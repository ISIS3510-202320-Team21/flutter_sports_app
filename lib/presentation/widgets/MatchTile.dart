//implement stateless widget that returns a container to display a match
import 'package:flutter/material.dart';
import 'package:flutter_app_sports/data/models/match.dart';
import 'package:flutter_app_sports/logic/blocs/match/bloc/match_bloc.dart';

class MatchTile extends StatelessWidget {
  final Match match;
  final MatchBloc matchBloc;
  const MatchTile(
      {Key? key, required this.match, required this.matchBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    //return a container with the match info
    return InkWell(
      child: Container(
        //add action if container is clicked
        margin: const EdgeInsets.only(top: 7.5, bottom:7.5),
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        decoration: BoxDecoration(
          color: colorScheme.background,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Match of ${match.sport?.name} on the way!",
                      style: TextStyle(
                          fontSize: 20,
                          color: colorScheme.onBackground),
                    ),
                  ),
                  Row(
                    //center children
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //display the date
                      Text(
                        "Status: ",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onBackground),
                      ),
                      Text(
                        match.status,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Image.asset(
              "assets/arrow_1.png",
              width: 40,
              height: 40,
            ),
          ],
        ),
      ),
      onTap: () {
        matchBloc.add(MatchClickedEvent(match: match));
      },
    );
  }
}