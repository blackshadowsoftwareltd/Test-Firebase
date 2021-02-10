import 'package:E_comarce_Test/widgetss/customButton.dart';
import 'package:E_comarce_Test/widgetss/customInput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //default form loading state
  bool _registerFormLoading = false;

//form input field values
  String _registerMail = '';
  String _registerpass = '';

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
                  'Register a new account',
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
                        _registerMail = value;
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
                        _registerpass = value;
                      },
                      focusNode: _passFocusNode,
                      isPassField: true,
                      onSubmit: (value) {
                        _submitForm();
                      },
                    ),
                    CustomButton(
                      text: 'Register',
                      outLineButton: false,
                      isLoading: _registerFormLoading,
                      onPresse: () {
                        _submitForm();
                        print('clicked on Register button');
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: CustomButton(
                  text: 'Already have an Account',
                  onPresse: () {
                    Navigator.pop(context);
                    print('Clicked on Already have an account button');
                  },
                  outLineButton: true,
                ),
              )
            ],
          ),
        ],
      )),
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
  Future<String> _createAccount() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _registerMail, password: _registerpass);
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
      _registerFormLoading = true;
    });
    // Run create account method
    String _createAccountFeedback = await _createAccount();
    //if the string is not null, we got error  while create account
    if (_createAccountFeedback != null) {
      _alertDialogBuilder(_createAccountFeedback);

      // setState for loading off
      setState(() {
        _registerFormLoading = false;
      });
    } else {
      //if String in null, user is logged in, head back to login page.
      Navigator.pop(context);
    }
  }
}
