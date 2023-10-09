import 'package:flutter/material.dart';
import 'package:flutter_app_sports/presentation/widgets/SquareIconButton.dart';

class MatchesView extends StatefulWidget {
  const MatchesView({super.key});

  @override
  _MatchesViewState createState() => _MatchesViewState();
}

class _MatchesViewState extends State<MatchesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: SquareIconButton(
                  iconData: Icons.add,
                  onPressed: () {
                    // Acción para el ícono de notificaciones
                  },
                )),
          ),
        ],
      ),
    );
  }
}
