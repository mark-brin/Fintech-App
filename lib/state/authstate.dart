import 'dart:io';
import 'dart:async';
import 'appState.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:clearpay/common/enums.dart';
import 'package:clearpay/common/locator.dart';
import 'package:clearpay/auth/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clearpay/common/sharedPreferences.dart';

class AuthState extends AppState {
  User? user;
  late String userId;
  Query? _profileQuery;
  UserModel? _userModel;
  bool isSignInWithGoogle = false;
  UserModel? get userModel => _userModel;
  List<UserModel>? _profileUserModelList;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  UserModel get profileUserModel {
    if (_profileUserModelList != null && _profileUserModelList!.isNotEmpty) {
      return _profileUserModelList!.last;
    } else {
      return UserModel();
    }
  }

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection(USERS);

  Stream<DocumentSnapshot> callStream({String? uid}) =>
      userCollection.doc(uid).snapshots();

  void removeLastUser() {
    _profileUserModelList!.removeLast();
  }

  void logoutCallback() async {
    authStatus = AuthStatus.NOT_LOGGED_IN;
    userId = '';
    _userModel = null;
    user = null;
    _profileQuery = null;
    if (isSignInWithGoogle) {
      _googleSignIn.signOut();
      isSignInWithGoogle = false;
    }
    firebaseAuth.signOut();
    notifyListeners();
    await getIt<SharedPreferenceHelper>().clearPreferenceValues();
  }

  void openSignUpPage() {
    authStatus = AuthStatus.NOT_LOGGED_IN;
    userId = '';
    notifyListeners();
  }

  databaseInit() {
    try {
      if (_profileQuery == null) {
        firestore
            .collection(USERS)
            .doc(user!.uid)
            .snapshots()
            .listen(onProfileChanged);
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<String?> signIn(
      BuildContext context, String email, String password) async {
    try {
      isBusy = true;
      var result = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = result.user;
      userId = user!.uid;
      return user!.uid;
    } catch (error) {
      isBusy = false;
      logoutCallback();
      return null;
    }
  }

  Future<String?> signUp(UserModel userModel,
      {required BuildContext context, required String password}) async {
    try {
      isBusy = true;
      var result = await firebaseAuth.createUserWithEmailAndPassword(
        email: userModel.email!,
        password: password,
      );
      user = result.user;
      authStatus = AuthStatus.LOGGED_IN;
      result.user!.updateDisplayName(userModel.displayName);
      result.user!.updatePhotoURL(userModel.profilePic);
      _userModel = userModel;
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
    firestore.collection(USERS).doc(user.userId).set(user.toJson());
    _userModel = user;
    isBusy = false;
  }

  Future<User?> getCurrentUser() async {
    try {
      isBusy = true;
      user = firebaseAuth.currentUser;
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
    user = firebaseAuth.currentUser;
    if (user!.emailVerified) {
      //userModel!.isVerified = true;
      createUser(userModel!);
    }
  }

  Future<void> sendEmailVerification(BuildContext context) async {
    User user = firebaseAuth.currentUser!;
    user.sendEmailVerification().then((_) {}).catchError((error) {});
  }

  Future<bool> emailVerified() async {
    User user = firebaseAuth.currentUser!;
    return user.emailVerified;
  }

  Future<void> forgetPassword(String email,
      {required BuildContext context}) async {
    try {
      await firebaseAuth
          .sendPasswordResetEmail(email: email)
          .then((value) {})
          .catchError((error) {});
    } catch (error) {
      // ignore: void_checks
      return Future.value(false);
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
          firebaseAuth.currentUser!.updateDisplayName(name);
          firebaseAuth.currentUser!.updatePhotoURL(userModel.profilePic);
        }
        if (userModel != null) {
          createUser(userModel);
        } else {
          createUser(_userModel!);
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<UserModel?> getUserDetail(String userId) async {
    UserModel? user;
    var event = await firestore.collection(USERS).doc(userId).get();
    final map = event.data();
    if (map != null) {
      user = UserModel.fromJson(map);
      //user.key = event.id;
      return user;
    } else {
      return null;
    }
  }

  getProfileUser({String? userProfileId}) async {
    try {
      isBusy = true;
      _profileUserModelList ??= [];
      userProfileId = userProfileId ?? user!.uid;
      DocumentSnapshot documentSnapshot =
          await userCollection.doc(userProfileId).get();
      var map = documentSnapshot.data() as Map<dynamic, dynamic>;
      if (documentSnapshot.data() != null) {
        _profileUserModelList!.add(UserModel.fromJson(map));
        if (userProfileId == user!.uid) {
          _userModel = _profileUserModelList!.last;
          //_userModel!.isVerified = user!.emailVerified;
          if (user!.emailVerified) {
            reloadUser();
          }
        }
      }
      isBusy = false;
    } catch (error) {
      isBusy = false;
    }
  }

  void onProfileChanged(DocumentSnapshot event) {
    var map = event.data() as Map<dynamic, dynamic>;
    if (event.data() != null) {
      final updatedUser = UserModel.fromJson(map);
      if (updatedUser.userId == user!.uid) {
        _userModel = updatedUser;
      }
      notifyListeners();
    }
  }
}
