import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PieChartSample2 extends StatefulWidget {
  List? dataPieChar = [];
  PieChartSample2({super.key, this.dataPieChar});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartSample2> {
  int touchedIndex = -1;

  static const ColorList = [
    Color.fromRGBO(108, 164, 255, 1),
    Color.fromRGBO(255, 114, 114, 1),
    Color.fromRGBO(240, 240, 240, 1)
  ];
  List data = [
    {"key": tr("online"), "value": "1"},
    {"key": tr("error"), "value": "1"},
    {"key": tr("offline"), "value": "1"}
  ];

  List active = [];

  init() {
    // 计算总和
    if (widget.dataPieChar != null) data = widget.dataPieChar!;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      int total = 0;
      for (var item in data) {
        active.add(item['key']);
        total += int.parse(item['value']!);
      }
      // 计算占比并打印
      for (var item in data) {
        double percentage = (int.parse(item['value']!) / total) * 100;
        item['pre'] = percentage.toString();
      }

      setState(() {
        data;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      key: ValueKey('PieChart${active.length}'),
      child: Row(
        children: <Widget>[
          Expanded(
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 0,
                centerSpaceRadius: 35,
                sections: showingSections(data
                    .where((element) => active.contains(element['key']))
                    .toList()),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (int index = 0; index < data.length; index++)
                  InkWell(
                    onTap: () {
                      if (active.contains(data[index]['key'])) {
                        active.remove(data[index]['key']);
                      } else {
                        active.add(data[index]['key']);
                      }
                      setState(() {
                        active;
                      });
                    },
                    child: Opacity(
                      opacity: active.contains(data[index]['key']) ? 1 : 0.45,
                      child: Indicator(
                        color: ColorList[index],
                        text: '${data[index]['key']}  ${data[index]['value']}',
                      ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(List arr) {
    bool showTitle = false;
    return List.generate(arr.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 15.0 : 8.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      return PieChartSectionData(
        showTitle: showTitle,
        color: ColorList[i],
        value: double.parse(arr[i]['pre']),
        title: '${arr[i]['pre'] * 100}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    });
  }
}

class Indicator extends StatefulWidget {
  Color color;
  String text;
  Indicator({super.key, required this.color, required this.text});

  @override
  State<Indicator> createState() => _IndicatorState();
}

class _IndicatorState extends State<Indicator> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: const EdgeInsets.fromLTRB(0, 4, 0, 0),
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(49),
                color: widget.color,
              )),
          Container(
            height: 24,
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Text(
              widget.text,
              style: normalTextS(),
            ),
          )
        ],
      ),
    );
  }
}
