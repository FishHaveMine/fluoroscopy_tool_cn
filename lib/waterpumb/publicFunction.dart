/*
 * @Author: FishHaveMine 751174479@qq.com
 * @Date: 2024-06-03 10:33:10
 * @LastEditors: FishHaveMine 751174479@qq.com
 * @LastEditTime: 2024-06-11 14:11:05
 * @FilePath: /fluoroscopy_tool/lib/view/local/publicFunction.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
/*
 * @Author: FishHaveMine 751174479@qq.com
 * @Date: 2024-06-03 10:33:10
 * @LastEditors: FishHaveMine 751174479@qq.com
 * @LastEditTime: 2024-06-08 14:18:14
 * @FilePath: /fluoroscopy_tool/lib/view/local/class.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */

// ignore: depend_on_referenced_packages
import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../view/class/deviceInfo.dart';

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

class WaterMachineDTO {
  final String sn;
  final String year;
  final String month;
  final String date;
  final String locks;
  final String dynamicPassword;
  final String random;
  final String version;
  final String address1281;
  final String address10;

  WaterMachineDTO({
    this.sn = '',
    this.year = '',
    this.month = '',
    this.date = '',
    this.locks = '',
    this.dynamicPassword = '',
    this.random = '',
    this.version = '',
    this.address1281 = '',
    this.address10 = '',
  });

  factory WaterMachineDTO.fromJson(Map<String, dynamic> json) {
    String _toString(dynamic value) => value?.toString() ?? '';

    return WaterMachineDTO(
      sn: _toString(json['sn']),
      year: _toString(json['year']),
      month: _toString(json['month']),
      date: _toString(json['date']),
      locks: _toString(json['locks']),
      dynamicPassword: _toString(json['dynamicPassword']),
      random: _toString(json['random']),
      version: _toString(json['version']),
      address1281: _toString(json['address1281']),
      address10: _toString(json['address10']),
    );
  }

  WaterMachineDTO copyWith({
    String? sn,
    String? year,
    String? month,
    String? date,
    String? locks,
    String? dynamicPassword,
    String? random,
    String? version,
    String? address1281,
    String? address10,
  }) {
    return WaterMachineDTO(
      sn: sn ?? this.sn,
      year: year ?? this.year,
      month: month ?? this.month,
      date: date ?? this.date,
      locks: locks ?? this.locks,
      dynamicPassword: dynamicPassword ?? this.dynamicPassword,
      random: random ?? this.random,
      version: version ?? this.version,
      address1281: address1281 ?? this.address1281,
      address10: address10 ?? this.address10,
    );
  }
}

class waterpumbInfoController extends GetxController {
  RxBool isConnected = false.obs;
  void set_isConnected(val) {
    isConnected.value = val ?? false;
    update();
  }

  static const platform =
      MethodChannel('samples.flutter.dev/waterpumbBasicHandler');
  Timer? _timerisPolling;
  Rx<WaterMachineDTO> loacalDevice = WaterMachineDTO().obs;

  @override
  void onInit() {
    super.onInit();
    _setupMethodChannel();
  }

  @override
  void onClose() {
    super.onClose();
    if (_timerisPolling != null) {
      _timerisPolling?.cancel();
    }
  }

  startPolling() {
    if (_timerisPolling != null) {
      _timerisPolling?.cancel();
    }
    _timerisPolling = Timer.periodic(const Duration(seconds: 2),
        (timer) => platform.invokeMethod('getWaterMachineDTO'));
  }

  applicationSwitching() async {
    return await platform.invokeMethod('applicationSwitching');
  }

  stopPolling() {
    loacalDevice.value = WaterMachineDTO.fromJson({});
    platform.invokeMethod('clearInstance');
    if (_timerisPolling != null) {
      _timerisPolling?.cancel();
    }
  }

  clearloacalDevice() {
    print("clearloacalDevice");
    loacalDevice.value = WaterMachineDTO.fromJson({});
    update();
  }

  void _setupMethodChannel() {
    platform.setMethodCallHandler((call) async {
      print("_setupMethodChannel:" + call.arguments);
      try {
        var arguments = jsonDecode(call.arguments);
        loacalDevice.value = WaterMachineDTO.fromJson(arguments);

        EasyLoading.dismiss();
        update();
      } catch (e) {
        print("_setupMethodChannel error:" + e.toString());
      }
    });
  }
}
