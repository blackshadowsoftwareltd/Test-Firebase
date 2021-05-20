import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiver/core.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController.addListener(_onSearchChange);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.removeListener(_onSearchChange);
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Search in Firestore'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              // prefixIcon: Icon(Icons.search),
              suffixIcon: Icon(Icons.search),
            ),
          ),
          ListView(
            children: [
              StreamBuilder(
                initialData: Firebase.initializeApp(),
                stream: Firestore.instance
                    .collection('wallpaperImage')
                    .snapshots(),
                builder: (context, snapShot) {
                  if (!snapShot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapShot.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot data =
                              snapShot.data.documents[index];
                          String _imgUrl = data['url'];
                          String _text = data['name'];
                          return Card(
                            child: Column(
                              children: [Text(_text)],
                            ),
                          );
                        });
                  }
                },
              )
            ],
          )
        ],
      ),
    );
  }

  _onSearchChange() {
    print(_searchController.text);
  }
}
