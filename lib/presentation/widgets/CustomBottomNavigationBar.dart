import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int? selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
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
        children: List.generate(3, (index) {
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
                    getIconData(index),
                    color: isSelected ? colorScheme.primary : colorScheme.onBackground,
                  ),
                  Text(
                    getLabel(index),
                    style: TextStyle(
                      color: isSelected ? colorScheme.primary : colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  IconData getIconData(int index) {
    switch (index) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.fast_forward;
      case 2:
        return Icons.person;
      default:
        throw Exception('Invalid index');
    }
  }

  String getLabel(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Matches';
      case 2:
        return 'Profile';
      default:
        throw Exception('Invalid index');
    }
  }
}
