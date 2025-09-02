import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/view/local/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'ModbusRTU/index.dart';
import 'deviceGatewayController.dart';
import 'gaywayQuery.dart';

class qualityInspectionPage extends StatefulWidget {
  qualityInspectionPage({super.key});

  @override
  State<qualityInspectionPage> createState() => _qualityInspectionPageState();
}

class _qualityInspectionPageState extends State<qualityInspectionPage> {
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
            '品质检测',
            style: TextStyle(color: Colors.black),
          ).tr(),
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
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      border: Border.all(
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 24.h),
                  child: ListTile(
                    onTap: () async {
                      Get.to(gaywayQueryPage());
                    },
                    title: const Text('网关注册连接状态查询').tr(),
                    trailing: Image.asset(
                      'public/images/icon/rightP.png',
                      height: 30.w,
                      color: Colors.black,
                    ),
                  )),
              Container(
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      border: Border.all(
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 24.h),
                  child: ListTile(
                    onTap: () async {
                      Get.to(modbusRTUPage());
                    },
                    title: const Text('ModbusRTU通讯调试工具'),
                    trailing: Image.asset(
                      'public/images/icon/rightP.png',
                      height: 30.w,
                      color: Colors.black,
                    ),
                  )),
            ],
          ),
        ));
  }
}
