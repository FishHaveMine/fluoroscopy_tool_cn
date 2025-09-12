import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/snInput.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/compent/textinput.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/cloud/projectCreate/oldProject/step1.dart';
import 'package:fluoroscopy_tool/view/cloud/projectManage/deviceManage.dart';
import 'package:fluoroscopy_tool/view/cloud/projectManage/ibutler/ibutler.dart';
import 'package:fluoroscopy_tool/view/systemCapabilityAnalysis/step2/systemDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import 'publicFunction.dart';

class addmodelM0_step4 extends StatefulWidget {
  addmodelM0_step4({super.key});

  @override
  State<addmodelM0_step4> createState() => _addmodelM0_step4State();
}

class _addmodelM0_step4State extends State<addmodelM0_step4> {
  final MOaddController _selectController = Get.put(MOaddController());
  static const _selfplatform =
      MethodChannel('samples.flutter.dev/getProjectHandler');

  @override
  void initState() {
    super.initState();
  }

  String systemName = "";
  String waterHardness = "";
  String pieces = "";

  final debouncer = Debouncer(milliseconds: 1000);

  void onSearchChanged() {
    debouncer.run(() {
      _toadd();
      // 调用你的搜索 API 或更新状态
    });
  }

  _toadd() async {
    // 创建主 JSON 对象
    Map<String, dynamic> jsonObject = {
      "deviceType": _selectController.jsonObject["deviceType"],
      "modifyType": _selectController.jsonObject["modifyType"]
          .toString()
          .replaceAll("modifyType", ""),
      "series": _selectController.jsonObject["series"],
      "systemName": systemName,
      "eauxiliaryHeat": "1",
      "projectCode": _selectController.jsonObject["projectCode"],
      "waterHardness": waterHardness,
      "uploadLocation": _selectController.jsonObject["uploadLocation"],
      "moduleInfos": [] // 初始化为一个空列表
    };

    // 创建 moduleInfos 对象
    Map<String, dynamic> moduleInfos = {
      "moduleSn": _selectController.jsonObject["moduleSn"],
      "moduleType": _selectController.jsonObject["moduleType"],
      "pieces": pieces,
      "cloudConnectionBoxImg": _selectController.imgaeList["type1"],
      "sprayDeviceInstallImg": _selectController.imgaeList["type2"],
      "powerPositionImg": _selectController.imgaeList["type3"],
      "waterTreatmentDeviceImg": _selectController.imgaeList["type4"],
      "otherImg": _selectController.imgaeList["type5"],
      "oldReformImgDataCompleteness": "ALL"
    };

    // 将 moduleInfos 添加到 moduleInfos 列表
    // jsonObject["moduleInfos"].add(moduleInfos);

    // 转换为 JSON 字符串以供使用
    // String jsonString = jsonEncode(jsonObject);
    EasyLoading.show(status: 'loading...');
    try {
      var historyback = await _selfplatform
          .invokeMethod('getAppFluorineMachineEnergyHandler.addEnergySys', {
        "jsonObject": jsonObject,
        "moduleInfos": moduleInfos,
      });

      var historydata = jsonDecode(historyback);
      print(historyback);
      if (historydata["errorCode"] != null &&
          historydata["errorCode"].toString() == "1001") {
        //登录失效
        tologout();
      }
      if (!historydata["success"]) {
        EasyLoading.showError(historydata['errorMsg']);
      } else {
        EasyLoading.showSuccess(tr('MOadd.step4.success'));
        Future.delayed(const Duration(seconds: 2), () {
          Get.offUntil(
            MaterialPageRoute(
              builder: (context) => deviceManage(),
            ),
            (route) =>
                route.settings.name == '/home' ||
                route.settings.name == '/projectDetail',
          );
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MOaddController>(
        init: MOaddController(),
        builder: (_) => Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.chevron_left,
                      color: Colors.black, size: 36)),
              title: const Text(
                'MOadd.step4.title',
                style: TextStyle(color: Colors.black),
              ).tr(),
              centerTitle: true,
              actions: [],
            ),
            body: Container(
              width: 720.w,
              height: 1280.h,
              color: const Color.fromRGBO(255, 255, 255, 1),
              padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
              child: Column(
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      Container(
                          padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 4.h),
                          decoration: BoxDecoration(
                            color: Colors.white, // 背景色
                            border: Border.all(
                              color: const Color(0xFFDFDFDF), // 边框颜色
                              width: 0.5, // 边框宽度
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              infolabe(
                                  name: tr("MOadd.step4.type1"),
                                  isrequired: true),
                              Expanded(
                                  child: textinput(
                                      textAlign:
                                          TextAlign.right, // 或者使用 TextAlign.end
                                      maxLines: 1, // 设置为 null 或大于 1 的数字以支持多行输入
                                      val: "",
                                      isrequired: true,
                                      onChanged: (back) {
                                        setState(() {
                                          systemName = back;
                                        });
                                      })),
                            ],
                          )),
                      Container(
                          padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 4.h),
                          decoration: BoxDecoration(
                            color: Colors.white, // 背景色
                            border: Border.all(
                              color: const Color(0xFFDFDFDF), // 边框颜色
                              width: 0.5, // 边框宽度
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              infolabe(
                                  name: tr("MOadd.step4.type2"),
                                  isrequired: true),
                              Expanded(
                                  child: textinput(
                                      keyboardType: TextInputType.number,
                                      textAlign:
                                          TextAlign.right, // 或者使用 TextAlign.end
                                      maxLines: 1, // 设置为 null 或大于 1 的数字以支持多行输入
                                      val: "",
                                      isrequired: true,
                                      onChanged: (back) {
                                        setState(() {
                                          waterHardness = back;
                                        });
                                      })),
                            ],
                          )),
                      Container(
                          padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 4.h),
                          decoration: BoxDecoration(
                            color: Colors.white, // 背景色
                            border: Border.all(
                              color: const Color(0xFFDFDFDF), // 边框颜色
                              width: 0.5, // 边框宽度
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              infolabe(
                                  name: tr("MOadd.step4.type3"),
                                  isrequired: true),
                              Expanded(
                                  child: textinput(
                                      keyboardType: TextInputType.number,
                                      textAlign:
                                          TextAlign.right, // 或者使用 TextAlign.end
                                      maxLines: 1, // 设置为 null 或大于 1 的数字以支持多行输入
                                      val: "",
                                      isrequired: true,
                                      onChanged: (back) {
                                        setState(() {
                                          pieces = back;
                                        });
                                      })),
                            ],
                          )),
                    ],
                  )),
                  Container(
                    height: 57,
                    padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                    child: Center(
                      child: submitButton(
                        isActive: systemName != "" &&
                            waterHardness != "" &&
                            pieces != "",
                        label: tr('MOadd.step2.btn'),
                        onClick: () async {
                          if (systemName != "" &&
                              waterHardness != "" &&
                              pieces != "") {
                            onSearchChanged();
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            )));
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel(); // 取消之前的定时器
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
