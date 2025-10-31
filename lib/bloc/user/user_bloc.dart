import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/app_config.dart';
import '../../data/model/user_detail.dart';
import '../../data/repo/user_repo.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepo userRepo = UserRepo();

  UserBloc() : super(UserInitial()) {
    on<UserEvent>((event, emit) async {
      if (event is AddUserDetails) {
        emit(AddUserDetailsLoading());
        try {
          UserDetail response = await userRepo.addUserDetails(
              event.userId, event.userName, event.email, event.age);
          emit(AddUserDetailsSuccess(response));
        } catch (error) {
          emit(AddUserDetailsFailed(error.toString()));
        }
      } else if (event is GetUserDetails) {
        emit(GetUserDetailsLoading());
        try {
          UserDetail response = await userRepo.getUserDetails();
          emit(GetUserDetailsSuccess(response));
        } catch (error) {
          emit(GetUserDetailsFailed(error.toString()));
        }
      } else if (event is UpdateUserDetails) {
        emit(UpdateUserDetailsLoading());
        try {
          await userRepo.updateUserDetails(
              event.userId,
              event.userName,
              event.pushNotificationEnabled,
              event.emailNotificationEnabled,
              event.profilePic);
          emit(UpdateUserDetailsSuccess());
        } catch (error) {
          emit(UpdateUserDetailsFailed(error.toString()));
        }
      } else if (event is ChangePasswordEvent) {
        emit(ChangePasswordLoading());
        var result = await UserRepo.changePassword(
            event.currentPassword!, event.newPassword!);
        if (result) {
          emit(ChangePasswordSuccess());
        } else {
          emit(ChangePasswordFailed(
              errorMessage:
                  'The current password is invalid or the user does not have a password.'));
        }
      } else if (event is DeleteUser) {
        emit(UserLoading());
        try {
          await userRepo.deleteUser(event.userId);
          emit(UserDeleteSuccess());
        } catch (err) {
          emit(UserFailed(err.toString()));
        }
      } else if (event is GetAppConfig) {
        emit(UserLoading());
        try {
          AppConfig response = await userRepo.getAppConfig();
          emit(GetAppConfigSuccess(response));
        } catch (err) {
          emit(GetAppConfigFailed(err.toString()));
        }
      } else if (event is GetAllUsers) {
        if (event.page == 1) {
          emit(GetAllUsersLoading());
        }
        try {
          List<UserDetail> users = await userRepo.getAllUsers(
              event.searchUser, event.limit, event.page);
          emit(GetAllUsersSuccess(users));
        } catch (err) {
          emit(GetAllUsersFailed(err.toString()));
        }
      }
    });
  }
}
