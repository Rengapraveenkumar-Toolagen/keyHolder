import 'package:flutter/material.dart';

import '../../../utils/colors/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: bgColor, body: _buildBody());
  }

  Widget _buildBody() {
    return const Center(
        child: Text('Profile Screen',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24, color: black)));
  }
}
