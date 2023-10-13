import 'package:flutter_app_sports/data/models/level.dart';
import 'package:flutter_app_sports/data/models/sport.dart';
import 'package:flutter_app_sports/data/models/user.dart';
import 'package:flutter_app_sports/data/repositories/match_repository.dart';
import 'package:flutter_app_sports/data/repositories/user_repository.dart';
import 'package:intl/intl.dart';

class Match {
  final DateTime date;
  final User userCreated;
  final User? userJoined;
  final String time;
  final String? rate;
  final String status;
  final String court;
  final Sport sport;
  final Level level;
  final int id;
  Match({
    required this.date,
    required this.time,
    required this.rate,
    required this.status,
    required this.court,
    required this.sport,
    required this.level,
    required this.userCreated,
    this.userJoined,
    required this.id,
  });

  static Future<Match> createFromJson(
      Map<String, dynamic> json, UserRepository userRepository) async {
    int userCreatedId = json['user_created_id'];
    User? userCreated = await userRepository.getInfoUser(userid: userCreatedId);

    return Match(
      date: DateFormat("dd/MM/yyyy").parse(json['date']),
      time: json['time'],
      rate: json['rate'],
      status: json['status'],
      court: json['court'],
      sport: Sport.fromJson(json['sport']),
      level: Level.fromJson(json['level']),
      userCreated: userCreated!,
      // user
      userJoined: json['user_joined_id'] != null
          ? User.fromJson(json['user_joined_id']) 
          : null,
      id: json['id'],
    );
  }
}
