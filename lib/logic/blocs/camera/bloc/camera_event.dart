part of 'camera_bloc.dart';

@immutable
abstract class CameraEvent {}

final class CameraInitialEvent extends CameraEvent {
}

final class CameraStoppedEvent extends CameraEvent {
}

final class SavePhotoEvent extends CameraEvent {
  final String imagePath;
  final int userId;
  SavePhotoEvent({
    required this.imagePath,
    required this.userId,
  });
}

class CameraClickedEvent extends CameraEvent {
  final String photo;
  CameraClickedEvent({
    required this.photo,
  });
}