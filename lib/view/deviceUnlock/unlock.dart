import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/snInput.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'deviceUnlock.dart';

class unlock extends StatefulWidget {
  const unlock({super.key});
  @override
  State<unlock> createState() => _unlockState();
}

class _unlockState extends State<unlock> {
  static const platform = MethodChannel('samples.flutter.dev/battery');
  static const _snplatform =
      MethodChannel('samples.flutter.dev/writeSnService');

  static const _colundplatform =
      MethodChannel('samples.flutter.dev/getDeviceUnlockHandler');

  static const CHANNEL_getProjectHandler =
      MethodChannel('samples.flutter.dev/getProjectHandler');

  final deviceInfoController _deviceInfoController = Get.find();

  int _remainingSeconds = 30; //超时时间
  late Timer _timer;
  int doingType = 0; // 0 未开始；1 解锁中；3 解锁成功；2 解锁失败；

  var unLockdata = {};

  init() async {
    setState(() {
      doingType = 1;
      _remainingSeconds = 30;
    });
    /**
     * 定时器处理超时
     */

    var unLock = await platform.invokeMethod('unLock',
        <String, dynamic>{"sn": _deviceInfoController.loacalDevice.value.sn});
    unLockdata = jsonDecode(unLock);
    print("unLock: ${unLockdata}");
    if (unLockdata["success"]) {
      toolUnlock();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          refresh();
          if (_timer != null && _timer.isActive) _timer.cancel();
        }
        setState(() {
          _remainingSeconds;
        });
      });
    } else {
      setState(() {
        doingType = 2;
        _remainingSeconds = 30;
      });
      EasyLoading.showError(unLockdata["errorMsg"]);
    }
  }

  toolUnlock() async {
    final prefs = await SharedPreferences.getInstance();
    String? usernameprefs = await prefs.getString("usernameA");
    print("toolUnlock usernameprefs: $usernameprefs");
    if (usernameprefs != null) {
      var _colundupload = await CHANNEL_getProjectHandler.invokeMethod(
          'getDeviceUnlockHandler.toolUnlock', <String, dynamic>{
        "sn": _deviceInfoController.loacalDevice.value.sn,
        "operator": usernameprefs,
      });
      var bakc = jsonDecode(_colundupload);

      print("toolUnlock ${{
        "sn": _deviceInfoController.loacalDevice.value.sn,
        "operator": usernameprefs,
      }}  ${bakc}");
      try {
        if (bakc["success"]) {
          EasyLoading.showSuccess(tr("deviceUnlock.uploadsuccess"));
        } else {
          EasyLoading.showError(bakc["errorMsg"]);
        }
      } catch (e) {}
    }
  }

  refresh() async {
    try {
      if (unLockdata["success"]) {
        if (unLockdata["data"]["result"] == 1) {
          setState(() {
            doingType = 3;
            _remainingSeconds = 30;
          });
        } else {
          setState(() {
            doingType = 2;
            _remainingSeconds = 30;
          });
        }
      } else {
        setState(() {
          doingType = 0;
          _remainingSeconds = 30;
        });
        EasyLoading.showError(unLockdata["errorMsg"]);
      }
    } on PlatformException catch (e) {
      if (_timer != null && _timer.isActive) _timer.cancel();
      print("unLockdata unLock: ${e}");
    }

    try {
      if (unLockdata.isNotEmpty && unLockdata["success"]) {
        final prefs = await SharedPreferences.getInstance();
        var useinfoSting = prefs.getString("useinfo");
        String phone = "";
        if (useinfoSting != null) {
          try {
            var useinfo = jsonDecode(useinfoSting);
            phone = useinfo["phone"];
          } catch (e) {}
        }
        String? usernameprefs = await prefs.getString("usernameA");
        var _colundupload = await _colundplatform
            .invokeMethod('insertOperationLog', <String, dynamic>{
          "deviceSn": _deviceInfoController.loacalDevice.value.sn,
          "executionResult": doingType == 2 ? "失败" : "成功",
          "number": "",
          "phone": phone,
          "uid": usernameprefs,
          "operation": unLockdata["data"]["msg"],
          "location": unLockdata["data"]["location"],
        });
        var bakc = jsonDecode(_colundupload);
        if (bakc["success"]) {
          var updateReport = await platform.invokeMethod('updateReport',
              <String, dynamic>{"id": unLockdata["data"]["id"]});
        }
      }
    } catch (e) {
      print("unLockdata _colundupload: ${e}");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      init();
    });
  }

  @override
  void dispose() {
    super.dispose();
    try {
      if (_timer != null && _timer.isActive) _timer.cancel();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Get.off(() => const deviceUnlock()); //
              },
              icon: const Icon(Icons.chevron_left,
                  color: Colors.black, size: 36)),
          title: const Text(
            'unlock.title',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [],
        ),
        body: Stack(children: <Widget>[
          Container(
            width: 720.w,
            height: 1280.h,
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(32.w, 24.h, 32.w, 24.h),
            child: Column(
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0.h, 0, 0.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color.fromRGBO(223, 223, 223, 1),
                                        width: 0.5,
                                      ),
                                    )),
                                padding:
                                    const EdgeInsets.fromLTRB(0, 12, 0, 12),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        tr('unlock.deviceSN'),
                                        style: normalTextBlack(),
                                      ),
                                      Text(
                                        _deviceInfoController
                                            .loacalDevice.value.sn
                                            .toUpperCase(),
                                        style: ErrorTip(),
                                      )
                                    ]),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color.fromRGBO(223, 223, 223, 1),
                                        width: 0.5,
                                      ),
                                    )),
                                padding:
                                    const EdgeInsets.fromLTRB(0, 12, 0, 12),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        tr('unlock.deviceType'),
                                        style: normalTextBlack(),
                                      ),
                                      Text(
                                        _deviceInfoController
                                            .loacalDevice.value.machine,
                                        style: ErrorTip(),
                                      )
                                    ]),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
                Expanded(
                    child: baseContainer(
                        child: doingType == 1
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'public/images/waterPump/loading.gif',
                                    width: 280,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(0, 40.h, 0, 16.h),
                                    child: Text(
                                      tr('unlock.doing', namedArgs: {
                                        "val": "$_remainingSeconds"
                                      }),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Color.fromRGBO(13, 13, 13, 1),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    key: ValueKey(
                                        '_remainingSeconds:$_remainingSeconds'),
                                    padding:
                                        EdgeInsets.fromLTRB(0, 0.h, 0, 64.h),
                                    child: Text(tr('unlock.doingtip'),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Color.fromRGBO(
                                                140, 140, 140, 1),
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    doingType == 3
                                        ? 'public/images/afterSalesReplacement/success.png'
                                        : 'public/images/afterSalesReplacement/error.png',
                                    width: 302.w,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(0, 40.h, 0, 16.h),
                                    child: Text(
                                      doingType == 3
                                          ? tr('unlock.success')
                                          : tr('unlock.error'),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Color.fromRGBO(13, 13, 13, 1),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    key: ValueKey(
                                        '_remainingSeconds:$_remainingSeconds'),
                                    padding:
                                        EdgeInsets.fromLTRB(0, 0.h, 0, 64.h),
                                    child: RichText(
                                        text: TextSpan(
                                      style: const TextStyle(
                                          fontSize: 14.0,
                                          color:
                                              Color.fromRGBO(140, 140, 140, 1)),
                                      children: <TextSpan>[
                                        doingType == 3
                                            ? TextSpan(
                                                text: tr('unlock.successtip'))
                                            : TextSpan(
                                                text: tr('unlock.errortip')),
                                      ],
                                    )),
                                  ),
                                  SizedBox(
                                    width: 440.w,
                                    height: 72.h,
                                    child: doingType == 3
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                  width: 208.w,
                                                  height: 72.h,
                                                  child: normalButton(
                                                    label: tr(
                                                        'unlock.successbtn1'),
                                                    onClick: () async {
                                                      init();
                                                    },
                                                  )),
                                              SizedBox(
                                                  width: 208.w,
                                                  height: 72.h,
                                                  child: submitButton(
                                                    isActive: true,
                                                    label: tr(
                                                        'unlock.successbtn2'),
                                                    onClick: () async {
                                                      Get.off(() =>
                                                          const deviceUnlock()); //
                                                    },
                                                  ))
                                            ],
                                          )
                                        : Center(
                                            child: SizedBox(
                                                width: 208.w,
                                                height: 72.h,
                                                child: normalButton(
                                                  label: tr('unlock.errorbtn'),
                                                  onClick: () async {
                                                    init();
                                                  },
                                                )),
                                          ),
                                  ),
                                ],
                              )))
              ],
            ),
          ),
        ]));
  }
}
