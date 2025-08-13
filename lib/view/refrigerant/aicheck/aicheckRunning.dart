import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../local/publicFunction.dart';
import 'aicheckResult.dart';

class aicheckRunning extends StatefulWidget {
  aicheckRunning({super.key});

  @override
  State<aicheckRunning> createState() => _copybasepageState();
}

class _copybasepageState extends State<aicheckRunning> {
  bool isRunning = true;
  String status = "";
  late Timer _timer;
  static const _selfplatform =
      MethodChannel('samples.flutter.dev/RefrigerantService');
  final deviceInfoController _deviceInfoController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      checkResult();
    });
  }

  @override
  void dispose() {
    super.dispose();
    try {
      _timer.cancel();
    } catch (e) {}
  }

  int runningTime = 0;
  checkResult() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      try {
        setState(() {
          runningTime = runningTime + 3;
        });
        var refrigerantResult = await _selfplatform
            .invokeMethod('checkResult', <String, dynamic>{});
        var data = jsonDecode(refrigerantResult);

        // INTERRUPT(14, 14), 中断
        // MORE(8, 13), 多冷媒
        // LESS(1, 6),  少冷媒
        // COMMON(7, 7);  正常
        // null  诊断中
        print("refrigerantTable checkResult: $refrigerantResult");
        if (data["success"]) {
          if (data["data"] != null) {
            setState(() {
              status = data["data"];
              isRunning = false;
            });
            _timer.cancel();
            Get.off(() => aicheckResult(result: status));
          }
        }
      } catch (e) {}
    });
  }

  aicheckstop() async {
    _timer.cancel();
    try {
      var refrigerantResult =
          await _selfplatform.invokeMethod('closeCheck', <String, dynamic>{});
      var data = jsonDecode(refrigerantResult);

      print(
          "refrigerantTable closeCheck: $refrigerantResult  ${(data["success"] && (data["data"] != null && data["data"]))}");
      if (data["success"] && (data["data"] != null && data["data"])) {
        setState(() {
          isRunning = false;
          runningTime = 0;
        });
        _timer.cancel();
      } else {
        EasyLoading.showError(data["errorMsg"]);
      }
    } catch (e) {}
  }

  stopAiCheck() async {
    bool issend = await divConfirmDialog(context,
        isSubmitButton: true,
        confirmTitle: tr("device.controltDialog.confirmTitle"),
        confirmDescriptionWidget: SingleChildScrollView(
          child: Container(
              width: 560.w,
              height: 80,
              padding: EdgeInsets.fromLTRB(24.w, 24.w, 24.w, 0),
              child: Text.rich(TextSpan(
                  style: normalTextBlack(),
                  text: tr('refrigerant.aicheck.stop.tip')))),
        ));
    if (issend) {
      aicheckstop();
    } else {
      // Get.to(() => aicheckResult());
    }
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
            'refrigerant.aicheck',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [],
        ),
        body: Container(
          width: 720.w,
          height: 1280.h,
          color: const Color.fromRGBO(255, 255, 255, 1),
          padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
          child: Column(
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: isRunning
                    ? [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 24.h, 0, 0.h),
                          child: Image.asset(
                            'public/images/refrigerant/ai.jpg',
                            width: 140,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(0, 130.h, 0, 0.h),
                            child: Text.rich(TextSpan(
                              style: normalTextBlack(
                                  fSize: 18, fw: FontWeight.w800),
                              text: tr("refrigerant.aicheck.checking"),
                            ))),
                        Text(
                          tr("refrigerant.aicheck.checking.tip", namedArgs: {
                            "val": (runningTime ~/ 60).toStringAsFixed(0)
                          }),
                          textAlign: TextAlign.center,
                          style: normalText(),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 64.h, 0, 0.h),
                          width: 400.w,
                          height: 36,
                          child: normalButton(
                              label: tr("refrigerant.aicheck.checking.btn"),
                              onClick: () {
                                stopAiCheck();
                              }),
                        )
                      ]
                    : [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 24.h, 0, 0.h),
                          child: Image.asset(
                            'public/images/refrigerant/disconnect.png',
                            width: 140,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(0, 130.h, 0, 0.h),
                            child: Text.rich(TextSpan(
                              style: normalTextBlack(
                                  fSize: 18, fw: FontWeight.w800),
                              text: tr("refrigerant.aicheck.stop"),
                            ))),
                        Text(
                          tr("refrigerant.aicheck.stop.con"),
                          textAlign: TextAlign.center,
                          style: normalText(),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 64.h, 0, 0.h),
                          width: 400.w,
                          height: 36,
                          child: normalButton(
                              label: tr("refrigerant.aicheck.stop.btn"),
                              onClick: () {}),
                        )
                      ],
              )),
            ],
          ),
        ));
  }
}
