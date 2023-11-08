part of 'camera_bloc.dart';

@immutable
abstract class CameraState  {}

abstract class CameraActionState extends CameraState {}

class CameraInitial extends CameraState {}

class CameraLoadingState extends CameraState {}

class CameraLoadedSuccessState extends CameraState {}

class CameraErrorState extends CameraState {
  final String error;
  CameraErrorState({
    required this.error,
  });
}

class CameraClickActionState extends CameraActionState {}

class SavedPhotoActionState extends CameraActionState {
  final User user;
  SavedPhotoActionState({
    required this.user,
  });
}