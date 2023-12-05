import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sports/data/models/sport.dart';
import 'package:flutter_app_sports/data/models/user.dart';
import 'package:flutter_app_sports/data/models/notification.dart'
    as Notification2;
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
  late User user;
  final _notification.NotificationBloc notificationBloc =
      _notification.NotificationBloc();
  double latitude = 0;
  double longitude = 0;
  List<Sport> sports = [];
  List<Notification2.Notification> notifications = [];
  ConnectivityResult connectivityResult = ConnectivityResult.none;

 @override
  void initState() {
    super.initState();
    // Inicialización de user y notifications se mueve aquí si requieren el context
    user = BlocProvider.of<AuthenticationBloc>(context).user!;
    notifications = user.notifications!;
  }


  void checkInitialConnectivity() async {
  connectivityResult = await (Connectivity().checkConnectivity());
  //setState(() {}); 

  if (_hasConnectivity) {
    homeBloc.add(FetchSportsRecent(user));
  } else {
    homeBloc.add(FetchSportsUserStorageRecent());
  }
}

    Future<void> _loadWeatherData() async {
      connectivityResult = await (Connectivity().checkConnectivity());
      if (_hasConnectivity) {
        homeBloc.add(FetchSportsRecent(user));
      } else {
        homeBloc.add(FetchSportsUserStorageRecent());
      }
    }

  Future<void> _handleRefresh() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      homeBloc.add(FetchSportsUserStorageRecent());
    } else {
      homeBloc.add(FetchSportsRecent(user));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    ScreenUtil.init(context);
    checkInitialConnectivity();
    return BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is Authenticated) {
            user = state.usuario;
          }
        },
        child: BlocConsumer<HomeBloc, HomeState>(
          bloc: homeBloc,
          listenWhen: (previous, current) => current is HomeActionState,
          buildWhen: (previous, current) => current is! HomeActionState,
          listener: (context, state) {
            if (state is HomeNavigateToNotificationState) {
              BlocProvider.of<GlobalBloc>(context)
                  .add(NavigateToIndexEvent(AppScreens.Notifications.index));
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
              homeBloc.add(SaveSportsUserStorageRecent(state.sports));
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
            return Scaffold(
                backgroundColor: colorScheme.onPrimary,
                body: Center(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await _loadWeatherData(); // Llamamos a la función para cargar datos
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BlocBuilder<AuthenticationBloc, AuthenticationState>(
                            builder: (context, authState) {
                              if (notifications.isNotEmpty) {
                                final title = notifications.isNotEmpty
                                    ? notifications.first.name
                                    : "Go and see your notifications!";

                                return CustomButtonNotifications(
                                  key: UniqueKey(),
                                  title: title,
                                  imageAsset: "assets/arrow_1.png",
                                  onPressed: goToNotifications,
                                );
                              } else {
                                return CustomButtonNotifications(
                                  key: UniqueKey(),
                                  title: "You don't have any notifications",
                                  imageAsset: "assets/arrow_1.png",
                                  onPressed: goToNotifications,
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          Builder(
                              builder: (BuildContext context) {
                                return _hasConnectivity
                                    ? WeatherDisplay(
                                        latitude: latitude,
                                        longitude: longitude,
                                      )
                                    : const Text(
                                        "There's no connection",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.red,
                                        ),
                                      );
                              },
                            ),
                          const SizedBox(height: 16),
                          RefreshIndicator(
                              onRefresh:
                                  _handleRefresh, // La función que se llamará para refrescar
                              child: SingleChildScrollView(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          _buildActionButton(
                                            title: 'Go to field reservation',
                                            imageAsset:
                                                'assets/field_reservation.png',
                                            onPressed: goToFieldReservation,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                        spacing: 16,
                                        runSpacing: 16,
                                        alignment: WrapAlignment.center,
                                        children: sports.map((sport) {
                                          return _buildActionButton2(
                                            title: sport.name,
                                            imageAsset: sport.image!,
                                            onPressed: () =>
                                                goToNewMatch(sport),
                                          );
                                        }).toList(),
                                      )
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ));
          },
        ));
  }

  bool get _hasConnectivity => connectivityResult != ConnectivityResult.none;

  Widget _buildActionButton(
      {required String title,
      required String imageAsset,
      required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 2,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
      ),
      child: SizedBox(
        width: 302,
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

  Widget _buildActionButton2({
    required String title,
    required String imageAsset,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 159,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
          elevation: 2,
        ),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: imageAsset,
              width: 50,
              height: 100,
              placeholder: (context, url) => const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
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
          elevation: 2, // Sin sombra
          padding: EdgeInsets.zero, // Sin relleno interno
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Sin bordes redondeados
          ),
          surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
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
