import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repo/signup_repo.dart';
part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupRepo signupRepo = SignupRepo();

  SignupBloc() : super(SignupInitial()) {
    on<SignupEvent>((event, emit) async {
      if (event is Signup) {
        emit(SignupLoading());
        try {
          await signupRepo.signupUser(
              event.email.trim(), event.password.trim(), event.userName.trim());
          // await signupRepo.createUserDB(FirebaseAuth.instance.currentUser!.uid,
          //     event.userName, event.email, event.phoneNumber);
          emit(SignupSuccess());
        } catch (error) {
          emit(SignupFailed(error.toString()));
        }
      } else if (event is EmailVerify) {
        emit(EmailVerifyLoading());
        try {
          var response = await signupRepo.emailVerify(event.userId);
          emit(EmailVerifySuccess(response));
        } catch (error) {
          emit(EmailVerifyFailed(error.toString()));
        }
      }
    });
  }
}
