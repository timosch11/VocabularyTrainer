import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'VocabsOfCategory.dart';
import 'MyEditVocabs.dart';

class MyManageVocabsWidget extends StatefulWidget {
  const MyManageVocabsWidget({super.key});

  @override
  MyManageVocabsWidgetState createState() => MyManageVocabsWidgetState();
}

class MyManageVocabsWidgetState extends State<MyManageVocabsWidget> {
  String category = "No Category";
  int counter = 0;
  void getCategory(String cat) {
    setState(() {
      category = cat;
    });
  }

  void incrementCounter() {
    counter++;
  }

  void decrementCounter() {
    setState(() {
      counter = 0;
    });
    print("counter:${counter}");
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      MyEditWidget(
        incrementCounter: incrementCounter,
        getCategory: getCategory,
      ),
      MyEditinCategoryWidget(
        category: category,
        decrementCounter: decrementCounter,
      )
    ];
    // TODO: implement build

    return MaterialApp(home: Scaffold(body: screens[counter]));
  }
}
