part of 'match_bloc.dart';

@immutable
abstract class MatchEvent {}

final class MatchInitialEvent extends MatchEvent {}

class MatchClickedEvent extends MatchEvent {
  final Match match;
  MatchClickedEvent({
    required this.match,
  });
}

class NewMatchNavigateEvent extends MatchEvent {}