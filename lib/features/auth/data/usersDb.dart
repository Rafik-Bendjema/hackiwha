import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hackiwha/features/auth/domain/entities/User.dart';

abstract class UsersDb {
  Future<bool> addUser(UserProfile user);
}

class UserDb_impl implements UsersDb {
  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Future<bool> addUser(UserProfile user) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email,
        password: user.pwd,
      );

      await db.collection("users").doc().set(user.toMap());

      return true;
    } on Exception catch (e) {
      return false;
    }
  }
}
