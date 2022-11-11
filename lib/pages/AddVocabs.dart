import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyAddVocabsWidget extends StatefulWidget {
  const MyAddVocabsWidget({super.key});

  @override
  MyAddVocabsWidgetState createState() => MyAddVocabsWidgetState();
}

List<String> list = <String>['One', 'Two', 'Three', 'Four'];
var cat;
CollectionReference ref = FirebaseFirestore.instance
    .collection("Students")
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .collection("Vocabs");
late var items;

class MyAddVocabsWidgetState extends State<MyAddVocabsWidget> {
  String category = "";
  String toTranslateWord = "";
  String germanWord = "";
  String dropdownValue = list.first;
  final TextEditingController _textController = new TextEditingController();
  final TextEditingController _textController2 = new TextEditingController();
  final TextEditingController _textController3 = new TextEditingController();
  var selectedCurrency, selectedType;
  @override
  void initState() {
    super.initState();
  }

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
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 10, 20, 20),
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 250,
                          child: TextFormField(
                              controller: _textController,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 2),
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
                              onChanged: (value) {
                                category = value;
                              }),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xffA1CAD0)),
                              onPressed: () {
                                add_category();
                                _textController.clear();
                              },
                              child: Icon(Icons.add)),
                        )
                      ],
                    ),
                  ),
                  Divider(color: Color(0xffA1CAD0), thickness: 2),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Students")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection("Vocabs")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return const Text("Loading.....");
                        else {
                          List<DropdownMenuItem> currencyItems = [];
                          List<String> curr = [];
                          for (int i = 0; i < snapshot.data!.docs.length; i++) {
                            var snap = snapshot.data!.docs[i]["category"];
                            print("Here:" +
                                FirebaseAuth.instance.currentUser!.uid);

                            if (curr.contains(snap) == false) {
                              curr.add(snapshot.data!.docs[i]["category"]);
                              currencyItems.add(
                                DropdownMenuItem(
                                  child: Text(
                                    snap,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  value: snap,
                                ),
                              );
                            }
                          }

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Icon(Icons.category_rounded,
                                  size: 25.0, color: Colors.black),
                              SizedBox(width: 50.0),
                              DropdownButton(
                                items: currencyItems,
                                onChanged: (currencyValue) {
                                  final snackBar = SnackBar(
                                    content: Text(
                                      'Selected Category is $currencyValue',
                                      style:
                                          TextStyle(color: Color(0xffA1CAD0)),
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  setState(() {
                                    selectedCurrency = currencyValue;
                                  });
                                },
                                value: selectedCurrency,
                                isExpanded: false,
                                hint: new Text(
                                  "Choose Category",
                                  style: TextStyle(color: Colors.grey[900]),
                                ),
                              ),
                            ],
                          );
                        }
                      }),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: TextFormField(
                      controller: _textController3,
                      decoration: InputDecoration(hintText: "German Word"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 35,
                          fontFamily: "lato",
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
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
                      controller: _textController2,
                      decoration: InputDecoration(hintText: "Translation"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 35,
                          fontFamily: "lato",
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      onChanged: (value) {
                        toTranslateWord = value;
                      },
                      maxLines: 3,
                      scrollPadding: EdgeInsets.all(12),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 50),
                    child: ElevatedButton(
                        onPressed: () {
                          add();
                          _textController2.clear();
                          _textController3.clear();
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "lato",
                              color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xffA1CAD0),
                            minimumSize: const Size.fromHeight(50))),
                  )
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
      "category": selectedCurrency,
      "germanWord": germanWord,
      "toTranslateWord": toTranslateWord,
      "created": DateTime.now()
    };

    ref.add(data);

    //Navigator.pop(context);
  }

  void add_category() async {
    var data = {
      "category": category,
      "germanWord": "dummy",
      "toTranslateWord": "dummy",
      "created": DateTime.now()
    };

    ref.add(data);
    selectedCurrency = category;
    //Navigator.pop(context);
  }
}
