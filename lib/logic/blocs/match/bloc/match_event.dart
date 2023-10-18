part of 'match_bloc.dart';

@immutable
abstract class MatchEvent {}

class NewMatchNavigateEvent extends MatchEvent {}

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

class FetchMatchesSportsEvent extends MatchEvent {
  final int sportId;
  final DateTime? date;
  FetchMatchesSportsEvent(this.sportId,this.date); 
}

class FetchMatchesUserEvent extends MatchEvent {
  final int userId;
  FetchMatchesUserEvent(this.userId); 
}

class MatchesLoadedForUserEvent extends MatchEvent {
  final List<Match> matches;
  MatchesLoadedForUserEvent(this.matches); 
}

class FetchLevelsEvent extends MatchEvent {
  FetchLevelsEvent(); 
}

class CreateMatchEvent extends MatchEvent {
  final Match match;
  final int userId;
  CreateMatchEvent(this.match,this.userId); 
}

class addUserToMatchEvent extends MatchEvent {
  final int userId;
  final int matchId;
  addUserToMatchEvent(this.userId,this.matchId); 
}