import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportsapp/features/match/bloc/match_bloc.dart'; // Asegúrate de importar el BLoC correcto

class MatchPage extends StatefulWidget {
  const MatchPage({Key? key}) : super(key: key);

  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  final MatchBloc matchBloc = MatchBloc();

  @override
  void initState() {
    matchBloc.add(MatchInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MatchBloc, MatchState>(
      bloc: matchBloc,
      listener: (context, state) {
        // Maneja los estados que representan acciones o efectos secundarios aquí.
      },
      builder: (context, state) {
        // Maneja los estados que representan la construcción de la UI aquí.
        if (state is MatchLoadingState) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (state is MatchLoadedState) {
          return Scaffold(
              // Construye tu UI basada en el estado cargado aquí.
              );
        } else if (state is MatchErrorState) {
          return Scaffold(body: Center(child: Text('Error: ${state.message}')));
        }
        return Scaffold(); // Retorna un scaffold vacío como fallback.
      },
    );
  }

  @override
  void dispose() {
    matchBloc.close(); // No olvides cerrar el BLoC cuando se dispose el widget.
    super.dispose();
  }
}
