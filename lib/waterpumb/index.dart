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
import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/store/globalData.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/view/cloud/index.dart';
import 'package:fluoroscopy_tool/view/local/index.dart';
import 'package:fluoroscopy_tool/view/mine/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'warterpumbIndex.dart';

class warterpumbWelcomePage extends StatefulWidget {
  const warterpumbWelcomePage({super.key});

  @override
  State<warterpumbWelcomePage> createState() => _warterpumbWelcomePageState();
}

// ignore: camel_case_types
class _warterpumbWelcomePageState extends State<warterpumbWelcomePage> {
  int _currentIndex = 0;
  final bool _downloading = true;
  // ignore: non_constant_identifier_names
  final List _HomePage = [warterpumbIndex(), const minePgae()];

  static const initplatform = MethodChannel('samples.flutter.dev/init');
  Future<void> _checkPermissions(context) async {
    checkversion(context);

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          appBar: null,
          body: _HomePage[_currentIndex],
          floatingActionButtonLocation: CustomFloatingActionButtonLocation(),
          floatingActionButton: Container(),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Theme.of(context).colorScheme.primary,
            currentIndex: _currentIndex,
            // ignore: non_constant_identifier_names
            onTap: (int Index) async {
              setState(() {
                _currentIndex = Index;
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Image.asset(
                        _currentIndex == 0
                            ? 'public/images/menu/menu2_active.png'
                            : 'public/images/menu/menu2.png',
                        width: 48.w,
                      )),
                  label: tr('menu_device')),
              BottomNavigationBarItem(
                  icon: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Image.asset(
                        _currentIndex == 1
                            ? 'public/images/menu/menu3_active.png'
                            : 'public/images/menu/menu3.png',
                        width: 48.w,
                      )),
                  label: tr('menu_mine'))
            ],
          ),
        ));
    ;
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
