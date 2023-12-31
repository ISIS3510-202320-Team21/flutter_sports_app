import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sports/logic/blocs/profile/profile_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/statistics/statistic_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/statistics/statistic_event.dart';
import 'package:flutter_app_sports/presentation/screens/MainLayout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../logic/blocs/authentication/bloc/authentication_bloc.dart';
import '../../logic/blocs/global_events/bloc/global_bloc.dart';
import '../../logic/blocs/global_events/bloc/global_event.dart';
import 'dart:convert';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String? userName;
  String? userImage;

  void initState() {
    super.initState();
    userName = BlocProvider.of<AuthenticationBloc>(context).user?.name;
    userImage = BlocProvider.of<AuthenticationBloc>(context).user?.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;
final ButtonStyle profileButtonStyle = ButtonStyle(
  elevation: MaterialStateProperty.all(2),
  surfaceTintColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onPrimary),
  foregroundColor: MaterialStateProperty.all(colorTheme.onError),
  shape: MaterialStateProperty.all(RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  )),
  padding: MaterialStateProperty.all(const EdgeInsets.all(16.0)),
);

final ButtonStyle iconButtonStyle = ButtonStyle(
  foregroundColor: MaterialStateProperty.all(colorTheme.onError),
  elevation: MaterialStateProperty.all(2),
  surfaceTintColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onPrimary),
  shape: MaterialStateProperty.all(RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  )),
  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 15.0)),
);

    final buttonWidth = MediaQuery.of(context).size.width / 2;

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileNavigateToEditState) {
          BlocProvider.of<GlobalBloc>(context)
              .add(NavigateToIndexEvent(AppScreens.EditProfile.index));
        } else if (state is ProfileNavigateToAddProfilePictureState) {
          BlocProvider.of<GlobalBloc>(context)
              .add(NavigateToIndexEvent(AppScreens.CameraScreen.index));
        } else if (state is ProfileLoadedSuccessState) {
          BlocProvider.of<AuthenticationBloc>(context)
              .add(UpdateUserEvent(state.user));
        }
        else if (state is ProfileNavigateToClaimsState){
          BlocProvider.of<GlobalBloc>(context)
              .add(NavigateToIndexEvent(AppScreens.Claims.index));
        } else if (state is NoInternetState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("You need internet connection to edit your profile!"),
                backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
          String base64String = "data:image/png;base64,$userImage";

          // Elimina el encabezado
          String base64Content = base64String.split(',').last;
          Uint8List bytes = base64.decode(base64Content);
          Image image = Image.memory(
            bytes,
            width: 80.0,
            height: 80.0,
          );
        return Scaffold(
          backgroundColor: colorTheme.onPrimary,
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () => BlocProvider.of<ProfileBloc>(context)
                          .add(ProfileAddProfilePictureButtonClickedEvent()),
                      style: profileButtonStyle,
                      child: userImage != null
                          ? image
                          : const Icon(Icons.account_circle, size: 80.0),
                    ),
                    const SizedBox(height: 20),
                    Text(userName ?? 'User', style: textTheme.headlineSmall),
                    const SizedBox(height: 40),
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(width: buttonWidth),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.edit, size: 28.0),
                        label: const Text('Edit my profile',
                            style: TextStyle(fontSize: 22)),
                        onPressed: () => _editProfile(context),
                        style: iconButtonStyle,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(width: buttonWidth),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.gavel, size: 28.0),
                        label: const Text('Claims', style: TextStyle(fontSize: 22)),
                        onPressed: () => _claims(context),
                        style: iconButtonStyle,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(width: buttonWidth),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.logout, size: 28.0),
                        label: const Text('Log out', style: TextStyle(fontSize: 22)),
                        onPressed: logOut,
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

  void _editProfile(BuildContext context) async {
    var connectivityResult = await(Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      BlocProvider.of<ProfileBloc>(context)
          .add(NoInternetEvent());
    } else {
      BlocProvider.of<GlobalBloc>(context)
          .add(NavigateToIndexEvent(AppScreens.EditProfile.index));
    }
  }

  void _claims(BuildContext context) =>
      BlocProvider.of<GlobalBloc>(context)
          .add(NavigateToIndexEvent(AppScreens.Claims.index));

  void logOut() async {
// Aquí puedes agregar el código para limpiar el estado de los blocs si es necesario
    // Por ejemplo:
    // Asegúrate de tener el evento y el estado adecuado en tu AuthenticationBloc.

    // Limpia los datos de SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    BlocProvider.of<AuthenticationBloc>(context).add(SignOutRequested());
    BlocProvider.of<GlobalBloc>(context).add(NavigateToIndexEvent(0));
    BlocProvider.of<StatisticsBloc>(context).add(StatisticsResetEvent());
    
    await prefs.clear();

    // Aquí también puedes navegar de vuelta a la pantalla de inicio de sesión si es necesario
    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You have been successfully logged out.'),
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }
}
