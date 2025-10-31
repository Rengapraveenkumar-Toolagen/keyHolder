import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/bloc.dart';
import '../../../data/classes/language_constant.dart';
import '../../../utils/utils.dart';
import '../../routes/pages_name.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class DashboardScreen extends StatefulWidget {
  final int? position;
  const DashboardScreen({super.key, this.position});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 2;
  NavigationBloc? navigationBloc;

  List<Widget>? _widgetOptions = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.position!;
    navigationBloc = BlocProvider.of<NavigationBloc>(context);
    _onItemTapped(_selectedIndex);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      navigationBloc!.add(OnTap(_selectedIndex));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  getCurrentWidget() {
    return _widgetOptions = <Widget>[
      const HomeScreen(),
      const MessageScreen(),
      const TaskListScreen(),
      const ProfileScreen()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) {
            return;
          }
          if (_selectedIndex != 0) {
            _onItemTapped(0);
          } else {
            showAlertWithAction(
                context: context,
                title: translation(context).exit,
                content: translation(context).exitConfirm,
                onPress: () {
                  exit(0);
                });
          }
          return;
        },
        child: Scaffold(
            drawer: const DrawerWidget(),
            appBar: _buildAppBar(),
            backgroundColor: bgColor,
            body: BlocListener<NavigationBloc, NavigationState>(
                bloc: navigationBloc,
                listener: (context, state) {
                  if (state is NavigationIndex) {
                    getCurrentWidget()[state.index];
                  }
                },
                child: BlocBuilder<NavigationBloc, NavigationState>(
                    bloc: navigationBloc,
                    builder: (context, state) {
                      return _buildBodyContent();
                    })),
            bottomNavigationBar: Container(
                color: bgColor,
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(
                          imagePath: 'assets/images/home.png',
                          label: translation(context).home,
                          index: 0),
                      _buildNavItem(
                          imagePath: 'assets/images/message.png',
                          label: translation(context).message,
                          index: 1),
                      _buildNavItem(
                          imagePath: 'assets/images/task.png',
                          label: translation(context).task,
                          index: 2),
                      _buildNavItem(
                          imagePath: 'assets/images/profile.png',
                          label: translation(context).profile,
                          index: 3)
                    ]))));
  }

  Widget showDrawer() {
    return Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Builder(builder: (context) {
          return InkWell(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: CircleAvatar(
                  radius: 25,
                  backgroundColor: lightGreyColor,
                  child: Image.asset('assets/images/square_menu.png',
                      width: 23, height: 23, color: greyBorderColor)));
        }));
  }

  AppBar _buildAppBar() {
    return AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        leading: showDrawer(),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, PageName.projectListScreen);
              },
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              child: Text(translation(context).projects,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500))),
          SizedBox(width: 5.w)
        ]);
  }

  Widget _buildBodyContent() {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(children: [
          _widgetOptions!.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.zero,
                  child:
                      Center(child: _widgetOptions!.elementAt(_selectedIndex)))
              : const SizedBox()
        ]));
  }

  Widget _buildNavItem({
    required String imagePath,
    required String label,
    required int index,
  }) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
        onTap: () => _onItemTapped(index),
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
                color: isSelected ? white : transparent,
                borderRadius: BorderRadius.circular(30)),
            child: Row(children: [
              Container(
                  padding: isSelected
                      ? const EdgeInsets.all(8)
                      : const EdgeInsets.all(15),
                  decoration:
                      const BoxDecoration(color: white, shape: BoxShape.circle),
                  child: Image.asset(imagePath,
                      width: 24,
                      height: 24,
                      color: isSelected ? primaryColor : Colors.grey)),
              if (isSelected)
                Text(label, style: const TextStyle(color: primaryColor))
            ])));
  }
}
