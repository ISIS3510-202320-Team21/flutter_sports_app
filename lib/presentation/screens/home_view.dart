import 'package:flutter/material.dart';
import 'package:flutter_app_sports/logic/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_event.dart';
import 'package:flutter_app_sports/logic/blocs/home/bloc/home_bloc.dart';
import 'package:flutter_app_sports/presentation/screens/matches_view.dart';
import 'package:flutter_app_sports/presentation/screens/notifications_view.dart';
import 'package:flutter_app_sports/presentation/screens/profile_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
  void goToManageMatches() {}
}

class _HomeViewState extends State<HomeView> {
  final HomeBloc homeBloc = HomeBloc();
  final GlobalBloc globalBloc = GlobalBloc();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    ScreenUtil.init(context);
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is HomeNavigateToNotificationState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NotificationsView()));
        } else if (state is HomeNavigateToReservationState) {
          const url = 'https://centrodeportivo.bookeau.com/#/login';
          launchUrl(Uri.parse(url));
        } else if (state is HomeNavigateToManageMatchesState) {
          BlocProvider.of<GlobalBloc>(context).add(NavigateToIndexEvent(1));
        } else if (state is HomeNavigateToQuickMatchState) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MatchesView()));
        } else if (state is HomeNavigateToNewMatchState) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MatchesView()));
        } else if (state is HomeNavigateToProfileState) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ProfileView()));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SingleChildScrollView(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Welcome back ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: colorScheme.onBackground,
                                  ),
                                ),
                                TextSpan(
                                  text: BlocProvider.of<AuthenticationBloc>(
                                                  context)
                                              .userName !=
                                          null
                                      ? '${BlocProvider.of<AuthenticationBloc>(context).userName}'
                                      : 'User',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'What would you like to do today?',
                            style: TextStyle(
                                fontSize: 16, color: colorScheme.onBackground),
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
                                imageAsset: 'assets/reserva_1.png',
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
                                imageAsset: 'assets/tenis_1.png',
                                onPressed: goToNewMatch,
                              ),
                              const SizedBox(width: 16),
                              _buildActionButton2(
                                title: 'New Soccer Match',
                                imageAsset: 'assets/ajedrez_1.png',
                                onPressed: goToNewMatch,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
      {required String title,
      required String imageAsset,
      required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFEAEAEA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: SizedBox(
        width: 300, // Establece el ancho máximo deseado
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              imageAsset,
              width: 100,
              height: 100,
            ),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: Colors.black, // Color del texto
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton2(
      {required String title,
      required String imageAsset,
      required VoidCallback onPressed}) {
    return Container(
      width: 155, // Establece el ancho máximo deseado
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFEAEAEA),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              imageAsset,
              width: 50,
              height: 100,
            ),
            SizedBox(
                width: 16), // Espacio horizontal entre la imagen y el texto
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black, // Color del texto
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
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
