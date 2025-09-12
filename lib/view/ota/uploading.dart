import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/cloud/projectManage/ibutler/ibutler.dart';
import 'package:fluoroscopy_tool/view/ota/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'publicFunction.dart';

class uploading extends StatefulWidget {
  int? updataType;
  uploading({super.key, this.updataType});

  @override
  State<uploading> createState() => _copybasepageState();
}

class _copybasepageState extends State<uploading> {
  List upling = [];
  int status = 0;
  late Timer _timer;
  bool isuploading = true;
  // FirmwareUpgradeStageEnum.DEVICE_OFF

  static const _selfplatform =
      MethodChannel('samples.flutter.dev/MbtBasicOtaHandler');

  _refresh() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _getEntity();
    });
  }

  final otaController _selfController = Get.put(otaController());
  _reload() async {
    EasyLoading.show(status: tr("startUpgrade"));
    var startUpgrade =
        await _selfplatform.invokeMethod('startUpgrade', <String, dynamic>{
      "deviceType": _selfController.selectType.value,
      "addressList": _selfController.selectID.value,
      "upgradeTypeEnum": widget.updataType
    });
    var startUpgrade_data = jsonDecode(startUpgrade);
    if (startUpgrade_data["success"]) {
      setState(() {
        status = 0;
      });
      EasyLoading.dismiss();
      _init();
    } else {
      EasyLoading.dismiss();
      EasyLoading.showError(startUpgrade_data["errorMsg"]);
    }
  }

  bool isupgradeStatus = false;
  _handleval(val) async {
    if (!isuploading) {
      return;
    }
    var data = jsonDecode(val);
    if (data["success"]) {
      upling = data["data"];
      // upling[0]["operation"];
      print(
          "__________________ taskStatus: ${upling[0]["taskStatus"]} __________________   __________________________   upgradeStatus :${upling[0]["upgradeStatus"]}");
      if (upling.isEmpty) {
        if (_timer.isActive) {
          try {
            _timer.cancel();
          } catch (e) {}
        }
        if (widget.updataType == null) {
          Get.back();
        }
        bool issend = await divConfirmDialog(context,
            confirmTitle: tr("device.controltDialog.confirmTitle"),
            confirmDescriptionWidget: SingleChildScrollView(
                child: SizedBox(
              width: 560.w,
              height: 140,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('ota.error').tr(),
                  ],
                ),
              ),
            )));
        if (issend) {
          _reload();
        } else {
          // Get.back();
          setState(() {
            status = 1;
          });
        }
        return;
      }
      if (upling.every((element) =>
          element["taskStatus"] == "FirmwareUpgradeTaskStatus_2")) {
        /**
       *
       *  FirmwareUpgradeStatus_0("FirmwareUpgradeStatus_0", 0, "升级成功"),
          FirmwareUpgradeStatus_1("FirmwareUpgradeStatus_1", 1, "升级失败"),
          FirmwareUpgradeStatus_2("FirmwareUpgradeStatus_2", 2, "升级进行中"),
          FirmwareUpgradeStatus_3("FirmwareUpgradeStatus_3", 3, "空闲");
       */
        if (upling.isNotEmpty &&
            upling.every((element) =>
                element["taskStatus"] == "FirmwareUpgradeTaskStatus_2" &&
                (element["upgradeStatus"] == 2 ||
                    element["upgradeStatus"] == 3))) {
          print("传输结束，正在更新");
          setState(() {
            isupgradeStatus = true;
          });
        }
        if (upling.isNotEmpty &&
            upling.every((element) =>
                element["taskStatus"] == "FirmwareUpgradeTaskStatus_2" &&
                (element["upgradeStatus"] == 0 ||
                    element["upgradeStatus"] == 1))) {
          print("传输结束，更新结束");
          try {
            _timer.cancel();
          } catch (e) {}
          Future.delayed(const Duration(seconds: 3), () {
            Get.off(() => otaResult(
                  data: null,
                ));
          });
        }
      }
      setState(() {
        upling;
      });
    }
  }

  _getEntity() {
    // FirmwareUpgradeTaskStatus_0("FirmwareUpgradeTaskStatus_0", 0, "未传输"),
    // FirmwareUpgradeTaskStatus_1("FirmwareUpgradeTaskStatus_1", 1, "正在传输"),
    // FirmwareUpgradeTaskStatus_2("FirmwareUpgradeTaskStatus_2", 2, "已完成传输"),
    // FirmwareUpgradeTaskStatus_3("FirmwareUpgradeTaskStatus_3", 3, "传输失败"),
    // FirmwareUpgradeTaskStatus_4("FirmwareUpgradeTaskStatus_4", 4, "取消传输");
    _selfplatform.invokeMethod(
        'getEntity', <String, dynamic>{}).then((value) => _handleval(value));
  }

  _init() {
    _getEntity();
    _refresh();
  }

  _interruptUpgrade() async {
    EasyLoading.dismiss();
    bool issend = await divConfirmDialog(context,
        confirmTitle: tr("device.controltDialog.confirmTitle"),
        confirmDescriptionWidget: SingleChildScrollView(
            child: SizedBox(
          width: 560.w,
          height: 140,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('stopOTA.tip').tr(),
              ],
            ),
          ),
        )));
    if (issend) {
      var listFirmwares = await _selfplatform
          .invokeMethod('interruptUpgrade', <String, dynamic>{});
      var data = jsonDecode(listFirmwares);
      if (!data["success"]) {
        EasyLoading.dismiss();
        EasyLoading.showError(data["errorMsg"]);
        return;
      } else {
        EasyLoading.dismiss();
        EasyLoading.showSuccess(tr("stopOTA.success"));
        isuploading = false;
        _timer.cancel();
        Future.delayed(const Duration(seconds: 3), () {
          Get.off(() => otaResult());
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer.isActive) {
      try {
        _timer.cancel();
      } catch (e) {}
    }
    EasyLoading.dismiss();
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
            'ota.title',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [],
        ),
        body: Container(
            width: 720.w,
            height: 1280.h,
            color: const Color.fromRGBO(255, 255, 255, 1),
            padding: EdgeInsets.fromLTRB(16, 25, 16, 0.h),
            child: Column(
              children: [
                InkWell(
                    onTap: () {
                      if (status == 1) {
                        _reload();
                      }
                    },
                    child: Container(
                      width: 720.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: status == 0
                            ? [
                                Image.asset(
                                  'public/images/waterPump/loading.gif',
                                  width: 140,
                                ),
                                Text(
                                  isupgradeStatus
                                      ? tr("ota.list.uptip3")
                                      : tr("ota.list.uptip1"),
                                  style: titleText(),
                                ),
                                Text(
                                  isupgradeStatus
                                      ? tr("ota.list.uptip4")
                                      : tr("ota.list.uptip2"),
                                  textAlign: TextAlign.center,
                                  style: normalText(),
                                ),
                              ]
                            : [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Image.asset(
                                    'public/images/ota/empty.png',
                                    width: 114,
                                  ),
                                ),
                                Text(
                                  "OTA.restart",
                                  style: titleText(),
                                ).tr()
                              ],
                      ),
                    )),
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20), // 圆角
                          border: Border.all(
                              color: const Color.fromRGBO(223, 223, 223, 1),
                              width: 0.5 // 边框宽度
                              ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: ListView.builder(
                              itemCount: upling.length + 1,
                              itemBuilder: ((context, index) {
                                if (index == 0) {
                                  return Container(
                                    padding: const EdgeInsets.all(0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(0), // 圆角
                                            border: Border.all(
                                                color: const Color.fromRGBO(
                                                    223, 223, 223, 1),
                                                width: 0.5 // 边框宽度
                                                ),
                                          ),
                                          child: Center(
                                              child: const Text("ota.table1")
                                                  .tr()),
                                        ),
                                        Expanded(
                                            child: Container(
                                          height: 40,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(0), // 圆角
                                            border: Border.all(
                                                color: const Color.fromRGBO(
                                                    223, 223, 223, 1),
                                                width: 0.5 // 边框宽度
                                                ),
                                          ),
                                          child: Center(
                                              child: const Text("ota.table2")
                                                  .tr()),
                                        )),
                                        Container(
                                          width: 100,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(0), // 圆角
                                            border: Border.all(
                                                color: const Color.fromRGBO(
                                                    223, 223, 223, 1),
                                                width: 0.5 // 边框宽度
                                                ),
                                          ),
                                          child: Center(
                                            child:
                                                const Text("ota.table3").tr(),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                                return Container(
                                  padding: const EdgeInsets.all(0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(0), // 圆角
                                          border: Border.all(
                                              color: const Color.fromRGBO(
                                                  223, 223, 223, 1),
                                              width: 0.5 // 边框宽度
                                              ),
                                        ),
                                        child: Center(
                                          child: Text(
                                              "${_selfController.selectType.value == 0 ? "ODU-" : "IDU-"}${upling[index - 1]["address"]}#"),
                                        ),
                                      ),
                                      Expanded(
                                          child: Container(
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(0), // 圆角
                                          border: Border.all(
                                              color: const Color.fromRGBO(
                                                  223, 223, 223, 1),
                                              width: 0.5 // 边框宽度
                                              ),
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                  margin:
                                                      const EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8), // 圆角
                                                    border: Border.all(
                                                        color: upling[index - 1]
                                                                        [
                                                                        "upgradeStatus"] ==
                                                                    1 ||
                                                                upling[index -
                                                                            1][
                                                                        "taskStatus"] ==
                                                                    "FirmwareUpgradeTaskStatus_3"
                                                            ? Colors.red
                                                            : const Color
                                                                    .fromRGBO(
                                                                25, 98, 255, 1),
                                                        width: 1 // 边框宽度
                                                        ),
                                                  ),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child:
                                                          LinearProgressIndicator(
                                                        color: upling[index - 1]
                                                                        [
                                                                        "upgradeStatus"] ==
                                                                    1 ||
                                                                upling[index -
                                                                            1][
                                                                        "taskStatus"] ==
                                                                    "FirmwareUpgradeTaskStatus_3"
                                                            ? Colors.red
                                                            : const Color
                                                                    .fromRGBO(
                                                                25, 98, 255, 1),
                                                        backgroundColor:
                                                            Colors.white,
                                                        value: double.parse(upling[
                                                                        index -
                                                                            1][
                                                                    "sendPercent"] !=
                                                                null
                                                            ? (upling[index - 1]
                                                                        [
                                                                        "sendPercent"] *
                                                                    0.01)
                                                                .toString()
                                                            : "0"),
                                                        minHeight: 6.0,
                                                      ))),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    upling[index - 1][
                                                                "sendPercent"] !=
                                                            null
                                                        ? "${double.parse((upling[index - 1]["sendPercent"]).toString()).toStringAsFixed(2)}%"
                                                        : "--",
                                                    style: const TextStyle(
                                                        fontSize: 10),
                                                  ),
                                                  // const Text("100%",
                                                  //     style: TextStyle(
                                                  //         fontSize: 10))
                                                  Text(
                                                          upling[index - 1][
                                                              "firmwareUpgradeStage"],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 10))
                                                      .tr()
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      )),
                                      Container(
                                        width: 100,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(0), // 圆角
                                          border: Border.all(
                                              color: const Color.fromRGBO(
                                                  223, 223, 223, 1),
                                              width: 0.5 // 边框宽度
                                              ),
                                        ),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: upling[index - 1]
                                                            ["taskStatus"] !=
                                                        "FirmwareUpgradeTaskStatus_2"
                                                    ? Text(
                                                        "${upling[index - 1]["taskStatus"]}",
                                                        style: TextStyle(
                                                            color: upling[index -
                                                                            1][
                                                                        "taskStatus"] ==
                                                                    "FirmwareUpgradeTaskStatus_3"
                                                                ? Colors.red
                                                                : Colors.black),
                                                      ).tr()
                                                    : Text(
                                                        "FirmwareUpgradeStatus_${upling[index - 1]["upgradeStatus"]}",
                                                        style: TextStyle(
                                                            color: upling[index -
                                                                            1][
                                                                        "upgradeStatus"] ==
                                                                    1
                                                                ? Colors.red
                                                                : Colors.black),
                                                      ).tr(),
                                              ),
                                              // Text(
                                              //     "operation: ${upling[index - 1]["operation"] ?? "--"}"),
                                              TooltipOnClick(
                                                  msg:
                                                      "${upling[index - 1]["operation"] ?? "--"}")
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              })),
                        ))),
                Container(
                  height: 57,
                  padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                  child: Center(
                    child: submitButton(
                      isActive: true,
                      label: tr('ota.list.btn1'),
                      onClick: () async {
                        _interruptUpgrade();
                      },
                    ),
                  ),
                )
              ],
            )));
  }
}
