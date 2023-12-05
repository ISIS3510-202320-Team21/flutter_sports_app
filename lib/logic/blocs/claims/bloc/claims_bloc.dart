import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async'; 

part 'claims_event.dart';
part 'claims_state.dart';

class ClaimsBloc extends Bloc<ClaimsEvent, ClaimsState> {
  ClaimsBloc() : super(ClaimsInitial());

  @override
  Stream<ClaimsState> mapEventToState(
    ClaimsEvent event,
  ) async* {
    if (event is ClaimsSubmitButtonPressedEvent) {
      // Aquí deberías poner la lógica para enviar el reclamo al backend
      // Puedes acceder al contenido del reclamo con event.claimContent
      try {
        // Lógica de envío al backend aquí
        // Puedes emitir un nuevo estado de éxito si es necesario
        yield ClaimsSubmitSuccessState();
      } catch (error) {
        // Manejo de errores aquí
        // Puedes emitir un nuevo estado de error si es necesario
        yield ClaimsSubmitErrorState(error: error.toString());
      }
    }
  }
}

