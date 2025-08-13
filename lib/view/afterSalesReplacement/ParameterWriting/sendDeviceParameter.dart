import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/view/afterSalesReplacement/publicFunction.dart';
import 'package:fluoroscopy_tool/view/local/parameters/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class sendDeviceParameter extends StatefulWidget {
  const sendDeviceParameter({super.key});

  @override
  State<sendDeviceParameter> createState() => _sendDeviceParameterState();
}

class _sendDeviceParameterState extends State<sendDeviceParameter> {
  final afterSalesReplacementController _selfController =
      Get.put(afterSalesReplacementController());

  final MethodChannel methodChannel = const MethodChannel('scan.data');
  static const platform = MethodChannel('samples.flutter.dev/battery');

  static const _snplatform =
      MethodChannel('samples.flutter.dev/writeSnService');
  static const _selfplatform =
      MethodChannel('samples.flutter.dev/afterSalesReplacement');

  int _remainingSeconds = 60 * 5; //超时时间
  late Timer _timer;
  bool isWriteing = true;
  bool isSuccess = true;

  bool toSetAddress = false;

  int showpage = 99;
  String sn = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setState(() {
      isWriteing = true;
      isSuccess = true;
    });
    /**
     * 定时器处理超时
     */
    // _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    //   setState(() {
    //     if (_remainingSeconds > 0) {
    //       _remainingSeconds--;
    //     } else {
    //       setState(() {
    //         isWriteing = false;
    //         isSuccess = false;
    //       });
    //       // _timer.cancel();
    //     }
    //   });
    // });

    // "afterSalesReplacement.NewBoardParameter1": "室外机模块板",
    // "afterSalesReplacement.NewBoardParameter2": "室外机主板",
    // "afterSalesReplacement.NewBoardParameter3": "室内机主板",
    // "afterSalesReplacement.NewBoardParameter4": "全热交换器主板",
    showpage = NewBoardParameterList.indexOf(
        _selfController.NewBoardParameterType.value);
    List parametersList = _selfController.parameterWritingParameter
        .replaceAll("[", "")
        .replaceAll("]", "")
        .split(",");
    if (showpage == 0) {
      try {
        var snback = await _snplatform.invokeMethod('unblock',
            <String, dynamic>{"sn": _selfController.parameterWritingSn.value});
        var data = jsonDecode(snback);
        uploadclound(data["data"]);
        if (data != null) {
          setState(() {
            isWriteing = false;
            isSuccess = true;
          });
          // _timer.cancel();
        } else {
          setState(() {
            isWriteing = false;
            isSuccess = false;
          });
          // _timer.cancel();
        }
      } on PlatformException catch (e) {
        setState(() {
          isWriteing = false;
          isSuccess = false;
        });
        // _timer.cancel();
        print(" writeSn: '${e.message}'.");
      }
    } else {
      /**
       * 反写sn
       */
      // EasyLoading.showInfo("开始写入sn");
      // if (showpage != 3) {
      //   try {
      //     var snback = await _snplatform.invokeMethod(
      //         'writeSn', <String, dynamic>{
      //       "sn": _selfController.parameterWritingSn.value
      //     });
      //     var data = jsonDecode(snback);
      //     uploadclound(data["data"]);
      //     if (data["success"]) {
      //     } else {
      //       EasyLoading.showError(data["errorMsg"]);
      //     }
      //   } on PlatformException catch (e) {
      //     // EasyLoading.showError(tr('writeSn.error'));
      //     setState(() {
      //       isWriteing = false;
      //       isSuccess = false;
      //     });
      //     // _timer.cancel();
      //     print(" writeSn: '${e.message}'.");
      //   }
      // }
    }

    if (showpage == 1) {
      try {
        print("--------------  writeOduParameters --------------");
        var writeOduParameters = await _selfplatform
            .invokeMethod('writeOduParameters', <String, dynamic>{
          "sn": _selfController.parameterWritingSn.value,
          'p1': parametersList[0].replaceAll("\"", ""),
          'p2': parametersList[1].replaceAll("\"", ""),
          'systemAddress': int.parse(
              _selfController.needSetParameter.value['networkAddress']),
          'oduAddress': int.parse(
              _selfController.needSetParameter.value['outdoorAddress']),
        });

        var data = jsonDecode(writeOduParameters);
        var writedata = data["data"];

        uploadclound(writedata);
        setState(() {
          isWriteing = false;
          isSuccess = writedata["execution_result"] == "成功";
        });
        // _timer.cancel();
      } catch (e) {
        print("writeOduParameters error $e");
        setState(() {
          isWriteing = false;
          isSuccess = false;
        });
        // _timer.cancel();
      }
    }

    if (showpage == 2 || showpage == 3) {
      try {
        var writeIduParameters = await _selfplatform
            .invokeMethod('writeIduParameters', <String, dynamic>{
          "sn": _selfController.parameterWritingSn.value,
          'p1': parametersList[0].replaceAll("\"", ""),
          'p2': parametersList[1].replaceAll("\"", ""),
          'iduAddress': int.parse(
              _selfController.needSetParameter.value['indoorAddress']),
        });
        var data = jsonDecode(writeIduParameters);
        var writedata = data["data"];

        uploadclound(writedata);
        setState(() {
          isWriteing = false;
          isSuccess = writedata["execution_result"] == "成功";
        });
        // _timer.cancel();
      } catch (e) {
        print("writeIduParameters error $e");
        setState(() {
          isWriteing = false;
          isSuccess = false;
        });
        // _timer.cancel();
      }
    }

    if (showpage != 3 && isSuccess) {
      try {
        var snback = await _snplatform.invokeMethod('writeSn',
            <String, dynamic>{"sn": _selfController.parameterWritingSn.value});
        var data = jsonDecode(snback);
        uploadclound(data["data"]);
        if (data["success"]) {
        } else {
          EasyLoading.showError(data["errorMsg"]);
        }
      } on PlatformException catch (e) {
        // EasyLoading.showError(tr('writeSn.error'));
        setState(() {
          isWriteing = false;
          isSuccess = false;
        });
        // _timer.cancel();
        print(" writeSn: '${e.message}'.");
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 720.w,
      height: 1280.h - 155,
      color: Colors.white,
      child: !toSetAddress
          ? Center(
              child: isWriteing
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'public/images/afterSalesReplacement/wirite.gif',
                          width: 280,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 40.h, 0, 16.h),
                          child: Text(
                            tr('sendDeviceParameter.sending'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 18,
                                color: Color.fromRGBO(13, 13, 13, 1),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          key: ValueKey('_remainingSeconds:$_remainingSeconds'),
                          padding: EdgeInsets.fromLTRB(0, 0.h, 0, 64.h),
                          child: Text(
                              showpage == 0
                                  ? tr('sendDeviceParameter.sendingtip')
                                  : tr('sendDeviceParameter.sendingtiplong'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromRGBO(140, 140, 140, 1),
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          isSuccess
                              ? 'public/images/afterSalesReplacement/success.png'
                              : 'public/images/afterSalesReplacement/error.png',
                          width: 302.w,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 40.h, 0, 16.h),
                          child: Text(
                            isSuccess
                                ? tr('sendDeviceParameter.success')
                                : tr('sendDeviceParameter.error'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 18,
                                color: Color.fromRGBO(13, 13, 13, 1),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          key: ValueKey('_remainingSeconds:$_remainingSeconds'),
                          padding: EdgeInsets.fromLTRB(0, 0.h, 0, 64.h),
                          child: RichText(
                              text: TextSpan(
                            style: const TextStyle(
                                fontSize: 14.0,
                                color: Color.fromRGBO(140, 140, 140, 1)),
                            children: <TextSpan>[
                              isSuccess
                                  ? TextSpan(
                                      text:
                                          tr('sendDeviceParameter.successtip'))
                                  : TextSpan(
                                      text: tr('sendDeviceParameter.errortip')),
                            ],
                          )),
                        ),
                        if (isSuccess && !isWriteing && showpage == 1)
                          SizedBox(
                            width: 228.w,
                            height: 72.h,
                            child: normalButton(
                              label: tr("installationParameters"),
                              onClick: () async {
                                setState(() {
                                  toSetAddress = true;
                                });
                              },
                            ),
                          ),
                        if (!isSuccess && !isWriteing)
                          SizedBox(
                            width: 228.w,
                            height: 72.h,
                            child: normalButton(
                              label: tr('sendDeviceParameter.errorbutton'),
                              onClick: () async {
                                // init();
                                Navigator.pop(context);
                              },
                            ),
                          ),
                      ],
                    ),
            )
          : parametersPage(iscom: true),
    );
  }
}
