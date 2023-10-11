import 'package:bloc/bloc.dart';
import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on <ProfileEditButtonClickedEvent>(profileEditButtonClickedEvent);
    on <ProfileSettingsButtonClickedEvent>(profileSettingsButtonClickedEvent);
    on <ProfileLogoutButtonClickedEvent>(profileLogoutButtonClickedEvent);
    on <ProfileAddProfilePictureButtonClickedEvent>(
        profileAddProfilePictureButtonClickedEvent);
  }

  FutureOr<void> profileEditButtonClickedEvent(
      ProfileEditButtonClickedEvent event, Emitter<ProfileState> emit) {
    print('Edit clicked');
    emit(ProfileNavigateToEditState());
  }

  FutureOr<void> profileSettingsButtonClickedEvent(
      ProfileSettingsButtonClickedEvent event, Emitter<ProfileState> emit) {
    print('Settings clicked');
    emit(ProfileNavigateToSettingsState());
  }

  FutureOr<void> profileLogoutButtonClickedEvent(
      ProfileLogoutButtonClickedEvent event, Emitter<ProfileState> emit) {
    print('Logout clicked');
    emit(ProfileNavigateToLogoutState());
  }

  FutureOr<void> profileAddProfilePictureButtonClickedEvent(
      ProfileAddProfilePictureButtonClickedEvent event,
      Emitter<ProfileState> emit) {
    print('Add profile picture clicked');
    emit(ProfileNavigateToAddProfilePictureState());
  }

  
}
