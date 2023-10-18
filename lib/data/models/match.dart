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
  final String? rate;
  final String status;
  final String city;
  final String court;
  final Sport? sport;
  final Level? level;
  int? id;
  Match(
      {required this.date,
      required this.time,
      this.rate,
      required this.status,
      required this.city,
      required this.court,
      this.sport,
      this.level,
      required this.userCreated,
      this.userJoined,
      id});

  static Future<Match> createFromJson(
      Map<String, dynamic> json, UserRepository userRepository) async {
    int userCreatedId = json['user_created_id'];
    SportRepository sportRepository = SportRepository();
    MatchRepository matchRepository =
        MatchRepository(userRepository: userRepository);

    User? userCreated = await userRepository.getInfoUser(userid: userCreatedId);

    List<Sport>? sports = await sportRepository.fetchSports();
    List<Level>? levels = await matchRepository.getLevels();
    Sport? sport;
    Level? level;
    if (json['sport_id'] != null) {
      sport = sports?.firstWhere((element) => element.id == json['sport_id']);
    } else {
      sport = Sport.fromJson(json['sport']);
    }
    if (json['level_id'] != null) {
      level = levels?.firstWhere((element) => element.id == json['level_id']);
    } else {
      level = Level.fromJson(json['level']);
    }
    return Match(
      date: DateFormat("dd/MM/yyyy").parse(json['date']),
      time: json['time'],
      rate: json['rate'],
      status: json['status'],
      city: json['city'],
      court: json['court'],
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
