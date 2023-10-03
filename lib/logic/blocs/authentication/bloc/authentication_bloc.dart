import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sportsapp/data/models/user.dart';
import 'package:sportsapp/data/repositories/auth_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(UnAuthenticated()) {
    /*
    Maneja el evento que se lanza al oprimir el boton de login
    Emite un estado de carga primero, luego intenta autenticar al usuario
    y en caso de lograrlo emite un estado de Authenticated
    */
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await AuthRepository()
            .signIn(email: event.email, password: event.password);
        User? usuario = await AuthRepository().findUserByEmail(event.email);
        emit(Authenticated(
            usuario!, event.email)); //emite el estado de exito: autenticado
      } catch (e) {
        emit(AuthError(e.toString().replaceAll("Exception: ",
            ""))); //emite el estado de error y muestra el mensaje
        emit(UnAuthenticated()); //vuelve al estado inicial: no autenticado
      }
    });

    /*
    Maneja el evento que se lanza al oprimir el boton de signup
    Emite un estado de carga primero, luego intenta crear el nuevo usuario
    y en caso de lograrlo emite un estado de Authenticated
    */
    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await AuthRepository()
            .signUp(email: event.email, password: event.password
                // fullName: event.fullName,
                // birthDate: event.birthDate,
                // phoneNumber: event.phoneNumber);
                );
      } catch (e) {
        emit(AuthError(e.toString().replaceAll("Exception: ", "")));
        emit(UnAuthenticated());
      }
    });

    /*
    Maneja el evento que se lanza al oprimir el boton de signout
    Y emite un estado de no autenticado
    */
    on<SignOutRequested>((event, emit) async {
      emit(AuthLoading());
      await AuthRepository().signOut();
      emit(UnAuthenticated());
    });
  }
}
