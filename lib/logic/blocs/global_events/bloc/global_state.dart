// global_state.dart
import 'package:flutter_app_sports/data/models/sport.dart';
import 'package:flutter_app_sports/data/models/match.dart' as externals;

abstract class GlobalState {}

class NavigationStateButtons extends GlobalState {
  final int selectedIndex;

  NavigationStateButtons(this.selectedIndex);
}

class NavigationSportState extends GlobalState {
  final Sport sport;

  NavigationSportState(this.sport);
}

class NavigationPrefferedMatchState extends GlobalState {
  final Sport sport;
  final DateTime? selectedDate;

  NavigationPrefferedMatchState(this.sport, this.selectedDate);
}

class NavigationMatchState extends GlobalState {
  final externals.Match match;
  final String status;
  NavigationMatchState(this.match, this.status);
}