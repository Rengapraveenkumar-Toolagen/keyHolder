import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/colors/colors.dart';
import '../../routes/pages_name.dart';
import '../../widgets/common/loading.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool animate = false;
  bool? isLoggedIn;
  bool? isUserRegistered;

  @override
  void initState() {
    FocusManager.instance.primaryFocus?.unfocus();
    _startAnimation(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: bgColor,
        body: Stack(alignment: Alignment.center, children: [Loading()]));
  }

  Future<void> _navigateNextScreen(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getBool('isLoggedIn');
    isUserRegistered = prefs.getBool('userRegister');
    if (isLoggedIn != null &&
        isLoggedIn! &&
        isUserRegistered != null &&
        isUserRegistered!) {
      Navigator.pushReplacementNamed(context, PageName.dashBoardScreen,
          arguments: 2);
    } else if ((isLoggedIn != null && !isLoggedIn!) ||
        (isUserRegistered != null && !isUserRegistered!)) {
      Navigator.pushReplacementNamed(context, PageName.loginScreen);
    } else {
      Navigator.pushReplacementNamed(context, PageName.introScreen);
    }
  }

  void _startAnimation(context) async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      animate = true;
    });
    await Future.delayed(const Duration(milliseconds: 2000));
    _navigateNextScreen(context);
  }
}
