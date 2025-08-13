import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/view/cloud/device/style.dart';
import 'package:fluoroscopy_tool/waterpumb/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class productSelect extends StatefulWidget {
  productSelect({super.key});

  @override
  State<productSelect> createState() => _productSelectState();
}

class _productSelectState extends State<productSelect> {
  List type = ["多联机", "水冷机组"];

  final waterpumbInfoController _deviceInfoController =
      Get.put(waterpumbInfoController());
  @override
  void initState() {
    super.initState();
    getMeid();
    getDeviceSn();
  }

  static const _selfplatform = MethodChannel('samples.flutter.dev/BackClip');
  getDeviceSn() async {
    try {
      var historyback = await _selfplatform.invokeMethod('getDeviceSn', {});
      var historydata = jsonDecode(historyback);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('deviceSn', "${historydata['data']}");
      print("getDeviceSn historydata： ${historydata['data']}");
    } catch (e) {}
  }

  Future<String?> getMeid() async {
    return '';
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    try {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;

      // 在Android 10及更高版本中，需要使用buildId
      if (androidInfo.version.sdkInt >= 29) {
        // 打印基本设备信息
        print('设备信息:');
        print('• 品牌: ${androidInfo.brand}');
        print('• 型号: ${androidInfo.model}');
        print('• 制造商: ${androidInfo.manufacturer}');
        print('• 产品: ${androidInfo.product}');
        print('• 硬件: ${androidInfo.hardware}');

        // 打印Android版本信息
        print('\nAndroid 版本:');
        print('• SDK 版本: ${androidInfo.version.sdkInt}');
        print('• 发布版本: ${androidInfo.version.release}');
        print('• 安全补丁: ${androidInfo.version.securityPatch}');
        print('• 增量版本: ${androidInfo.version.incremental}');

        // 打印设备标识符
        print('\n设备标识符:');
        print('• Android ID: ${androidInfo.id}'); // 推荐使用的设备标识符

        // 打印设备特性
        print('\n设备特性:');
        print('• 是否物理设备: ${androidInfo.isPhysicalDevice}');
        print('• 系统特性: ${androidInfo.systemFeatures.join(', ')}');
        return androidInfo.id; // 返回buildId作为设备标识符
      } else {}
    } catch (e) {
      print('获取设备信息失败: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 1280.h,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('public/images/login/bg.png'),
                fit: BoxFit.fill)),
        child: SingleChildScrollView(
            child: Column(children: [
          // const Padding(
          //   padding: EdgeInsets.fromLTRB(0, 87, 0, 51),
          //   child: Text(
          //     "产品系列",
          //     style: TextStyle(
          //         fontSize: 18,
          //         fontWeight: FontWeight.w500,
          //         color: Color.fromRGBO(13, 13, 13, 1)),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 70, 0, 40),
            child: Image.asset(
              'public/images/productSelect.png',
              width: 252.w,
            ),
          ),
          for (var typeitem in type)
            InkWell(
              onTap: () async {
                if (typeitem == "多联机") {
                  Get.offAllNamed('/home');
                } else {
                  try {
                    var back =
                        await _deviceInfoController.applicationSwitching();
                    print("applicationSwitching_ $back");
                  } catch (e) {
                    print("applicationSwitching_ $e");
                  }
                  Get.offAllNamed('/warterpumbIndex');
                }
              },
              child: Container(
                width: 720.w - 100,
                height: 100,
                decoration: cardStyleFull(context),
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 14),
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                      child: Image.asset(
                        'public/images/prowaterpumb/${typeitem == "多联机" ? "fuji" : "shuiji"}.png',
                        width: 120.w,
                      ),
                    ),
                    Text(
                      typeitem,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(13, 13, 13, 1)),
                    ),
                  ],
                ),
              ),
            )
        ])));
  }
}
