import 'package:flutter/material.dart';
import 'package:flutter_boilerplate_project/presentation/screens/key_holder/home_screen.dart';

import '../../data/model/project_details.dart';
import '../../data/model/subtask.dart';
import '../screens/screens.dart';
import './pages_name.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case PageName.splashScreen:
        return _buildMaterialPageRoute(settings, const SplashScreen());
      case PageName.loginScreen:
        return _buildMaterialPageRoute(settings, const LoginScreen());
      case PageName.signupScreen:
        return _buildMaterialPageRoute(settings, const SignUpScreen());
      case PageName.forgetPasswordScreen:
        return _buildMaterialPageRoute(settings, const ForgetPasswordScreen());
      case PageName.emailVerificationScreen:
        var arg = settings.arguments;
        return _buildMaterialPageRoute(
            settings, EmailVerificationScreen(userEmail: arg as String));
      case PageName.emailOTPVerificationScreen:
        // var arg = settings.arguments;
        return _buildMaterialPageRoute(
            settings,
            const EmailOTPVerifyScreen(
                // userDetail: arg == null ? null : arg as UserDetail
                ));
      case PageName.dashBoardScreen:
        var arg = settings.arguments;
        return _buildMaterialPageRoute(
            settings, DashboardScreen(position: arg == null ? 0 : arg as int));
      case PageName.changePasswordScreen:
        return _buildMaterialPageRoute(settings, const ChangePasswordScreen());
      case PageName.createTaskScreen:
        return _buildMaterialPageRoute(settings, const CreateTaskScreen());
      case PageName.introScreen:
        return _buildMaterialPageRoute(settings, const IntroScreen());
      case PageName.loginEntryScreen:
        return _buildMaterialPageRoute(settings, const LoginEntryScreen());
      case PageName.projectListScreen:
        return _buildMaterialPageRoute(settings, const ProjectListScreen());
      case PageName.projectDetailScreen:
        var arg = settings.arguments;
        return _buildMaterialPageRoute(settings,
            ProjectDetailScreen(project: arg is ProjectDetails ? arg : null));
      case PageName.taskListScreen:
        return _buildMaterialPageRoute(settings, const TaskListScreen());
      case PageName.languageScreen:
        return _buildMaterialPageRoute(settings, const LanguageScreen());
      case PageName.projectTaskListScreen:
        var arg = settings.arguments as Map;
        return _buildMaterialPageRoute(
            settings,
            ProjectTaskListScreen(
                isProjectTask: arg['isProjectTask'] == null
                    ? null
                    : arg['isProjectTask'] as bool,
                project: arg['project'] == null
                    ? null
                    : arg['project'] as ProjectDetails));
      case PageName.updateTaskScreen:
        var arg = settings.arguments;
        return _buildMaterialPageRoute(
            settings, UpdateTaskScreen(taskId: arg is String ? arg : null));
      case PageName.updateSubTaskScreen:
        var arg = settings.arguments;
        return _buildMaterialPageRoute(settings,
            UpdateSubtaskScreen(subtasks: arg is SubTasks ? arg : null));
      case PageName.keyHolderHomeScreen:
        return _buildMaterialPageRoute(settings, const KeyHolderHomeScreen());
      default:
        return _buildMaterialPageRoute(settings, const ErrorScreen());
    }
  }

  PageRoute _buildMaterialPageRoute(RouteSettings settings, Widget page) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        });
  }
}
