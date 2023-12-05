import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class IndividualMatch extends StatefulWidget {
  final Match match;
  final String state;
  const IndividualMatch({Key? key, required this.match, required this.state})
      : super(key: key);

  @override
  _IndividualMatchState createState() => _IndividualMatchState();
}

class _IndividualMatchState extends State<IndividualMatch> {
  User? user;
  double? userRating=3;
  bool isUserInMatch = false;
  MatchBloc matchBloc = MatchBloc();

  @override
  void initState() {
    super.initState();
    user = BlocProvider.of<AuthenticationBloc>(context).user;
    isUserInMatch = widget.match.userCreated?.id == user?.id;
  }


@override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    void _showRatingDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Rate the match'),
          content: RatingBar.builder(
            initialRating: 3,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              userRating = rating;
            },
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () {
                matchBloc.add(
                  RateMatchEvent(
                    user: user!,
                    match: widget.match,
                    rating: userRating!,
                  ),
                );
                setState(() {});
                Navigator.of(dialogContext).pop();
              },
            )
          ],
        ),
      );
    }

    ListTile buildListTile(
        {IconData? icon, required String title, String? subtitle}) {
      return ListTile(
        leading: Icon(icon, color: colorScheme.primary),
        title: Text(title, style: theme.textTheme.subtitle1),
        subtitle: subtitle != null ? Text(subtitle) : null,
      );
    }

    Widget buildListTile2({
      IconData? icon,
      required String title,
    }) {
      return ListTile(
        leading: widget.match.sport?.image != null
            ? CachedNetworkImage(
                imageUrl: widget.match.sport!.image!,
                width: 50,
                height: 100,
                placeholder: (context, url) => const Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )
            : Icon(
                icon ?? Icons.sports,
                color: Theme.of(context).colorScheme.primary,
              ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: BlocListener<MatchBloc, MatchState>(
        bloc: matchBloc,
        listener: (context, state) {
          if (state is MatchCreatedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Match created successfully!')),
            );
          } else if (state is MatchUpdatedMatchState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Match joined successfully!')),
            );
            BlocProvider.of<GlobalBloc>(context)
                .add(NavigateToIndexEvent(AppScreens.Home.index));
          } else if (state is MatchFinishedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Match rated successfully!')),
            );
            BlocProvider.of<GlobalBloc>(context)
                .add(NavigateToIndexEvent(AppScreens.Home.index));
          } else if (state is MatchErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error loading data')),
            );
          }
        },
        child: BlocBuilder<MatchBloc, MatchState>(
          bloc: matchBloc,
          builder: (context, state) {
            if (state is MatchLoadingState){
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildListTile(
                      icon: Icons.calendar_today,
                      title: widget.match.date != null
                          ? DateFormat('dd/MM/yyyy').format(widget.match.date!)
                          : "No Date",
                      subtitle: "Date",
                    ),
                    const SizedBox(height: 8),
                    buildListTile2(
                        title: widget.match.sport?.name ?? "Unknown"),
                    buildListTile(
                      icon: Icons.terrain,
                      title: "Level: ${widget.match.level?.name ?? 'Unknown'}",
                    ),
                    buildListTile(
                      icon: Icons.access_time,
                      title: "Time: ${widget.match.time}",
                    ),
                    buildListTile(
                      icon: Icons.place,
                      title: "Court: ${widget.match.court}",
                    ),
                    buildListTile(
                      icon: Icons.location_city,
                      title: "City: ${widget.match.city}",
                    ),
                    buildListTile(
                      icon: Icons.person,
                      title:
                          "Created By: ${widget.match.userCreated?.name ?? "Unknown"}",
                    ),
                    const SizedBox(height: 20),
                    if (widget.state == "Match") ...[
                      ElevatedButton(
                        onPressed: () {
                          matchBloc.add(
                              addUserToMatchEvent(user!.id, widget.match.id!));
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 30)),
                        ),
                        child: const Text(
                          "Match!",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ] else if ((widget.state == "Rate" && isUserInMatch && widget.match.rate1 == null) || (widget.state == "Rate" && !isUserInMatch && widget.match.rate2 == null)) ...[
                      ElevatedButton(
                        onPressed: () => _showRatingDialog(context),
                        child: const Text(
                          "Rate!",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ] else if ((widget.state == "Rate" && (widget.match.rate1 != null || widget.match.rate2 != null))) ...[
                      RatingBar.builder(
                        initialRating: isUserInMatch
                            ? widget.match.rate1 ?? 0
                            : widget.match.rate2 ?? 0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {},
                        ignoreGestures: true,
                      ),
                    ]
                    else if (widget.state == "Finished") ...[
                      RatingBar.builder(
                        initialRating: (widget.match.rate1! + widget.match.rate2!) / 2, 
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {},
                        ignoreGestures: true, // Add this line
                      ),
                    ],
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
