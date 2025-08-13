/*
 * @Author: FishHaveMine 751174479@qq.com
 * @Date: 2024-05-27 15:03:53
 * @LastEditors: FishHaveMine 751174479@qq.com
 * @LastEditTime: 2024-06-04 17:50:57
 * @FilePath: /fluoroscopy_tool/lib/view/welcome/index.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
/*
 * @Author: FishHaveMine 751174479@qq.com
 * @Date: 2024-05-27 15:03:53
 * @LastEditors: FishHaveMine 751174479@qq.com
 * @LastEditTime: 2024-05-30 11:20:50
 * @FilePath: /HVAC/fluoroscopy_tool/lib/view/welcome/index.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/EmailInputDialog.dart';
import 'package:fluoroscopy_tool/store/globalData.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/view/cloud/index.dart';
import 'package:fluoroscopy_tool/view/local/index.dart';
import 'package:fluoroscopy_tool/view/mine/index.dart';
import 'package:fluoroscopy_tool/store/http.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../local/publicFunction.dart';
import 'package:get/get.dart';

import 'searchFaultInfo/search.dart';

class welcomePage extends StatefulWidget {
  const welcomePage({super.key});

  @override
  State<welcomePage> createState() => _welcomePageState();
}

// ignore: camel_case_types
class _welcomePageState extends State<welcomePage> {
  int _currentIndex = 1;
  final bool _downloading = true;
  // ignore: non_constant_identifier_names
  final List _HomePage = [
    const cloudSwitch(),
    const localDevice(),
    const minePgae()
  ];

  Future<void> _checkPermissions(context) async {
    checkversion(context);
  }

  final deviceInfoController _deviceInfoController =
      Get.put(deviceInfoController());
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _checkPermissions(context);
    });
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  void dispose() {
    super.dispose();
  }

  static const _selfplatform = MethodChannel('samples.flutter.dev/BackClip');

  static const McuUtilplatform = MethodChannel('samples.flutter.dev/McuUtil');
  _test() async {
    await McuUtilplatform.invokeMethod('powerOn');
    await Future.delayed(Duration(seconds: 1));
    EasyLoading.show(status: 'loading...');
    try {
      var historyback = await _selfplatform.invokeMethod('TestServiceob', {});
      var historydata = jsonDecode(historyback);
      print("TestServiceob  $historydata");
      EasyLoading.dismiss();
    } catch (e) {
      print("TestServiceob error ${e}");
      EasyLoading.dismiss();
    }
  }

  _test2() async {
    await McuUtilplatform.invokeMethod('powerOn');
    await Future.delayed(Duration(seconds: 1));
    EasyLoading.show(status: 'loading...');
    try {
      var historyback = await _selfplatform.invokeMethod('TestServiceob2', {});
      var historydata = jsonDecode(historyback);
      print("TestServiceob  $historydata");
      EasyLoading.dismiss();
    } catch (e) {
      print("TestServiceob error ${e}");
      EasyLoading.dismiss();
    }
  }

  downlown(email) async {
    EasyLoading.show(status: 'loading...');
    try {
      final String filePath =
          '/data/data/com.example.fluoroscopy_tool/files/Database_/dev/ttyS0/2025-08-11 10-57-43.db';
      final File dbFile = File(filePath);

      // 检查文件是否存在
      if (!await dbFile.exists()) {
        print('文件不存在: $filePath');
        return false;
      }

      var uploadExcelFileback = await MideaApi.uploadExcelFile(dbFile.path);

      print("getHistoryDataExcel uploadExcelFile： ${uploadExcelFileback}");
      if (uploadExcelFileback["errorCode"] == 200) {
        var fileurl = uploadExcelFileback["data"];
        var sendDBAndSend = {"dbUrl": fileurl};
        print("getHistoryDataExcel getDBAndSend send： $sendDBAndSend");
        var getDBAndSendback = await MideaApi.getDBAndSend(sendDBAndSend);
        print("getHistoryDataExcel getDBAndSendback $getDBAndSendback");

        var send = {"email": email, "excelUrl": getDBAndSendback["data"]};
        print("getHistoryDataExcel sendEmail send： $send");
        var sendEmaileback = await MideaApi.sendEmail(send);
        print("getHistoryDataExcel sendEmaileback $sendEmaileback");
        //继续下一步  --- 发送到邮箱
        EasyLoading.showSuccess(
            tr("menu.export") + tr("unlockhistory.unlocksuccess"));
      } else {
        EasyLoading.showSuccess(
            tr("menu.export") + tr("unlockhistory.unlockerror"));
      }
    } catch (e) {}
    return;
    try {
      var historyback =
          await _selfplatform.invokeMethod('getHistoryDataExcel', {});
      var historydata = jsonDecode(historyback);
      print("getHistoryDataExcel historydata： $historydata");
      EasyLoading.dismiss();
      if (historydata['errorCode'] != 200) {
        EasyLoading.showSuccess(
            tr("menu.export") + tr("unlockhistory.unlockerror"));
        //返回的是 file.absolutePath 弹框输入邮箱并发送
        return;
      } else {
        var uploadExcelFileback =
            await MideaApi.uploadExcelFile(historydata["data"]);

        print("getHistoryDataExcel uploadExcelFile： ${uploadExcelFileback}");
        if (uploadExcelFileback["errorCode"] == 200) {
          var fileurl = uploadExcelFileback["data"];
          var send = {"email": email, "excelUrl": fileurl};
          print("getHistoryDataExcel send： $send");
          var sendEmaileback = await MideaApi.sendEmail(send);
          print("getHistoryDataExcel sendEmaileback $sendEmaileback");
          //继续下一步  --- 发送到邮箱
          EasyLoading.showSuccess(
              tr("menu.export") + tr("unlockhistory.unlocksuccess"));
        } else {
          EasyLoading.showSuccess(
              tr("menu.export") + tr("unlockhistory.unlockerror"));
        }

        // await Future.delayed(const Duration(seconds: 2), () {
        //   print('One second has passed.'); // Prints after 1 second.
        // });
      }
    } catch (e) {
      print("getHistoryDataExcel error $e");
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: GetBuilder<deviceInfoController>(
            init: deviceInfoController(),
            builder: (_) => Scaffold(
                  appBar: null,
                  body: _HomePage[_currentIndex],
                  floatingActionButtonLocation:
                      CustomFloatingActionButtonLocation(),
                  floatingActionButton: _currentIndex == 0
                      ? IconTextButton(
                          icon: Icons.search,
                          text: tr('errorclound'),
                          onPressed: () {
                            Get.to(() => searchFaultInfo());
                          },
                        )
                      : Container(
                          // width: 80,
                          // height: 150,
                          // child: Column(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   crossAxisAlignment: CrossAxisAlignment.end,
                          //   children: [
                          //     IconTextButton(
                          //       icon: Icons.import_export_sharp,
                          //       text: 'USB测试',
                          //       onPressed: () {
                          //         // _test();
                          //         EmailInputDialog.show(
                          //           context,
                          //           onConfirm: (email) {
                          //             downlown(email);
                          //           },
                          //         );
                          //       },
                          //     ),
                          //     // SizedBox(
                          //     //   height: 15,
                          //     // ),
                          //     // IconTextButton(
                          //     //   icon: Icons.import_export_sharp,
                          //     //   text: 'USB测试2',
                          //     //   onPressed: () {
                          //     //     _test2();
                          //     //     // EmailInputDialog.show(
                          //     //     //   context,
                          //     //     //   onConfirm: (email) {
                          //     //     //     downlown(email);
                          //     //     //   },
                          //     //     // );
                          //     //   },
                          //     // )
                          //   ],
                          // ),
                          ),
                  bottomNavigationBar: BottomNavigationBar(
                    selectedItemColor: Theme.of(context).colorScheme.primary,
                    currentIndex: _currentIndex,
                    // ignore: non_constant_identifier_names
                    onTap: (int Index) async {
                      _checkPermissions(context);
                      setState(() {
                        _currentIndex = Index;
                      });
                      if (_currentIndex != 1) {
                        // _deviceInfoController.stopPolling();
                      }
                    },
                    items: [
                      // BottomNavigationBarItem(
                      //     icon: Icon(Icons.bluetooth), label: tr('bottomNavigationTitle1')),
                      BottomNavigationBarItem(
                          icon: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Image.asset(
                                _currentIndex == 0
                                    ? 'public/images/menu/menu1_active.png'
                                    : 'public/images/menu/menu1.png',
                                width: 48.w,
                              )),
                          label: tr('menu_project')),
                      BottomNavigationBarItem(
                          icon: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Image.asset(
                                _currentIndex == 1
                                    ? 'public/images/menu/menu2_active.png'
                                    : 'public/images/menu/menu2.png',
                                width: 48.w,
                              )),
                          label: tr('menu_device')),
                      BottomNavigationBarItem(
                          icon: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Image.asset(
                                _currentIndex == 2
                                    ? 'public/images/menu/menu3_active.png'
                                    : 'public/images/menu/menu3.png',
                                width: 48.w,
                              )),
                          label: tr('menu_mine'))
                    ],
                  ),
                )));
  }
}

/// 自定义 FloatingActionButtonLocation
class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // 屏幕宽度
    final double screenWidth = scaffoldGeometry.scaffoldSize.width;

    // FAB 高度
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;

    // 距底部的偏移
    const double bottomMargin = 66.0;

    // 距右边的偏移
    const double rightMargin = 0.0; // 贴边可设置为 0

    return Offset(
      screenWidth -
          scaffoldGeometry.floatingActionButtonSize.width -
          rightMargin,
      scaffoldGeometry.scaffoldSize.height - fabHeight - bottomMargin,
    );
  }
}
