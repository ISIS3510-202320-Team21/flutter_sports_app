import 'package:flutter/material.dart';

class MatchesView extends StatefulWidget {
  const MatchesView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MatchesViewState createState() => _MatchesViewState();
}

class _MatchesViewState extends State<MatchesView> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _iconButtonWithBackground(IconData iconData, VoidCallback onPressed) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8,
          8.0), 
      child: IconButton(
        icon: Icon(iconData, color: colorScheme.onBackground),
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "MATCHES",
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onBackground,
        ),
        actions: [
          _iconButtonWithBackground(Icons.message, () {
            // Acción para el ícono de mensajes
          }),
          _iconButtonWithBackground(Icons.notifications, () {
            // Acción para el ícono de notificaciones
          }),
        ],
      ),
      body: const SafeArea(
        child: Center(
          child: Text(
            'Hello, Matches!',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: colorScheme.onBackground),
            activeIcon: Icon(Icons.home, color: colorScheme.primary),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: colorScheme.onBackground),
            activeIcon: Icon(Icons.search, color: colorScheme.primary),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: colorScheme.onBackground),
            activeIcon: Icon(Icons.person, color: colorScheme.primary),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onBackground,
        onTap: _onItemTapped,
      ),
    );
  }
}
