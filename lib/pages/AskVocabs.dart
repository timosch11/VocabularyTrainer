import 'package:flutter/material.dart';

class MyAskVocabsWidget extends StatefulWidget {
  const MyAskVocabsWidget({super.key});

  @override
  MyAskVocabsWidgetState createState() => MyAskVocabsWidgetState();
}

class MyAskVocabsWidgetState extends State<MyAskVocabsWidget> {
  @override
  Widget build(BuildContext context) => Scaffold(
          body: Center(
        child: Text(
          "AskVocabs",
          style: TextStyle(fontSize: 60),
        ),
      ));
}
