part of 'match_bloc.dart';

@immutable
abstract class MatchState {
  get levels => null;
}

abstract class MatchActionState extends MatchState {}

class MatchInitial extends MatchState {}

class MatchLoadingState extends MatchState {}

class MatchLoadedSuccessState extends MatchState {
  final List<Match> matches;
  MatchLoadedSuccessState({
    required this.matches,
  });
}

class MatchErrorState extends MatchState {}

class MatchClickActionState extends MatchActionState {}

class NewMatchNavigateActionState extends MatchActionState {}

class MatchesLoadedForSportState extends MatchState {
  final List<Match> matches;

  MatchesLoadedForSportState(this.matches);
}

class MatchesLoadedForUserState extends MatchState {
  final List<Match> matches;

  MatchesLoadedForUserState(this.matches);
}

class LevelsLoadedState extends MatchState {
  final List<Level> levels;

  LevelsLoadedState(this.levels);
}

class MatchCreatedState extends MatchState {
  final Match match;

  MatchCreatedState(this.match);
}