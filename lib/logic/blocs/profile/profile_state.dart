part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {
  ProfileState copyWith({String? profileImagePath});
}

abstract class ProfileActionState extends ProfileState {}

class ProfileInitial extends ProfileState {
  @override
  ProfileState copyWith({String? profileImagePath}) {
    return ProfileInitial();
  }
}

class ProfileLoadedSuccessState extends ProfileActionState {
  final User user;

  ProfileLoadedSuccessState({required this.user});
  
  @override
  ProfileState copyWith({String? profileImagePath}) {
    return ProfileLoadedSuccessState(user: user);
  }
}

class ProfileLoadingState extends ProfileState {
  @override
  ProfileState copyWith({String? profileImagePath}) {
    return ProfileLoadingState();
  }
}

class ProfileErrorState extends ProfileState {
  @override
  ProfileState copyWith({String? profileImagePath}) {
    return ProfileErrorState();
  }
}

class ProfileNavigateToEditState extends ProfileActionState {
  @override
  ProfileState copyWith({String? profileImagePath}) {
    return ProfileNavigateToEditState();
  }
}

class ProfileNavigateToSettingsState extends ProfileActionState {
  @override
  ProfileState copyWith({String? profileImagePath}) {
    return ProfileNavigateToSettingsState();
  }
}

class ProfileNavigateToLogoutState extends ProfileActionState {
  @override
  ProfileState copyWith({String? profileImagePath}) {
    return ProfileNavigateToLogoutState();
  }
}

class ProfileNavigateToAddProfilePictureState extends ProfileActionState {
  @override
  ProfileState copyWith({String? profileImagePath}) {
    return ProfileNavigateToAddProfilePictureState();
  }
}
