import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/endpoints.dart';
import '../dio_client.dart';

class UserApiProvider {
  final DioClient _dioClient = DioClient();

  Future<Response> addUserDetails(
    String? userId,
    String? userName,
    String? email,
    String? age,
  ) async {
    try {
      final Response response =
          await _dioClient.post(Endpoints.addUserDetails, data: {
        'Id': userId,
        'UserName': userName,
        'Email': email,
        'Age': age,
      });
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> getUserDetails() async {
    try {
      final Response response = await _dioClient.get(Endpoints.getUserDetails);
      return response;
    } catch (error) {
      rethrow;
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
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      var url = Uri.parse(Endpoints.baseUrl + Endpoints.updateUserDetails);

      var request = http.MultipartRequest('PUT', url);
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data'
      });
      request.fields['Id'] = userId;
      if (userName != null) {
        request.fields['UserName'] = userName;
      }

      if (pushNotificationEnabled != null) {
        request.fields['PushNotification'] = pushNotificationEnabled.toString();
      }
      if (emailNotificationEnabled != null) {
        request.fields['EmailNotification'] =
            emailNotificationEnabled.toString();
      }

      if (profilePic != null) {
        request.files.add(
          http.MultipartFile(
            'profilePic',
            File(profilePic.path).readAsBytes().asStream(),
            File(profilePic.path).lengthSync(),
            filename: profilePic.path.split('/').last,
          ),
        );
      }

      http.Response response =
          await http.Response.fromStream(await request.send());
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> deleteUser(String userId) async {
    try {
      await _dioClient.delete('${Endpoints.deleteUser}?userId=$userId');
      return await FirebaseAuth.instance.currentUser?.delete();
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> getAppConfig() async {
    try {
      final Response response = await _dioClient.get(Endpoints.getAppConfig);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> getAllUsers(String searchUser, int limit, int page) async {
    try {
      final Response response = await _dioClient.get(
          '${Endpoints.getAllUsers}?limit=$limit&page=$page&keyword=$searchUser');
      return response;
    } catch (error) {
      rethrow;
    }
  }
}
