part of 'signup_bloc.dart';

abstract class SignupEvent {}

class Signup extends SignupEvent {
  String email, password, userName,phoneNumber;

  Signup(this.email, this.password, this.userName,this.phoneNumber);
}

class EmailVerify extends SignupEvent {
  String userId;

  EmailVerify(this.userId);
}
