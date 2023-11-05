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
  final String name;
  final DateTime bornDate;
  final String phoneNumber;
  final String role;
  final String university;
  final String gender;

  SignUpRequested({
    required this.email,
    required this.password,
    required this.name,
    required this.phoneNumber,
    required this.role,
    required this.university,
    required this.gender,
    required this.bornDate,
  });
}

/*
Cuando el usuario quiere cerrar sesión
se lanza este evento y el repositorio de autenticacion es llamado para 
completar la acción
*/
class SignOutRequested extends AuthenticationEvent {}

/*
Cuando se necesita obtener la lista de roles disponibles
se lanza este evento y el repositorio de autenticación es llamado para 
completar la acción
*/


class UpdateUserEvent extends AuthenticationEvent {
  final User user;

  UpdateUserEvent(this.user);
}


