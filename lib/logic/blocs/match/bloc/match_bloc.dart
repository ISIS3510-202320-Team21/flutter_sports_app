import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_sports/data/models/level.dart';
import 'package:flutter_app_sports/data/models/match.dart';
import 'package:flutter_app_sports/data/models/user.dart';
import 'package:flutter_app_sports/data/repositories/user_repository.dart';
import 'package:flutter_app_sports/logic/blocs/authentication/bloc/authentication_bloc.dart';

import '../../../../data/repositories/match_repository.dart';

part 'match_event.dart';
part 'match_state.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  MatchBloc() : super(MatchInitial()) {
    on<MatchInitialEvent>(matchInitialEvent);
    on<MatchClickedEvent>(matchClickedEvent);
    on<NewMatchNavigateEvent>(newMatchNavigateEvent);
    on<FetchMatchesSportsEvent>(_handleFetchPlayersForSportEvent);
    on<FetchMatchesUserEvent>(_handleFetchPlayersForUserEvent);
    on<FetchLevelsEvent>(_handleFetchLevelsEvent);
    on<CreateMatchEvent>(_handleCreateMatchEvent);
    on<addUserToMatchEvent>(_handleAddUserToMatchEvent);
    on<RateMatchEvent>(rateMatchEvent);
    on<DeleteMatchEvent>(_deleteMatch);
  }
  
  FutureOr<void> matchInitialEvent(MatchInitialEvent event, Emitter<MatchState> emit) async {
    emit(MatchLoadingState());
    try {
      List<Match>? matches = await MatchRepository(userRepository: UserRepository() ).getMatchesForUser(userid: event.userId);
      emit(MatchLoadedSuccessState(matches: matches!));
    } catch (e) {
      print(e);
      emit(MatchErrorState());
    }
  }
FutureOr<void> _handleFetchPlayersForSportEvent(FetchMatchesSportsEvent event, Emitter<MatchState> emit) async {
    emit(MatchLoadingState());
    try {
      List<Match>? matches = await MatchRepository(userRepository: UserRepository()).getMatchesForSport(sportId: event.sportId, date: event.date);
      emit(MatchesLoadedForSportState(matches!));
    } catch (e) {
      print(e);
      emit(MatchErrorState());
    }
  }

FutureOr<void> _handleFetchPlayersForUserEvent(FetchMatchesUserEvent event, Emitter<MatchState> emit) async {
    emit(MatchLoadingState());
    try {
      List<Match>? matches = await MatchRepository(userRepository: UserRepository()).getMatchesForUser(userid: event.userId);
      emit(MatchesLoadedForUserState(matches!));
    } catch (e) {
      print(e);
      emit(MatchErrorState());
    }
  }


  FutureOr<void> matchClickedEvent(MatchClickedEvent event, Emitter<MatchState> emit) {
    print('Match clicked');
    emit(MatchClickActionState());
  }

  FutureOr<void> newMatchNavigateEvent(NewMatchNavigateEvent event, Emitter<MatchState> emit) {
    print('New match navigate');
    emit(NewMatchNavigateActionState());
  }

  FutureOr<void> _handleFetchLevelsEvent(FetchLevelsEvent event, Emitter<MatchState> emit) async {
    emit(MatchLoadingState());
    try {
      List<Level>? levels = await MatchRepository(userRepository: UserRepository()).getLevels();
      emit(LevelsLoadedState(levels!));
    } catch (e) {
      print(e);
      emit(MatchErrorState());
    }
  }

  FutureOr<void> _handleCreateMatchEvent(CreateMatchEvent event, Emitter<MatchState> emit) async {
    emit(MatchLoadingState());
    try {
      Match? match = await MatchRepository(userRepository: UserRepository()).createMatch(event.match,event.userId);
      emit(MatchCreatedState(match!));
    } catch (e) {
      print(e);
      emit(MatchErrorState());
    }
  }

  FutureOr<void> _handleAddUserToMatchEvent(addUserToMatchEvent event, Emitter<MatchState> emit) async {
    emit(MatchLoadingState());
    try {
      Match? match = await MatchRepository(userRepository: UserRepository()).addUserToMatch(event.userId,event.matchId);
      emit(MatchUpdatedMatchState(match!));
    } catch (e) {
      print(e);
      emit(MatchErrorState());
    }
  }

  FutureOr<void> rateMatchEvent(RateMatchEvent event, Emitter<MatchState> emit) async {
    emit(MatchLoadingState());
    try {
      await MatchRepository(userRepository: UserRepository()).rateMatch(event.user,event.match,event.rating);
      Match? match = await MatchRepository(userRepository: UserRepository()).changeStatusMatch(event.match.id!, "Finished");
      emit(MatchFinishedState(match!));
    } catch (e) {
      print(e);
      emit(MatchErrorState());
    }
  }
Future<void> _deleteMatch(DeleteMatchEvent event, Emitter<MatchState> emit) async {
    emit(MatchLoadingState());
    try {
      int xd = await MatchRepository(userRepository: UserRepository()).deleteMatch(event.matchId);
      emit(MatchDeletedState(xd));
    } catch (e) {
      print(e);
    }
}
}
