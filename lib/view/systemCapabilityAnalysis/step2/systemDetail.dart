import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/systemCapabilityAnalysis/diagnosis/historyList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../selfpublicFunction.dart';
import 'children/showingCheckResult.dart';
import 'sysinfo.dart';
import 'sysparameter.dart';

class systemDetail extends StatefulWidget {
  systemDetail({super.key});

  @override
  State<systemDetail> createState() => _systemDetailState();
}

class _systemDetailState extends State<systemDetail> {
  final systemAnalysisController _selfcon = Get.find();

  late Timer _timer;
  var connectedSystem;
  static const platform =
      MethodChannel('samples.flutter.dev/getSystemDataHandler');

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

      print("startCheck : ${{
        "sysId": _selfcon.selectedSystem.value["sysId"],
        "mode": _selfcon.analysisType.value == 1 ? "cooling" : "heating"
      }}");
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
          print("queryCheckRecord ${{
            "pageIndex": 1,
            "sysId": _systemController.selectedSystem.value["sysId"],
            "mode": _systemController.analysisType.value == 1
                ? "cooling"
                : "heating"
          }}");
          var queryCheckRecord_data = jsonDecode(queryCheckRecord);
          checktime++;
          for (var element in queryCheckRecord_data["data"]) {
            if (element["id"].toString() == id.toString()) {
              iscommpelt = element["status"] == 1;
            }
          }
          if (iscommpelt || checktime > 60) {
            _timer.cancel();
            EasyLoading.dismiss();
            if (iscommpelt) {
              Get.to(() => showingCheckResult(
                    id: id,
                  ));
            } else {
              EasyLoading.showError(tr("queryCheckRecord.error"));
            }
          }
        });
      } else {
        EasyLoading.showError(data['errorMsg']);
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("$e");
    }
  }

  final systemAnalysisController _systemController = Get.find();
  final GlobalKey<sysparameterState> childKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    setState(() {
      connectedSystem = _systemController.selectedSystem.value;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_selfcon.selectedSystem.value["sysId"] == null) {
        EasyLoading.showError(tr("getSearchBySn.empty"));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    try {
      if (_timer.isActive) {
        _timer.cancel();
      }
    } catch (e) {}
  }

// 刷新方法
  Future<void> _refresh() async {
    childKey.currentState?.triggerChildRefresh();
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
          title: const Text(
            'systemCapabilityAnalysisPage.systemDetail',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 16.w, 0),
              child: TextButton(
                  onPressed: () {
                    Get.to(() =>
                        historyListpage(connectedSystem: connectedSystem));
                  },
                  child: Text(
                    "systemCapabilityAnalysisPage.systemDetail.action",
                    style: normalText(),
                  ).tr()),
            )
          ],
        ),
        body: Stack(children: [
          Container(
              width: 720.w,
              height: 1280.h,
              color: const Color.fromRGBO(244, 244, 244, 1),
              padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
              child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        sysinfo(connectedSystem: connectedSystem),
                        sysparameter(
                            key: childKey, connectedSystem: connectedSystem),
                        Container(
                          height: 57,
                          padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                        )
                      ],
                    ),
                  ))),
          Positioned(
              bottom: 0,
              child: Container(
                width: 720.w,
                height: 57,
                color: const Color.fromRGBO(244, 244, 244, 1),
                padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                child: Center(
                  child: submitButton(
                    isActive: _selfcon.selectedSystem.value["sysId"] != null,
                    label: tr(
                        'systemCapabilityAnalysisPage.systemDetail.btn${_selfcon.selectType.value + 1}',
                        namedArgs: {
                          "val": _selfcon.analysisType.value == 1
                              ? tr("cooling")
                              : tr("heating"),
                        }),
                    onClick: () async {
                      if (_selfcon.selectedSystem.value["sysId"] != null) {
                        toCloundCheck();
                      } else {
                        EasyLoading.showError(tr("getSearchBySn.empty"));
                      }
                    },
                  ),
                ),
              ))
        ]));
  }
}
