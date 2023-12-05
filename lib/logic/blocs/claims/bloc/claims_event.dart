part of 'claims_bloc.dart';

@immutable
abstract class ClaimsEvent {}

class ClaimsSubmitButtonPressedEvent extends ClaimsEvent {
  final String claimContent;

  ClaimsSubmitButtonPressedEvent({required this.claimContent});
}

class ClaimsSubmitSuccessEvent extends ClaimsEvent {}

class ClaimsSubmitErrorEvent extends ClaimsEvent {
  final String error;

  ClaimsSubmitErrorEvent({required this.error});
}