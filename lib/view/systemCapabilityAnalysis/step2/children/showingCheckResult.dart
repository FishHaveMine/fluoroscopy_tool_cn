import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/systemCapabilityAnalysis/selfpublicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../line_chart.dart';
import '../sysinfo.dart';
import '../sysparameter.dart';
import 'handerFunction.dart';

class showingCheckResult extends StatefulWidget {
  int showingType = 0;
  int id;
  showingCheckResult({super.key, required this.id, this.showingType = 0});

  @override
  State<showingCheckResult> createState() => _copybasepageState();
}

class _copybasepageState extends State<showingCheckResult> {
  static const platform =
      MethodChannel('samples.flutter.dev/getSystemDataHandler');

  final systemAnalysisController _selfcon = Get.find();
  int showing = 0;

  systemAnalysisController _systemController = Get.find();
  List tap = ["parametersPage.ODU", "parametersPage.IDU"];
  String active = 'parametersPage.ODU';
  var RecordDetail = {};
  List switchMenu = ["table", "charts"];
  int showingID = 0;
  init(id) async {
    showingID = id;
    var queryCheckRecordDetail =
        await platform.invokeMethod('queryCheckRecordDetail', <String, dynamic>{
      'id': id,
      "sysId": _systemController.selectedSystem.value["sysId"],
    });

    var data = jsonDecode(queryCheckRecordDetail);
    print("-------------------------------------------------------");
    print(data["data"]["result"]);
    if (data["success"]) {
      setState(() {
        RecordDetail = data["data"];
      });
    }
  }

  late Timer _timer;
  toCloundCheck() async {
    EasyLoading.show(status: 'loading...');
    try {
      if (_timer.isActive) {
        _timer.cancel();
      }
    } catch (e) {}
    try {
      var startCheck =
          await platform.invokeMethod('startCheck', <String, dynamic>{
        "sysId": _selfcon.selectedSystem.value["sysId"],
        "mode": _selfcon.analysisType.value == 1 ? "cooling" : "heating"
      });
      var data = jsonDecode(startCheck);

      if (data["success"] && data["data"] != null) {
        int id = int.parse(data["data"].toString());
        int checktime = 0;
        bool iscommpelt = true;
        _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
          var queryCheckRecord =
              await platform.invokeMethod('queryCheckRecord', {
            "pageIndex": 1,
            "sysId": _systemController.selectedSystem.value["sysId"],
            "mode": _systemController.analysisType.value == 1
                ? "cooling"
                : "heating"
          });
          var queryCheckRecord_data = jsonDecode(queryCheckRecord);
          checktime++;
          if (queryCheckRecord_data["data"] != null) {
            for (var element in queryCheckRecord_data["data"]) {
              if (element["id"].toString() == id.toString()) {
                iscommpelt = element["status"] == 1;
              }
            }
          }
          if (iscommpelt || checktime > 60) {
            _timer.cancel();
            EasyLoading.dismiss();
            if (iscommpelt) {
              init(id);
            } else {
              EasyLoading.showError(tr("queryCheckRecord.error"));
            }
          }
        });
      }
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    super.initState();
    init(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.chevron_left,
                  color: Colors.black, size: 36)),
          title: Text(
            widget.showingType == 0
                ? tr('checkResult.title', namedArgs: {
                    "val": _systemController.analysisType.value == 1
                        ? tr("cooling")
                        : tr("heating")
                  })
                : tr("checkResult"),
            style: const TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          actions: [],
        ),
        body: Container(
          width: 720.w,
          height: 1280.h,
          color: const Color.fromRGBO(244, 244, 244, 1),
          padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.showingType == 0)
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            for (var tapitem in tap)
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      active = tapitem;
                                    });
                                  },
                                  child: SizedBox(
                                    height: 42,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                            height: 40,
                                            child: Center(
                                              child: Text(
                                                tapitem,
                                                style: TextStyle(
                                                    color: active == tapitem
                                                        ? Colors.blue
                                                        : Colors.black),
                                              ).tr(),
                                            )),
                                        Center(
                                          child: Container(
                                            width: 48,
                                            height: 2,
                                            color: active == tapitem
                                                ? Colors.blue
                                                : Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                      ],
                    ),
                  ),
                if (widget.showingType == 0)
                  Container(
                    color: Colors.white,
                    height: 360,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(16.w, 10, 16.w, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 42 * (switchMenu.length + 1),
                                child: Row(
                                  children: [
                                    for (int index = 0;
                                        index < switchMenu.length;
                                        index++)
                                      Expanded(
                                        child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                showing = index;
                                              });
                                            },
                                            child: Container(
                                                width: 42,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: showing == index
                                                      ? const Color.fromRGBO(
                                                          0, 128, 255, 0.6)
                                                      : const Color.fromRGBO(
                                                          191,
                                                          191,
                                                          191,
                                                          0.09), // 背景色
                                                  border: Border.all(
                                                    color: showing == index
                                                        ? const Color.fromRGBO(
                                                            0, 128, 255, 0.6)
                                                        : const Color.fromRGBO(
                                                            191,
                                                            191,
                                                            191,
                                                            0.09), // 背景色
                                                    width: 0.6, // 边框宽度
                                                  ),
                                                  borderRadius: index == 0
                                                      ? const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  4.8),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  4.8),
                                                        )
                                                      : index ==
                                                              switchMenu
                                                                      .length -
                                                                  1
                                                          ? const BorderRadius
                                                              .only(
                                                              topRight: Radius
                                                                  .circular(
                                                                      4.8),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          4.8),
                                                            )
                                                          : null, // 圆角
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    switchMenu[index],
                                                    style: normalTextS(
                                                        fontcolor: showing ==
                                                                index
                                                            ? Colors.white
                                                            : const Color
                                                                    .fromRGBO(
                                                                140,
                                                                140,
                                                                140,
                                                                1),
                                                        lineheight: 1.2),
                                                  ).tr(),
                                                ))),
                                      )
                                  ],
                                ),
                              ),
                              Weather()
                            ],
                          ),
                        ),
                        Expanded(
                            key: ValueKey(active),
                            child: showing == 0
                                ? tableview(
                                    connectedSystem: _selfcon.selectedSystem,
                                    active: active)
                                : Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
                                    child: LineChart(
                                        connectedSystem:
                                            _selfcon.selectedSystem,
                                        active: active),
                                  ))
                      ],
                    ),
                  ),
                if (widget.showingType == 1)
                  sysinfo(
                      hideBuzzer: true,
                      connectedSystem: _systemController.selectedSystem.value),
                if (RecordDetail.isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 20, 16.w, 10),
                    child: Text(
                        tr("checkTime", namedArgs: {
                          "startTime": DateFormat('yyyy/MM/dd')
                              .format(DateTime.fromMillisecondsSinceEpoch(
                            RecordDetail["startTime"],
                          )),
                          "endTime": DateFormat('yyyy/MM/dd')
                              .format(DateTime.fromMillisecondsSinceEpoch(
                            RecordDetail["endTime"],
                          ))
                        }),
                        style: normalText(),
                        textAlign: TextAlign.start),
                  ),
                  if (RecordDetail["result"].isNotEmpty)
                    for (var result in RecordDetail["result"])
                      InkWell(
                        onTap: () {
                          Get.to(() => handerFunction(
                                id: showingID,
                                code: result["code"],
                                title: result["label"],
                              ));
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    result["label"],
                                    style: normalTextBlack(
                                        lineheight: 1,
                                        fSize: 16,
                                        fw: FontWeight.w700),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    tr("checkTip", namedArgs: {}),
                                    style: normalText(),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    size: 16,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                ],
                if (widget.showingType == 0)
                  Container(
                    height: 57,
                    padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                    child: Center(
                      child: submitButton(
                        isActive: true,
                        label: tr('checkAgain', namedArgs: {}),
                        onClick: () async {
                          toCloundCheck();
                        },
                      ),
                    ),
                  )
              ],
            ),
          ),
        ));
  }
}
