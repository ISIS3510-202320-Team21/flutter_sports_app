import 'package:flutter/material.dart';
import 'package:flutter_app_sports/data/models/level.dart';
import 'package:flutter_app_sports/data/models/sport.dart';
import 'package:intl/intl.dart';

class Match {
  final DateTime date;
  final String time;
  final double? rate;
  final String status;
  final String court;
  final Sport sport;
  final Level level;

  Match({
    required this.date,
    required this.time,
    required this.rate,
    required this.status,
    required this.court,
    required this.sport,
    required this.level,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      date: DateFormat("dd/MM/yyyy").parse(json['date']),
      time: json['time'],
      rate: json['rate'],
      status: json['status'],
      court: json['court'],
      sport: Sport.fromJson(json['sport']),
      level: Level.fromJson(json['level']),
    );
  }
}
