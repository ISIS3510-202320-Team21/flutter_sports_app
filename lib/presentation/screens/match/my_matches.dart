import 'package:flutter/material.dart';
import 'package:flutter_app_sports/logic/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_event.dart';
import 'package:flutter_app_sports/logic/blocs/match/bloc/match_bloc.dart';
import 'package:flutter_app_sports/data/models/match.dart';
import 'package:flutter_app_sports/presentation/screens/MainLayout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class MyMatches extends StatefulWidget {
  const MyMatches({Key? key}) : super(key: key);

  @override
  State<MyMatches> createState() => _MyMatchesState();
}

class _MyMatchesState extends State<MyMatches> {
  List<Match> matches = [];
  String? userName;
  int? userId;

  @override
  void initState() {
    super.initState();
    userName = BlocProvider.of<AuthenticationBloc>(context).user?.name;
    userId = BlocProvider.of<AuthenticationBloc>(context).user?.id;
    BlocProvider.of<MatchBloc>(context).add(FetchMatchesUserEvent(userId!));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    BlocProvider.of<MatchBloc>(context).add(FetchMatchesUserEvent(userId!));
    return Builder(builder: (BuildContext innerContext) {
      return BlocBuilder<MatchBloc, MatchState>(
        buildWhen: (previous, current) => current is! MatchActionState,
        builder: (context, state) {
          if (state is MatchesLoadedForUserState) {
            matches = state.matches;
            
          } else if (state is MatchErrorState) {
            return const Center(child: Text('Error loading match data'));
          } else if (state is MatchDeletedState) {
            matches.remove(
                matches.firstWhere((match) => match.id == state.matchId));
            Future.delayed(Duration.zero, () {
              ScaffoldMessenger.of(innerContext)
                  .showSnackBar(const SnackBar(content: Text('Match deleted')));
            });
            innerContext.read<MatchBloc>().add(FetchMatchesUserEvent(userId!));
          }
          return Scaffold(
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
                    BlocProvider.of<GlobalBloc>(context)
                        .add(NavigateToIndexEvent(AppScreens.Matches.index));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.black),
                  onPressed: () {
                    BlocProvider.of<MatchBloc>(context)
                        .add(FetchMatchesUserEvent(userId!));
                  },
                ),
              ],
            ),
            body: state is MatchLoadingState
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    children: [
                      ..._buildMatchesList(matches, context, userId: userId)
                    ],
                  ),
          );
        },
      );
    });
  }

  List<Widget> _buildMatchesList(List<Match> matches, BuildContext context,
      {int? userId}) {
    // Asigna un valor a cada estado para poder ordenar las coincidencias
    Map<String, int> statusOrder = {
      'Approved': 1,
      'Pending': 2,
      'Finished': 3,
      'Out of Date': 4,
    };

    // Ordena las coincidencias basándote en el valor de su estado
    matches.sort((a, b) =>
        (statusOrder[a.status] ?? 99).compareTo(statusOrder[b.status] ?? 99));

    List<Widget> widgets = [];
    String? lastStatus;

    for (var match in matches) {
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

      bool isCreatedByCurrentUser = userId == match.userCreated?.id;
      String opponentName = match.userJoined?.name ?? '...';

      widgets.add(Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: Colors.grey[100],
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          title: Text(
            isCreatedByCurrentUser
                ? 'Match on ${match.sport?.name} with $opponentName'
                : 'Match on ${match.sport?.name} with ${match.userCreated?.name}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Status: ${match.status}',
              style: TextStyle(color: _statusColor(match.status)),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (match.status == 'Pending' || match.status == 'Out of Date')
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.black45),
                  onPressed: () {
                    _borrarPartido(match);
                  },
                ),
              const Icon(Icons.arrow_forward_ios, color: Colors.black45),
            ],
          ),
          onTap: () {
            if (match.status == 'Finished') {
              BlocProvider.of<GlobalBloc>(context)
                  .add(NavigateToMatchEvent(match, "Finished"));
            } else if (match.status == 'Approved') {
              BlocProvider.of<GlobalBloc>(context)
                  .add(NavigateToMatchEvent(match, "Rate"));
            }
          },
        ),
      ));
    }

    return widgets;
  }

  void _borrarPartido(Match match) {
    BlocProvider.of<MatchBloc>(context).add(DeleteMatchEvent(match.id!));
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Approved':
        return const Color(0xFF337E19);
      case 'Pending':
        return const Color(0xFF19647E);
      case 'Out of Date':
        return const Color(0xFFFF0000);
      default:
        return Colors.black;
    }
  }
}
