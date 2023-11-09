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

class RateMatchEvent extends MatchEvent {
  final User user;
  final Match match;
  final double rating;
  RateMatchEvent({
    required this.user,
    required this.match,
    required this.rating,
  });
}

class FetchMatchesSportsEvent extends MatchEvent {
  final int sportId;
  final DateTime? date;
  FetchMatchesSportsEvent(this.sportId, this.date);
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
  CreateMatchEvent(this.match, this.userId);
}

class addUserToMatchEvent extends MatchEvent {
  final int userId;
  final int matchId;
  addUserToMatchEvent(this.userId, this.matchId);
}

class UpdatedMatchEvent extends MatchEvent {
  UpdatedMatchEvent();
}

class DeleteMatchEvent extends MatchEvent {
  final int matchId;

  DeleteMatchEvent(this.matchId);

  @override
  List<Object> get props => [matchId];
}

class FetchCitiesRequested extends MatchEvent {}

class FetchCourtsRequested extends MatchEvent {}

class AllDataLoadedEvent extends MatchEvent {
}