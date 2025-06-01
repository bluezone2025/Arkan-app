part of 'userprofile_cubit.dart';

abstract class UserprofileState {}

class UserprofileInitial extends UserprofileState {}

class EditProfileLoadingState extends UserprofileState {}

class EditProfileSuccessState extends UserprofileState {}

class EditProfileErrorState extends UserprofileState {
  final String error;
  EditProfileErrorState(this.error);
}

class GetProfileLoadingState extends UserprofileState {}

class GetProfileSuccessState extends UserprofileState {}

class GetProfileErrorState extends UserprofileState {
  final String error;
  GetProfileErrorState(this.error);
}

class ChangePasswordProfileLoadingState extends UserprofileState {}

class ChangePasswordProfileSuccessState extends UserprofileState {}

class ChangePasswordProfileErrorState extends UserprofileState {
  final String error;
  ChangePasswordProfileErrorState(this.error);
}

class GetAllInfoSuccessState extends UserprofileState {}

class GetAllInfoLoadinState extends UserprofileState {}

class GetAllInfoErrorState extends UserprofileState {
  final String error;

  GetAllInfoErrorState(this.error);
}

class GetSingleInfoLoadinState extends UserprofileState {}

class GetSingleInfoSuccessState extends UserprofileState {}

class GetSingleInfoErrorState extends UserprofileState {
  final String error;

  GetSingleInfoErrorState(this.error);
}

class ContactUsLoadinState extends UserprofileState {}

class ContactUsSuccessState extends UserprofileState {}

class ContactUsErrorState extends UserprofileState {
  final String error;

  ContactUsErrorState(this.error);
}
