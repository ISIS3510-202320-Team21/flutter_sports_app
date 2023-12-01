import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async'; 

part 'claims_event.dart';
part 'claims_state.dart';

class ClaimsBloc extends Bloc<ClaimsEvent, ClaimsState> {
  ClaimsBloc() : super(ClaimsInitial()) {
    on<ClaimsEvent>((event, emit) {
    });
  }
}
