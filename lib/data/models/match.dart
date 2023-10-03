import 'package:flutter/material.dart';
import 'package:sportsapp/data/models/level.dart';
import 'package:sportsapp/data/models/sport.dart';

class Match {
  final DateTime date;
  final TimeOfDay time;
  final double rate;
  final String status;
  final String place;
  final Sport sport;
  final Level level;

  Match({
    required this.date,
    required this.time,
    required this.rate,
    required this.status,
    required this.place,
    required this.sport,
    required this.level,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      date: DateTime.parse(json['date']),
      time: TimeOfDay.fromDateTime(DateTime.parse(json[
          'time'])), // Asume que 'time' viene en formato de fecha completo.
      rate: json['rate'],
      status: json['status'],
      place: json['place'],
      sport: Sport.fromJson(json['sport']),
      level: Level.fromJson(json['level']),
    );
  }
}
