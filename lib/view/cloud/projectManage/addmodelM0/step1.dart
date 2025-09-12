import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/snInput.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/color.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/cloud/projectManage/addmodelM0/step2.dart';
import 'package:fluoroscopy_tool/view/systemCapabilityAnalysis/step2/systemDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'publicFunction.dart';

class addmodelM0 extends StatefulWidget {
  String projectCode;
  addmodelM0({super.key, required this.projectCode});

  @override
  State<addmodelM0> createState() => _addmodelM0State();
}

class _addmodelM0State extends State<addmodelM0> {
  final MOaddController _selectController = Get.put(MOaddController());
  static const _selfplatform =
      MethodChannel('samples.flutter.dev/getProjectHandler');
  static const platform = MethodChannel('samples.flutter.dev/battery');
  String sn = '';
  openscan() async {
    try {
      await platform.invokeMethod('SCANNER_TRIG');
    } on PlatformException catch (e) {
      print("Failed to SCANNER_TRIG: '${e.message}'.");
    }
  }

  moduleCheck() async {
    // Get.to(() => addmodelM0_step2());
    // return;
    EasyLoading.show(status: 'loading...');
    try {
      var historyback = await _selfplatform
          .invokeMethod('getAppFluorineMachineEnergyHandler.moduleCheck', {
        "sn": sn,
      });

      var historydata = jsonDecode(historyback);
      print(historydata);
      EasyLoading.dismiss();
      if (!historydata['success']) {
        EasyLoading.showError(historydata['errorMsg']);
        return;
      } else {
        List datakey = historydata["data"].keys.toList();
        String moduleType = "";
        for (var element in datakey) {
          if (historydata["data"][element] == sn) {
            moduleType = element;
          }
        }
        final prefs = await SharedPreferences.getInstance();
        _selectController.updatePropertyName("moduleSn", sn);
        _selectController.updatePropertyName("moduleType", moduleType);
        _selectController.updatePropertyName("projectCode", widget.projectCode);
        _selectController.updatePropertyName(
            "uploadLocation", prefs.getString("location"));

        Get.to(() => addmodelM0_step2());
      }
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
      EasyLoading.showError("$e");
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _selectController.clearDefaultValues();
      _selectController.cleanimgaeList();
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
            'MOadd.step1.title',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [],
        ),
        body: Container(
          width: 720.w,
          height: 1280.h,
          color: const Color.fromRGBO(244, 244, 244, 1),
          padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
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
                            Row(
                              children: [
                                Text(
                                  '*',
                                  style: normalTextBlack(fontcolor: Colors.red),
                                ).tr(),
                                Text(
                                  'MOadd.step1.tip',
                                  style: normalTextBlack(),
                                ).tr(),
                              ],
                            ),
                            Stack(
                              children: [
                                Positioned(
                                    child: Container(
                                  margin: const EdgeInsets.fromLTRB(0, 9, 0, 0),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(42),
                                      color: snInputColors),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          openscan();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 0),
                                          child: Image.asset(
                                            'public/images/waterPump/scran.png',
                                            width: 40.w,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: snInput(
                                          valBack: (back) {
                                            setState(() {
                                              sn = back;
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                              ],
                            )
                          ],
                        )),
                  ),
                ],
              ))),
              Container(
                height: 57,
                padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                child: Center(
                  child: submitButton(
                    isActive: sn != "",
                    label: tr('MOadd.step1.btn'),
                    onClick: () async {
                      if (sn != "") moduleCheck();
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
