import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/communication/publicFunction.dart';
import 'package:fluoroscopy_tool/view/systemCapabilityAnalysis/step2/systemDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'result.dart';

class checkingpage extends StatefulWidget {
  checkingpage({super.key});

  @override
  State<checkingpage> createState() => _checkingpageState();
}

class _checkingpageState extends State<checkingpage> {
  final communicationController _selfController = Get.find();

  static const platform = MethodChannel('samples.flutter.dev/battery');
  static const _snplatform =
      MethodChannel('samples.flutter.dev/CommunicationDetection');
  int _remainingSeconds = 300; //超时时间
  bool ischecking = true;
  String errorMsg = "";
  late Timer _timer;
  init() async {
    setState(() {
      _remainingSeconds = 300;
      ischecking = true;
    });
    /**
     * 定时器处理超时
     */
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
      } else {
        _timer.cancel();
      }

      // if (_remainingSeconds == 290) {
      //   Get.to(() => resultpage());
      // }
      setState(() {
        _remainingSeconds;
      });
    });

    await platform.invokeMethod('disableAutoSleep', <String, dynamic>{});

    if (_selfController.connectType.value == "0") {
      print(_selfController.needSetParameter.value["protocol"]);

      try {
        var send = {
          "protocolType":
              _selfController.needSetParameter.value["protocol"] == "V8"
                  ? 2
                  : _selfController.needSetParameter.value["protocol"] == "v6"
                      ? 1
                      : 0,
          "indoorAddress": int.parse(_selfController
              .needSetParameter.value["indoorAddress"]
              .toString()
              .replaceAll("#", ""))
        };
        print(send);
        var snback = await _snplatform.invokeMethod('outdoorDetection', send);
        var data = jsonDecode(snback);
        print("outdoorDetection: $data");
        if (data == null) {
          errorMsg = tr("outdoordetection.isnull");
          _timer.cancel();
          setState(() {
            errorMsg;
            _remainingSeconds = 300;
            ischecking = false;
          });
          return;
        }
        if (!data['success']) {
          errorMsg = data['errorMsg'];
          _timer.cancel();
          setState(() {
            errorMsg;
            _remainingSeconds = 300;
            ischecking = false;
          });
        } else {
          _timer.cancel();
          await platform.invokeMethod('enableAutoSleep', <String, dynamic>{});
          Get.to(() => resultpage(result: data["data"]));
        }
      } on PlatformException catch (e) {
        _timer.cancel();
        await platform.invokeMethod('enableAutoSleep', <String, dynamic>{});
        setState(() {
          _remainingSeconds = 300;
          ischecking = false;
        });
      }
    } else {
      try {
        var send = {
          "protocolType":
              _selfController.needSetParameter.value["protocol"] == "V8"
                  ? 2
                  : _selfController.needSetParameter.value["protocol"] == "V6"
                      ? 1
                      : 0,
          "isAssignAddress": _selfController.connectType.value == "1"
              ? true
              : _selfController.needSetParameter.value["addressSet"] ==
                  "内机已有地址",
          "indoorNum": _selfController.needSetParameter.value["indoorNum"] !=
                  null
              ? int.parse(_selfController.needSetParameter.value["indoorNum"]
                  .toString())
              : 0
        };
        String invokeMethodKey = "singleIndoorDetection";
        if (_selfController.connectType.value != "1") {
          invokeMethodKey = "multiIndoorDetection";
        }
        print("$invokeMethodKey: $send");
        var snback = await _snplatform.invokeMethod(invokeMethodKey, send);
        var data = jsonDecode(snback);
        print(data);
        print("$invokeMethodKey data: $data");
        if (data == null) {
          errorMsg = tr("outdoordetection.isnull");
          _timer.cancel();
          setState(() {
            errorMsg;
            _remainingSeconds = 300;
            ischecking = false;
          });
          return;
        }

        if (!data['success']) {
          errorMsg = data['errorMsg'];
          _timer.cancel();
          setState(() {
            errorMsg;
            _remainingSeconds = 300;
            ischecking = false;
          });
        } else {
          _timer.cancel();
          Get.to(() => resultpage(result: data["data"]));
        }
      } on PlatformException catch (e) {
        _timer.cancel();
        setState(() {
          _remainingSeconds = 300;
          ischecking = false;
        });
      }
    }
  }

  _tostop() async {
    EasyLoading.show(status: 'loading...');
    try {
      await platform.invokeMethod('enableAutoSleep', <String, dynamic>{});
      var historyback = await _snplatform.invokeMethod('setStop', {});

      Future.delayed(const Duration(seconds: 3), () {
        EasyLoading.dismiss();

        Get.back();
      });
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
    }
  }

  _stopcheck() async {
    bool issend = await divConfirmDialog(context,
        confirmTitle: tr("device.controltDialog.confirmTitle"),
        confirmDescriptionWidget: SingleChildScrollView(
          child: SizedBox(
              width: 560.w,
              height: 200.h,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Instructionspage.tip6',
                      style: titleText(),
                    ).tr(),
                    Text(
                      'Instructionspage.tip7',
                      style: normalText(),
                    ).tr(),
                  ],
                ),
              )),
        ));
    if (issend) _tostop();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print('----------------- dispose ----------------- 清空定时器、断开链接');
    super.dispose();

    platform.invokeMethod('enableAutoSleep', <String, dynamic>{});
    try {
      _timer.cancel();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                if (ischecking) {
                  _stopcheck();
                } else {
                  Navigator.pop(context);
                }
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
          padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
          child: Column(
            children: [
              Expanded(
                  child: Center(
                child: Column(
                  children: [
                    Image.asset(
                      ischecking
                          ? 'public/images/waterPump/loading.gif'
                          : 'public/images/afterSalesReplacement/error.png',
                      width: 280,
                    ),
                    if (ischecking)
                      Text(
                        tr("waterPump.search"),
                        style: normalTextBlack(),
                      ),
                    if (ischecking)
                      Text(
                        tr("Instructionspage.tip4"),
                        style: normalText(
                            fontcolor: const Color.fromRGBO(249, 83, 78, 1)),
                      ),
                    if (ischecking)
                      Text(
                        key: ValueKey("_remainingSeconds:$_remainingSeconds"),
                        tr("Instructionspage.tip5",
                            namedArgs: {"val": _remainingSeconds.toString()}),
                        style: normalTextBlack(fSize: 18, fw: FontWeight.w700),
                      ),
                    if (!ischecking)
                      Text(
                        errorMsg,
                        style: normalTextBlack(
                            fSize: 18,
                            fontcolor: const Color.fromRGBO(249, 83, 78, 1),
                            fw: FontWeight.w700),
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
                    label: tr(ischecking
                        ? 'Instructionspage.stop'
                        : 'Instructionspage.start'),
                    onClick: () async {
                      if (ischecking) {
                        _stopcheck();
                      } else {
                        init();
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
