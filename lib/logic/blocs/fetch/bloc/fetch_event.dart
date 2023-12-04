import 'package:equatable/equatable.dart';

abstract class FetchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchInitialDataRequested extends FetchEvent {}


// Add other events as necessary
