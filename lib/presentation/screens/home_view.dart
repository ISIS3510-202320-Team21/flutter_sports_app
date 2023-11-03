import 'package:flutter/material.dart';
import 'package:flutter_app_sports/data/models/sport.dart';
import 'package:flutter_app_sports/data/models/user.dart';
import 'package:flutter_app_sports/data/services/weather_api.dart';
import 'package:flutter_app_sports/logic/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/connectivity/bloc/connectivity_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_event.dart';
import 'package:flutter_app_sports/logic/blocs/home/bloc/home_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/match/bloc/match_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/notification/bloc/notification_bloc.dart'
    as _notification;
import 'package:flutter_app_sports/presentation/screens/MainLayout.dart';
import 'package:flutter_app_sports/presentation/screens/match/matches_view.dart';
import 'package:flutter_app_sports/presentation/screens/profile_view.dart';
import 'package:flutter_app_sports/presentation/widgets/WeatherDisplay.dart';
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
  final MatchBloc matchBloc = MatchBloc();
  List<Sport> sports = [];
  late User user;
  final _notification.NotificationBloc notificationBloc =
      _notification.NotificationBloc();
  double latitude = 0;
  double longitude = 0;

  @override
  void initState() {
    super.initState();
    int userId = BlocProvider.of<AuthenticationBloc>(context).user!.id;
    user = BlocProvider.of<AuthenticationBloc>(context).user!;
    BlocProvider.of<AuthenticationBloc>(context)
        .add(FetchUniversitiesRequested());
    BlocProvider.of<AuthenticationBloc>(context).add(FetchRolesRequested());
    BlocProvider.of<AuthenticationBloc>(context).add(FetchGendersRequested());
    homeBloc.add(FetchSportsRecent(user));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    ScreenUtil.init(context);


    return MultiBlocProvider(
      providers: [ 
        BlocProvider<HomeBloc>(create: (context) => homeBloc),
      ],
      child: BlocConsumer<HomeBloc, HomeState>(
        bloc: homeBloc,
        listenWhen: (previous, current) => current is HomeActionState,
        buildWhen: (previous, current) => current is! HomeActionState,
        listener: (context, state) {
          if (state is HomeNavigateToNotificationState) {
            BlocProvider.of<GlobalBloc>(context).add(NavigateToIndexEvent(3));
          } else if (state is HomeNavigateToReservationState) {
            const url = 'https://centrodeportivo.bookeau.com/#/login';
            launchUrl(Uri.parse(url));
          } else if (state is HomeNavigateToManageMatchesState) {
            BlocProvider.of<GlobalBloc>(context)
                .add(NavigateToIndexEvent(AppScreens.MyMatches.index));
          } else if (state is HomeNavigateToQuickMatchState) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MatchesView()));
          } else if (state is HomeNavigateToNewMatchState) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MatchesView()));
          } else if (state is HomeNavigateToProfileState) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ProfileView()));
          } else if (state is RecentSportsLoaded) {
            sports = state.sports;
            homeBloc.add(HomeLoadedSuccessEvent());
          } else if (state is FetchErrorState) {
            print(state.error);
          }
        },
        builder: (context, state) {
          if (state is SportsLoadingRecent) {
            return const Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));
          }
          print("La cantidad de deportes es:");
          print(sports.length);

          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<AuthenticationBloc, AuthenticationState>(
                      builder: (context, authState) {
                        if (authState is Authenticated) {
                          final notifications = authState.usuario.notifications;
                          final title =
                              notifications != null && notifications.isNotEmpty
                                  ? notifications.last.name
                                  : "Aquí va el texto de las notificaciones";

                          return CustomButtonNotifications(
                            key: UniqueKey(),
                            title: title,
                            imageAsset: "assets/arrow_1.png",
                            onPressed: goToNotifications,
                          );
                        }
                        return CustomButtonNotifications(
                          title: "Aquí va el texto de las notificaciones",
                          imageAsset: "assets/arrow_1.png",
                          onPressed: goToNotifications,
                        );
                      },
                    ),
                    WeatherDisplay(
                      latitude: latitude,
                      longitude: longitude,
                    ),
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
                                    text: user.name,
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
                                  fontSize: 16,
                                  color: colorScheme.onBackground),
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
                            Wrap(
                              spacing:
                                  16, // Espacio horizontal entre cada botón
                              runSpacing:
                                  16, // Espacio vertical entre las líneas
                              alignment: WrapAlignment.center,
                              children: sports.map((sport) {
                                return _buildActionButton2(
                                  title: sport.name,
                                  imageAsset: sport.image!,
                                  onPressed: () => goToNewMatch(sport),
                                );
                              }).toList(),
                            )
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
      ),
    );
  }

  Widget _buildActionButton(
      {required String title,
      required String imageAsset,
      required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFEAEAEA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: SizedBox(
        width: 300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              imageAsset,
              width: 100,
              height: 100,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
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
    return SizedBox(
      width: 170, // Establece el ancho máximo deseado
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEAEAEA),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Row(
          children: [
            Image.network(
              imageAsset,
              width: 50,
              height: 100,
            ),
            const SizedBox(
                width: 16), // Espacio horizontal entre la imagen y el texto
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
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

  void goToNewMatch(Sport sport) {
    BlocProvider.of<GlobalBloc>(context).add(NavigateToSportEvent(sport));
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

class CustomButtonNotifications extends StatelessWidget {
  final String title;
  final String imageAsset;
  final VoidCallback onPressed;

  const CustomButtonNotifications({
    Key? key,
    required this.title,
    required this.imageAsset,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0, // Sin sombra
          padding: EdgeInsets.zero, // Sin relleno interno
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Sin bordes redondeados
          ),
          backgroundColor: const Color(0xFFEAEAEA), // Color de fondo
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black, // Color del texto
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Image.asset(
              imageAsset,
              width: 40,
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
