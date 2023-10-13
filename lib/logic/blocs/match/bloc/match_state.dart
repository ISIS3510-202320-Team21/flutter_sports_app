part of 'match_bloc.dart';

@immutable
abstract class MatchState {}

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

class MatchesLoadedForSportEvent extends MatchState {
  final List<Match> matches;

  MatchesLoadedForSportEvent(this.matches);
}
