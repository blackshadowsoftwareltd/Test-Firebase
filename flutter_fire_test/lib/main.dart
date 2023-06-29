import 'dart:ui' show DartPluginRegistrant;

import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart'
    show MaterialApp, WidgetsFlutterBinding, runApp;
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'app.dart';
// Import the generated file
import 'firebase_options.dart' show DefaultFirebaseOptions;

Future<void> main() async {
  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  runApp(const ProviderScope(
      child: MaterialApp(
    home: StartApp(),
  )));
}
