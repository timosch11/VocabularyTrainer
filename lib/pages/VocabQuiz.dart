import 'dart:convert';
import 'dart:io';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MyQuiz extends StatefulWidget {
  const MyQuiz(
      {super.key,
      required this.category,
      required this.time,
      required this.NoOfVocabs});
  final String category;
  final int time;
  final int NoOfVocabs;

  @override
  MyQuizState createState() => MyQuizState();
}

var selectedCurrency, selectedType;
var cat;
late var items;
var usedtip = false;

class MyQuizState extends State<MyQuiz> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool isPlaying = false;
  final controller = ConfettiController(duration: const Duration(seconds: 2));
  var counter_ = 0;
  AnimationStatus _animationStatus = AnimationStatus.dismissed;
  final TextEditingController _textController = new TextEditingController();
  int endTime = 0;
  var answers = List.empty(growable: true);
  int NoOfVocabs = 1;
  var sessionkey = UniqueKey().toString();
  @override
  void initState() {
    endTime = DateTime.now().millisecondsSinceEpoch + 1000 * widget.time * 60;
    var NoOfVocabs = widget.NoOfVocabs;
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
  List askedvocbs = List.empty(growable: true);
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

  void setCounter(value) {
    counter_ = value;
  }

  void decrementCounter() {
    counter_--;
  }

  List<Container> return_icon_list_view(answeristright, icon_list) {
    if (answeristright == true) {
      icon_list[counter_] = Container(
          padding: EdgeInsets.symmetric(horizontal: 1),
          height: 30,
          width: 30,
          alignment: Alignment.centerLeft,
          child: IconButton(
            alignment: Alignment.centerLeft,
            icon: Icon(Icons.check_box),
            iconSize: 20,
            color: Colors.green,
            onPressed: () {},
          ));
    } else {
      icon_list[counter_] = Container(
          padding: EdgeInsets.symmetric(horizontal: 1),
          height: 30,
          width: 30,
          alignment: Alignment.centerLeft,
          child: IconButton(
            alignment: Alignment.centerLeft,
            icon: Icon(Icons.cancel_presentation_sharp),
            iconSize: 20,
            color: Colors.red,
            onPressed: () {},
          ));
    }
    return icon_list;
  }

  List<Container> icon_list = new List.filled(
      10,
      Container(
          padding: EdgeInsets.symmetric(horizontal: 1),
          height: 30,
          width: 30,
          alignment: Alignment.center,
          child: IconButton(
            alignment: Alignment.center,
            icon: Icon(Icons.question_mark_sharp),
            iconSize: 20,
            onPressed: () {},
          )),
      growable: true);
  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
        body: FutureBuilder<QuerySnapshot>(
            future: ref.get(),
            builder: ((context, snapshot) {
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

              if (snapshot.hasData && counter_ != dat.length - 1) {
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
                        Divider(),
                        Container(
                          child: SizedBox(
                              height: 60,
                              child: Container(
                                // height: double.infinity,
                                // width: double.infinity,

                                child: Align(
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    itemCount: icon_list.length,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  width: 30,
                                                  child: InkWell(
                                                    child: Text(
                                                      "  ${(index + 1).toString()}",
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        setCounter(index);
                                                      });
                                                    },
                                                  )),
                                              SizedBox(
                                                  width: 30,
                                                  child: icon_list[index]),
                                            ],
                                          ),
                                          VerticalDivider()
                                        ],
                                      );
                                    },
                                    shrinkWrap: true,
                                  ),
                                ),
                              )),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Transform(
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(pi * _animation.value * 2),
                              child: GestureDetector(
                                  onTap: () {
                                    usedtip = true;
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
                                          height: 180,
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
                                          height: 180,
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
                        Expanded(
                          child: Container(
                              color: Color(0xffA1CAD0),
                              height: 180,
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
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 30),
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
                                        Map<String, dynamic> toadd =
                                            SaveAnswers(
                                                _textController.text,
                                                data["toTranslateWord"],
                                                data["germanWord"],
                                                usedtip);
                                        askedvocbs.add(toadd);
                                        usedtip = false;
                                      });
                                      ;

                                      setState(() {
                                        var answeristright = false;
                                        if (data["toTranslateWord"]
                                                .toLowerCase() ==
                                            _textController.text.toLowerCase())
                                          answeristright = true;

                                        icon_list = return_icon_list_view(
                                            answeristright, icon_list);
                                      });
                                      _textController.clear();
                                      incrementCounter();

                                      var answeristright = false;
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
                            center: Text(
                                "${((counter_ / (dat.length - 2)) * 100).toStringAsFixed(0)}%"),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                          ),
                        ),
                      ]),
                );
              } else {
                //addtodb();
                var corrects = getNoOfCorrectAnswers();
                Color col = corrects[4];
                if (corrects[3] == "A" || corrects[3] == "B") {
                  controller.play();
                }
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ConfettiWidget(
                        confettiController: controller,
                        shouldLoop: false,
                        //maxBlastForce: 100,
                        //minBlastForce: 80,
                        emissionFrequency: 0.5,
                        blastDirectionality: BlastDirectionality.explosive,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (!isKeyboard)
                            Image(
                                image: AssetImage('assets/images/logo.png'),
                                width: 144,
                                height: 185),
                          if (!isKeyboard)
                            BubbleSpecialThree(
                              text: 'You are doing\n great! :)',
                              color: Color(0xffA1CAD0),
                              tail: true,
                              isSender: false,
                              textStyle:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                        ],
                      ),
                      Divider(),
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: Icon(Icons.check_box,
                                      size: 30, color: Colors.greenAccent),
                                  padding: const EdgeInsets.all(12),
                                ),
                                Text(
                                  corrects[0].toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Container(
                              width: 300,
                              decoration: const BoxDecoration(
                                  color: Color(0xffA1CAD0),
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(12),
                                      bottomLeft: Radius.circular(12))),
                              child: Text(
                                "Right Answers",
                                textAlign: TextAlign.center,
                              ),
                              padding: const EdgeInsets.all(12),
                            )
                          ],
                        ),
                      ),
                      Divider(),
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: Icon(Icons.format_align_left_sharp,
                                      size: 30, color: Colors.blueAccent),
                                  padding: const EdgeInsets.all(12),
                                ),
                                Text(
                                  corrects[1].toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Container(
                              width: 300,
                              decoration: const BoxDecoration(
                                  color: Color(0xffA1CAD0),
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(12),
                                      bottomLeft: Radius.circular(12))),
                              child: Text(
                                "Total Vocabularies",
                                textAlign: TextAlign.center,
                              ),
                              padding: const EdgeInsets.all(12),
                            )
                          ],
                        ),
                      ),
                      Divider(),
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: Icon(Icons.person,
                                      size: 30, color: Colors.blueAccent),
                                  padding: const EdgeInsets.all(12),
                                ),
                                Text(
                                  "${corrects[2].toString()} %",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Container(
                              width: 300,
                              decoration: const BoxDecoration(
                                  color: Color(0xffA1CAD0),
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(12),
                                      bottomLeft: Radius.circular(12))),
                              child: Text(
                                "Accomplished",
                                textAlign: TextAlign.center,
                              ),
                              padding: const EdgeInsets.all(12),
                            )
                          ],
                        ),
                      ),
                      Divider(),
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: col,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: Icon(Icons.school_rounded,
                                      size: 30, color: Colors.blueAccent),
                                  padding: const EdgeInsets.all(12),
                                ),
                                Text(
                                  "${corrects[3].toString()}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Container(
                              width: 300,
                              decoration: const BoxDecoration(
                                  color: Color(0xffA1CAD0),
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(12),
                                      bottomLeft: Radius.circular(12))),
                              child: Text(
                                "Rating",
                                textAlign: TextAlign.center,
                              ),
                              padding: const EdgeInsets.all(12),
                            )
                          ],
                        ),
                      ),
                    ]);
              }
            })));
  }

  List getNoOfCorrectAnswers() {
    List results = List.empty(growable: true);
    int correct = 0;
    int total = 0;
    for (int i = 0; i < askedvocbs.length; i++) {
      total++;
      if (askedvocbs[i]["answerRight"].toString() == "true") {
        correct++;
      }
    }
    String rating = "A";
    results.add(correct);
    results.add(total);
    Color col = Colors.greenAccent;
    results.add(((correct / total) * 100).round());
    if (results[2] == 100) {
      rating = "A";
    } else if (results[2] >= 75) {
      rating = "B";
      col = Colors.lightGreen;
    } else if (results[2] >= 50) {
      rating = "C";
      col = Colors.yellow;
    } else if (results[2] >= 25) {
      rating = "D";
      col = Colors.yellowAccent;
    } else {
      rating = "E";
      col = Colors.redAccent;
    }
    results.add(rating);
    results.add(col);
    return results;
  }

  Map<String, dynamic> SaveAnswers(answer, rightanswer, germanWord, usedtip) {
    var answeristright = false;
    if (answer.toLowerCase() == rightanswer.toLowerCase())
      answeristright = true;

    Map<String, dynamic> toadd = {
      "answer": answer.toLowerCase(),
      "rightanswer": rightanswer.toLowerCase(),
      "germanWord": germanWord,
      "answerRight": answeristright.toString(),
      "usedtip": usedtip,
      "timestamp": DateTime.now(),
      "session": sessionkey
    };

    answers.add(toadd);
    return toadd;
  }

  void addtodb() {
    CollectionReference ref = FirebaseFirestore.instance
        .collection("Students")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Tests");
    for (int i = 0; i < answers.length; i++) {
      ref.add(answers[i]);
    }
  }
}
