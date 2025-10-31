import 'package:flutter/material.dart';

import '../../../utils/colors/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: bgColor, body: _buildBody());
  }

  Widget _buildBody() {
    return const Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('Home Screen',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: black)),
    ]));
  }
}
