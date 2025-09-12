import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../index.dart';

class aicheckResult extends StatefulWidget {
  String result;
  aicheckResult({super.key, required this.result});

  @override
  State<aicheckResult> createState() => _copybasepageState();
}

class _copybasepageState extends State<aicheckResult> {
  int status = 1;

  String imagkey = "more";

  @override
  void initState() {
    super.initState();
    setState(() {
      status = ["MORE", "COMMON", "LESS", "INTERRUPT"].indexOf(widget.result);
      imagkey = widget.result == "MORE"
          ? "more"
          : widget.result == "COMMON"
              ? "normal"
              : widget.result == "LESS"
                  ? "less"
                  : "empty";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Get.offAll(() => refrigerantTable());
              },
              icon: const Icon(Icons.chevron_left,
                  color: Colors.black, size: 36)),
          title: const Text(
            'refrigerant.aicheck',
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 24.h, 0, 0.h),
                    child: Image.asset(
                      'public/images/refrigerant/${imagkey}.png',
                      width: 270.w,
                    ),
                  ),
                  if (imagkey != "empty")
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 130.h, 0, 20.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text.rich(TextSpan(
                              style: normalTextBlack(
                                  fSize: 18, fw: FontWeight.w800),
                              text: tr("refrigerant.aicheck.finish"),
                            )),
                            if (status != 4)
                              Image.asset(
                                'public/images/refrigerant/${status}.png',
                                width: 48.w,
                              )
                          ],
                        )),
                  Padding(
                      padding: EdgeInsets.fromLTRB(24, 0.h, 24, 20.h),
                      child: Text(
                        tr("refrigerant.aicheck.finish.${imagkey}"),
                        textAlign: TextAlign.center,
                        style: imagkey != "empty"
                            ? normalText()
                            : normalTextBlack(fSize: 18, fw: FontWeight.w800),
                      )),
                  if (imagkey == "empty")
                    Padding(
                        padding: EdgeInsets.fromLTRB(24, 0.h, 24, 20.h),
                        child: Text(
                          tr("refrigerant.aicheck.finish.${imagkey}.tip"),
                          textAlign: TextAlign.center,
                          style: normalText(),
                        )),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 64.h, 0, 0.h),
                    width: 208.w,
                    height: 36,
                    child: normalButton(
                        label: tr("refrigerant.aicheck.finish.${imagkey}.btn"),
                        onClick: () {
                          if (imagkey != "less") {
                            Get.offAll(() => refrigerantTable());
                          }
                        }),
                  )
                ],
              )),
            ],
          ),
        ));
  }
}
