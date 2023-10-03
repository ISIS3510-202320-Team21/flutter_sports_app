import 'package:sportsapp/data/models/photo.dart';
import 'package:sportsapp/data/models/match.dart';
import 'package:sportsapp/data/models/notification.dart' as MyAppNotification;

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
  final List<MyAppNotification.Notification> notifications;

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
      matches: List<Match>.from(json['matches'].map((x) => Match.fromJson(x))),
      notifications: List<MyAppNotification.Notification>.from(
          json['notifications']
              .map((x) => MyAppNotification.Notification.fromJson(x))),
    );
  }
}
