part of 'claims_bloc.dart';

@immutable
abstract class ClaimsEvent {}

class ClaimsSubmitButtonPressedEvent extends ClaimsEvent {
  final String claimContent;
  final int userId;
  ClaimsSubmitButtonPressedEvent({required this.claimContent, required this.userId});
}

class ClaimsSubmitSuccessEvent extends ClaimsEvent {}

class ClaimsSubmitErrorEvent extends ClaimsEvent {
  final String error;

  ClaimsSubmitErrorEvent({required this.error});
}