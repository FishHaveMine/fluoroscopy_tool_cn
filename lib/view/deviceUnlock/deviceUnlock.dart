import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/snInput.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/color.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import 'historyList.dart';
import 'unlock.dart';
import 'writeSn.dart';

class deviceUnlock extends StatefulWidget {
  const deviceUnlock({super.key});
  @override
  State<deviceUnlock> createState() => _deviceUnlockState();
}

class _deviceUnlockState extends State<deviceUnlock> {
  static const platform = MethodChannel('samples.flutter.dev/battery');
  static const _snplatform =
      MethodChannel('samples.flutter.dev/writeSnService');

  final deviceInfoController _deviceInfoController = Get.find();

  bool isSure = false;
  String sn = '';
  int limit = 0;

  initcount() async {
    var reportData =
        await platform.invokeMethod('unLockgetData', <String, dynamic>{
      "isall": false,
      "report": 0,
      "pageindex": 1,
    });
    var jsondata2 = jsonDecode(reportData);
    if (jsondata2["success"]) {
      limit = jsondata2["totalCount"];
    }

    if (limit > 4) {
      bool issend = await divConfirmOnlyDialog(context,
          confirmTitle: tr("refrigerant.checkBefor.title"),
          isSubmitButton: true,
          confirmDescriptionWidget: SizedBox(
              width: 560.w,
              height: 116.h,
              child: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Text(
                    tr("deviceunlock.unlocklimit",
                        namedArgs: {"val": "$limit"}),
                    style: normalText(),
                  ),
                ),
              ))));
      if (issend) {
        Get.to(() => const unlockhistory());
      }
    }
    setState(() {
      limit;
    });
  }

  openscan() async {
    try {
      await platform.invokeMethod('SCANNER_TRIG');
    } on PlatformException catch (e) {
      print("Failed to SCANNER_TRIG: '${e.message}'.");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initcount();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.offAllNamed('/home'); //
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {
                    Get.offAllNamed('/home'); //
                  },
                  icon: const Icon(Icons.chevron_left,
                      color: Colors.black, size: 36)),
              title: const Text(
                'deviceunlock.title',
                style: TextStyle(color: Colors.black),
              ).tr(),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                  child: TextButton(
                      onPressed: () async {
                        await platform.invokeMethod('REMOVE_RESULT');
                        Get.to(() => const unlockhistory());
                      },
                      child: Text(
                        'deviceunlock.unlockhistory',
                        style: actionsTextButtonStyle(),
                      ).tr()),
                )
              ],
            ),
            body: Stack(children: <Widget>[
              SingleChildScrollView(
                  child: Container(
                width: 720.w,
                height: 1280.h - 80,
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(32.w, 24.h, 32.w, 24.h),
                child: Column(
                  children: [
                    Expanded(
                        child: baseContainer(
                            child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 24.h, 0, 0.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'afterSalesReplacement.sn',
                                    style: ErrorTip(),
                                  ).tr(),
                                  Stack(
                                    children: [
                                      Positioned(
                                          child: Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 9, 0, 0),
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(42),
                                            color: snInputColors),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                openscan();
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
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
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 0, 0),
                                                  child: snInput(
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
                                  )
                                ],
                              )),
                        ),
                        if (limit > 0)
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: Text(
                              tr("deviceunlock.unlocklimit",
                                  namedArgs: {"val": "$limit"}),
                              style: normalText(),
                            ),
                          )
                      ],
                    ))),
                    Container(
                      height: 57,
                      padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                      child: Center(
                        child: submitButton(
                          isActive: sn ==
                                  _deviceInfoController.loacalDevice.value.sn &&
                              limit < 4,
                          label: tr('deviceunlock.unlockbtn'),
                          onClick: () async {
                            if (limit > 4) {
                              return;
                            }
                            if (sn == "") {
                              EasyLoading.showError(tr('deviceunlock.snempty'));
                              return;
                            }
                            if (sn ==
                                _deviceInfoController.loacalDevice.value.sn) {
                              bool issend = await divConfirmOnlyDialog(context,
                                  confirmText: tr(
                                      'deviceunlock.unlockbtn.confirmbutton'),
                                  confirmTitle:
                                      tr("deviceunlock.unlockbtn.confirmTitle"),
                                  isSubmitButton: true,
                                  confirmDescriptionWidget: makesurebox(
                                onchange: (val) {
                                  setState(() {
                                    isSure = val;
                                  });
                                },
                              ));
                              if (isSure) {
                                await platform.invokeMethod('REMOVE_RESULT');
                                Get.to(() => const unlock());
                              }
                            } else {
                              EasyLoading.showError(
                                  tr('deviceunlock.entererror'));
                            }

                            // if (sn ==
                            //     _deviceInfoController.loacalDevice.value.sn) {
                            //   var getDeviceTypeEnum = 99;
                            //   try {
                            //     getDeviceTypeEnum = await platform
                            //         .invokeMethod('getDeviceTypeEnum',
                            //             <String, dynamic>{});
                            //     print('getDeviceTypeEnum:$getDeviceTypeEnum');
                            //   } on PlatformException catch (e) {
                            //     print(" unLock: '${e.message}'.");
                            //   }
                            //   try {
                            //     var unLock = await platform.invokeMethod(
                            //         'unLock', <String, dynamic>{});
                            //     print('unLock: $unLock');
                            //   } on PlatformException catch (e) {
                            //     print(" unLock: '${e.message}'.");
                            //   }
                            // }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              )),
              Positioned(
                bottom: 280.h, // 距离底部的距离
                right: 0.0, // 距离右侧的距离
                child: InkWell(
                  onTap: () async {
                    await platform.invokeMethod('REMOVE_RESULT');
                    Get.to(() => const writeSn());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white, // 背景色为白色
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(200), // 左上角圆角半径为200
                        bottomLeft: Radius.circular(200), // 左下角圆角半径为200
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                          child: Image.asset(
                            'public/images/writeSn.png',
                            width: 48.w,
                          ),
                        ),
                        const Text(
                          "deviceunlock.writeSn",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              color: Color.fromRGBO(38, 38, 38, 1)),
                        ).tr()
                      ],
                    ),
                  ),
                ),
              ),
            ])));
  }
}

class makesurebox extends StatefulWidget {
  Function? onchange;
  makesurebox({super.key, this.onchange});

  @override
  State<makesurebox> createState() => _makesureboxState();
}

class _makesureboxState extends State<makesurebox> {
  bool isSure = false;
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
    return SizedBox(
      width: 560.w,
      height: 345,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(
                'deviceunlock.unlockbtn.confirm1',
                style: normalTextBlack(),
              ).tr(),
            ),
            Text(
              'deviceunlock.unlockbtn.confirm2',
              style: normalTextBlack(),
            ).tr(),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 32.h, 0, 32.h),
              child: Image.asset(
                'public/images/deviceunlocktip.png',
                width: 470.w,
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isSure = !isSure;
                });
                widget.onchange!(isSure);
              },
              child: Container(
                key: ValueKey("isSure_InkWell_$isSure"),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RoundCheckBox(
                      key: ValueKey("isSure_$isSure"),
                      isChecked: isSure,
                      onTap: (selected) {
                        setState(() {
                          isSure = selected!;
                        });

                        widget.onchange!(isSure);
                      },
                      size: 20,
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
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 5),
                      child: const Text(
                              'afterSalesReplacement.NewBoardParameterImport.confirmtip')
                          .tr(),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
