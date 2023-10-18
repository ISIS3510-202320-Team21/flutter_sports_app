import 'package:flutter/material.dart';
import 'package:flutter_app_sports/data/models/match.dart';
import 'package:flutter_app_sports/data/models/user.dart';
import 'package:flutter_app_sports/logic/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_event.dart';
import 'package:flutter_app_sports/logic/blocs/match/bloc/match_bloc.dart';
import 'package:flutter_app_sports/presentation/screens/MainLayout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class IndividualMatch extends StatefulWidget {
  final Match match;
  const IndividualMatch({Key? key, required this.match}) : super(key: key);

  @override
  _IndividualMatchState createState() => _IndividualMatchState();
}

class _IndividualMatchState extends State<IndividualMatch> {
  User? user;
    @override
  void initState() {
    super.initState();
    user = BlocProvider.of<AuthenticationBloc>(context).user;
  }

  @override
  Widget build(BuildContext context) {
    return Provider<MatchBloc>(
      create: (context) => MatchBloc(),
      child: Builder(
        builder: (BuildContext innerContext) {
          return _buildUI(context);
        },
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    return Scaffold(
      body: BlocListener<MatchBloc, MatchState>(
        listener: (context, state) {
          if (state is MatchCreatedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Match created successfully!')),
            );
          } 
          else if (state is MatchUpdatedMatchState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Match joined successfully!')),
            );
            BlocProvider.of<GlobalBloc>(context).add(NavigateToIndexEvent(AppScreens.Home.index));
          }
          else if (state is MatchErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error loading data')),
            );
          }
        },
        child: BlocBuilder<MatchBloc, MatchState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListTile(
                        leading: Icon(Icons.calendar_today,
                            color: Theme.of(context).colorScheme.primary),
                        title: Text(
                          widget.match.date != null
                              ? DateFormat('dd/MM/yyyy')
                                  .format(widget.match.date!)
                              : "No Date",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text('Date'), // Leyenda
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: widget.match.sport?.image != null
                          ? Image.network(
                              widget.match.sport!.image!,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.sports_tennis,
                              color: Theme.of(context).colorScheme.primary),
                      title: Text(
                        "Sport: ${widget.match.sport!.name}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: Text(
                        "Level: ${widget.match.level!.name}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(''), // Leyenda
                    ),
                    const Divider(),
                    ListTile(
                      title: Text(
                        "Time: ${widget.match.time}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: Text(
                        "Court: ${widget.match.court}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: Text(
                        "City: ${widget.match.city}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: Text(
                        "Created By: ${widget.match.userCreated!.name}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<MatchBloc>(context)
                            .add(addUserToMatchEvent(user!.id, widget.match.id!));
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 30)),
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.primary),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        shadowColor: MaterialStateProperty.all(Colors.black45),
                        elevation: MaterialStateProperty.all(5),
                        overlayColor: MaterialStateProperty.all(Colors.black12),
                      ),
                      child: const Text(
                        "Match!",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
