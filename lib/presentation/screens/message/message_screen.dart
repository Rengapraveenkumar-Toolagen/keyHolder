import 'package:flutter/material.dart';

import '../../../utils/colors/colors.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: bgColor, body: _buildBody());
  }

  Widget _buildBody() {
    return const Center(
        child: Text('Message Screen',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24, color: black)));
  }
}
