import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/cloud/publicFunction.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class bluetooth extends StatefulWidget {
  bluetooth({super.key});

  @override
  State<bluetooth> createState() => _bluetoothState();
}

class _bluetoothState extends State<bluetooth> {
  static const platform = MethodChannel('samples.flutter.dev/MSInterface');

  final deviceInfoController _deviceInfoController = Get.find();
  final MethodChannel methodChannel =
      const MethodChannel('sample.channel.MsInterface');
  List msBleScanInfos = [];
  // 请求蓝牙相关权限
  Future<void> requestPermissions() async {
    // 请求蓝牙扫描和连接权限
    PermissionStatus bluetoothScanStatus =
        await Permission.bluetoothScan.request();
    PermissionStatus bluetoothConnectStatus =
        await Permission.bluetoothConnect.request();
    PermissionStatus bluetoothStatus = await Permission.bluetooth.request();

    if (bluetoothScanStatus.isGranted &&
        bluetoothConnectStatus.isGranted &&
        bluetoothStatus.isGranted) {
      // 权限已授予，可以继续执行相关操作
      print('Bluetooth permissions granted');
    } else {
      // 权限被拒绝，告知用户
      print('Bluetooth permissions denied');
    }
  }

  initSDK() async {
    print("initSDK");
    try {
      var _toolUnlock =
          await platform.invokeMethod('initSDK', <String, dynamic>{});
      var bakc = jsonDecode(_toolUnlock);

      print("initSDK $bakc");
      if (bakc["success"]) {
      } else {
        return;
      }
    } catch (e) {}
  }

  bool isscarning = false;
  DateTime? _lastClickTime;

  void _handleClick() {
    DateTime now = DateTime.now();
    if (_lastClickTime == null ||
        now.difference(_lastClickTime!).inSeconds >= 2) {
      _lastClickTime = now;
      if (!isscarning) {
        startBlueScanAction();
      } else {
        stopBlueScanAction();
      }
      print("按钮点击成功");
      // 执行你的逻辑
    } else {
      print("点击过快，请稍后再试");
    }
  }

  startBlueScanAction() async {
    _deviceInfoController.setmsBleScanInfos([]);
    setState(() {
      msBleScanInfos = [];
      isscarning = true;
    });
    print("startBlueScanAction");
    EasyLoading.show(status: 'loading...');
    try {
      var _toolUnlock = await platform
          .invokeMethod('startBlueScanAction', <String, dynamic>{});
      print("startBlueScanAction success $_toolUnlock");
      Future.delayed(const Duration(seconds: 2), () {
        EasyLoading.dismiss();
      });
    } catch (e) {
      print("startBlueScanAction error $e");
      EasyLoading.dismiss();
    }
  }

  stopBlueScanAction() async {
    try {
      await platform.invokeMethod('stopBlueScanAction', <String, dynamic>{});
      setState(() {
        isscarning = false;
      });
    } catch (e) {}
  }

  String device_token = "";
  String device_mac = "";
  bool isconnectBlueing = false;
  bool isconnectBlueingerror = false;
  connectBlue(mac) async {
    await stopBlueScanAction();
    try {
      setState(() {
        isconnectBlueing = true;
        isconnectBlueingerror = false;
      });
      if (mac != _deviceInfoController.bluetoothmac) {
        await _deviceInfoController.setbluetoothtoken("");
      }

      await _deviceInfoController.setbluetoothmac(mac);
      if (_deviceInfoController.bluetoothtoken.value == "") {
        device_mac = mac;
        // EasyLoading.show(status: 'loading...');
        var _toolUnlock = await platform.invokeMethod(
            'startComboBindAction', <String, dynamic>{"mac": mac});
        device_token = _toolUnlock['data'];

        await _deviceInfoController.setbluetoothtoken(device_token);
        print("connectBlue startComboBindAction:   $device_token");
      } else {
        device_token = _deviceInfoController.bluetoothtoken.value;
      }
      setupBlueConnectionAction();
    } on PlatformException catch (_, e) {
      // EasyLoading.dismiss();
      setState(() {
        isconnectBlueingerror = true;
      });
      showaptip();
      print("connectBlue startComboBindAction:   $e");
    }
  }

  bool isdone = false;
  showaptip() async {
    isdone = false;
    bool issend = await divConfirmOnlyDialog(context,
        isSubmitButton: true,
        confirmTitle: tr("showaptip"),
        confirmDescriptionWidget: SizedBox(
          width: 560.w,
          height: 345,
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'public/images/bluetooth/ap.png',
                  width: 479.w,
                ),
                const Padding(padding: EdgeInsets.all(8)),
                const Text(
                  "showaptip.context",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ).tr(),
                const Padding(padding: EdgeInsets.all(20)),
                confrimtip(onchange: (val) {
                  print("isdone: $val");
                  isdone = val;
                })
              ],
            ),
          )),
        ));
    if (isdone) {
      connectBlue(device_mac);
    }
  }

  setupBlueConnectionAction() async {
    try {
      var _toolUnlock = await platform.invokeMethod('setupBlueConnectionAction',
          <String, dynamic>{"token": device_token, "mac": device_mac});
      print("connectBlue setupBlueConnectionAction:   $_toolUnlock");
      EasyLoading.dismiss();
      queryAuthStatusAction();
    } on PlatformException catch (_, e) {
      EasyLoading.dismiss();
      EasyLoading.showError(_.message ?? "setupBlueConnectionAction error");
      print("connectBlue setupBlueConnectionAction:   $e");
    }
  }

  bool isconnect = false;
  checkconnect() async {
    try {
      var _toolUnlock = await platform.invokeMethod(
          'isDeviceConnected', <String, dynamic>{"mac": device_mac});
      print("connectBlue isDeviceConnectedAction:   $_toolUnlock");

      /**
     * 设置全局的连接状态为蓝牙连接,先开启 Polling 获取指令队列
     */
      await _deviceInfoController.setIsBluetooth(true);
      await _deviceInfoController.setIsConnected(true);
      await _deviceInfoController.startPolling();

      sendcommand();
    } on PlatformException catch (_, e) {
      EasyLoading.dismiss();
      EasyLoading.showError(_.message ?? "isDeviceConnectedAction error");
      print("connectBlue isDeviceConnectedAction:   $e");
    }
  }

  List back = [];
  sendcommand() async {
    /**
     * 发送队列中第一条指令，后续在数据返回中自动下发队列中的指令
     */
    platform.invokeMethod('sendBlueHexRequest', {});
    Future.delayed(const Duration(seconds: 1), () {
      Get.offAllNamed('/home');
    });
  }

  queryAuthStatusAction() async {
    var sendBlueHexRequestAction =
        await platform.invokeMethod('queryAuthStatus', <String, dynamic>{
      "mac": device_mac,
    });
    var backstatus = json.decode(sendBlueHexRequestAction);
    EasyLoading.dismiss();
    if (backstatus['messageBody']['authStatus'] == 1) {
      setState(() {
        isconnect = true;
        back = [];
      });

      /** 鉴权成功，成功连接上设备，创建数据监听 */
      checkconnect();
    } else {
      EasyLoading.showError(tr("queryauthstatus.error"));
      disconnectBlueConnection();
    }
    print(
        "connectBlue queryAuthStatus:  authStatus ${backstatus['messageBody']['authStatus'] == 1 ? "  ------- > 已确权" : "  ------- > 未确权/待确权"}");
  }

  disconnectBlueConnection() async {
    var sendBlueHexRequestAction =
        await platform.invokeMethod('disconnectBlueConnection', {});
    var backstatus = sendBlueHexRequestAction;

    setState(() {
      isconnect = false;
      back = [];
    });
    print("connectBlue disconnectBlueConnection:   $sendBlueHexRequestAction");
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
    initSDK();

    // methodChannel.setMethodCallHandler((call) async {
    //   print("methodChannel back $call");
    //   if (call.method == 'connectFail') {
    //     setState(() {
    //       isconnect = false;
    //       back = [];
    //     });
    //     _deviceInfoController.setbluetoothmac("");
    //     _deviceInfoController.setIsConnected(true);
    //   }
    //   if (call.method == 'onDataChange') {
    //     setState(() {
    //       back.add("back -->  ${call.arguments}");
    //     });
    //   }
    //   if (call.method == 'startScan') {
    //     msBleScanInfos.add(json.decode(call.arguments));
    //     print("msBleScanInfos: $msBleScanInfos");
    //     setState(() {
    //       msBleScanInfos;
    //     });
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
    if (isscarning) {
      stopBlueScanAction();
    }

    EasyLoading.dismiss();
    // if (isconnect) _deviceInfoController.setupBluetoothmethodChannel();
    // methodChannel.setMethodCallHandler(null);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<deviceInfoController>(
        init: deviceInfoController(),
        builder: (_) => Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {
                    if (isconnectBlueing) {
                      setState(() {
                        isconnectBlueing = false;
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.chevron_left,
                      color: Colors.black, size: 36)),
              title: const Text(
                'bluetooth.apptitle',
                style: TextStyle(color: Colors.black),
              ).tr(),
              centerTitle: true,
              actions: [],
            ),
            // floatingActionButton: IconTextButton(
            //   icon: Icons.search,
            //   text: "sendcommand",
            //   onPressed: () {
            //     sendcommand();
            //   },
            // ),
            body: Container(
              width: 720.w,
              height: 1280.h,
              color: const Color.fromRGBO(244, 244, 244, 1),
              padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
              child: !isconnectBlueing
                  ? Column(
                      children: [
                        Expanded(
                            child: Container(
                          width: 720.w,
                          margin: const EdgeInsets.symmetric(vertical: 16),
                          child: _.msBleScanInfos.isNotEmpty
                              ? ListView.builder(
                                  itemCount: _.msBleScanInfos.length,
                                  itemBuilder: ((context, index) => Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 32),
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            const Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 16, 0, 0)),
                                            Row(
                                              children: [
                                                Image.asset(
                                                  'public/images/bluetooth/bluetooth.png',
                                                  width: 74.w,
                                                ),
                                                const Padding(
                                                    padding: EdgeInsets.all(8)),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(_.msBleScanInfos[
                                                          index]["name"]),
                                                      const Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 4, 0, 0)),
                                                      Text(
                                                        _.msBleScanInfos[index]
                                                            ["mac"],
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    15,
                                                                    17,
                                                                    28,
                                                                    0.5)),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    connectBlue(
                                                        _.msBleScanInfos[index]
                                                            ["mac"]);
                                                  },
                                                  child: Container(
                                                    width: 128.w,
                                                    height: 68.h,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color(
                                                          0xFF0C69FF), // 背景颜色
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8)), // 圆角
                                                    ),
                                                    child: Center(
                                                      child: const Text(
                                                        'bluetooth.btn',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14),
                                                      ).tr(),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 16, 0, 0)),
                                            Container(
                                              height: 1,
                                              color: const Color.fromRGBO(
                                                  238, 238, 238, 1),
                                            )
                                          ],
                                        ),
                                      )))
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'public/images/bluetooth/empty.png',
                                        width: 276.w,
                                      ),
                                      const Padding(padding: EdgeInsets.all(8)),
                                      const Text(
                                        "bluetooth.empty",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ).tr()
                                    ],
                                  ),
                                ),
                        )),
                        Container(
                          height: 57,
                          padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                          child: submitButton(
                            isActive: true,
                            key: ValueKey('isscarning_$isscarning'),
                            label: !isscarning
                                ? tr('bluetooth.scarn')
                                : tr('bluetooth.stopscarn'),
                            onClick: () async {
                              _handleClick();
                            },
                          ),
                        ),
                      ],
                    )
                  : Container(
                      color: Colors.white,
                      child: Center(
                        child: SizedBox(
                          width: 528.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: !isconnectBlueingerror
                                ? [
                                    Stack(
                                      children: [
                                        Image.asset(
                                          'public/images/waterPump/loading.gif',
                                          width: 256,
                                        ),
                                        Positioned(
                                          left: 90,
                                          top: 80,
                                          child: Image.asset(
                                            'public/images/bluetooth/scarn.png',
                                            width: 70,
                                            color: const Color.fromRGBO(
                                                255, 255, 255, 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Padding(padding: EdgeInsets.all(8)),
                                    const Text(
                                      "bluetooth.connecting",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ).tr(),
                                    const Padding(padding: EdgeInsets.all(8)),
                                    const Text(
                                      "bluetooth.connecting.tip",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              Color.fromRGBO(140, 140, 140, 1),
                                          fontWeight: FontWeight.w400),
                                    ).tr()
                                  ]
                                : [
                                    Stack(
                                      children: [
                                        Image.asset(
                                          'public/images/afterSalesReplacement/error.png',
                                          width: 198,
                                        ),
                                      ],
                                    ),
                                    const Padding(padding: EdgeInsets.all(8)),
                                    const Text(
                                      "bluetooth.connecting.error",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const Padding(padding: EdgeInsets.all(8)),
                                    const Text(
                                      "bluetooth.connecting.errortip",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              Color.fromRGBO(140, 140, 140, 1),
                                          fontWeight: FontWeight.w400),
                                    ).tr(),
                                    const Padding(padding: EdgeInsets.all(32)),
                                    SizedBox(
                                      width: 208.w,
                                      height: 72.h,
                                      child: normalButton(
                                        label: tr('bluetooth.reconnecting'),
                                        onClick: () {
                                          connectBlue(device_mac);
                                        },
                                      ),
                                    )
                                  ],
                          ),
                        ),
                      ),
                    ),
            )));
  }
}

class confrimtip extends StatefulWidget {
  Function onchange;
  confrimtip({super.key, required this.onchange});

  @override
  State<confrimtip> createState() => _confrimtipState();
}

class _confrimtipState extends State<confrimtip> {
  bool isdone = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isdone = !isdone;
        });

        widget.onchange(isdone);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            key: ValueKey('isdone_$isdone'),
            padding: const EdgeInsets.fromLTRB(0, 4, 8, 0),
            child: RoundCheckBox(
              isChecked: isdone,
              onTap: (selected) {
                setState(() {
                  isdone = !isdone;
                });
                widget.onchange(isdone);
              },
              size: 18,
              checkedWidget: const Icon(
                Icons.check,
                color: Colors.white,
                size: 14,
              ),
              checkedColor: Theme.of(context).colorScheme.secondary,
              border: Border.all(
                  // width: 1,
                  color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          const Text(
            "bluetooth.finish",
            style: TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400),
          ).tr(),
        ],
      ),
    );
  }
}
