part of 'camera_bloc.dart';

@immutable
abstract class CameraEvent {}

final class CameraInitialEvent extends CameraEvent {
}

final class CameraStoppedEvent extends CameraEvent {
}

class CameraClickedEvent extends CameraEvent {
  final String photo;
  CameraClickedEvent({
    required this.photo,
  });
}