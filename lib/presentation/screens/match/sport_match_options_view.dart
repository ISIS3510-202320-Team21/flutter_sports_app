import 'dart:async';

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
  DateTime? selectedDate;
  User? user;
  List<Match> matches = [];

  final List<String> omittedStatuses = ['Finished', 'Out of Date', 'Approved'];

  @override
  void initState() {
    super.initState();
    user = BlocProvider.of<AuthenticationBloc>(context).user;
    BlocProvider.of<MatchBloc>(context)
        .add(FetchMatchesSportsEvent(widget.sport.id, selectedDate));
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MatchBloc>(context)
        .add(FetchMatchesSportsEvent(widget.sport.id, selectedDate));
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () async {
        // Llama al evento para cargar de nuevo las coincidencias
        BlocProvider.of<MatchBloc>(context)
            .add(FetchMatchesSportsEvent(widget.sport.id, selectedDate));
      },
      child: BlocConsumer<MatchBloc, MatchState>(
        builder: (context, state) {
          if (state is MatchLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
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

                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                      BlocProvider.of<MatchBloc>(context).add(
                          FetchMatchesSportsEvent(
                              widget.sport.id, selectedDate));
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Fecha',
                      border: OutlineInputBorder(),
                      suffixIcon: selectedDate != null
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  selectedDate = null;
                                });
                                // También es necesario actualizar los matches ya que la fecha ha cambiado
                                BlocProvider.of<MatchBloc>(context).add(
                                    FetchMatchesSportsEvent(
                                        widget.sport.id, null));
                              },
                            )
                          : Icon(Icons.arrow_drop_down),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today, size: 20.0),
                        const SizedBox(width: 10.0),
                        Text(
                          selectedDate != null
                              ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                              : 'Selecciona una fecha',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ...matches
                  .where((match) =>
                      !omittedStatuses.contains(match.status) &&
                      match.userCreated?.id != user?.id)
                  .map((match) => _buildMatchTile(match))
                  .toList(),
              ListTile(
                leading: const Icon(Icons.add_circle, size: 40.0),
                title:
                    const Text('Add your preferred times and wait for a match'),
                trailing: const Icon(Icons.arrow_forward_ios),
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
            ],
          );
        },
        listener: (BuildContext context, MatchState state) {
          if (state is MatchesLoadedForSportState) {
            matches = state.matches;
          }
        },
      ),
    ));
  }

  Widget _buildMatchTile(Match match) {
    return InkWell(
      onTap: () => _onMatchSelected(match),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(match.userCreated?.imageUrl ??
              'https://thumbs.dreamstime.com/b/vector-de-usuario-redes-sociales-perfil-avatar-predeterminado-retrato-vectorial-del-176194876.jpg'),
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
        duration: Duration(seconds: 2),
      ),
    );
    BlocProvider.of<GlobalBloc>(context)
        .add(NavigateToMatchEvent(match, "Match"));
  }
}
