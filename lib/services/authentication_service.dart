import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../models/user.dart';
import '../services/users_service.dart';
import '../utils/constants.dart';

class AuthenticationService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<dynamic> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      auth.UserCredential result = await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await firestore
          .collection(AppConst.USERS)
          .doc(result.user?.uid ?? '')
          .get();
      User? user;
      if (documentSnapshot.exists) {
        user = User.fromJson(documentSnapshot.data() ?? {});
      } else if (result.user != null) {      
        user = User(email: '', firstName: 'Anonym', userID: result.user!.uid);
      }
      return user;
    } on auth.FirebaseAuthException catch (exception, s) {
      debugPrint(exception.toString() + '$s');
      switch ((exception).code) {
        case 'invalid-email':
          return 'Email address is malformed.';
        case 'wrong-password':
          return 'Wrong password.';
        case 'user-not-found':
          return 'No user corresponding to the given email address.';
        case 'user-disabled':
          return 'This user has been disabled.';
        case 'too-many-requests':
          return 'Too many attempts ot sign in as this user';
      }
      return 'Unexpected server error. Please try again.';
    } catch (e, s) {
      debugPrint(e.toString() + '$s');
      return 'Login failed. Please try again';
    }
  }

  static signUpWithEmailAndPassword(
      {required String email, required String password, name = 'Guest'}) async {
    try {
      auth.UserCredential result = await auth.FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User user =
          User(email: email, firstName: name, userID: result.user?.uid ?? '');
      String? errorMessage = await UsersService.createNewUser(user);
      if (errorMessage == null) {
        return user;
      } else {
        return 'Server sign up issue. Please try again later.';
      }
    } on auth.FirebaseAuthException catch (error) {
      debugPrint(error.toString() + '${error.stackTrace}');
      String message = tr('couldNotSignUp');
      switch (error.code) {
        case 'email-already-in-use':
          message = 'Email already in use. Please use another email!';
          break;
        case 'invalid-email':
          message = 'Enter valid e-mail';
          break;
        case 'operation-not-allowed':
          message = 'Email/password accounts are not enabled';
          break;
        case 'weak-password':
          message = 'Password must be more than 5 characters';
          break;
        case 'too-many-requests':
          message = 'Too many requests, Please try again later.';
          break;
      }
      return message;
    } catch (e) {
      return tr('couldNotSignUp');
    }
  }

  static logout() async {
    await auth.FirebaseAuth.instance.signOut();
  }

  static Future<User?> getAuthUser() async {
    auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      User? user = await UsersService.getCurrentUser(firebaseUser.uid);
      return user;
    } else {
      return null;
    }
  }

  static resetPassword(String email) async {
    await auth.FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  // Explore app as a guest user
  static signInAsGuest() async {
    auth.UserCredential result = await auth.FirebaseAuth.instance.signInAnonymously();
    User user =
          User(email: '', firstName: 'Anonym', userID: result.user?.uid ?? '');
    return user;
  }

  static bool isSignedIn() {
    return auth.FirebaseAuth.instance.currentUser != null;
  }
}
