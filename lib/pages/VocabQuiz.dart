import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class MyQuiz extends StatefulWidget {
  const MyQuiz({super.key});

  @override
  MyQuizState createState() => MyQuizState();
}

var selectedCurrency, selectedType;
var cat;
late var items;

class MyQuizState extends State<MyQuiz> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  var counter_ = 1;
  AnimationStatus _animationStatus = AnimationStatus.dismissed;
  final TextEditingController _textController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween<double>(end: 1, begin: 0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _animationStatus = status;
      });
  }

  CollectionReference ref = FirebaseFirestore.instance
      .collection("Students")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("Vocabs");
  int counter = 0;
  List myColors = [
    Colors.yellow[200],
    Colors.red[200],
    Colors.green[200],
    Colors.deepPurple[200],
    Colors.purple[200],
    Colors.cyan[200],
    Colors.teal[200],
    Colors.tealAccent[200],
    Colors.pink[200],
  ];

  void incrementCounter() {
    counter_++;
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
        body: FutureBuilder<QuerySnapshot>(
            future: ref.get(),
            builder: ((context, snapshot) {
              // for (int counter = 0; counter <= 10; counter++) {
              if (snapshot.hasData) {
                Map? data = snapshot.data?.docs[counter_].data() as Map?;
                print(counter_);
                String hint = "";
                for (int i = 0; i < data!["toTranslateWord"].length; i++) {
                  if (i.isEven) {
                    hint = hint + data["toTranslateWord"][i];
                  } else {
                    hint = hint + "_";
                  }
                }
                return Container(
                  padding: const EdgeInsets.only(top: 80),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Transform(
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateX(pi * _animation.value * 2),
                            child: GestureDetector(
                                onTap: () {
                                  if (_animationStatus ==
                                      AnimationStatus.dismissed) {
                                    _animationController.forward();
                                  } else {
                                    _animationController.reverse();
                                  }
                                },
                                child: _animation.value >= 0.5
                                    ? Container(
                                        color: Color(0xffA1CAD0),
                                        height: 200,
                                        width: 300,
                                        child: Card(
                                            color: Color(0xffA1CAD0),
                                            child: Container(
                                                child: Center(
                                              child: Text(
                                                "${hint}",
                                                style: TextStyle(fontSize: 30),
                                              ),
                                            ))),
                                      )
                                    : Container(
                                        color: Color(0xffA1CAD0),
                                        height: 200,
                                        width: 300,
                                        child: Card(
                                            color: Color(0xffA1CAD0),
                                            child: Container(
                                                child: Center(
                                              child: Text(
                                                "${data["germanWord"]}",
                                                style: TextStyle(
                                                  fontSize: 30,
                                                ),
                                              ),
                                            ))),
                                      ))),
                        Divider(),
                        Divider(),
                        Container(
                            color: Color(0xffA1CAD0),
                            height: 200,
                            width: 300,
                            child: Card(
                                color: Color(0xffA1CAD0),
                                child: Container(
                                    child: Center(
                                  child: TextFormField(
                                      controller: _textController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white30,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 2),
                                        hintText: "Translation",
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 0.0,
                                          ),
                                        ),
                                      ),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: "lato",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                      textAlign: TextAlign.center,
                                      onChanged: (value) {}),
                                )))),
                        Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.fromLTRB(200, 75, 50, 0),
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  incrementCounter();
                                });
                                ;
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Next",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "lato",
                                        color: Colors.black),
                                  ),
                                  Icon(
                                    Icons.navigate_next_outlined,
                                    color: Colors.black,
                                  )
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  minimumSize: const Size.fromHeight(50))),
                        )
                      ]),
                );
              } else {
                return Center(child: Text("Please Add Vocabs first"));
              }
            })));
  }
}
