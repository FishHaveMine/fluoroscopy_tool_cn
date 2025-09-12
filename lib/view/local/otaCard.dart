import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/view/afterSalesReplacement/NewBoardParameterImportAuthorization.dart';
import 'package:fluoroscopy_tool/view/afterSalesReplacement/connectStep1.dart';
import 'package:fluoroscopy_tool/view/afterSalesReplacement/publicFunction.dart';
import 'package:fluoroscopy_tool/view/errorAnalysis/index.dart';
import 'package:fluoroscopy_tool/view/ota/deviceStatus.dart';
import 'package:fluoroscopy_tool/view/userinfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../store/globalData.dart' hide connectType;
import '../afterSalesReplacement/style.dart';
import 'publicFunction.dart';
import 'style.dart';

import 'package:get/get.dart';

/// 包含设备历史告警（errorAnalysisPage）、OTA（otaDeviceStatus）、售后换板（NewBoardParameterImportAuthorization）

class otaCard extends StatefulWidget {
  const otaCard({super.key});

  @override
  State<otaCard> createState() => _otaCardState();
}

class _otaCardState extends State<otaCard> {
  final deviceInfoController _deviceInfoController = Get.find();

  final userinfoController _promissioncontroller = Get.find();
  static const _selfplatform =
      MethodChannel('samples.flutter.dev/RefrigerantService');
  final afterSalesReplacementController _selfController =
      Get.put(afterSalesReplacementController());

  bool isnetconnecd = false;
  _checknet() async {
    try {
      final response = await Dio().get('https://${apiHost}/');
      setState(() {
        isnetconnecd = response.statusCode == 200;
      });
    } catch (e) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checknet();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<deviceInfoController>(
        init: deviceInfoController(),
        builder: (_) => Container(
              margin: EdgeInsets.fromLTRB(paddingLR, 10, paddingLR, 0.h),
              child: Row(
                children: [
                  InkWell(
                    onTap: () async {
                      // Get.to(() => errorAnalysisPage());
                      // return;
                      if (_promissioncontroller
                          .checkLocalPromission("FaultIntelliAnalysis")) {
                        bool issend = await divConfirmOnlyDialog(context,
                            confirmText: _deviceInfoController
                                    .loacalDevice.value.isconnected
                                ? tr('determine')
                                : tr('deviceUnlock.connecd'),
                            confirmTitle: tr("errorAnalysis.title"),
                            isSubmitButton: true,
                            confirmDescriptionWidget: SizedBox(
                              width: 600.w,
                              height: _deviceInfoController
                                      .loacalDevice.value.isconnected
                                  ? 426.h
                                  : 460.h,
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(24, 24, 24, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'deviceUnlock.tip1',
                                        style: titleStyleS(),
                                      ).tr(),
                                      Text(
                                        'errorAnalysis.connect.tip2',
                                        style: titleStyleS(),
                                      ).tr(),
                                      Padding(
                                        padding: _deviceInfoController
                                                .loacalDevice.value.isconnected
                                            ? const EdgeInsets.fromLTRB(
                                                0, 25, 0, 0)
                                            : const EdgeInsets.fromLTRB(
                                                0, 15, 0, 0),
                                        child: Text(
                                          'deviceUnlock.tip3',
                                          style: titleStyleS(),
                                        ).tr(),
                                      ),
                                      _deviceInfoController
                                              .loacalDevice.value.isconnected
                                          ? Text(
                                              'errorAnalysis.tip4',
                                              style: titleStyleS(),
                                            ).tr()
                                          : const Text(
                                              'errorAnalysis.tip4_error',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ).tr(),
                                      isnetconnecd
                                          ? Text(
                                              'errorAnalysis.tip5',
                                              style: titleStyleS(),
                                            ).tr()
                                          : const Text(
                                              'errorAnalysis.tip5_error',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ).tr(),
                                    ],
                                  ),
                                ),
                              ),
                            ));
                        print("issend: $issend");
                        if (issend != null && issend) {
                          if (_deviceInfoController
                              .loacalDevice.value.isconnected) {
                            try {
                              _deviceInfoController.checkisPollingBack();
                            } catch (e) {
                              return;
                            }
                            // if (!isnetconnecd) {
                            //   return;
                            // }
                            Get.to(() => errorAnalysisPage());
                          } else {
                            Get.to(() => connectStep1Page(
                                  title: tr(
                                      'afterSalesReplacement.connectTypeTitle'),
                                  connectType: const [
                                    'afterSalesReplacement.connectType1',
                                    'afterSalesReplacement.connectType3',
                                  ],
                                  nextPage: errorAnalysisPage(),
                                ));
                          }
                        }
                      }
                    },
                    child: Container(
                      height: 244.h,
                      width: 318.w,
                      decoration: cardStyle(context),
                      margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      padding: EdgeInsets.all(24.w),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'smartFaultAnalysis',
                                    style: funName(context),
                                    overflow: TextOverflow.visible,
                                  ).tr(),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  color: Color.fromRGBO(136, 136, 136, 1),
                                )
                              ],
                            ),
                            const Padding(padding: EdgeInsets.all(5)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  'public/images/deviceError.png',
                                  height: 128.w,
                                ),
                                Expanded(
                                    child: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                          _deviceInfoController.loacalDevice
                                                          .value.errorCode ==
                                                      "0" ||
                                                  !_deviceInfoController
                                                      .loacalDevice
                                                      .value
                                                      .isconnected
                                              ? "--"
                                              : _deviceInfoController
                                                  .loacalDevice.value.errorCode,
                                          style: deviceError(context)),
                                      const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 8)),
                                      Text(
                                        'faultCode',
                                        style: deviceErrorInfo(context),
                                      ).tr()
                                    ],
                                  ),
                                ))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          // Get.to(() => NewBoardParameterImportAuthorization());
                          // return;
                          if (_promissioncontroller.checkLocalPromission(
                              "AfterSaleMainboardReplace")) {
                            bool isv8 = false;
                            if (_deviceInfoController
                                .loacalDevice.value.isconnected) {
                              var getProtocol = await _selfplatform
                                  .invokeMethod(
                                      'getProtocol', <String, dynamic>{});
                              var data = jsonDecode(getProtocol);
                              isv8 = data["data"].contains("V8");
                            }
                            bool issend = await divConfirmOnlyDialog(context,
                                isSubmitButton: true,
                                confirmText: _deviceInfoController
                                        .loacalDevice.value.isconnected
                                    ? tr('determine')
                                    : tr('deviceUnlock.connecd'),
                                confirmTitle:
                                    tr("device.controltDialog.confirmTitle"),
                                confirmDescriptionWidget: SizedBox(
                                    width: 560.w,
                                    height: 200,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          24, 10, 24, 10),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'afterSalesReplacement.confirm',
                                              style: TextStyle(
                                                  fontSize: 14, height: 1.5),
                                            ).tr(),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
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
                                                      _deviceInfoController
                                                          .loacalDevice
                                                          .value
                                                          .isconnected
                                                  ? const TextStyle(
                                                      fontSize: 14,
                                                      height: 1.5,
                                                      color: Colors.red)
                                                  : const TextStyle(
                                                      fontSize: 14,
                                                      height: 1.5),
                                            ).tr(),
                                            Text(
                                              'afterSalesReplacement.confirm3',
                                              style: _deviceInfoController
                                                      .loacalDevice
                                                      .value
                                                      .isconnected
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

                            if (issend) {
                              if (!_deviceInfoController
                                  .loacalDevice.value.isconnected) {
                                Get.to(() => connectStep1Page(
                                      title: tr(
                                          'afterSalesReplacement.connectTypeTitle'),
                                      nextPage:
                                          NewBoardParameterImportAuthorization(),
                                    ));
                              } else {
                                try {
                                  _deviceInfoController.checkisPollingBack();
                                } catch (e) {
                                  return;
                                }
                                if (isv8) {
                                  Get.to(() =>
                                      NewBoardParameterImportAuthorization());
                                }
                              }
                            }
                          }
                        },
                        child: Container(
                          height: 112.h,
                          width: 318.w,
                          decoration: cardStyle(context),
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          padding: EdgeInsets.fromLTRB(38.w, 0.w, 38.w, 0.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'public/images/icon/AftermarketReplacement.png',
                                width: 64.w,
                              ),
                              SizedBox(
                                width: 33.w,
                              ),
                              Expanded(
                                  child: Text(
                                'afterSalesReplacement',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: funName(context),
                              ).tr())
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          if (_deviceInfoController.isBluetooth.value) {
                            EasyLoading.showError(tr("bluetooth.dissupport"));
                            return;
                          }

                          await _deviceInfoController
                              .setLocalBluetoothConnect(false);
                          // Get.to(() => otaDeviceStatus());
                          // return;
                          if (_promissioncontroller
                              .checkLocalPromission("ProgramUpgrade")) {
                            bool issend = await divConfirmOnlyDialog(context,
                                confirmText: _deviceInfoController
                                        .loacalDevice.value.isconnected
                                    ? tr('determine')
                                    : tr('deviceUnlock.connecd'),
                                confirmTitle: tr("ota.title"),
                                isSubmitButton: true,
                                confirmDescriptionWidget: SingleChildScrollView(
                                  child: SizedBox(
                                    width: 600.w,
                                    height: _deviceInfoController
                                            .loacalDevice.value.isconnected
                                        ? 426.h
                                        : 460.h,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          24, 24, 24, 0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'deviceUnlock.tip1',
                                            style: titleStyleS(),
                                          ).tr(),
                                          Text(
                                            'ota.mian.tip1',
                                            style: titleStyleS(),
                                          ).tr(),
                                          Padding(
                                            padding: _deviceInfoController
                                                    .loacalDevice
                                                    .value
                                                    .isconnected
                                                ? const EdgeInsets.fromLTRB(
                                                    0, 25, 0, 0)
                                                : const EdgeInsets.fromLTRB(
                                                    0, 15, 0, 0),
                                            child: Text(
                                              'deviceUnlock.tip3',
                                              style: titleStyleS(),
                                            ).tr(),
                                          ),
                                          _deviceInfoController.loacalDevice
                                                          .value.model ==
                                                      'V8' ||
                                                  !_deviceInfoController
                                                      .loacalDevice
                                                      .value
                                                      .isconnected
                                              ? Text(
                                                  'trialRun.tip4',
                                                  style: titleStyleS(),
                                                ).tr()
                                              : const Text(
                                                  'trialRun.tip4_error',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ).tr(),
                                          _deviceInfoController.loacalDevice
                                                  .value.isconnected
                                              ? Text(
                                                  'deviceUnlock.tip5',
                                                  style: titleStyleS(),
                                                ).tr()
                                              : const Text(
                                                  'deviceUnlock.tip5_error',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ).tr(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ));

                            if (issend) {
                              if (!_deviceInfoController
                                  .loacalDevice.value.isconnected) {
                                Get.to(() => connectStep1Page(
                                      connectType: const [
                                        'afterSalesReplacement.connectType1',
                                        'afterSalesReplacement.connectType3',
                                      ],
                                      title: tr(
                                          'afterSalesReplacement.connectTypeTitle'),
                                      nextPage: otaDeviceStatus(),
                                    ));
                              } else {
                                if (_deviceInfoController
                                        .loacalDevice.value.isconnected &&
                                    (_deviceInfoController
                                            .loacalDevice.value.model ==
                                        'V8')) {
                                  try {
                                    _deviceInfoController.checkisPollingBack();
                                  } catch (e) {
                                    return;
                                  }
                                  Get.to(() => otaDeviceStatus());
                                }
                              }
                            }
                          }
                          // Get.to(() => otaDeviceStatus());
                        },
                        child: Opacity(
                          opacity:
                              _deviceInfoController.isBluetooth.value ? 0.4 : 1,
                          child: Container(
                            height: 112.h,
                            width: 318.w,
                            padding: EdgeInsets.fromLTRB(38.w, 0.w, 38.w, 0.w),
                            decoration: cardStyle(context),
                            child: Row(
                              children: [
                                Image.asset(
                                  'public/images/icon/ProgramUpgrade.png',
                                  width: 64.w,
                                ),
                                SizedBox(
                                  width: 33.w,
                                ),
                                Expanded(
                                    child: Text(
                                  'programUpgrade',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: funName(context),
                                ).tr())
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ));
  }
}
