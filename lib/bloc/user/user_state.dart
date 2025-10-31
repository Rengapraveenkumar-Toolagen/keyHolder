part of 'user_bloc.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class AddUserDetailsLoading extends UserState {
  AddUserDetailsLoading();
}

class AddUserDetailsSuccess extends UserState {
  final UserDetail userDetail;
  AddUserDetailsSuccess(this.userDetail);
}

class AddUserDetailsFailed extends UserState {
  final String errorMessage;
  AddUserDetailsFailed(this.errorMessage);
}

class GetUserDetailsLoading extends UserState {
  GetUserDetailsLoading();
}

class GetUserDetailsSuccess extends UserState {
  final UserDetail userDetail;
  GetUserDetailsSuccess(this.userDetail);
}

class GetUserDetailsFailed extends UserState {
  final String errorMessage;
  GetUserDetailsFailed(this.errorMessage);
}

class UpdateUserDetailsLoading extends UserState {
  UpdateUserDetailsLoading();
}

class UpdateUserDetailsSuccess extends UserState {
  UpdateUserDetailsSuccess();
}

class UpdateUserDetailsFailed extends UserState {
  final String errorMessage;
  UpdateUserDetailsFailed(this.errorMessage);
}

class ChangePasswordLoading extends UserState {
  ChangePasswordLoading();
}

class ChangePasswordSuccess extends UserState {
  ChangePasswordSuccess();
}

class ChangePasswordFailed extends UserState {
  String? errorMessage;
  ChangePasswordFailed({this.errorMessage});
}

class UserLoading extends UserState {
  UserLoading();
}

class UserDeleteSuccess extends UserState {
  UserDeleteSuccess();
}

class UserFailed extends UserState {
  final String errorMessage;
  UserFailed(this.errorMessage);
}

class GetAppConfigSuccess extends UserState {
  final AppConfig appConfig;
  GetAppConfigSuccess(this.appConfig);
}

class GetAppConfigFailed extends UserState {
  final String errorMessage;
  GetAppConfigFailed(this.errorMessage);
}

class GetAllUsersLoading extends UserState {
  GetAllUsersLoading();
}

class GetAllUsersSuccess extends UserState {
  final List<UserDetail> usersList;
  GetAllUsersSuccess(this.usersList);
}

class GetAllUsersFailed extends UserState {
  final String errorMessage;
  GetAllUsersFailed(this.errorMessage);
}
