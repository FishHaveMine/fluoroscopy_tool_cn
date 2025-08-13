import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample11 extends StatefulWidget {
  const LineChartSample11({super.key});

  @override
  State<LineChartSample11> createState() => _LineChartSample11State();
}

class _LineChartSample11State extends State<LineChartSample11> {
  var baselineX = 0.0;
  var baselineY = 0.0;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 18.0,
          right: 18.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  RotatedBox(
                    quarterTurns: 1,
                    child: Slider(
                      value: baselineY,
                      onChanged: (newValue) {
                        setState(() {
                          baselineY = newValue;
                        });
                      },
                      min: -10,
                      max: 1000,
                    ),
                  ),
                  Expanded(
                    child: _Chart(
                      baselineX,
                      (20 - (baselineY + 10)) - 10,
                    ),
                  )
                ],
              ),
            ),
            Slider(
              value: baselineX,
              onChanged: (newValue) {
                setState(() {
                  baselineX = newValue;
                });
              },
              min: -10,
              max: 1000,
            ),
          ],
        ),
      ),
    );
  }
}

class _Chart extends StatefulWidget {
  final double baselineX;
  final double baselineY;

  _Chart(this.baselineX, this.baselineY) : super();

  @override
  State<_Chart> createState() => __ChartState();
}

class __ChartState extends State<_Chart> {
  Widget getHorizontalTitles(value, TitleMeta meta) {
    TextStyle style;
    if ((value - widget.baselineX).abs() <= 0.1) {
      style = const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );
    } else {
      style = const TextStyle(
        color: Colors.white60,
        fontSize: 14,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(meta.formattedValue, style: style),
    );
  }

  Widget getVerticalTitles(value, TitleMeta meta) {
    TextStyle style;
    if ((value - widget.baselineY).abs() <= 0.1) {
      style = const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );
    } else {
      style = const TextStyle(
        color: Colors.white60,
        fontSize: 14,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(meta.formattedValue, style: style),
    );
  }

  FlLine getHorizontalVerticalLine(double value) {
    if ((value - widget.baselineY).abs() <= 0.1) {
      return FlLine(
        color: Colors.white70,
        strokeWidth: 1,
        dashArray: [8, 4],
      );
    } else {
      return FlLine(
        color: Colors.blueGrey,
        strokeWidth: 0.4,
        dashArray: [8, 4],
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fixdata();
  }

  FlLine getVerticalVerticalLine(double value) {
    if ((value - widget.baselineX).abs() <= 0.1) {
      return FlLine(
        color: Colors.white70,
        strokeWidth: 1,
        dashArray: [8, 4],
      );
    } else {
      return FlLine(
        color: Colors.blueGrey,
        strokeWidth: 0.4,
        dashArray: [8, 4],
      );
    }
  }

  List titleColumn = ["环境温度T4", "限额", "高压压力", "低压压力"];
  List showing = ["环境温度T4", "限额", "高压压力", "低压压力"];
  List colorslist = [
    const Color.fromRGBO(0, 128, 255, 1),
    const Color.fromRGBO(82, 221, 13, 1),
    const Color.fromRGBO(255, 192, 1, 1),
    const Color.fromRGBO(255, 51, 103, 1),
    const Color.fromRGBO(13, 221, 168, 1)
  ];
  Map<String, List<FlSpot>> data = {};
  Map<String, Color> dataColor = {};
  TextStyle labelstyle = const TextStyle(
      fontWeight: FontWeight.w400,
      color: Color.fromRGBO(13, 13, 13, 1),
      fontSize: 9);
  double max = 0;
  double minSpotX = 0;
  double maxSpotX = 0;
  double minSpotY = 0;
  double maxSpotY = 0;
  fixdata() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      int index = 0;
      for (var row in titleColumn) {
        data[row] = [];
        dataColor[row] = colorslist[index];
        index++;
        List<FlSpot> mock = [];
        for (int i = 0; i < 5; i++) {
          var val = Random().nextDouble() * 400;
          max = max > val ? max : val;
          mock.add(FlSpot(i.toDouble(), val));
        }
        data[row] = mock;
      }
      maxSpotX = max;
      maxSpotY = max;
      setState(() {
        data;
        maxSpotX;
        maxSpotY;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          for (var key in data.keys
              .toList()
              .where((element) => showing.contains(element)))
            LineChartBarData(
              gradient: LinearGradient(
                colors: [
                  dataColor[key]!,
                  dataColor[key]!,
                ],
              ),
              spots: reverseSpots(data[key]!, minSpotY, maxSpotY),
              isCurved: true,
              isStrokeCapRound: true,
              barWidth: 2,
              belowBarData: BarAreaData(
                show: false,
              ),
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 2,
                    color: Color.lerp(
                      dataColor[key]!,
                      dataColor[key]!,
                      percent / 100,
                    )!,
                    strokeColor: Colors.white,
                    strokeWidth: 1,
                  );
                },
              ),
            ),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getVerticalTitles,
              reservedSize: 36,
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: getHorizontalTitles,
                reservedSize: 32),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getVerticalTitles,
              reservedSize: 36,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: getHorizontalTitles,
                reservedSize: 32),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: getHorizontalVerticalLine,
          getDrawingVerticalLine: getVerticalVerticalLine,
        ),
        minY: -10,
        maxY: 10,
        baselineY: widget.baselineY,
        minX: -10,
        maxX: 10,
        baselineX: widget.baselineX,
      ),
    );
  }

  double reverseY(double y, double minX, double maxX) {
    return y;
  }

  List<FlSpot> reverseSpots(List<FlSpot> inputSpots, double minY, double maxY) {
    return inputSpots.map((spot) {
      return spot.copyWith(y: (maxY + minY) - spot.y);
    }).toList();
  }
}
