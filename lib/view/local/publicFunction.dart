/*
 * @Author: FishHaveMine 751174479@qq.com
 * @Date: 2024-06-03 10:33:10
 * @LastEditors: FishHaveMine 751174479@qq.com
 * @LastEditTime: 2024-06-11 14:11:05
 * @FilePath: /fluoroscopy_tool/lib/view/local/publicFunction.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */

import 'dart:async';
import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/class/deviceInfo.dart';
import 'package:fluoroscopy_tool/view/electronicExpansionValve/line_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../compent/tap_handler_page.dart';
import 'checkData/class.dart';
import 'style.dart';

/// 定义本地连接之后的数据对象、然后定时刷新数据并推送到其他页面

// v8协议的系统-运行模式有这几种
//     RunMode_0("RunMode_0", 0, "关机"),
//     RunMode_1("RunMode_1", 1, "送风免费制冷"),
//     RunMode_2("RunMode_2", 2, "制冷热交换"),
//     RunMode_3("RunMode_3", 3, "制热旁通"),
//     RunMode_4("RunMode_4", 4, "强制制冷"),
//     RunMode_5("RunMode_5", 5, "清爽"),
//     RunMode_6("RunMode_6", 6, "除湿排风"),
//     RunMode_10("RunMode_10", 10, "制热水"),
//     RunMode_11("RunMode_11", 11, "制冷水"),
//     RunMode_12("RunMode_12", 12, "采暖"),
//     RunMode_13("RunMode_13", 13, "制冷制热水"),
//     RunMode_14("RunMode_14", 14, "制热制热水"),
//     RunMode_15("RunMode_15", 15, "采暖制热水"),
//     RunMode_16("RunMode_16", 16, "电加热模式"),
//     RunMode_29("RunMode_29", 29, "主制冷"),
//     RunMode_30("RunMode_30", 30, "主制热");

// v6协议的系统-运行模式有这几种
//     RunMode_0("RunMode_0", 0, "关机"),
//     RunMode_1("RunMode_1", 1, "送风"),
//     RunMode_2("RunMode_2", 2, "制冷"),
//     RunMode_3("RunMode_3", 3, "制热"),
//     RunMode_4("RunMode_4", 4, "强制制冷"),
//     RunMode_5("RunMode_5", 5, "主制冷"),
//     RunMode_6("RunMode_6", 6, "主制热");
var modeMap = {
  1: {'name': "cooling", "key": "icon_cool"},
  2: {'name': "heating", "key": "icon_hot"},
  3: {'name': "ventilation", "key": "icon_wind"},
  4: {'name': "dry", "key": "icon_dry"},
  5: {'name': "auto", "key": "icon_auto"},
  "制冷": {'name': "制冷", "key": "icon_cool"},
  "送风免费制冷": {'name': "送风免费制冷", "key": "icon_cool"},
  "除湿排风": {'name': "除湿排风", "key": "icon_wind"},
  "制冷热交换": {'name': "制冷热交换", "key": "icon_cool"},
  "电加热模式": {'name': "电加热模式", "key": "icon_hot"},
  "制热水": {'name': "制热水", "key": "icon_hot"},
  "制冷制热水": {'name': "制冷制热水", "key": "icon_cool"},
  "制热制热水": {'name': "制热制热水", "key": "icon_hot"},
  "采暖": {'name': "采暖", "key": "icon_hot"},
  "制冷水": {'name': "制冷水", "key": "icon_cool"},
  "主制冷": {'name': "主制冷", "key": "icon_cool"},
  "主制热": {'name': "主制热", "key": "icon_hot"},
  "清爽": {'name': "清爽", "key": "icon_wind"},
  "强制制冷": {'name': "强制制冷", "key": "icon_cool"},
  "关机": {'name': "关机", "key": "icon_off"},
  "制热旁通": {'name': "制热旁通", "key": "icon_hot"},
  "送风": {'name': "送风", "key": "icon_cool"},
  "制热": {'name': "制热", "key": "icon_hot"},
  "除湿": {'name': "除湿", "key": "icon_cool"},
  "采暖制热水": {'name': "采暖制热水", "key": "icon_hot"},
  "自动模式": {'name': "自动模式", "key": "icon_cool"},
};

bool _isgetConnectionback = false;

bool _isProtocolHandlerStoping = false;

bool _isreconnect = true;

class deviceInfoController extends GetxController {
  RxBool isGettingSuccess = false.obs;
  RxBool isgetConnectionback = false.obs;

  void set_isgetConnectionback(val) {
    isgetConnectionback.value = val ?? false;
    update();
  }

  RxBool isCreateSHARE = false.obs;
  void set_isCreateSHARE(val) {
    isCreateSHARE.value = val;
    update();
  }

  //本地连接设备类型
  // ODU(0)
  // IDU(1)
  // SYS(2)
  RxInt deviceTypeEnum = 3.obs;
  void set_deviceTypeEnum(val) {
    deviceTypeEnum.value = val;
    update();
  }

  RxString updateTime = ''.obs;
  Rx<deviceInfo> loacalDevice = deviceInfo(
          sn: '--',
          machine: '--',
          version: '--',
          model: '--',
          ODU: 0,
          IDU: 0,
          totalMatches: 0,
          matchingNumber: 0,
          runningModel: '--',
          isconnected: false,
          errorCode: '--')
      .obs;
  var systemEntity = {}.obs;
  RxList<dynamic> outdoorEntityList = [].obs;
  RxList<dynamic> indoorEntityList = [].obs;
  void set_systemEntity(val) {
    systemEntity.value = val;
    update();
  }

  void set_outdoorEntityList(val) {
    outdoorEntityList.value = val;
    update();
  }

  void set_indoorEntityList(val) {
    indoorEntityList.value = val;
    update();
  }

  void set_loacalDevice(val) {
    isGettingSuccess.value = true;
    loacalDevice.value = deviceInfo.fromJson(val);
    updateTime.value = DateTime.now().toString();
    update();
  }

  String checkstring(val) {
    return val == null ? '--' : val;
  }

  int checkint(val) {
    return val == null ? 0 : val;
  }

  void setSN(sn) {
    loacalDevice.value.sn = checkstring(sn);
    update();
  }

  void setmachine(sn) {
    loacalDevice.value.machine = checkstring(sn);
    update();
  }

  void setVersion(version) {
    loacalDevice.value.version = checkstring(version);
    update();
  }

  void setModel(model) {
    loacalDevice.value.model = checkstring(model);
    update();
  }

  void setODU(odu) {
    loacalDevice.value.ODU = checkint(odu);
    update();
  }

  void setIDU(idu) {
    loacalDevice.value.IDU = checkint(idu);
    update();
  }

  void setTotalMatches(totalMatches) {
    loacalDevice.value.totalMatches = totalMatches;
    update();
  }

  void setMatchingNumber(matchingNumber) {
    loacalDevice.value.matchingNumber = matchingNumber;
    update();
  }

  void setRunningModel(runningModel) {
    loacalDevice.value.runningModel = checkstring(runningModel);
    update();
  }

  bool isconnectedBefore = false;
  Future<void> setIsConnected(isConnected) async {
    loacalDevice.value.isconnected = isConnected;
    update();
  }

  void setErrorCode(errorCode) {
    loacalDevice.value.errorCode = errorCode ?? "0";
    update();
  }

  void clean_loacalDevic() {
    systemEntity.value = {};
    outdoorEntityList.value = [];
    indoorEntityList.value = [];
    loacalDevice.value.sn = '--';
    loacalDevice.value.machine = '--';
    loacalDevice.value.version = '--';
    loacalDevice.value.model = '--';
    loacalDevice.value.ODU = 0;
    loacalDevice.value.IDU = 0;
    loacalDevice.value.totalMatches = 0;
    loacalDevice.value.matchingNumber = 0;
    loacalDevice.value.runningModel = '--';
    loacalDevice.value.isconnected = false;
    loacalDevice.value.errorCode = '0';
    isGettingSuccess.value = false;
    update();
  }

/** ----------------------  冷媒自动充注 属性 */
  RxString deviceProtocol = "".obs;
  setDeviceProtocol(val) {
    print("deviceProtocol: $val");
    deviceProtocol.value = val;
    update();
  }

  RxBool canauto = true.obs; //是否满足充注条件 （4G模块下、无4G模块默认true）
  setCanAuto(val) {
    canauto.value = val;
    update();
  }

  RxString subCooling = ''.obs;
  setSubCooling(val) {
    subCooling.value = val ?? "";
    update();
  }

  RxString systemOperation = ''.obs;
  setSystemOperation(val) {
    systemOperation.value = val ?? "";
    update();
  }

  RxString t2aAvg = ''.obs;
  setT2aAvg(val) {
    t2aAvg.value = val ?? "";
    update();
  }
/**   冷媒自动充注 属性 ---------------------- */

  Rx<deviceInfo> settingDevice = deviceInfo(
          sn: '--',
          machine: '--',
          version: '--',
          model: '--',
          ODU: 0,
          IDU: 0,
          totalMatches: 0,
          matchingNumber: 0,
          runningModel: '--',
          isconnected: false,
          errorCode: '--')
      .obs;

  RxList<dynamic> settingIndoorEntityList = [].obs;
  void set_settingDevice(val) {
    settingDevice.value = deviceInfo.fromJson(val);
    update();
  }

  void set_settingIndoorEntityList(val) {
    settingIndoorEntityList.value = val;
    update();
  }

  final MethodChannel methodChannel =
      const MethodChannel('sample.channel.data');

  static const bluetoothplatform =
      MethodChannel('samples.flutter.dev/MSInterface');

  MethodChannel bluetoothmethodChannel =
      const MethodChannel('sample.channel.MsInterface');

  RxString bluetoothmac = "".obs;
  RxString bluetoothtoken = "".obs;
  RxList msBleScanInfos = [].obs; //蓝牙设备列表

  static const MSInterfaceplatform =
      MethodChannel('samples.flutter.dev/MSInterface');

  setLocalBluetoothConnect(isBluetoothConnect) async {
    try {
      var _toolUnlock = await MSInterfaceplatform.invokeMethod(
          'isBluetoothConnect',
          <String, dynamic>{"isBluetoothConnect": isBluetoothConnect});
      return _toolUnlock;
    } on PlatformException catch (_, e) {
      print(" setLocalBluetoothConnect:   $e");
    }
  }

  static const McuUtilplatform = MethodChannel('samples.flutter.dev/McuUtil');
  static const platform = MethodChannel('samples.flutter.dev/battery');
  static const _selfplatform =
      MethodChannel('samples.flutter.dev/RefrigerantService');

  RxBool isPolling = false.obs;
  RxBool isPollingBack = false.obs;
  RxBool isBluetooth = false.obs; //是否使用蓝牙连接

  setbluetoothtoken(val) {
    bluetoothtoken.value = val;
    update();
  }

  setbluetoothmac(val) {
    bluetoothmac.value = val;
    update();
  }

  setmsBleScanInfos(val) {
    msBleScanInfos.value = val;
    update();
  }

  setIsBluetooth(val) {
    isBluetooth.value = val;
    update();
  }

  setIsPolling(val) {
    isPolling.value = val;
    update();
  }

  setIsPollingBack(val) {
    if (val) {
      EasyLoading.showSuccess(tr("ispollingback.finish"));
    }
    isPollingBack.value = val;
    update();
  }

  checkisPollingBack() {
    if (!isPollingBack.value) {
      EasyLoading.showError(tr("ispollingback"));
      throw Error();
    }
  }

  Timer? _timerisPolling;
  DateTime startTime = DateTime.now();
  // 模拟加载数据
  startPolling() async {
    startTime = DateTime.now();
    await McuUtilplatform.invokeMethod('powerOff');
    await Future.delayed(const Duration(seconds: 1));
    if (_isProtocolHandlerStoping) {
      return;
    }
    await McuUtilplatform.invokeMethod('powerOn');
    print(
        "----------  startPolling  ----------   isPolling: ${isPolling.value}    _isgetConnectionback:${_isgetConnectionback}");
    if (isPolling.value) {
      try {
        _timerisPolling?.cancel();
        await platform.invokeMethod('stopPolling', <String, dynamic>{});
      } catch (e) {}
    }
    try {
      var getConnection = await platform.invokeMethod('getConnection');
      var data = jsonDecode(getConnection);
      _isgetConnectionback = data["data"];
      print("try to getConnection: $data");
      set_isgetConnectionback(data["data"]);
      if (!data["success"]) {
        EasyLoading.showError(data["errorMsg"]);
        await McuUtilplatform.invokeMethod('powerOff');
        return;
      } else {
        EasyLoading.showSuccess(tr("getConnection"));
      }
    } catch (e) {
      _isgetConnectionback = false;
      return;
    }

    setIsPollingBack(false);

    try {
      platform.invokeMethod('startPolling').then(
          (val) => {print("startPolling back: $val"), setIsPollingBack(true)});
      if (_timerisPolling != null) {
        _timerisPolling?.cancel();
      }
      _timerisPolling = Timer.periodic(const Duration(seconds: 2),
          (timer) => platform.invokeMethod('getPolling'));
      setIsPolling(true);

      await platform.invokeMethod('disableAutoSleep', <String, dynamic>{});
      EasyLoading.showSuccess(tr("startPolling"));
      // var data = jsonDecode(iscon);
      // print("startPolling: $data");
      // if (data["success"]) {
      //   EasyLoading.showSuccess(tr('load.success'));
      //   if (_timerisPolling != null) {
      //     _timerisPolling?.cancel();
      //   }
      //   _timerisPolling = Timer.periodic(const Duration(seconds: 2),
      //       (timer) => platform.invokeMethod('getPolling'));
      //   setIsPolling(true);
      // } else {
      //   EasyLoading.showError(iscon['errorMsg']);
      // }
      // EasyLoading.dismiss();
      // EasyLoading.showSuccess(tr('load.success'));
    } catch (e) {
      //   EasyLoading.dismiss();
      EasyLoading.showError("$e");
    }
  }

  stopPolling() async {
    final currentTime = DateTime.now();
    final difference = currentTime.difference(startTime);
    print("difference.inSeconds: ${difference.inSeconds}");
    if (difference.inSeconds >= 5) {
      print("------------------   stopPolling   --------------");
      setIsPolling(false);
      await platform.invokeMethod('stopPolling', <String, dynamic>{});
      clean_loacalDevic();
      await platform.invokeMethod('enableAutoSleep', <String, dynamic>{});
      _timerisPolling?.cancel();
      McuUtilplatform.invokeMethod('powerOff');
      isconnectedBefore = false;
      print("------------------  powerOff   --------------");
    }
    if (isBluetooth.value) {
      bluetoothplatform.invokeMethod('disconnectBlueConnection', {});
    }
  }

  // ignore: non_constant_identifier_names
  ProtocolHandlerStop() async {
    if (isBluetooth.value) {
      return;
    }
    final currentTime = DateTime.now();
    final difference = currentTime.difference(startTime);

    print("difference.inSeconds: ${difference.inSeconds}");
    if (difference.inSeconds >= 5) {
      EasyLoading.show(status: 'loading...', dismissOnTap: false);
      _isProtocolHandlerStoping = true;
      try {
        print("------------------   ProtocolHandlerStop   --------------");
        await platform.invokeMethod('ProtocolHandlerStop', <String, dynamic>{});
        await McuUtilplatform.invokeMethod('powerOff');

        await platform.invokeMethod('enableAutoSleep', <String, dynamic>{});
        setIsPolling(false);
        clean_loacalDevic();
        setIsConnected(false);
        _timerisPolling?.cancel();
        isconnectedBefore = false;
        Future.delayed(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
          _isProtocolHandlerStoping = false;
        });
      } catch (e) {
        EasyLoading.dismiss();
        _isProtocolHandlerStoping = false;
      }
      print("------------------   powerOff   --------------");
    }
  }

  @override
  void onInit() {
    super.onInit();
    _setupBluetoothmethodChannel();
    _setupMethodChannel();
  }

  _setupBluetoothmethodChannel() {
    print('bluetoothmethodChannel: setupBluetoothmethodChannel');
    try {
      bluetoothmethodChannel.setMethodCallHandler(null);
    } catch (e) {}
    bluetoothmethodChannel = const MethodChannel('sample.channel.MsInterface');

    bluetoothmethodChannel.setMethodCallHandler((call) async {
      print('bluetoothmethodChannel: ${loacalDevice.value.isconnected} $call');
      if (call.method == 'connectSuccess') {
        // setIsConnected(true);
      }

      if (call.method == 'connectFail' ||
          call.method == 'connectError' ||
          call.method == 'overtiem') {
        setIsBluetooth(false);
        if (loacalDevice.value.isconnected) {
          Get.defaultDialog(
            title: tr("device.checkdatacontroller.confirmtitle"),
            titleStyle: normalTextBlack(fSize: 18),
            middleText: tr("device.connectdialog.isbluetootherror"),
            onConfirm: () async {
              final prefs = await SharedPreferences.getInstance();
              bool _hasLogin = prefs.getString('token') != null;
              if (_hasLogin) {
                Get.offAllNamed('/home');
              } else {
                Get.offAllNamed('/login');
              }
            },
            confirm: InkWell(
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                bool _hasLogin = prefs.getString('token') != null;
                if (_hasLogin) {
                  Get.offAllNamed('/home');
                } else {
                  Get.offAllNamed('/login');
                }
              },
              child: Container(
                // ignore: prefer_const_constructors
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1CA2FF), Color(0xFF0080FF)],
                    stops: [0.0, 1.0],
                    transform: GradientRotation(115 * (3.1415926 / 180.0)),
                  ),
                ),
                child: Center(
                  child: const Text(
                    "determine",
                    style: TextStyle(color: Colors.white),
                  ).tr(),
                ),
              ),
            ),
            cancel: null, // 通过设置 cancel 为 null 来隐藏取消按钮
          );
          setbluetoothmac("");
        }
        setIsConnected(false);
        _isProtocolHandlerStoping = false;
        stopPolling();
      }
      if (call.method == 'startScan') {
        msBleScanInfos.value.add(json.decode(call.arguments));
        update();
      }
    });
  }

  void _setupMethodChannel() {
    methodChannel.setMethodCallHandler((call) async {
      if (call.method == 'monitorData') {
        var arguments = jsonDecode(call.arguments);
        print("monitorData: $arguments");
        try {
          print(
              "arguments['linkStatus']:   ${arguments['linkStatus']}  ${isconnectedBefore}");

          if (arguments['linkStatus'] != null) {
            if (arguments['linkStatus']) {
              isconnectedBefore = true;
            }
            if (arguments['linkStatus'] == false && isconnectedBefore) {
              isconnectedBefore = false;

              if (_isreconnect) {
                Get.defaultDialog(
                  title: tr("device.checkdatacontroller.confirmtitle"),
                  titleStyle: normalTextBlack(fSize: 18),
                  middleText: tr("device.connectdialog.error"),
                  onConfirm: () {
                    // Get.offAllNamed('/home'); //
                  },
                  confirm: InkWell(
                    onTap: () async {
                      /**
                     * 判断是非在登录中
                     */
                      final prefs = await SharedPreferences.getInstance();
                      bool _hasLogin = prefs.getString('token') != null;
                      if (_hasLogin) {
                        Get.offAllNamed('/home');
                      } else {
                        Get.offAllNamed('/login');
                      }
                    },
                    child: Container(
                      // ignore: prefer_const_constructors
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF1CA2FF), Color(0xFF0080FF)],
                          stops: [0.0, 1.0],
                          transform:
                              GradientRotation(115 * (3.1415926 / 180.0)),
                        ),
                      ),
                      child: Center(
                        child: const Text(
                          "determine",
                          style: TextStyle(color: Colors.white),
                        ).tr(),
                      ),
                    ),
                  ),
                  cancel: null, // 通过设置 cancel 为 null 来隐藏取消按钮
                );
              }

              ProtocolHandlerStop();
              setIsConnected(false);
              clean_loacalDevic();
              stopPolling();
            }
            setIsConnected(arguments['linkStatus']);
          } else {
            if (isBluetooth.value) {
              return;
            }
            if (isconnectedBefore) {
              if (_isreconnect) {
                Get.defaultDialog(
                  title: tr("device.checkDataController.confirmTitle"),
                  titleStyle: normalTextBlack(fSize: 18),
                  middleText: tr("device.connectDialog.error"),
                  onConfirm: () {
                    // Get.offAllNamed('/home'); //
                  },
                  confirm: InkWell(
                    onTap: () async {
                      /**
                     * 判断是非在登录中
                     */
                      final prefs = await SharedPreferences.getInstance();
                      bool _hasLogin = prefs.getString('token') != null;
                      if (_hasLogin) {
                        Get.offAllNamed('/home');
                      } else {
                        Get.offAllNamed('/login');
                      }
                    },
                    child: Container(
                      // ignore: prefer_const_constructors
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF1CA2FF), Color(0xFF0080FF)],
                          stops: [0.0, 1.0],
                          transform:
                              GradientRotation(115 * (3.1415926 / 180.0)),
                        ),
                      ),
                      child: Center(
                        child: const Text(
                          "determine",
                          style: TextStyle(color: Colors.white),
                        ).tr(),
                      ),
                    ),
                  ),
                  cancel: null, // 通过设置 cancel 为 null 来隐藏取消按钮
                );
              }

              isconnectedBefore = false;
              setIsConnected(false);
              clean_loacalDevic();
              stopPolling();
            }
          }
          if (arguments['deviceTypeEnum'] != null) {
            set_deviceTypeEnum(arguments['deviceTypeEnum'] == 'SYS'
                ? 2
                : arguments['deviceTypeEnum'] == 'ODU'
                    ? 0
                    : 1);
          }
        } catch (e) {}
        if (arguments['linkStatus'] != null && arguments['linkStatus']) {
          try {
            if (arguments['mixRatio'] != null) {
              setMatchingNumber(arguments['mixRatio']);
            } //设置配比
            if (arguments['totalHorse'] != null) {
              setTotalMatches(arguments['totalHorse']);
            } //设置总匹数
          } catch (e) {}
          try {
            if (arguments['mode'] != null) {
              setRunningModel(arguments['mode']);
            }
          } catch (e) {}
          try {
            setSN(arguments['sn']);
            setmachine(arguments['machineType']);

            setErrorCode(arguments['errorCode']);

            setVersion(arguments['version']);
            setModel(arguments['protocol']);
            set_systemEntity(arguments['systemEntity']);
          } catch (e) {
            print(e);
          }
          setODU(arguments['outdoorEntityList'].length);

          set_outdoorEntityList(arguments['outdoorEntityList']);

          set_indoorEntityList(arguments['indoorEntityList']);
          setIDU(arguments['indoorEntityList'].length);
        } else if (call.method == 'getConnection') {
          print('getConnection : ${call.arguments}');
          // _deviceInfoController.setIsConnected(call.arguments != null);
        }
      }
    });
  }

  @override
  void onClose() {
    // Clean up if necessary
    methodChannel.setMethodCallHandler(null);
    bluetoothmethodChannel.setMethodCallHandler(null);
    super.onClose();
  }
}

bool checkIsConnect(context) {
  final deviceInfoController _deviceInfoController =
      Get.put(deviceInfoController());
  if (!_deviceInfoController.loacalDevice.value.isconnected) {
    divConfirmDialog(context,
        confirmTitle: tr("device.connectDialog.confirmTitle"),
        confirmText: tr("device.connectDialog.confirmText"),
        confirmDescriptionWidget: Container(
          width: 560.w,
          height: 200,
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr('device.connectDialog.content1'),
                  style: dialogTitle(context),
                ),
                Text(
                  tr('device.connectDialog.content2'),
                  style: dialogContent(context),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 20)),
                Text(
                  tr('device.connectDialog.content3'),
                  style: dialogTitle(context),
                ),
                Text(
                  tr('device.connectDialog.content4'),
                  style: dialogContent(context),
                ),
              ],
            ),
          )),
        ));
  }
  return _deviceInfoController.loacalDevice.value.isconnected;
}

Map<String, String> iduTypeMap = {
  "IduType_0": "老内机",
  "IduType_1": "环形出风Q4",
  "IduType_2": "G挂壁",
  "IduType_3": "自由静压T2",
  "IduType_4": "薄型风管机T2",
  "IduType_5": "美式风管机",
  "IduType_6": "T1高静压",
  "IduType_7": "环形出风Q4_",
  "IduType_8": "DL座吊",
  "IduType_9": "立式暗装",
  "IduType_10": "立式明装",
  "IduType_11": "新风机",
  "IduType_12": "一拖一",
  "IduType_13": "全热交换器",
  "IduType_14": "一面出风",
  "IduType_15": "两面出风",
  "IduType_16": "Console",
  "IduType_17": "高温水力模块",
  "IduType_18": "T3新风机",
  "IduType_19": "Clivet新风机",
  "IduType_20": "常温小风量新风机",
  "IduType_21": "独立控制盒",
  "IduType_22": "柜机",
  "IduType_23": "加湿器",
  "IduType_24": "独立控制盒_出风温度控制",
  "IduType_25": "小多联新风机",
  "IduType_26": "直棚机",
  "IduType_27": "低温水力模块",
  "IduType_28": "中温水力模块",
  "IduType_29": "采暖水力模块",
  "IduType_30": "直棚机_再热",
  "IduType_31": "烤烟内机",
  "IduType_32": "AT内机",
  "IduType_33": "卧式",
  "IduType_34": "制热水箱",
  "IduType_61": "ByPassKit",
  "IduType_62": "屋顶机",
};

Widget runningModelImage(val) {
  String imageUrl = 'auto@2x';
  switch (val) {
    case 'RunMode_0':
      imageUrl = 'icon_off';
      break;
    case 'RunMode_2':
      imageUrl = 'cooling@2x';
      break;
    case 'RunMode_7':
      imageUrl = 'auto@2x';
      break;
    case 'RunMode_6':
      imageUrl = 'dehumidify@2x';
      break;
    case 'RunMode_1':
      imageUrl = 'wind@2x';
      break;
    case 'RunMode_3':
      imageUrl = 'heating@2x';
      break;
    default:
      imageUrl = 'auto@2x';
  }
  return Image.asset(
    'public/images/${imageUrl == "icon_off" ? "icon" : "checkData"}/$imageUrl.png',
    width: 36.w,
    color: Colors.grey,
  );
}

List<String> lockItemTableColumns = [
  'lockOpen',
  'lockClose',
  'lockLineControl',
  'lockRemoteControl',
  'lockRunMode'
];
Widget lockItem(val) {
  return Image.asset(
    'public/images/checkData/${val ? 'lock@2x' : 'unlock@2x'}.png',
    width: 26.w,
  );
}

Widget handelTabelRow(val, key) {
  if (val == null) {
    return Text(
      '--',
      textAlign: TextAlign.center,
      style: tableValue(),
    );
  }
  if (key.toString().toUpperCase().contains("SN")) {
    return Text(
      val.toString().toUpperCase(),
      textAlign: TextAlign.center,
      style: tableValue(),
    );
  }

  if (val.toString().contains('RunMode_')) {
    return val.toString() != "RunMode_0"
        ? runningModelImage(val)
        : Text(
            val.toString() == 'null' ? '--' : '--',
            textAlign: TextAlign.center,
            style: tableValue(),
          );
  } else if (val.toString().contains('FanSpeed_')) {
    return Text(
      val.replaceAll('FanSpeed_', '') == '8'
          ? '自动风'
          : val.replaceAll('FanSpeed_', ''),
      textAlign: TextAlign.center,
      style: tableValue(),
    ).tr();
  } else if (val.toString().contains('IduType_')) {
    return Text(
      iduTypeMap[val.toString().replaceAll(' ', '')] ?? val,
      textAlign: TextAlign.center,
      style: tableValue(),
    ).tr();
  }
  if (lockItemTableColumns.contains(key)) {
    if (val.toString().contains('LockMode_')) {
      return Text(
        val,
        textAlign: TextAlign.center,
        style: tableValue(),
      ).tr();
    } else {
      return lockItem(val == "true");
    }
  } else {
    double? value = double.tryParse(val);
    return Text(
      (value != null
          ? value.toStringAsFixed(1)
          : val.toString() == 'null'
              ? '--'
              : tr(val.toString().toLowerCase().trim())),
      textAlign: TextAlign.center,
      style: tableValue(),
    );
  }
}

int _remainingSeconds = 30; //超时时间
late Timer _timer;
Future<void> setmission(timeclock, callback, next) async {
  // final deviceInfoController _deviceInfoController =
  //     Get.put(deviceInfoController());
  const platform = MethodChannel('samples.flutter.dev/battery');
  _remainingSeconds = timeclock;
  print("开启定时任务：$timeclock   $_remainingSeconds");

  callback();

  try {
    platform
        .invokeMethod('stopPolling', <String, dynamic>{}).then((value) => {});
    // _deviceInfoController.clean_loacalDevic();
  } catch (e) {}
  _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (_remainingSeconds > 0) {
      _remainingSeconds--;
      EasyLoading.showProgress(((timeclock - _remainingSeconds) / timeclock),
          status: tr('updatadownloading', namedArgs: {
            "val": (((timeclock - _remainingSeconds) / timeclock) * 100)
                .toStringAsFixed(1)
          }));
    } else {
      _timer.cancel();
      await platform.invokeMethod('startPolling', <String, dynamic>{});
      Future.delayed(const Duration(seconds: 3), () {
        EasyLoading.dismiss();
        next();
      });
    }
  });
}

void clearmission() {
  try {
    if (_timer != null) _timer.cancel();
  } catch (e) {}
}

imageTurn() {
  final deviceInfoController _deviceInfoController = Get.find();
  if (_deviceInfoController.loacalDevice.value.isconnected &&
      _deviceInfoController.deviceTypeEnum.value == 1) {
    return 'public/images/local/indoor.png';
  }
  if (_deviceInfoController.loacalDevice.value.isconnected &&
      _deviceInfoController.loacalDevice.value.model == 'V8') {
    return 'public/images/local/v8.png';
  }
  if (!_deviceInfoController.loacalDevice.value.isconnected ||
      (_deviceInfoController.loacalDevice.value.isconnected &&
          _deviceInfoController.loacalDevice.value.model == 'V8')) {
    return 'public/images/local/outdoor.png';
  }
  return 'public/images/local/outdoor.png';
}
