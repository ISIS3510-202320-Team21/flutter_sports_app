import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_sports/data/models/match.dart';

import '../../../../../data/repositories/match_repository.dart';

part 'match_event.dart';
part 'match_state.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  MatchBloc() : super(MatchInitial()) {
    on<MatchInitialEvent>(matchInitialEvent);
  }

  FutureOr<void> matchInitialEvent(
      MatchInitialEvent event, Emitter<MatchState> emit) async {
    print("MatchInitialEvent");
    emit(MatchLoadingState());

    try {
      print("MatchLoadingState");
      List<Match>? matches = await MatchRepository().getMatches(userid: 1);
      emit(MatchLoadedSuccessState(matches: matches!));
    } catch (e) {
      print(e);
      emit(MatchErrorState());
    }
  }
}
