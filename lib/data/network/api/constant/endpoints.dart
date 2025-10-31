import '../../../../flavor_config/constants/flavors.dart';
import '../../../../flavor_config/flavor_app_config.dart';

class Endpoints {
  Endpoints._();

  // dev base url
  static const String devBaseUrl =
      'https://tasko-webapp-aqe0fhazapbhgsdy.uksouth-01.azurewebsites.net/api';

  // base url
  static const String prodBaseUrl = 'https://proddomain/api';

  // base url
  static String baseUrl = FlavorAppConfig.appFlavor == Flavor.dev
      ? devBaseUrl
      : FlavorAppConfig.appFlavor == Flavor.prod
          ? prodBaseUrl
          : devBaseUrl;

  // image dev base url
  static const String imageDevBaseUrl = 'https://taskost.blob.core.windows.net';

  // image prod base url
  static const String imageProdBaseUrl = 'https://imageproddomain';

  // image base url
  static String imageBaseUrl = FlavorAppConfig.appFlavor == Flavor.dev
      ? imageDevBaseUrl
      : FlavorAppConfig.appFlavor == Flavor.prod
          ? imageProdBaseUrl
          : imageDevBaseUrl;

  // receiveTimeout
  static const Duration receiveTimeout = Duration(seconds: 20);

  // connectTimeout
  static const Duration connectionTimeout = Duration(seconds: 20);

  static const String createUser = '/User/CreateUser';

  static const String getToken = '/Auth/Access';

  static const String getRefreshToken = '/Auth/Refresh';

  static const String resendEmail = '/User/ResendEmailConfirmation';

  static const String validateOTP = '/TwoFactorAuth/verify-otp';

  static const String resendOTP = '/TwoFactorAuth/resend-otp';

  static const String addUserDetails = '/User/CreateUserProfile';

  static const String getUserDetails = '/user/GetUserDetails';

  static const String updateUserDetails = '/user/UpdateUserProfile';

  static const String deleteUser = '/User/DeleteUser';

  static const String getAppConfig = '/AppConfig/GetAppConfig';

  static const String createTask = '/Task/CreateTask';

  static const String updateTask = '/Task/UpdateTask';

  static const String getAllTasks = '/Task/GetAllTasks';

  static const String deleteTask = '/Task/DeleteTask';

  static const String getTaskById = '/Task/GetTaskById';

  static const String getAllUsers = '/User/GetAllUsers';

  static const String getCompletedTasks = '/Task/GetAllCompletedTasks';

  static const String getOverdueTasks = '/Task/GetAllOverDueTaskById';

  static const String getCreatedByMeTasks = '/Task/GetAllCreatedByIdTasks';

  static const String getAssignToMeTasks = '/Task/GetAllAssignedByIdTasks';

  static const String getAllTasksByUserId = '/Task/GetAllTasksByUserId';

  static const String getAllProjects = '/Project/GetAllProjects';

  static const String createProject = '/Project/CreateProject';

  static const String updateProject = '/Project/UpdateProject';

  static const String deleteProject = '/Project/DeleteProject';

  static const String getAllTasksByProject = '/Task/GetAllProjectById';

  static const String getTasksByProjectAndUser =
      '/Task/GetTasksByProjectAndUser';

  static const String getTasksByProject = '/Task/GetTasksByProject';
}
