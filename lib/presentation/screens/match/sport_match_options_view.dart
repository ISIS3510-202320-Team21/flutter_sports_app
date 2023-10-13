import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_sports/data/models/sport.dart';
import 'package:flutter_app_sports/logic/blocs/match/bloc/match_bloc.dart';
import 'package:flutter_app_sports/data/models/match.dart';
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
  DateTime? selectedDate;
  final List<String> omittedStatuses = ['Finished', 'Out of Date'];
  @override
  Widget build(BuildContext context) {
    return Provider<MatchBloc>(
      create: (context) => MatchBloc(),
      child: Builder(
        builder: (BuildContext innerContext) {
          innerContext
              .read<MatchBloc>()
              .add(FetchMatchesSportsEvent(widget.sport.id, selectedDate));

          return Scaffold(
            body: BlocBuilder<MatchBloc, MatchState>(
              builder: (context, state) {
                if (state is MatchLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MatchesLoadedForSportState) {
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
                              innerContext.read<MatchBloc>().add(
                                  FetchMatchesSportsEvent(
                                      widget.sport.id, selectedDate));
                            }
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today),
                              const SizedBox(width: 10.0),
                              Text(
                                selectedDate != null
                                    ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                    : 'Selecciona una fecha',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),

                      // Display the matches
// Listado de estados que deseas omitir

// Filtrado de matches
                      ...state.matches
                          .where((match) =>
                              !omittedStatuses.contains(match.status))
                          .map((match) => _buildMatchTile(match))
                          .toList(),

                      ListTile(
                        leading: const Icon(Icons.add_circle, size: 40.0),
                        title: const Text(
                            'Add your preferred times and wait for a match'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Handle the tap action
                        },
                      ),
                    ],
                  );
                } else if (state is MatchErrorState) {
                  return const Center(child: Text('Error loading matches'));
                } else {
                  return Container();
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMatchTile(Match match) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
            match.userCreated.imageUrl ?? 'https://picsum.photos/200'),
      ),
      title: Text(match.userCreated.name),
      subtitle: Text(match.level.name),
      trailing: Text(match.time),
    );
  }
}
