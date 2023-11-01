import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_sports/data/repositories/user_repository.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/user.dart';
part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  User? get user => state is EditProfileLoadedSuccessState ? (state as EditProfileLoadedSuccessState).user : null;
  List<String> roles = [];
  List<String> universities = [];
  List<String> genders = [];
  int userId = 0;
  EditProfileBloc() : super(EditProfileInitial()) {
    on<EditProfileInitialEvent>(editProfileInitialEvent);
    on<SubmitUserEvent>(submitUserEvent);
    on<ProfileNavigateEvent>(profileNavigateEvent);
  }

  FutureOr<void> editProfileInitialEvent(EditProfileInitialEvent event, Emitter<EditProfileState> emit) async {
    emit(EditProfileLoadingState());
    try {
      User? user = await UserRepository().getInfoUser(userid: event.userId);
      userId = event.userId;
      roles = await UserRepository().getRoles();
      universities = await UserRepository().getUniversities();
      genders = await UserRepository().getGenders();
      emit(EditProfileLoadedSuccessState(user: user!));
    } catch (e) {
      print(e);
      emit(EditProfileErrorState());
    }
  }

  FutureOr<void> submitUserEvent(SubmitUserEvent event, Emitter<EditProfileState> emit) async {
    emit(EditProfileLoadingState());
    try {
      User? usuario = await UserRepository().changeInfo(
        email: event.email,
        name: event.name,
        phoneNumber: event.phoneNumber,
        role: event.role,
        university: event.university,
        bornDate: DateFormat('dd/MM/yy').format(event.bornDate),
        gender: event.gender,
        userid: event.userId
      );
      emit(SubmittedUserActionState());
    } catch (e) {
      print(e);
      emit(EditProfileErrorState());
      emit(SubmissionErrorState(message: e.toString()));
    }
  }

  FutureOr<void> profileNavigateEvent(ProfileNavigateEvent event, Emitter<EditProfileState> emit) {
    print('Go to profile');
    emit(ProfileNavigateActionState());
  }
}
