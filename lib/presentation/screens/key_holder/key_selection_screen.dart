import 'package:flutter/material.dart';
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

  late Future<List<KeyModel>> _futureKeys;
  List<KeyModel> _keys = [];
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _futureKeys = _getKeys();
    _futureKeys.then((value) {
      if (mounted) {
        setState(() {
          _keys = value;
        });
      }
    });
  }

  Future<List<KeyModel>> _getKeys() async {
    await Future.delayed(const Duration(seconds: 2));
    return mockedData.map((item) => KeyModel.fromJson(item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Key Selection"),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, foregroundColor: Colors.white),
              onPressed: _selectedIndex == null
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              KeyHolderHomeScreen(
                                  // keyModel: _keys[_selectedIndex!],
                                  ),
                        ),
                      );
                    },
              child: const Text("Next")),
        ),
      ),
      body: FutureBuilder<List<KeyModel>>(
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
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  leading: ClipOval(
                    child: Image.network(
                      key.imgUrl,
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
                  title: Text(key.name),
                  trailing: Radio<int>(
                    value: index,
                    groupValue: _selectedIndex,
                    onChanged: (int? value) {
                      setState(() {
                        _selectedIndex = value;
                      });
                    },
                  ),
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
