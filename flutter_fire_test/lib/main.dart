import 'dart:ui' show dartPluginRegistry, DartPluginRegistrant;

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart'
    show MaterialApp, WidgetsFlutterBinding, runApp;
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'app.dart';
// Import the generated file
import 'firebase_options.dart' show DefaultFirebaseOptions;
import 'modules/task/views/task.dart' show TaskScreen;

Future<void> main() async {
  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  runApp(const ProviderScope(
      child: MaterialApp(
    // home: StartApp(),
    home: TaskScreen(),
  )));
}
