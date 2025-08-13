import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/afterSalesReplacement/NewBoardParameterImportAuthorization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../local/publicFunction.dart';
import 'style.dart' hide ErrorTip;

class connectStep3Page extends StatefulWidget {
  Widget? nextPage;

  connectStep3Page({Key? key, this.nextPage = null}) : super(key: key);
  @override
  State<connectStep3Page> createState() => _connectStep3PageState();
}

class _connectStep3PageState extends State<connectStep3Page> {
  bool isConnecting = true;
  bool isConnected = false;

  // int _remainingSeconds = 60;
  late Timer _timer;

  final deviceInfoController _deviceInfoController = Get.find();

  static const platform = MethodChannel('samples.flutter.dev/battery');

  init() {
    _deviceInfoController.startPolling();
    setState(() {
      isConnecting = true;
      isConnected = false;
    });
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        if (_deviceInfoController.loacalDevice.value.isconnected &&
            _deviceInfoController.isPollingBack.value) {
          setState(() {
            isConnecting = false;
            isConnected = true;
          });
          _timer.cancel();
        }
        // if (_remainingSeconds > 0) {
        //   _remainingSeconds--;
        // } else {
        //   setState(() {
        //     isConnecting = false;
        //     isConnected = false;
        //   });
        //   _timer.cancel();
        // }
      });
    });
  }

  _back() async {
    if (!(_deviceInfoController.loacalDevice.value.isconnected &&
        _deviceInfoController.isPollingBack.value)) {
      bool issend = await divConfirmDialog(context,
          isSubmitButton: true,
          confirmTitle: tr("device.controltDialog.confirmTitle"),
          confirmDescriptionWidget: SingleChildScrollView(
            child: Container(
                width: 560.w,
                height: 80,
                padding: EdgeInsets.fromLTRB(24.w, 24.w, 24.w, 0),
                child: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                        style: normalTextBlack(),
                        text: tr('loacalDevice.disconnected')))),
          ));
      if (issend) {
        if (!_deviceInfoController.loacalDevice.value.isconnected) {
          _deviceInfoController.ProtocolHandlerStop();
        } else {
          _deviceInfoController.stopPolling();
        }
        Get.offAllNamed('/home');
      }
    } else {
      Get.offAllNamed('/home');
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer.isActive) {
      try {
        _timer.cancel();
      } catch (e) {}
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // Get height of app bar
    double appBarHeight = AppBar().preferredSize.height;

    // Calculate remaining height for page content
    double contentHeight = MediaQuery.of(context).size.height -
        appBarHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    return WillPopScope(
        onWillPop: () async {
          _back();
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
                onPressed: () {
                  _back();
                },
                icon: const Icon(Icons.chevron_left,
                    color: Colors.black, size: 36)),
            title: const Text(
              'afterSalesReplacement.connectStep3',
              style: TextStyle(color: Colors.black),
            ).tr(),
            centerTitle: true,
            actions: const [],
          ),
          body: Container(
            width: 720.w,
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(32.w, 24.w, 32.w, 24.w),
            child: Stack(
              children: [
                if (isConnecting)
                  Positioned(
                      width: 720.w - 32.w * 2,
                      height: contentHeight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                              padding: EdgeInsets.fromLTRB(0, 220.h, 0, 0.h),
                              child: Image.asset(
                                'public/images/waterPump/loading1.gif',
                                width: 280,
                              )),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 64.h, 0, 64.h),
                            child: Text(
                              tr('afterSalesReplacement.connectStepConnecting'),
                              style: tipStyle(),
                            ),
                          ),
                        ],
                      )),
                if (!isConnecting && isConnected)
                  Positioned(
                      width: 720.w - 32.w * 2,
                      height: contentHeight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                              padding: EdgeInsets.fromLTRB(0, 220.h, 0, 0.h),
                              child: Image.asset(
                                'public/images/afterSalesReplacement/success.png',
                                width: 215.w,
                              )),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 64.h, 0, 64.h),
                            child: Text(
                                tr('afterSalesReplacement.connectStepConnectSuccess'),
                                style: tipStyle()),
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(0, 0.h, 0, 0.h),
                              child: SizedBox(
                                width: 208.w,
                                height: 72.h,
                                child: normalButton(
                                  label: tr('determine'),
                                  onClick: () async {
                                    Get.to(() =>
                                        widget.nextPage ??
                                        NewBoardParameterImportAuthorization());
                                  },
                                ),
                              )),
                        ],
                      )),
                if (!isConnecting && !isConnected)
                  Positioned(
                      width: 720.w - 32.w * 2,
                      height: contentHeight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                              padding: EdgeInsets.fromLTRB(0, 220.h, 0, 0.h),
                              child: Image.asset(
                                'public/images/afterSalesReplacement/error.png',
                                width: 215.w,
                              )),
                          Padding(
                              padding:
                                  EdgeInsets.fromLTRB(64.w, 64.h, 64.w, 64.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: Center(
                                      child: Text(
                                        'afterSalesReplacement.connectStepConnectError',
                                        style: tipStyle(),
                                        textAlign: TextAlign.center,
                                      ).tr(),
                                    ),
                                  ),
                                  Text(
                                    'afterSalesReplacement.connectStepConnectErrorTip1',
                                    style: ErrorTip(),
                                    textAlign: TextAlign.left,
                                  ).tr(),
                                  Text(
                                    'afterSalesReplacement.connectStepConnectErrorTip2',
                                    style: ErrorTip(),
                                    textAlign: TextAlign.left,
                                  ).tr(),
                                  Text(
                                    'afterSalesReplacement.connectStepConnectErrorTip3',
                                    style: ErrorTip(),
                                    textAlign: TextAlign.left,
                                  ).tr(),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.fromLTRB(0, 0.h, 0, 0.h),
                              child: SizedBox(
                                width: 208.w,
                                height: 72.h,
                                child: normalButton(
                                  label:
                                      tr('afterSalesReplacement.connectStep3'),
                                  onClick: () async {
                                    await _deviceInfoController
                                        .ProtocolHandlerStop();
                                    await Future.delayed(
                                        const Duration(seconds: 1));
                                    init();
                                  },
                                ),
                              )),
                        ],
                      )),
              ],
            ),
          ),
        ));
  }
}
