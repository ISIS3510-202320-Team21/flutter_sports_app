import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_app_sports/data/models/sport.dart';
import 'package:flutter_app_sports/data/models/user.dart';
import 'package:flutter_app_sports/data/repositories/auth_repository.dart';
import 'package:meta/meta.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  User? get user =>
      state is Authenticated ? (state as Authenticated).usuario : null;

  final AuthRepository _authRepository = AuthRepository();
  AuthenticationBloc() : super(UnAuthenticated()) {
    /*
    Maneja el evento que se lanza al oprimir el boton de login
    Emite un estado de carga primero, luego intenta autenticar al usuario
    y en caso de lograrlo emite un estado de Authenticated
    */
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        User? usuario = await _authRepository.signIn(
            email: event.email, password: event.password);
        if (usuario != null) {
          // Convertir el usuario a JSON y almacenarlo
          final prefs = await SharedPreferences.getInstance();
          final userJson = json.encode(usuario.toJson());
          await prefs.setString('user', userJson);
          await prefs.setBool('isLoggedIn', true);
          emit(Authenticated(usuario, event.email));
        } else {
          // Manejar el caso cuando el usuario es nulo
          emit(AuthError("Usuario no encontrado."));
          emit(UnAuthenticated());
        }
      } catch (e) {
        emit(AuthError(e.toString().replaceAll("Exception: ", "")));
        emit(UnAuthenticated());
      }
    });

    on<CheckSession>((event, emit) async {
      emit(AuthLoading());
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (isLoggedIn) {
        // Si está logueado, emite el estado de autenticado
        final userJson = prefs.getString('user');
        final user = User.fromJson(jsonDecode(userJson!));
        emit(Authenticated(user, user.email));
      } else {
        // Si no está logueado, emite el estado de no autenticado
        emit(UnAuthenticated());
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
        User? usuario = await AuthRepository().signUp(
          email: event.email,
          password: event.password,
          name: event.name,
          phoneNumber: event.phoneNumber,
          role: event.role,
          university: event.university,
          bornDate: DateFormat('dd/MM/yy').format(event.bornDate),
          gender: event.gender,
        );
        emit(Authenticated(usuario!, event.email));
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

    on<UpdateUserEvent>((event, emit) async {
      emit(AuthLoading());
      final prefs = await SharedPreferences.getInstance();
      final userJson = json.encode(event.user.toJson());
      await prefs.setString('user', userJson);
      await prefs.setBool('isLoggedIn', true);
      emit(Authenticated(event.user, event.user.email));
    });
  }
}
