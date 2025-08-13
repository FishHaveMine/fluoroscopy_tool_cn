import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/view/cloud/device/style.dart';
import 'package:fluoroscopy_tool/waterpumb/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'pumbReport/index.dart';
import 'qualityInspection/index.dart';
import 'unlock/unlockform.dart';

class warterpumbIndex extends StatefulWidget {
  warterpumbIndex({super.key});

  @override
  State<warterpumbIndex> createState() => _warterpumbIndexState();
}

class _warterpumbIndexState extends State<warterpumbIndex> {
  static const platform =
      MethodChannel('samples.flutter.dev/waterpumbBasicHandler');

  static const McuUtilplatform = MethodChannel('samples.flutter.dev/McuUtil');
  init() async {
    EasyLoading.show(status: 'loading...');
    try {
      await McuUtilplatform.invokeMethod('powerOn');
      var GenCode =
          await platform.invokeMethod('initwaterData', <String, dynamic>{});
      EasyLoading.dismiss();
      EasyLoading.showSuccess("初始化成功");
    } catch (e) {
      print("initwaterData showError: $e");

      EasyLoading.dismiss();
      EasyLoading.showError("初始化失败");
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    init();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _deviceInfoController.stopPolling();
    EasyLoading.dismiss();
  }

  List fun = [
    {
      "icon": "unlock@3x",
      "name": "解锁功能",
    },
    {
      "icon": "report@3x",
      "name": "调试报告",
    },
    {
      "icon": "testreport@3x",
      "name": "品质检测",
    }
  ];

  @override
  Widget build(BuildContext context) {
    // Get height of app bar
    double appBarHeight = AppBar().preferredSize.height;

    // Calculate remaining height for page content
    double contentHeight = MediaQuery.of(context).size.height -
        appBarHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    return GetBuilder<waterpumbInfoController>(
        init: waterpumbInfoController(),
        builder: (_) => Container(
              width: 720.w,
              height: 1280.h - 55,
              clipBehavior: Clip.hardEdge, // 关键点！裁剪超出部分
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('public/images/devicePageBg.png'),
                      fit: BoxFit.fill)),
              child: Column(
                children: [
                  const deviceVersion(),
                  deviceInfoPage(
                    onStart: () {},
                  ),
                  SizedBox(
                    height: 64.h,
                  ),
                  for (var funitem in fun)
                    InkWell(
                      onTap: () {
                        // EasyLoading.showError(tr("noopen"));
                        // return;
                        if (funitem["name"] == "解锁功能") {
                          Get.to(UnlockPage());
                        } else if (funitem["name"] == "调试报告") {
                          Get.to(pumbReportIndex());
                        } else {
                          Get.to(qualityInspectionPage());
                        }
                      },
                      child: Container(
                        width: 620.w,
                        decoration: cardStyleFull(context),
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 14),
                        padding: EdgeInsets.all(24.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 26.w, 0),
                              child: Image.asset(
                                'public/images/prowaterpumb/${funitem["icon"]}.png',
                                width: 64.w,
                              ),
                            ),
                            Text(
                              funitem["name"],
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(13, 13, 13, 1)),
                            ),
                          ],
                        ),
                      ),
                    )
                ],
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
  final waterpumbInfoController _deviceInfoController = Get.find();

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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<waterpumbInfoController>(
        init: waterpumbInfoController(),
        builder: (_) => Container(
              padding: EdgeInsets.fromLTRB(paddingLR, 58.h, paddingLR, 0),
              child: _deviceInfoController.isConnected.value
                  ? Column(
                      children: [
                        InkWell(
                            onTap: () {},
                            child: Row(children: [
                              // Text(
                              //   _deviceInfoController
                              //       .loacalDevice.value.version,
                              //   style: versionTitle(context),
                              // ),
                              // const Padding(
                              //     padding: EdgeInsets.fromLTRB(8, 0, 0, 0)),
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
                          children: _deviceInfoController.isConnected.value
                              ? [
                                  Text(
                                      _deviceInfoController
                                          .loacalDevice.value.locks,
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
                                  InkWell(
                                      onTap: () {
                                        _copyTextToClipboard(
                                            _deviceInfoController
                                                .loacalDevice.value.sn);
                                      },
                                      child: Text(
                                          'SN ${_deviceInfoController.loacalDevice.value.sn.toUpperCase()}',
                                          style: versionValue(context)))
                                ]
                              : [],
                        )
                      ],
                    )
                  : SizedBox(
                      width: 720.w,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 7, 0, 11),
                        child: Text(
                          'local.disconnect',
                          style: versionTitle(context),
                        ).tr(),
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

class _deviceInfoPageState extends State<deviceInfoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  static const platform = MethodChannel('samples.flutter.dev/battery');
  final waterpumbInfoController _deviceInfoController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<waterpumbInfoController>(
        init: waterpumbInfoController(),
        builder: (_) => Container(
              width: 720.w,
              height: 430.h,
              margin: EdgeInsets.fromLTRB(0, 0.h, 0, 0),
              child: Stack(children: [
                Positioned(
                  bottom: 0.h,
                  left: 0,
                  child: InkWell(
                      onTap: () {},
                      child: SizedBox(
                        width: 720.w,
                        child: Center(
                          child: Image.asset(
                              'public/images/icon/deviceInfoBG1.png',
                              width: 575.w),
                        ),
                      )),
                ),
                Positioned(
                  left: 0,
                  bottom: 70.h,
                  child: SizedBox(
                    width: 720.w,
                    child: Center(
                      child: SizedBox(
                        width: 402.w,
                        child: InkWell(
                            onTap: () async {},
                            child: Stack(
                              children: [
                                Center(
                                  child: Opacity(
                                      opacity: _deviceInfoController
                                              .isConnected.value
                                          ? 1
                                          : 0.6, // 设置不透明度为 50%
                                      child: Image.asset(
                                        'public/images/prowaterpumb/shuiji.png',
                                        width: 402.w,
                                      )),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                ),
                if (false)
                  Positioned(
                    left: (720.w - 575.w) / 2,
                    bottom: 120.h,
                    child: SizedBox(
                      width: 575.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                "─ ─",
                                style: info(fs: 34.w),
                              ),
                              Text(
                                "就地",
                                style: info(),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Text(
                                "─ ─",
                                style: info(fs: 34.w),
                              ),
                              Text(
                                "多联",
                                style: info(),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "─ ─",
                                style: info(fs: 34.w),
                              ),
                              Text(
                                "制冷",
                                style: info(),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Text(
                                "─ ─",
                                style: info(fs: 34.w),
                              ),
                              Text(
                                "主机",
                                style: info(),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
              ]),
            ));
  }
}

TextStyle info({double? fs = null}) {
  return TextStyle(
      color: Colors.white,
      fontSize: fs ?? 24.w,
      fontWeight: fs != null ? FontWeight.w600 : FontWeight.w400);
}
