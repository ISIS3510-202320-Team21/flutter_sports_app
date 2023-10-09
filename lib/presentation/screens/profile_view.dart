import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Widget _iconButtonWithBackground(IconData iconData, VoidCallback onPressed) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.all(4.0),
      child: IconButton(
        icon: Icon(
          iconData,
          color: colorScheme.onBackground,
          size: 30, // Aumentado el tamaño para que se vea más grueso
        ),
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: Text(
                'Hello, Profile!',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
          ),
        ],
      ),
    );
  }
}
