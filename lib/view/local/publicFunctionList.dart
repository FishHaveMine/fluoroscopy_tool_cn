import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/view/afterSalesReplacement/connectStep1.dart';
import 'package:fluoroscopy_tool/view/afterSalesReplacement/connectStep2.dart';
import 'package:fluoroscopy_tool/view/afterSalesReplacement/publicFunction.dart';
import 'package:fluoroscopy_tool/view/connectselect/connecttype.dart';
import 'package:fluoroscopy_tool/view/local/parameters/index.dart';
import 'package:fluoroscopy_tool/view/userinfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../afterSalesReplacement/style.dart';
import '../deviceUnlock/welcomePage.dart';
import '../parametersSetting/index.dart';
import '../trialRun/index.dart';
import 'checkData/IndoorUnitCentralControl/IndoorUnitCentralControl.dart';
import 'publicFunction.dart';
import 'style.dart';

import 'package:get/get.dart';

class publicFunctionList extends StatelessWidget {
  publicFunctionList({super.key});

  final deviceInfoController _deviceInfoController = Get.find();
  final userinfoController _promissioncontroller = Get.find();

  static const platform = MethodChannel('samples.flutter.dev/battery');

  static const _selfplatform =
      MethodChannel('samples.flutter.dev/RefrigerantService');
  final afterSalesReplacementController _selfController =
      Get.put(afterSalesReplacementController());
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(65 / 2, 0, 65 / 2, 0.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          imageFunItem(
              imageUrl: 'public/images/icon/function1.png',
              title: 'deviceUnlock',
              onClick: () async {
                if (_promissioncontroller.checkLocalPromission("LocalUnlock")) {
                  // try {
                  //   _deviceInfoController.checkisPollingBack();
                  // } catch (e) {
                  //   return;
                  // }
                  if (_deviceInfoController.isBluetooth.value) {
                    if (_deviceInfoController.loacalDevice.value.isconnected) {
                      Get.to(() => const IndoorUnitCentralControl());
                      return;
                    } else {
                      Get.to(() => connecttypepage(
                            nextPage: const IndoorUnitCentralControl(),
                          ));
                      return;
                    }
                  } else {
                    Get.to(() => const IndoorUnitCentralControl());
                    return;
                  }

                  bool issend = await divConfirmOnlyDialog(context,
                      confirmText:
                          _deviceInfoController.loacalDevice.value.isconnected
                              ? tr('deviceunlock.enter')
                              : tr('deviceunlock.connecd'),
                      confirmTitle: tr("deviceUnlock"),
                      isSubmitButton: true,
                      confirmDescriptionWidget: SizedBox(
                        width: 560.w,
                        height: 416.h,
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
                                'deviceunlock.tip2',
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
                              Text(
                                'deviceunlock.tip4',
                                style: titleStyleS(),
                              ).tr(),
                              _deviceInfoController
                                      .loacalDevice.value.isconnected
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
                        )),
                      ));
                  if (issend) {
                    if (!_deviceInfoController.loacalDevice.value.isconnected) {
                      _selfController.setConnectType(connectType[0]);
                      Get.to(() => connecttypepage(
                            title: tr('deviceunlock'),
                            nextPage: const deviceUnlockWelcomePage(),
                          ));
                    } else {
                      try {
                        _deviceInfoController.checkisPollingBack();
                      } catch (e) {
                        return;
                      }
                      Get.to(() => const deviceUnlockWelcomePage());
                    }
                  }
                }
              }),
          imageFunItem(
              imageUrl: 'public/images/icon/function2.png',
              title: 'installationParameters',
              onClick: () {
                if (_promissioncontroller
                    .checkLocalPromission("InstallParams")) {
                  if (!_deviceInfoController.loacalDevice.value.isconnected) {
                    Get.to(() => connecttypepage(
                          connectType: const [
                            'afterSalesReplacement.connectType1',
                            'afterSalesReplacement.connectType3',
                          ],
                          title: tr('afterSalesReplacement.connectTypeTitle'),
                          nextPage: parametersPage(),
                        ));
                  } else {
                    Get.to(() => parametersPage());
                  }
                }
              }),
          imageFunItem(
              imageUrl: 'public/images/icon/function3.png',
              title: 'trialRun',
              onClick: () async {
                if (_promissioncontroller.checkLocalPromission("TestRun")) {
//本地连接设备类型
                  // ODU(0)
                  // IDU(1)
                  // SYS(2)

                  bool issend = await divConfirmOnlyDialog(context,
                      confirmText:
                          _deviceInfoController.loacalDevice.value.isconnected
                              ? tr('determine')
                              : tr('deviceunlock.connecd'),
                      confirmTitle: tr("trialRun"),
                      isSubmitButton: true,
                      confirmDescriptionWidget: SizedBox(
                        width: 600.w,
                        height: 416.h,
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
                                'trialRun.tip2',
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
                              _deviceInfoController
                                          .loacalDevice.value.isconnected &&
                                      !(_deviceInfoController
                                                  .deviceTypeEnum.value ==
                                              1 &&
                                          (_deviceInfoController
                                                      .loacalDevice.value.IDU ==
                                                  0 ||
                                              _deviceInfoController
                                                      .loacalDevice.value.IDU ==
                                                  1))
                                  ? Text(
                                      'deviceunlock.newtip5',
                                      style: titleStyleS(),
                                    ).tr()
                                  : const Text(
                                      'deviceunlock.newtip5_error',
                                      style: TextStyle(color: Colors.red),
                                    ).tr(),
                            ],
                          ),
                        )),
                      ));
                  if (issend) {
                    if (!_deviceInfoController.loacalDevice.value.isconnected) {
                      _selfController.setConnectType(connectType[0]);
                      Get.to(() => connecttypepage(
                            title: tr('afterSalesReplacement.connectTypeTitle'),
                            nextPage: trialRunpage(),
                          ));
                    } else {
                      try {
                        _deviceInfoController.checkisPollingBack();
                      } catch (e) {
                        return;
                      }
                      if (_deviceInfoController.loacalDevice.value.model ==
                          'V8') {
                        try {
                          if (_deviceInfoController.deviceTypeEnum.value == 1 &&
                              (_deviceInfoController.loacalDevice.value.IDU ==
                                      0 ||
                                  _deviceInfoController
                                          .loacalDevice.value.IDU ==
                                      1)) {
                            return;
                          }
                        } catch (e) {}
                        Get.to(() => trialRunpage());
                      }
                    }
                  }
                }
              }),
          imageFunItem(
              imageUrl: 'public/images/icon/function4.png',
              title: 'functionSettings',
              onClick: () async {
                // EasyLoading.showInfo(tr("codingtip.Text"));
                // return;

                if (_promissioncontroller.checkLocalPromission(
                        "FunctionParamsSetting2",
                        showtoast: false) ||
                    _promissioncontroller.checkLocalPromission(
                        "FunctionParamsView2",
                        showtoast: false)) {
                  bool isv8 = false;
                  if (_deviceInfoController.loacalDevice.value.isconnected) {
                    var getProtocol = await _selfplatform
                        .invokeMethod('getProtocol', <String, dynamic>{});
                    var data = jsonDecode(getProtocol);
                    isv8 = data["data"].contains("V8");
                  }
                  if (_deviceInfoController.loacalDevice.value.isconnected &&
                      isv8) {
                    try {
                      _deviceInfoController.checkisPollingBack();
                    } catch (e) {
                      return;
                    }
                    if (_deviceInfoController
                        .indoorEntityList.value.isNotEmpty) {
                      _deviceInfoController.set_settingIndoorEntityList(
                          List.from(
                              _deviceInfoController.indoorEntityList.value));
                    }
                    _deviceInfoController.set_settingDevice(
                        _deviceInfoController.loacalDevice.toJson());

                    Get.to(() => parametersSetting());
                  } else {
                    // ignore: use_build_context_synchronously
                    bool issend = await divConfirmOnlyDialog(context,
                        isSubmitButton: true,
                        confirmTitle: tr("functionSettings"),
                        confirmText:
                            _deviceInfoController.loacalDevice.value.isconnected
                                ? tr('determine')
                                : tr('deviceunlock.connecd'),
                        confirmDescriptionWidget: SizedBox(
                            width: 560.w,
                            height: 200,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(24, 10, 24, 10),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'functionSettings.tip',
                                      style:
                                          TextStyle(fontSize: 14, height: 1.5),
                                    ).tr(),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 15, 0, 0),
                                      child: const Text(
                                        'afterSalesReplacement.confirm1',
                                        style: TextStyle(
                                            fontSize: 14, height: 1.5),
                                      ).tr(),
                                    ),
                                    Text(
                                      'afterSalesReplacement.confirm2',
                                      style: !isv8 &&
                                              _deviceInfoController.loacalDevice
                                                  .value.isconnected
                                          ? const TextStyle(
                                              fontSize: 14,
                                              height: 1.5,
                                              color: Colors.red)
                                          : const TextStyle(
                                              fontSize: 14, height: 1.5),
                                    ).tr(),
                                    Text(
                                      'afterSalesReplacement.confirm3',
                                      style: _deviceInfoController
                                              .loacalDevice.value.isconnected
                                          ? const TextStyle(
                                              fontSize: 14, height: 1.5)
                                          : const TextStyle(
                                              fontSize: 14,
                                              height: 1.5,
                                              color: Colors.red),
                                    ).tr(),
                                  ],
                                ),
                              ),
                            )));

                    if (issend != null) {
                      if (!_deviceInfoController
                          .loacalDevice.value.isconnected) {
                        Get.to(() => connecttypepage(
                              title:
                                  tr('afterSalesReplacement.connectTypeTitle'),
                              connectType: const [
                                'afterSalesReplacement.connectType1',
                                'afterSalesReplacement.connectType3',
                              ],
                              nextPage: parametersSetting(),
                            ));
                      } else {
                        try {
                          _deviceInfoController.checkisPollingBack();
                        } catch (e) {
                          return;
                        }
                        if (isv8) {
                          Get.to(() => parametersSetting());
                        }
                      }
                    }
                  }
                } else {
                  EasyLoading.showError(tr("withoutpromission"));
                }
              })
        ],
      ),
    );
  }
}

class imageFunItem extends StatelessWidget {
  String imageUrl;
  String title;
  VoidCallback onClick;
  imageFunItem(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick();
        // if (checkIsConnect(context)) {
        //   onClick();
        // }
      },
      child: SizedBox(
        width: (656.w - 65) / 4,
        child: Column(
          children: [
            Image.asset(
              imageUrl,
              width: 80.w,
            ),
            const Padding(padding: EdgeInsets.fromLTRB(0, 4, 0, 4)),
            Text(title,
                    textAlign: TextAlign.center, style: versionValue(context))
                .tr()
          ],
        ),
      ),
    );
  }
}
