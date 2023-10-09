import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'match_event.dart';
part 'match_state.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  MatchBloc() : super(MatchInitial()) {
    on<MatchEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
