import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MyQuiz extends StatefulWidget {
  const MyQuiz({super.key, required this.category, required this.time});
  final String category;
  final int time;

  @override
  MyQuizState createState() => MyQuizState();
}

var selectedCurrency, selectedType;
var cat;
late var items;

class MyQuizState extends State<MyQuiz> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  var counter_ = 0;
  AnimationStatus _animationStatus = AnimationStatus.dismissed;
  final TextEditingController _textController = new TextEditingController();
  int endTime = 0;
  @override
  void initState() {
    endTime = DateTime.now().millisecondsSinceEpoch + 1000 * widget.time * 60;
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

  void decrementCounter() {
    counter_--;
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
        body: FutureBuilder<QuerySnapshot>(
            future: ref.get(),
            builder: ((context, snapshot) {
              //Map? data = snapshot.data?.docs[counter_].data() as Map?;
              var data2 = snapshot.data!.docs;
              List dat = [];

              for (int i = 0; i <= data2!.length - 1; i++) {
                if (data2[i]["category"] == widget.category &&
                    data2[i]["toTranslateWord"] != "dummy") {
                  dat.add(data2[i]);
                }
              }
              if (counter >= dat.length - 1) {
                counter_ = dat.length - 1;
              }
              Map? data = dat[counter_].data() as Map?;
              print(counter_);
              if (snapshot.hasData && counter_ != dat.length - 1) {
                String hint = "";
                for (int i = 0; i < data!["toTranslateWord"].length; i++) {
                  if (i.isEven) {
                    hint = hint + data["toTranslateWord"][i];
                  } else {
                    hint = hint + "_";
                  }
                }

                return Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(children: [
                          Spacer(),
                          CountdownTimer(
                            endTime: endTime,
                            textStyle: TextStyle(
                                color: Colors.green,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )
                        ]),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Transform(
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(pi * _animation.value * 2),
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
                                                  style:
                                                      TextStyle(fontSize: 30),
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
                        ),
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
                          padding: const EdgeInsets.only(top: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 120,
                                height: 60,
                                child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        decrementCounter();
                                      });
                                      ;
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.skip_previous_outlined,
                                          color: Colors.black,
                                        ),
                                        Text(
                                          "Previous",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "lato",
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        minimumSize:
                                            const Size.fromHeight(50))),
                              ),
                              SizedBox(
                                width: 120,
                                height: 60,
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
                                          Icons.skip_next_outlined,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        minimumSize:
                                            const Size.fromHeight(50))),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 17),
                          child: LinearPercentIndicator(
                            lineHeight: 14.0,
                            percent: counter_ / (dat.length - 2),
                            backgroundColor: Colors.grey,
                            progressColor: Color(0xffA1CAD0),
                            animation: true,
                            center:
                                Text("${(counter_ / (dat.length - 2)) * 100}%"),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                          ),
                        ),
                      ]),
                );
              } else {
                return Center(child: Text("Please Add Vocabs first"));
              }
            })));
  }
}
