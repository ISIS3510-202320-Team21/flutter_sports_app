import 'package:equatable/equatable.dart';

abstract class FetchState extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchInitial extends FetchState {}

class RolesLoadInProgress extends FetchState {}

class RolesLoadSuccess extends FetchState {
  final List<String> roles;
  RolesLoadSuccess(this.roles);
}

class UniversitiesLoadInProgress extends FetchState {}

class UniversitiesLoadSuccess extends FetchState {
  final List<String> universities;
  UniversitiesLoadSuccess(this.universities);
}

class GendersLoadInProgress extends FetchState {}

class GendersLoadSuccess extends FetchState {
  final List<String> genders;
  GendersLoadSuccess(this.genders);
}

class FetchLoadError extends FetchState {
  final String error;
  FetchLoadError(this.error);
}

// Add other states as necessary
