import 'package:flutter_app_sports/data/models/level.dart';
import 'package:flutter_app_sports/data/models/sport.dart';
import 'package:flutter_app_sports/data/models/user.dart';
import 'package:flutter_app_sports/data/repositories/match_repository.dart';
import 'package:flutter_app_sports/data/repositories/sport_repository.dart';
import 'package:flutter_app_sports/data/repositories/user_repository.dart';
import 'package:intl/intl.dart';

class Match {
  final DateTime? date;
  final User? userCreated;
  final User? userJoined;
  final String time;
  final double? rate1;
  final double? rate2;
  final String status;
  final String city;
  final String court;
  final Sport? sport;
  final Level? level;
  int? id;
  Match(
      {required this.date,
      required this.time,
      this.rate1,
      this.rate2,
      required this.status,
      required this.city,
      required this.court,
      this.sport,
      this.level,
      required this.userCreated,
      this.userJoined,
      this.id});

  static Future<Match> createFromJson(
      Map<String, dynamic> json, UserRepository userRepository) async {
    MatchRepository(userRepository: userRepository);

    User userCreated = User.fromJson(json['user_created']);

    Sport sport = Sport.fromJson(json['sport']);
    Level level = Level.fromJson(json['level']);

    return Match(
      date: DateFormat("dd/MM/yyyy").parse(json['date']),
      time: json['time'],
      rate1: json['rate1'] != null ? double.parse(json['rate1']) : null,
      rate2: json['rate2'] != null ? double.parse(json['rate2']) : null,
      status: json['status'],
      city: json['city'],
      court: json['court'],
      id: json['id'],
      sport: sport,
      level: level,
      userCreated: userCreated!,
      userJoined: json['user_joined'] != null
          ? User.fromJson(json['user_joined'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': DateFormat("dd/MM/yyyy").format(date!),
        'time': time,
        'status': status,
        'court': court,
        'city': city,
        'sport_id': sport?.id,
        'level_id': level?.id,
      };
}
