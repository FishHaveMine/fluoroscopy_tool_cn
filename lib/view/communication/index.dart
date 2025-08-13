import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/tapContainer.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/communication/Instructions.dart';
import 'package:fluoroscopy_tool/view/communication/sceneCheck.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'publicFunction.dart';

class communicationTypeSelectPage extends StatefulWidget {
  communicationTypeSelectPage({super.key});

  @override
  State<communicationTypeSelectPage> createState() => _emptyResultPageState();
}

class _emptyResultPageState extends State<communicationTypeSelectPage> {
  int activeIndex = 0;

  final communicationController _selfController =
      Get.put(communicationController());
  init() {}
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Get.offAllNamed('/home'); //
              },
              icon: const Icon(Icons.chevron_left,
                  color: Colors.black, size: 36)),
          title: const Text(
            'communication.title',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: const [],
        ),
        body: tapContariner(
          activechange: (val) {
            setState(() {
              activeIndex = val;
            });
          },
          activeIndex: 0,
          tap: List.generate(3,
              (index) => tr("communication.type${index + 1}", namedArgs: {})),
          child: [
            for (int i = 0; i < 3; i++)
              Container(
                padding: EdgeInsets.fromLTRB(36.w, 24.h, 36.w, 24.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "communication.typeselect.tip1",
                      style: normalTextBlack(fSize: 16),
                    ).tr(),
                    Expanded(
                      child: Text(
                        i == 0
                            ? "communication.typeselect.tip2"
                            : i == 1
                                ? "communication.typeselect.tip2_1"
                                : "communication.typeselect.tip2_2",
                        maxLines: 2,
                        style: normalTextS(fSize: 14),
                      ).tr(),
                    ),
                    Row(
                      children: [
                        Text("communication.typeselect.tip3",
                                style: normalTextBlack(fSize: 16))
                            .tr(),
                        Expanded(
                            child: Text(
                                    i == 0
                                        ? "communication.typeselect.tip4"
                                        : i == 1
                                            ? "communication.typeselect.tip4_1"
                                            : "communication.typeselect.tip4_2",
                                    maxLines: 1,
                                    style: normalTextS(fSize: 14))
                                .tr()),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        print('activeIndex : $activeIndex  $i index:1');
                        _selfController.setConnectType("$i");
                        Get.to(() => Instructionspage());
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                        child: Image.asset(
                          i == 2
                              ? 'public/images/communication/tip2.jpg'
                              : 'public/images/communication/tip1.jpg',
                          width: 720.w - 36.w * 2,
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: Row(
                          children: [
                            Text("communication.typeselect.tip5",
                                    style: normalTextBlack())
                                .tr(),
                            Expanded(
                              child: Text(
                                      i == 0
                                          ? "communication.typeselect.tip6"
                                          : "communication.typeselect.tip6_1",
                                      maxLines: 2,
                                      style: normalTextS())
                                  .tr(),
                            )
                          ],
                        )),
                    InkWell(
                        onTap: () {
                          print('activeIndex : $activeIndex  $i index:2');
                          _selfController.setConnectType("$i");
                          Get.to(() => Instructionspage());
                        },
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: Image.asset(
                              'public/images/communication/tip2.jpg',
                              width: 720.w - 36.w * 2,
                            ))),
                  ],
                ),
              )
          ],
        ));
  }
}
