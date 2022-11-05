import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyAddVocabsWidget extends StatefulWidget {
  const MyAddVocabsWidget({super.key});

  @override
  MyAddVocabsWidgetState createState() => MyAddVocabsWidgetState();
}

final List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class MyAddVocabsWidgetState extends State<MyAddVocabsWidget> {
  String category = "";
  String toTranslateWord = "";
  String germanWord = "";
  String dropdownValue = list.first;
  CollectionReference ref = FirebaseFirestore.instance
      .collection("Students")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("Vocabs");

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
                                EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 8))),
                      ),
                    ],
                  ),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    underline: Container(
                      height: 5,
                      color: Color(0xffA1CAD0),
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  Container(
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
                      maxLines: 3,
                      scrollPadding: EdgeInsets.all(12),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                      decoration: InputDecoration(hintText: "Translation"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 35,
                          fontFamily: "lato",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      onChanged: (value) {
                        toTranslateWord = value;
                      },
                      maxLines: 3,
                      scrollPadding: EdgeInsets.all(12),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 120, 20, 20),
                    alignment: Alignment.bottomCenter,
                    child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Add Category",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                          ),
                        ),
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: "lato",
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        textAlign: TextAlign.center,
                        onChanged: (value) {}),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void add() async {
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
