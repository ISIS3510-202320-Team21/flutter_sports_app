import 'package:flutter/material.dart';
import 'package:flutter_app_sports/presentation/screens/home_view.dart';
import 'package:flutter_app_sports/presentation/screens/matches_view.dart';
import 'package:flutter_app_sports/presentation/screens/profile_view.dart';
import 'package:flutter_app_sports/presentation/widgets/CustomBottomNavigationBar.dart';
import 'package:flutter_app_sports/presentation/widgets/SquareIconButton.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainLayout extends StatefulWidget {
  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  // Lista de títulos para cada vista
  final List<String> _titles = [
    "HOME",
    "MATCHES",
    "MY PROFILE",
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colorScheme.onPrimary,
        elevation: 0.0,
        title: Text(
          _titles[_selectedIndex],  
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
          SquareIconButton(
            iconData: Icons.notifications,
            onPressed: () {
              // Acción para el ícono de notificaciones
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          HomeView(),
          MatchesView(),
          ProfileView(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
