import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';
import '../utils/constants.dart';

class UsersService {
  static final UsersService _instance = UsersService.internal();
  factory UsersService() => _instance;
  UsersService.internal();

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// save a new user document in the USERS table in firebase firestore
  /// returns an error message on failure or null on success
  static Future<String?> createNewUser(User user) async => await firestore
      .collection(AppConst.USERS)
      .doc(user.userID)
      .set(user.toJson())
      .then((value) => null, onError: (e) => e);

  static Future<User?> getCurrentUser(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> userDocument =
        await firestore.collection(AppConst.USERS).doc(uid).get();
    if (userDocument.data() != null && userDocument.exists) {
      return User.fromJson(userDocument.data()!);
    } else {
      return null;
    }
  }

  static Future<User> updateCurrentUser(User user) async {
    return await firestore
        .collection(AppConst.USERS)
        .doc(user.userID)
        .set(user.toJson())
        .then((document) {
      return user;
    });
  }
}
