import 'package:bloc/bloc.dart';
import 'package:flutter_app_sports/data/repositories/auth_repository.dart';
import 'fetch_event.dart';
import 'fetch_state.dart';

class FetchBloc extends Bloc<FetchEvent, FetchState> {
  final AuthRepository _authRepository = AuthRepository();

  FetchBloc() : super(FetchInitial()) {
    on<FetchRolesRequested>((event, emit) async {
      emit(RolesLoadInProgress());
      try {
        List<String> roles = await _authRepository.fetchRoles();
        emit(RolesLoadSuccess(roles));
      } catch (e) {
        emit(FetchLoadError(e.toString()));
      }
    });

    on<FetchUniversitiesRequested>((event, emit) async {
      emit(UniversitiesLoadInProgress());
      try {
        List<String> universities = await _authRepository.fetchUniversities();
        emit(UniversitiesLoadSuccess(universities));
      } catch (e) {
        emit(FetchLoadError(e.toString()));
      }
    });

    on<FetchGendersRequested>((event, emit) async {
      emit(GendersLoadInProgress());
      try {
        List<String> genders = await _authRepository.fetchGenders();
        emit(GendersLoadSuccess(genders));
      } catch (e) {
        emit(FetchLoadError(e.toString()));
      }
    });
    
    // ... Handle other events
  }
}
