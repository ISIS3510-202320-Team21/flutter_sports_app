import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_sports/data/models/level.dart';
import 'package:flutter_app_sports/data/models/sport.dart';
import 'package:flutter_app_sports/data/models/match.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_event.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_state.dart';
import 'package:flutter_app_sports/presentation/screens/editProfile_view.dart';
import 'package:flutter_app_sports/presentation/screens/home_view.dart';
import 'package:flutter_app_sports/presentation/screens/match/individual_match.dart';
import 'package:flutter_app_sports/presentation/screens/match/my_matches.dart';
import 'package:flutter_app_sports/presentation/screens/match/new_matches_view.dart';
import 'package:flutter_app_sports/presentation/screens/match/prefered_match.dart';
import 'package:flutter_app_sports/presentation/screens/match/sport_match_options_view.dart';
import 'package:flutter_app_sports/presentation/screens/notifications_view.dart';
import 'package:flutter_app_sports/presentation/screens/profile_view.dart';
import 'package:flutter_app_sports/presentation/widgets/CustomBottomNavigationBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'camera_view.dart';

enum AppScreens {
  Home,
  Matches,
  Profile,
  Notifications,
  EditProfile,
  MyMatches,
  SportMatchOptions,
  CameraScreen,
  PreferedMatch,
  MatchDetails
  // Agrega nuevas pantallas aquí
}

final Map<AppScreens, String> screenTitles = {
  AppScreens.Home: "HOME",
  AppScreens.Matches: "NEW MATCH",
  AppScreens.Profile: "MY PROFILE",
  AppScreens.Notifications: "NOTIFICATIONS",
  AppScreens.EditProfile: "EDIT PROFILE",
  AppScreens.MyMatches: "MY MATCHES",
  AppScreens.SportMatchOptions: "MATCH OPTIONS",
  AppScreens.CameraScreen: "CAMERA",
  AppScreens.PreferedMatch: "PREFERED MATCH",
  AppScreens.MatchDetails: "MATCH DETAILS"
};

final Map<AppScreens, Widget> screenViews = {
  AppScreens.Home: const HomeView(),
  AppScreens.Matches: const NewMatchesView(),
  AppScreens.Profile: const ProfileView(),
  AppScreens.Notifications: const NotificationsView(),
  AppScreens.EditProfile: const EditProfileView(),
  AppScreens.MyMatches: MyMatches(),
  AppScreens.SportMatchOptions: SportMatchOptionsView(
      sport: Sport(
    id: 1,
    name: "Fútbol",
    image: "https://i.ibb.co/0j3h2ZC/football.png",
  )),
  AppScreens.CameraScreen: const TakePictureScreen(),
  AppScreens.PreferedMatch: PreferedMatch(
    selectedSport: Sport(
      id: 1,
      name: "Fútbol",
      image: null,
    ),
    selectedDate: DateTime.now(),
  ),
  AppScreens.MatchDetails: IndividualMatch(
    match: Match(
        date: DateTime.now(),
        time: "11:00 - 13:00",
        status: "Pending",
        city: "Bogotá",
        sport: Sport(
          id: 1,
          name: "Fútbol",
          image: null,
        ),
        level: Level(
          id: 1,
          name: "Amateur",
        ),
        userCreated: null,
        court: "xd"),
    state: "",
  )
};

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  AppScreens _selectedScreen = AppScreens.Home;
  final List<AppScreens> _navigationHistory = [];
  final int maxHistoryLength = 2;
  Sport? selectedSport;
  Future<bool> _onWillPop() async {
    if (_selectedScreen == AppScreens.Home) {
      SystemNavigator.pop();
      return false;
    } else if (_navigationHistory.isEmpty || _selectedScreen == AppScreens.Profile || _selectedScreen == AppScreens.Matches) {
      BlocProvider.of<GlobalBloc>(context)
          .add(NavigateToIndexEvent(AppScreens.Home.index));
      return false;
    }else if (_navigationHistory.isNotEmpty &&
        _selectedScreen != AppScreens.Home) {
      setState(() {
        _selectedScreen = _navigationHistory.removeLast();
      });
      else if (_selectedScreen == AppScreens.SportMatchOptions) {
        BlocProvider.of<GlobalBloc>(context).add(
            NavigateToSportEvent(selectedSport!));
        return false;
      }
      BlocProvider.of<GlobalBloc>(context)
          .add(NavigateToIndexEvent(_selectedScreen.index));

      return false;
    }  
    return true;
  }

  Widget iconButtonWithRoundedSquare(
      BuildContext context, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(1.0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onBackground,
            size: 28,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    ScreenUtil.init(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: BlocBuilder<GlobalBloc, GlobalState>(
        builder: (context, state) {
          if (_navigationHistory.length >= maxHistoryLength) {
            _navigationHistory.removeAt(0);
          }

          if (state is NavigationStateButtons) {
            if (_selectedScreen != AppScreens.values[state.selectedIndex]) {
              _navigationHistory.add(_selectedScreen);
            }
            _selectedScreen = AppScreens.values[state.selectedIndex];
            if (_selectedScreen == AppScreens.MyMatches) {
              screenViews[AppScreens.MyMatches] = MyMatches();
            }
          }

          if (state is NavigationSportState) {
            if (_selectedScreen != AppScreens.SportMatchOptions) {
              _navigationHistory.add(_selectedScreen);
            }
            _selectedScreen = AppScreens.SportMatchOptions;
            print("selected screen sports");
            screenViews[AppScreens.SportMatchOptions] =
                SportMatchOptionsView(sport: state.sport);
            selectedSport = state.sport;
          }

          if (state is NavigationPrefferedMatchState) {
            if (_selectedScreen != AppScreens.PreferedMatch) {
              _navigationHistory.add(_selectedScreen);
            }
            _selectedScreen = AppScreens.PreferedMatch;
            print("selected screen preffered match");
            screenViews[AppScreens.PreferedMatch] = PreferedMatch(
                selectedSport: state.sport, selectedDate: state.selectedDate);
          }

          if (state is NavigationMatchState) {
            if (_selectedScreen != AppScreens.MatchDetails) {
              _navigationHistory.add(_selectedScreen);
            }
            _selectedScreen = AppScreens.MatchDetails;
            print("selected screen match details");
            screenViews[AppScreens.MatchDetails] =
                IndividualMatch(match: state.match, state: state.status);
          }

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: colorScheme.onPrimary,
              elevation: 0.0,
              title: Text(
                screenTitles[_selectedScreen]!,
                style: textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onBackground,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                iconButtonWithRoundedSquare(context, Icons.message, () {
                  // Acción para el ícono de mensajes
                }),
                if (_selectedScreen != AppScreens.Notifications)
                  iconButtonWithRoundedSquare(context, Icons.notifications, () {
                    BlocProvider.of<GlobalBloc>(context).add(
                        NavigateToIndexEvent(AppScreens.Notifications.index));
                  }),
              ],
              bottom: PreferredSize(
                preferredSize:
                    Size.fromHeight(0.01 * ScreenUtil().screenHeight),
                child: const SizedBox(),
              ),
            ),
            body: IndexedStack(
              index: _selectedScreen.index,
              children: screenViews.values.toList(),
            ),
            bottomNavigationBar: CustomBottomNavigationBar(
              selectedIndex: _selectedScreen.index,
              onItemTapped: (index) {
                BlocProvider.of<GlobalBloc>(context)
                    .add(NavigateToIndexEvent(index));
              },
            ),
          );
        },
      ),
    );
  }
}
