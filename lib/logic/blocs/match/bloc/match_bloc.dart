import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_sports/data/models/match.dart';
import 'package:flutter_app_sports/data/repositories/user_repository.dart';

import '../../../../data/repositories/match_repository.dart';

part 'match_event.dart';
part 'match_state.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  MatchBloc() : super(MatchInitial()) {
    on<MatchInitialEvent>(matchInitialEvent);
    on<MatchClickedEvent>(matchClickedEvent);
    on<NewMatchNavigateEvent>(newMatchNavigateEvent);
    on<FetchMatchesSportsEvent>(_handleFetchPlayersForSportEvent);
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
      emit(MatchesLoadedForSportEvent(matches!));
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
}
