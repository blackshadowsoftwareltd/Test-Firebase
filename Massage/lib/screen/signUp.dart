import 'package:Massage/services/service.dart';
import 'package:Massage/widget/appBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  Authenticators _authenticator = new Authenticators();
  String email, pass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context),
        body: ListView(
            // padding: EdgeInsets.all(10),
            children: [
              Container(
                height: 450,
                // color: Colors.green,
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        height: 250,
                        // color: Colors.grey,
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.all(10),
                        child: Form(
                          key: formKey,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextFormField(
                                    validator: (value) {
                                      return value.isEmpty || value.length < 3
                                          ? 'Fill up me at last 3 characters'
                                          : null;
                                    },
                                    controller: nameController,
                                    style: simpleTextFieldStyle(20),
                                    decoration:
                                        textFieldInputDecoration('Full Name')),
                                TextFormField(
                                    validator: (value) {
                                      return RegExp(
                                                  "/^WS{1,2}:\/\/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:56789/i")
                                              .hasMatch(value)
                                          ? null
                                          : 'Please provide a valid Email';
                                    },
                                    controller: emailController,
                                    style: simpleTextFieldStyle(20),
                                    decoration:
                                        textFieldInputDecoration('Email')),
                                TextFormField(
                                  validator: (value) {
                                    return value.length > 6
                                        ? null
                                        : 'Please provide a valid password';
                                  },
                                  obscureText: true,
                                  controller: passController,
                                  style: simpleTextFieldStyle(20),
                                  decoration:
                                      textFieldInputDecoration('Password'),
                                )
                              ]),
                        )),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerRight,
                      // child: Text('Forgot Password!',
                      //     style: simpleTextFieldStyle(16)),
                    ),
                    Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            signUpMe();
                          },
                          child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width - 20,
                              // color: Colors.white,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.lightBlueAccent,
                                        Colors.blueAccent
                                      ]),
                                  borderRadius: BorderRadius.circular(50)),
                              child: isLoading
                                  ? CircularProgressIndicator()
                                  : Text('Sign Up',
                                      style: simpleTextFieldStyle(20))),
                        )),
                    Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 20,
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Already have an account?  ",
                                style: simpleTextFieldStyle(16)),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Text("Sign In now",
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.red,
                                      decoration: TextDecoration.underline)),
                            ),
                          ],
                        ))
                  ],
                ),
              )
            ]));
  }

  signUpMe() {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      _authenticator
          .signUpWithEmailAndPassword(emailController.text, passController.text)
          .then((value) {
        print('signUp>>>>>>$value');
      });
    }
  }
}
