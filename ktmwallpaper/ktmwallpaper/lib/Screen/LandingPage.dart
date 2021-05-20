import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ktmwallpaper/Screen/HomePage.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapShot) {
          if (snapShot.hasError) {
            return Scaffold(body: Center(child: Text(snapShot.error)));
          }
          if (snapShot.connectionState == ConnectionState.done) {
            print('<<<<ConnectionState.done>>>>');
            return HomePage();
          } else {
            // ConnectionStatus();
          }

          return Scaffold(
              body: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                Container(
                    margin: EdgeInsets.all(5),
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator()),
                Padding(
                    padding: EdgeInsets.all(5),
                    child: Text('Checking Internet Connection',
                        style: TextStyle(fontSize: 16)))
              ])));
        });
  }

  Future _checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      print('xxxxx');
    }
  }

  Widget progresser() {
    return SpinKitFadingCube(
      color: Colors.deepOrange,
      size: 50.0,
    );
  }
}
