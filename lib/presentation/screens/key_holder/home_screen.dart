import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class KeyHolderHomeScreen extends StatefulWidget {
  const KeyHolderHomeScreen({super.key});

  @override
  State<KeyHolderHomeScreen> createState() => _KeyHolderHomeScreenState();
}

class _KeyHolderHomeScreenState extends State<KeyHolderHomeScreen> {
  final mockedData = [
    {
      "id": 1,
      "name": "Home Keys",
      "imgUrl": "https://picsum.photos/id/1/200/300"
    },
    {
      "id": 2,
      "name": "Office Keys",
      "imgUrl": "https://picsum.photos/id/2/200/300"
    },
    {
      "id": 3,
      "name": "Car Keys",
      "imgUrl": "https://picsum.photos/id/3/200/300"
    },
    {
      "id": 4,
      "name": "Shed Keys",
      "imgUrl": "https://picsum.photos/id/4/200/300"
    },
    {
      "id": 5,
      "name": "Mailbox Keys",
      "imgUrl": "https://picsum.photos/id/5/200/300"
    },
    {
      "id": 6,
      "name": "Safe Keys",
      "imgUrl": "https://picsum.photos/id/6/200/300"
    },
    {
      "id": 7,
      "name": "Storage Keys",
      "imgUrl": "https://picsum.photos/id/7/200/300"
    }
  ];
  final String defaultImgUrl =
      "https://docs.flutter.dev/assets/images/shared/brand/flutter/logo/flutter-lockup-color.png";

  late Future<List<Map<String, dynamic>>> _futureKeys;

  @override
  void initState() {
    super.initState();
    _futureKeys = _getKeys();
  }

  Future<List<Map<String, dynamic>>> _getKeys() async {
    await Future.delayed(const Duration(seconds: 2));
    return mockedData;
  }

  Future<void> _refreshData() async {
    setState(() {
      _futureKeys = _getKeys();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Keys"),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<List<Map<String, dynamic>>>(
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
      ),
      floatingActionButton: SizedBox(
        width: 100,
        height: 100,
        child: ClipOval(
          child: FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () {},
            child: const Text('SOS',
                style: TextStyle(fontSize: 24, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
