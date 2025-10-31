import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/logger.dart';
import '../model/app_config.dart';
import '../model/user_detail.dart';
import '../network/api/dio_exception.dart';
import '../network/api/provider/user_api_provider.dart';

class UserRepo {
  final UserApiProvider _userApiProvider = UserApiProvider();

  Future<UserDetail> addUserDetails(
    String? userId,
    String? userName,
    String? email,
    String? age,
  ) async {
    UserDetail userDetail;
    try {
      var response = await _userApiProvider.addUserDetails(
        userId,
        userName,
        email,
        age,
      );
      var res = response.data as Map<String, dynamic>;
      userDetail = UserDetail.fromMap(res['data']);
      return userDetail;
    } on DioException catch (error) {
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  Future<UserDetail> getUserDetails() async {
    UserDetail userDetails;
    try {
      var response = await _userApiProvider.getUserDetails();
      var res = response.data as Map<String, dynamic>;
      userDetails = UserDetail.fromMap(res['data']);
      return userDetails;
    } on DioException catch (error) {
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  updateUserDetails(
    String userId,
    String? userName,
    bool? pushNotificationEnabled,
    bool? emailNotificationEnabled,
    File? profilePic,
  ) async {
    try {
      var response = await _userApiProvider.updateUserDetails(userId, userName,
          pushNotificationEnabled, emailNotificationEnabled, profilePic);

      return response;
    } on DioException catch (error) {
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  static Future<bool> changePassword(
      String currentPassword, String newPassword) async {
    try {
      final credentials = EmailAuthProvider.credential(
          email: FirebaseAuth.instance.currentUser!.email!,
          password: currentPassword);

      UserCredential? result = await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credentials);

      await result.user!.updatePassword(newPassword);

      return true;
    } on Exception catch (_, e) {
      Logger.printLog(e.toString());
      return false;
    }
  }

  Future<dynamic> deleteUser(String userId) async {
    try {
      var response = await _userApiProvider.deleteUser(userId);
      return response;
    } on DioException catch (error) {
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  Future<AppConfig> getAppConfig() async {
    AppConfig appConfig;
    try {
      var response = await _userApiProvider.getAppConfig();
      var res = response.data as Map<String, dynamic>;
      appConfig = AppConfig.fromMap(res);
      return appConfig;
    } on DioException catch (error) {
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  Future<List<UserDetail>> getAllUsers(
      String searchUser, int limit, int page) async {
    List<UserDetail> users;
    try {
      var response =
          await _userApiProvider.getAllUsers(searchUser, limit, page);
      var res = response.data as Map<String, dynamic>;
      var result = res['data'] as List;
      users = result.map((user) => UserDetail.fromMap(user)).toList();
      return users;
    } on DioException catch (error) {
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }
}
