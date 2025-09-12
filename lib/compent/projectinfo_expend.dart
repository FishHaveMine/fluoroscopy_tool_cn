import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../style/index.dart';
import 'HorizontalPercentageBarChart.dart';

class projectinfo_expend extends StatefulWidget {
  bool isnearestProject = true;
  bool showMore = true;
  Function? onClick;
  String? search;
  var showing;
  projectinfo_expend(
      {super.key,
      required this.showing,
      this.search,
      this.onClick,
      this.isnearestProject = true,
      this.showMore = true});
  @override
  State<projectinfo_expend> createState() => _projectinfoState();
}

class _projectinfoState extends State<projectinfo_expend> {
  var info;
  double online = 0;
  double error = 0;
  double offline = 0;

  Map nodemap = {
    "Auto_priority": "自动优先",
    "Cooling_priority": "制冷优先",
    "Heating_priority": "制热优先",
    "VIP_priority": "VIP优先",
    "Energy_demand_priority": "能需优先",
    "FirstOpen_Prior": "先开优先",
    "Heating_only": "只制热",
    "Cooling_only": "只制冷",
    "ChangeOver": "ChangeOver",
    "First_enabled": "多开优先"
  };

  @override
  void initState() {
    super.initState();
    try {
      String systemNum = widget.showing["alldata"]["systemNum"].toString();
      String systemFaultNum =
          widget.showing["alldata"]["systemFaultNum"].toString();
      String systsystemOffLineNumemNum =
          widget.showing["alldata"]["systsystemOffLineNumemNum"].toString();
      error = double.tryParse(systemFaultNum) ?? 0;
      offline = double.tryParse(systsystemOffLineNumemNum) ?? 0;
      online = double.parse(systemNum) - error - offline;
    } catch (e) {
      print(e);
    }

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
                InkWell(
                    onTap: () {
                      if (widget.onClick != null) {
                        widget.onClick!();
                      }
                    },
                    onLongPress: () {
                      _copyTextToClipboard(info['code'].toString());
                    },
                    child: Container(
                      width: 230,
                      child: Text(
                        info['code'] ?? "",
                        maxLines: 2,
                        style: normalText(),
                      ),
                    )),
                if (info['projectType'] != null &&
                    info['projectType'] == "fjjngz")
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                            width: 1,
                            color: const Color.fromRGBO(140, 140, 140, 0.5))),
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Text(
                      tr('fjjngz'),
                      style: normalText(lineheight: 1, fSize: 12),
                    ),
                  )
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: infosWidget(
                      'public/images/systemCapabilityAnalysis/system.png',
                      tr("systemNum"),
                      info['systemCount'].toString()),
                ),
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
            ),
            const Padding(padding: EdgeInsets.fromLTRB(0, 16, 0, 0)),
            if (info["alldata"]["outdoorModeSettingEnumIntegerMap"] != null &&
                widget.showMore)
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: ExpansionTile(
                      initiallyExpanded: true,
                      collapsedTextColor: Colors.black,
                      textColor: Colors.black,
                      iconColor: Colors.black,
                      collapsedIconColor: Colors.black,
                      title: const Text(
                        "projectDetail.expend1",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ).tr(),
                      trailing: const Text(""),
                      children: [
                        SizedBox(
                          width: 720.w - 24.w * 2 - 16 * 2 - 16 * 2,
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            children: [
                              for (var index in info["alldata"]
                                      ["outdoorModeSettingEnumIntegerMap"]
                                  .keys)
                                cardinfo(item: {
                                  'icon': nodemap[index],
                                  'name': nodemap[index],
                                  'val': info["alldata"][
                                              "outdoorModeSettingEnumIntegerMap"]
                                          [index]
                                      .toString(),
                                })
                            ],
                          ),
                        )
                      ])),
            if (widget.showMore)
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: ExpansionTile(
                      initiallyExpanded: true,
                      collapsedTextColor: Colors.black,
                      textColor: Colors.black,
                      iconColor: Colors.black,
                      collapsedIconColor: Colors.black,
                      title: const Text(
                        "projectDetail.expend2",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ).tr(),
                      trailing: Text(
                          "${tr("outdoorPowerRationing")} ${info["alldata"]["outdoorPowerRationing"] ?? "--"}"),
                      children: const [])),
            if (widget.showMore)
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: ExpansionTile(
                      initiallyExpanded: true,
                      collapsedTextColor: Colors.black,
                      textColor: Colors.black,
                      iconColor: Colors.black,
                      collapsedIconColor: Colors.black,
                      title: const Text(
                        "projectDetail.expend3",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ).tr(),
                      trailing: Text(
                          "${tr('outdoorMuteSetting')} ${info["alldata"]["outdoorMuteSetting"] ?? "--"}"),
                      children: const []))
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
            style: const TextStyle(color: Colors.black),
          ),
        );
      }
      // 添加关键词部分，并标红
      textSpans.add(
        TextSpan(
          text: longString.substring(match.start, match.end),
          style:
              const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
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
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 3),
            child: Text(
              val,
              style: normalTextBlack(),
            )),
      ],
    );
  }
}

class cardinfo extends StatelessWidget {
  var iconmap = {
    "自动优先": "AutoPriority",
    "制冷优先": "CoolPriority",
    "VIP优先": "VIPPriority",
    "只制热": "HeatOnly",
    "只制冷": "CoolOnly",
    "制热优先": "HeatPriority",
    "ChangeOver": "ChangeOver",
    "多开优先": "MultiOpenPriority",
    "先开优先": "StartFirstPriority",
    "能需优先": "DemandPriority",
  };
  var item;
  cardinfo({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (720.w - 24.w * 2 - 16 * 2 - 16 * 2) / 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: Image.asset(
                  'public/images/cloud/${iconmap[item!['icon']]}.png',
                  height: 28.w,
                ),
              ),
              Text(
                item!['name']!,
                style: const TextStyle(
                    fontSize: 14.0, color: Color.fromRGBO(13, 13, 13, 0.5)),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: Text(
                  item!['val']!,
                  style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(13, 13, 13, 1)),
                ),
              ),
              const Text(
                'unit.tai',
                style: TextStyle(
                    fontSize: 12.0, color: Color.fromRGBO(13, 13, 13, 0.5)),
              ).tr()
            ]),
          )
        ],
      ),
    );
  }
}
