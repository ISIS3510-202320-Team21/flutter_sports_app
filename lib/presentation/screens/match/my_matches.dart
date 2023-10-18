import 'package:flutter/material.dart';
import 'package:flutter_app_sports/logic/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/match/bloc/match_bloc.dart';
import 'package:flutter_app_sports/data/models/match.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyMatches extends StatelessWidget {
  const MyMatches({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final userName = BlocProvider.of<AuthenticationBloc>(context).user?.name;
    final userId = BlocProvider.of<AuthenticationBloc>(context).user?.id;

    return BlocProvider<MatchBloc>(
      create: (context) {
        final matchBloc = MatchBloc();
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
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Matches for $userName',
                      style: TextStyle(
                        fontSize: textTheme.titleLarge?.fontSize,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
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
        margin: const EdgeInsets.all(10),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          title: Text('Match on ${match.sport.name} with ${match.userJoined?.name}'),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text('Status: ${match.status}'),
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
      );
    }).toList();
  }
}
