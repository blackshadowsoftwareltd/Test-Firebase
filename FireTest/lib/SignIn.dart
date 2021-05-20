import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'HomePage.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var mail, pass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In with Gmail Id'),
      ),
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: FlatButton(
                  child: Text('Sign In with Gmail Id'),
                  onPressed: () {
                    signIn();
                    print('pressed');
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future signIn() async {
    final GoogleSignInAccount googleSignInAccount =
        await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    AuthResult result =
        await FirebaseAuth.instance.signInWithCredential(credential);
    FirebaseUser user = result.user;
    if (user != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    user: user,
                  )));
    }
  }
}
