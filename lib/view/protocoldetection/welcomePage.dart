import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:fluoroscopy_tool/view/protocoldetection/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

class protocolwelcomePage extends StatefulWidget {
  bool isnullresult = false;
  protocolwelcomePage({super.key, this.isnullresult = false});

  @override
  State<protocolwelcomePage> createState() => _copybasepageState();
}

class _copybasepageState extends State<protocolwelcomePage> {
  final deviceInfoController _deviceInfoController = Get.find();
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
                Get.offAllNamed('/home'); //
              },
              icon: const Icon(Icons.chevron_left,
                  color: Colors.black, size: 36)),
          title: const Text(
            'protocoldetection.title',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [],
        ),
        body: Container(
          width: 720.w,
          height: 1280.h,
          color: const Color.fromRGBO(255, 255, 255, 1),
          margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
          padding: EdgeInsets.fromLTRB(0.w, 16.h, 0.w, 0.h),
          child: Column(
            children: [
              Expanded(
                  child: baseContainer(
                      child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'public/images/protocoldetection/unknown.png',
                      width: 200,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 40.h, 0, 0.h),
                    child: Text(
                      tr('protocoldetection.protocolwelcomePage.tip1',
                          namedArgs: {}),
                      style: titleText(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0.h, 0, 0.h),
                    child: Text(
                      tr('protocoldetection.protocolwelcomePage.tip2',
                          namedArgs: {}),
                      style: normalTextBlack(),
                    ),
                  ),
                ],
              ))),
              Container(
                height: 57,
                padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                child: Center(
                  child: submitButton(
                    isActive:
                        _deviceInfoController.loacalDevice.value.isconnected &&
                            (_deviceInfoController.loacalDevice.value.model ==
                                    'V8' ||
                                _deviceInfoController
                                        .loacalDevice.value.model ==
                                    'V6' ||
                                _deviceInfoController
                                        .loacalDevice.value.model ==
                                    'V4+' ||
                                _deviceInfoController
                                        .loacalDevice.value.model ==
                                    'V4Plus'),
                    label: tr('protocoldetection.protocolwelcomePage.btn'),
                    onClick: () async {
                      if (_deviceInfoController
                              .loacalDevice.value.isconnected &&
                          (_deviceInfoController.loacalDevice.value.model ==
                                  'V8' ||
                              _deviceInfoController.loacalDevice.value.model ==
                                  'V6' ||
                              _deviceInfoController.loacalDevice.value.model ==
                                  'V4+' ||
                              _deviceInfoController.loacalDevice.value.model ==
                                  'V4Plus')) {
                        Get.to(() => protocolSearchPage());
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
