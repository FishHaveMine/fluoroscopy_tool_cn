import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/systemCapabilityAnalysis/selfpublicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import 'pie_chart_sample.dart';
import 'sysinfo.dart';

import 'package:get/get.dart';

class sysinfo extends StatefulWidget {
  Map? showing;
  var connectedSystem;
  bool? isselect;
  Function? onselect;
  bool? hideBuzzer;
  sysinfo(
      {super.key,
      required this.connectedSystem,
      this.showing,
      this.isselect,
      this.onselect,
      this.hideBuzzer});

  @override
  State<sysinfo> createState() => _sysinfoState();
}

class _sysinfoState extends State<sysinfo> {
  static const platform = MethodChannel('samples.flutter.dev/battery');
  static const SystemDatalatform =
      MethodChannel('samples.flutter.dev/getSystemDataHandler');

  static const getProjectHandler =
      MethodChannel('samples.flutter.dev/getProjectHandler');
  var info = {};

  String _key = DateTime.now().millisecondsSinceEpoch.toString();
  int online = 0;
  int error = 0;
  int offline = 0;
  int indoorListlength = 0;
  countstatus(element) {
    if (element["status"] == 2) {
      error++;
    } else if (element["status"] == 0 || element["status"] == 3) {
      offline++;
    } else {
      online++;
    }
  }

  String sn = "";

  Map statusMap = {
    "0": "device_status0",
    "5": "device_status5",
    "1": "device_status1",
    "2": "device_status2",
    "3": "device_status3",
  };

  Map statusMapColor = {
    "0": Colors.grey,
    "5": Colors.green,
    "1": Colors.green,
    "2": Colors.red,
    "3": Colors.grey,
  };
  setsysinfo(value) async {
    if (value.isEmpty) {
      EasyLoading.showError(tr("getDetailBySn.empty"));
      return;
    }
    try {
      online = 0;
      error = 0;
      offline = 0;
      if (value["indoorList"] != null) {
        indoorListlength = value["indoorList"].length;
        for (var element in value["indoorList"]) {
          countstatus(element);
        }
      }
      print("setsysinfo  send:${widget.connectedSystem}");
      // if (widget.connectedSystem["status"] != null) {
      //   value["status"] = widget.connectedSystem["status"];
      // } else {
      var send = {
        // "projectCode": widget.connectedSystem["projectCode"].toString(),
        "sn": widget.connectedSystem["sn"] != null
            ? widget.connectedSystem["sn"]
            : widget.connectedSystem["outdoorSn"] == ""
                ? widget.connectedSystem["module4gSn"]
                : widget.connectedSystem["outdoorSn"],
        // "vrfNid": widget.connectedSystem["sysId"].toString(),
        "netModelEnum": "",
        "status": "",
        "pageindex": 1
      };
      print("setsysinfo  send: $send");
      var historyback = await getProjectHandler.invokeMethod(
          'getProfessionalToolsHandler.page', send);

      var historydata = jsonDecode(historyback);
      print("setsysinfo: $historydata");
      if (historydata["errorCode"] != null &&
          historydata["errorCode"].toString() == "1001") {
        //登录失效
        tologout();
      }
      if (!historydata["success"]) {
        EasyLoading.showError(historydata['errorMsg']);
      }

      if (historydata["data"] != null &&
          historydata["data"].isNotEmpty &&
          historydata["data"][0] != null) {
        value["status"] = historydata["data"][0]["status"].toString();
      } else {
        EasyLoading.showError(tr("getprofessionaltoolshandler.empty"));
      }
      // }
      setState(() {
        info = value;
        indoorListlength;
        online;
        error;
        offline;
        sn;
        _key = DateTime.now().millisecondsSinceEpoch.toString();
      });
    } catch (e) {
      print("setsysinfo error:$e");
    }
  }

  getDetailBySn() {
    EasyLoading.show(status: 'loading...');

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        platform.invokeMethod('getDetailBySn', <String, dynamic>{
          "sysId": widget.connectedSystem['sysId']
        }).then((value) => {EasyLoading.dismiss(), setsysinfo(value["data"])});
      } catch (e) {
        EasyLoading.dismiss();
      }
    });
  }

  startBuzzer() async {
    EasyLoading.show(status: 'loading...');

    var init_history = await SystemDatalatform.invokeMethod('startBuzzer',
        <String, dynamic>{"sysId": widget.connectedSystem['sysId']});

    var backdata = jsonDecode(init_history);
    EasyLoading.dismiss();
    if (!backdata['success']) {
      EasyLoading.showError(backdata['errorMsg']);
    } else {
      // ignore: use_build_context_synchronously
      EasyLoading.showSuccess(tr("startBuzzer.success"));
      // init();
    }
  }

  @override
  void initState() {
    super.initState();
    getDetailBySn();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey("info_$_key"),
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: info.isNotEmpty
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.onselect != null)
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
                    child: RoundCheckBox(
                      isChecked: widget.isselect,
                      onTap: (selected) {
                        widget.onselect!(selected);
                      },
                      size: 24,
                      checkedWidget: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      ),
                      checkedColor: Theme.of(context).colorScheme.secondary,
                      border: Border.all(
                          // width: 1,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 200, // Maximum width
                                ),
                                child: SizedBox(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 15, 0),
                                    child: Text(
                                      info['sysName'].toString(),
                                      style: titleText(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )),
                            Container(
                              width: 34,
                              height: 24,
                              margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color: statusMapColor[
                                              info['status'].toString()] ??
                                          Colors.green),
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.white),
                              child: Center(
                                child: Text(
                                  info['status'] != null
                                      ? statusMap[info['status'].toString()]
                                      : "--",
                                  style: TextStyle(
                                      color: statusMapColor[
                                              info['status'].toString()] ??
                                          Colors.green,
                                      fontSize: 12),
                                ).tr(),
                              ),
                            )
                          ],
                        ),
                        if (widget.hideBuzzer != true)
                          TextButton(
                              onPressed: () async {
                                await startBuzzer();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: Image.asset(
                                      'public/images/systemCapabilityAnalysis/Buzzer.png',
                                      width: 16,
                                    ),
                                  ),
                                  const Text(
                                    'systemCapabilityAnalysisPage.systemDetail.Buzzer',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 12),
                                  ).tr(),
                                ],
                              )),
                        // InkWell(
                        //   onTap: () {
                        //     startBuzzer();
                        //   },
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       Padding(
                        //         padding:
                        //             const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        //         child: Image.asset(
                        //           'public/images/systemCapabilityAnalysis/Buzzer.png',
                        //           width: 16,
                        //         ),
                        //       ),
                        //       const Text(
                        //         'systemCapabilityAnalysisPage.systemDetail.Buzzer',
                        //         style: TextStyle(
                        //             color: Colors.blue, fontSize: 12),
                        //       ).tr(),
                        //     ],
                        //   ),
                        // )
                      ],
                    ),
                    SizedBox(
                      width: 720.w - 17 * 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(TextSpan(children: [
                            TextSpan(
                                style: normalText(),
                                text: '${tr('deviceListinfo.sn', namedArgs: {
                                      'val': sn.toString()
                                    })}:${sn.toString()}'),
                            if (info['projectName'] != null)
                              TextSpan(
                                  style: normalText(),
                                  text:
                                      '\n${tr('systemCapabilityAnalysisPage.systemDetail.syslabel1', namedArgs: {
                                        'val': info['projectName'].toString()
                                      })}'),
                            if (info['module4gSn'] != null)
                              TextSpan(
                                  style: normalText(),
                                  text:
                                      '\n${tr('systemCapabilityAnalysisPage.systemDetail.syslabel2', namedArgs: {
                                        'val': info['module4gSn'].toString()
                                      })}'),
                            // TextSpan(
                            //     style: normalText(),
                            //     text:
                            //         '\n${tr('systemCapabilityAnalysisPage.systemDetail.syslabel3', namedArgs: {
                            //           'val': (info['indoorCount']).toString()
                            //         })}'),

                            TextSpan(
                                style: normalText(),
                                text:
                                    '\n${tr('systemCapabilityAnalysisPage.systemDetail.syslabel5', namedArgs: {
                                      'val0': info['ratio'].toString(),
                                      'val1': info['outdoorTotal'].toString(),
                                      'val2': info['indoorTotal'].toString()
                                    })}')
                          ])),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: (720.w - 17 * 2) * 0.6,
                            height: 114,
                            key: ValueKey("$online _ $error _ $offline"),
                            child: Stack(
                              children: [
                                PieChartSample2(dataPieChar: [
                                  {"key": tr("online"), "value": "$online"},
                                  {"key": tr("error"), "value": "$error"},
                                  {"key": tr("offline"), "value": "$offline"}
                                ]),
                                Positioned(
                                    left: 40,
                                    child: SizedBox(
                                        width: 80,
                                        height: 114,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "$indoorListlength",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            const Text(
                                              "indoorNum",
                                              style: TextStyle(fontSize: 10),
                                            ).tr()
                                          ],
                                        )))
                              ],
                            )),
                        Expanded(
                            child: Container(
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: Image.asset(
                                  'public/images/systemCapabilityAnalysis/outdoor.png',
                                  width: 16,
                                ),
                              ),
                              Text(
                                  '${tr('local.ODU')} ${info['outdoorCount']}'),
                            ],
                          )),
                        ))
                      ],
                    )
                  ],
                ))
              ],
            )
          : null,
    );
  }
}
