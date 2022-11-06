import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyAddVocabsWidget extends StatefulWidget {
  const MyAddVocabsWidget({super.key});

  @override
  MyAddVocabsWidgetState createState() => MyAddVocabsWidgetState();
}

List<String> list = <String>['One', 'Two', 'Three', 'Four'];

CollectionReference ref = FirebaseFirestore.instance
    .collection("Students")
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .collection("Vocabs");
late var items;
Future<Iterable<Object?>> getData() async {
  // Get docs from collection reference
  QuerySnapshot querySnapshot = await ref.get();

  // Get data from docs and convert map to List
  final allData = querySnapshot.docs
      .map((doc) => doc.data() as Map<dynamic, dynamic>)
      .toList();
  var list;
  for (var i = 0; i < allData.length; i++) {
    list.add(allData[i]);
    print(allData[i]);
  }
  print(list);
  return allData;
}

class MyAddVocabsWidgetState extends State<MyAddVocabsWidget> {
  String category = "";
  String toTranslateWord = "";
  String germanWord = "";
  String dropdownValue = list.first;
  var selectedCurrency, selectedType;
  @override
  void initState() {
    var allData = getData();
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [],
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: ref.snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return const Text("Loading.....");
                        else {
                          List<DropdownMenuItem> currencyItems = [];
                          List<String> curr = [];
                          for (int i = 0; i < snapshot.data!.docs.length; i++) {
                            var snap = snapshot.data!.docs[i]["category"];

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
                              const Icon(Icons.category,
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
                                  "Choose Currency Type",
                                  style: TextStyle(color: Color(0xff11b719)),
                                ),
                              ),
                            ],
                          );
                        }
                      }),
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
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          minimumSize: const Size.fromHeight(50)))
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
}
