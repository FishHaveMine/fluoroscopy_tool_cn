import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class card5 extends StatefulWidget {
  card5({super.key, required this.data});
  List data = [];
  List ColorList = [
    const Color.fromRGBO(0, 108, 234, 1),
    const Color.fromRGBO(0, 234, 219, 1),
    const Color.fromRGBO(76, 220, 33, 1),
    const Color.fromRGBO(211, 219, 237, 1)
  ];
  final Color avgColor = const Color.fromRGBO(252, 178, 60, 1);
  @override
  State<card5> createState() => _card5State();
}

class _card5State extends State<card5> {
  final double width = 7;
  double maxY = 20;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  List data = [];
  List title = [];
  List filterIndex = [];
  int touchedGroupIndex = -1;

  _filterIndex(index) {
    if (filterIndex.contains(index)) {
      filterIndex.remove(index);
    } else {
      filterIndex.add(index);
    }
    setState(() {
      filterIndex;
    });
    _init();
  }

  _init() {
    print(widget.data);
    if (widget.data[0]["data"].isEmpty) {
      final barGroup1 = makeGroupData(0, 0, 0, 0);
      final barGroup2 = makeGroupData(1, 0, 0, 0);
      final barGroup3 = makeGroupData(2, 0, 0, 0);

      final items = [
        barGroup1,
        barGroup2,
        barGroup3,
      ];

      rawBarGroups = items;

      showingBarGroups = rawBarGroups;
      setState(() {
        title;
        maxY;
        rawBarGroups;
        showingBarGroups;
      });
      return;
    }
    if (widget.data.isNotEmpty) {
      data = [];
      title = [];
      for (var element in widget.data) {
        title.add(element["name"]);
        data.add(
            element["data"].map((e) => double.parse(e.toString())).toList());
      }

      // 遍历 filterIndex，将对应子数组的元素全部清零
      for (int index in filterIndex) {
        for (var e in data) {
          e[index] = 0.0;
        }
      }

      // 找到数组中的最大值
      double maxValue = data
          .expand((i) => i)
          .reduce((curr, next) => curr > next ? curr : next);

      // 计算比最大值大的10的倍数
      print(data);
      maxY = ((maxValue + 9) ~/ 10 * 10).toDouble();
      final barGroup1 = makeGroupData(0, data[0][0], data[1][0], data[2][0]);
      final barGroup2 = makeGroupData(1, data[0][1], data[1][1], data[2][1]);
      final barGroup3 = makeGroupData(2, data[0][2], data[1][2], data[2][2]);

      final items = [
        barGroup1,
        barGroup2,
        barGroup3,
      ];

      rawBarGroups = items;

      showingBarGroups = rawBarGroups;
      setState(() {
        title;
        maxY;
        rawBarGroups;
        showingBarGroups;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            if (title.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    for (var n in title)
                      InkWell(
                        onTap: () {
                          _filterIndex(title.indexOf(n));
                        },
                        child: Opacity(
                          opacity:
                              filterIndex.contains(title.indexOf(n)) ? 0.4 : 1,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  margin: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                  color: widget.ColorList[title.indexOf(n)],
                                ),
                                Text(
                                  tr(n),
                                  style: const TextStyle(
                                    color: Color.fromRGBO(142, 154, 180, 1),
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: maxY,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (a, b, c, d) => null,
                    ),
                    touchCallback: (FlTouchEvent event, response) {
                      return;
                      if (response == null || response.spot == null) {
                        setState(() {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                        });
                        return;
                      }

                      touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                      setState(() {
                        if (!event.isInterestedForInteractions) {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                          return;
                        }
                        showingBarGroups = List.of(rawBarGroups);
                        if (touchedGroupIndex != -1) {
                          var sum = 0.0;
                          for (final rod
                              in showingBarGroups[touchedGroupIndex].barRods) {
                            sum += rod.toY;
                          }
                          final avg = sum /
                              showingBarGroups[touchedGroupIndex]
                                  .barRods
                                  .length;

                          showingBarGroups[touchedGroupIndex] =
                              showingBarGroups[touchedGroupIndex].copyWith(
                            barRods: showingBarGroups[touchedGroupIndex]
                                .barRods
                                .map((rod) {
                              return rod.copyWith(
                                  toY: avg, color: widget.avgColor);
                            }).toList(),
                          );
                        }
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
                        getTitlesWidget: bottomTitles,
                        reservedSize: 42,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 45,
                        interval: 1,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border.symmetric(
                      horizontal: BorderSide(
                        color: Color.fromRGBO(142, 154, 180, 0.6),
                      ),
                    ),
                  ),
                  barGroups: showingBarGroups,
                  gridData: FlGridData(
                    show: true,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: const Color.fromRGBO(142, 154, 180, 0.6),
                      strokeWidth: 1,
                    ),
                    drawVerticalLine: false,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontSize: 14,
    );
    String text;
    if (value % 10 == 0) {
      text = value.toStringAsFixed(0);
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 15,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['dayselect1', 'dayselect2', 'dayselect3'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontSize: 12,
      ),
    ).tr();

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2, double y3) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.ColorList[0],
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: widget.ColorList[1],
          width: width,
        ),
        BarChartRodData(
          toY: y3,
          color: widget.ColorList[2],
          width: width,
        ),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}
