part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/*
Cuando el usuario quiere hacer login con su correo y contraseña
se lanza este evento y el repositorio de autenticacion es llamado para 
completar la acción
*/
class LoginRequested extends AuthenticationEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);
}

/*
Cuando el usuario intenta registrarse como usuario nuevo
se lanza este evento y el repositorio de autenticacion es llamado para 
completar la acción
*/
class SignUpRequested extends AuthenticationEvent {
  final String email;
  final String password;
  // final String birthDate;
  // final String phoneNumber;
  // final String fullName;

  SignUpRequested(this.email, this.password);
}

/*
Cuando el usuario quiere cerrar sesión
se lanza este evento y el repositorio de autenticacion es llamado para 
completar la acción
*/
class SignOutRequested extends AuthenticationEvent {}
