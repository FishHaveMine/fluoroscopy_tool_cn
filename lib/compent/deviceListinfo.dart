import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/view/cloud/projectManage/projectDetail.dart';
import 'package:fluoroscopy_tool/view/cloud/publicFunction.dart';
import 'package:fluoroscopy_tool/view/userinfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import '../style/index.dart';
import '../view/cloud/device/ deviceDetail.dart';
import 'HorizontalPercentageBarChart.dart';

import 'package:get/get.dart';

class deviceListinfo extends StatefulWidget {
  String? search;
  Function? onSelect;
  bool? isSelect;
  bool showproject = true;
  var showing;
  deviceListinfo(
      {super.key,
      required this.showing,
      this.search,
      this.onSelect,
      this.showproject = true,
      this.isSelect});
  @override
  State<deviceListinfo> createState() => _projectinfoState();
}

class _projectinfoState extends State<deviceListinfo> {
  final userinfoController _promissioncontroller = Get.find();

  static const platform =
      MethodChannel('samples.flutter.dev/getProjectHandler');
  var info;
  double online = 999;
  double error = 999;
  double offline = 999;
  Color statusColor = const Color.fromRGBO(140, 140, 140, 1);
  @override
  void initState() {
    super.initState();
    error;
    offline;
    setState(() {
      info = jsonDecode(jsonEncode(widget.showing));
    });

    // print("info-------------------- > $info");
    try {
      if (info["status"] != null) {
        switch (info["status"].toString()) {
          case "0":
            statusColor = const Color.fromRGBO(140, 140, 140, 1);
            break;
          case "5":
            statusColor = Colors.green;
            break;
          case "1":
            statusColor = Colors.green;
            break;
          case "2":
            statusColor = Colors.red;
            break;
          case "3":
            statusColor = Colors.red;
            break;
          default:
            statusColor = const Color.fromRGBO(140, 140, 140, 1);
        }
        setState(() {
          statusColor;
        });
      }
    } catch (e) {}
    try {
      online = double.parse(info["indoorNum"].toString());
      error = double.parse(info["indoorFault"].toString());
      offline = double.parse(info["indoorOffline"].toString());
      if (error == 0 && offline == 0) {
        offline = online == 0 ? 999 : 0;
        error = online == 0 ? 999 : 0;
      }
      if (error != 999) online = online - error;
      if (offline != 999) online = online - offline;
    } catch (e) {}

    setState(() {
      online;
      error;
      offline;
    });
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  final cloudProjectController _selectController = Get.find();
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

  _gotopro() async {
    EasyLoading.show(status: 'loading...');
    try {
      var send = {"history": false, "key": info['projectCode'], "pageIndex": 1};
      var getSearch = await platform.invokeMethod('getPageProject', send);
      var data = jsonDecode(getSearch);

      EasyLoading.dismiss();
      if (data["errorCode"] != null && data["errorCode"].toString() == "1001") {
        //登录失效
        tologout();
      }
      if (data["data"] != null) {
        if (data["data"].isEmpty) {
          EasyLoading.showError(tr("clound.searchEmpty"));
        } else {
          print(_echangeData(data["data"][0]));
          _selectController.setSelectProject(_echangeData(data["data"][0]));
          Get.to(() => projectDetail());
        }
      }
    } catch (e) {
      print(e);

      EasyLoading.dismiss();
    }
  }

  _echangeData(e) {
    return {
      "project": {
        "id": e["projectId"].runtimeType == String ? e["projectId"] : "--",
        "name":
            e["projectName"].runtimeType == String ? e["projectName"] : "--",
        "code":
            e["projectCode"].runtimeType == String ? e["projectCode"] : "--",
        "systemCount": e["systemNum"].runtimeType == int ? e["systemNum"] : 0,
        "indoorCount": e["indoorNum"].runtimeType == int ? e["indoorNum"] : 0,
        "outdoorCount":
            e["outdoorNum"].runtimeType == int ? e["outdoorNum"] : 0,
        "address": e["location"].runtimeType == String ? e["location"] : "--",
        "projectType":
            e["projectType"] != null ? e["projectType"].toString() : ""
      },
      "vrf": {},
      "alldata": e
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                if (widget.onSelect != null) {
                  widget.onSelect!();
                } else {
                  if (_promissioncontroller
                      .checkCloundPromission("DeviceView_Archived")) {
                    _selectController.setSelectDevice(info);
                    Get.to(() => deviceDetail());
                  }
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.onSelect != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 10, 0),
                      child: RoundCheckBox(
                        isChecked: widget.isSelect,
                        onTap: (selected) {
                          widget.onSelect!();
                        },
                        size: 18,
                        checkedWidget: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                        checkedColor: Theme.of(context).colorScheme.secondary,
                        border: Border.all(
                            // width: 1,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  widget.search == null || widget.search == ""
                      ? Expanded(
                          child: Text(
                          info['systemName'] ?? "--",
                          style:
                              normalTextBlack(fSize: 18, fw: FontWeight.w500),
                        ))
                      : Expanded(child: buildRichText()),
                  Container(
                    padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                    margin: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(width: 1, color: statusColor)),
                    child: Text(
                      tr("device_status${info["status"]}"),
                      style: normalText(lineheight: 1, fontcolor: statusColor),
                    ),
                  ),
                  // if (info["netModelEnum"] != null)
                  //   Container(
                  //     padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                  //     margin: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(4),
                  //         border: Border.all(
                  //             width: 1,
                  //             color: const Color.fromRGBO(13, 13, 13, 0.5))),
                  //     child: Text(
                  //       tr(info["netModelEnum"].toString() != "{}"
                  //           ? info["netModelEnum"].toString()
                  //           : ""),
                  //       style: normalText(lineheight: 1),
                  //     ),
                  //   )
                ],
              ),
            ),
            // Row(
            //   children: [
            //     Text(
            //       "${tr('deviceListinfo.project')} ",
            //       style: normalText(),
            //     ),
            //     Expanded(
            //       child: InkWell(
            //         onTap: () {
            //           if (widget.onSelect != null) {
            //             widget.onSelect!();
            //           } else {
            //             _selectController.setSelectDevice(info);
            //             Get.to(() => deviceDetail());
            //           }
            //         },
            //         onLongPress: () {
            //           _copyTextToClipboard(info['sn'].toString());
            //         },
            //         child: Text(
            //           info['sn'].isEmpty ? "--" : info['sn'].toString(),
            //           style: normalText(fSize: 14),
            //         ),
            //       ),
            //     )
            //   ],
            // ),
            // Row(
            //   children: [
            //     Text(
            //       "${tr('deviceListinfo.code')} ",
            //       style: normalText(),
            //     ),
            //     Expanded(
            //       child: InkWell(
            //         onTap: () {
            //           if (widget.onSelect != null) {
            //             widget.onSelect!();
            //           } else {
            //             _selectController.setSelectDevice(info);
            //             Get.to(() => deviceDetail());
            //           }
            //         },
            //         onLongPress: () {
            //           _copyTextToClipboard(info['sn'].toString());
            //         },
            //         child: Text(
            //           info['sn'].isEmpty ? "--" : info['sn'].toString(),
            //           style: normalText(fSize: 14),
            //         ),
            //       ),
            //     )
            //   ],
            // ),
            Row(
              children: [
                Text(
                  "${tr('deviceListinfo.sn')} ",
                  style: normalText(),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (widget.onSelect != null) {
                        widget.onSelect!();
                      } else {
                        if (_promissioncontroller
                            .checkCloundPromission("DeviceView_Archived")) {
                          _selectController.setSelectDevice(info);
                          Get.to(() => deviceDetail());
                        }
                      }
                    },
                    onLongPress: () {
                      _copyTextToClipboard(info['sn'].toString());
                    },
                    child: Text(
                      info['sn'].isEmpty ? "--" : info['sn'].toString(),
                      style: normalText(fSize: 14),
                    ),
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
                  child: InkWell(
                      onTap: () {
                        if (widget.onSelect != null) {
                          widget.onSelect!();
                        } else {
                          if (_promissioncontroller
                              .checkCloundPromission("DeviceView_Archived")) {
                            _selectController.setSelectDevice(info);
                            Get.to(() => deviceDetail());
                          }
                        }
                      },
                      onLongPress: () {
                        _copyTextToClipboard(info['gatewaySn'].toString());
                      },
                      child: Text(
                        info['gatewaySn'],
                        style: normalText(),
                      )),
                ),
                // TextButton(
                //     onPressed: () {
                //       _copyTextToClipboard(info['sn']);
                //     },
                //     child: Text(tr('projectDetail.deviceManage.copy')))
              ],
            ),
            if (widget.showproject)
              Row(
                children: [
                  Text(
                    "${tr('deviceListinfo.project')} ",
                    style: normalText(),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (widget.onSelect != null) {
                          widget.onSelect!();
                        } else {
                          if (_promissioncontroller
                              .checkCloundPromission("DeviceView_Archived")) {
                            _selectController.setSelectDevice(info);
                            Get.to(() => deviceDetail());
                          }
                        }
                      },
                      onLongPress: () {
                        _copyTextToClipboard(info['projectName'].toString());
                      },
                      child: Text(
                        info['projectName'].isEmpty
                            ? "--"
                            : info['projectName'].toString(),
                        style: normalText(
                          fSize: 14,
                        ),
                      ),
                    ),
                  )
                ],
              ),

            if (widget.showproject)
              Row(
                children: [
                  Text(
                    "${tr('deviceListinfo.code')} ",
                    style: normalText(),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (widget.onSelect != null) {
                          widget.onSelect!();
                        } else {
                          if (_promissioncontroller
                              .checkCloundPromission("DeviceView_Archived")) {
                            _selectController.setSelectDevice(info);
                            Get.to(() => deviceDetail());
                          }
                        }
                      },
                      onLongPress: () {
                        _copyTextToClipboard(info['projectCode'].toString());
                      },
                      child: Text(
                        info['projectCode'].isEmpty
                            ? "--"
                            : info['projectCode'].toString(),
                        style: normalText(fSize: 14),
                      ),
                    ),
                  ),
                  if (!info['projectName'].isEmpty)
                    TextButton(
                        onPressed: () {
                          _gotopro();
                        },
                        child: Text(tr("tosys"),
                            style: normalText(
                                fSize: 14,
                                fontcolor:
                                    const Color.fromRGBO(25, 98, 255, 1))))
                ],
              ),
            Row(
              children: [
                infosWidget(
                    'public/images/systemCapabilityAnalysis/outdoor.png',
                    tr("local.ODU"),
                    info['outdoorNum'].toString()),
              ],
            ),
            Row(
              children: [
                infosWidget('public/images/systemCapabilityAnalysis/indoor.png',
                    tr("local.IDU"), info['indoorNum'].toString()),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
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
