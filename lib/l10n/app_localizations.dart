import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pt')
  ];

  /// No description provided for @infoTitle.
  ///
  /// In en, this message translates to:
  /// **'Information about you'**
  String get infoTitle;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @dob.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dob;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country/Region'**
  String get country;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @verifyEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify your email'**
  String get verifyEmail;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'LOG IN'**
  String get login;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'SIGN UP'**
  String get signUp;

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAnAccount;

  /// No description provided for @welcomeTo.
  ///
  /// In en, this message translates to:
  /// **'welcome to'**
  String get welcomeTo;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createAccount;

  /// No description provided for @passwordReset.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent'**
  String get passwordReset;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account is created.. please verify your email to login.'**
  String get accountCreated;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter email'**
  String get enterEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @validEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter valid email'**
  String get validEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get enterPassword;

  /// No description provided for @passwordContains.
  ///
  /// In en, this message translates to:
  /// **'Password should contain capital, small letter, number & special character'**
  String get passwordContains;

  /// No description provided for @passwordNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Password not match'**
  String get passwordNotMatch;

  /// No description provided for @selectTerms.
  ///
  /// In en, this message translates to:
  /// **'Select the terms and condition'**
  String get selectTerms;

  /// No description provided for @agreeTo.
  ///
  /// In en, this message translates to:
  /// **'By clicking Sign Up, you agree to our'**
  String get agreeTo;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @termsAnd.
  ///
  /// In en, this message translates to:
  /// **'and that you have read our'**
  String get termsAnd;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Please enter full name'**
  String get enterFullName;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @enterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter current password'**
  String get enterCurrentPassword;

  /// No description provided for @currentPasswordMust.
  ///
  /// In en, this message translates to:
  /// **'Current password should be at least 6 characters'**
  String get currentPasswordMust;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter new password'**
  String get enterNewPassword;

  /// No description provided for @newPasswordMust.
  ///
  /// In en, this message translates to:
  /// **'Password should contain capital, small letter, number & special character'**
  String get newPasswordMust;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @enterConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter confirm password'**
  String get enterConfirmPassword;

  /// No description provided for @newPasswordNotMatch.
  ///
  /// In en, this message translates to:
  /// **'New password and confirm password does not matched'**
  String get newPasswordNotMatch;

  /// No description provided for @passwordChangeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully...'**
  String get passwordChangeSuccess;

  /// No description provided for @continueCaps.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE'**
  String get continueCaps;

  /// No description provided for @otpVerification.
  ///
  /// In en, this message translates to:
  /// **'OTP verification'**
  String get otpVerification;

  /// No description provided for @successful.
  ///
  /// In en, this message translates to:
  /// **'Successful'**
  String get successful;

  /// No description provided for @resendOtpSuccess.
  ///
  /// In en, this message translates to:
  /// **'Resend otp sent successfully'**
  String get resendOtpSuccess;

  /// No description provided for @resendOtpFailed.
  ///
  /// In en, this message translates to:
  /// **'Resend otp sent failed'**
  String get resendOtpFailed;

  /// No description provided for @otpVerifyDesc.
  ///
  /// In en, this message translates to:
  /// **'Please enter the One-Time Password (OTP) to verify your account.'**
  String get otpVerifyDesc;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'An OTP has been sent to'**
  String get otpSentTo;

  /// No description provided for @validate.
  ///
  /// In en, this message translates to:
  /// **'Validate'**
  String get validate;

  /// No description provided for @otpNotRecieved.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t recieve an OTP? '**
  String get otpNotRecieved;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @registrationCompleted.
  ///
  /// In en, this message translates to:
  /// **'Registration completed successfully'**
  String get registrationCompleted;

  /// No description provided for @userUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'User updated successfully'**
  String get userUpdateSuccess;

  /// No description provided for @clickVerifyButton.
  ///
  /// In en, this message translates to:
  /// **'Click the verify email button in the email sent to'**
  String get clickVerifyButton;

  /// No description provided for @noEmailInSpam.
  ///
  /// In en, this message translates to:
  /// **'No email in your inbox or spam folder?'**
  String get noEmailInSpam;

  /// No description provided for @resendVerifyEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend verification email'**
  String get resendVerifyEmail;

  /// No description provided for @emailVerifySent.
  ///
  /// In en, this message translates to:
  /// **'Email verify link sent'**
  String get emailVerifySent;

  /// No description provided for @verifyEmailNote.
  ///
  /// In en, this message translates to:
  /// **'Wrong address? logout and signup with a different email. If you mistyped your email when signing up, you will need to create a new account.'**
  String get verifyEmailNote;

  /// No description provided for @goToLogin.
  ///
  /// In en, this message translates to:
  /// **'GO TO'**
  String get goToLogin;

  /// No description provided for @taskname.
  ///
  /// In en, this message translates to:
  /// **'Task name'**
  String get taskname;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get endDate;

  /// No description provided for @pleaseEnterTaskName.
  ///
  /// In en, this message translates to:
  /// **'Please enter taskname'**
  String get pleaseEnterTaskName;

  /// No description provided for @pleaseEnterDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter description'**
  String get pleaseEnterDescription;

  /// No description provided for @createTask.
  ///
  /// In en, this message translates to:
  /// **'Create Task'**
  String get createTask;

  /// No description provided for @taskPriority.
  ///
  /// In en, this message translates to:
  /// **'Task Priority'**
  String get taskPriority;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Catergory'**
  String get category;

  /// No description provided for @addTeamMembers.
  ///
  /// In en, this message translates to:
  /// **'Add team members'**
  String get addTeamMembers;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @task.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get task;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @hi.
  ///
  /// In en, this message translates to:
  /// **'Hi'**
  String get hi;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get sendCode;

  /// No description provided for @forgotPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'Don\'t worry! It occurs. Please enter the email address linked with your account'**
  String get forgotPasswordMessage;

  /// No description provided for @organize.
  ///
  /// In en, this message translates to:
  /// **'Organize'**
  String get organize;

  /// No description provided for @yourProjects.
  ///
  /// In en, this message translates to:
  /// **'Your Projects'**
  String get yourProjects;

  /// No description provided for @simplifyWorkflows.
  ///
  /// In en, this message translates to:
  /// **'Simplify tasks and workflows'**
  String get simplifyWorkflows;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @letsGet.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get'**
  String get letsGet;

  /// No description provided for @started.
  ///
  /// In en, this message translates to:
  /// **'started'**
  String get started;

  /// No description provided for @everythingsOnePlace.
  ///
  /// In en, this message translates to:
  /// **'Everything you need is in one place'**
  String get everythingsOnePlace;

  /// No description provided for @createAccounts.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccounts;

  /// No description provided for @logintoAccount.
  ///
  /// In en, this message translates to:
  /// **'Login to Account'**
  String get logintoAccount;

  /// No description provided for @collaborate.
  ///
  /// In en, this message translates to:
  /// **'Collaborate'**
  String get collaborate;

  /// No description provided for @easily.
  ///
  /// In en, this message translates to:
  /// **'Easily'**
  String get easily;

  /// No description provided for @workTogether.
  ///
  /// In en, this message translates to:
  /// **'Work together instantly & smoothly'**
  String get workTogether;

  /// No description provided for @boost.
  ///
  /// In en, this message translates to:
  /// **'Boost'**
  String get boost;

  /// No description provided for @productivity.
  ///
  /// In en, this message translates to:
  /// **'Productivity'**
  String get productivity;

  /// No description provided for @connectTools.
  ///
  /// In en, this message translates to:
  /// **'Connect tools, automate workflows'**
  String get connectTools;

  /// No description provided for @changePasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'Update your password to keep your account secure'**
  String get changePasswordMessage;

  /// No description provided for @loginHeading.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginHeading;

  /// No description provided for @loginToContinue.
  ///
  /// In en, this message translates to:
  /// **'Login to continue using the app'**
  String get loginToContinue;

  /// No description provided for @createMyAcc.
  ///
  /// In en, this message translates to:
  /// **'Create my account'**
  String get createMyAcc;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @everythingYouNeed.
  ///
  /// In en, this message translates to:
  /// **'Everything you need is in one place'**
  String get everythingYouNeed;

  /// No description provided for @checkYourEmailAuthorize.
  ///
  /// In en, this message translates to:
  /// **'Check your email for authorize'**
  String get checkYourEmailAuthorize;

  /// No description provided for @checkYourEmailForOTP.
  ///
  /// In en, this message translates to:
  /// **'Check your email for OTP'**
  String get checkYourEmailForOTP;

  /// No description provided for @signupButton.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signupButton;

  /// No description provided for @oops.
  ///
  /// In en, this message translates to:
  /// **'Ooops!'**
  String get oops;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection found'**
  String get noInternet;

  /// No description provided for @checkConnection.
  ///
  /// In en, this message translates to:
  /// **'Check you connection'**
  String get checkConnection;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you need to logout ?'**
  String get logoutConfirm;

  /// No description provided for @projectTitle.
  ///
  /// In en, this message translates to:
  /// **'Project Title'**
  String get projectTitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @createProject.
  ///
  /// In en, this message translates to:
  /// **'Create Project'**
  String get createProject;

  /// No description provided for @projects.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get projects;

  /// No description provided for @enterProjectTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Project title'**
  String get enterProjectTitle;

  /// No description provided for @deleteProject.
  ///
  /// In en, this message translates to:
  /// **'Delete project'**
  String get deleteProject;

  /// No description provided for @doYouWantToDeleteProject.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete this project ?'**
  String get doYouWantToDeleteProject;

  /// No description provided for @deleteTask.
  ///
  /// In en, this message translates to:
  /// **'Delete task'**
  String get deleteTask;

  /// No description provided for @doYouWantToDeleteTask.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete this task ?'**
  String get doYouWantToDeleteTask;

  /// No description provided for @projectName.
  ///
  /// In en, this message translates to:
  /// **'Project name'**
  String get projectName;

  /// No description provided for @pleaseEnterProjectName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a project name'**
  String get pleaseEnterProjectName;

  /// No description provided for @projectDescription.
  ///
  /// In en, this message translates to:
  /// **'Project description'**
  String get projectDescription;

  /// No description provided for @pleaseEnterProjectDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter a project description'**
  String get pleaseEnterProjectDescription;

  /// No description provided for @membersList.
  ///
  /// In en, this message translates to:
  /// **'Members list'**
  String get membersList;

  /// No description provided for @addMember.
  ///
  /// In en, this message translates to:
  /// **'Add Members'**
  String get addMember;

  /// No description provided for @updateProject.
  ///
  /// In en, this message translates to:
  /// **'Update Project'**
  String get updateProject;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @taskName.
  ///
  /// In en, this message translates to:
  /// **'Task name'**
  String get taskName;

  /// No description provided for @enterTaskName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a task name'**
  String get enterTaskName;

  /// No description provided for @taskDescription.
  ///
  /// In en, this message translates to:
  /// **'Task Description'**
  String get taskDescription;

  /// No description provided for @enterTaskDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter a task description'**
  String get enterTaskDescription;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get dueDate;

  /// No description provided for @assignTo.
  ///
  /// In en, this message translates to:
  /// **'Assign to'**
  String get assignTo;

  /// No description provided for @addMembers.
  ///
  /// In en, this message translates to:
  /// **'Add members'**
  String get addMembers;

  /// No description provided for @projectList.
  ///
  /// In en, this message translates to:
  /// **'Project list'**
  String get projectList;

  /// No description provided for @addProject.
  ///
  /// In en, this message translates to:
  /// **'Add project'**
  String get addProject;

  /// No description provided for @addFile.
  ///
  /// In en, this message translates to:
  /// **'Add file'**
  String get addFile;

  /// No description provided for @updateTask.
  ///
  /// In en, this message translates to:
  /// **'Update task'**
  String get updateTask;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @pleaseEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a phone number'**
  String get pleaseEnterPhoneNumber;

  /// No description provided for @noTasksAvailable.
  ///
  /// In en, this message translates to:
  /// **'No tasks available'**
  String get noTasksAvailable;

  /// No description provided for @taskDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Task deleted successfully'**
  String get taskDeletedSuccessfully;

  /// No description provided for @taskUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Task updated successfully'**
  String get taskUpdatedSuccessfully;

  /// No description provided for @taskCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Task created successfully'**
  String get taskCreatedSuccessfully;

  /// No description provided for @noChangesMade.
  ///
  /// In en, this message translates to:
  /// **'No Changes made'**
  String get noChangesMade;

  /// No description provided for @addSubTask.
  ///
  /// In en, this message translates to:
  /// **'Add Sub Task'**
  String get addSubTask;

  /// No description provided for @pleaseEnterSubTaskName.
  ///
  /// In en, this message translates to:
  /// **'Please enter subtask name'**
  String get pleaseEnterSubTaskName;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @exitConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to exit the application?'**
  String get exitConfirm;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @assignToMe.
  ///
  /// In en, this message translates to:
  /// **'Assigned to me'**
  String get assignToMe;

  /// No description provided for @createdByMe.
  ///
  /// In en, this message translates to:
  /// **'Created by me'**
  String get createdByMe;

  /// No description provided for @allTasks.
  ///
  /// In en, this message translates to:
  /// **'All tasks'**
  String get allTasks;

  /// No description provided for @overdueTasks.
  ///
  /// In en, this message translates to:
  /// **'Overdue tasks'**
  String get overdueTasks;

  /// No description provided for @completedTasks.
  ///
  /// In en, this message translates to:
  /// **'Completed tasks'**
  String get completedTasks;

  /// No description provided for @pleaseAssignMember.
  ///
  /// In en, this message translates to:
  /// **'Please assign a member'**
  String get pleaseAssignMember;

  /// No description provided for @pleaseSelectDuedate.
  ///
  /// In en, this message translates to:
  /// **'Please select due date'**
  String get pleaseSelectDuedate;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get accountDeleted;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @accountDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get accountDeleteConfirm;

  /// No description provided for @projectCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Project created successfully'**
  String get projectCreatedSuccessfully;

  /// No description provided for @noProjectsAvailabe.
  ///
  /// In en, this message translates to:
  /// **'No projects available'**
  String get noProjectsAvailabe;

  /// No description provided for @searchUser.
  ///
  /// In en, this message translates to:
  /// **'Search user'**
  String get searchUser;

  /// No description provided for @memberAlreadyInTeam.
  ///
  /// In en, this message translates to:
  /// **'Member already in the team'**
  String get memberAlreadyInTeam;

  /// No description provided for @projectUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Project updated successfully'**
  String get projectUpdatedSuccessfully;

  /// No description provided for @searchProject.
  ///
  /// In en, this message translates to:
  /// **'Search project'**
  String get searchProject;

  /// No description provided for @pleaseSelectProject.
  ///
  /// In en, this message translates to:
  /// **'Please select project'**
  String get pleaseSelectProject;

  /// No description provided for @addProjectMember.
  ///
  /// In en, this message translates to:
  /// **'Add project member'**
  String get addProjectMember;

  /// No description provided for @selectMember.
  ///
  /// In en, this message translates to:
  /// **'Select member'**
  String get selectMember;

  /// No description provided for @pleaseSelectMember.
  ///
  /// In en, this message translates to:
  /// **'Please select member'**
  String get pleaseSelectMember;

  /// No description provided for @proofOfCompletion.
  ///
  /// In en, this message translates to:
  /// **'Proof of completion'**
  String get proofOfCompletion;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get deleted;

  /// No description provided for @projectDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Project deleted successfully'**
  String get projectDeletedSuccessfully;

  /// No description provided for @appSettingConfirm.
  ///
  /// In en, this message translates to:
  /// **'Please give permission in app settings'**
  String get appSettingConfirm;

  /// No description provided for @groupByProject.
  ///
  /// In en, this message translates to:
  /// **'Group by project'**
  String get groupByProject;

  /// No description provided for @searchTask.
  ///
  /// In en, this message translates to:
  /// **'Search task'**
  String get searchTask;

  /// No description provided for @updateSubtask.
  ///
  /// In en, this message translates to:
  /// **'Update Subtask'**
  String get updateSubtask;

  /// No description provided for @subtaskName.
  ///
  /// In en, this message translates to:
  /// **'Subtask name'**
  String get subtaskName;

  /// No description provided for @subtaskDescription.
  ///
  /// In en, this message translates to:
  /// **'Subtask Description'**
  String get subtaskDescription;

  /// No description provided for @enterSubtaskDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter subtask description'**
  String get enterSubtaskDescription;

  /// No description provided for @searchCountry.
  ///
  /// In en, this message translates to:
  /// **'Search country'**
  String get searchCountry;

  /// No description provided for @attachProofofcompletion.
  ///
  /// In en, this message translates to:
  /// **'Please attach proof of complection'**
  String get attachProofofcompletion;

  /// No description provided for @deleteFile.
  ///
  /// In en, this message translates to:
  /// **'Delete file'**
  String get deleteFile;

  /// No description provided for @deleteThisFile.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete this file?'**
  String get deleteThisFile;

  /// No description provided for @deleteSubtask.
  ///
  /// In en, this message translates to:
  /// **'Delete subtask'**
  String get deleteSubtask;

  /// No description provided for @deleteThisSubtask.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete this subtask?'**
  String get deleteThisSubtask;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr', 'it', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
