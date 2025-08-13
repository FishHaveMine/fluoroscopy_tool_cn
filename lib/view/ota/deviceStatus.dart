import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/ota/uploading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'history.dart';
import 'index.dart';
import 'publicFunction.dart';

class otaDeviceStatus extends StatefulWidget {
  otaDeviceStatus({super.key});

  @override
  State<otaDeviceStatus> createState() => _copybasepageState();
}

class _copybasepageState extends State<otaDeviceStatus> {
  int status = 0; //0:空闲   1:更新中

  final otaController _selfController = Get.put(otaController());
  static const _selfplatform =
      MethodChannel('samples.flutter.dev/MbtBasicOtaHandler');
  _init() async {
    try {
      EasyLoading.show(status: 'loading...');
      var firmwareDownloadUrl =
          await _selfplatform.invokeMethod('getEntity', <String, dynamic>{});
      var data = jsonDecode(firmwareDownloadUrl);
      print("getEntity: $data");
      if (data["data"].isNotEmpty) {
        EasyLoading.dismiss();
        var upling = data["data"];
        if (upling.every((element) => element["upgradeStatus"] == 2)) {
          Get.off(() => uploading());
        }
      }
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  _interruptUpgrade() async {
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
              )),
        ));
    if (issend) {
      var listFirmwares = await _selfplatform
          .invokeMethod('interruptUpgrade', <String, dynamic>{});
      var data = jsonDecode(listFirmwares);
      if (!data["success"]) {
        EasyLoading.showError(data["errorMsg"]);
        return;
      } else {
        EasyLoading.showSuccess(tr("stopOTA.success"));
        setState(() {
          status = 0;
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
                'ota.title',
                style: TextStyle(color: Colors.black),
              ).tr(),
              centerTitle: true,
              actions: [
                TextButton(
                    onPressed: () {
                      Get.to(() => otaHistory());
                    },
                    child: const Text("ota.history.title").tr())
              ],
            ),
            body: Container(
                width: 720.w,
                height: 1280.h,
                color: const Color.fromRGBO(255, 255, 255, 1),
                padding: EdgeInsets.fromLTRB(16, 25, 16, 0.h),
                child: Column(
                  children: [
                    if (status == 0)
                      Expanded(
                          child: Image.asset(
                        'public/images/ota/empty.png',
                        width: 720.w,
                      )),
                    if (status == 1)
                      Expanded(
                          child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'public/images/waterPump/loading.gif',
                              width: 200,
                            ),
                            Text(
                              tr("ota.list.updateing"),
                              style: titleText(),
                            ),
                            Text(
                              tr("ota.list.updateing.tip"),
                              style: normalText(),
                            ),
                          ],
                        ),
                      )),
                    Container(
                      height: 57,
                      padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                      child: Center(
                        child: submitButton(
                          isActive: true,
                          label: status == 0
                              ? tr('ota.list.btn')
                              : tr('ota.list.btn1'),
                          onClick: () async {
                            if (status == 0) {
                              Get.to(() => otaIndex());
                            } else {
                              _interruptUpgrade();
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ))));
  }
}
