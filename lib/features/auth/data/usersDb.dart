import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackiwha/features/auth/domain/entities/User.dart';

abstract class UsersDb {
  Future<bool> addUser(User user);
}

class UserDb_impl implements UsersDb {
  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Future<bool> addUser(User user) async {
    try {
      await db.collection("users").doc().set(user.toMap());

      return true;
    } on Exception catch (e) {
      return false;
    }
  }
}
