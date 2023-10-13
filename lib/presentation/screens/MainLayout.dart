import 'package:flutter/material.dart';
import 'package:flutter_app_sports/data/models/sport.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_event.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_state.dart';
import 'package:flutter_app_sports/presentation/screens/editProfile_view.dart';
import 'package:flutter_app_sports/presentation/screens/home_view.dart';
import 'package:flutter_app_sports/presentation/screens/match/my_matches.dart';
import 'package:flutter_app_sports/presentation/screens/match/new_matches_view.dart';
import 'package:flutter_app_sports/presentation/screens/match/sport_match_options_view.dart';
import 'package:flutter_app_sports/presentation/screens/notifications_view.dart';
import 'package:flutter_app_sports/presentation/screens/profile_view.dart';
import 'package:flutter_app_sports/presentation/widgets/CustomBottomNavigationBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum AppScreens {
  Home,
  Matches,
  Profile,
  Notifications,
  EditProfile,
  MyMatches,
  SportMatchOptions,
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

};

final Map<AppScreens, Widget> screenViews = {
  AppScreens.Home: const HomeView(),
  AppScreens.Matches: const NewMatchesView(),
  AppScreens.Profile: const ProfileView(),
  AppScreens.Notifications: const NotificationsView(),
  AppScreens.EditProfile: const EditProfileView(),
  AppScreens.MyMatches: const MyMatches(),
  AppScreens.SportMatchOptions: SportMatchOptionsView(
      sport: Sport(
    id: 1,
    name: "Fútbol",
    image: "https://i.ibb.co/0j3h2ZC/football.png",
  ))
};

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  AppScreens _selectedScreen = AppScreens.Home;

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

    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        if (state is NavigationStateButtons) {
          print(state.selectedIndex);
          _selectedScreen = AppScreens.values[state.selectedIndex];
        }

        if (state is NavigationSportState) {
          
          _selectedScreen = AppScreens.SportMatchOptions;
          print("selected screen sports");
          screenViews[AppScreens.SportMatchOptions] =
              SportMatchOptionsView(sport: state.sport);
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
              preferredSize: Size.fromHeight(0.01 * ScreenUtil().screenHeight),
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
    );
  }
}
