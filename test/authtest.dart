// import 'dart:io';
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';
// import 'package:clearpay/common/enums.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:clearpay/auth/usermodel.dart';
// import 'package:clearpay/state/authstate.dart';

// class MockSupabaseClient {
//   final MockSupabaseAuth auth = MockSupabaseAuth();
//   MockQueryBuilder from(String table) {
//     return MockQueryBuilder();
//   }
// }

// class MockSupabaseAuth {
//   MockUser? _currentUser;
//   User? get currentUser => _currentUser;

//   void setCurrentUser(MockUser? user) {
//     _currentUser = user;
//   }

//   Future<AuthResponse> signInWithPassword({
//     required String email,
//     required String password,
//   }) async {
//     if (email == 'test@example.com' && password == 'password123') {
//       _currentUser = MockUser('user-123', 'test@example.com');
//       return Future.value(MockAuthResponse(_currentUser!) as AuthResponse);
//     }
//     throw AuthException('Invalid login credentials');
//   }

//   Future<AuthResponse> signUp({
//     required String email,
//     required String password,
//   }) async {
//     _currentUser = MockUser('new-user-123', email);
//     return Future.value(MockAuthResponse(_currentUser!) as AuthResponse);
//   }

//   Future<void> signOut() async {
//     _currentUser = null;
//   }
// }

// class MockAuthResponse implements AuthResponse {
//   @override
//   Session? get session => null;
//   final User user;
//   MockAuthResponse(this.user);
//   @override
//   dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
// }

// class MockUser implements User {
//   final String _id;
//   final String _email;
//   DateTime? _emailConfirmedAt;
//   MockUser(this._id, this._email);

//   @override
//   String get id => _id;

//   @override
//   String? get email => _email;

//   @override
//   String? get emailConfirmedAt => _emailConfirmedAt?.toIso8601String();

//   void confirmEmail() {
//     _emailConfirmedAt = DateTime.now();
//   }

//   @override
//   dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
// }

// class MockGoogleSignIn {
//   bool isSignedIn = false;

//   Future<void> signOut() async {
//     isSignedIn = false;
//   }
// }

// class MockSharedPreferenceHelper {
//   UserModel? storedUserModel;

//   Future<void> clearPreferenceValues() async {
//     storedUserModel = null;
//   }

//   Future<void> saveUserProfile(UserModel userModel) async {
//     storedUserModel = userModel;
//   }
// }

// class MockQueryBuilder {
//   Future<void> upsert(Map<String, dynamic> data) async {}

//   MockQueryBuilder select() {
//     return this;
//   }

//   MockQueryBuilder eq(String field, dynamic value) {
//     return this;
//   }

//   Future<Map<String, dynamic>> single() async {
//     return {
//       'userId': 'user-123',
//       'name': 'Test User',
//       'email': 'test@example.com'
//     };
//   }

//   MockQueryBuilder stream({required List<String> primaryKey}) {
//     return this;
//   }

//   StreamSubscription<List<Map<String, dynamic>>> listen(
//       void Function(List<Map<String, dynamic>>) onData) {
//     Future.delayed(Duration(milliseconds: 10), () {
//       onData([
//         {
//           'userId': 'user-123',
//           'name': 'Test User',
//           'email': 'test@example.com'
//         },
//       ]);
//     });
//     return MockStreamSubscription();
//   }
// }

// class MockStreamSubscription
//     implements StreamSubscription<List<Map<String, dynamic>>> {
//   @override
//   Future<void> cancel() async {}
//   @override
//   dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
// }

// class MockBuildContext implements BuildContext {
//   @override
//   dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
// }

// class TestableAuthState extends AuthenticationState {
//   UserModel? _userModel;
//   final MockSupabaseClient mockSupabase = MockSupabaseClient();
//   final MockGoogleSignIn mockGoogleSignIn = MockGoogleSignIn();
//   final MockSharedPreferenceHelper mockPrefHelper =
//       MockSharedPreferenceHelper();

//   @override
//   SupabaseClient get supabase => mockSupabase as SupabaseClient;
//   UserModel? get testUserModel => _userModel;
//   set testUserModel(UserModel? value) => _userModel = value;

//   @override
//   Future<void> updateUserProfile(UserModel? userModel,
//       {File? image, File? bannerImage}) async {
//     try {
//       if (userModel != null) {
//         createUser(userModel);
//       } else if (_userModel != null) {
//         createUser(_userModel!);
//       }
//     } catch (error) {
//       if (kDebugMode) {
//         print('Update profile error: $error');
//       }
//     }
//   }

//   void onProfileChanged(Map<String, dynamic> data) {
//     final updatedUser = UserModel.fromJson(data);
//     _userModel = updatedUser;
//     mockPrefHelper.saveUserProfile(_userModel!);
//     notifyListeners();
//   }
// }

// void main() {
//   late TestableAuthState authState;

//   setUp(() {
//     authState = TestableAuthState();
//   });

//   group('Authentication State - Initial State', () {
//     test('Initial state should be NOT_DETERMINED', () {
//       expect(authState.authStatus, equals(AuthStatus.NOT_DETERMINED));
//       expect(authState.user, isNull);
//       expect(authState.userModel, isNull);
//     });
//   });

//   group('Authentication State - Sign In Process', () {
//     test('Sign in with valid credentials returns userId', () async {
//       final result = await authState.signIn(
//         'test@example.com',
//         'password123',
//         context: MockBuildContext(),
//       );

//       expect(result, 'user-123');
//       expect(authState.user?.id, 'user-123');
//       expect(authState.userId, 'user-123');
//       expect(authState.isBusy, isFalse);
//     });

//     test('Sign in with invalid credentials returns null', () async {
//       final result = await authState.signIn(
//         'test@example.com',
//         'wrong-password',
//         context: MockBuildContext(),
//       );

//       expect(result, isNull);
//       expect(authState.isBusy, isFalse);
//     });
//   });

//   group('Authentication State - Sign Up Process', () {
//     test('Sign up with valid data returns userId and creates user', () async {
//       final userModel = UserModel(
//         email: 'new@example.com',
//         displayName: 'New User',
//       );

//       final result = await authState.signUp(
//         userModel,
//         context: MockBuildContext(),
//         password: 'newpassword',
//       );

//       expect(result, 'new-user-123');
//       expect(authState.authStatus, equals(AuthStatus.LOGGED_IN));
//       expect(authState.testUserModel, isNotNull);
//       expect(authState.testUserModel?.userId, 'new-user-123');
//     });
//   });

//   group('Authentication State - User Management', () {
//     test('getCurrentUser sets LOGGED_IN status when user exists', () async {
//       // Set up a mock current user
//       authState.mockSupabase.auth
//           .setCurrentUser(MockUser('existing-123', 'existing@example.com'));

//       final user = await authState.getCurrentUser();

//       expect(user, isNotNull);
//       expect(authState.authStatus, equals(AuthStatus.LOGGED_IN));
//       expect(authState.userId, 'existing-123');
//     });

//     test('getCurrentUser sets NOT_LOGGED_IN status when no user exists',
//         () async {
//       final user = await authState.getCurrentUser();

//       expect(user, isNull);
//       expect(authState.authStatus, equals(AuthStatus.NOT_LOGGED_IN));
//     });

//     test('logoutCallback clears user data and signs out', () async {
//       // Set up initial state as logged in
//       authState.mockSupabase.auth
//           .setCurrentUser(MockUser('user-123', 'test@example.com'));
//       await authState.getCurrentUser();

//       // Verify logged in state
//       expect(authState.authStatus, equals(AuthStatus.LOGGED_IN));

//       // Perform logout
//       authState.logoutCallback();

//       // Verify logged out state
//       expect(authState.authStatus, equals(AuthStatus.NOT_LOGGED_IN));
//       expect(authState.userId, isEmpty);
//       expect(authState.user, isNull);
//       expect(authState.testUserModel, isNull);
//     });
//   });

//   group('Authentication State - Email Verification', () {
//     test('emailVerified returns true when email is confirmed', () async {
//       // Set up user with confirmed email
//       final mockUser = MockUser('verified-123', 'verified@example.com');
//       mockUser.confirmEmail();
//       authState.mockSupabase.auth.setCurrentUser(mockUser);

//       final isVerified = await authState.emailVerified();

//       expect(isVerified, isTrue);
//     });

//     test('emailVerified returns false when email is not confirmed', () async {
//       // Set up user with unconfirmed email
//       final mockUser = MockUser('unverified-123', 'unverified@example.com');
//       authState.mockSupabase.auth.setCurrentUser(mockUser);

//       final isVerified = await authState.emailVerified();

//       expect(isVerified, isFalse);
//     });
//   });

//   group('Authentication State - Database Operations', () {
//     test('databaseInit sets up profile stream when user exists', () async {
//       // Set up user
//       authState.mockSupabase.auth
//           .setCurrentUser(MockUser('stream-123', 'stream@example.com'));
//       authState.user = authState.mockSupabase.auth.currentUser;

//       // Initialize database stream
//       authState.databaseInit();

//       // Wait for async operations
//       await Future.delayed(Duration(milliseconds: 20));

//       // Verify user model updated from stream
//       expect(authState.testUserModel, isNotNull);
//       expect(authState.testUserModel?.displayName, 'Test User');
//     });

//     test('openSignUpPage resets auth state', () {
//       // Set up logged in state
//       authState.authStatus = AuthStatus.LOGGED_IN;
//       authState.userId = 'active-user';

//       // Call method under test
//       authState.openSignUpPage();

//       // Verify state reset
//       expect(authState.authStatus, equals(AuthStatus.NOT_LOGGED_IN));
//       expect(authState.userId, isEmpty);
//     });
//   });
// }
