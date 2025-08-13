import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../style/index.dart';
import 'HorizontalPercentageBarChart.dart';

class projectinfo extends StatefulWidget {
  Function? onClick;
  String? search;
  var showing;
  projectinfo({super.key, required this.showing, this.search, this.onClick});
  @override
  State<projectinfo> createState() => _projectinfoState();
}

class _projectinfoState extends State<projectinfo> {
  var info;
  double online = 0;
  double error = 0;
  double offline = 0;
  @override
  void initState() {
    super.initState();
    //   OFFLINE(0, "离线", 4, "Offline"),

    //   ONLINE(5, "在线", 2, "Online"),

    //   OPEN(1, "运行", 1, "ON"),

    //   FAULT(2, "故障", 3, "Fault"),

    //   CLOSE(3, "关机", 2, "OFF");
    try {
      String systemNum = widget.showing["systemNum"].toString();
      String systemFaultNum = widget.showing["systemFaultNum"].toString();
      String systsystemOffLineNumemNum =
          widget.showing["systsystemOffLineNumemNum"].toString();
      error = double.tryParse(systemFaultNum) ?? 0;
      offline = double.tryParse(systsystemOffLineNumemNum) ?? 0;
      online = double.parse(systemNum) - error - offline;
    } catch (e) {
      if (widget.showing["data"] != null &&
          widget.showing["data"]["deviceStatus"] != null) {
        for (var element in widget.showing["data"]["deviceStatus"]) {
          if (["1", "5", "2", "3"].contains(element["code"].toString())) {
            online = online + double.parse(element["value"].toString());
          }
          if (element["en"] == "Fault") {
            error = double.parse(element["value"].toString());
            // if (error != 999) online = online - error;
          }
          if (element["en"] == "Offline") {
            offline = double.parse(element["value"].toString());
            // if (offline != 999) online = online - offline;
          }
        }
      }
    }

    // if (error == 999 || offline == 999) {
    //   error = offline != 999 && error == 999 ? 0 : error;
    //   offline = error != 999 && offline == 999 ? 0 : offline;
    // }
    setState(() {
      info = widget.showing;

      online;
      error;
      offline;
    });
  }

  void _copyTextToClipboard(String text) {
    if (text != null) {
      Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${tr('projectDetail.deviceManage.copy')}: $text'),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                widget.search == null || widget.search == ""
                    ? Expanded(
                        child: InkWell(
                            onTap: () {
                              if (widget.onClick != null) {
                                widget.onClick!();
                              }
                            },
                            onLongPress: () {
                              _copyTextToClipboard(info['name'].toString());
                            },
                            child: Text(
                              info['name'] ?? "",
                              style: normalTextBlack(
                                  fSize: 18, fw: FontWeight.w500),
                            )))
                    : Expanded(child: buildRichText()),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                  child: Image.asset(
                    'public/images/systemCapabilityAnalysis/location.png',
                    width: 9,
                    color: const Color.fromRGBO(13, 13, 13, 0.5),
                  ),
                ),
                Expanded(
                  child: Text(
                    info['address'] ?? "",
                    style: normalText(),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  "${tr('project.code')} ",
                  style: normalText(),
                ),
                Expanded(
                    child: InkWell(
                        onTap: () {
                          if (widget.onClick != null) {
                            widget.onClick!();
                          }
                        },
                        onLongPress: () {
                          _copyTextToClipboard(info['code'].toString());
                        },
                        child: Text(
                          info['code'] ?? "",
                          style: normalText(),
                        ))),
              ],
            ),
            Row(
              children: [
                infosWidget(
                    'public/images/systemCapabilityAnalysis/outdoor.png',
                    tr("local.ODU"),
                    info['outdoorCount'].toString()),
                infosWidget('public/images/systemCapabilityAnalysis/indoor.png',
                    tr("local.IDU"), info['indoorCount'].toString()),
              ],
            ),
            Row(
              children: [
                ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 230.w, // 设置最大宽度
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                      child: infosWidget(
                          'public/images/systemCapabilityAnalysis/system.png',
                          tr("systemNum"),
                          info['systemCount'].toString()),
                    )),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: HorizontalPercentageBarChart(
                      barHeight: 16,
                      barWidth: 720.w - 16 * 2 - 24.w * 2 - 110,
                      borderRadius: 16,
                      data: [
                        NamedValueColor(
                            name: tr('online'),
                            value: online,
                            color: Colors.green),
                        NamedValueColor(
                            name: tr('error'), value: error, color: Colors.red),
                        NamedValueColor(
                            name: tr('offline'),
                            value: offline,
                            color: const Color.fromRGBO(211, 219, 237, 1)),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ));
  }

  Widget buildRichText() {
    String longString = info['name'];
    String keyString = widget.search!;
    List<TextSpan> textSpans = [];

    // 使用正则表达式进行匹配，忽略大小写
    RegExp regExp = RegExp(keyString, caseSensitive: false);
    Iterable<Match> matches = regExp.allMatches(longString);

    int lastMatchEnd = 0;

    for (Match match in matches) {
      // 添加非关键词部分
      if (match.start > lastMatchEnd) {
        textSpans.add(
          TextSpan(
            text: longString.substring(lastMatchEnd, match.start),
            style: TextStyle(color: Colors.black),
          ),
        );
      }
      // 添加关键词部分，并标红
      textSpans.add(
        TextSpan(
          text: longString.substring(match.start, match.end),
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      );
      lastMatchEnd = match.end;
    }

    // 添加剩余的非关键词部分
    if (lastMatchEnd < longString.length) {
      textSpans.add(
        TextSpan(
          text: longString.substring(lastMatchEnd),
          style: normalTextBlack(fSize: 18, fw: FontWeight.w500),
        ),
      );
    }

    return RichText(
      text: TextSpan(
        style: normalTextBlack(fSize: 18, fw: FontWeight.w500),
        children: textSpans,
      ),
    );
  }
}

class infosWidget extends StatelessWidget {
  final String img;
  final String text;
  final String val;

  // Constructor to initialize the widget with data
  infosWidget(this.img, this.text, this.val);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 2, 5, 0),
          child: Image.asset(
            img,
            width: 16,
            color: const Color.fromRGBO(13, 13, 13, 0.5),
          ),
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 5, 3),
            child: Text(
              text,
              style: normalText(),
            )),
        Container(
          width: 50,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 3),
              child: Text(
                val,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: normalTextBlack(),
              )),
        ),
      ],
    );
  }
}
