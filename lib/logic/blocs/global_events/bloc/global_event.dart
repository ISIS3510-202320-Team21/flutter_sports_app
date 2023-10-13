import 'package:flutter_app_sports/data/models/sport.dart';

abstract class GlobalEvent {}

class NavigateToIndexEvent extends GlobalEvent {
  final int index;

  NavigateToIndexEvent(this.index);
}

class NavigateToSportEvent extends GlobalEvent {
  final Sport sport;

  NavigateToSportEvent(this.sport);
}
