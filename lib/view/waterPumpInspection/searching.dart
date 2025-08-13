import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'protocol_table.dart';

class waterPumpInspectionSearchingPage extends StatefulWidget {
  List indoorAddressList;
  waterPumpInspectionSearchingPage(
      {super.key, required this.indoorAddressList});
  @override
  State<waterPumpInspectionSearchingPage> createState() =>
      _waterPumpInspectionSearchingPageState();
}

class _waterPumpInspectionSearchingPageState
    extends State<waterPumpInspectionSearchingPage> {
  static const _selfplatform =
      MethodChannel('samples.flutter.dev/waterPumpInspec');

  static const platform = MethodChannel('samples.flutter.dev/battery');
  String resultuuid = '';
  bool isSearching = true;
  bool isStop = false;
  int error = 0;
  int total = 0;
  int _remainingSeconds = 60 * 5;
  List reportdata = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    init();
  }

  int countOccurrences(
      List<Map<String, int>> mapArray, String targetKey, int targetValue) {
    int count = 0;
    for (Map<String, int> map in mapArray) {
      if (map.containsKey(targetKey) && map[targetKey] == targetValue) {
        count++;
      }
    }
    return count;
  }

  _togetback(value) {
    try {
      if (reportdata != null) {
        reportdata = jsonDecode(value);

        print("togetback reportdata : $reportdata");

        if (_timer != null && _timer.isActive) _timer.cancel();

        setState(() {
          isSearching = false;
          total = reportdata.length;
          error = reportdata.where((element) => element['result'] == 0).length;
        });

        platform.invokeMethod('enableAutoSleep', <String, dynamic>{});
      } else {
        setState(() {
          isSearching = false;
          total = 0;
          error = 0;
        });
        platform.invokeMethod('enableAutoSleep', <String, dynamic>{});
      }
    } catch (e) {}
  }

  togetback() async {
    try {
      _selfplatform.invokeMethod('getResult', <String, dynamic>{
        'uuid': resultuuid,
      }).then((value) => _togetback(value));
    } catch (e) {
      setState(() {
        isSearching = false;
        total = 0;
        error = 0;
      });
    }
  }

  _stopgetResult() {
    try {
      divConfirmDialog(context,
          confirmTitle: tr("device.controltDialog.confirmTitle"),
          confirmDescriptionWidget: Container(
            width: 560.w,
            height: 80,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(15),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              color: Colors.black, height: 1.5, fontSize: 16.0),
                          text: tr("setStop"),
                        ),
                      ))
                ],
              ),
            ),
          )).then((value) => {
            if (value)
              {
                _selfplatform.invokeMethod(
                    'setStop', <String, dynamic>{}).then((value) => null),
                Navigator.pop(context)
              }
          });
    } catch (e) {}
  }

  init() async {
    try {
      await platform.invokeMethod('disableAutoSleep', <String, dynamic>{});
      print("togetback  indoorAddressList: ${widget.indoorAddressList}");
      resultuuid = await _selfplatform
          .invokeMethod('PumpDetectioncheck', <String, dynamic>{
        'indoorAddressList': widget.indoorAddressList,
      });

      print("togetback  indoorAddressList resultuuid: ${resultuuid}");
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (isStop) {
          _timer.cancel();
        }
        if (_remainingSeconds > 1) {
          setState(() {
            _remainingSeconds--;
          });
        } else {
          _timer.cancel();
        }
      });

      togetback();
    } on PlatformException catch (e) {
      setState(() {
        isSearching = false;
        total = 0;
        error = 0;
      });

      await platform.invokeMethod('enableAutoSleep', <String, dynamic>{});
      try {
        if (_timer != null && _timer.isActive) _timer.cancel();
      } catch (e) {}
      print("Failed to SCANNER_TRIG: '${e.message}'.");
    }
  }

  checkagarn() {
    _remainingSeconds = 60 * 5;
    setState(() {
      isSearching = true;
    });
    init();
  }

  @override
  void dispose() {
    try {
      if (_timer != null && _timer.isActive) _timer.cancel();
    } catch (e) {}
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    String templatetotal = tr('waterPump.searchresulttotal',
        namedArgs: {'total': '$total', 'error': '$error'});
    String template = tr('waterPump.searchresulterror',
        namedArgs: {'total': '$total', 'error': '$error'});
    // 分割文本以便设置不同样式
    int errorIndex = template.indexOf('$error');
    String firstPart = template.substring(0, errorIndex);
    String errorPart = '$error';
    String lastPart = template.substring(errorIndex + errorPart.length);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon:
                const Icon(Icons.chevron_left, color: Colors.black, size: 36)),
        title: const Text(
          'waterPump.title',
          style: TextStyle(color: Colors.black),
        ).tr(),
        centerTitle: true,
        actions: [],
      ),
      body: Center(
        child: isSearching
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'public/images/waterPump/360p.gif',
                    width: 280,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 40.h, 0, 16.h),
                    child: Text(
                      tr('waterPump.search'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Color.fromRGBO(13, 13, 13, 1),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    // key: ValueKey('_remainingSeconds:$_remainingSeconds'),
                    padding: EdgeInsets.fromLTRB(0, 0.h, 0, 64.h),
                    child: Text(
                        tr('waterPump.searching', namedArgs: {
                          'time': '$_remainingSeconds',
                        }),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(140, 140, 140, 1),
                            fontWeight: FontWeight.w500)),
                  ),
                  SizedBox(
                    width: 208.w,
                    height: 72.h,
                    child: normalButton(
                      label: tr('waterPump.stopsearch'),
                      onClick: () async {
                        _stopgetResult();
                      },
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'public/images/waterPump/v8@2x.png',
                    width: 280,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 40.h, 0, 16.h),
                    child: Text(
                      tr('waterPump.searchfinish'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Color.fromRGBO(13, 13, 13, 1),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    // key: ValueKey('_remainingSeconds:$_remainingSeconds'),
                    padding: EdgeInsets.fromLTRB(0, 0.h, 0, 64.h),
                    child: RichText(
                        text: TextSpan(
                      style: const TextStyle(
                          fontSize: 14.0,
                          color: Color.fromRGBO(140, 140, 140, 1)),
                      children: <TextSpan>[
                        TextSpan(text: templatetotal),
                        TextSpan(text: firstPart),
                        TextSpan(
                            text: errorPart,
                            style: const TextStyle(color: Colors.red)),
                        TextSpan(text: lastPart),
                      ],
                    )),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(119.w, 0, 119.w, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 208.w,
                          height: 72.h,
                          child: submitButton(
                            isActive: true,
                            label: tr('waterPump.searchagarn'),
                            onClick: () async {
                              checkagarn();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 208.w,
                          height: 72.h,
                          child: normalButton(
                            label: tr('waterPump.showresult'),
                            onClick: () async {
                              Get.to(() =>
                                  protocolTablePage(reportdata: reportdata));
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

class PumpCheckLog {
  final String uuid;
  final String? userId;
  final String username;
  final String sn;
  final String address;
  final String mode1;
  final int open1;
  final int feedback1;
  final int speed1;
  final String mode2;
  final int open2;
  final int feedback2;
  final int speed2;
  final String location;
  final int result;
  final DateTime time;
  final int report;

  PumpCheckLog({
    required this.uuid,
    this.userId,
    required this.username,
    required this.sn,
    required this.address,
    required this.mode1,
    required this.open1,
    required this.feedback1,
    required this.speed1,
    required this.mode2,
    required this.open2,
    required this.feedback2,
    required this.speed2,
    required this.location,
    required this.result,
    required this.time,
    required this.report,
  });

  factory PumpCheckLog.fromJson(Map<String, dynamic> json) {
    return PumpCheckLog(
      uuid: json['uuid'],
      userId: json['user_id'],
      username: json['username'],
      sn: json['sn'],
      address: json['address'],
      mode1: json['mode1'],
      open1: json['open1'],
      feedback1: json['feedback1'],
      speed1: json['speed1'],
      mode2: json['mode2'],
      open2: json['open2'],
      feedback2: json['feedback2'],
      speed2: json['speed2'],
      location: json['location'],
      result: json['result'],
      time: DateTime.parse(json['time']),
      report: json['report'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'user_id': userId,
      'username': username,
      'sn': sn,
      'address': address,
      'mode1': mode1,
      'open1': open1,
      'feedback1': feedback1,
      'speed1': speed1,
      'mode2': mode2,
      'open2': open2,
      'feedback2': feedback2,
      'speed2': speed2,
      'location': location,
      'result': result,
      'time': time.toIso8601String(),
      'report': report,
    };
  }
}
