import 'package:connectivity_plus/connectivity_plus.dart';
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
    // matchBloc.add(FetchMatchesUserEvent(userId!));
  }

  void checkInitialConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      matchBloc.add(FetchMatchesUserStorageRecent());
    } else {
      matchBloc.add(FetchMatchesUserEvent(userId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    checkInitialConnectivity();
    
    matchBloc.add(FetchMatchesUserEvent(userId!));
    return BlocConsumer<MatchBloc, MatchState>(
      bloc: matchBloc,
      listener: (context, state) {
        // Actualiza la lista de partidos cuando los datos estén cargados.
        if (state is MatchesLoadedForUserState) {
          matches = state.matches;
          matchBloc.add(SaveMatchesUserStorageRecent(state.matches));
        } else if (state is MatchDeletedState) {
          matches?.removeWhere((match) => match.id == state.matchId);
          Future.delayed(Duration.zero, () {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Match deleted')));
          });
          matchBloc.add(FetchMatchesUserEvent(userId!));
        }
      },
      builder: (context, state) {
        if (state is MatchLoadingState) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Center(
                  child: CircularProgressIndicator(),
                ),
                Positioned(
                bottom: MediaQuery.of(context).size.height * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
                child: Column(
                  children: [
                    // Espacio entre los botones
                    SizedBox(
                      child: FloatingActionButton(
                        heroTag: "SODUFNSID",
                        backgroundColor: colorScheme.onPrimary,
                        elevation: 2,
                        child: const Icon(Icons.replay, color: Colors.black),
                        onPressed: () {
                          matchBloc.add(FetchMatchesUserEvent(userId!));
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      child: FloatingActionButton(
                        heroTag: "SODUFNSID2",
                        backgroundColor: colorScheme.onPrimary,
                        elevation: 2,
                        child: const Icon(Icons.add, color: Colors.black),
                        onPressed: () {
                          BlocProvider.of<GlobalBloc>(context).add(
                            NavigateToIndexEvent(AppScreens.Matches.index),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
              ],
              ),
          );
        }
        return Scaffold(
          body: Stack(
            children: [
              // Verifica si hay partidos y decide qué widget mostrar
              if (matches != null && matches!.isEmpty)
                const Center(child: Text("You don't have any matches... Yet."))
              else
                ListView(
                  children: [
                    // ...resto de tu código de ListView...
                    if (matches != null)
                      ..._buildMatchesList(matches!, context, userId: userId),
                  ],
                ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
                child: Column(
                  children: [
                    // Espacio entre los botones
                    SizedBox(
                      child: FloatingActionButton(
                        heroTag: "SODUFNSIDasd",
                        backgroundColor: colorScheme.onPrimary,
                        elevation: 2,
                        child: const Icon(Icons.replay, color: Colors.black),
                        onPressed: () {
                          matchBloc.add(FetchMatchesUserEvent(userId!));
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      child: FloatingActionButton(
                        heroTag: "SODUFNSID2asdasdasd",
                        backgroundColor: colorScheme.onPrimary,
                        elevation: 2,
                        child: const Icon(Icons.add, color: Colors.black),
                        onPressed: () {
                          BlocProvider.of<GlobalBloc>(context).add(
                            NavigateToIndexEvent(AppScreens.Matches.index),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 2,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
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
                const SizedBox(height: 4),
                Text('Level: ${match.level?.name ?? 'Unknown'}'),
                const SizedBox(height: 4),
                Text(
                    'Date: ${DateFormat('dd/MM/yyyy').format(match.date ?? DateTime.now())}'),
                const SizedBox(height: 4),
                Text('Time: ${match.time}'),
                const SizedBox(height: 4),
                Text('Location: ${match.city}, ${match.court}'),
                const SizedBox(height: 8),
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
