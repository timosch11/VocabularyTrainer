import 'package:confetti/confetti.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:flag/flag.dart';
import 'loginscreen.dart';

class MyHomeWidget extends StatefulWidget {
  const MyHomeWidget({super.key});

  @override
  MyHomeWidgetState createState() => MyHomeWidgetState();
}

class MyHomeWidgetState extends State<MyHomeWidget> {
  late DatabaseReference dbRef;
  bool isPlaying = false;
  final controller = ConfettiController(duration: const Duration(seconds: 2));
  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child("Student");
    controller.play();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    Future<Object?> GetData() async {
      DatabaseEvent event = await dbRef.once();
      return event.snapshot.value;
    }

    var a = FutureBuilder<Object?>(
        future: GetData(),
        initialData: null,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? CircularProgressIndicator()
              : Text('Your data: $snapshot.data');
        });
    print(a);
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Color(0xffeaeaea),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xffA1CAD0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/images/logo-removebg-preview-ConvertImage.png',
              fit: BoxFit.fitHeight,
              height: 32,
            ),
            Container(
                padding: const EdgeInsets.all(8.0),
                child: Text("${user.displayName.toString().toUpperCase()}")),
            Flag.fromCode(
              FlagsCode.GB,
              width: 45,
              height: 25,
            ),
          ],
        ),
      ),
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
                  "Welcome Back!".toUpperCase(),
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
            "Welcome Back ${user.displayName.toString()} :)",
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: Color(0xff1d4e89),
            ),
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
              ))
        ],
      ),
    ));
  }
}
