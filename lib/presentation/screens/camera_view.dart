// A screen that allows users to take a picture using a given camera.
import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/blocs/camera/bloc/camera_bloc.dart';

class TakePictureScreen extends StatefulWidget {

  const TakePictureScreen({
    super.key
  });

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  final CameraBloc cameraBloc = CameraBloc();
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late List<CameraDescription> cameras;
  late CameraDescription camera;

  @override
  void initState() {
    cameraBloc.add(CameraInitialEvent());
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    // availableCameras().then((availableCameras) {
    //   cameras = availableCameras;
    //   camera = cameras.first;
    // });
    // _controller = CameraController(
    // _controller = cameraBloc.getController();
    //
    //   // Get a specific camera from the list of available cameras.
    //   camera,
    //   // Define the resolution to use.
    //   ResolutionPreset.medium,
    // );

    // Next, initialize the controller. This returns a Future.
    // _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   // App state changed before we got the chance to initialize.
  //   if (!cameraBloc.isInitialized()) return;
  //
  //   if (state == AppLifecycleState.inactive) {
  //     cameraBloc.add(CameraStoppedEvent());
  //   } else if (state == AppLifecycleState.resumed){
  //     cameraBloc.add(CameraInitialEvent());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CameraBloc,CameraState>(
      bloc: cameraBloc,
      listenWhen: (previous, current) => current is CameraActionState,
      buildWhen: (previous, current) => current is! CameraActionState,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case CameraLoadingState:
            return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ));
          case CameraLoadedSuccessState:
            return Scaffold(
              appBar: AppBar(title: const Text('Take a picture')),
              // You must wait until the controller is initialized before displaying the
              // camera preview. Use a FutureBuilder to display a loading spinner until the
              // controller has finished initializing.
              body: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If the Future is complete, display the preview.
                    return CameraPreview(_controller);
                  } else {
                    // Otherwise, display a loading indicator.
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              floatingActionButton: FloatingActionButton(
                // Provide an onPressed callback.
                onPressed: () async {
                  // Take the Picture in a try / catch block. If anything goes wrong,
                  // catch the error.
                  try {
                    // Ensure that the camera is initialized.
                    await cameraBloc.getController();
                    _controller = cameraBloc.getController();

                    // Attempt to take a picture and get the file `image`
                    // where it was saved.
                    final image = await _controller.takePicture();

                    if (!mounted) return;

                    // If the picture was taken, display it on a new screen.
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DisplayPictureScreen(
                          // Pass the automatically generated path to
                          // the DisplayPictureScreen widget.
                          imagePath: image.path,
                        ),
                      ),
                    );
                  } catch (e) {
                    // If an error occurs, log the error to the console.
                    print(e);
                  }
                },
                child: const Icon(Icons.camera_alt),
              ),
            );
          case CameraErrorState:
            return const Scaffold(body: Center(child: Text('Error')));
          default:
            return const SizedBox();
        }
      },
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}