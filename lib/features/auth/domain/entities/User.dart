import 'package:uuid/uuid.dart';

class User {
  final uuid = const Uuid();
  late String id;
  String full_name;
  String profile_pic;
  String email;
  String type;
  String phone_number;
  String pwd;

  User(
      {required this.full_name,
      required this.phone_number,
      required this.profile_pic,
      required this.type,
      required this.email,
      required this.pwd}) {
    id = uuid.v1();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': full_name,
      'email': email,
      'pwd': pwd,
      'profile_pic': profile_pic,
      'type': type,
      'phone_number': phone_number,
    };
  }
}
