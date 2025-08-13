/*
 * @Author: FishHaveMine 751174479@qq.com
 * @Date: 2024-06-01 15:09:13
 * @LastEditors: FishHaveMine 751174479@qq.com
 * @LastEditTime: 2024-06-05 17:16:43
 * @FilePath: /fluoroscopy_tool/lib/view/mine/index.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/bottomSelectSheet.dart';
import 'package:fluoroscopy_tool/compent/fontSetting.dart';
import 'package:fluoroscopy_tool/view/local/style.dart';
import 'package:fluoroscopy_tool/view/log/list.dart';
import 'package:fluoroscopy_tool/view/mine/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import 'package:get/get.dart';

import 'BackClip.dart';
import 'about.dart';

import 'package:file_picker/file_picker.dart';

import 'fileManage.dart';

class minePgae extends StatefulWidget {
  const minePgae({super.key});

  @override
  State<minePgae> createState() => _minePgaeState();
}

class _minePgaeState extends State<minePgae> {
  // WidgetsToImageController to access widget
  WidgetsToImageController controller = WidgetsToImageController();

  static const platform = MethodChannel('com.example.usb_channel');
  String usbPath = '未开始';
  bool statr = false;

  // to save image bytes of widget
  Uint8List? bytes;
  Future<void> changeLocale(context) async {
    Future<sheetBack?> selectedIndex = await showCustomModalBottomSheet(
        isMultiple: false,
        context,
        [
          {'label': tr('self.en'), 'name': tr('self.en'), 'value': 1},
          {'label': tr('self.cn'), 'name': tr('self.cn'), 'value': 2},
        ],
        // ignore: unrelated_type_equality_checks
        baseValue: [
          EasyLocalization.of(context)?.currentLocale!.languageCode == 'en'
              ? '1'
              : '2'
        ],
        titleName: tr('chooseLangage'));
    selectedIndex.then((value) => {
          if (value != null)
            {
              if (value.baseValue![0] == '1')
                {_changeLanguage(switchLanguage(0))}
              else if (value.baseValue![0] == '2')
                {_changeLanguage(switchLanguage(1))}
            }
        });
  }

  Future<void> _changeLanguage(Locale locale) async {
    await EasyLocalization.of(context)?.setLocale(locale);
    // 语言变更完成后，可以添加额外的刷新逻辑
    setState(() {}); // 强制重建（通常不需要，仅作备用）
    print('Current locale: ${context.locale}');
  }

  Locale switchLanguage(int index) {
    switch (index) {
      case 0:
        return const Locale('en', 'US');
      case 1:
        return const Locale('zh', 'CN');
    }
    return const Locale('en', 'US');
  }

  Future<void> startUsbListener() async {
    try {
      setState(() {
        statr = true;
      });
      await platform.invokeMethod('setusdhost');
      Future.delayed(const Duration(seconds: 5));
      await platform.invokeMethod('startUsbListener');
    } on PlatformException catch (e) {
      print("启动监听失败: ${e.message}");
    }
  }

  Future<void> stopUsbListener() async {
    try {
      setState(() {
        statr = false;
      });
      await platform.invokeMethod('stopUsbListener');
    } on PlatformException catch (e) {
      print("停止监听失败: ${e.message}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 设置MethodCallHandler监听挂载事件
      platform.setMethodCallHandler((call) async {
        if (call.method == "onUsbMounted") {
          setState(() {
            usbPath = call.arguments ?? '未知路径';
          });
        }
      });
    });
  }

  @override
  void dispose() {
    // 停止监听
    if (statr) stopUsbListener();
    super.dispose();
  }

  String fileContent = '';
  String filefilePath = '';
  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any, // 可选择任何类型文件
      allowMultiple: false, // 是否允许多选
    );

    if (result != null) {
      // 获取文件路径
      final filePath = result.files.single.path!;
      // 读取文件内容
      final file = File(filePath);
      final content = "";

      setState(() {
        fileContent = content;
        filefilePath = filePath;
      });

      // 弹框显示文件内容
      _showContentDialog(content);
    } else {
      print("未选择任何文件");
    }
  }

  // 弹框显示文件内容
  void _showContentDialog(String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("文件内容"),
          content: SingleChildScrollView(
            child: Column(
              children: [Text(filefilePath), Text(content)],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("关闭"),
            ),
          ],
        );
      },
    );
  }

  late Directory documentsDirectory;

  @override
  Widget build(BuildContext context) {
    return WidgetsToImage(
        controller: controller,
        child: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('public/images/mineBg.png'),
                  fit: BoxFit.cover)),
          padding: EdgeInsets.fromLTRB(32.w, 0.h, 32.w, 50.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                  onLongPress: () {
                    Get.to(() => logpage());
                  },
                  child: SizedBox(
                    height: 344.h,
                    child: Center(
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.white),
                          child: Image.asset(
                            'public/images/header.png',
                            height: 188.w,
                          )),
                    ),
                  ),
                ),
                Container(
                  decoration: cardStyle(context),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 24.h),
                  child: Column(
                    children: [
                      const fontSetting(),
                      ListTile(
                        onTap: () {
                          EasyLoading.showInfo(tr("codingtip.Text"));
                          return;
                          changeLocale(context);
                        },
                        leading: Image.asset(
                          'public/images/icon/icon_language.png',
                          height: 48.w,
                        ),
                        title: const Text('menu_Language').tr(),
                        trailing: Image.asset(
                          'public/images/icon/rightP.png',
                          height: 48.w,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: cardStyle(context),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 24.h),
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0.h),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () async {
                          Get.to(() => account());
                        },
                        leading: Image.asset(
                          'public/images/icon/icon_Account.png',
                          height: 48.w,
                        ),
                        title: const Text('menu_account').tr(),
                        trailing: Image.asset(
                          'public/images/icon/rightP.png',
                          height: 48.w,
                        ),
                      ),
                      ListTile(
                        onTap: () async {
                          Get.to(() => BackClip());
                        },
                        leading: Image.asset(
                          'public/images/icon/CommunicationDetection1.png',
                          height: 48.w,
                        ),
                        title: const Text('menu_ota').tr(),
                        trailing: Image.asset(
                          'public/images/icon/rightP.png',
                          height: 48.w,
                        ),
                      ),
                      ListTile(
                        onTap: () async {
                          Get.to(() => about());
                        },
                        leading: Image.asset(
                          'public/images/icon/icon_About.png',
                          height: 48.w,
                        ),
                        title: const Text('menu_app').tr(),
                        trailing: Image.asset(
                          'public/images/icon/rightP.png',
                          height: 48.w,
                        ),
                      ),
                      // TextButton(
                      //   onPressed: () {
                      //     if (!statr) {
                      //       startUsbListener();
                      //     } else {
                      //       stopUsbListener();
                      //     }
                      //   },
                      //   child: Text(usbPath),
                      // ),
                      // TextButton(
                      //   onPressed: () {
                      //     pickFile();
                      //   },
                      //   child: Text("选择文件"),
                      // )
                    ],
                  ),
                ),
                Container(
                  decoration: cardStyle(context),
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0.h),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () async {
                          Get.to(() => FileManage());
                        },
                        leading: Image.asset(
                          'public/images/icon/CommunicationDetection1.png',
                          height: 48.w,
                        ),
                        title: const Text('menu_file').tr(),
                        trailing: Image.asset(
                          'public/images/icon/rightP.png',
                          height: 48.w,
                        ),
                      ),
                      ListTile(
                        onTap: () async {
                          Get.offAllNamed('/productSelect');
                        },
                        leading: Image.asset(
                          'public/images/icon/CommunicationDetection1.png',
                          height: 48.w,
                        ),
                        title: const Text('切换产品').tr(),
                        trailing: Image.asset(
                          'public/images/icon/rightP.png',
                          height: 48.w,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
