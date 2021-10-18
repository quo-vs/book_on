import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

import '../models/user.dart';

/// Thrown if during the sign up process if a failure occurs.
class SignUpFailure implements Exception {}

/// Thrown during the login process if a faliure occurs.
class LoginWithEmailAndPasswordFailure implements Exception {}

class LogInWithGoogleFailure implements Exception {}

/// Thrown during logout process if faliure
class LogOutFailure implements Exception {}

class AuthService {

  AuthService({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) {
    _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;
    _googleSignIn = googleSignIn ?? GoogleSignIn.standard();
  }

  late firebase_auth.FirebaseAuth _firebaseAuth;
  late GoogleSignIn _googleSignIn;

  @visibleForTesting
  bool isWeb = kIsWeb;

  bool isSignedIn() {
    return _firebaseAuth.currentUser != null;
  }

  firebase_auth.User? currentUser() {
    return _firebaseAuth.currentUser;
  }

  ///Stream of [User] which will emit the current user when
  /// the authentication state hanges
  /// 
  /// Emits [User.empty] if user is not authenticated
  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null 
        ? User.empty 
        : firebaseUser.toUser;
      return user;
    });
  }

  /// Creates a new user with provided [email] and [password]
  /// 
  /// Throws a [SignUpFailure] if an exception occurs.
  Future<void> signUp({required String email, required String password}) async {
      try {
        await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, 
          password: password
        );
      } on Exception {
        throw SignUpFailure();
      }
  }

  /// Signs in user with provided [email] and [password].
  /// 
  /// Throws a [LoginWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> login({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
    } on Exception {
      throw SignUpFailure();
    }
  } 

  Future<void> logout() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } on Exception {
      throw LogOutFailure();
    }
  }

  /// Explore app as a guest user
  Future<void> guest() async {
    final user = await _firebaseAuth.signInAnonymously();
  }

    Future<void> logInWithGoogle() async {
    try {
      late final firebase_auth.AuthCredential credential;
      if (isWeb) {
        final googleProvider = firebase_auth.GoogleAuthProvider();
        final userCredential = await _firebaseAuth.signInWithPopup(
          googleProvider,
        );
        credential = userCredential.credential!;
      } else {
        final googleUser = await _googleSignIn.signIn();
        final googleAuth = await googleUser!.authentication;
        credential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      }

      await _firebaseAuth.signInWithCredential(credential);
    } catch (_) {
      throw LogInWithGoogleFailure();
    }
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final firebase_auth.AuthCredential credential = firebase_auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(id: uid, email: email, name: displayName);
  }
}