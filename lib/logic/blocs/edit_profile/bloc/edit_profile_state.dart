part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileState  {}

abstract class EditProfileActionState extends EditProfileState {}

class EditProfileInitial extends EditProfileState {}

class EditProfileLoadingState extends EditProfileState {}

class EditProfileLoadedSuccessState extends EditProfileState {
  final User user;
  EditProfileLoadedSuccessState({
    required this.user,
  });
}

class EditProfileErrorState extends EditProfileState {}

class SubmissionErrorState extends EditProfileActionState {
  final String message;
  SubmissionErrorState({
    required this.message
  });
}

class SubmittedUserActionState extends EditProfileActionState {
  User user;
  SubmittedUserActionState({
    required this.user
  });
}

class NoInternetActionState extends EditProfileActionState {}

class ProfileNavigateActionState extends EditProfileActionState {}