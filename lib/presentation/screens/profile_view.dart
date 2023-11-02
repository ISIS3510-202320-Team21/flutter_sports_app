import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_sports/logic/blocs/profile/profile_bloc.dart';
import 'package:flutter_app_sports/main.dart';
import 'package:flutter_app_sports/presentation/screens/MainLayout.dart';
import 'package:flutter_app_sports/presentation/screens/login_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_app/restart_app.dart';
import '../../logic/blocs/authentication/bloc/authentication_bloc.dart';
import '../../logic/blocs/global_events/bloc/global_bloc.dart';
import '../../logic/blocs/global_events/bloc/global_event.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileBloc _profileBloc = ProfileBloc();

  String? userName;
  void initState() {
    super.initState();
    userName = BlocProvider.of<AuthenticationBloc>(context).user?.name;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<ProfileBloc, ProfileState>(
      bloc: _profileBloc,
      listenWhen: (previous, current) => current is ProfileActionState,
      buildWhen: (previous, current) => current is! ProfileActionState,
      listener: (context, state) {
        if (state is ProfileNavigateToEditState) {
          BlocProvider.of<GlobalBloc>(context)
              .add(NavigateToIndexEvent(AppScreens.EditProfile.index));
        } else if (state is ProfileNavigateToAddProfilePictureState) {
          BlocProvider.of<GlobalBloc>(context)
              .add(NavigateToIndexEvent(AppScreens.CameraScreen.index));
        }
      },
      builder: (context, state) {
        if (state is ProfileLoadedSuccessState) {
          // Si el estado es ProfileLoadedSuccessState, muestra la imagen de perfil
          final profileImagePath = state.profileImagePath;

          return Scaffold(
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Acción cuando se presiona el botón de perfil
                            _profileBloc.add(
                              ProfileAddProfilePictureButtonClickedEvent(),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(16.0),
                            backgroundColor: colorScheme.background,
                            shadowColor: Colors.transparent,
                          ),
                          child: profileImagePath != null
                              ? Image.file(
                                  File(profileImagePath),
                                  width: 80.0,
                                  height: 80.0,
                                )
                              : const Icon(
                                  Icons.account_circle,
                                  size: 80.0,
                                  color: Colors.black87,
                                ),
                        ),
                        const SizedBox(
                            height:
                                20), // Espacio reducido entre el botón de perfil y el texto
                        Text(
                          'Nombre del usuario',
                          style: textTheme.titleLarge!.copyWith(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lato',
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                            height:
                                40.0), // Espacio entre el nombre y los botones
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _iconButtonWithText(
                                Icons.edit,
                                'Edit my profile',
                                () {
                                  goToEditProfile();
                                },
                              ),
                              const SizedBox(
                                  height: 16.0), // Espacio entre los botones
                              _iconButtonWithText(
                                Icons.settings,
                                'Settings',
                                () {
                                  // Acción cuando se presiona el botón
                                },
                              ),
                              const SizedBox(
                                  height: 16.0), // Espacio entre los botones
                              _iconButtonWithText(
                                Icons.logout,
                                'Log out',
                                () {
                                  Restart.restartApp(webOrigin: '/');
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          // Si no estás en ProfileLoadedSuccessState, muestra el icono de perfil por defecto.
          return Scaffold(
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Acción cuando se presiona el botón de perfil
                            _profileBloc.add(
                              ProfileAddProfilePictureButtonClickedEvent(),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(16.0),
                            backgroundColor: colorScheme.background,
                            shadowColor: Colors.transparent,
                          ),
                          child: const Icon(
                            Icons.account_circle,
                            size: 80.0,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(
                          height:
                              20), // Espacio reducido entre el botón de perfil y el texto
                      Text(
                        userName != null ? '$userName' : 'User',
                        style: textTheme.titleLarge!.copyWith(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lato',
                          color: colorScheme.primary,
                        ),
                        const SizedBox(
                            height:
                                40.0), // Espacio entre el nombre y los botones
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _iconButtonWithText(
                                Icons.edit,
                                'Edit my profile',
                                () {
                                  goToEditProfile();
                                },
                              ),
                              const SizedBox(
                                  height: 16.0), // Espacio entre los botones
                              _iconButtonWithText(
                                Icons.settings,
                                'Settings',
                                () {
                                  // Acción cuando se presiona el botón
                                },
                              ),
                              const SizedBox(
                                  height: 16.0), // Espacio entre los botones
                              _iconButtonWithText(
                                Icons.logout,
                                'Log out',
                                () {
                                  Restart.restartApp(webOrigin: '/');
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _iconButtonWithText(
    IconData iconData,
    String text,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          Icon(
            iconData,
            size: 36.0,
            color: Colors.black,
          ),
          const SizedBox(width: 16.0), // Espacio entre el icono y el texto
          Text(
            text,
            style: const TextStyle(
              fontSize: 18.0,
              fontFamily: 'Lato',
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void goToEditProfile() {
    _profileBloc.add(ProfileEditButtonClickedEvent());
  }
}