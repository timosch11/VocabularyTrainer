import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class MyCreateQuizWidget extends StatefulWidget {
  const MyCreateQuizWidget({
    super.key,
    required this.incrementCounter,
    required this.getCategory,
    required this.getTimespan,
    required this.getNoOfVocs,
  });
  final Function() incrementCounter;
  final Function(String cat) getCategory;
  final Function(int time) getTimespan;
  final Function(int vocs) getNoOfVocs;
  @override
  MyCreateQuizWidgetState createState() => MyCreateQuizWidgetState();
}

class MyCreateQuizWidgetState extends State<MyCreateQuizWidget> {
  CollectionReference ref = FirebaseFirestore.instance
      .collection("Students")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("Vocabs");

  late List<String> alphabets = new List<int>.generate(10, (i) => i + 1)
      .map((e) => e.toString())
      .toList();
  late List<String> alphabets2 = new List<int>.generate(100, (i) => i + 5)
      .map((e) => e.toString())
      .toList();
  var selectedCurrency, selectedType;

  List<String?> result = List.filled(2, "0");
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 80, 20, 50),
              child: StreamBuilder<QuerySnapshot>(
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
                        print("Here:" + FirebaseAuth.instance.currentUser!.uid);

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
                                  style: TextStyle(color: Color(0xffA1CAD0)),
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              setState(() {
                                selectedCurrency = currencyValue;
                                var category = currencyValue;
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
            ),
            Text("Select Time and Number of Vocabularys:\n\n"),
            SizedBox(
              height: 124,
              child: Row(
                children: [
                  Expanded(
                    child: RollerSlot(
                      callback: (p0) {
                        setState(() {
                          result[0] = p0;
                          var time = p0;
                        });
                      },
                      data: alphabets.map((e) => e + " min").toList(),
                    ),
                  ),
                  Expanded(
                    child: RollerSlot(
                      callback: (p0) {
                        setState(() {
                          result[1] = p0;
                        });
                      },
                      data: alphabets2.map((e) => e + " pcs").toList(),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Container(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 40),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffA1CAD0)),
                  onPressed: () {
                    var category = selectedCurrency;
                    widget.getCategory(category);
                    widget.getTimespan(int.parse(
                        result[0]!.substring(0, result[0]!.length - 4)));
                    widget.getNoOfVocs(int.parse(
                        result[0]!.substring(0, result[1]!.length - 4)));
                    widget.incrementCounter();
                  },
                  child: Text(
                      "Start ${result[0]} min long test with ${result[1]} vocabs"),
                ))
          ],
        ),
      );
}

class RollerSlot extends StatelessWidget {
  const RollerSlot({
    Key? key,
    required this.data,
    required this.callback,
  }) : super(key: key);

  final List<String> data;
  final Function(String) callback;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: CupertinoPicker(
          selectionOverlay: Container(color: Color(0xffA1CAD0).withOpacity(.5)),
          itemExtent: 24.0,
          onSelectedItemChanged: (value) => callback(data[value]),
          children: data
              .map(
                (e) => Text(e),
              )
              .toList()),
    );
  }
}
