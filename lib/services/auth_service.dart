import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

import '../models/user.dart';
import '../exceptions/auth_exception.dart';

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
  /// Throws a [AuthenticationException] if an exception occurs.
  Future<void> signUp({required String email, required String password}) async {
      try {
        await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, 
          password: password
        );
      } catch (err) {
        throw AuthenticationException(message: err.toString());
      }
  }

  /// Signs in user with provided [email] and [password].
  /// 
  /// Throws a [AuthenticationException] if an exception occurs.
  Future<void> login({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
    } catch (err) {
      throw AuthenticationException(message: err.toString());
    }
  } 

  Future<void> logout() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (err) {
      throw AuthenticationException(message: err.toString());
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
    } catch (err) {
       throw AuthenticationException(message: err.toString());
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