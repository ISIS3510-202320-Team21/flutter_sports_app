// global_state.dart
import 'package:flutter_app_sports/data/models/sport.dart';

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