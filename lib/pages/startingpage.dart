import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_circular_text/circular_text.dart';

class MyStartingPageWidget extends StatefulWidget {
  const MyStartingPageWidget({super.key});

  @override
  MyStartingPageWidgetState createState() => MyStartingPageWidgetState();
}

class MyStartingPageWidgetState extends State<MyStartingPageWidget> {
  final controller = ConfettiController(duration: const Duration(seconds: 2));
  final user = FirebaseAuth.instance.currentUser!;
  late DatabaseReference dbRef;
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child("Student");
    controller.play();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ConfettiWidget(
              confettiController: controller,
              shouldLoop: false,
              //maxBlastForce: 100,
              //minBlastForce: 80,
              emissionFrequency: 0.5,
              blastDirectionality: BlastDirectionality.explosive,
            ),
            SizedBox(
              height: 40,
            ),
            ConfettiWidget(
              confettiController: controller,
              shouldLoop: true,
            ),
            CircularText(
              children: [
                TextItem(
                  text: Text(
                    "Welcome!".toUpperCase(),
                    style: TextStyle(
                      fontSize: 28,
                      color: Color(0xff1d4e89),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  space: 8,
                  startAngle: -90,
                  startAngleAlignment: StartAngleAlignment.center,
                  direction: CircularTextDirection.clockwise,
                )
              ],
              radius: 180,
              position: CircularTextPosition.inside,
            ),
            Text(
              "Welcome ${user.displayName.toString()} :)",
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Color(0xff1d4e89),
              ),
            ),
          ],
        ),
      );
}
