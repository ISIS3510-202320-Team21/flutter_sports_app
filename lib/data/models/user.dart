import 'package:flutter_app_sports/data/models/notification.dart' as notif;
import 'package:intl/intl.dart';

class User {
  final int id;
  final String email;
  final String? university;
  final String name;
  final String? phoneNumber;
  final String? role;
  final DateTime? bornDate;
  final String? gender;
  final String? imageUrl;
  final String? latitude;
  final String? longitude;
  final List<notif.Notification>? notifications;

  User(
      {required this.id,
      required this.email,
      this.university,
      required this.name,
      this.phoneNumber,
      this.role,
      this.bornDate,
      this.gender,
      this.imageUrl,
      this.latitude,
      this.longitude,
      this.notifications});

  factory User.fromJson(Map<String, dynamic> json) {
    final dateParts = json['bornDate'].split('/');
    final day = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final year = int.parse(dateParts[2]);
    final parsedDate = DateTime(year, month, day);

    return User(
      id: json['id'],
      university: json['university'],
      email: json['email'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
      bornDate: parsedDate,
      gender: json['gender'],
      imageUrl: json["imageUrl"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      notifications: json["notifications"] != null
          ? (json["notifications"] as List)
              .map((i) => notif.Notification.fromJson(i))
              .toList()
          : null,
    );
  }



Map<String, dynamic> toJson() {
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  String formattedDate = bornDate != null ? dateFormat.format(bornDate!) : '';

  return {
    'email': email,
    'id': id,
    'university': university,
    'name': name,
    'phoneNumber': phoneNumber,
    'role': role,
    'bornDate': formattedDate,
    'gender': gender,
    'imageUrl': imageUrl,
    'notifications': notifications?.map((notification) => notification.toJson()).toList(),
  };
}

}
