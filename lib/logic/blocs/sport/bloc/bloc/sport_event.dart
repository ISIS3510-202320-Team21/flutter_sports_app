import 'package:equatable/equatable.dart';
import 'package:flutter_app_sports/data/models/sport.dart';

abstract class SportEvent extends Equatable {
  const SportEvent();

  @override
  List<Object> get props => [];
}

class FetchSportsEvent extends SportEvent {}
class FetchSportsStorage extends SportEvent {}

class UpdateSportEvent extends SportEvent {
  final Sport updatedSport;  
  UpdateSportEvent(this.updatedSport);

  @override
  List<Object> get props => [updatedSport];
}

class DeleteSportEvent extends SportEvent {
  final int sportId;
  DeleteSportEvent(this.sportId);

  @override
  List<Object> get props => [sportId];
}

class SaveMatchSportsEvent extends SportEvent {
  final List<Sport> sports;
  SaveMatchSportsEvent(this.sports);

  @override
  List<Object> get props => [sports];
}


