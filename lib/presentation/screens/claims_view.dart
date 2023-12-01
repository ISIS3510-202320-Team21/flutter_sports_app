import 'package:flutter/material.dart';
import 'package:flutter_app_sports/logic/blocs/claims/bloc/claims_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClaimsView extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ClaimsBloc>(
      create: (context) => ClaimsBloc(), // Add the create argument
      child: Scaffold(
        appBar: AppBar(
          title: Text('Claims'),
        ),
      ),
    );

} 
}