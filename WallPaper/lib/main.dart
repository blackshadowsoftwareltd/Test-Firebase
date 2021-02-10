import 'package:WallPaper/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// void main() => runApp(MaterialApp(
//       home: HomePage(),
//     ));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class Page extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  String img =
      'https://img.pngio.com/loading-bar-png-vector-clipart-psd-peoplepngcom-loading-png-700_394.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.blue,
        child: GestureDetector(
          child: Hero(
            tag: 'tg',
            child: Image.network(img),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ImgV(
                          i: img,
                        )));
          },
        ),
      ),
    );
  }
}

class ImgV extends StatefulWidget {
  String i;

  ImgV({this.i});

  @override
  _ImgVState createState() => _ImgVState();
}

class _ImgVState extends State<ImgV> {
  @override
  Widget build(BuildContext context) {
    print(widget.i);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.green,
        child: Center(
          child: Hero(
            tag: 'tg',
            child: Image.network(widget.i),
          ),
        ),
      ),
    );
  }
}
