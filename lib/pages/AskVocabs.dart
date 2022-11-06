import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyAskVocabsWidget extends StatefulWidget {
  const MyAskVocabsWidget({super.key});

  @override
  MyAskVocabsWidgetState createState() => MyAskVocabsWidgetState();
}

class MyAskVocabsWidgetState extends State<MyAskVocabsWidget> {
  CollectionReference ref = FirebaseFirestore.instance
      .collection("Students")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("Vocabs");

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
  @override
  Widget build(BuildContext context) => Scaffold(
      body: FutureBuilder<QuerySnapshot>(
          future: ref.get(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: ((context, index) {
                  Random random = new Random();
                  Color bg = myColors[random.nextInt(8)];
                  Map? data = snapshot.data?.docs[index].data() as Map?;
                  print(data?.values.toList());
                  return Card(
                      color: bg,
                      child: Column(children: [
                        Text(
                            "${data!['germanWord']} : ${data['toTranslateWord']}")
                      ]));
                }),
              );
            } else {
              return Center(child: Text("Please Add Vocabs first"));
            }
          })));
}
