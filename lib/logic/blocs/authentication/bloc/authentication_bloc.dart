import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_app_sports/data/models/user.dart';
import 'package:flutter_app_sports/data/repositories/auth_repository.dart';
import 'package:meta/meta.dart';
import 'package:intl/intl.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  String? _userName;
  int? _userId;
  int? get userId => _userId;
  String? get userName => _userName;
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
        User? usuario = await AuthRepository()
            .signIn(email: event.email, password: event.password);
        _userName = usuario?.name;
        _userId = usuario?.id;
        // Store value to session
        emit(Authenticated(usuario!, event.email));
      } catch (e) {
        emit(AuthError(e.toString().replaceAll("Exception: ", "")));
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

    on<FetchRolesRequested>((event, emit) async {
      emit(RolesLoading());
      try {
        List<String> roles = await _authRepository.fetchRoles();
        emit(RolesLoaded(roles));
      } catch (e) {
        emit(FetchError(e.toString().replaceAll("Exception: ", "")));
      }
    });

    on<FetchUniversitiesRequested>((event, emit) async {
      emit(UniversitiesLoading());
      try {
        List<String> universities = await _authRepository.fetchUniversities();
        emit(UniversitiesLoaded(universities));
      } catch (e) {
        emit(FetchError(e.toString().replaceAll("Exception: ", "")));
      }
    });

    on<FetchGendersRequested>((event, emit) async {
      emit(GendersLoading());
      try {
        List<String> genders = await _authRepository.fetchGenders();
        emit(GendersLoaded(genders));
      } catch (e) {
        emit(FetchError(e.toString().replaceAll("Exception: ", "")));
      }
    });
  }
}