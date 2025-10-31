import 'package:flutter/material.dart';

class DeliverCodeScreen extends StatefulWidget {
  const DeliverCodeScreen({super.key});

  @override
  State<DeliverCodeScreen> createState() => _DeliverCodeScreenState();
}

class _DeliverCodeScreenState extends State<DeliverCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Active Request"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "Provide this code to delivery agent",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              child: Text("831 094",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}
