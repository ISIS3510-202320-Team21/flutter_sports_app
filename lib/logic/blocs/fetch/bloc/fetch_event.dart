import 'package:equatable/equatable.dart';

abstract class FetchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchRolesRequested extends FetchEvent {}

class FetchUniversitiesRequested extends FetchEvent {}

class FetchGendersRequested extends FetchEvent {}


// Add other events as necessary
