// ignore_for_file: use_build_context_synchronously

/*
 * @Author: FishHaveMine 751174479@qq.com
 * @Date: 2024-05-27 17:01:26
 * @LastEditors: FishHaveMine 751174479@qq.com
 * @LastEditTime: 2024-06-12 15:29:18
 * @FilePath: /fluoroscopy_tool/lib/view/local/index.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 * 
 *  这次8月底拿出出去试用的功能点暂定如下：
 * 本地连接部分包括如下：
 * 设备解锁、安装参数、历史故障、售后换版、水泵检测、膨胀阀检测、协议检测。
 * 云端管理：主功能
 */
import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/ImagePickerExample.dart';
import 'package:fluoroscopy_tool/compent/file_picker.dart';
import 'package:fluoroscopy_tool/compent/location.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/view/local/cardFunList.dart';
import 'package:fluoroscopy_tool/view/local/checkData/index.dart';
import 'package:fluoroscopy_tool/view/userinfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../store/globalData.dart' hide connectType;
import '../../style/index.dart';
import 'otaCard.dart';
import 'publicFunction.dart';
import 'publicFunctionList.dart';
import 'style.dart';

import 'package:get/get.dart';

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class localDevice extends StatefulWidget {
  const localDevice({super.key});

  @override
  State<localDevice> createState() => _localDeviceState();
}

class _localDeviceState extends State<localDevice> {
  final deviceInfoController _deviceInfoController = Get.find();
  final userinfoController _promissioncontroller =
      Get.put(userinfoController());
  static const platform = MethodChannel('samples.flutter.dev/battery');
  static const initplatform = MethodChannel('samples.flutter.dev/init');
  static const McuUtilplatform = MethodChannel('samples.flutter.dev/McuUtil');
  static const _colundplatform =
      MethodChannel('samples.flutter.dev/getDeviceUnlockHandler');

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.status;
    if (!status.isGranted) {
      final result = await Permission.camera.request();
      if (result.isGranted) {
        // 权限已被授予
        print('Camera permission granted');
      } else if (result.isDenied) {
        // 权限被拒绝
        print('Camera permission denied');
      } else if (result.isPermanentlyDenied) {
        // 权限被永久拒绝
        print('Camera permission permanently denied');
      }
    } else {
      // 权限已经被授予
      print('Camera permission already granted');
    }
  }

  Future<void> requestPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      // 请求权限
      if (await Permission.camera.request().isGranted) {
        print("Camera permission granted");
      } else {
        print("Camera permission denied");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    print('home ----------------- initState -----------------');
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    // _deviceInfoController.setIsConnected(false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      requestPermission();
      inthttp();
      checkunlock();
      requestCameraPermission();
    });
  }

  Timer? _timer;
  getDeviceTypeEnum() async {}

  upclound(unLockdata) async {
    if (unLockdata["report"] == 1) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    if (unLockdata["result"] == 1) {
      try {
        String? operator = prefs.getString('username');
        if (operator != null) {
          var _toolUnlock = await _colundplatform.invokeMethod(
              'getDeviceUnlockHandler.toolUnlock', <String, dynamic>{
            "sn": unLockdata["sn"],
            "operator": operator,
          });
          var bakc = jsonDecode(_toolUnlock);
          if (bakc["success"]) {
          } else {
            return;
          }
        }
      } catch (e) {}
    }
    try {
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
        "deviceSn": unLockdata["sn"],
        "executionResult": unLockdata["result"] == 1 ? "成功" : "失败",
        "number": "",
        "phone": phone,
        "uid": unLockdata["username"],
        "operation": unLockdata["msg"],
        "location": unLockdata["location"],
      });
      var bakc = jsonDecode(_colundupload);
      if (bakc["success"]) {
        var updateReport = await platform.invokeMethod(
            'updateReport', <String, dynamic>{"id": unLockdata["id"]});
      }
    } catch (e) {
      return;
    }
  }

  checkunlock() async {
    try {
      final response = await Dio().get('https://${apiHost}/');
      bool isnetconnecd = response.statusCode == 200;
      if (isnetconnecd) {
        var reportData =
            await platform.invokeMethod('unLockgetData', <String, dynamic>{
          "isall": false,
          "report": 0,
          "pageindex": 1,
        });
        var jsondata2 = jsonDecode(reportData);
        if (jsondata2["success"]) {
          for (var element in jsondata2["data"]) {
            await upclound(element);
          }
        }
      }
    } catch (e) {}
  }

  inthttp() async {
    final prefs = await SharedPreferences.getInstance();
    bool? haveinithttp = prefs.getBool("haveinithttp");
    if (haveinithttp == true) {
      prefs.remove("haveinithttp");
    } else {
      await initplatform.invokeMethod('init', <String, dynamic>{
        "issit": apiHost == "btri-dev.midea.com",
        "token": prefs.getString('token'),
        "uid": prefs.getString('username'),
      });
    }
  }

  bool _isClickable = true; // 控制按钮是否可点击
  // 模拟加载数据
  intList() async {
    if (_isClickable) {
      // 第一次点击执行的逻辑
      _deviceInfoController.startPolling();

      // 禁用按钮，防止短时间内再次点击
      _isClickable = false;

      // 1秒后恢复按钮的点击功能
      Timer(const Duration(seconds: 10), () {
        _isClickable = true;
      });
    } else {
      print('Click ignored due to cooldown');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _deviceInfoController.stopPolling();
    EasyLoading.dismiss();
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
    return GetBuilder<deviceInfoController>(
        init: deviceInfoController(),
        builder: (_) => Container(
              height: 1280.h - 55,
              clipBehavior: Clip.hardEdge, // 关键点！裁剪超出部分
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('public/images/devicePageBg.png'),
                      fit: BoxFit.fill)),
              child: SingleChildScrollView(
                child: Column(
                  key: ValueKey(
                      'localMain_${_deviceInfoController.updateTime.value}'),
                  children: [
                    const deviceVersion(),
                    deviceInfoPage(onStart: () {
                      intList();
                    }),
                    publicFunctionList(),
                    const otaCard(),
                    const cardFunList()
                  ],
                ),
              ),
            ));
  }
}

class deviceVersion extends StatefulWidget {
  const deviceVersion({super.key});

  @override
  State<deviceVersion> createState() => _deviceVersionState();
}

class _deviceVersionState extends State<deviceVersion> {
  final deviceInfoController _deviceInfoController = Get.find();

  void _copyTextToClipboard(String text) {
    if (text != null) {
      Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${tr('projectDetail.deviceManage.copy')}: $text'),
        ),
      );
    }
  }

  static const platform = MethodChannel('samples.flutter.dev/battery');
  openscan() async {
    try {
      await platform.invokeMethod('SCANNER_TRIG');
    } on PlatformException catch (e) {
      print("Failed to SCANNER_TRIG: '${e.message}'.");
    }
  }

  imgpick() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ImagePickerExample()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<deviceInfoController>(
        init: deviceInfoController(),
        builder: (_) => Container(
              padding: EdgeInsets.fromLTRB(paddingLR, 58.h, paddingLR, 0),
              child: _deviceInfoController.loacalDevice.value.isconnected
                  ? Column(
                      children: [
                        InkWell(
                            onTap: () {},
                            child: Row(children: [
                              Text(
                                _deviceInfoController
                                    .loacalDevice.value.machine,
                                style: versionTitle(context),
                              ),
                              const Padding(
                                  padding: EdgeInsets.fromLTRB(8, 0, 0, 0)),
                              // ignore: prefer_interpolation_to_compose_strings
                              Text(
                                  tr('local.version') +
                                      (_deviceInfoController
                                              .loacalDevice.value.version
                                              .toString()
                                              .contains("null")
                                          ? "--"
                                          : _deviceInfoController
                                              .loacalDevice.value.version),
                                  style: versionValue(context))
                            ])),
                        const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 7)),
                        Row(
                          children: _deviceInfoController
                                  .loacalDevice.value.isconnected
                              ? [
                                  Text(
                                      _deviceInfoController
                                              .loacalDevice.value.model +
                                          tr('local.model'),
                                      style: versionValue(context)),
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: SizedBox(
                                      width: 1,
                                      height: 11,
                                      child: DecoratedBox(
                                        decoration:
                                            BoxDecoration(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: InkWell(
                                          onTap: () {
                                            _copyTextToClipboard(
                                                _deviceInfoController
                                                    .loacalDevice.value.sn);
                                          },
                                          child: Text(
                                              'SN ${_deviceInfoController.loacalDevice.value.sn.toUpperCase()}',
                                              maxLines: 1,
                                              style: versionValue(context))))
                                ]
                              : [],
                        )
                      ],
                    )
                  : SizedBox(
                      width: 720.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 7, 0, 11),
                            child: Text(
                              'local.disconnect',
                              style: versionTitle(context),
                            ).tr(),
                          ),
                          IconButton(
                              onPressed: () {
                                getDBFile(context);
                              },
                              icon: const Icon(
                                Icons.ios_share,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
            ));
  }
}

class deviceInfoPage extends StatefulWidget {
  Function onStart;
  deviceInfoPage({super.key, required this.onStart});

  @override
  State<deviceInfoPage> createState() => _deviceInfoPageState();
}

class _deviceInfoPageState extends State<deviceInfoPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final userinfoController _promissioncontroller = Get.find();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
      upperBound: 1.0,
    )..repeat(reverse: true); // 循环动画

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose(); // Properly dispose of the AnimationController
    super.dispose();
  }

  static const platform = MethodChannel('samples.flutter.dev/battery');
  final deviceInfoController _deviceInfoController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<deviceInfoController>(
        init: deviceInfoController(),
        builder: (_) => Container(
              width: 656.w,
              height: 300.h,
              margin: EdgeInsets.fromLTRB(paddingLR, 0.h, paddingLR, 0),
              child: Stack(children: [
                // if (_deviceInfoController.loacalDevice.value.isconnected)
                locationpage(getlocation: (val) async {
                  final prefs = await SharedPreferences.getInstance();
                  print("locationpage: $val");
                  await platform.invokeMethod('setlocation', <String, dynamic>{
                    "username": prefs.getString('username'),
                    "location": val['address'],
                    "latitude": val['latitude'],
                    "longitude": val['longitude'],
                  });
                  prefs.setString("location", val['address']);
                  prefs.setString("latitude", val['latitude'].toString());
                  prefs.setString("longitude", val['longitude'].toString());
                }),
                Positioned(
                  bottom: 60.h,
                  left: 0,
                  child: InkWell(
                      onTap: () {},
                      child: SizedBox(
                        width: 656.w,
                        child: Center(
                          child: Image.asset(
                              'public/images/icon/deviceInfoBG1.png',
                              width: 362.w),
                        ),
                      )),
                ),
                if (_deviceInfoController.loacalDevice.value.isconnected)
                  Positioned(
                    bottom: 24.h,
                    left: (656.w - 428.w) / 2,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 255, 255, 0.3),
                            borderRadius: BorderRadius.circular(16)),
                        width: 428.w,
                        height: 56.h,
                      ),
                    ),
                  ),
                if (_deviceInfoController.loacalDevice.value.isconnected)
                  Positioned(
                    bottom: 24.h,
                    left: (656.w - 428.w) / 2,
                    child: GestureDetector(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => checkDataPage()),
                          );
                          // print('checkDataPage');
                          // Get.to(() => const checkDataPage());
                        },
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'public/images/icon/deviceInfoBG.png'),
                                    fit: BoxFit.contain)),
                            width: 428.w,
                            height: 56.h,
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1, // 只显示一行
                                      '${tr('local.ODU')} ${_deviceInfoController.loacalDevice.value.ODU}  ${tr('local.IDU')} ${_deviceInfoController.loacalDevice.value.IDU}',
                                      style: cardInfoName(context),
                                    ),
                                  ),
                                  SizedBox(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'local.checkData',
                                          style: cardInfoTap(context),
                                        ).tr(),
                                        const Icon(
                                          Icons.chevron_right,
                                          size: 14,
                                          color:
                                              Color.fromRGBO(136, 136, 136, 1),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                  ),
                Positioned(
                    left: 0,
                    top: 12.h,
                    child: SizedBox(
                        width: 656.w,
                        height: 218.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (_deviceInfoController
                                .loacalDevice.value.isconnected)
                              SizedBox(
                                width: (656.w - 348.w - paddingLR * 2) / 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 48.h,
                                          child: Center(
                                            child: Text(
                                                    _deviceInfoController
                                                            .loacalDevice
                                                            .value
                                                            .isconnected
                                                        ? '${_deviceInfoController.loacalDevice.value.totalMatches.toStringAsFixed(1)}HP'
                                                        : '--',
                                                    // overflow:
                                                    //     TextOverflow.ellipsis,
                                                    maxLines: 1, // 只显示一行
                                                    style: versionValueBlock(
                                                        context))
                                                .tr(),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 33.h,
                                          child: Center(
                                            child: Text('totalMatches',
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        versionValue(context))
                                                .tr(),
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 30.h)),
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 48.h,
                                          child: Center(
                                            child: Text(
                                                    _deviceInfoController
                                                            .loacalDevice
                                                            .value
                                                            .isconnected
                                                        ? '${_deviceInfoController.loacalDevice.value.matchingNumber.toStringAsFixed(1)}%'
                                                        : '--',
                                                    // overflow:
                                                    //     TextOverflow.ellipsis,
                                                    maxLines: 1, // 只显示一行
                                                    style: versionValueBlock(
                                                        context))
                                                .tr(),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 33.h,
                                          child: Center(
                                            child: Text('matchingNumber',
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        versionValue(context))
                                                .tr(),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            SizedBox(
                              width: 348.w,
                              height: 178.h,
                              child: InkWell(
                                  onTap: () async {
                                    if (_deviceInfoController
                                        .loacalDevice.value.isconnected) {
                                      bool issend = await divConfirmDialog(
                                          context,
                                          isSubmitButton: true,
                                          confirmTitle: tr(
                                              "device.controltDialog.confirmTitle"),
                                          confirmDescriptionWidget:
                                              SingleChildScrollView(
                                            child: Container(
                                                width: 560.w,
                                                height: 80,
                                                padding: EdgeInsets.fromLTRB(
                                                    24.w, 24.w, 24.w, 0),
                                                child: Text.rich(
                                                    textAlign: TextAlign.center,
                                                    TextSpan(
                                                        style:
                                                            normalTextBlack(),
                                                        text: tr(
                                                            'loacalDevice.disconnected')))),
                                          ));
                                      if (issend) {
                                        _deviceInfoController.stopPolling();
                                      }
                                    } else {
                                      if (_deviceInfoController
                                          .isPolling.value) {
                                        _deviceInfoController
                                            .ProtocolHandlerStop();
                                      } else {
                                        widget.onStart();
                                      }
                                    }
                                  },
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Opacity(
                                            opacity: _deviceInfoController
                                                    .loacalDevice
                                                    .value
                                                    .isconnected
                                                ? 1
                                                : 0.6, // 设置不透明度为 50%
                                            child: Image.asset(
                                              imageTurn(),
                                              height: 178.h,
                                            )),
                                      ),
                                      if (_deviceInfoController
                                              .isPolling.value &&
                                          !_deviceInfoController
                                              .loacalDevice.value.isconnected)
                                        AnimatedBuilder(
                                          animation: _animation,
                                          builder: (context, child) {
                                            return Positioned(
                                              bottom: 8.5,
                                              left: 62,
                                              width: 128.w,
                                              height: _animation.value *
                                                  150.h, // 蒙层高度在 0 到 100 之间变化
                                              child: Container(
                                                color: Colors.white.withOpacity(
                                                    0.4), // 半透明白色蒙层
                                              ),
                                            );
                                          },
                                        ),
                                    ],
                                  )),
                            ),
                            if (_deviceInfoController
                                .loacalDevice.value.isconnected)
                              SizedBox(
                                  width: (656.w - 348.w - paddingLR * 2) / 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          if (_deviceInfoController.loacalDevice
                                                  .value.isconnected &&
                                              modeMap[_deviceInfoController
                                                      .loacalDevice
                                                      .value
                                                      .runningModel] !=
                                                  null)
                                            Image.asset(
                                              'public/images/icon/${modeMap[_deviceInfoController.loacalDevice.value.runningModel]!['key']}.png',
                                              width: 48.w,
                                              color: Colors.white,
                                            ),
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 4.h)),
                                          if (_deviceInfoController.loacalDevice
                                                  .value.isconnected &&
                                              modeMap[_deviceInfoController
                                                      .loacalDevice
                                                      .value
                                                      .runningModel] !=
                                                  null)
                                            SizedBox(
                                              height: 33.h,
                                              child: Center(
                                                child: Text(
                                                        '${_deviceInfoController.loacalDevice.value.isconnected ? _deviceInfoController.loacalDevice.value.runningModel : '--'}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: versionValue(
                                                            context))
                                                    .tr(),
                                              ),
                                            )
                                        ],
                                      ),
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              0, 0, 0, 30.h)),
                                      InkWell(
                                          onTap: () async {
                                            if (_deviceInfoController
                                                .loacalDevice
                                                .value
                                                .isconnected) {
                                              bool issend = await divConfirmDialog(
                                                  context,
                                                  isSubmitButton: true,
                                                  confirmTitle: tr(
                                                      "device.controltDialog.confirmTitle"),
                                                  confirmDescriptionWidget:
                                                      Container(
                                                    width: 560.w,
                                                    height: 80,
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            24.w,
                                                            24.w,
                                                            24.w,
                                                            0),
                                                    child: Text.rich(
                                                        textAlign:
                                                            TextAlign.center,
                                                        TextSpan(
                                                            style:
                                                                normalTextBlack(),
                                                            text: tr(
                                                                'loacalDevice.disconnected'))),
                                                  ));
                                              if (issend) {
                                                _deviceInfoController
                                                    .stopPolling();
                                              }
                                            } else {
                                              if (_deviceInfoController
                                                  .isPolling.value) {
                                                _deviceInfoController
                                                    .ProtocolHandlerStop();
                                              } else {
                                                widget.onStart();
                                              }
                                            }
                                          },
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                'public/images/icon/${_deviceInfoController.loacalDevice.value.isconnected ? 'connected' : 'disconnected'}.png',
                                                width: 48.w,
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 4.h)),
                                              SizedBox(
                                                height: 33.h,
                                                child: Center(
                                                  child: Text(
                                                          _deviceInfoController
                                                                  .loacalDevice
                                                                  .value
                                                                  .isconnected
                                                              ? 'connected'
                                                              : 'disconnected',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: versionValue(
                                                              context))
                                                      .tr(),
                                                ),
                                              )
                                            ],
                                          ))
                                    ],
                                  )),
                          ],
                        ))),
                if (!_deviceInfoController.loacalDevice.value.isconnected)
                  Positioned(
                    bottom: 20,
                    left: (656.w - 280.w) / 2,
                    child: GestureDetector(
                        onTap: () async {
                          if (_deviceInfoController
                              .loacalDevice.value.isconnected) {
                            bool issend = await divConfirmDialog(context,
                                isSubmitButton: true,
                                confirmTitle:
                                    tr("device.controltDialog.confirmTitle"),
                                confirmDescriptionWidget: SingleChildScrollView(
                                  child: Container(
                                      width: 560.w,
                                      height: 80,
                                      padding: EdgeInsets.fromLTRB(
                                          24.w, 24.w, 24.w, 0),
                                      child: Text.rich(
                                          textAlign: TextAlign.center,
                                          TextSpan(
                                              style: normalTextBlack(),
                                              text: tr(
                                                  'loacalDevice.disconnected')))),
                                ));
                            if (issend) {
                              _deviceInfoController.stopPolling();
                            }
                          } else {
                            if (_deviceInfoController.isPolling.value) {
                              _deviceInfoController.ProtocolHandlerStop();
                            } else {
                              widget.onStart();
                            }
                          }
                        },
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20), // 圆角
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromRGBO(174, 203, 247, 0.8),
                                  Color.fromRGBO(255, 255, 255, 0.8),
                                  Color.fromRGBO(174, 203, 247, 0.8),
                                ],
                                stops: [0.0, 0.5, 1.0], // 渐变的停止位置
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              border: Border.all(
                                  color: Colors.white, width: 0.5 // 边框宽度
                                  ),
                            ),
                            width: 280.w,
                            height: 58.h,
                            child: Center(
                              child: Text(
                                _deviceInfoController.isPolling.value
                                    ? "afterSalesReplacement.connectStepButton.doing"
                                    : "afterSalesReplacement.connectStepButton",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(0, 128, 255, 1)),
                              ).tr(),
                            ),
                          ),
                        )),
                  ),
              ]),
            ));
  }
}
