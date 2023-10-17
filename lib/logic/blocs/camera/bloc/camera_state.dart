part of 'camera_bloc.dart';

@immutable
abstract class CameraState  {}

abstract class CameraActionState extends CameraState {}

class CameraInitial extends CameraState {}

class CameraLoadingState extends CameraState {}

class CameraLoadedSuccessState extends CameraState {
  // final CameraDescription camera;
  // CameraLoadedSuccessState({
  //   required this.camera,
  // });
}

class CameraErrorState extends CameraState {
  final String error;
  CameraErrorState({
    required this.error,
  });
}

class CameraClickActionState extends CameraActionState {}