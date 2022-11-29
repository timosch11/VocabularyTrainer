import 'dart:async';

import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class BarChartSample1 extends StatefulWidget {
  const BarChartSample1({super.key});

  List<Color> get availableColors => const <Color>[
        Colors.purpleAccent,
        Colors.yellow,
        Colors.lightBlue,
        Colors.orange,
        Colors.pink,
        Colors.redAccent,
      ];

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample1> {
  final Color barBackgroundColor = Color.fromARGB(255, 255, 255, 255);
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;
  bool isPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
            int calculateDifference(DateTime date) {
              DateTime now = DateTime.now();
              return DateTime(date.year, date.month, date.day)
                      .difference(DateTime(now.year, now.month, now.day))
                      .inDays *
                  -1;
            }

            Map<dynamic, double> myMap = {};
            for (int i = 0; i <= 6; i++) {
              myMap[i] = 0;
            }
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              var snap = snapshot.data!.docs[i];
              if (calculateDifference(snap["created"].toDate()) <= 7 &&
                  snap["toTranslateWord"] != "dummy") {
                if (myMap.containsKey(
                    calculateDifference(snap["created"].toDate()))) {
                  myMap[calculateDifference(snap["created"].toDate())] =
                      (myMap[calculateDifference(snap["created"].toDate())]! +
                          1);
                } else {
                  myMap[calculateDifference(snap["created"].toDate())] = 1;
                }
              }
              print(myMap);
            }
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: AspectRatio(
                aspectRatio: 1,
                child: Card(
                  elevation: 18.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  color: Color.fromARGB(255, 252, 185, 149),
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const Text(
                              'Your Progress',
                              style: TextStyle(
                                color: const Color(0xff1d4e89),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            const Text(
                              'Number of added Vocabs the last 7 days',
                              style: TextStyle(
                                color: Color(0xff379982),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 38,
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: BarChart(
                                  isPlaying
                                      ? randomData(myMap)
                                      : mainBarData(myMap),
                                  swapAnimationDuration: animDuration,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              color: const Color(0xff1d4e89),
                            ),
                            onPressed: () {
                              setState(() {
                                isPlaying = !isPlaying;
                                if (isPlaying) {
                                  refreshState();
                                }
                              });
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = const Color(0xffA1CAD0),
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? Colors.yellow : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Colors.yellow)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups(myMap) => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, myMap[6], isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, myMap[5], isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, myMap[4], isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, myMap[3], isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, myMap[2], isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, myMap[1], isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, myMap[0], isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData(myMap) {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.blueGrey,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay;
            switch (group.x) {
              case 0:
                weekDay = DateFormat('EEEE')
                    .format(DateTime.now().subtract(Duration(days: 6)));
                break;
              case 1:
                weekDay = DateFormat('EEEE')
                    .format(DateTime.now().subtract(Duration(days: 5)));
                break;
              case 2:
                weekDay = DateFormat('EEEE')
                    .format(DateTime.now().subtract(Duration(days: 4)));
                break;
              case 3:
                weekDay = DateFormat('EEEE')
                    .format(DateTime.now().subtract(Duration(days: 3)));
                break;
              case 4:
                weekDay = DateFormat('EEEE')
                    .format(DateTime.now().subtract(Duration(days: 2)));
                break;
              case 5:
                weekDay = DateFormat('EEEE')
                    .format(DateTime.now().subtract(Duration(days: 1)));
                break;
              case 6:
                weekDay = DateFormat('EEEE').format(DateTime.now());
                ;
                break;
              default:
                throw Error();
            }
            return BarTooltipItem(
              '$weekDay\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY - 1).toInt().toString(),
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(myMap),
      gridData: FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(
            DateFormat('EEEE')
                .format(DateTime.now().subtract(Duration(days: 6)))
                .toString()
                .substring(0, 2),
            style: style);
        break;
      case 1:
        text = Text(
            DateFormat('EEEE')
                .format(DateTime.now().subtract(Duration(days: 5)))
                .toString()
                .substring(0, 2),
            style: style);
        break;
      case 2:
        text = Text(
            DateFormat('EEEE')
                .format(DateTime.now().subtract(Duration(days: 4)))
                .toString()
                .substring(0, 2),
            style: style);
        break;
      case 3:
        text = Text(
            DateFormat('EEEE')
                .format(DateTime.now().subtract(Duration(days: 3)))
                .toString()
                .substring(0, 2),
            style: style);
        break;
      case 4:
        text = Text(
            DateFormat('EEEE')
                .format(DateTime.now().subtract(Duration(days: 2)))
                .toString()
                .substring(0, 2),
            style: style);
        break;
      case 5:
        text = Text(
            DateFormat('EEEE')
                .format(DateTime.now().subtract(Duration(days: 1)))
                .toString()
                .substring(0, 2),
            style: style);
        break;
      case 6:
        text = Text(
            DateFormat('EEEE')
                .format(DateTime.now().subtract(Duration(days: 0)))
                .toString()
                .substring(0, 2),
            style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  BarChartData randomData(myMap) {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(
              0,
              Random().nextInt(50).toDouble() + 50,
              barColor: widget.availableColors[
                  Random().nextInt(widget.availableColors.length)],
            );
          case 1:
            return makeGroupData(
              1,
              Random().nextInt(50).toDouble() + 50,
              barColor: widget.availableColors[
                  Random().nextInt(widget.availableColors.length)],
            );
          case 2:
            return makeGroupData(
              2,
              Random().nextInt(50).toDouble() + 50,
              barColor: widget.availableColors[
                  Random().nextInt(widget.availableColors.length)],
            );
          case 3:
            return makeGroupData(
              3,
              Random().nextInt(50).toDouble() + 50,
              barColor: widget.availableColors[
                  Random().nextInt(widget.availableColors.length)],
            );
          case 4:
            return makeGroupData(
              4,
              Random().nextInt(50).toDouble() + 50,
              barColor: widget.availableColors[
                  Random().nextInt(widget.availableColors.length)],
            );
          case 5:
            return makeGroupData(
              5,
              Random().nextInt(50).toDouble() + 50,
              barColor: widget.availableColors[
                  Random().nextInt(widget.availableColors.length)],
            );
          case 6:
            return makeGroupData(
              6,
              Random().nextInt(15).toDouble() + 6,
              barColor: widget.availableColors[
                  Random().nextInt(widget.availableColors.length)],
            );
          default:
            return throw Error();
        }
      }),
      gridData: FlGridData(show: false),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
      animDuration + const Duration(milliseconds: 50),
    );
    if (isPlaying) {
      await refreshState();
    }
  }
}
