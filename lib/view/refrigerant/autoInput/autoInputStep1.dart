import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:fluoroscopy_tool/view/refrigerant/autoInput/inputing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import '../index.dart';

class autoInputStep1 extends StatefulWidget {
  autoInputStep1({super.key});

  @override
  State<autoInputStep1> createState() => _copybasepageState();
}

class _copybasepageState extends State<autoInputStep1> {
  int step = 0;
  bool isSure = false;
  bool is4Gmodel = false;
  static const _selfplatform =
      MethodChannel('samples.flutter.dev/RefrigerantService');

  static const _cloundplatform =
      MethodChannel('samples.flutter.dev/getProjectHandler');

  var deviceinfo = {};
  searchDevice() async {
    try {
      var send = {
        "projectCode": "",
        "sn": _deviceInfoController.loacalDevice.value.sn,
        "pageindex": 1
      };
      var historyback = await _cloundplatform.invokeMethod(
          'getProfessionalToolsHandler.page', send);

      var historydata = jsonDecode(historyback);
      if (historydata["data"] != null && historydata["data"][0] != null) {
        return historydata["data"][0]["netModelEnum"];
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  final deviceInfoController _deviceInfoController = Get.find();

  List titleColumn = [];
  List titleRow = [
    "canauto",
    "systemOperationtable",
    "compressor1Frequency",
    "compressor2Frequency",
    "highPressure",
    "lowPressure",
    "t7C1Temp",
    "t7C2Temp",
    "highPressureSaturationTemp",
    "subCooling",
  ];

  initTabel() {
    if (_deviceInfoController.outdoorEntityList.isNotEmpty) {
      titleColumn = [];
      for (var element in _deviceInfoController.outdoorEntityList) {
        titleColumn.add("${element["address"]}#");
      }
      setState(() {
        titleColumn;
      });
    }

    print("initTabel: ${titleColumn}");
  }

  tonext() async {
    if (!_deviceInfoController.canauto.value ||
        // ignore: unrelated_type_equality_checks
        _deviceInfoController.systemOperation.value != "1") {
      await divConfirmOnlyDialog(context,
          isSubmitButton: true,
          confirmTitle: tr("refrigerant.checkLessNext.title"),
          confirmText: tr("refrigerant.checkLessNext.btn"),
          confirmDescriptionWidget: Container(
              width: 560.w,
              height: 160,
              padding: EdgeInsets.fromLTRB(24.w, 24.w, 24.w, 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: !is4Gmodel
                      ? [
                          Text.rich(TextSpan(
                            style: normalTextBlack(),
                            text: tr("refrigerant.checkLessNext.content1"),
                          )),
                        ]
                      : [
                          Text.rich(TextSpan(
                            style: normalTextBlack(),
                            text: tr("refrigerant.checkLessNext.content"),
                          )),
                          Text.rich(TextSpan(
                            style: normalTextBlack(
                                fontcolor: _deviceInfoController
                                            .systemOperation.value !=
                                        "1"
                                    ? Colors.red
                                    : Colors.black),
                            text: tr("refrigerant.checkLessNext.contenttip1"),
                          )),
                          Text.rich(TextSpan(
                            style: normalTextBlack(
                                fontcolor: !_deviceInfoController.canauto.value
                                    ? Colors.red
                                    : Colors.black),
                            text: tr("refrigerant.checkLessNext.contenttip12"),
                          )),
                          Text.rich(TextSpan(
                            style: normalTextBlack(),
                            text: tr("refrigerant.checkLessNext.contenttip13"),
                          ))
                        ],
                ),
              )));
      return;
    }
    setState(() {
      step = 1;
    });
  }

  toInputing() async {
    var isTrueCondition = await _selfplatform
        .invokeMethod('openRefrigerant', <String, dynamic>{});
    var data = jsonDecode(isTrueCondition);
    print("refrigerant openRefrigerant: $isTrueCondition");
    if (data["success"]) {
      Get.off(() => inputing());
    } else {
      EasyLoading.showError(data["errorMsg"]);
    }
  }

  _check4G() async {
    is4Gmodel = false;
    _deviceInfoController.setCanAuto(true);

    // String netModelEnum = await searchDevice();
    // print("netModelEnum: $netModelEnum");
    // if (netModelEnum != "MODEL_4G") {
    //   is4Gmodel = false;
    //   _deviceInfoController.setCanAuto(true);
    // } else {
    //   /** 有4g模块 ， 添加判断 */
    //   is4Gmodel = true;
    //   _deviceInfoController.setCanAuto(false);
    // }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _check4G();
      initTabel();
    });
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
            'refrigerant.autoInputStep',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [],
        ),
        body: Container(
          width: 720.w,
          height: 1280.h,
          color: const Color.fromRGBO(255, 255, 255, 1),
          padding: step == 0 ? null : EdgeInsets.fromLTRB(32.w, 0.h, 32.w, 0.h),
          child: step == 0
              ? Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(32.w, 0.h, 32.w, 0.h),
                        child: deviceInfo(
                          sn: _deviceInfoController.loacalDevice.value.sn,
                          deviceVersion: "",
                          systemOperation: "",
                        ),
                      ),
                      Expanded(
                          key: ValueKey("infotable_${titleColumn.length}"),
                          child: infotable(
                              titleColumn: titleColumn, titleRow: titleRow)),
                      Container(
                        height: 57,
                        padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                        child: Center(
                          child: submitButton(
                            isActive: _deviceInfoController.canauto.value &&
                                // ignore: unrelated_type_equality_checks
                                _deviceInfoController.systemOperation.value ==
                                    "1",
                            label: tr(
                                step < 4
                                    ? 'refrigerant.autoInputStep.btn'
                                    : 'refrigerant.autoInputStep.finsh',
                                namedArgs: {"step": "${step + 1}"}),
                            onClick: () async {
                              tonext();
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                        child: Container(
                      child: step == 4
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 24.h, 0, 0.h),
                                  child: Image.asset(
                                    'public/images/refrigerant/start.png',
                                    width: 404.w,
                                  ),
                                ),
                                Text.rich(TextSpan(
                                  style: normalTextBlack(fSize: 16),
                                  text: tr(
                                      "refrigerant.autoInputStep${step}.tip"),
                                )),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isSure = !isSure;
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RoundCheckBox(
                                        isChecked: isSure,
                                        onTap: (selected) {
                                          setState(() {
                                            isSure = selected!;
                                          });
                                        },
                                        size: 20,
                                        checkedWidget: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        checkedColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        border: Border.all(
                                            // width: 1,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 0, 2),
                                        child: Text(
                                          "refrigerant.autoInputStep${step}",
                                          style: normalTextBlack(
                                              fSize: 16, fw: FontWeight.w600),
                                        ).tr(),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "refrigerant.autoInputStep.tip",
                                  style: normalTextBlack(fSize: 16),
                                ).tr(),
                                Text(
                                  "refrigerant.autoInputStep${step}",
                                  style: normalTextBlack(
                                      fSize: 16, fw: FontWeight.w600),
                                ).tr(),
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0, 24.h, 0, 40.h),
                                  child: Image.asset(
                                    'public/images/refrigerant/tip${step}.png',
                                    width: 644.w,
                                  ),
                                ),
                                Text.rich(TextSpan(
                                  style: normalTextBlack(fSize: 16),
                                  text: tr(
                                      "refrigerant.autoInputStep${step}.tip"),
                                ))
                              ],
                            ),
                    )),
                    Container(
                      height: 57,
                      padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                      child: Center(
                        child: submitButton(
                          isActive: step < 4 ? true : isSure,
                          label: tr(
                              step < 4
                                  ? 'refrigerant.autoInputStep.btn'
                                  : 'refrigerant.autoInputStep.finsh',
                              namedArgs: {"step": "${step + 1}"}),
                          onClick: () async {
                            if (step != 4) {
                              setState(() {
                                step++;
                              });
                            } else {
                              if (isSure) {
                                toInputing();
                              }
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
        ));
  }
}
