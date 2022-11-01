import 'package:confetti/confetti.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:flag/flag.dart';
import 'loginscreen.dart';
import "startingpage.dart";
import "AddVocabs.dart";
import "AskVocabs.dart";
import "Settings.dart";

class MyHomeWidget extends StatefulWidget {
  const MyHomeWidget({super.key});

  @override
  MyHomeWidgetState createState() => MyHomeWidgetState();
}

class MyHomeWidgetState extends State<MyHomeWidget> {
  late DatabaseReference dbRef;
  int _currentIndex = 0;
  bool isPlaying = false;
  final controller = ConfettiController(duration: const Duration(seconds: 2));
  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child("Student");
    controller.play();
  }

  final screens = [
    MyStartingPageWidget(),
    MyAddVocabsWidget(),
    MyAskVocabsWidget(),
    MySettingsWidget()
  ];
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
                      child:
                          Text("${user.displayName.toString().toUpperCase()}")),
                  Flag.fromCode(
                    FlagsCode.GB,
                    width: 45,
                    height: 25,
                  ),
                ],
              ),
            ),
            body: screens[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              onTap: (index) => setState(() => _currentIndex = index),
              currentIndex: _currentIndex,
              selectedFontSize: 10,
              selectedIconTheme:
                  IconThemeData(color: Colors.redAccent, size: 25),
              selectedItemColor: Colors.white,
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
              unselectedIconTheme: IconThemeData(
                color: Colors.white,
              ),
              unselectedItemColor: Colors.white,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  backgroundColor: Color(0xffA1CAD0),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.edit_rounded),
                    backgroundColor: Color(0xffA1CAD0),
                    label: "Edit"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.auto_stories_rounded),
                    backgroundColor: Color(0xffA1CAD0),
                    label: "Learn"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings_rounded),
                    backgroundColor: Color(0xffA1CAD0),
                    label: "Settings"),
              ],
            )));
  }
}
