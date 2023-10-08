part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState extends Equatable {}

/*
Cuando el usuario oprime el boton de login o signin elestado 
pasa a ser primero AuthLoading y luego a autenticado si es exitoso
*/
class AuthLoading extends AuthenticationState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

/*
Cuando el usuario se autentica exitosamente el estado pasa a ser 
autenticado (Authenticated)
*/
class Authenticated extends AuthenticationState {
  //User usuario;
  User usuario;
  String email;

  Authenticated(this.usuario, this.email);

  @override
  List<Object?> get props => [];
}

/*
Este es el estado inicial del bloc, cuando el usuario no esta autenticado
*/
class UnAuthenticated extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

/*
Si un error ocurre el estado pasa a ser AuthError
*/
class AuthError extends AuthenticationState {
  final String error;

  AuthError(this.error);
  @override
  List<Object?> get props => [error];
}

/*
Representa el estado cuando se está cargando la lista de roles
*/
class RolesLoading extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

/*
Representa el estado cuando se ha cargado la lista de roles
*/
class RolesLoaded extends AuthenticationState {
  final List<String> roles;

  RolesLoaded(this.roles);

  @override
  List<Object?> get props => [roles];
}

/*
Representa el estado cuando se está cargando la lista de universidades
*/
class UniversitiesLoading extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

/*
Representa el estado cuando se ha cargado la lista de universidades
*/
class UniversitiesLoaded extends AuthenticationState {
  final List<String> universities;

  UniversitiesLoaded(this.universities);

  @override
  List<Object?> get props => [universities];
}

/*
Representa el estado cuando se está cargando la lista de géneros
*/
class GendersLoading extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

/*
Representa el estado cuando se ha cargado la lista de géneros
*/
class GendersLoaded extends AuthenticationState {
  final List<String> genders;

  GendersLoaded(this.genders);

  @override
  List<Object?> get props => [genders];
}

/*
Representa el estado cuando hay un error al cargar alguna de las listas
*/
class FetchError extends AuthenticationState {
  final String error;

  FetchError(this.error);

  @override
  List<Object?> get props => [error];
}
