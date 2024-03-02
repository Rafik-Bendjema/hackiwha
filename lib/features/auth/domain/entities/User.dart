import 'package:uuid/uuid.dart';

class UserProfile {
  final uuid = const Uuid();
  late String id;
  String full_name;
  String? profile_pic;
  String email;
  String? phone_number;
  String pwd;

  UserProfile({
    required this.full_name,
    required this.phone_number,
    required this.profile_pic,
    required this.email,
    required this.pwd,
  }) {
    id = uuid.v1();
  }

  UserProfile.withoutPhoneNumber({
    required this.full_name,
    required this.profile_pic,
    required this.email,
    required this.pwd,
  }) {
    id = uuid.v1();
  }

  UserProfile.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        full_name = json['full_name'],
        profile_pic = json['profile_pic'],
        email = json['email'],
        phone_number = json['phone_number'],
        pwd = json['pwd'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': full_name,
      'email': email,
      'pwd': pwd,
      'profile_pic': profile_pic,
      'phone_number': phone_number,
    };
  }
}
