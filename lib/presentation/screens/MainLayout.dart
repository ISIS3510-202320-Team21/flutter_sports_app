import 'package:flutter/material.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_event.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_state.dart';
import 'package:flutter_app_sports/presentation/screens/home_view.dart';
import 'package:flutter_app_sports/presentation/screens/matches_view.dart';
import 'package:flutter_app_sports/presentation/screens/notifications_view.dart';
import 'package:flutter_app_sports/presentation/screens/profile_view.dart';
import 'package:flutter_app_sports/presentation/widgets/CustomBottomNavigationBar.dart';
import 'package:flutter_app_sports/presentation/widgets/SquareIconButton.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class MainLayout extends StatefulWidget {
  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = -1;  // -1 indica que ningún ítem está seleccionado

  final List<String> _titles = [
    "HOME",
    "MATCHES",
    "MY PROFILE",
    "NOTIFICATIONS",
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    ScreenUtil.init(context);

    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        if (state is NavigationStateButtons) {
          _selectedIndex = state.selectedIndex;
        }

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: colorScheme.onPrimary,
            elevation: 0.0,
            title: Text(
              _titles[_selectedIndex >= 0 ? _selectedIndex : 3],  // Usar el índice 3 (NOTIFICATIONS) si ningún ítem está seleccionado
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
            toolbarHeight: 0.1 * ScreenUtil().screenHeight,
            iconTheme: IconThemeData(
              color: colorScheme.onBackground,
            ),
            actions: [
              SquareIconButton(
                iconData: Icons.message,
                onPressed: () {
                  // Acción para el ícono de mensajes
                },
              ),
              if (_selectedIndex != 3)  // Mostrar el ícono de notificaciones solo si no estamos en la pantalla de notificaciones
                SquareIconButton(
                  iconData: Icons.notifications,
                  onPressed: () {
                    BlocProvider.of<GlobalBloc>(context)
                        .add(NavigateToIndexEvent(3));  
                  },
                ),
            ],
          ),
          body: IndexedStack(
            index: _selectedIndex >= 0 ? _selectedIndex : 3,  // Usar el índice 3 (NOTIFICATIONS) si ningún ítem está seleccionado
            children: const [
              HomeView(),
              MatchesView(),
              ProfileView(),
              NotificationsView(),
            ],
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            selectedIndex: _selectedIndex,
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
