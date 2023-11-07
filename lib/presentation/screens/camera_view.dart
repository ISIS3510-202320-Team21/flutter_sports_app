// A screen that allows users to take a picture using a given camera.
import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../logic/blocs/authentication/bloc/authentication_bloc.dart';
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
  int? userId;

  @override
  void initState() {
    cameraBloc.add(CameraInitialEvent());
    userId = BlocProvider.of<AuthenticationBloc>(context).user!.id;
    super.initState();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (!cameraBloc.isInitialized()) return;

    if (state == AppLifecycleState.inactive) {
      cameraBloc.add(CameraStoppedEvent());
    } else if (state == AppLifecycleState.resumed){
      cameraBloc.add(CameraInitialEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
              //center body
              body: Center(
                child: CameraPreview(cameraBloc.getController())
              ),
              // body: CameraPreview(cameraBloc.getController()),
              floatingActionButton: FloatingActionButton(
                // Provide an onPressed callback.
                onPressed: () async {
                  try {
                    final image = await cameraBloc.getController().takePicture();
                    if (!mounted) return;
                    // If the picture was taken, display it on a new screen.
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DisplayPictureScreen(
                          imagePath: image.path,
                        ),
                      ),
                    );
                  } catch (e) {
                    print(e);
                  }
                },
                child: Icon(
                  Icons.camera_alt,
                  color: colorScheme.onPrimary),
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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final userId = BlocProvider.of<AuthenticationBloc>(context).user?.id;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colorScheme.onPrimary,
        elevation: 0.0,
        title: Text(
          "PHOTO",
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0.01 * ScreenUtil().screenHeight),
          child: const SizedBox(),
        ),
      ),
      body: Center(child: Image.file(File(imagePath))),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "backbtn",
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: colorScheme.onPrimary,
            ),
          ),
          SizedBox(
            width: 0.1 * ScreenUtil().screenWidth,
          ),
          FloatingActionButton(
            heroTag: "savebtn",
            onPressed: () {
              BlocProvider.of<CameraBloc>(context).add(SavePhotoEvent(imagePath: imagePath, userId: userId!));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Photo Saved!'),
                    backgroundColor: Colors.green),
              );
              Navigator.pop(context);
            },
            child: Icon(
              Icons.save,
              color: colorScheme.onPrimary,
            ),
          ),
          SizedBox(
            width: 0.01 * ScreenUtil().screenWidth,
          ),
        ],
      ),
    );
  }
}