import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {

  CameraBloc() : super(CameraInitial()) {
    on<CameraInitialEvent>(notificationInitialEvent);
    on<CameraClickedEvent>(notificationClickedEvent);
    on<CameraStoppedEvent>(cameraStoppedEvent);
  }

  late CameraController _controller;
  CameraController getController() => _controller;
  bool isInitialized() => _controller?.value?.isInitialized ?? false;

  FutureOr<void> notificationInitialEvent(CameraInitialEvent event, Emitter<CameraState> emit) async {
    emit(CameraLoadingState());
    try {
      print("Camera loading");
      _controller = await getCameraController();
      print("Camera loaded");
      await _controller.initialize();
      print("Camera initialized");
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

  Future<CameraController> getCameraController() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    return CameraController(camera, ResolutionPreset.medium, enableAudio: false);
  }

  FutureOr<void> cameraStoppedEvent(CameraStoppedEvent event, Emitter<CameraState> emit) async* {
    _controller?.dispose();
    emit(CameraInitial());
  }
}
