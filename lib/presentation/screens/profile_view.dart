import 'package:flutter/material.dart';
import 'package:flutter_app_sports/logic/blocs/profile/profile_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/blocs/global_events/bloc/global_bloc.dart';
import '../../logic/blocs/global_events/bloc/global_event.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileBloc _profileBloc = ProfileBloc();

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
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => const EditProfileView()));
          BlocProvider.of<GlobalBloc>(context).add(NavigateToIndexEvent(4));
        }
      },
      builder: (context, state) {
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
                        },
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(16.0),
                          backgroundColor: Colors.white,
                        ),
                        child: Icon(
                          Icons.account_circle,
                          size: 80.0,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 30), // Espacio reducido entre el botón de perfil y el texto
                      Text(
                        'Nombre del usuario',
                        style: textTheme.titleLarge!.copyWith(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lato',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20.0), // Espacio entre el nombre y los botones
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
                            SizedBox(height: 16.0), // Espacio entre los botones
                            _iconButtonWithText(
                              Icons.settings,
                              'Settings',
                              () {
                                // Acción cuando se presiona el botón
                              },
                            ),
                            SizedBox(height: 16.0), // Espacio entre los botones
                            _iconButtonWithText(
                              Icons.logout,
                              'Log out',
                              () {
                                // Acción cuando se presiona el botón
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
          SizedBox(width: 16.0), // Espacio entre el icono y el texto
          Text(
            text,
            style: TextStyle(
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
