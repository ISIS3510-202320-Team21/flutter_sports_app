//implement stateless widget that returns a container to display a match
import 'package:flutter/material.dart';
import 'package:flutter_app_sports/data/models/match.dart';
import 'package:flutter_app_sports/logic/blocs/match/bloc/bloc/match_bloc.dart';

import 'SquareIconButton.dart';

class MatchTile extends StatelessWidget {
  final Match match;
  final MatchBloc matchBloc;
  const MatchTile(
      {Key? key, required this.match, required this.matchBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    //return a container with the match info
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: colorScheme.secondary,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SquareIconButton(
                iconData: Icons.add,
                onPressed: () {
                  // Acción para el ícono de notificaciones
                },
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "Match of ${match.sport.name} on the way!",
                style: const TextStyle(
                    fontSize: 18.0,
                    letterSpacing: 1.2),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                "Status: ",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.2),
              ),
              Text(
                match.status,
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.2,
                    color: colorScheme.primary),
              ),
            ],
          ),
        ],
      ),
    );

  }
}