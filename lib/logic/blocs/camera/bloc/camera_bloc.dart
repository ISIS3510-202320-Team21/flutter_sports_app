import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_sports/data/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';

import '../../../../data/models/user.dart';
part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {

  CameraBloc() : super(CameraInitial()) {
    on<CameraInitialEvent>(notificationInitialEvent);
    on<CameraClickedEvent>(notificationClickedEvent);
    on<CameraStoppedEvent>(cameraStoppedEvent);
    on<SavePhotoEvent>(savedPhotoEvent);
  }

  late CameraController _controller;
  CameraController getController() => _controller;
  bool isInitialized() => _controller?.value?.isInitialized ?? false;

  FutureOr<void> notificationInitialEvent(CameraInitialEvent event, Emitter<CameraState> emit) async {
    emit(CameraLoadingState());
    try {
      _controller = await getCameraController();
      await _controller.initialize();
      emit(CameraLoadedSuccessState());
    } on CameraException catch (error) {
      print(error);
      _controller?.dispose();
      emit(CameraErrorState(error: error.description!));
    } catch (error) {
      print(error);
      emit(CameraErrorState(error: error.toString()));
    }
  }

  FutureOr<void> notificationClickedEvent(CameraClickedEvent event, Emitter<CameraState> emit) {
    print('Camera clicked');
    emit(CameraClickActionState());
  }

  Future<FutureOr<void>> savedPhotoEvent(SavePhotoEvent event, Emitter<CameraState> emit) async {
    emit(CameraLoadingState());
    print('You saved the photo!');
    String imagePath = event.imagePath;
    File fileData = File(imagePath);
    List<int> imageBytes = await fileData.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    User? user = await UserRepository().changeImage(image: base64Image, userid: event.userId);
    emit(SavedPhotoActionState());
  }

  FutureOr<void> cameraStoppedEvent(CameraStoppedEvent event, Emitter<CameraState> emit) async* {
    _controller?.dispose();
    emit(CameraInitial());
  }

  Future<CameraController> getCameraController() async {
    final cameras = await availableCameras();
    //final camera = cameras.first;
    final camera = cameras.firstWhere((description) => description.lensDirection == CameraLensDirection.front);

    return CameraController(camera, ResolutionPreset.low, enableAudio: false);
  }
}
