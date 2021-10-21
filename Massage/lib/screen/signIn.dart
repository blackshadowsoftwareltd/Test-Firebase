import 'package:Massage/screen/signUp.dart';
import 'package:Massage/widget/appBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
                        height: 150,
                        // color: Colors.grey,
                        padding: EdgeInsets.all(10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextField(
                                  style: simpleTextFieldStyle(20),
                                  decoration:
                                      textFieldInputDecoration('Email')),
                              TextField(
                                style: simpleTextFieldStyle(20),
                                decoration:
                                    textFieldInputDecoration('Password'),
                              )
                            ])),
                    Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.centerRight,
                        child: Text('Forgot Password!',
                            style: simpleTextFieldStyle(16))),
                    Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
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
                            child: Text('Sign In',
                                style: simpleTextFieldStyle(20)))),
                    Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 20,
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Don't have an account?  ",
                                style: simpleTextFieldStyle(16)),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpPage())),
                              child: Text("Register now",
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
}
