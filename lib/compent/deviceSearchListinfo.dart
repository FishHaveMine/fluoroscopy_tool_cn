import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../style/index.dart';
import '../view/local/publicFunction.dart';
import 'HorizontalPercentageBarChart.dart';

class deviceSearchListinfo extends StatefulWidget {
  String? search;
  var showing;
  deviceSearchListinfo({super.key, required this.showing, this.search});
  @override
  State<deviceSearchListinfo> createState() => _projectinfoState();
}

class _projectinfoState extends State<deviceSearchListinfo> {
  var info;
  @override
  void initState() {
    super.initState();
    setState(() {
      info = widget.showing;
    });
    print("deviceSearchListinfo: $info");
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _copyTextToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${tr('projectDetail.deviceManage.copy')}: $text'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: [
            if (info['systemName'] != null)
              Row(
                children: [
                  widget.search == null || widget.search == ""
                      ? Text(
                          info['systemName'],
                          style:
                              normalTextBlack(fSize: 18, fw: FontWeight.w500),
                        )
                      : buildRichText(),
                ],
              ),
            Row(
              children: [
                Text(
                  "${tr('deviceListinfo.sn')} ",
                  style: normalText(),
                ),
                Expanded(
                  child: Text(
                    info['sn'],
                    style: normalText(),
                  ),
                )
                // TextButton(
                //     onPressed: () {
                //       _copyTextToClipboard(info['sn']);
                //     },
                //     child: Text(tr('projectDetail.deviceManage.copy')))
              ],
            ),
            Row(
              children: [
                Text(
                  "${tr('deviceListinfo.gaywaysn')} ",
                  style: normalText(),
                ),
                Expanded(
                  child: Text(
                    info['gatewaySn'],
                    style: normalText(),
                  ),
                ),
                // TextButton(
                //     onPressed: () {
                //       _copyTextToClipboard(info['gatewaySn']);
                //     },
                //     child: Text(tr('projectDetail.deviceManage.copy')))
              ],
            ),
            deviceStatus(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              rowinfo(
                text: '模式优先:',
                val: "自动优先",
              ),
              rowinfo(
                text: '限电:',
                val: "60%",
              ),
              rowinfo(
                text: '静音:',
                val: "14挡",
              ),
            ]),
            Row(
              children: [
                infosWidget(
                    'public/images/systemCapabilityAnalysis/outdoor.png',
                    tr("local.ODU"),
                    info['outdoorNum'].toString()),
                infosWidget('public/images/systemCapabilityAnalysis/indoor.png',
                    tr("local.IDU"), info['indoorNum'].toString()),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                    child: HorizontalPercentageBarChart(
                      barHeight: 16,
                      barWidth: 720.w - 16 * 2 - 24.w * 2 - 110 * 2,
                      borderRadius: 16,
                      data: [
                        NamedValueColor(
                            name: tr('error'),
                            value: double.parse(info['indoorFault'].toString()),
                            color: Colors.red),
                        NamedValueColor(
                            name: tr('offline'),
                            value:
                                double.parse(info['indoorOffline'].toString()),
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
    String longString = info['systemName'];
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

class rowinfo extends StatelessWidget {
  final String text;
  final String val;
  rowinfo({super.key, required this.text, required this.val});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: normalText(),
        ),
        Text(
          val,
          style: normalTextBlack(),
        )
      ],
    );
  }
}

class deviceStatus extends StatelessWidget {
  deviceStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Color.fromRGBO(223, 223, 223, 1),
              width: 0.5,
            ),
          )),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(
                height: 48.h,
                child: Center(
                  child: Text('120HP',
                          style: normalTextBlack(
                              lineheight: 1, fSize: 18, fw: FontWeight.w600))
                      .tr(),
                ),
              ),
              SizedBox(
                child: Center(
                  child: Text('totalMatches',
                          textAlign: TextAlign.center, style: normalTextS())
                      .tr(),
                ),
              )
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 48.h,
                child: Center(
                  child: Text('110%',
                          style: normalTextBlack(
                              lineheight: 1, fSize: 18, fw: FontWeight.w600))
                      .tr(),
                ),
              ),
              SizedBox(
                child: Center(
                  child: Text('matchingNumber',
                          textAlign: TextAlign.center, style: normalTextS())
                      .tr(),
                ),
              )
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 48.h,
                child: Center(
                  child: Text('100%',
                          style: normalTextBlack(
                              lineheight: 1, fSize: 18, fw: FontWeight.w600))
                      .tr(),
                ),
              ),
              SizedBox(
                child: Center(
                  child: Text('trafficusage',
                          textAlign: TextAlign.center, style: normalTextS())
                      .tr(),
                ),
              )
            ],
          ),
          Column(
            children: [
              Image.asset(
                'public/images/icon/icon_cool.png',
                width: 48.w,
                color: const Color.fromRGBO(62, 205, 255, 1),
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 4.h)),
              SizedBox(
                child: Center(
                  child: Text('送风免费制冷',
                          textAlign: TextAlign.center, style: normalTextS())
                      .tr(),
                ),
              )
            ],
          ),
          Column(
            children: [
              Image.asset(
                'public/images/checkData/error.png',
                width: 48.w,
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 4.h)),
              SizedBox(
                child: Center(
                  child: Text('--',
                          textAlign: TextAlign.center, style: normalTextS())
                      .tr(),
                ),
              )
            ],
          )
        ],
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
