// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/view/afterSalesReplacement/connectStep1.dart';
import 'package:fluoroscopy_tool/view/communication/index.dart';
import 'package:fluoroscopy_tool/view/electronicExpansionValve/tip.dart';
import 'package:fluoroscopy_tool/view/protocoldetection/welcomePage.dart';
import 'package:fluoroscopy_tool/view/refrigerant/index.dart';
import 'package:fluoroscopy_tool/view/systemCapabilityAnalysis/index.dart';
import 'package:fluoroscopy_tool/view/userinfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../afterSalesReplacement/style.dart';
import '../electronicExpansionValve/index.dart';
import '../waterPumpInspection/index.dart';
import '../waterPumpInspection/search.dart';
import 'publicFunction.dart';
import 'style.dart';

import 'package:get/get.dart';

/// 本地连接最下面的卡片组建
/// 包含水泵检测、膨胀阀检测、协议检测等

class cardFunList extends StatefulWidget {
  const cardFunList({super.key});

  @override
  State<cardFunList> createState() => _cardFunListState();
}

class _cardFunListState extends State<cardFunList> {
  final deviceInfoController _deviceInfoController = Get.find();
  final userinfoController _promissioncontroller = Get.find();

  static const _selfplatform =
      MethodChannel('samples.flutter.dev/RefrigerantService');

  static const MSInterfaceplatform =
      MethodChannel('samples.flutter.dev/MSInterface');

  static const platform = MethodChannel('samples.flutter.dev/battery');

  /// 卡片方法的排列对象
  List funNameList = [
    "communication",
    "waterPump",
    "electronicExpansionValve",
    "protocol",
    // "systemAnalysis",
    "refrigerant"
  ];

  /// 用于匹配方法的多语言处理
  Map pk = {
    "communication": "CommunicateDetect",
    "waterPump": "WaterPumpDetect",
    "electronicExpansionValve": "ElecExpansValveDetect",
    "protocol": "ProtocolDetect",
    "systemAnalysis": "SystemCapabilityAnalysis",
    "refrigerant": "RefrigerantDetectCharge"
  };

  List<Widget> allFun = [];
  bool isV8V6 = false;
  bool isAllV8 = false;
  checkpromission() async {
    try {
      if (_deviceInfoController.indoorEntityList.isNotEmpty) {
        bool containsV6 = _deviceInfoController.indoorEntityList.value
            .any((item) => item['isV8Indoor'] == true);
        isAllV8 = containsV6; //全部都是v8内机
      }
      var getProtocol =
          await _selfplatform.invokeMethod('getProtocol', <String, dynamic>{});
      var data = jsonDecode(getProtocol);
      isV8V6 = data["data"] == "V8V6";
      _deviceInfoController.setDeviceProtocol(getProtocol["data"]);
      return isV8V6 && isAllV8;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isV8() async {
    try {
      if (!_deviceInfoController.loacalDevice.value.isconnected) {
        return false;
      }
      var getProtocol =
          await _selfplatform.invokeMethod('getProtocol', <String, dynamic>{});
      var data = jsonDecode(getProtocol);
      bool isv8 = data["data"].toString().contains("V8");
      return isv8;
    } catch (e) {
      return false;
    }
  }

  initFun({String? languageCode}) async {
    print("languageCode: $languageCode");
    for (var i = 0; i < funNameList.length; i++) {
      allFun.add(GestureDetector(
        child: Opacity(
            opacity: _deviceInfoController.isBluetooth.value ? 0.4 : 1,
            child: Container(
              width: (656.w - 48.w - 24.w) / 4,
              height: 120.h,
              padding: EdgeInsets.fromLTRB(0, 12.w, 0, 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      'public/images/icon/CommunicationDetection${i + 1}.png',
                      width: 64.w,
                    ),
                    const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 5)),
                    Center(
                      child: Text(funNameList[i],
                              overflow: TextOverflow.ellipsis,
                              maxLines: languageCode == 'zh' ? 1 : 2, // 只显示一行
                              textAlign: TextAlign.center,
                              style: languageCode == 'zh'
                                  ? cardFunName(context)
                                  : cardFunNameSmall(context))
                          .tr(),
                    )
                  ],
                ),
              ),
            )),
        onTap: () async {
          if (!_deviceInfoController.loacalDevice.value.isconnected) {
            await _deviceInfoController.setLocalBluetoothConnect(false);
          }
          if (_deviceInfoController.isBluetooth.value) {
            EasyLoading.showError(tr("bluetooth.dissupport"));
            return;
          }
          if (!_promissioncontroller.checkLocalPromission(pk[funNameList[i]])) {
            return;
          }
          if (funNameList[i] == 'communication') {
            Get.to(() => communicationTypeSelectPage());
          }
          if (funNameList[i] == 'electronicExpansionValve') {
            // Get.to(() => electronicExpansionValveTip());
            // return;
            // ignore: use_build_context_synchronously
            bool issend = await divConfirmOnlyDialog(context,
                confirmText:
                    _deviceInfoController.loacalDevice.value.isconnected
                        ? tr("connecthelp")
                        : tr('deviceunlock.connecd'),
                confirmTitle: tr("electronicExpansionValve.title"),
                isSubmitButton: true,
                confirmDescriptionWidget: SizedBox(
                  width: 600.w,
                  height: _deviceInfoController.loacalDevice.value.isconnected
                      ? 426.h
                      : 450.h,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'deviceunlock.tip1',
                            style: titleStyleS(),
                          ).tr(),
                          Text(
                            'electronicExpansionValve.main.tip2',
                            style: titleStyleS(),
                          ).tr(),
                          Padding(
                            padding: _deviceInfoController
                                    .loacalDevice.value.isconnected
                                ? const EdgeInsets.fromLTRB(0, 25, 0, 0)
                                : const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: Text(
                              'deviceunlock.tip3',
                              style: titleStyleS(),
                            ).tr(),
                          ),
                          _deviceInfoController
                                      .loacalDevice.value.isconnected &&
                                  _deviceInfoController
                                          .indoorEntityList.length ==
                                      1
                              ? Text(
                                  'electronicExpansionValve.main.tip3',
                                  style: titleStyleS(),
                                ).tr()
                              : const Text(
                                  'electronicExpansionValve.main.tip3',
                                  style: TextStyle(color: Colors.red),
                                ).tr(),
                          _deviceInfoController.loacalDevice.value.isconnected
                              ? Text(
                                  'deviceunlock.tip5',
                                  style: titleStyleS(),
                                ).tr()
                              : const Text(
                                  'deviceunlock.tip5_error',
                                  style: TextStyle(color: Colors.red),
                                ).tr(),
                        ],
                      ),
                    ),
                  ),
                ));
            if (issend) {
              if (!_deviceInfoController.loacalDevice.value.isconnected) {
                Get.to(() => electronicExpansionValveTip());
                // Get.to(() => connectStep1Page(
                //       title: tr('afterSalesReplacement.connectTypeTitle'),
                //       connectType: const [
                //         'afterSalesReplacement.connectType3',
                //       ],
                //       nextPage: electronicExpansionValveTip(),
                //     ));
              } else {
                bool ispass = await isV8();
                if (ispass) {
                  try {
                    _deviceInfoController.checkisPollingBack();
                  } catch (e) {
                    return;
                  }
                  Get.to(() => electronicExpansionValveTip());
                }
              }
            }
          }

          if (funNameList[i] == 'waterPump') {
// ignore: use_build_context_synchronously
            bool issend = await divConfirmOnlyDialog(context,
                confirmText:
                    _deviceInfoController.loacalDevice.value.isconnected
                        ? tr('determine')
                        : tr('deviceunlock.connecd'),
                confirmTitle: tr("waterPump"),
                isSubmitButton: true,
                confirmDescriptionWidget: SingleChildScrollView(
                  child: SizedBox(
                    width: 600.w,
                    height: _deviceInfoController.loacalDevice.value.isconnected
                        ? 426.h
                        : 460.h,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'deviceunlock.tip1',
                            style: titleStyleS(),
                          ).tr(),
                          Text(
                            'waterPump.connect.tip2',
                            style: titleStyleS(),
                          ).tr(),
                          Padding(
                            padding: _deviceInfoController
                                    .loacalDevice.value.isconnected
                                ? const EdgeInsets.fromLTRB(0, 25, 0, 0)
                                : const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: Text(
                              'deviceunlock.tip3',
                              style: titleStyleS(),
                            ).tr(),
                          ),
                          _deviceInfoController.loacalDevice.value.model ==
                                      'V8' ||
                                  !_deviceInfoController
                                      .loacalDevice.value.isconnected
                              ? Text(
                                  'trialRun.tip4',
                                  style: titleStyleS(),
                                ).tr()
                              : const Text(
                                  'trialRun.tip4_error',
                                  style: TextStyle(color: Colors.red),
                                ).tr(),
                          _deviceInfoController.loacalDevice.value.isconnected
                              ? Text(
                                  'deviceunlock.tip5',
                                  style: titleStyleS(),
                                ).tr()
                              : const Text(
                                  'deviceunlock.tip5_error',
                                  style: TextStyle(color: Colors.red),
                                ).tr(),
                        ],
                      ),
                    ),
                  ),
                ));
            if (issend) {
              if (!_deviceInfoController.loacalDevice.value.isconnected) {
                Get.to(() => connectStep1Page(
                      title: tr('afterSalesReplacement.connectTypeTitle'),
                      connectType: const [
                        'afterSalesReplacement.connectType1',
                        'afterSalesReplacement.connectType3',
                      ],
                      nextPage: const waterPumpInspectionList(),
                    ));
              } else {
                try {
                  _deviceInfoController.checkisPollingBack();
                } catch (e) {
                  return;
                }
                await checkpromission();
                if (isV8V6 && isAllV8) {
                  Get.to(() => const waterPumpPage());
                } else {
                  if (_deviceInfoController.loacalDevice.value.model == 'V8') {
                    Get.to(() => const waterPumpInspectionList());
                  }
                }
              }
            }
          }

          if (funNameList[i] == 'systemAnalysis') {
            // EasyLoading.showInfo(tr("codingtip.Text"));
            // return;
            Get.to(() => const systemCapabilityAnalysisPage());
          }

          if (funNameList[i] == 'refrigerant') {
            // ignore: use_build_context_synchronously
            bool issend = await divConfirmOnlyDialog(context,
                confirmText:
                    _deviceInfoController.loacalDevice.value.isconnected
                        ? tr('determine')
                        : tr('deviceunlock.connecd'),
                confirmTitle: tr("refrigerant.confirm.title"),
                isSubmitButton: true,
                confirmDescriptionWidget: SingleChildScrollView(
                    child: SizedBox(
                  width: 600.w,
                  height: _deviceInfoController.loacalDevice.value.isconnected
                      ? 426.h
                      : 460.h,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'deviceunlock.tip1',
                            style: titleStyleS(),
                          ).tr(),
                          Text(
                            'refrigerant.confirm.tip1',
                            style: titleStyleS(),
                          ).tr(),
                          Padding(
                            padding: _deviceInfoController
                                    .loacalDevice.value.isconnected
                                ? const EdgeInsets.fromLTRB(0, 25, 0, 0)
                                : const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: Text(
                              'deviceunlock.tip3',
                              style: titleStyleS(),
                            ).tr(),
                          ),
                          _deviceInfoController.loacalDevice.value.model ==
                                      'V8' ||
                                  !_deviceInfoController
                                      .loacalDevice.value.isconnected
                              ? Text(
                                  'refrigerant.confirm.tip2',
                                  style: titleStyleS(),
                                ).tr()
                              : const Text(
                                  'refrigerant.confirm.tip2',
                                  style: TextStyle(color: Colors.red),
                                ).tr(),
                          _deviceInfoController.loacalDevice.value.isconnected
                              ? Text(
                                  'deviceunlock.tip5',
                                  style: titleStyleS(),
                                ).tr()
                              : const Text(
                                  'deviceunlock.tip5_error',
                                  style: TextStyle(color: Colors.red),
                                ).tr(),
                        ],
                      ),
                    ),
                  ),
                )));
            if (issend) {
              if (!_deviceInfoController.loacalDevice.value.isconnected) {
                Get.to(() => connectStep1Page(
                      title: tr('afterSalesReplacement.connectTypeTitle'),
                      connectType: const [
                        'afterSalesReplacement.connectType1',
                        // 'afterSalesReplacement.connectType3',
                      ],
                      nextPage: refrigerantTable(),
                    ));
              } else {
                try {
                  _deviceInfoController.checkisPollingBack();
                } catch (e) {
                  return;
                }
                await checkpromission();
                bool ispass = await isV8();
                if (isV8V6 || ispass) {
                  Get.to(() => refrigerantTable());
                } else {}
              }
            }
          }

          if (funNameList[i] == 'protocol') {
            bool issend = await divConfirmOnlyDialog(context,
                confirmText:
                    _deviceInfoController.loacalDevice.value.isconnected
                        ? tr('determine')
                        : tr('deviceunlock.connecd'),
                confirmTitle: tr("protocoldetection"),
                isSubmitButton: true,
                confirmDescriptionWidget: SizedBox(
                  width: 600.w,
                  height: _deviceInfoController.loacalDevice.value.isconnected
                      ? 450.h
                      : 450.h,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'deviceunlock.tip1',
                            style: titleStyleS(),
                          ).tr(),
                          Text(
                            'protocoldetection.tip2',
                            style: titleStyleS(),
                          ).tr(),
                          Padding(
                            padding: _deviceInfoController
                                    .loacalDevice.value.isconnected
                                ? const EdgeInsets.fromLTRB(0, 25, 0, 0)
                                : const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: Text(
                              'deviceunlock.tip3',
                              style: titleStyleS(),
                            ).tr(),
                          ),
                          _deviceInfoController.loacalDevice.value.model ==
                                      'V8' ||
                                  _deviceInfoController
                                          .loacalDevice.value.model ==
                                      'V6' ||
                                  _deviceInfoController
                                          .loacalDevice.value.model ==
                                      'V4+' ||
                                  _deviceInfoController
                                          .loacalDevice.value.model ==
                                      'V4Plus' ||
                                  !_deviceInfoController
                                      .loacalDevice.value.isconnected
                              ? Text(
                                  'protocoldetection.tip4',
                                  style: titleStyleS(),
                                ).tr()
                              : const Text(
                                  'protocoldetection.tip4_error',
                                  style: TextStyle(color: Colors.red),
                                ).tr(),
                          _deviceInfoController.loacalDevice.value.isconnected
                              ? Text(
                                  'deviceunlock.tip5',
                                  style: titleStyleS(),
                                ).tr()
                              : const Text(
                                  'deviceunlock.tip5_error',
                                  style: TextStyle(color: Colors.red),
                                ).tr(),
                        ],
                      ),
                    ),
                  ),
                ));
            if (issend) {
              if (!_deviceInfoController.loacalDevice.value.isconnected) {
                Get.to(() => connectStep1Page(
                      title: tr('afterSalesReplacement.connectTypeTitle'),
                      connectType: const [
                        'afterSalesReplacement.connectType5',
                        'afterSalesReplacement.connectType6',
                      ],
                      nextPage: protocolwelcomePage(),
                    ));
              } else {
                try {
                  _deviceInfoController.checkisPollingBack();
                } catch (e) {
                  return;
                }
                if (_deviceInfoController.loacalDevice.value.isconnected &&
                    (_deviceInfoController.loacalDevice.value.model == 'V8' ||
                        _deviceInfoController.loacalDevice.value.model ==
                            'V6' ||
                        _deviceInfoController.loacalDevice.value.model ==
                            'V4+' ||
                        _deviceInfoController.loacalDevice.value.model ==
                            'V4Plus')) Get.to(() => protocolwelcomePage());
              }
            }
          }
        },
      ));
      setState(() {
        allFun;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String? languageCode =
          EasyLocalization.of(context)?.currentLocale?.languageCode;
      initFun(languageCode: languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 384.h,
      width: 656.w,
      margin: EdgeInsets.fromLTRB(paddingLR, 10, paddingLR, 0),
      padding: const EdgeInsets.all(12),
      decoration: cardStyle(context),
      child: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'smartDetection',
            style: funName(context),
          ).tr(),
          Wrap(
            spacing: 0,
            runSpacing: 0,
            children: allFun,
          )
        ],
      )),
    );
  }
}
