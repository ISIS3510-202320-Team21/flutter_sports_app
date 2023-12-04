import 'package:bloc/bloc.dart';
import 'package:flutter_app_sports/data/repositories/auth_repository.dart';
import 'fetch_event.dart';
import 'fetch_state.dart';

class FetchBloc extends Bloc<FetchEvent, FetchState> {
  final AuthRepository _authRepository = AuthRepository();

  FetchBloc() : super(FetchInitial()) {
    on<FetchInitialDataRequested>((event, emit) async {
      emit(DataLoadInProgress());
      try {
        List<String> roles = await _authRepository.fetchRoles();
        List<String> universities = await _authRepository.fetchUniversities();
        List<String> genders = await _authRepository.fetchGenders();
        
        emit(LoadedInitialData(roles, universities, genders));
      } catch (e) {
        emit(FetchLoadError(e.toString()));
      }
    });


  }
}
