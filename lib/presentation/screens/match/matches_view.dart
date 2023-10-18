import 'package:flutter/material.dart';
import 'package:flutter_app_sports/logic/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/match/bloc/match_bloc.dart';
import 'package:flutter_app_sports/presentation/widgets/SquareIconButton.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/MatchTile.dart';

class MatchesView extends StatefulWidget {
  const MatchesView({super.key});

  @override
  _MatchesViewState createState() => _MatchesViewState();
}

class _MatchesViewState extends State<MatchesView> {
  final MatchBloc matchBloc = MatchBloc();

  @override
  void initState() {
    int? userId = BlocProvider.of<AuthenticationBloc>(context).user?.id;
    matchBloc.add(MatchInitialEvent(userId: userId!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MatchBloc,MatchState>(
      bloc: matchBloc,
      listenWhen: (previous, current) => current is MatchActionState,
      buildWhen: (previous, current) => current is! MatchActionState,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case MatchLoadingState:
            return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ));
          case MatchLoadedSuccessState:
            final successState = state as MatchLoadedSuccessState;
            return Scaffold(
              body: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SquareIconButton(
                        iconData: Icons.add,
                        onPressed: () {
                          matchBloc.add(NewMatchNavigateEvent());
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: successState.matches.length,
                      itemBuilder: (context, index) {
                        return MatchTile(
                          match: successState.matches[index],
                          matchBloc: matchBloc,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          case MatchErrorState:
            return const Scaffold(body: Center(child: Text('Error')));
          default:
            return const SizedBox();
        }
      },
    );
  }
}
