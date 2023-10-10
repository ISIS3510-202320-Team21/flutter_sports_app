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

class SubmittedUserActionState extends EditProfileActionState {}

class ProfileNavigateActionState extends EditProfileActionState {}