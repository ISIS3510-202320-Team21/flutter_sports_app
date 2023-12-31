import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_app_sports/data/models/sport.dart';
import 'package:flutter_app_sports/data/models/user.dart';
import 'package:flutter_app_sports/logic/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_event.dart';
import 'package:flutter_app_sports/logic/blocs/match/bloc/match_bloc.dart';
import 'package:flutter_app_sports/data/models/match.dart';
import 'package:flutter_app_sports/presentation/screens/MainLayout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class SportMatchOptionsView extends StatefulWidget {
  final Sport sport;

  const SportMatchOptionsView({required this.sport, Key? key})
      : super(key: key);

  @override
  _SportMatchOptionsViewState createState() => _SportMatchOptionsViewState();
}

class _SportMatchOptionsViewState extends State<SportMatchOptionsView> {
  int maxdisplayedMatchesCount = 5;
  int quantity = 5;
  DateTime? selectedDate;
  User? user;
  List<Match> matches = [];
  MatchBloc matchBloc = MatchBloc();

  final List<String> omittedStatuses = [
    'Finished',
    'Out of Date',
    'Approved',
    'Deleted'
  ];

  @override
  void initState() {
    super.initState();
    user = BlocProvider.of<AuthenticationBloc>(context).user;
    matchBloc.add(FetchMatchesSportsEvent(widget.sport.id, selectedDate));
  }

  @override
  Widget build(BuildContext context) {
    matchBloc.add(FetchMatchesSportsEvent(widget.sport.id, selectedDate));
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: RefreshIndicator(
        onRefresh: () async {
          matchBloc.add(FetchMatchesSportsEvent(widget.sport.id, selectedDate));
        },
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<MatchBloc, MatchState>(
                bloc: matchBloc,
                builder: (context, state) {
                  if (state is MatchLoadingState) {
                    return const Scaffold(
                        backgroundColor: Colors.white,
                        body: Center(
                          child: CircularProgressIndicator(),
                        ));
                  }
                  var pendingMatches = matches
                      .where((match) =>
                          !omittedStatuses.contains(match.status) &&
                          match.userCreated!.id != user!.id)
                      .toList();

                  return ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2101),
                            );

                            if (pickedDate != null &&
                                pickedDate != selectedDate) {
                              setState(() {
                                selectedDate = pickedDate;
                              });
                              matchBloc.add(FetchMatchesSportsEvent(
                                  widget.sport.id, selectedDate));
                            }
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              suffixIcon: selectedDate != null
                                  ? IconButton(
                                      icon: const Icon(Icons.clear,
                                          size: 20.0, color: Colors.black),
                                      onPressed: () {
                                        setState(() {
                                          selectedDate = null;
                                        });
                                        matchBloc.add(FetchMatchesSportsEvent(
                                            widget.sport.id, null));
                                      },
                                    )
                                  : const Icon(Icons.arrow_drop_down),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.calendar_today, size: 20.0),
                                const SizedBox(width: 10.0),
                                Text(
                                  selectedDate != null
                                      ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                      : 'Select a date',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ...pendingMatches
                          .take(maxdisplayedMatchesCount)
                          .map((match) => _buildMatchTile(match))
                          .toList(),
                      if (pendingMatches.isEmpty)
                        Center(
                          child: Text(
                            'No matches found',
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,),
                          ),
                        ),
                      if (pendingMatches.length > maxdisplayedMatchesCount)
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                // Aumenta la cantidad de partidos mostrados
                                maxdisplayedMatchesCount = min(
                                    maxdisplayedMatchesCount + quantity,
                                    pendingMatches.length);
                              });
                            },
                            child: const Text("Load More Matches"),
                          ),
                        ),
                    ],
                  );
                },
                listener: (BuildContext context, MatchState state) {
                  if (state is MatchesLoadedForSportState) {
                    matches = state.matches;
                  }
                },
              ),
            ),
            Container(
              child: ListTile(
                leading:
                    const Icon(Icons.add_circle, size: 30, color: Colors.black),
                title:
                    const Text('Add your preferred times and wait for a match'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 20.0),
                onTap: () {
                  if (selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a date first!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    BlocProvider.of<GlobalBloc>(context).add(
                        NavigateToPrefferedMatchEvent(
                            widget.sport, selectedDate));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchTile(Match match) {
    String userImage = match.userCreated?.imageUrl ?? '';

    ImageProvider? imageProvider;
    if (userImage.isNotEmpty) {
      // Caso de cadena Base64 o cualquier otra cadena que no esté vacía
      String base64Content = userImage.split(',').last;
      Uint8List bytes = base64.decode(base64Content);
      imageProvider = MemoryImage(bytes);
    } else {
      // Caso de imagen por defecto
      imageProvider = const AssetImage('assets/profile_image.png');
    }

    return InkWell(
      onTap: () => _onMatchSelected(match),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: imageProvider,
        ),
        title: Text(match.userCreated!.name),
        subtitle: Text(match.level!.name),
        trailing: Text(match.time),
      ),
    );
  }

  void _onMatchSelected(Match match) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Match seleccionado: ${match.userCreated!.name}'),
        duration: const Duration(seconds: 2),
      ),
    );
    BlocProvider.of<GlobalBloc>(context)
        .add(NavigateToMatchEvent(match, "Match"));
  }
}
