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
  final String imagePath;

  ProfileUpdateImageEvent({required this.imagePath});
}
