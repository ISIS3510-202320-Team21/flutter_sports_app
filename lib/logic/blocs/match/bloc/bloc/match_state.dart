part of 'match_bloc.dart';

sealed class MatchState extends Equatable {
  const MatchState();
  
  @override
  List<Object> get props => [];
}

final class MatchInitial extends MatchState {}
