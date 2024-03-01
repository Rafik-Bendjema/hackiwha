import 'package:uuid/uuid.dart';

class Offer {
  Uuid uuid = const Uuid();
  late String id;
  DateTime date;
  String user_id;
  String description;
  bool isAvailable;

  Offer(
      {required this.date,
      required this.description,
      required this.user_id,
      this.isAvailable = true}) {
    id = uuid.v1();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'user_id': user_id,
      'description': description,
    };
  }
}
