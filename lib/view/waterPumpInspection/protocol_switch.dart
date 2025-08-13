import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class protocolSwitchPage extends StatefulWidget {
  int connectionSettings;
  protocolSwitchPage({super.key, required this.connectionSettings});
  @override
  State<protocolSwitchPage> createState() => _protocolSwitchPageState();
}

class _protocolSwitchPageState extends State<protocolSwitchPage> {
  int _remainingSeconds = 120;
  late Timer _timer;

  static const platform = MethodChannel('samples.flutter.dev/battery');
  toSetting() async {
    var AddressChangeBack = await platform.invokeMethod('setParametersPageInfo',
        {"connectionSettings": widget.connectionSettings});

    var data = jsonDecode(AddressChangeBack);
    if (data["data"]) {
      EasyLoading.showSuccess(tr("setParametersPageInfo.success"));
    } else {
      EasyLoading.showError(tr("setParametersPageInfo.error"));
    }
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer.cancel();
        }
      });
    });
    toSetting();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'public/images/waterPump/loading.gif',
              width: 280,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 40.h, 0, 16.h),
              child: Text(
                tr('waterPump.switch'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromRGBO(13, 13, 13, 1),
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              key: ValueKey('_remainingSeconds:$_remainingSeconds'),
              padding: EdgeInsets.fromLTRB(0, 0.h, 0, 64.h),
              child: Text(
                  tr('waterPump.switching', namedArgs: {
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
              child: submitButton(
                isActive: false,
                label: tr('cancel'),
                onClick: () async {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
