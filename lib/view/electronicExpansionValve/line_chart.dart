import 'dart:async';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

const style = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
    color: Color.fromRGBO(142, 154, 180, 1));

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<List<Color>> gradientColors = [
    [const Color.fromRGBO(64, 205, 254, 1), Colors.transparent],
    [const Color.fromRGBO(185, 233, 124, 1), Colors.transparent],
    [const Color.fromRGBO(193, 193, 193, 1), Colors.transparent],
    [const Color.fromRGBO(241, 254, 64, 1), Colors.transparent],
  ];
  List<List<FlSpot>> data = [
    [],
    [],
    [],
    [],
  ];
  Map xDate = {};
  int limit = 10;
  final deviceInfoController _deviceInfoController = Get.find();
  List name = ["T1", "T2A", "T2", "T2B"];
  List showName = ["T1", "T2A", "T2", "T2B"];
  late Timer _timer;

  int indexkey = 0;
  initRunning() {
    if (_deviceInfoController.indoorEntityList.isEmpty) {
      return;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      List val = [
        _deviceInfoController.indoorEntityList[0]["elecHeatingTempT1Setting"],
        _deviceInfoController.indoorEntityList[0]["t2ATemp"],
        _deviceInfoController.indoorEntityList[0]["t2Temp"],
        _deviceInfoController.indoorEntityList[0]["t2BTemp"]
      ];
      for (int index = 0; index < name.length; index++) {
        // final random = Random();
        // final int min = 18;
        // final int max = 28;
        // final int randomNumber = min + random.nextInt(max - min + 1);
        data[index].add(FlSpot(indexkey.toDouble(), val[index]));
        if (data[index].length > 60) {
          data[index].removeAt(0);
        }
      }

      // if (indexkey > 300) {
      //   indexkey = 0;
      // }

      DateTime now = DateTime.now();
      String formattedDate = DateFormat('hh:mm:ss').format(now);
      xDate[indexkey] = formattedDate;
      indexkey++;
      if (indexkey > 60 * 10) {
        indexkey = 0;
      }
      setState(() {
        data;
        xDate;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initRunning();
  }

  @override
  void dispose() {
    super.dispose();
    try {
      _timer.cancel();
    } catch (e) {}
  }

  switchShow(val) {
    if (showName.contains(val)) {
      showName.remove(val);
    } else {
      showName.add(val);
    }
    setState(() {
      showName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 210,
      width: 720.w,
      child: AspectRatio(
        aspectRatio: 1.70,
        child: Padding(
          padding: const EdgeInsets.only(
            right: 18,
            left: 12,
            top: 12,
            bottom: 12,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "device.checkData.temp",
                      style: style,
                    ).tr(),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        for (var item in name)
                          InkWell(
                            onTap: () {
                              switchShow(item);
                            },
                            child: Opacity(
                              opacity: showName.contains(item) ? 1 : 0.5,
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 12, 0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 2,
                                        color:
                                            gradientColors[name.indexOf(item)]
                                                [0],
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 8, 0),
                                      ),
                                      Text(
                                        item,
                                        style: style,
                                      )
                                    ],
                                  )),
                            ),
                          )
                      ],
                    ))
                  ],
                ),
              ),
              if (xDate.isNotEmpty)
                Expanded(
                    child: LineChart(
                  avgData(),
                ))
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    Widget text;
    text = const Text('', style: style);
    if (value % 30 == 0) {
      text = Text('${xDate[value.toInt()] ?? ""}', style: style);
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  double getRandomDoubleInRange(double min, double max) {
    Random random = Random();
    return min + (max - min) * random.nextDouble();
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('0', style: style);
        break;
      case 10:
        text = const Text('10', style: style);
        break;
      case 20:
        text = const Text('20', style: style);
        break;
      case 30:
        text = const Text('30', style: style);
        break;
      case 40:
        text = const Text('40', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 0,
          );
        },
        getDrawingHorizontalLine: (value) {
          return [10, 20, 30, 39].contains(value)
              ? FlLine(
                  color: const Color.fromRGBO(42, 52, 72, 1),
                  strokeWidth: 0.2,
                  dashArray: [10])
              : FlLine(
                  color: const Color.fromRGBO(42, 52, 72, 1),
                  strokeWidth: 0,
                  dashArray: [10]);
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: Color.fromRGBO(42, 52, 72, 1),
              width: 0.5,
            ),
          )),
      minX: data.isNotEmpty && data[0] != null ? data[0].first.x : 0,
      maxX: data.isNotEmpty && data[0] != null ? data[0].last.x : 0,
      maxY: 36,
      minY: 16,
      lineBarsData: [
        for (int index = 0; index < showName.length; index++)
          LineChartBarData(
            spots: data.isNotEmpty && data[index] != null ? data[index] : [],
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(
                        begin: gradientColors[index][0],
                        end: gradientColors[index][1])
                    .lerp(0.2)!,
                ColorTween(
                        begin: gradientColors[index][0],
                        end: gradientColors[index][1])
                    .lerp(0.2)!,
              ],
            ),
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(
              show: false,
              gradient: LinearGradient(
                colors: [
                  ColorTween(
                          begin: gradientColors[index][0],
                          end: gradientColors[index][1])
                      .lerp(0.2)!
                      .withOpacity(0.1),
                  ColorTween(
                          begin: gradientColors[index][0],
                          end: gradientColors[index][1])
                      .lerp(0.2)!
                      .withOpacity(0.1),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
