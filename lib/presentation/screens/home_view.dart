import 'package:flutter/material.dart';
import 'package:flutter_app_sports/data/models/user.dart';
import 'package:flutter_app_sports/logic/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/home/bloc/home_bloc.dart';
import 'package:flutter_app_sports/presentation/screens/matches_view.dart';
import 'package:flutter_app_sports/presentation/screens/notifications_view.dart';
import 'package:flutter_app_sports/presentation/screens/profile_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeBloc homeBloc = HomeBloc();
  //User? currentUser;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is HomeNavigateToNotificationState) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsView()));
        } else if (state is HomeNavigateToReservationState) {
          const url = 'https://centrodeportivo.bookeau.com/#/login';
          launchUrl(Uri.parse(url));
        } else if (state is HomeNavigateToManageMatchesState) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const MatchesView()));
        } else if (state is HomeNavigateToQuickMatchState) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const MatchesView()));
        } else if (state is HomeNavigateToNewMatchState) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const MatchesView()));
        } else if (state is HomeNavigateToProfileState) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileView()));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'HOME',
                style: TextStyle(
                  color: Color(0xFF37392E),
                  fontSize: 29,
                  fontFamily: 'Lato',
                ),
              ),
              
            ) 
          ),
          
          body: SingleChildScrollView( // Added SingleChildScrollView to prevent overflow
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    BlocProvider.of<AuthenticationBloc>(context).userName != null
                      ? 'Welcome back ${BlocProvider.of<AuthenticationBloc>(context).userName}'
                      : 'Welcome ',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'What would you like to do today?',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildActionButton(
                        title: 'Go to field reservation',
                        imageAsset: 'assets/field_reservation.png', 
                        onPressed: goToFieldReservation,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildActionButton(
                        title: 'Manage your matches',
                        imageAsset: 'assets/manage_matches.png', 
                        onPressed: goToManageMatches,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildActionButton2(
                        title: 'New Tennis Match',
                        imageAsset: 'assets/new_match1.png', 
                        onPressed: goToNewMatch,
                      ),
                      const SizedBox(width: 16),
                      _buildActionButton2(
                        title: 'New Basketball Match',
                        imageAsset: 'assets/loginIcon.png', 
                        onPressed: goToNewMatch,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

Widget _buildActionButton({required String title, required String imageAsset, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed, 
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16), // Ajusta el espacio horizontal aquí
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Ajusta esto según tu preferencia
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Alinea la imagen y el texto hacia la izquierda
        children: [
          Image.asset(
            imageAsset,
            width: 100, // Ancho de la imagen
            height: 100, // Alto de la imagen
          ),
          SizedBox(width: 16), // Espacio entre la imagen y el texto
          Text(
            title,
            style: TextStyle(
              fontSize: 18, // Ajusta el tamaño de fuente según tus necesidades
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton2({required String title, required String imageAsset, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed, 
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16), // Ajusta el espacio horizontal aquí
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Ajusta esto según tu preferencia
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            imageAsset,
            width: 50, // Ancho de la imagen
            height: 100, // Alto de la imagen
          ),
          SizedBox(width: 16), // Espacio entre la imagen y el texto
          Expanded( // Esto permite que el texto se ajuste sin hacer el botón más ancho
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18, // Ajusta el tamaño de fuente según tus necesidades
              ),
            ),
          ),
        ],
      ),
    );
  }


  void goToFieldReservation() {
    homeBloc.add(HomeReservationButtonClickedEvent());
  }

  void goToManageMatches() {
    homeBloc.add(HomeManageMatchesButtonClickedEvent());
  }

  void goToNewMatch() {
    homeBloc.add(HomeNewMatchButtonClickedEvent());
  }

  void goToQuickMatch() {
    homeBloc.add(HomeQuickMatchButtonClickedEvent());
  }

  void goToProfile() {
    homeBloc.add(HomeProfileButtonClickedEvent());
  }

  void goToNotifications() {
    homeBloc.add(HomeNotificationButtonClickedEvent());
  }

}
