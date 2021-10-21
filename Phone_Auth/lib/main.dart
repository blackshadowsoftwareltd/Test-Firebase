import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ///
  String? number, otp, verificationId;
  bool isSent = false, isSignedIn = false;

  ///
  FirebaseAuth _auth = FirebaseAuth.instance;

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Auth'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: CupertinoTextField(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                placeholder: 'Phone number',
                onChanged: (text) => number = text,
              ),
            ),
            OutlinedButton(
                onPressed: () async {
                  await _auth.verifyPhoneNumber(
                      phoneNumber: number!,
                      verificationCompleted: (phoneAuthCredential) async {
                        // signInWithPhoneAuthCredential(phoneAuthCredential);
                      },
                      verificationFailed: (verificationFailed) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(verificationFailed.message!)));
                      },
                      codeSent: (verificationId, resendingToken) async {
                        this.verificationId = verificationId;
                        isSent = true;
                        setState(() {});
                      },
                      codeAutoRetrievalTimeout: (verificationId) async {});
                },
                child: const Text('Get OTP')),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CupertinoTextField(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                placeholder: 'OTP',
                onChanged: (text) => otp = text,
              ),
            ),
            OutlinedButton(
                onPressed: () async {
                  PhoneAuthCredential phoneAuthCredential =
                      PhoneAuthProvider.credential(
                          verificationId: verificationId!, smsCode: otp!);
                  signInWithPhoneAuthCredential(phoneAuthCredential);
                },
                child: const Text('Submit'))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.exit_to_app),
          onPressed: () async {
            await _auth.signOut();
            isSignedIn = false;
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('SignedOut')));
          }),
    );
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      ///
      if (authCredential.user != null) {
        print('SignIn Complete\n\n\n');
        print(authCredential.user!.uid);
        print('\n\n\n');

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("SignIn Success")));
        isSignedIn = true;
      }

      ///
    } on FirebaseAuthException catch (e) {
      print(e.message);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }
}
