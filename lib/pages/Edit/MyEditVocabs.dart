import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Home/startingpage.dart';
import 'VocabsOfCategory.dart';

class MyEditWidget extends StatefulWidget {
  const MyEditWidget({
    super.key,
    required this.getCategory,
    required this.incrementCounter,
  });
  final Function(String cat) getCategory;
  final Function() incrementCounter;

  @override
  MyEditWidgetState createState() => MyEditWidgetState();
}

class MyEditWidgetState extends State<MyEditWidget> {
  var category = "No Category";
  var selectedCurrency, selectedType;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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

              if (curr.contains(snap) == false &&
                  snapshot.data!.docs[i]["germanWord"] != "dummy") {
                curr.add(snapshot.data!.docs[i]["category"]);
              }
            }

            return ListView.builder(
              itemCount: curr.length,
              itemBuilder: (context, index) {
                final item = curr[index];
                return Container(
                  padding: const EdgeInsets.only(top: 15),
                  key: Key(item),
                  child: ListTile(
                    onTap: () {
                      category = item;
                      widget.getCategory(category);
                      widget.incrementCounter();
                    },
                    leading: Icon(
                      Icons.category,
                      color: Colors.black,
                    ),
                    enabled: true,
                    title: Text(
                      item,
                      style: TextStyle(
                        fontSize: 22.0,
                        fontFamily: "lato",
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              },
            );
          }
        });
  }
}
