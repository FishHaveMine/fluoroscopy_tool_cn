import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:fluoroscopy_tool/view/trialRun/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'StepsWidget.dart';

class trialRunpage extends StatefulWidget {
  trialRunpage({super.key});

  @override
  State<trialRunpage> createState() => _copybasepageState();
}

class _copybasepageState extends State<trialRunpage> {
  final deviceInfoController _deviceInfoController = Get.find();
  final GlobalKey<StepsWidgetState> _childKey = GlobalKey<StepsWidgetState>();

  static const _snplatform = MethodChannel('samples.flutter.dev/tryRunHandler');
  int doingType = 0; // 0 未开始；1 试运行中；3 试运行成功；2 试运行失败；
  int page = 0;
  List history = [];
  bool is_startTryRun = false;
  late Timer _timer;
  init(showloading) async {
    // int run_re = 1;
    // int run_Step = 0;
    // setState(() {
    //   if (!is_startTryRun) is_startTryRun = run_re == 1;
    //   doingType = run_re;
    //   page = run_Step;
    //   history;
    // });
    // return;
    if (_deviceInfoController.loacalDevice.value.model != 'V8') {
      Get.offAllNamed('/home'); //
      return;
    }
    if (showloading) EasyLoading.show(status: "loading...");
    try {
      var snback = await _snplatform
          .invokeMethod('getTestRunStatus', <String, dynamic>{});
      var data = jsonDecode(snback);
      print("functionParamHandler getTestRunStatus: ${data["data"]}");
      if (data["success"]) {
        /**
         * 需要判断是否启动过试运行
         */
        int run_re = data["data"]["testRunResult"];
        int run_Step = data["data"]["specialModeStep"] - 1;
        // specialMode: 0,    //
        // specialModeStep: 0,   // 正在运行的步数
        // testRunResult: 0 // 运行状态
        history.add(data["data"]);

        setState(() {
          if (!is_startTryRun) is_startTryRun = run_re == 1;
          doingType = run_re;
          page = run_Step;
          history;
        });
        if (run_re == 3 || run_re == 2) {
          try {
            if (_timer != null && _timer.isActive) {
              _timer.cancel();
            }
          } catch (e) {}
        }
      } else {
        EasyLoading.showError(data["errorMsg"]);
      }
      EasyLoading.dismiss();
    } on PlatformException catch (e) {
      print(" unLock: '${e.message}'.");
      EasyLoading.dismiss();
    }
  }

  /** 开始试运行 */
  _startTryRun() async {
    EasyLoading.show(status: "loading...");
    setState(() {
      doingType = 0;
      page = 0;
      is_startTryRun = true;
    });
    try {
      var snback =
          await _snplatform.invokeMethod('openTestRun', <String, dynamic>{});
      var data = jsonDecode(snback);
      print("functionParamHandler openTestRun: $data");
      if (data["success"]) {
        EasyLoading.showSuccess(tr("openTestRun.tip"));
        startStep();
      } else {
        EasyLoading.showError(data["errorMsg"]);
      }
      EasyLoading.dismiss();
    } on PlatformException catch (e) {
      print(" unLock: '${e.message}'.");
      EasyLoading.dismiss();
    }
  }

  startStep() {
    try {
      if (_timer != null && _timer.isActive) {
        _timer.cancel();
      }
    } catch (e) {}

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      init(false);
    });
  }

  @override
  void initState() {
    super.initState();

    if (_deviceInfoController.loacalDevice.value.model == 'V8') {
      try {
        if (_deviceInfoController.deviceTypeEnum.value == 1 &&
            (_deviceInfoController.loacalDevice.value.IDU == 0 ||
                _deviceInfoController.loacalDevice.value.IDU == 1)) {
          Get.offAllNamed('/home');
        } else {
          init(true);
          startStep();
        }
      } catch (e) {}
    }
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
    try {
      if (_timer != null && _timer.isActive) {
        try {
          _timer.cancel();
        } catch (e) {}
      }
    } catch (e) {}
  }

  void _showBottomSheet() {
    // showModalBottomSheet(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return ListView.builder(
    //         itemCount: history.length,
    //         itemBuilder: ((context, index) =>
    //             Text("${jsonEncode(history[index])}")));
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Get.offAllNamed('/home'); //
              },
              icon: const Icon(Icons.chevron_left,
                  color: Colors.black, size: 36)),
          // ignore: prefer_const_constructors
          title: Text(
            'trialRun.title',
            style: const TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [
            TextButton(
                onPressed: () {
                  // islocation: doingType == 2 || doingType == 3
                  Get.to(() => tryResult(
                        islocation: doingType == 2 || doingType == 3,
                        sn: _deviceInfoController.loacalDevice.value.sn,
                      ));
                },
                child: Text(
                  'trialRun.actionbtn',
                  style: normalTextS(),
                ).tr())
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: _showBottomSheet, // 点击显示弹框
        //   child: Icon(Icons.history), // 悬浮按钮的图标
        // ),
        body: Container(
          width: 720.w,
          height: 1280.h,
          color: const Color.fromRGBO(255, 255, 255, 1),
          padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0.h, 0, 0.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color.fromRGBO(223, 223, 223, 1),
                                      width: 0.5,
                                    ),
                                  )),
                              padding: EdgeInsets.fromLTRB(32.w, 12, 32.w, 12),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      tr('trialRun.showtype1'),
                                      style: normalTextBlack(),
                                    ),
                                    Text(
                                      _deviceInfoController
                                          .loacalDevice.value.machine,
                                      style: ErrorTip(),
                                    ).tr()
                                  ]),
                            ),
                            if (doingType == 0 || !is_startTryRun)
                              Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color.fromRGBO(223, 223, 223, 1),
                                        width: 0.5,
                                      ),
                                    )),
                                padding:
                                    EdgeInsets.fromLTRB(32.w, 12, 32.w, 12),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        tr('trialRun.showtype2'),
                                        style: normalTextBlack(),
                                      ),
                                      Text(
                                        doingType == 0
                                            ? "trialRun.showtype2.tip"
                                            : doingType == 3
                                                ? "trialRun.start.success"
                                                : "trialRun.running.tip1_error",
                                        style: ErrorTip(),
                                      ).tr()
                                    ]),
                              ),
                            if (doingType == 1)
                              Container(
                                  width: 720.w,
                                  height: 80,
                                  padding:
                                      EdgeInsets.fromLTRB(0.w, 24.w, 0.w, 0.w),
                                  child: StepsWidget(
                                    key: _childKey,
                                    currentIndex: page,
                                  )),
                          ],
                        )),
                  ),
                ],
              ),
              Expanded(
                  child: baseContainer(
                      child: doingType == 1 && is_startTryRun
                          ? SizedBox(
                              width: 300,
                              height: 300,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      Image.asset(
                                        'public/images/waterPump/loading.gif',
                                        width: 255,
                                      ),
                                      Positioned(
                                        left: 50,
                                        top: 50,
                                        child: Image.asset(
                                          'public/images/trialRun/running.png',
                                          width: 155,
                                          color: const Color.fromRGBO(
                                              255, 255, 255, 1),
                                        ),
                                      ),
                                      Positioned(
                                        left: 50,
                                        top: 50,
                                        child: Image.asset(
                                          'public/images/trialRun/running.png',
                                          width: 155,
                                        ),
                                      )
                                    ],
                                  ),
                                  Text(
                                    tr("trialRun.running.tip1",
                                        namedArgs: {"Step": "Step${page + 1}"}),
                                    style: titleText(),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      "trialRun.running.tip2",
                                      style: normalText(),
                                    ).tr(),
                                  )
                                ],
                              ),
                            )
                          : (doingType == 2 || doingType == 3) && is_startTryRun
                              ? SizedBox(
                                  width: 300,
                                  height: 300,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'public/images/afterSalesReplacement/${doingType == 3 ? "success" : "error"}.png',
                                        width: 200,
                                      ),
                                      Text(
                                        tr(
                                            doingType == 3
                                                ? "trialRun.start.finish"
                                                : "trialRun.running.tip1_error",
                                            namedArgs: {
                                              "Step": "Step${page + 1}",
                                            }),
                                        style: titleText(),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Text(
                                          "trialRun.running.tip2",
                                          style: normalText(),
                                        ).tr(),
                                      )
                                    ],
                                  ),
                                )
                              : Container())),
              if (doingType == 0)
                Container(
                  height: 57,
                  padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                  child: Center(
                    child: submitButton(
                      isActive: true,
                      label: tr('trialRun.start'),
                      onClick: () async {
                        bool issend = await divConfirmDialog(context,
                            confirmTitle:
                                tr("device.controltDialog.confirmTitle"),
                            isSubmitButton: true,
                            confirmDescriptionWidget: SingleChildScrollView(
                              child: SizedBox(
                                  width: 560.w,
                                  height: 24 * 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text('trialRun.tip').tr(),
                                      ],
                                    ),
                                  )),
                            ));
                        if (issend) {
                          _startTryRun();
                        }
                      },
                    ),
                  ),
                ),
              if (doingType == 1)
                Container(
                  height: 57,
                  padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                  child: Center(
                    child: Opacity(
                      opacity: 0.6,
                      child: submitButton(
                        isActive: true,
                        label: tr('trialRun.running'),
                        onClick: () async {},
                      ),
                    ),
                  ),
                ),
              if (doingType == 2 || doingType == 3)
                Container(
                  height: 57,
                  padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                  child: Center(
                    child: Opacity(
                      opacity: 1,
                      child: submitButton(
                        isActive: true,
                        label: tr('trialRun.start.restart'),
                        onClick: () async {
                          _startTryRun();
                        },
                      ),
                    ),
                  ),
                )
            ],
          ),
        ));
  }
}

TextStyle ActiveTip() {
  return const TextStyle(
      color: Color.fromRGBO(0, 128, 255, 1),
      fontSize: 9,
      height: 1,
      fontWeight: FontWeight.w400);
}
