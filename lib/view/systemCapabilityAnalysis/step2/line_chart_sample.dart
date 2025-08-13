import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LineChartSample extends StatefulWidget {
  const LineChartSample({super.key});

  @override
  State<LineChartSample> createState() => _LineChartSampleState();
}

class _LineChartSampleState extends State<LineChartSample> {
  @override
  void initState() {
    super.initState();
    fixdata();
  }

  @override
  void dispose() {
    super.dispose();
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

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final intValue = reverseY(value, minSpotY, maxSpotY).toInt();

    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Text(
        intValue.toString(),
        style: labelstyle,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    final intValue = reverseY(value, minSpotY, maxSpotY).toInt();

    return Text(intValue.toString(),
        style: labelstyle, textAlign: TextAlign.right);
  }

  Widget topTitleWidgets(double value, TitleMeta meta) {
    if (value % 1 != 0) {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(value.toInt().toString(), style: labelstyle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 22, top: 20),
            child: AspectRatio(
              aspectRatio: 2,
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipRoundedRadius: 0,
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          return LineTooltipItem(
                            touchedSpot.y.toString(),
                            TextStyle(
                              color: touchedSpot.bar.gradient!.colors.first,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          );
                        }).toList();
                      },
                    ),
                    getTouchedSpotIndicator: (
                      _,
                      indicators,
                    ) {
                      return indicators
                          .map((int index) => TouchedSpotIndicatorData(
                                FlLine(color: Colors.transparent),
                                FlDotData(show: false),
                              ))
                          .toList();
                    },
                    touchSpotThreshold: 12,
                    distanceCalculator:
                        (Offset touchPoint, Offset spotPixelCoordinates) =>
                            (touchPoint - spotPixelCoordinates).distance,
                  ),
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
                  minY: 0,
                  maxY: maxSpotY + minSpotY,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: leftTitleWidgets,
                        reservedSize: 38,
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: rightTitleWidgets,
                        reservedSize: 30,
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: topTitleWidgets,
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    checkToShowHorizontalLine: (value) {
                      final intValue =
                          reverseY(value, minSpotY, maxSpotY).toInt();

                      if (intValue == (maxSpotY + minSpotY).toInt()) {
                        return false;
                      }

                      return true;
                    },
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      left: BorderSide(color: Colors.grey),
                      top: BorderSide(color: Colors.grey),
                      bottom: BorderSide(color: Colors.grey),
                      right: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Wrap(
          spacing: 10.0, // 间隔
          runSpacing: 4.0, // 行间距
          children: List.generate(
              dataColor.keys.toList().length,
              ((index) => InkWell(
                    onTap: () {
                      String key = dataColor.keys.toList()[index];
                      if (showing.contains(key)) {
                        showing.remove(key);
                      } else {
                        showing.add(key);
                      }
                      setState(() {
                        showing;
                      });
                    },
                    child: Opacity(
                      opacity: showing.contains(dataColor.keys.toList()[index])
                          ? 1
                          : 0.6,
                      child: SizedBox(
                        width: 720.w / 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 10,
                              height: 2,
                              margin: const EdgeInsets.fromLTRB(0, 3, 10, 0),
                              color: colorslist[index],
                            ),
                            Text(
                              dataColor.keys.toList()[index],
                              style: normalTextS(),
                            )
                          ],
                        ),
                      ),
                    ),
                  ))),
        )
      ],
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
