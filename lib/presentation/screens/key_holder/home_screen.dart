import 'package:flutter/material.dart';

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
      "imgUrl": "https://via.placeholder.com/150/FF0000/FFFFFF?Text=Home"
    },
    {
      "id": 2,
      "name": "Office Keys",
      "imgUrl": "https://via.placeholder.com/150/00FF00/FFFFFF?Text=Office"
    },
    {
      "id": 3,
      "name": "Car Keys",
      "imgUrl": "https://via.placeholder.com/150/0000FF/FFFFFF?Text=Car"
    },
    {
      "id": 4,
      "name": "Shed Keys",
      "imgUrl": "https://via.placeholder.com/150/FFFF00/000000?Text=Shed"
    },
    {
      "id": 5,
      "name": "Mailbox Keys",
      "imgUrl": "https://via.placeholder.com/150/00FFFF/000000?Text=Mail"
    },
    {
      "id": 6,
      "name": "Safe Keys",
      "imgUrl": "https://via.placeholder.com/150/FF00FF/FFFFFF?Text=Safe"
    },
    {
      "id": 7,
      "name": "Storage Keys",
      "imgUrl": "https://via.placeholder.com/150/C0C0C0/000000?Text=Storage"
    }
  ];

  Future<List<Map<String, dynamic>>> _getKeys() async {
    await Future.delayed(const Duration(seconds: 2));
    return mockedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getKeys(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          } else if (snapshot.hasData) {
            final keys = snapshot.data!;
            return ListView.builder(
              itemCount: keys.length,
              itemBuilder: (context, index) {
                final key = keys[index];
                return ListTile(
                  leading: Image.network(key['imgUrl'] as String),
                  title: Text(key['name'] as String),
                );
              },
            );
          } else {
            return const Center(child: Text('No data'));
          }
        },
      ),
      floatingActionButton: SizedBox(
        width: 100,
        height: 100,
        child: FloatingActionButton(
          onPressed: () {},
          child: const Text('SOS', style: TextStyle(fontSize: 24)),
        ),
      ),
    );
  }
}