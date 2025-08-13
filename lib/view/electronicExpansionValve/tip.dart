import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/electronicExpansionValve/index.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:fluoroscopy_tool/view/systemCapabilityAnalysis/step2/systemDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class electronicExpansionValveTip extends StatefulWidget {
  electronicExpansionValveTip({super.key});

  @override
  State<electronicExpansionValveTip> createState() => _copybasepageState();
}

class _copybasepageState extends State<electronicExpansionValveTip> {
  @override
  void initState() {
    super.initState();
  }

  final deviceInfoController _deviceInfoController = Get.find();
  bool isAgree = false;

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
          title: Text(
            'electronicExpansionValve.title',
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 24, 0, 24),
                        child: Text(tr('electronicexpansionTip'),
                            style: normalTextBlack())),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Center(
                        child: Image.asset(
                          'public/images/communication/electronicExpansionValvetip.png',
                          width: 600.w,
                        ),
                      ),
                    ),
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
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 72.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RoundCheckBox(
                              isChecked: isAgree,
                              onTap: (selected) {
                                setState(() {
                                  isAgree = selected == true;
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
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                              child:
                                  Text('afterSalesReplacement.connectStepTap')
                                      .tr(),
                            ),
                          ],
                        ),
                      )),
                  Container(
                    height: 57,
                    padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                    child: Center(
                      child: submitButton(
                        isActive: isAgree &&
                            !_deviceInfoController
                                .loacalDevice.value.isconnected,
                        label: tr('Instructionspage.next'),
                        onClick: () async {
                          if (isAgree &&
                              !_deviceInfoController
                                  .loacalDevice.value.isconnected) {
                            Get.to(() => electronicExpansionValve());
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
