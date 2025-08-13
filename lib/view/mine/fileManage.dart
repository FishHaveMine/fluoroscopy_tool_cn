// ignore_for_file: use_build_context_synchronously, unused_element

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalData.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'BackClip.dart';

class FileManage extends StatefulWidget {
  FileManage({super.key});

  @override
  State<FileManage> createState() => _accountState();
}

class _accountState extends State<FileManage> {
  static const _selfplatform = MethodChannel('samples.flutter.dev/BackClip');
  String CacheFile = "--";
  String formatToTwoDecimals(String value) {
    double number = double.tryParse(value) ?? 0.0; // 解析为数值，默认值为0
    return number.toStringAsFixed(2); // 保留两位小数
  }

  _getCacheFile() async {
    EasyLoading.show(status: 'loading...');
    try {
      var historyback = await _selfplatform.invokeMethod('getCacheFile', {});
      var historydata = jsonDecode(historyback);
      if (historydata["data"] != null) {
        CacheFile =
            "${formatToTwoDecimals((historydata["data"] / 1024 / 1024).toString())}MB";
        setState(() {
          CacheFile;
        });
      }
      EasyLoading.dismiss();
    } catch (e) {}
    EasyLoading.dismiss();
  }

  clearCacheFile() async {
    var historyback = await _selfplatform.invokeMethod('clearCacheFile', {});
    var historydata = jsonDecode(historyback);
    if (!historydata['success']) {
      EasyLoading.showError(historydata['errorMsg']);
    } else {
      EasyLoading.showSuccess(tr("menu_file.showsuccess"));
      await Future.delayed(const Duration(seconds: 2), () {
        print('One second has passed.'); // Prints after 1 second.
      });
      _getCacheFile();
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    _getCacheFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.chevron_left,
                  color: Colors.black, size: 36)),
          title: const Text(
            'menu_file',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: const [],
        ),
        body: SizedBox(
            width: 720.w,
            height: 1280.h,
            child: Column(children: [
              Expanded(
                  child: Column(
                children: [
                  itembox(
                    title: tr('menu_file.type1'),
                    val: CacheFile,
                    btntext: tr("menu_file.type1.btn"),
                    clickfun: () async {
                      bool issend = await divConfirmDialog(context,
                          confirmTitle:
                              tr("device.controltDialog.confirmTitle"),
                          isSubmitButton: true,
                          confirmDescriptionWidget: SingleChildScrollView(
                            child: SizedBox(
                                width: 560.w,
                                height: 140,
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'menu_file.type1.tip',
                                        style: normalTextBlack(),
                                      ).tr(),
                                    ],
                                  ),
                                )),
                          ));
                      if (issend) {
                        clearCacheFile();
                      }
                    },
                  )
                ],
              )),
            ])));
  }
}
