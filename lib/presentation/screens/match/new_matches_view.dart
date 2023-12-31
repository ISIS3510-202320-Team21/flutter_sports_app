// Archivo: new_matches_view.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sports/logic/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/global_events/bloc/global_event.dart';
import 'package:flutter_app_sports/logic/blocs/sport/bloc/bloc/sport_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/sport/bloc/bloc/sport_event.dart';
import 'package:flutter_app_sports/logic/blocs/sport/bloc/bloc/sport_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewMatchesView extends StatefulWidget {
  const NewMatchesView({Key? key}) : super(key: key);

  @override
  _NewMatchesViewState createState() => _NewMatchesViewState();
}

class _NewMatchesViewState extends State<NewMatchesView> {
  String? userName;
  final sportBloc = SportBloc();

  @override
  void initState() {
    super.initState();
    userName = BlocProvider.of<AuthenticationBloc>(context).user?.name;
    checkInitialConnectivity(sportBloc);
  }

  void checkInitialConnectivity(SportBloc sportBloc) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      sportBloc.add(FetchSportsStorage());
    } else {
      sportBloc.add(FetchSportsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<SportBloc, SportState>(
      bloc: sportBloc,
      listener: (context, state) {
        if (state is SportsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error fetching sports')),
          );
        } else if (state is SportsLoaded) {
          sportBloc.add(SaveMatchSportsEvent(state.sports));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: colorScheme.onPrimary,
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: userName != null ? '$userName' : 'User',
                          style: TextStyle(
                            fontSize: textTheme.titleLarge?.fontSize,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        TextSpan(
                          text:
                              ', please choose one of your sports, or add a new one:',
                          style: TextStyle(
                            fontSize: textTheme.titleLarge?.fontSize,
                            fontWeight: FontWeight.w300,
                            color: colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (state is FetchingSports)
                const Center(child: CircularProgressIndicator())
              else if (state is SportsLoaded)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: state.sports.length,
                    itemBuilder: (context, index) {
                      final sport = state.sports[index];

                      return InkWell(
                        onTap: () {
                          print("Tapped on sport ${sport.name}");
                          BlocProvider.of<GlobalBloc>(context)
                              .add(NavigateToSportEvent(sport));
                        },
                        splashColor: Colors.blueAccent
                            .withOpacity(0.5), // Color de la salpicadura
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 1,
                          surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 8.0,
                                right: 8.0,
                                child: Text(
                                  sport.name,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: CircleAvatar(
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                sport.image!),
                                        radius: 40,
                                        backgroundColor: Colors.transparent,
                                      )),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        alignment: Alignment.bottomRight,
                                        child: const Icon(
                                          Icons.arrow_forward,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                const SizedBox(),
            ],
          ),
        );
      },
    );
  }
}
