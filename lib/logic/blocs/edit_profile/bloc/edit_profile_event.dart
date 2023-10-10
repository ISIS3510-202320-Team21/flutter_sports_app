part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileEvent {}

final class EditProfileInitialEvent extends EditProfileEvent {
  final int userId;
  EditProfileInitialEvent({
    required this.userId,
  });
}

class SubmitUserEvent extends EditProfileEvent {
  final String email;
  final String name;
  final DateTime bornDate;
  final String phoneNumber;
  final String role;
  final String university;
  final String gender;
  final int userId;

  SubmitUserEvent({
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.role,
    required this.university,
    required this.gender,
    required this.bornDate,
    required this.userId
  });
}

class ProfileNavigateEvent extends EditProfileEvent {}