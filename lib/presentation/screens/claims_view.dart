import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_sports/logic/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_app_sports/logic/blocs/claims/bloc/claims_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClaimsView extends StatelessWidget {

  final _claimController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    final authState = authenticationBloc.state;
    if (authState is Authenticated) {
      final userId = authState.usuario.id;
    return BlocProvider<ClaimsBloc>(
      create: (context) => ClaimsBloc(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Submit your claim',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _claimController, // Utiliza el TextEditingController aquí
                decoration: const InputDecoration(
                  hintText: 'Enter your claim here...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                  onPressed: () {
                    String claimContent = _claimController.text;
                    BlocProvider.of<ClaimsBloc>(context).add(
                      ClaimsSubmitButtonPressedEvent(
                        claimContent: claimContent,
                        userId: userId,
                      ),
                    );
                  },
                child: const Text('Submit'),
              ),
              const SizedBox(height: 16),
              // Aquí puedes manejar la respuesta del envío
              BlocBuilder<ClaimsBloc, ClaimsState>(
                builder: (context, state) {
                  if (state is ClaimsSubmitButtonPressedState && state.isSubmitting) {
                    return const CircularProgressIndicator();
                  } else if (state is ClaimsSubmitSuccessState) {
                    // Muestra un mensaje de éxito aquí
                    return const Text('Claim submitted successfully!');
                  } else if (state is ClaimsSubmitErrorState) {
                    // Muestra un mensaje de error aquí
                    return Text('Error submitting claim: ${state.error}');
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  } else {
    return const Text('You must be logged in to submit a claim.');
  }
  }
}
