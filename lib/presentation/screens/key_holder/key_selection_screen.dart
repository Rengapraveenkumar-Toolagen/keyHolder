import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boilerplate_project/presentation/screens/key_holder/data.dart';
import 'package:flutter_boilerplate_project/presentation/screens/key_holder/home_screen.dart';
import 'package:flutter_boilerplate_project/presentation/screens/key_holder/key_model.dart';
import 'package:shimmer/shimmer.dart';

class KeySelectionScreen extends StatefulWidget {
  const KeySelectionScreen({super.key});

  @override
  State<KeySelectionScreen> createState() => _KeySelectionScreenState();
}

class _KeySelectionScreenState extends State<KeySelectionScreen> {
  final String defaultImgUrl =
      "https://docs.flutter.dev/assets/images/shared/brand/flutter/logo/flutter-lockup-color.png";

  late Future<List<Map<String, dynamic>>> _futureKeys;

  @override
  void initState() {
    super.initState();
    _futureKeys = _getKeys();
  }

  // Future<List<Map<String, dynamic>>> _getKeys() async {
  //   await Future.delayed(const Duration(seconds: 2));
  //   final String response =
  //       await rootBundle.loadString('assets/data/keys.json');
  //   final parsedList = jsonDecode(response);
  //   final keys = parsedList.map((item) => KeyModel.fromJson(item)).toList();

  //   return keys;
  // }

  Future<List<Map<String, dynamic>>> _getKeys() async {
    await Future.delayed(const Duration(seconds: 2));
    return mockedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Key Selection"),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, foregroundColor: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const KeyHolderHomeScreen(),
                  ),
                );
              },
              child: Text("Next")),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureKeys,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: ListView.builder(
                itemCount: 7,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const CircleAvatar(
                      radius: 25.0,
                      backgroundColor: Colors.white,
                    ),
                    title: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final keys = snapshot.data!;
            return ListView.builder(
              itemCount: keys.length,
              itemBuilder: (context, index) {
                final key = keys[index];
                return ListTile(
                  leading: ClipOval(
                    child: Image.network(
                      key['imgUrl'] as String,
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.network(
                        defaultImgUrl,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                  title: Text(key['name'] as String),
                );
              },
            );
          } else {
            return const Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}
