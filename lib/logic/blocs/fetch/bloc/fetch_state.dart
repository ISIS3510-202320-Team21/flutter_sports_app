import 'package:equatable/equatable.dart';

abstract class FetchState extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchInitial extends FetchState {}


class LoadedInitialData extends FetchState {
  final List<String> roles;
  final List<String> universities;
  final List<String> genders;

  LoadedInitialData(this.roles, this.universities,this.genders);
}

class DataLoadInProgress extends FetchState {}


class FetchLoadError extends FetchState {
  final String error;
  FetchLoadError(this.error);
}


// Add other states as necessary
