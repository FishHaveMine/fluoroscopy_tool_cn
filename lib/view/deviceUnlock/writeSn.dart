import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/snInput.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/deviceUnlock/welcomePage.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

class writeSn extends StatefulWidget {
  const writeSn({super.key});
  @override
  State<writeSn> createState() => _writeSnState();
}

class _writeSnState extends State<writeSn> {
  static const platform = MethodChannel('samples.flutter.dev/battery');
  static const _snplatform =
      MethodChannel('samples.flutter.dev/writeSnService');

  final deviceInfoController _deviceInfoController = Get.find();

  final GlobalKey<snInputState> _key = GlobalKey<snInputState>();
  String sn = '';
  openscan() async {
    try {
      await platform.invokeMethod('SCANNER_TRIG');
    } on PlatformException catch (e) {
      print("Failed to SCANNER_TRIG: '${e.message}'.");
    }
  }

  int _remainingSeconds = 30; //超时时间
  late Timer _timer;
  int doingType = 0; // 0 未开始；1 解锁中；3 解锁成功；2 解锁失败；
  init() async {
    _key.currentState?.fun();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        doingType = 1;
        _remainingSeconds = 30;
      });
      /**
     * 定时器处理超时
     */
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            setState(() {
              doingType = 2;
            });
            _timer.cancel();
          }
        });
      });

      await Future.delayed(const Duration(seconds: 2), () {});

      try {
        var snback = await _snplatform
            .invokeMethod('writeSn', <String, dynamic>{"sn": sn});
        var data = jsonDecode(snback);
        print("writeSn: $data");

        uploadclound(data["data"]);
        if (data["success"]) {
          // EasyLoading.showSuccess(tr('unlock.success'));
          setState(() {
            doingType = data["data"]["execution_result"] == "成功" ? 3 : 2;
            _remainingSeconds = 30;
          });
        } else {
          EasyLoading.showError(data["errorMsg"]);
          setState(() {
            doingType = 2;
            _remainingSeconds = 30;
          });
        }
        _timer.cancel();
      } on PlatformException catch (e) {
        print(" unLock: '${e.message}'.");
      }
    });
  }

  bool isNumeric(String str) {
    if (str.isEmpty) return false;
    for (int i = 0; i < str.length; i++) {
      if (!RegExp(r'[0-9]').hasMatch(str[i])) {
        return false;
      }
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          _key.currentState?.fun();
          Get.off(() => const deviceUnlockWelcomePage());
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {
                    Get.off(() => const deviceUnlockWelcomePage());
                  },
                  icon: const Icon(Icons.chevron_left,
                      color: Colors.black, size: 36)),
              title: const Text(
                'writeSn.title',
                style: TextStyle(color: Colors.black),
              ).tr(),
              centerTitle: true,
              actions: [],
            ),
            body: GetBuilder<deviceInfoController>(
                init: deviceInfoController(),
                builder: (_) => Stack(children: <Widget>[
                      SingleChildScrollView(
                          child: Container(
                        width: 720.w,
                        height: 1280.h - 80,
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(32.w, 24.h, 32.w, 24.h),
                        child: Column(
                          children: [
                            baseContainer(
                                child: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 24.h, 0, 0.h),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'afterSalesReplacement.sn',
                                            style: ErrorTip(),
                                          ).tr(),
                                          Stack(
                                            children: [
                                              Positioned(
                                                  child: Container(
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 9, 0, 0),
                                                padding:
                                                    const EdgeInsets.all(14),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            42),
                                                    color: snInputColors),
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        openscan();
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                10, 0, 10, 0),
                                                        child: Image.asset(
                                                          'public/images/waterPump/scran.png',
                                                          width: 40.w,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  0, 0, 0, 0),
                                                          child: snInput(
                                                            key: _key,
                                                            valBack: (back) {
                                                              setState(() {
                                                                sn = back;
                                                              });
                                                            },
                                                          )),
                                                    )
                                                  ],
                                                ),
                                              )),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 15, 0, 0),
                                            child: Text(
                                              "${tr('deviceSN')}:${_deviceInfoController.loacalDevice.value.sn.toUpperCase()}",
                                              style: ErrorTip(),
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              ],
                            )),
                            if (doingType != 0)
                              Container(
                                  height: 400,
                                  child: baseContainer(
                                      child: doingType == 1
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'public/images/waterPump/loading.gif',
                                                  width: 280,
                                                ),
                                                // Padding(
                                                //   padding: EdgeInsets.fromLTRB(
                                                //       0, 40.h, 0, 16.h),
                                                //   child: Text(
                                                //     tr('unlock.sndoing',
                                                //         namedArgs: {
                                                //           "val":
                                                //               "$_remainingSeconds"
                                                //         }),
                                                //     textAlign: TextAlign.center,
                                                //     style: const TextStyle(
                                                //         fontSize: 18,
                                                //         color: Color.fromRGBO(
                                                //             13, 13, 13, 1),
                                                //         fontWeight:
                                                //             FontWeight.w500),
                                                //   ),
                                                // ),
                                                // Padding(
                                                //   key: ValueKey(
                                                //       '_remainingSeconds:$_remainingSeconds'),
                                                //   padding: EdgeInsets.fromLTRB(
                                                //       0, 0.h, 0, 0.h),
                                                //   child: Text(
                                                //       tr('unlock.sndoingtip'),
                                                //       textAlign:
                                                //           TextAlign.center,
                                                //       style: const TextStyle(
                                                //           fontSize: 14,
                                                //           color: Color.fromRGBO(
                                                //               140, 140, 140, 1),
                                                //           fontWeight:
                                                //               FontWeight.w500)),
                                                // ),
                                              ],
                                            )
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  doingType == 3
                                                      ? 'public/images/afterSalesReplacement/success.png'
                                                      : 'public/images/afterSalesReplacement/error.png',
                                                  width: 302.w,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 40.h, 0, 40.h),
                                                  child: Text(
                                                    doingType == 3
                                                        ? tr('writeSn.success')
                                                        : tr('writeSn.error'),
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        color: Color.fromRGBO(
                                                            13, 13, 13, 1),
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 440.w,
                                                  height: 72.h,
                                                  child: Center(
                                                    child: SizedBox(
                                                        width: 208.w,
                                                        height: 72.h,
                                                        child: normalButton(
                                                          label:
                                                              tr('determine'),
                                                          onClick: () async {
                                                            setState(() {
                                                              doingType = 0;
                                                            });
                                                          },
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            ))),
                            if (doingType == 0) Expanded(child: Container()),
                            if (doingType == 0)
                              Container(
                                height: 57,
                                padding:
                                    EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                                child: Center(
                                  child: submitButton(
                                    isActive: sn != "" && (sn.length == 22),
                                    label: tr('determine'),
                                    onClick: () async {
                                      if (sn ==
                                          _deviceInfoController
                                              .loacalDevice.value.sn) {
                                        bool issend = await divConfirmOnlyDialog(
                                            context,
                                            confirmTitle: tr(
                                                "device.controltDialog.confirmTitle"),
                                            isSubmitButton: true,
                                            confirmDescriptionWidget: SizedBox(
                                              width: 560.w,
                                              height: 96.h,
                                              child: SingleChildScrollView(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 0, 0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'writeSn.samesntip',
                                                      style: titleText(),
                                                    ).tr(),
                                                  ],
                                                ),
                                              )),
                                            ));
                                      } else if (sn != "" &&
                                          (sn.length == 22)) {
                                        // bool snpass = isNumeric(sn);
                                        // if (!snpass) {
                                        //   EasyLoading.showError(tr('writeSn.error1'));
                                        //   return;
                                        // }
                                        try {
                                          init();
                                        } on PlatformException catch (e) {
                                          EasyLoading.showError('${e.message}');
                                        }
                                      } else {
                                        EasyLoading.showError(
                                            tr('writeSn.error1'));
                                      }
                                    },
                                  ),
                                ),
                              )
                          ],
                        ),
                      )),
                    ]))));
  }
}
