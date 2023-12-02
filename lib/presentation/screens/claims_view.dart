import 'package:flutter/material.dart';
import 'package:flutter_app_sports/logic/blocs/claims/bloc/claims_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClaimsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ClaimsBloc>(
      create: (context) => ClaimsBloc(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Subtítulo
              const Text(
                'Submit your claim',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Cuadro de texto
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter your claim here...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              // Botón de envío
              ElevatedButton(
                onPressed: () {
                  // Aquí puedes agregar lógica para enviar el claim
                  //BlocProvider.of<ClaimsBloc>(context).add(
                  // Agrega el evento correspondiente para manejar el envío
                  // Puedes definir tu propio evento en el Bloc
                  //);
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
