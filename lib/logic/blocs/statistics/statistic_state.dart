// statistic_state.dart
import 'package:flutter_app_sports/data/models/classes.dart';

abstract class StatisticsState {}

class StatisticsInitial extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsLoaded extends StatisticsState {
  final List<SportMatchCount> statistics;

  StatisticsLoaded(this.statistics);
}

class StatisticsWait extends StatisticsState {}

class StatisticsError extends StatisticsState {
  final String message;

  StatisticsError(this.message);
}
