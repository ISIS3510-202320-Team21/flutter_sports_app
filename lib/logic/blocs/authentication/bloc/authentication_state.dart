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