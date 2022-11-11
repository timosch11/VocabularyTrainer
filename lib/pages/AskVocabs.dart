import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "VocabQuiz.dart";
import 'VocabQuizSelections.dart';

class MyAskVocabsWidget extends StatefulWidget {
  const MyAskVocabsWidget({super.key});

  @override
  MyAskVocabsWidgetState createState() => MyAskVocabsWidgetState();
}

class MyAskVocabsWidgetState extends State<MyAskVocabsWidget> {
  int counter = 0;

  void incrementCounter() {
    setState(() => counter = 1);
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      MyCreateQuizWidget(
        incrementCounter: incrementCounter,
      ),
      MyQuiz()
    ];
    // TODO: implement build
    print(counter);
    return MaterialApp(home: Scaffold(body: screens[counter]));
  }
}
