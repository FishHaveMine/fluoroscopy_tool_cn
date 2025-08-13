import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:fluoroscopy_tool/view/refrigerant/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

class inputing extends StatefulWidget {
  inputing({super.key});

  @override
  State<inputing> createState() => _copybasepageState();
}

class _copybasepageState extends State<inputing> {
  bool isfinish = false;
  bool iserror = false;
  double inputsetting = 0;
  late Timer _timer;

  static const _selfplatform =
      MethodChannel('samples.flutter.dev/RefrigerantService');
  final deviceInfoController _deviceInfoController = Get.find();
  checkResult() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      try {
        var refrigerantResult = await _selfplatform
            .invokeMethod('refrigerantResult', <String, dynamic>{});
        var data = jsonDecode(refrigerantResult);
        print("refrigerant : $data");
        if (data["success"] && data["data"].toString() == "true") {
          setState(() {
            isfinish = true;
          });
          _timer.cancel();
        }

        // if (!data["success"]) {
        //   setState(() {
        //     isfinish = true;
        //     iserror = true;
        //   });
        //   _timer.cancel();
        // }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$e"),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  OverlayEntry? _overlayEntry;
  void _showOverlay() {
    final overlay = Overlay.of(context);
    if (overlay != null) {
      _overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: 0.0,
          left: 0.0,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                _focusNode.unfocus();
              },
              child: Container(
                color: Colors.black.withOpacity(0.5),
                width: 720.w,
                height: 1280.h,
              ),
            ),
          ),
        ),
      );
      overlay.insert(_overlayEntry!);
    }
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      _showOverlay();
    } else {
      _hideOverlay();
    }
  }

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      checkResult();
    });
  }

  @override
  void dispose() {
    super.dispose();
    try {
      _timer.cancel();
    } catch (e) {}
    _focusNode.unfocus();
    _focusNode.dispose();
    _hideOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Get.off(() => refrigerantTable());
              },
              icon: const Icon(Icons.chevron_left,
                  color: Colors.black, size: 36)),
          title: const Text(
            'refrigerant.autoInputStep',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [],
        ),
        body: Container(
          width: 720.w,
          height: 1280.h,
          color: const Color.fromRGBO(255, 255, 255, 1),
          padding: EdgeInsets.fromLTRB(32.w, 0.h, 32.w, 0.h),
          child: Column(
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: !isfinish
                    ? [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 24.h, 0, 46.h),
                          child: Image.asset(
                            'public/images/refrigerant/start.png',
                            width: 404.w,
                          ),
                        ),
                        Text.rich(TextSpan(
                          style: normalTextBlack(fSize: 18),
                          text: tr("refrigerant.inputing"),
                        )),
                        Text.rich(TextSpan(
                          style: normalText(fSize: 14),
                          text: tr("refrigerant.inputing.tip"),
                        )),
                      ]
                    : [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 24.h, 0, 46.h),
                          child: Image.asset(
                            'public/images/refrigerant/start.png',
                            width: 404.w,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(0, 24.h, 0, 46.h),
                            child: Text(
                              style: normalTextBlack(
                                fSize: 18,
                                fw: FontWeight.w800,
                              ),
                              !iserror
                                  ? tr("refrigerant.inputing.finish")
                                  : tr("refrigerant.inputing.finish.iserror"),
                            )),
                        if (!iserror)
                          Padding(
                              padding: EdgeInsets.fromLTRB(16, 0.h, 16, 0.h),
                              child: Row(
                                children: [
                                  Text(
                                    style: normalTextBlack(
                                      fSize: 14,
                                      fontcolor: Colors.red,
                                    ),
                                    "*",
                                  ),
                                  Expanded(
                                    child: Text(
                                      style: normalTextBlack(
                                        fSize: 14,
                                        fw: FontWeight.w600,
                                      ),
                                      tr("refrigerant.inputing.finish.tip1"),
                                    ),
                                  )
                                ],
                              )),
                        // if (!iserror)
                        //   Padding(
                        //       padding: EdgeInsets.fromLTRB(0, 12.h, 0, 46.h),
                        //       child: Container(
                        //         padding:
                        //             const EdgeInsets.symmetric(horizontal: 16),
                        //         decoration: BoxDecoration(
                        //           color: const Color(0xFFF7F7F7), // 背景颜色
                        //           borderRadius:
                        //               BorderRadius.circular(8), // 圆角边框
                        //         ),
                        //         child: TextField(
                        //           focusNode: _focusNode,
                        //           decoration: InputDecoration(
                        //             hintText: tr('input.hintText'),
                        //             border: InputBorder.none, // 去掉默认的下划线边框
                        //           ),
                        //           onChanged: (val) {
                        //             inputsetting = val as double;
                        //           },
                        //         ),
                        //       )),
                        // if (!iserror)
                        //   Text(
                        //     style: normalText(fSize: 14),
                        //     tr("refrigerant.inputing.finish.tip"),
                        //   ),

                        Container(
                          margin: EdgeInsets.fromLTRB(0, 36.h, 0, 0.h),
                          width: 208.w,
                          height: 36,
                          child: normalButton(
                              label: tr("refrigerant.inputing.start.btn"),
                              onClick: () {
                                Get.off(() => refrigerantTable());
                              }),
                        )
                      ],
              )),
            ],
          ),
        ));
  }
}
