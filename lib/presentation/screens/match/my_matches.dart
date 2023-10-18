import 'package:flutter/material.dart';
import 'package:flutter_app_sports/logic/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_event.dart';
import 'package:flutter_app_sports/logic/blocs/match/bloc/match_bloc.dart';
import 'package:flutter_app_sports/data/models/match.dart';
import 'package:flutter_app_sports/presentation/screens/MainLayout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyMatches extends StatelessWidget {
  const MyMatches({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final userName = BlocProvider.of<AuthenticationBloc>(context).user?.name;
    final userId = BlocProvider.of<AuthenticationBloc>(context).user?.id;
    final MatchBloc matchBloc = MatchBloc();

    return BlocProvider<MatchBloc>(
      create: (context) {
        if (userId != null) {
          matchBloc.add(FetchMatchesUserEvent(userId));
        }
        return matchBloc;
      },
      child: BlocConsumer<MatchBloc, MatchState>(
        listener: (context, state) {
          if (state is MatchErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error loading match data')),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: colorScheme.onPrimary,

              elevation: 0,
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.black),
                  onPressed: () {
                    BlocProvider.of<GlobalBloc>(context).add(NavigateToIndexEvent(AppScreens.Matches.index));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.refresh,
                      color: Colors.black), // Icono de refrescar
                  onPressed: () {
                    if (userId != null) {
                      BlocProvider.of<MatchBloc>(context).add(
                          FetchMatchesUserEvent(
                              userId)); // Disparamos el evento de fetch nuevamente
                    }
                  },
                ),
              ],
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Matches for $userName',
                      style: TextStyle(
                        fontSize: textTheme.headline5?.fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                if (state is MatchLoadingState)
                  const Center(child: CircularProgressIndicator())
                else if (state is MatchesLoadedForUserState)
                  ..._buildMatchesList(state.matches)
                else
                  const SizedBox(),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildMatchesList(List<Match> matches) {
    return matches.map((match) {
      return Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          title: Text(
              match.userJoined?.name == null
                  ? 'Match on ${match.sport?.name}'
                  : 'Match on ${match.sport?.name} with ${match.userJoined?.name}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Status: ${match.status}',
              style: TextStyle(color: _statusColor(match.status)),
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black45),
        ),
      );
    }).toList();
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
