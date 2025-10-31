import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../bloc/user/user_bloc.dart';
import '../../../../data/classes/language_constant.dart';
import '../../../../utils/colors/colors.dart';
import '../../../routes/pages_name.dart';
import '../../widgets.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  UserBloc? userBloc;
  String? userId;
  String? userName;

  @override
  void initState() {
    userBloc = BlocProvider.of<UserBloc>(context);
    userId = FirebaseAuth.instance.currentUser!.uid;
    userName = FirebaseAuth.instance.currentUser!.displayName;
    super.initState();
  }

  clearPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      bloc: userBloc,
      listener: (context, state) async {
        if (state is UserDeleteSuccess) {
          clearPref();
          Navigator.pushNamedAndRemoveUntil(
              context, PageName.loginScreen, (route) => false);
          showAlertSnackBar(
              context, translation(context).accountDeleted, AlertType.success);
        } else if (state is UserFailed) {
          showAlertSnackBar(context, state.errorMessage, AlertType.error);
        } else if (state is UserLoading) {
          const Loading();
        }
      },
      child: BlocBuilder<UserBloc, UserState>(
        bloc: userBloc,
        builder: (context, state) {
          return _buildDrawer();
        },
      ),
    );
  }

  Widget _buildDrawer() {
    return Container(
        width: MediaQuery.of(context).size.width / 1.25,
        color: white,
        child: Column(children: [
          SizedBox(height: 30.h),
          ListTile(
              leading: const Icon(Icons.person, color: black),
              title: Text(userName!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: black)),
              onTap: () {}),
          ListTile(
              leading: const Icon(Icons.lock_outline, color: black),
              title: Text(
                translation(context).changePassword,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, color: black),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, PageName.changePasswordScreen);
              }),
          ListTile(
              leading: const Icon(Icons.language, color: black),
              title: Text(
                translation(context).language,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, color: black),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, PageName.languageScreen);
              }),
          ListTile(
              leading: const Icon(Icons.logout, color: redTextColor),
              title: Text(translation(context).logout,
                  style: const TextStyle(
                      color: redTextColor, fontWeight: FontWeight.bold)),
              onTap: () async {
                showAlertWithAction(
                    context: context,
                    title: translation(context).logout,
                    content: translation(context).logoutConfirm,
                    onPress: () {
                      _doLogOut(context);
                    });
              }),
          const Spacer(),
          ListTile(
              leading: const Icon(Icons.delete_forever, color: redTextColor),
              title: Text(translation(context).deleteAccount,
                  style: const TextStyle(
                      color: redTextColor, fontWeight: FontWeight.bold)),
              onTap: () async {
                showAlertWithAction(
                    context: context,
                    title: translation(context).deleteAccount,
                    content: translation(context).accountDeleteConfirm,
                    onPress: () {
                      userBloc!.add(DeleteUser(userId!));
                    });
              }),
          SizedBox(height: 10.h)
        ]));
  }

  void _doLogOut(context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await FirebaseAuth.instance.signOut().then((value) {
      sharedPreferences.clear();
      Navigator.pushNamedAndRemoveUntil(
          context, PageName.loginScreen, (route) => false);
    });
  }
}
