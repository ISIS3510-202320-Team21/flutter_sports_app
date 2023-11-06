import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app_sports/logic/blocs/profile/profile_bloc.dart';
import 'package:flutter_app_sports/presentation/screens/MainLayout.dart';
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

  @override
  void initState() {
    super.initState();
    userName = BlocProvider.of<AuthenticationBloc>(context).user?.name;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;

    final ButtonStyle profileButtonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(const Color(0xFFEAEAEA)),
      foregroundColor: MaterialStateProperty.all(colorTheme.onError),
      shape: MaterialStateProperty.all(CircleBorder()),
      padding: MaterialStateProperty.all(EdgeInsets.all(16.0)),
    );

    final ButtonStyle iconButtonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(const Color(0xFFEAEAEA)),
      foregroundColor: MaterialStateProperty.all(colorTheme.onError),
      elevation: MaterialStateProperty.all(0),
      padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 15.0)),
    );

    final buttonWidth = MediaQuery.of(context).size.width / 2;

    return BlocConsumer<ProfileBloc, ProfileState>(
      bloc: _profileBloc,
      listener: (context, state) {
        if (state is ProfileNavigateToEditState) {
          BlocProvider.of<GlobalBloc>(context).add(NavigateToIndexEvent(AppScreens.EditProfile.index));
        } else if (state is ProfileNavigateToAddProfilePictureState) {
          BlocProvider.of<GlobalBloc>(context).add(NavigateToIndexEvent(AppScreens.CameraScreen.index));
        }
      },
      builder: (context, state) {
        String? profileImagePath = state is ProfileLoadedSuccessState ? state.profileImagePath : null;
        return Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () => _profileBloc.add(ProfileAddProfilePictureButtonClickedEvent()),
                      style: profileButtonStyle,
                      child: profileImagePath != null ? Image.file(File(profileImagePath), width: 80.0, height: 80.0) : Icon(Icons.account_circle, size: 80.0),
                    ),
                    SizedBox(height: 20),
                    Text(userName ?? 'User', style: textTheme.headline5),
                    SizedBox(height: 40),
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(width: buttonWidth),
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.edit, size: 28.0),
                        label: Text('Edit my profile', style: TextStyle(fontSize: 22)),
                        onPressed: () => _editProfile(context),
                        style: iconButtonStyle,
                      ),
                    ),
                    SizedBox(height: 20),
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(width: buttonWidth),
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.settings, size: 28.0),
                        label: Text('Settings', style: TextStyle(fontSize: 22)),
                        onPressed: () {},
                        style: iconButtonStyle,
                      ),
                    ),
                    SizedBox(height: 20),
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(width: buttonWidth),
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.logout, size: 28.0),
                        label: Text('Log out', style: TextStyle(fontSize: 22)),
                        onPressed: Restart.restartApp,
                        style: iconButtonStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _editProfile(BuildContext context) => BlocProvider.of<GlobalBloc>(context).add(NavigateToIndexEvent(AppScreens.EditProfile.index));
}
