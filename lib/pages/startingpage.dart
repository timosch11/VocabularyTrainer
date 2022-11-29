import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';
import 'try.dart';

class MyStartingPageWidget extends StatefulWidget {
  const MyStartingPageWidget({super.key});

  @override
  MyStartingPageWidgetState createState() => MyStartingPageWidgetState();
}

class MyStartingPageWidgetState extends State<MyStartingPageWidget> {
  Future fact = fetchFact();
  Future translation = fetchTranslation();
  void _generateFact() {
    setState(() {
      fact = fetchFact();
    });
  }

  final controller = ConfettiController(duration: const Duration(seconds: 2));
  final user = FirebaseAuth.instance.currentUser!;
  late DatabaseReference dbRef;
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child("Student");
    //controller.play();
    fetchTranslation();
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
              height: 05,
            ),
            ConfettiWidget(
              confettiController: controller,
              shouldLoop: true,
            ),
            Stack(
              children: [
                CircularText(
                  children: [
                    TextItem(
                      text: Text(
                        "Welcome ${user.displayName.toString()}".toUpperCase(),
                        style: TextStyle(
                          fontSize: 30,
                          color: Color(0xff1d4e89),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      space: 8,
                      startAngle: -90,
                      startAngleAlignment: StartAngleAlignment.center,
                      direction: CircularTextDirection.clockwise,
                    ),
                  ],
                  radius: 220,
                  position: CircularTextPosition.inside,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 60, horizontal: 10),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      child: FutureBuilder(
                        future: fact,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.toString() ==
                                    'You must be connected to internet to get facts!' ||
                                snapshot.data.toString() ==
                                    'Error on sending request!')
                              return Text(
                                "",
                              );
                            else
                              return Column(
                                children: [
                                  Text(
                                    "Did you know that: \n",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Color(0xff1d4e89)),
                                  ),
                                  Card(
                                    elevation: 18.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    clipBehavior: Clip.antiAlias,
                                    margin: EdgeInsets.all(4.0),
                                    child: SizedBox(
                                      width: 350,
                                      height: 190,
                                      child: Container(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          children: [
                                            FutureBuilder(
                                              future: translation,
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  if (snapshot.data
                                                              .toString() ==
                                                          'You must be connected to internet to get facts!' ||
                                                      snapshot.data
                                                              .toString() ==
                                                          'Error on sending request!')
                                                    return Center(
                                                        child: Text(snapshot
                                                            .data
                                                            .toString()));
                                                  else
                                                    return Column(
                                                      children: [
                                                        Text(
                                                          snapshot.data
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        )
                                                      ],
                                                    );
                                                }
                                                return CircularProgressIndicator();
                                              },
                                            ),
                                            Divider(),
                                            Center(
                                                child: Text(
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black38),
                                              snapshot.data
                                                  .toString()
                                                  .substring(
                                                      2,
                                                      snapshot.data
                                                          .toString()
                                                          .indexOf('Source:')),
                                            )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                          }
                          return CircularProgressIndicator();
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 300),
                  child: Container(
                      height: 325, width: 400, child: BarChartSample1()),
                )
              ],
            ),
          ],
        ),
      );
}

Future fetchFact() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    final response = await http.get(Uri.parse(
        "http://randomuselessfact.appspot.com/today.txt?language=en"));
    if (response.statusCode == 200)
      return response.body.toString();
    else
      return "Error on sending request!";
  } else
    return "You must be connected to internet to get facts!";
}

Future fetchTranslation() async {
  final translator = GoogleTranslator();
  var fact = await fetchFact();
  fact = fact.substring(2, fact.indexOf('Source:'));
  print(fact);
  var translation = await translator.translate(fact.toString(), to: 'en');
  return translation;
}
