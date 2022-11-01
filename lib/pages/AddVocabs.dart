import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyAddVocabsWidget extends StatefulWidget {
  const MyAddVocabsWidget({super.key});

  @override
  MyAddVocabsWidgetState createState() => MyAddVocabsWidgetState();
}

class MyAddVocabsWidgetState extends State<MyAddVocabsWidget> {
  String category = "";
  String toTranslateWord = "";
  String germanWord = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Form(
              child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      add();
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: "lato",
                          color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.grey[700]),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 25, vertical: 8))),
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Category"),
                style: TextStyle(
                    fontSize: 25,
                    fontFamily: "lato",
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
                onChanged: (value) {
                  category = value;
                },
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.175,
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: TextFormField(
                  decoration: InputDecoration(hintText: "German Word"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 35,
                      fontFamily: "lato",
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  onChanged: (value) {
                    germanWord = value;
                  },
                  maxLines: 1,
                  scrollPadding: EdgeInsets.all(12),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.175,
                padding: const EdgeInsets.only(top: 0),
                child: TextFormField(
                  decoration:
                      InputDecoration.collapsed(hintText: "Translation"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 35,
                      fontFamily: "lato",
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  onChanged: (value) {
                    toTranslateWord = value;
                  },
                  maxLines: 1,
                  scrollPadding: EdgeInsets.all(12),
                ),
              ),
            ],
          ))
        ],
      ),
    ));
  }

  void add() async {
    CollectionReference ref = FirebaseFirestore.instance
        .collection("Students")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Vocabs");

    var data = {
      "category": category,
      "germanWord": germanWord,
      "toTranslateWord": toTranslateWord,
      "created": DateTime.now()
    };

    ref.add(data);
    //Navigator.pop(context);
  }
}
