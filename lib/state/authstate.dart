import 'dart:io';
import 'dart:async';
import 'appState.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fintech_app/common/enums.dart';
import 'package:fintech_app/auth/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart' as db;

class AuthState extends AppState {
  User? user;
  late String userId;
  UserModel? _userModel;
  db.Query? _profileQuery;
  bool isSignInWithGoogle = false;
  UserModel? get userModel => _userModel;
  UserModel? get profileUserModel => _userModel;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  final userDatabase = FirebaseDatabase.instance.ref();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void logoutCallback() async {
    authStatus = AuthStatus.NOT_LOGGED_IN;
    userId = '';
    _userModel = null;
    user = null;
    _profileQuery!.onValue.drain();
    _profileQuery = null;
    if (isSignInWithGoogle) {
      _googleSignIn.signOut();
      isSignInWithGoogle = false;
    }
    _firebaseAuth.signOut();
    notifyListeners();
    // await getIt<SharedPreferenceHelper>().clearPreferenceValues();
  }

  void openSignUpPage() {
    authStatus = AuthStatus.NOT_LOGGED_IN;
    userId = '';
    notifyListeners();
  }

  void databaseInit() {
    try {
      if (_profileQuery == null) {
        _profileQuery = userDatabase.child("profile").child(user!.uid);
        _profileQuery!.onValue.listen(onProfileChanged);
        _profileQuery!.onChildChanged.listen(onProfileUpdated);
      }
    } catch (error) {}
  }

  void onProfileUpdated(DatabaseEvent event) {}

  Future<String?> signIn(String email, String password,
      {required BuildContext context}) async {
    try {
      isBusy = true;
      var result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = result.user;
      userId = user!.uid;
      return user!.uid;
    } on FirebaseException catch (error) {
      if (error.code == 'firebase_auth/user-not-found') {
      } else {}
      return null;
    } catch (error) {
      return null;
    } finally {
      isBusy = false;
    }
  }

  Future<User?> handleGoogleSignIn() async {
    try {
      // userAnalytics.logLogin(loginMethod: 'google_login');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google login cancelled by user');
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      user = (await _firebaseAuth.signInWithCredential(credential)).user;
      authStatus = AuthStatus.LOGGED_IN;
      userId = user!.uid;
      isSignInWithGoogle = true;
      createUserFromGoogleSignIn(user!);
      notifyListeners();
      return user;
    } on PlatformException {
      user = null;
      authStatus = AuthStatus.NOT_LOGGED_IN;
      return null;
    } on Exception {
      user = null;
      authStatus = AuthStatus.NOT_LOGGED_IN;
      return null;
    } catch (error) {
      user = null;
      authStatus = AuthStatus.NOT_LOGGED_IN;
      return null;
    }
  }

  void createUserFromGoogleSignIn(User user) {
    var diff = DateTime.now().difference(user.metadata.creationTime!);
    if (diff < const Duration(seconds: 15)) {
      UserModel model = UserModel(
        key: user.uid,
        userId: user.uid,
        email: user.email!,
        profilePic: user.photoURL!,
        displayName: user.displayName!,
        bio: 'Edit profile to update bio',
        dob: DateTime(1950, DateTime.now().month, DateTime.now().day + 3)
            .toString(),
      );
      createUser(model, newUser: true);
    } else {}
  }

  Future<String?> signUp(UserModel userModel,
      {required BuildContext context, required String password}) async {
    try {
      isBusy = true;
      var result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: userModel.email!,
        password: password,
      );
      user = result.user;
      authStatus = AuthStatus.LOGGED_IN;
      result.user!.updateDisplayName(userModel.displayName);
      result.user!.updatePhotoURL(userModel.profilePic);
      _userModel = userModel;
      _userModel!.key = user!.uid;
      _userModel!.userId = user!.uid;
      createUser(_userModel!, newUser: true);
      return user!.uid;
    } catch (error) {
      isBusy = false;
      return null;
    }
  }

  void createUser(UserModel user, {bool newUser = false}) {
    if (newUser) {
      user.createdAt = DateTime.now().toUtc().toString();
    }
    userDatabase.child('profile').child(user.userId!).set(user.toJson());
    _userModel = user;
    isBusy = false;
  }

  Future<User?> getCurrentUser() async {
    try {
      isBusy = true;
      user = _firebaseAuth.currentUser;
      if (user != null) {
        await getProfileUser();
        authStatus = AuthStatus.LOGGED_IN;
        userId = user!.uid;
      } else {
        authStatus = AuthStatus.NOT_LOGGED_IN;
      }
      isBusy = false;
      return user;
    } catch (error) {
      isBusy = false;
      authStatus = AuthStatus.NOT_LOGGED_IN;
      return null;
    }
  }

  void reloadUser() async {
    await user!.reload();
    user = _firebaseAuth.currentUser;
    if (user!.emailVerified) {
      createUser(userModel!);
    }
  }

  Future<void> sendEmailVerification(BuildContext context) async {
    User user = _firebaseAuth.currentUser!;
    user.sendEmailVerification().then((_) {}).catchError((error) {});
  }

  Future<bool> emailVerified() async {
    User user = _firebaseAuth.currentUser!;
    return user.emailVerified;
  }

  Future<void> forgetPassword(String email,
      {required BuildContext context}) async {
    try {
      await _firebaseAuth
          .sendPasswordResetEmail(email: email)
          .then((value) {})
          .catchError((error) {});
    } catch (error) {
      return Future.value();
    }
  }

  Future<void> updateUserProfile(UserModel? userModel,
      {File? image, File? bannerImage}) async {
    try {
      if (image == null && bannerImage == null) {
        createUser(userModel!);
      } else {
        if (image != null) {
          var name = userModel!.displayName ?? user!.displayName;
          _firebaseAuth.currentUser!.updateDisplayName(name);
          _firebaseAuth.currentUser!.updatePhotoURL(userModel.profilePic);
        }
        if (bannerImage != null) {
          // Utility.logEvent('user_banner_image');
        }

        if (userModel != null) {
          createUser(userModel);
        } else {
          createUser(_userModel!);
        }
      }
    } catch (error) {}
  }

  Future<UserModel?> getUserDetail(String userId) async {
    UserModel user;
    var event = await userDatabase.child('profile').child(userId).once();

    final map = event.snapshot.value as Map?;
    if (map != null) {
      user = UserModel.fromJson(map);
      user.key = event.snapshot.key!;
      return user;
    } else {
      return null;
    }
  }

  FutureOr<void> getProfileUser({String? userProfileId}) {
    try {
      userProfileId = userProfileId ?? user!.uid;
      userDatabase.child("profile").child(userProfileId).once().then(
        (DatabaseEvent event) async {
          final snapshot = event.snapshot;
          if (snapshot.value != null) {
            var map = snapshot.value as Map<dynamic, dynamic>?;
            if (map != null) {
              if (userProfileId == user!.uid) {
                _userModel = UserModel.fromJson(map);
                if (!user!.emailVerified) {}
                // getIt<SharedPreferenceHelper>().saveUserProfile(_userModel!);
              }
            }
          }
          isBusy = false;
        },
      );
    } catch (error) {
      isBusy = false;
    }
  }

  void onProfileChanged(DatabaseEvent event) {
    final val = event.snapshot.value;
    if (val is Map) {
      final updatedUser = UserModel.fromJson(val);
      _userModel = updatedUser;
      // getIt<SharedPreferenceHelper>().saveUserProfile(_userModel!);
      notifyListeners();
    }
  }
}
