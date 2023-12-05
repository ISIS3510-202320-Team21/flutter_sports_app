import 'package:bloc/bloc.dart';
import 'package:flutter_app_sports/data/repositories/claims_repository.dart';
import 'package:flutter_app_sports/logic/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async'; 

part 'claims_event.dart';
part 'claims_state.dart';

class ClaimsBloc extends Bloc<ClaimsEvent, ClaimsState> {
  ClaimsBloc() : super(ClaimsInitial()) {
    on<ClaimsSubmitButtonPressedEvent>(_onSubmitted);
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
    } catch (e) {
      emit(ClaimsSubmitErrorState(error: e.toString()));
    }
  }
}