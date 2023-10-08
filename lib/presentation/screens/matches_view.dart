import 'package:flutter/material.dart';
import 'package:flutter_app_sports/presentation/widgets/CustomBottomNavigationBar.dart';

class MatchesView extends StatefulWidget {
  const MatchesView({super.key});

  @override
  _MatchesViewState createState() => _MatchesViewState();
}

class _MatchesViewState extends State<MatchesView> {
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
      body: Stack(
        children: [
          const SafeArea(
            child: Center(
              child: Text(
                'Hello, Matches!',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _iconButtonWithBackground(Icons.add, () {
                // Acción para el ícono de +
              }),
            ),
          ),
        ],
      ),
    );
  }
}
