import 'package:flutter/material.dart';

enum AppScreens {
  Home,
  Matches,
  Statistics,
  Profile,
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int? selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        border: Border(
          top: BorderSide(
            color: colorScheme.onBackground.withOpacity(0.2),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: AppScreens.values.map((screen) {
          final index = screen.index;
          final isSelected = index == selectedIndex;
          return InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () => onItemTapped(index),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    getIconData(screen),
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onBackground,
                  ),
                  Text(
                    getLabel(screen),
                    style: TextStyle(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData getIconData(AppScreens screen) {
    switch (screen) {
      case AppScreens.Home:
        return Icons.home;
      case AppScreens.Matches:
        return Icons.fast_forward;
      case AppScreens.Statistics:
        return Icons.bar_chart;
      case AppScreens.Profile:
        return Icons.person;
      default:
        throw Exception('Invalid screen');
    }
  }

  String getLabel(AppScreens screen) {
    switch (screen) {
      case AppScreens.Home:
        return 'Home';
      case AppScreens.Matches:
        return 'Matches';
      case AppScreens.Statistics:
        return 'Statistics';
      case AppScreens.Profile:
        return 'Profile';
      default:
        throw Exception('Invalid screen');
    }
  }
}
