import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/snInput.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/afterSalesReplacement/publicFunction.dart';
import 'package:fluoroscopy_tool/view/afterSalesReplacement/style.dart';
import 'package:fluoroscopy_tool/view/cloud/device/style.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import '../afterSalesReplacement/connectStep2.dart';
import 'deviceUnlock.dart';
import 'historyList.dart';
import 'unlock.dart';
import 'writeSn.dart';

class deviceUnlockWelcomePage extends StatefulWidget {
  const deviceUnlockWelcomePage({super.key});
  @override
  State<deviceUnlockWelcomePage> createState() => _deviceUnlockState();
}

class _deviceUnlockState extends State<deviceUnlockWelcomePage> {
  static const platform = MethodChannel('samples.flutter.dev/battery');
  static const _snplatform =
      MethodChannel('samples.flutter.dev/writeSnService');
  final afterSalesReplacementController _selfController = Get.find();
  final deviceInfoController _deviceInfoController = Get.find();

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
                'deviceUnlock.title',
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
                        'deviceUnlock.unlockhistory',
                        style: actionsTextButtonStyle(),
                      ).tr()),
                )
              ],
            ),
            body: Stack(children: [
              Container(
                color: const Color.fromRGBO(245, 245, 245, 1),
                padding: const EdgeInsets.all(16),
                child: ListView.builder(
                    itemCount: 4,
                    itemBuilder: ((context, index) {
                      return index == 3
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                tr("deviceUnlock.welcomePage.tip1"),
                                style: normalText(),
                              ),
                            )
                          : InkWell(
                              onTap: () async {
                                if (index > 0) {
                                  EasyLoading.showError("功能暂未开放");
                                  return;
                                }
                                bool issend = await divConfirmOnlyDialog(
                                    context,
                                    confirmText: _deviceInfoController
                                            .loacalDevice.value.isconnected
                                        ? tr('deviceUnlock.enter')
                                        : tr('deviceUnlock.connecd'),
                                    confirmTitle: tr("deviceUnlock"),
                                    isSubmitButton: true,
                                    confirmDescriptionWidget: SizedBox(
                                      width: 560.w,
                                      height: 416.h,
                                      child: SingleChildScrollView(
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
                                                'deviceUnlock.tip2',
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
                                              Text(
                                                'deviceUnlock.tip4',
                                                style: titleStyleS(),
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
                                    _selfController
                                        .setConnectType(connectType[0]);
                                    Get.to(() => connectStep2Page(
                                          title: tr('deviceUnlock'),
                                          nextPage: const deviceUnlock(),
                                        ));
                                  } else {
                                    Get.to(() => const deviceUnlock());
                                  }
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                                padding: EdgeInsets.all(16),
                                decoration: cardStyleFull(context),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: Image.asset(
                                        'public/images/deviceUnlock/type${index + 1}.png',
                                        height: 136.h,
                                      ),
                                    ),
                                    Text(
                                      tr("deviceUnlock.welcomePage.type${index + 1}") +
                                          "${index > 0 ? "(暂未开放)" : ""}",
                                      style: titleText(),
                                    )
                                  ],
                                ),
                              ),
                            );
                    })),
              ),
              Positioned(
                bottom: 150.h, // 距离底部的距离
                right: 0.0, // 距离右侧的距离
                child: InkWell(
                  onTap: () async {
                    if (!_deviceInfoController.loacalDevice.value.isconnected) {
                      _selfController.setConnectType(connectType[0]);
                      Get.to(() => connectStep2Page(
                            title: tr('deviceUnlock'),
                            nextPage: const writeSn(),
                          ));
                    } else {
                      Get.to(() => const writeSn());
                    }
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
                          "deviceUnlock.writeSn",
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
