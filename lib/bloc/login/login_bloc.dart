import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate_project/data/model/user_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/model/token_access.dart';
import '../../data/repo/login_repo.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepo loginRepo = LoginRepo();

  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      if (event is Login) {
        emit(LoginLoading());
        try {
          // String? platform;
          // if (Platform.isAndroid) {
          //   platform = 'android';
          // } else if (Platform.isIOS) {
          //   platform = 'ios';
          // }
          // final firebaseMessaging = FirebaseMessaging.instance;
          await loginRepo.loginUser(event.email.trim(), event.password.trim());
          final prefs = await SharedPreferences.getInstance();

          //var fcmToken = await firebaseMessaging.getToken();

          // Mocked user detail
          final mockUser = UserDetail(
            'u12345',
            'john_doe',
            'john.doe@example.com',
            '+15551234567',
            false, // isAdmin
            true, // pushNotification
            false, // emailNotification
            isSelected: true,
          );

          // Mocked token access
          final mockTokenAccess = TokenAccess(
              true,
              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.mockAccessToken123',
              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.mockRefreshToken456',
              mockUser);

          // TokenAccess user = await loginRepo
          //     .getAccessToken(FirebaseAuth.instance.currentUser!.uid);
          TokenAccess user = mockTokenAccess;
          var authToken = user.accessToken;
          var refreshToken = user.refreshToken;
          await prefs.setString('accessToken', authToken!);
          await prefs.setString('refreshToken', refreshToken!);

          if (user.userDetail != null) {
            await prefs.setBool('isLoggedIn', true);
            await prefs.setBool('userRegister', true);
          }
          emit(LoginSuccess(user));
        } catch (error) {
          emit(LoginFailed(error.toString()));
        }
      } else if (event is ValidateOTP) {
        emit(ValidateOTPLoading());
        try {
          await loginRepo.validateOTP(event.userId, event.otp);
          emit(ValidateOTPSuccess());
        } catch (error) {
          emit(ValidateOTPFailed(error.toString()));
        }
      } else if (event is ResendEmailOTP) {
        emit(ResendOTPLoading());
        try {
          await loginRepo.resendOTP(event.userId);
          emit(ResendOTPSuccess());
        } catch (error) {
          emit(ResendOTPFailed(error.toString()));
        }
      }
    });
  }
}
