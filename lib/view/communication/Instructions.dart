import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/communication/publicFunction.dart';
import 'package:fluoroscopy_tool/view/communication/sceneCheck.dart';
import 'package:fluoroscopy_tool/view/systemCapabilityAnalysis/step2/systemDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import 'checking.dart';

class Instructionspage extends StatefulWidget {
  Instructionspage({super.key});

  @override
  State<Instructionspage> createState() => _copybasepageState();
}

class _copybasepageState extends State<Instructionspage> {
  bool isAgree = false;
  final communicationController _selfController = Get.find();
  static const tipimage = [
    [
      "public/images/communication/outdoorM1M2.png",
      "public/images/communication/outdoorPQ.png",
    ],
    [
      "public/images/communication/indoorM1M2.png",
      "public/images/communication/indoorPQ.png",
    ],
    [
      "public/images/communication/systemM1M2.png",
      "public/images/communication/systemPQ.png",
    ]
  ];
  @override
  void initState() {
    super.initState();
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
          title: Text(
            tr("communication.type${(int.parse(_selfController.connectType.value) + 1).toString()}") +
                tr("communication.title "),
            style: const TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [],
        ),
        body: Container(
          width: 720.w,
          height: 1280.h,
          color: const Color.fromRGBO(255, 255, 255, 1),
          padding: EdgeInsets.fromLTRB(32.w, 0.h, 32.w, 0.h),
          child: Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _selfController.connectType.value.toString() != '0'
                        ? Text.rich(TextSpan(
                            style: normalTextBlack(),
                            text: '1、请确认内机已上电\n2、请确认当前的接线方式，具体接线要求参考以下接线方式:'))
                        : Text.rich(TextSpan(
                            style: normalTextBlack(),
                            text: tr('Instructionspage.tip1'))),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 24, 0, 24),
                        child: Text(tr('Instructionspage.tip2'),
                            style: normalTextBlack())),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Center(
                        child: Image.asset(
                          tipimage[int.parse(_selfController.connectType.value)]
                              [0],
                          width: 487.w,
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 24, 0, 24),
                        child: Text(tr('Instructionspage.tip2-1'),
                            style: normalTextBlack())),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Center(
                        child: Image.asset(
                          tipimage[int.parse(_selfController.connectType.value)]
                              [1],
                          width: 487.w,
                        ),
                      ),
                    )
                  ],
                ),
              )),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isAgree = !isAgree;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Row(
                        children: [
                          RoundCheckBox(
                            isChecked: isAgree,
                            onTap: (selected) {
                              setState(() {
                                isAgree = selected!;
                              });
                            },
                            size: 20,
                            checkedWidget: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            ),
                            checkedColor:
                                Theme.of(context).colorScheme.secondary,
                            border: Border.all(
                                // width: 1,
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(8, 0, 0, 5),
                            child: Text(
                              tr("Instructionspage.tip3"),
                              style: normalTextBlack(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 57,
                    padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                    child: Center(
                      child: submitButton(
                        isActive: isAgree,
                        label: tr('Instructionspage.next'),
                        onClick: () async {
                          if (isAgree) {
                            Get.to(() => sceneCheckPage());
                          }
                        },
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
