import 'package:flutter/material.dart';
import 'package:flutter_app_sports/logic/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_event.dart';
import 'package:flutter_app_sports/logic/blocs/match/bloc/match_bloc.dart';
import 'package:flutter_app_sports/data/models/match.dart';
import 'package:flutter_app_sports/presentation/screens/MainLayout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyMatches extends StatefulWidget {
  const MyMatches({Key? key}) : super(key: key);

  @override
  State<MyMatches> createState() => _MyMatchesState();
}

class _MyMatchesState extends State<MyMatches> {
  List<Match>? matches;
  String? userName;
  int? userId;
  MatchBloc matchBloc = MatchBloc();
  // Aquí puedes inicializar tu lista de partidos.

  @override
  void initState() {
    super.initState();
    userName = BlocProvider.of<AuthenticationBloc>(context).user?.name;
    userId = BlocProvider.of<AuthenticationBloc>(context).user?.id;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    matchBloc.add(FetchMatchesUserEvent(userId!));

    return BlocProvider(
      create: (context) => matchBloc,
      child: BlocConsumer<MatchBloc, MatchState>(
        builder: (context, state) {
          if (state is MatchErrorState) {
            return const Center(child: Text('Error loading match data'));
          } else if (state is MatchLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          // Retorna el Scaffold solo si los datos necesarios están cargados.
          return matches == null
              ? const Center(child: CircularProgressIndicator())
              : Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: colorScheme.onPrimary,
                    elevation: 0,
                    centerTitle:
                        false, // Cambiado a false para alinear a la izquierda
                    title: Padding(
                      padding: const EdgeInsets.all(1),
                      child: Text(
                        'Matches for $userName',
                        style: TextStyle(
                          fontSize: textTheme.headline5?.fontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.black),
                        onPressed: () {
                          BlocProvider.of<GlobalBloc>(context).add(
                              NavigateToIndexEvent(AppScreens.Matches.index));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.black),
                        onPressed: () {
                          matchBloc.add(FetchMatchesUserEvent(userId!));
                        },
                      ),
                    ],
                  ),
                  body: state is MatchLoadingState
                      ? const Center(child: CircularProgressIndicator())
                      : ListView(
                          children: [
                            ..._buildMatchesList(matches!, context,
                                userId: userId)
                          ],
                        ),
                );
        },
        listener: (BuildContext context, MatchState state) {
          // Actualiza la lista de partidos cuando los datos estén cargados.
          if (state is MatchesLoadedForUserState) {
            matches = state.matches;
          } else if (state is MatchDeletedState) {
            matches?.removeWhere((match) => match.id == state.matchId);
            Future.delayed(Duration.zero, () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Match deleted')));
            });
            matchBloc.add(FetchMatchesUserEvent(userId!));
          }
        },
      ),
    );
  }

  List<Widget> _buildMatchesList(List<Match> matches, BuildContext context,
      {int? userId}) {
    // Asigna un valor a cada estado para poder ordenar las coincidencias
    Map<String, int> statusOrder = {
      'Approved': 1,
      'Pending': 2,
      'Finished': 3,
      'Out of Date': 4,
      'Deleted': 5,

    };

    // Ordena las coincidencias basándote en el valor de su estado
    matches.sort((a, b) =>
        (statusOrder[a.status] ?? 99).compareTo(statusOrder[b.status] ?? 99));

    List<Widget> widgets = [];
    String? lastStatus;

    for (var match in matches) {
      if (match.status == 'Deleted') {
        continue;
      }
      // Añade un banner antes de la primera coincidencia de cada categoría
      if (match.status != lastStatus) {
        widgets.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            '${match.status} Matches',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ));
        lastStatus = match.status;
      }

      widgets.add(Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: InkWell(
          onTap: () {
            _onMatchTap(context, match);
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sport: ${match.sport?.name ?? 'Unknown'}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text('Level: ${match.level?.name ?? 'Unknown'}'),
                SizedBox(height: 4),
                Text(
                    'Date: ${DateFormat('dd/MM/yyyy').format(match.date ?? DateTime.now())}'),
                SizedBox(height: 4),
                Text('Time: ${match.time}'),
                SizedBox(height: 4),
                Text('Location: ${match.city}, ${match.court}'),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Status: ${match.status}',
                      style: TextStyle(color: _statusColor(match.status)),
                    ),
                    if (match.status == 'Pending')
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _borrarPartido(match);
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ));
    }

    return widgets;
  }

  void _onMatchTap(BuildContext context, Match match) {
    if (match.status == 'Finished') {
      BlocProvider.of<GlobalBloc>(context)
          .add(NavigateToMatchEvent(match, "Finished"));
    } else if (match.status == 'Approved') {
      BlocProvider.of<GlobalBloc>(context)
          .add(NavigateToMatchEvent(match, "Rate"));
    }
  }

  void _borrarPartido(Match match) {
    matchBloc.add(DeleteMatchEvent(match.id!));
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Approved':
        return const Color(0xFF337E19);
      case 'Pending':
        return const Color(0xFF19647E);
      case 'Out of Date':
        return const Color(0xFFFF0000);
      case 'Finished':
        return const Color(0xFF000000);
      default:
        return Colors.black;
    }
  }
}
