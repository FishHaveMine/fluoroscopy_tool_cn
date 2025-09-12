import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/refrigerant/aicheck/aicheckRunning.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class aicheck extends StatefulWidget {
  aicheck({super.key});

  @override
  State<aicheck> createState() => _copybasepageState();
}

class _copybasepageState extends State<aicheck> {
  bool isSure = false;
  static const _selfplatform =
      MethodChannel('samples.flutter.dev/RefrigerantService');

  tostart() async {
    EasyLoading.show(status: 'loading...');
    try {
      var refrigerantResult =
          await _selfplatform.invokeMethod('openCheck', <String, dynamic>{});
      print("refrigerantTable openCheck: $refrigerantResult");
      var data = jsonDecode(refrigerantResult);
      if (data["success"] && data["data"]) {
        Get.to(() => aicheckRunning());
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(data["errorMsg"]);
      }
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isCN =
        EasyLocalization.of(context)?.currentLocale!.languageCode == 'zh';
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.chevron_left,
                  color: Colors.black, size: 36)),
          title: Text(
            'refrigerant.aicheck',
            style: const TextStyle(color: Colors.black),
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 24.h, 0, 0.h),
                    child: Image.asset(
                      'public/images/refrigerant/ai.jpg',
                      width: 140,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(50.w, 130.h, 50.w, 130.h),
                      child: Text.rich(TextSpan(
                        style: normalTextBlack(fSize: 16),
                        text: tr("refrigerant.aicheck.start"),
                      ))),
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
                          checkedColor: Theme.of(context).colorScheme.secondary,
                          border: Border.all(
                              // width: 1,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 2),
                          child: Text(
                            "refrigerant.autoInputStep4",
                            maxLines: 2,
                            style: normalTextBlack(
                                fSize: isCN ? 16 : 14, fw: FontWeight.w600),
                          ).tr(),
                        )
                      ],
                    ),
                  )
                ],
              )),
              Container(
                height: 57,
                padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                child: Center(
                  child: submitButton(
                    isActive: isSure,
                    label: tr(
                      "refrigerant.aicheck.start.btn",
                    ),
                    onClick: () async {
                      if (isSure) tostart();
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
