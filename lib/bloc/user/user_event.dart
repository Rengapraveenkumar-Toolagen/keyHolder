part of 'user_bloc.dart';

abstract class UserEvent {}

class AddUserDetails extends UserEvent {
  String userId;
  String? userName;
  String? email;
  String? age;
  AddUserDetails(
    this.userId,
    this.userName,
    this.email,
    this.age,
  );
}

class GetUserDetails extends UserEvent {
  GetUserDetails();
}

class UpdateUserDetails extends UserEvent {
  String userId;
  String? userName;
  bool? pushNotificationEnabled;
  bool? emailNotificationEnabled;
  File? profilePic;

  UpdateUserDetails(this.userId, this.userName, this.pushNotificationEnabled,
      this.emailNotificationEnabled, this.profilePic);
}

class ChangePasswordEvent extends UserEvent {
  String? currentPassword;
  String? newPassword;
  ChangePasswordEvent({this.currentPassword, this.newPassword});
}

class DeleteUser extends UserEvent {
  String userId;
  DeleteUser(this.userId);
}

class GetAppConfig extends UserEvent {
  GetAppConfig();
}

class GetAllUsers extends UserEvent {
  String searchUser;
  int limit;
  int page;
  GetAllUsers(this.searchUser, this.limit, this.page);
}
