part of 'match_bloc.dart';

@immutable
abstract class MatchEvent {}

final class MatchInitialEvent extends MatchEvent {
  final int userId;
  MatchInitialEvent({
    required this.userId,
  });
}

class MatchClickedEvent extends MatchEvent {
  final Match match;
  MatchClickedEvent({
    required this.match,
  });
}

class NewMatchNavigateEvent extends MatchEvent {}