import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/systemCapabilityAnalysis/step2/systemDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

class rtuCheckpage extends StatefulWidget {
  int checkingStatus;
  rtuCheckpage({super.key, required this.checkingStatus});

  @override
  State<rtuCheckpage> createState() => _rtuCheckpageState();
}

class _rtuCheckpageState extends State<rtuCheckpage> {
  static const McuUtilplatform = MethodChannel('samples.flutter.dev/McuUtil');

  @override
  void initState() {
    super.initState();
    setState(() {
      status = widget.checkingStatus;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _getSentCommands();
      setState(() {
        _count++;
      });
      print("第 $_count 次执行");
    });
  }

  int status = 0;
  List sendList = [];
  static const platform =
      MethodChannel('samples.flutter.dev/waterpumbBasicHandler');
  _reset() {
    setState(() {
      status = 0;
    });
  }

  _getSentCommands() {
    platform.invokeMethod('getSentCommands', <String, dynamic>{}).then(
        (value) => {_addCOM(json.decode(value))});
  }

  Timer? _timer;
  int _count = 0;

  _addCOM(val) {
    print(val.runtimeType);
    print(val);
    setState(() {
      sendList = [...val];
    });
  }

  _starsetStop() async {
    try {
      EasyLoading.show(status: 'loading...');
      _timer?.cancel(); // 取消定时器

      var back = await platform.invokeMethod('setStop', <String, dynamic>{});

      McuUtilplatform.invokeMethod('powerOff');
      _reset();
      print('back: $back');
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // 取消定时器
    // TODO: implement dispose
    super.dispose();
    EasyLoading.dismiss();
  }

  String formatDateTime(String dateString) {
    try {
      // 解析 ISO 8601 格式的日期字符串
      final dateTime = DateTime.parse(dateString);

      // 提取各部分并补零
      final year = dateTime.year.toString();
      final month = dateTime.month.toString().padLeft(2, '0');
      final day = dateTime.day.toString().padLeft(2, '0');
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final second = dateTime.second.toString().padLeft(2, '0');

      // 拼接成 yyyy-mm-dd hh:mm:ss 格式
      return '$year-$month-$day $hour:$minute:$second';
    } catch (e) {
      return '--';
    }
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
            '查看报文',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: const [],
        ),
        body: Container(
          width: 720.w,
          height: 1280.h,
          color: const Color.fromRGBO(255, 255, 255, 1),
          padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: Color.fromRGBO(223, 223, 223, 1),
                            width: 0.5,
                          ),
                        )),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            '检测报文',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      trailing: status == 2
                          ? TextButton(
                              onPressed: () {
                                _starsetStop();
                              },
                              child: const Text(
                                '停止检测',
                                style: TextStyle(
                                    color: Color.fromRGBO(25, 98, 255, 1),
                                    fontWeight: FontWeight.bold),
                              ))
                          : null,
                    )),
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                  child: ListView.builder(
                itemBuilder: ((context, index) => Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    child: Text(
                      '[${formatDateTime(sendList[index]['time'])}] ${sendList[index]['rxTx']} : ${sendList[index]['command']}',
                      style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Color.fromRGBO(102, 102, 102, 1)),
                    ))),
                itemCount: sendList.length,
              )),
              const SizedBox(
                height: 16,
              )
            ],
          ),
        ));
  }
}
