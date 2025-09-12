import 'dart:convert';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/snInput.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/afterSalesReplacement/style.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class unlockhistory extends StatefulWidget {
  const unlockhistory({super.key});
  @override
  State<unlockhistory> createState() => _unlockhistoryState();
}

class _unlockhistoryState extends State<unlockhistory> {
  static const platform = MethodChannel('samples.flutter.dev/battery');
  static const _snplatform =
      MethodChannel('samples.flutter.dev/writeSnService');

  final deviceInfoController _deviceInfoController = Get.find();
  String sn = '';
  int showingType = 0;
  List typeCount = [0, 0, 0, 0, 0];
  List data = [];
  int pageindex = 1;
  int maxindex = 1;

  ScrollController _scrollController = ScrollController();

  final GlobalKey<snInputState> _key = GlobalKey<snInputState>();

  initcount() async {
    var allData =
        await platform.invokeMethod('unLockgetData', <String, dynamic>{
      "isall": true,
      "report": 0,
      "result": 1,
      "pageindex": 1,
    });

    var jsondata1 = jsonDecode(allData);
    if (jsondata1["success"]) {
      typeCount[0] = jsondata1["totalCount"];
    }

    var reportData =
        await platform.invokeMethod('unLockgetData', <String, dynamic>{
      "isall": false,
      "report": 1,
      "pageindex": 1,
    });
    var jsondata2 = jsonDecode(reportData);
    if (jsondata2["success"]) {
      typeCount[3] = jsondata2["totalCount"];
      typeCount[4] = typeCount[0] - jsondata2["totalCount"];
    }

    var resultData =
        await platform.invokeMethod('unLockgetData', <String, dynamic>{
      "isall": false,
      "result": 0,
      "pageindex": 1,
    });

    var jsondata3 = jsonDecode(resultData);
    if (jsondata3["success"]) {
      typeCount[2] = jsondata3["totalCount"];
      typeCount[1] = typeCount[0] - jsondata3["totalCount"];
    }
    setState(() {
      typeCount;
    });
  }

  String formatTimestamp(int? timestamp) {
    if (timestamp == null) {
      return "--";
    } else {
      var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      var formatter = DateFormat('yyyy/MM/dd HH:mm');
      return formatter.format(date);
    }
  }

  static const _colundplatform =
      MethodChannel('samples.flutter.dev/getDeviceUnlockHandler');

  upclound(unLockdata) async {
    if (unLockdata["report"] == 1) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    var useinfoSting = prefs.getString("useinfo");
    String phone = "";
    if (useinfoSting != null) {
      try {
        var useinfo = jsonDecode(useinfoSting);
        phone = useinfo["phone"];
      } catch (e) {}
    }
    String? usernameprefs = await prefs.getString("usernameA");
    var _colundupload = await _colundplatform
        .invokeMethod('insertOperationLog', <String, dynamic>{
      "deviceSn": unLockdata["sn"],
      "executionResult": unLockdata["result"] == 1 ? "成功" : "失败",
      "number": "",
      "phone": phone,
      "uid": unLockdata["username"],
      "operation": unLockdata["msg"],
      "location": unLockdata["location"],
    });
    var bakc = jsonDecode(_colundupload);
    if (bakc["success"]) {
      var updateReport = await platform.invokeMethod(
          'updateReport', <String, dynamic>{"id": unLockdata["id"]});
    }
    data = [];
    initcount();
    init();
  }

  init() async {
    if (data.isNotEmpty && data.length >= typeCount[0]) {
      return;
    }

    EasyLoading.show(status: 'loading...');
    var unLockgetData =
        await platform.invokeMethod('unLockgetData', <String, dynamic>{
      "isall": showingType == 0 && sn == "",
      "sn": sn == "" ? null : sn,
      "result": showingType == 1
          ? 1
          : showingType == 2
              ? 0
              : null,
      "report": showingType == 3
          ? 1
          : showingType == 4
              ? 0
              : null,
      "pageindex": pageindex,
    });
    var jsondata = jsonDecode(unLockgetData);
    if (jsondata["success"]) {
      maxindex = jsondata['totalCount'];
      for (var element in jsondata["data"]) {
        data.add({
          "sn": element["sn"],
          "parameter1": element["device_type"].toString(),
          "parameter2":
              formatTimestamp(int.tryParse(element["time"].toString())),
          "parameter3": element["location"],
          "parameter4": element["result"] == 1
              ? 'unlockhistory.unlocksuccess'
              : "unlockhistory.unlockerror",
          "parameter5": element["report"] == 1
              ? 'unlockhistory.upcloudsuccess'
              : "unlockhistory.upclouderror",
          ...element
        });
      }
    }
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        data;
      });
      EasyLoading.dismiss();
    });
  }

  openscan() async {
    try {
      await platform.invokeMethod('SCANNER_TRIG');
    } on PlatformException catch (e) {
      print("Failed to SCANNER_TRIG: '${e.message}'.");
    }
  }

  searchsn() {
    pageindex = 1;
    data = [];
    init();
  }

  @override
  void initState() {
    super.initState();
    initcount();
    init();
    _scrollController.addListener(() {
      // 判断是否滚动到了列表底部
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (data.length != maxindex) {
          pageindex++;
          init(); // 加载更多数据
        }
      }
    });
  }

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
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.chevron_left,
                      color: Colors.black, size: 36)),
              title: const Text(
                'deviceUnlock.unlockhistory',
                style: TextStyle(color: Colors.black),
              ).tr(),
              centerTitle: true,
              actions: [],
            ),
            body: Stack(children: <Widget>[
              Container(
                  width: 720.w,
                  height: 1280.h,
                  color: const Color.fromRGBO(245, 245, 245, 1),
                  padding: EdgeInsets.fromLTRB(32.w, 24.h, 32.w, 24.h),
                  child: Column(
                    children: [
                      Container(
                          padding: EdgeInsets.fromLTRB(0.w, 0, 0.w, 24.h),
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(0, 24.h, 0, 0.h),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            Positioned(
                                                child: Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  0, 0, 0, 0),
                                              padding: const EdgeInsets.all(0),
                                              height: 44,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(42),
                                                  color: Colors.white),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      openscan();
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          20, 0, 10, 0),
                                                      child: Image.asset(
                                                        'public/images/waterPump/scran.png',
                                                        width: 16,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 0, 0, 0),
                                                        child: snInput(
                                                          key: _key,
                                                          isSamll: true,
                                                          onfocus: () {},
                                                          valBack: (back) {
                                                            setState(() {
                                                              sn = back;
                                                            });
                                                            if (back == "") {
                                                              searchsn();
                                                            }
                                                          },
                                                        )),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      _key.currentState?.fun();
                                                      searchsn();
                                                    },
                                                    child: Container(
                                                      width: 75,
                                                      height: 36,
                                                      margin:
                                                          const EdgeInsets.all(
                                                              5),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(49),
                                                          color: const Color
                                                                  .fromRGBO(
                                                              25, 98, 255, 1)),
                                                      child: Center(
                                                        child: const Text(
                                                          'search',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14),
                                                        ).tr(),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )),
                                          ],
                                        )
                                      ],
                                    )),
                              ),
                              SizedBox(
                                  width: double.infinity,
                                  height: 120.w + 24.h,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(0, 24.h, 0, 0.h),
                                    child: GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 5,
                                        mainAxisSpacing: 10.0,
                                        crossAxisSpacing: 10.0,
                                        childAspectRatio: 1.0,
                                      ),
                                      itemCount: 5,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              showingType = index;
                                              pageindex = 1;
                                              data = [];
                                            });
                                            init();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: showingType == index
                                                  ? const Color(0xFF1962FF)
                                                  : Colors
                                                      .white, // 使用十六进制颜色代码设置背景色
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10), // 设置圆角
                                            ),
                                            height: 120.w,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 0, 5),
                                                  child: Text(
                                                    '${typeCount[index]}',
                                                    style: TextStyle(
                                                        color:
                                                            showingType == index
                                                                ? Colors.white
                                                                : Colors.black,
                                                        fontSize: 32 / 2),
                                                  ),
                                                ),
                                                Text(
                                                  tr('unlockhistory.type${index + 1}'),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color:
                                                          showingType == index
                                                              ? Colors.white
                                                              : const Color(
                                                                  0x7F0D0D0D),
                                                      fontSize: 12),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ))
                            ],
                          )),
                      Expanded(
                          child: ListView.builder(
                              controller: _scrollController,
                              itemCount: data.length,
                              itemBuilder: ((context, index) => InkWell(
                                    onTap: () {
                                      upclound(data[index]);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(24.w,
                                          index == 0 ? 24.w : 0.w, 24.w, 12.w),
                                      color: Colors.white,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 0, 0.h),
                                            child: Text(
                                              data[index]["sn"],
                                              style: tipStyle(),
                                            ),
                                          ),
                                          for (int parameterindex = 0;
                                              parameterindex < 5;
                                              parameterindex++)
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 5, 0),
                                                  child: Text(
                                                    '${tr("unlockhistory.parameter${parameterindex + 1}")}:',
                                                    style: normalText(),
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                                '${data[index]["parameter${parameterindex + 1}"]}',
                                                                style:
                                                                    normalText(
                                                                        fontcolor: parameterindex <
                                                                                3
                                                                            ? Colors
                                                                                .black
                                                                            : [
                                                                                'unlockhistory.unlocksuccess',
                                                                                'unlockhistory.upcloudsuccess'
                                                                              ].contains(data[index]["parameter${parameterindex + 1}"])
                                                                                ? const Color.fromRGBO(51, 208, 83, 1)
                                                                                : const Color.fromRGBO(255, 133, 25, 1)))
                                                            .tr()),
                                                    if ([
                                                      'unlockhistory.upclouderror',
                                                    ].contains(data[index][
                                                        "parameter${parameterindex + 1}"]))
                                                      InkWell(
                                                        onTap: () {
                                                          upclound(data[index]);
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4),
                                                              margin: const EdgeInsets
                                                                      .fromLTRB(
                                                                  0, 0, 5, 0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Colors
                                                                    .white,
                                                                border:
                                                                    Border.all(
                                                                  color: const Color
                                                                          .fromRGBO(
                                                                      151,
                                                                      151,
                                                                      151,
                                                                      1),
                                                                  width: 0.5,
                                                                ),
                                                              ),
                                                              child:
                                                                  const Center(
                                                                child: Icon(
                                                                  Icons.upload,
                                                                  size: 18,
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              'unlockhistory.upcloud',
                                                              style:
                                                                  normalTextBlack(
                                                                      fSize:
                                                                          12),
                                                            ).tr()
                                                          ],
                                                        ),
                                                      )
                                                  ],
                                                ))
                                              ],
                                            ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 12.w, 0, 0),
                                            child: const Divider(),
                                          )
                                        ],
                                      ),
                                    ),
                                  ))))
                    ],
                  )),
            ])));
  }
}

// 生成随机的 SN（序列号）
String generateRandomSN() {
  String characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();
  String sn = '';
  for (int i = 0; i < 22; i++) {
    sn += characters[random.nextInt(characters.length)];
  }
  return sn;
}

// 随机设备类型
String getRandomDeviceType() {
  List<String> deviceTypes = [
    'Smartphone',
    'Tablet',
    'Laptop',
    'Desktop',
    'Smartwatch'
  ];
  return deviceTypes[Random().nextInt(deviceTypes.length)];
}

// 生成随机的解锁时间
String generateRandomDateTime() {
  DateTime now = DateTime.now();
  int randomSeconds =
      Random().nextInt(60 * 60 * 24 * 365); // Up to one year in seconds
  return DateFormat('yyyy/MM/dd HH:mm:ss')
      .format(now.subtract(Duration(seconds: randomSeconds)));
}

// 随机解锁地点
String getRandomUnlockLocation() {
  List<String> locations = ['Home', 'Office', 'School', 'Gym', 'Park'];
  return locations[Random().nextInt(locations.length)];
}
