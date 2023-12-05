import 'package:bloc/bloc.dart';
import 'package:flutter_app_sports/data/repositories/claims_repository.dart';
import 'package:flutter_app_sports/logic/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart'; 

part 'claims_event.dart';
part 'claims_state.dart';

class ClaimsBloc extends Bloc<ClaimsEvent, ClaimsState> {
  ClaimsBloc() : super(ClaimsInitial()) {
    on<ClaimsSubmitButtonPressedEvent>(_onSubmitted);
  }

  Future<void> saveClaim(String claimContent) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> claims = prefs.getStringList('saved_claims') ?? [];
    claims.add(claimContent);
    await prefs.setStringList('saved_claims', claims);
    }

  Future<void> _onSubmitted(
    ClaimsSubmitButtonPressedEvent event,
    Emitter<ClaimsState> emit,
  ) async {
    emit(ClaimsSubmitButtonPressedState(isSubmitting: true));

    try {
      await ClaimsRepository().submitClaim(
        userId: event.userId,
        claimContent: event.claimContent,
      );
      emit(ClaimsSubmitSuccessState());
      await saveClaim(event.claimContent);
    } catch (e) {
      emit(ClaimsSubmitErrorState(error: e.toString()));
    }
  }
}