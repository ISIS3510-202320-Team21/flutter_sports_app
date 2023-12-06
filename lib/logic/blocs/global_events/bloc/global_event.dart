import 'package:flutter_app_sports/data/models/sport.dart';
import 'package:flutter_app_sports/data/models/match.dart' as externals;
import 'package:flutter_app_sports/data/models/notification.dart' as _notification;

abstract class GlobalEvent {}

class NavigateToIndexEvent extends GlobalEvent {
  final int index;

  NavigateToIndexEvent(this.index);
}

class NavigateToSportEvent extends GlobalEvent {
  final Sport sport;

  NavigateToSportEvent(this.sport);
}

class NavigateToPrefferedMatchEvent extends GlobalEvent {
  final Sport sport;
  final DateTime? selectedDate;

  NavigateToPrefferedMatchEvent(this.sport, this.selectedDate);
}

class NavigateToMatchEvent extends GlobalEvent {
  final externals.Match match;
  final String status;
  NavigateToMatchEvent(this.match, this.status);
}

class NavigateToNotificationEvent extends GlobalEvent {
  final _notification.Notification notification;
  NavigateToNotificationEvent(this.notification);
}