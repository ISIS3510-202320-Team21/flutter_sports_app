import 'package:equatable/equatable.dart';
import 'package:flutter_app_sports/data/models/sport.dart';


abstract class SportState extends Equatable {
  const SportState();
  
  @override
  List<Object> get props => [];
}

class SportInitial extends SportState {}

class FetchingSports extends SportState {}  // Estado para cuando se están cargando los deportes

class SportsLoaded extends SportState {
  final List<Sport> sports;
  SportsLoaded(this.sports);
}

class SportsError extends SportState {}

// ... otros estados de carga según sea necesario, por ejemplo:
class UpdatingSport extends SportState {}  // Estado para cuando se está actualizando un deporte
class DeletingSport extends SportState {}
