import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'pages/loginscreen.dart';
import 'pages/registerscreen.dart';

Future<void> main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return SizedBox.shrink();
  };
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: MyLoginWidget()));
}
