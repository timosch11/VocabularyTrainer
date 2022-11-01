import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MySettingsWidget extends StatefulWidget {
  const MySettingsWidget({super.key});

  @override
  MySettingsWidgetState createState() => MySettingsWidgetState();
}

class MySettingsWidgetState extends State<MySettingsWidget> {
  @override
  Widget build(BuildContext context) => Scaffold(
          body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Text(
              "Settings",
              style: TextStyle(fontSize: 60),
            ),
            Spacer(),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                ),
                onPressed: (() {
                  FirebaseAuth.instance.signOut();
                }),
                icon: Icon(Icons.arrow_back, size: 32),
                label: Text(
                  "Sign out",
                  style: TextStyle(fontSize: 24),
                )),
          ]));
}
