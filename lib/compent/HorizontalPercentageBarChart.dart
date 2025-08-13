import 'dart:convert';

import 'package:fluoroscopy_tool/style/index.dart';
import 'package:flutter/material.dart';

class NamedValueColor {
  final String name;
  double value;
  final Color color;

  NamedValueColor({
    required this.name,
    required this.value,
    required this.color,
  });

  @override
  String toString() {
    return '$name: $value';
  }
}

class HorizontalPercentageBarChart extends StatefulWidget {
  bool? iscountAlll;
  List<NamedValueColor> data;
  double barHeight;
  double barWidth;
  double borderRadius;
  HorizontalPercentageBarChart({
    super.key,
    this.iscountAlll = false,
    required this.data,
    required this.barHeight,
    required this.barWidth,
    required this.borderRadius,
  });

  @override
  State<HorizontalPercentageBarChart> createState() =>
      _HorizontalPercentageBarChartState();
}

class _HorizontalPercentageBarChartState
    extends State<HorizontalPercentageBarChart> {
  late double barHeight;
  late double barWidth;
  late double borderRadius;
  List<double> percentages = [];
  List<Color> colors = [];
  List<NamedValueColor> data = [];
  List<NamedValueColor> copiedList = [];
  List<String> hidden = [];

  init() {
    percentages = [];
    colors = [];
    if (copiedList.isEmpty) {
      copiedList = List.from(widget.data);
      // copiedList.sort((a, b) => a.value.compareTo(b.value));
    }

    List<NamedValueColor> filldata = List.from(copiedList);
    data = filldata.where((item) => !hidden.contains(item.name)).toList();

    if (widget.iscountAlll == true) {
      double all = 0;
      int allindex = 0;
      for (int index = 0; index < data.length; index++) {
        var item = data[index];
        if (item.name != "全部") {
          all = all + item.value;
        } else {
          allindex = index;
        }
      }
      var removedElement = data.removeAt(allindex);
      removedElement.value = all + 0.01;
      data.add(removedElement);
    }
    data.sort((a, b) => b.value.compareTo(a.value));

    double max = data[0].value == 0 ? 999 : data[0].value;
    for (var element in data) {
      percentages.add(element.value / max);
      colors.add(element.color);
    }
    if (!percentages.any((element) => element > 0)) {
      percentages[percentages.length - 1] = 1;
    }
    barHeight = widget.barHeight;
    barWidth = widget.barWidth;
    borderRadius = widget.borderRadius;
    setState(() {
      data;
      copiedList;
      barHeight;
      barWidth;
      borderRadius;
      percentages;
      colors;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.iscountAlll == true) {
      data = widget.data;
      double all = 0;
      for (var item in widget.data) {
        all = all + item.value;
      }
      data.add(NamedValueColor(
          name: '全部',
          value: all == 0 ? 999 : 0,
          color: const Color.fromRGBO(239, 239, 239, 1)));
      data.sort((a, b) => b.value.compareTo(a.value));
    }
    init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: barWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: barWidth,
            height: barHeight,
            child: CustomPaint(
              painter: BarChartPainter(
                percentages: percentages,
                barHeight: barHeight,
                barWidth: barWidth,
                borderRadius: borderRadius,
                colors: colors,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var item in copiedList)
                if (item.name != "全部")
                  InkWell(
                    onTap: () {
                      if (hidden.contains(item.name)) {
                        hidden.remove(item.name);
                      } else {
                        if (hidden.length != widget.data.length - 1) {
                          hidden.add(item.name);
                        }
                      }
                      init();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          margin: EdgeInsets.fromLTRB(0, 5, 4, 0),
                          decoration: BoxDecoration(
                            color: item.color,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                          child: SizedBox(
                            width: 23,
                            child: Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              style: normalText(fSize: 10),
                            ),
                          ),
                        ),
                        Text(
                          item.value == 999
                              ? "0"
                              : item.value.toStringAsFixed(0),
                          style: normalTextBlack(fSize: 10),
                        )
                      ],
                    ),
                  )
            ],
          )
        ],
      ),
    );
  }
}

class BarChartPainter extends CustomPainter {
  final List<double> percentages;
  final double barHeight;
  final double barWidth;
  final double borderRadius;
  final List<Color> colors;

  BarChartPainter({
    required this.percentages,
    required this.barHeight,
    required this.barWidth,
    required this.borderRadius,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint fillPaint = Paint()..style = PaintingStyle.fill;

    double totalWidth = barWidth;
    double startX = 0;

    for (int i = 0; i < percentages.length; i++) {
      double percentage = percentages[i];
      double barLength = percentage * totalWidth;

      fillPaint.color = colors[i];

      Rect fillRect = Rect.fromLTWH(0, 0, barLength, barHeight);
      RRect fillRRect =
          RRect.fromRectAndRadius(fillRect, Radius.circular(borderRadius));
      canvas.drawRRect(fillRRect, fillPaint);

      startX += barLength;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
