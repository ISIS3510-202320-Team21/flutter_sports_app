import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is HomeNavigateToNotificationState) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsView()));
        }
        else if (state is HomeNavigateToReservationState) {
          final url = 'https://centrodeportivo.bookeau.com/#/login';
          launchUrl(Uri.parse(url));
        }
        else if (state is HomeNavigateToManageMatchesState) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MatchesView()));
        }
        else if (state is HomeNavigateToQuickMatchState) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MatchesView()));
        }
        else if (state is HomeNavigateToNewMatchState) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MatchesView()));
        }
        else if (state is HomeNavigateToProfileState) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileView()));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Align(
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
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome back Camilo',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 16),
                Text(
                  'What would you like to do today?',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton(
                      title: 'Go to field reservation',
                      imageAsset: 'field_reservation.png',
                      onPressed: goToFieldReservation,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton(
                      title: 'Manage your matches',
                      imageAsset: 'manage_matches.png',
                      onPressed: goToManageMatches,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton(
                      title: 'New match',
                      imageAsset: 'new_match1.png',
                      onPressed: goToNewMatch,
                    ),
                    SizedBox(width: 16),
                    _buildActionButton(
                      title: 'New match',
                      imageAsset:'new_match2.png',
                      onPressed: goToNewMatch,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton({required String title, required String imageAsset, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed, 
      icon: Image.asset(
        imageAsset,
        width: 40,
        height: 40,
      ),
      label: Text(title),
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
