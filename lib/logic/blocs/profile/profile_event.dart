part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class ProfileEditButtonClickedEvent extends ProfileEvent {

}

class ProfileSettingsButtonClickedEvent extends ProfileEvent {

}

class ProfileLogoutButtonClickedEvent extends ProfileEvent {

}

class ProfileAddProfilePictureButtonClickedEvent extends ProfileEvent {

}

class ProfileUpdateImageEvent extends ProfileEvent {
  final User user;

  ProfileUpdateImageEvent({
    required this.user,
  });
}
