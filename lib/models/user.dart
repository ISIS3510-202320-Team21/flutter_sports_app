import 'package:sportsapp/models/notification.dart';
import 'package:sportsapp/models/photo.dart';
import 'package:sportsapp/models/match.dart';

class User {
  final String email;
  final String password;
  final String name;
  final String phoneNumber;
  final String role;
  final DateTime bornDate;
  final String gender;
  final Photo photo;
  final List<Match> matches;
  final List<Notification> notifications;

  User({
    required this.email,
    required this.password,
    required this.name,
    required this.phoneNumber,
    required this.role,
    required this.bornDate,
    required this.gender,
    required this.photo,
    required this.matches,
    required this.notifications,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password: json['password'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
      bornDate: DateTime.parse(json['bornDate']),
      gender: json['gender'],
      photo: Photo.fromJson(json['photo']),
      matches: (json['matches'] as List).map((e) => Match.fromJson(e)).toList(),
      notifications: (json['notifications'] as List)
          .map((e) => Notification.fromJson(e))
          .toList(),
    );
  }
}
