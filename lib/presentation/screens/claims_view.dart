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
                  // Obtener el texto del cuadro de texto
                  String claimContent = ''; // Puedes obtener el texto aquí

                  // Enviar el evento al Bloc
                  BlocProvider.of<ClaimsBloc>(context).add(
                    ClaimsSubmitButtonPressedEvent(claimContent: claimContent),
                  );
                },
                child: const Text('Submit'),
              ),
              SizedBox(height: 16),
              // Manejar la respuesta del envío (opcional)
              BlocBuilder<ClaimsBloc, ClaimsState>(
                builder: (context, state) {
                  if (state is ClaimsSubmitButtonPressedState) {
                    if (state.isSubmitting) {
                      return CircularProgressIndicator();
                    } else {
                      // Puedes mostrar un mensaje de éxito o error aquí según el estado
                      // state.isSubmitting indica si se está enviando o no
                    }
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
