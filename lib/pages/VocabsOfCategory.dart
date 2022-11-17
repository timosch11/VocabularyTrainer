import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'startingpage.dart';
import 'MyEditVocabs.dart';

class MyEditinCategoryWidget extends StatefulWidget {
  const MyEditinCategoryWidget(
      {super.key, required this.category, required this.decrementCounter});
  final String category;
  final Function() decrementCounter;
  @override
  MyEditinCategoryWidgetState createState() => MyEditinCategoryWidgetState();
}

class MyEditinCategoryWidgetState extends State<MyEditinCategoryWidget> {
  var selectedCurrency, selectedType;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
              width: 30,
              child: BackButton(onPressed: () {
                widget.decrementCounter();
              }),
            ),
          ],
        ),
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
                List curr2 = [];
                List instances = [];
                for (int i = 0; i < snapshot.data!.docs.length; i++) {
                  var snap = snapshot.data!.docs[i];
                  print(snap);
                  if (snap["category"] == widget.category &&
                      snap["toTranslateWord"] != "dummy") {
                    curr.add(
                        snapshot.data!.docs[i]["toTranslateWord"].toString());
                    curr2.add(snapshot.data!.docs[i]["germanWord"].toString());
                    instances.add(snapshot.data!.docs[i].id);
                    print(instances);
                  }
                }

                return Expanded(
                  child: SizedBox(
                    child: ListView.builder(
                      itemCount: curr.length,
                      itemBuilder: (context, index) {
                        final item = curr[index];
                        final item2 = curr2[index];
                        print(item);
                        return Dismissible(
                          key: Key(item),

                          onDismissed: (direction) {
                            setState(() {
                              FirebaseFirestore.instance
                                  .collection("Students")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection("Vocabs")
                                  .doc(instances[index])
                                  .delete();
                              curr.removeAt(index);
                            });

                            // Then show a snackbar.
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('$item dismissed')));
                          },

                          // Show a red background as the item is swiped away.
                          background: Container(color: Colors.red),
                          child: ListTile(
                            leading: Icon(Icons.library_books),
                            enabled: true,
                            subtitle: Text(item2),
                            title: Text(item),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
            }),
      ],
    );
  }
}
