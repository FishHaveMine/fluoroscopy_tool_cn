import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/protocoldetection/welcomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'emptyResult.dart';
import 'resultTap.dart';

class protocolSearchPage extends StatefulWidget {
  bool isnullresult = false;
  protocolSearchPage({super.key, this.isnullresult = false});

  @override
  State<protocolSearchPage> createState() => _copybasepageState();
}

class _copybasepageState extends State<protocolSearchPage> {
  static const platform =
      MethodChannel('samples.flutter.dev/ProtocolCheckService');
  int _remainingSeconds = 30; //超时时间
  late Timer _timer;
  bool isSuccess = true;
  bool isstop = false;
  init() async {
    try {
      var checkback = await platform.invokeMethod('check');
      var back = jsonDecode(checkback);
      print(
          "ProtocolCheck checkback:  ${back.runtimeType}  ${back["success"]} $back");
      if (isstop) {
        return;
      }
      if (back["success"]) {
        setState(() {
          isSuccess = true;
        });
        Get.to(() => resultTapPage());
      } else {
        // EasyLoading.showError(back["errorMsg"]);
        setState(() {
          isSuccess = false;
        });
        Future.delayed(const Duration(seconds: 1), () {
          Get.to(() => emptyResultPage());
        });
      }
    } catch (e) {
      setState(() {
        isSuccess = false;
      });
    }
  }

  stopcheck() async {
    isstop = true;
    try {
      var checkback = await platform.invokeMethod('setStop');
      var back = jsonDecode(checkback);

      print(
          "ProtocolCheck stopcheck:  ${back.runtimeType}  ${back["success"]} $back");

      Get.off(() => protocolwelcomePage()); //
      // if (back["data"]) {
      //   Get.offAllNamed('/home'); //
      // } else {
      //   EasyLoading.showError(back["errormsg"]);
      // }
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    if (!widget.isnullresult) {
      init();
    } else {
      Future.delayed(const Duration(seconds: 5), () {
        Get.to(() => resultTapPage());
      });
    }
  }

  Future<bool> _onWillPop() async {
    Get.off(() => protocolwelcomePage()); //
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {
                    Get.off(() => protocolwelcomePage()); //
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
              color: const Color.fromRGBO(244, 244, 244, 1),
              padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
              child: Column(
                children: [
                  Expanded(
                      child: baseContainer(
                          child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'public/images/waterPump/loading.gif',
                        width: 280,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 40.h, 0, 16.h),
                        child: Text(
                          tr('protocoldetection.searching', namedArgs: {}),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18,
                              color: Color.fromRGBO(13, 13, 13, 1),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ))),
                  if (!widget.isnullresult)
                    Container(
                      height: 57,
                      padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                      child: Center(
                        child: submitButton(
                          isActive: true,
                          label: tr('protocoldetection.endsearch'),
                          onClick: () async {
                            bool isSend = await divConfirmDialog(context,
                                confirmTitle:
                                    tr("device.controltDialog.confirmTitle"),
                                cancelText:
                                    tr("protocoldetection.endsearch.sure"),
                                confirmText:
                                    tr("protocoldetection.endsearch.cancel"),
                                confirmDescriptionWidget: SingleChildScrollView(
                                  child: SizedBox(
                                      width: 560.w,
                                      height: 96.h,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 16),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              tr('protocoldetection.endsearch.tip',
                                                  namedArgs: {}),
                                              style: normalText(),
                                            ),
                                          ],
                                        ),
                                      )),
                                ));
                            if (isSend != null &&
                                isSend.toString() == "false") {
                              stopcheck();
                            } else if (isSend != null &&
                                isSend.toString() == "true") {}
                          },
                        ),
                      ),
                    )
                ],
              ),
            )));
  }
}
