import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'VocabQuiz.dart';
import 'VocabQuizSelections.dart';

class MyAskVocabsWidget extends StatefulWidget {
  const MyAskVocabsWidget({super.key});

  @override
  MyAskVocabsWidgetState createState() => MyAskVocabsWidgetState();
}

class MyAskVocabsWidgetState extends State<MyAskVocabsWidget> {
  int counter = 0;
  String category = "No Category";
  int timespan = 0;
  int NoOfVocs = 0;
  void incrementCounter() {
    setState(() => counter = 1);
  }

  void getCategory(String cat) {
    setState(() {
      category = cat;
    });
  }

  void getTimespan(int time) {
    setState(() {
      timespan = time;
    });
  }

  void getNoOfVocs(int vocs) {
    setState(() {
      NoOfVocs = vocs;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      MyCreateQuizWidget(
        incrementCounter: incrementCounter,
        getCategory: getCategory,
        getTimespan: getTimespan,
        getNoOfVocs: getNoOfVocs,
      ),
      MyQuiz(
        category: category,
        time: timespan,
        NoOfVocabs: NoOfVocs,
      )
    ];

    print(counter);
    return MaterialApp(
        home:
            Scaffold(resizeToAvoidBottomInset: false, body: screens[counter]));
  }
}
