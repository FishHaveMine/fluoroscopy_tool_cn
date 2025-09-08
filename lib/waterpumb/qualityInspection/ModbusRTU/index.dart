import 'package:fluoroscopy_tool/waterpumb/qualityInspection/ModbusRTU/public/wifiList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../style/index.dart';
import '../deviceGatewayController.dart';
import 'gaywayQuery.dart';

class modbusRTUPage extends StatefulWidget {
  modbusRTUPage({super.key});

  @override
  State<modbusRTUPage> createState() => _modbusRTUPageState();
}

class _modbusRTUPageState extends State<modbusRTUPage> {
  DeviceGatewayController con = Get.put(DeviceGatewayController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF8AA9EE),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.chevron_left,
                  color: Colors.black, size: 36)),
          title: const Text(
            'ModbusRTU通讯调试工具',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          actions: [],
        ),
        body: Container(
          width: 720.w,
          height: 1280.h,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, // 对应180deg
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF8AA9EE), // #8AA9EE 1%
                Color(0xFFF2F2F2), // #F2F2F2 47%
                Color(0xFFF2F2F2), // #F2F2F2 98%
              ],
              stops: [0.01, 0.47, 0.98], // 对应百分比位置
            ),
          ),
          padding: EdgeInsets.fromLTRB(32.w, 64.h, 32.w, 64.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                  onTap: () {
                    Get.to(WifiScanner());
                  },
                  child: infosWidget(
                      'public/images/icon/modbusRTUPage1.png', '常规串口检测')),
              InkWell(
                onTap: () {
                  Get.to(gaywayRTUCheckPage());
                },
                child: infosWidget(
                    'public/images/icon/modbusRTUPage2.png', '网关串口出厂检测'),
              )
            ],
          ),
        ));
  }
}

class infosWidget extends StatelessWidget {
  final String img;
  final String text;

  // Constructor to initialize the widget with data
  infosWidget(this.img, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.w,
      height: 170.h,
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
      margin: const EdgeInsets.fromLTRB(10, 5, 0, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 2, 5, 0),
            child: Image.asset(
              img,
              width: 42.w,
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 5, 3),
              child: Text(
                text,
                style: normalText(fSize: 16, fontcolor: Colors.black),
              )),
        ],
      ),
    );
  }
}
