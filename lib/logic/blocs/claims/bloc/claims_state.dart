part of 'claims_bloc.dart';

@immutable
abstract class ClaimsState {
}

class ClaimsInitial extends ClaimsState{}

class ClaimsSubmitButtonPressedState extends ClaimsState {
  final bool isSubmitting;

  ClaimsSubmitButtonPressedState({required this.isSubmitting});
}

class ClaimsSubmitSuccessState extends ClaimsState {}

class ClaimsSubmitErrorState extends ClaimsState {
  final String error;

  ClaimsSubmitErrorState({required this.error});
}