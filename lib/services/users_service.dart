import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class UsersService {
  static final UsersService _instance = UsersService.internal();
  factory UsersService() => _instance;
  UsersService.internal();

  addUsers(BuildContext context) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    AuthService authService = AuthService();
    var uid = authService.currentUser()?.uid;
    await users
        .add(uid)
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add quote: $error"));
  }
}
