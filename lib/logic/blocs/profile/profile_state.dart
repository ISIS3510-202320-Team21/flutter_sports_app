part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

abstract class ProfileActionState extends ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoadedSuccessState extends ProfileActionState {}

class ProfileLoadingState extends ProfileState {}

class ProfileErrorState extends ProfileState {}

class ProfileNavigateToEditState extends ProfileActionState {}

class ProfileNavigateToSettingsState extends ProfileActionState {}

class ProfileNavigateToLogoutState extends ProfileActionState {}

class ProfileNavigateToAddProfilePictureState extends ProfileActionState {}