import 'package:confetti/confetti.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:flag/flag.dart';
import 'loginscreen.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import "startingpage.dart";
import 'MyEditVocabs.dart';
import "AddVocabs.dart";
import "AskVocabs.dart";
import "Settings.dart";
import 'ManageVocabs.dart';
import "try.dart";

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
    MyManageVocabsWidget(),
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
                          Text("PineAPPulary")),
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
                  IconThemeData(color: Color(0xff1d4e89), size: 25),
              selectedItemColor: Color(0xff1d4e89),
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
                    icon: Icon(Icons.add),
                    backgroundColor: Color(0xffA1CAD0),
                    label: "Add"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.auto_stories_rounded),
                    backgroundColor: Color(0xffA1CAD0),
                    label: "Learn"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.edit),
                    backgroundColor: Color(0xffA1CAD0),
                    label: "Edit"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    backgroundColor: Color(0xffA1CAD0),
                    label: "Profil"),
              ],
            )));
  }
}
