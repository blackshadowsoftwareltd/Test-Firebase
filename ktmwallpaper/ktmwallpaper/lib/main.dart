
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:ktmwallpaper/Screen/LandingPage.dart';

void main() async {
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  await FirebaseAdMob.instance
      .initialize(appId: 'ca-app-pub-7623473266641534~6037335678');
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KTM Wallpaper',
      theme: ThemeData(primaryColor: Colors.deepOrange),
      home: LandingPage()));
}
