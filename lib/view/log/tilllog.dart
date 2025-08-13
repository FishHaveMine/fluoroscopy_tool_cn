import 'dart:async';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class tilllog extends StatefulWidget {
  const tilllog({super.key});

  @override
  State<tilllog> createState() => _tilllogState();
}

class _tilllogState extends State<tilllog> {
  static const platformbattery =
      const MethodChannel('samples.flutter.dev/battery');
  String consoleOutput = '';

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  Timer? _timer;
  Future<void> _startListening() async {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      handleTimeout();
    });
  }

  @override
  void dispose() {
    // 在组件销毁时取消定时器
    if (_timer != null) _timer?.cancel();
    dellog();
    super.dispose();
  }

  createLog() async {
    // callback function
    try {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      bool createLogFile = await platformbattery.invokeMethod(
          'createLogFile', {'fileName': "app_log_$formattedDate.txt"});
      print('createLogFile:$createLogFile');
    } catch (e) {
      print(e);
    }
    _startListening();
  }

  Future<void> handleTimeout() async {
    // callback function
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final String content = await platformbattery.invokeMethod(
        'readLogFile', {'fileName': "app_log_$formattedDate.txt"});
    setState(() {
      consoleOutput = content;
    });
  }

  Future<void> dellog() async {
    // callback function
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    await platformbattery.invokeMethod(
        'clearFileContent', {'fileName': "app_log_$formattedDate.txt"});
  }

  topolling() {
    print('to startPolling');
    try {
      platformbattery.invokeMethod('startPolling');
    } on PlatformException catch (e) {
      print("Failed to SCANNER_TRIG: '${e.message}'.");
    }
  }

  List<String> menuItems = [
    '开启',
    '停止',
    '清空',
  ];

  CustomPopupMenuController _controller = CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(43, 103, 234, 1),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon:
                const Icon(Icons.chevron_left, color: Colors.white, size: 36)),
        title: Text('日志'),
        centerTitle: true,
        actions: [
          CustomPopupMenu(
            horizontalMargin: 20.0,
            verticalMargin: 0.0,
            arrowColor: Colors.white,
            menuBuilder: () => ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                color: Colors.white,
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: menuItems
                        .map(
                          (item) => GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              _controller.hideMenu();
                              if (item == '开启') {
                                topolling();
                              } else if (item == '清空') {
                                dellog();
                              } else {
                                print('to stopPolling');
                                try {
                                  platformbattery.invokeMethod('stopPolling');
                                } on PlatformException catch (e) {
                                  print(
                                      "Failed to SCANNER_TRIG: '${e.message}'.");
                                }
                              }
                            },
                            child: Container(
                              height: 40,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      // margin:
                                      //     const EdgeInsets.only(left: 10),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Text(
                                        tr(item),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
            pressType: PressType.singleClick,
            controller: _controller,
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 16.0),
                text: consoleOutput,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
