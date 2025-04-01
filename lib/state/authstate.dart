import 'dart:io';
import 'dart:async';
import 'appState.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fintech_app/common/enums.dart';
import 'package:fintech_app/common/locator.dart';
import 'package:fintech_app/auth/usermodel.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fintech_app/common/sharedPreferences.dart';

class AuthenticationState extends AppState {
  User? user;
  late String userId;
  UserModel? _userModel;
  bool isSignInWithGoogle = false;
  UserModel? get userModel => _userModel;
  StreamSubscription? _profileSubscription;
  final supabase = Supabase.instance.client;
  UserModel? get profileUserModel => _userModel;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;

  void logoutCallback() async {
    authStatus = AuthStatus.NOT_LOGGED_IN;
    userId = '';
    _userModel = null;
    user = null;
    if (_profileSubscription != null) {
      await _profileSubscription!.cancel();
      _profileSubscription = null;
    }
    if (isSignInWithGoogle) {
      _googleSignIn.signOut();
      isSignInWithGoogle = false;
    }
    await supabase.auth.signOut();
    notifyListeners();
    await getIt<SharedPreferenceHelper>().clearPreferenceValues();
  }

  void openSignUpPage() {
    authStatus = AuthStatus.NOT_LOGGED_IN;
    userId = '';
    notifyListeners();
  }

  void databaseInit() {
    try {
      if (_profileSubscription == null && user != null) {
        _profileSubscription = supabase
            .from('profile')
            .stream(primaryKey: ['userId'])
            .eq('userId', user!.id)
            .listen((data) {
              if (data.isNotEmpty) {
                _onProfileChanged(data[0]);
              }
            });
      }
    } catch (error) {
      if (kDebugMode) {
        print('Database init error: $error');
      }
    }
  }

  Future<String?> signIn(String email, String password,
      {required BuildContext context}) async {
    try {
      isBusy = true;
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      user = response.user;
      userId = user!.id;
      return user!.id;
    } on AuthException catch (error) {
      if (kDebugMode) {
        print('Sign in error: ${error.message}');
      }
      return null;
    } catch (error) {
      if (kDebugMode) {
        print('Unexpected error: $error');
      }
      return null;
    } finally {
      isBusy = false;
    }
  }

  Future<String?> signUp(UserModel userModel,
      {required BuildContext context, required String password}) async {
    try {
      isBusy = true;
      final response = await supabase.auth.signUp(
        email: userModel.email!,
        password: password,
      );

      user = response.user;
      authStatus = AuthStatus.LOGGED_IN;

      _userModel = userModel;
      _userModel!.key = user!.id;
      _userModel!.userId = user!.id;
      createUser(_userModel!, newUser: true);
      return user!.id;
    } catch (error) {
      if (kDebugMode) {
        print('Sign up error: $error');
      }
      isBusy = false;
      return null;
    }
  }

  void createUser(UserModel user, {bool newUser = false}) {
    if (newUser) {
      user.createdAt = DateTime.now().toUtc().toString();
    }

    supabase.from('profile').upsert(user.toJson()).then((_) {
      _userModel = user;
      isBusy = false;
    }).catchError((error) {
      if (kDebugMode) {
        print('Create user error: $error');
      }
      isBusy = false;
    });
  }

  Future<User?> getCurrentUser() async {
    try {
      isBusy = true;
      user = supabase.auth.currentUser;

      if (user != null) {
        await getProfileUser();
        authStatus = AuthStatus.LOGGED_IN;
        userId = user!.id;
      } else {
        authStatus = AuthStatus.NOT_LOGGED_IN;
      }
      isBusy = false;
      return user;
    } catch (error) {
      if (kDebugMode) {
        print('Get current user error: $error');
      }
      isBusy = false;
      authStatus = AuthStatus.NOT_LOGGED_IN;
      return null;
    }
  }

  void reloadUser() async {
    await supabase.auth.refreshSession();
    user = supabase.auth.currentUser;

    if (user != null && user!.emailConfirmedAt != null) {
      userModel!.isVerified = true;
      createUser(userModel!);
    }
  }

  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      if (kDebugMode) {
        print('Email verification is handled automatically by Supabase');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error sending verification: $error');
      }
    }
  }

  Future<bool> emailVerified() async {
    await supabase.auth.refreshSession();
    user = supabase.auth.currentUser;
    return user?.emailConfirmedAt != null;
  }

  Future<void> forgetPassword(String email,
      {required BuildContext context}) async {
    try {
      await supabase.auth
          .resetPasswordForEmail(
            email,
            redirectTo: 'io.supabase.flutter://reset-callback/',
          )
          .then(
            (value) {},
          )
          .catchError(
        (error) {
          if (kDebugMode) {
            print('Password reset error: $error');
          }
        },
      );
    } catch (error) {
      if (kDebugMode) {
        print('Password reset error: $error');
      }
      return Future.value();
    }
  }

  Future<void> updateUserProfile(UserModel? userModel,
      {File? image, File? bannerImage}) async {
    try {
      if (image == null && bannerImage == null) {
        createUser(userModel!);
      } else {
        if (userModel != null) {
          createUser(userModel);
        } else {
          createUser(_userModel!);
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Update profile error: $error');
      }
    }
  }

  Future<UserModel?> getUserDetail(String userId) async {
    try {
      final data =
          await supabase.from('profile').select().eq('userId', userId).single();

      UserModel user = UserModel.fromJson(data);
      user.key = userId;
      return user;
    } catch (error) {
      if (kDebugMode) {
        print('Get user detail error: $error');
      }
      return null;
    }
  }

  FutureOr<void> getProfileUser({String? userProfileId}) {
    try {
      userProfileId = userProfileId ?? user!.id;
      supabase
          .from('profile')
          .select()
          .eq('userId', userProfileId)
          .single()
          .then((data) {
        if (userProfileId == user!.id) {
          _userModel = UserModel.fromJson(data);
          _userModel!.isVerified = user!.emailConfirmedAt != null;
          if (user!.emailConfirmedAt == null) {
            // reloadUser();
          }
          // getIt<SharedPreferenceHelper>().saveUserProfile(_userModel!);
        }
        isBusy = false;
      }).catchError((error) {
        if (kDebugMode) {
          print('Get profile user error: $error');
        }
        isBusy = false;
      });
    } catch (error) {
      if (kDebugMode) {
        print('Get profile user error: $error');
      }
      isBusy = false;
    }
  }

  void _onProfileChanged(Map<String, dynamic> data) {
    final updatedUser = UserModel.fromJson(data);
    _userModel = updatedUser;
    getIt<SharedPreferenceHelper>().saveUserProfile(_userModel!);
    notifyListeners();
  }

  void onProfileUpdated(dynamic data) {}
}
