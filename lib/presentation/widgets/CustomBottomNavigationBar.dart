import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({super.key, 
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BottomNavigationBar(
      elevation: 0.0,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: colorScheme.onBackground),
          activeIcon: Icon(Icons.home, color: colorScheme.primary),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fast_forward, color: colorScheme.onBackground),
          activeIcon: Icon(Icons.fast_forward, color: colorScheme.primary),
          label: 'Matches',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: colorScheme.onBackground),
          activeIcon: Icon(Icons.person, color: colorScheme.primary),
          label: 'Profile',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onBackground,
      onTap: onItemTapped,
    );
  }
}
