import 'package:E_comarce_Test/Screen/registerPage.dart';
import 'package:E_comarce_Test/widgetss/customButton.dart';
import 'package:E_comarce_Test/widgetss/customInput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  //default form loading state
  bool _logInFormLoading = false;

//form input field values
  String _logInMail = '';
  String _logInpass = '';

  // focusNode for input field
  FocusNode _passFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _passFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Welcome User,\nLogin to your account',
                    textAlign: TextAlign.center,
                    style: Constants.boldHeading,
                  ),
                ),
                Container(
                  height: 350,
                  // color: Colors.green,
                  padding: EdgeInsets.only(top: 100),
                  child: Column(
                    children: [
                      CustomInput(
                        hintText: 'Enter a valid mail...',
                        levelText: 'Mail',
                        onChanged: (value) {
                          _logInMail = value;
                        },
                        onSubmit: (value) {
                          _passFocusNode.requestFocus();
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      CustomInput(
                        hintText: 'Enter a valid password',
                        levelText: 'Password',
                        onChanged: (value) {
                          _logInpass = value;
                        },
                        focusNode: _passFocusNode,
                        isPassField: true,
                        onSubmit: (value) {
                          _submitForm();
                        },
                      ),
                      CustomButton(
                        text: 'Login',
                        outLineButton: false,
                        isLoading: _logInFormLoading,
                        onPresse: () {
                          _submitForm();
                          print('clicked on login button');
                        },
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: CustomButton(
                    text: 'Create new Account',
                    onPresse: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()));
                      print('Clicked on create an account button');
                    },
                    outLineButton: true,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

// alertDialog for display some error
  Future<void> _alertDialogBuilder(String error) async {
    //built an alert dialog to display some error
    return showDialog(
        context: context,
        barrierColor: Colors.grey[700],
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Container(
              child: Text(error),
            ),
            actions: [
              FlatButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  // create a new user account
  Future<String> _loginAccount() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _logInMail, password: _logInpass);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  void _submitForm() async {
    // setState for loading start
    setState(() {
      _logInFormLoading = true;
    });
    // Run create account method
    String _loginAccountFeedback = await _loginAccount();
    //if the string is not null, we got error  while create account
    if (_loginAccountFeedback != null) {
      _alertDialogBuilder(_loginAccountFeedback);

      // setState for loading off
      setState(() {
        _logInFormLoading = false;
      });
    }
  }
}
