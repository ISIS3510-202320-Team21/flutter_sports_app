// Archivo: new_matches_view.dart
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final sportBloc = SportBloc();
        sportBloc.add(FetchSportsEvent());
        return sportBloc;
      },
      child: BlocConsumer<SportBloc, SportState>(
        listener: (context, state) {
          if (state is SportsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error fetching sports')),
            );
          }
        },
        builder: (context, state) {
          if (state is FetchingSports) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          } else if (state is SportsLoaded) {
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: state.sports.length,
                  itemBuilder: (context, index) {
                    final sport = state.sports[index];
                    return Card(
                      elevation: 5,
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
                                  backgroundImage: NetworkImage(sport.image),
                                  radius: 40,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      8.0), // Añade un relleno a la flecha
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
                    );
                  },
                ),
              ),
            );
          }
          return const SizedBox(); // Añadir un estado por defecto
        },
      ),
    );
  }
}
