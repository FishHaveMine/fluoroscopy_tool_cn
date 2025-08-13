import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/bottomSelectSheet.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'line_chart.dart';

class electronicExpansionValve extends StatefulWidget {
  electronicExpansionValve({super.key});

  @override
  State<electronicExpansionValve> createState() =>
      _electronicExpansionValveState();
}

class _electronicExpansionValveState extends State<electronicExpansionValve> {
  static const platform =
      MethodChannel('samples.flutter.dev/ElectronicService');
  late Timer _timer;
  String T2A = "--";
  String T2 = "--";
  String T2B = "--";
  String T1 = "--";
  String MaxStep = "STEP_480P";
  List MaxSteplist = ["STEP_480P", "STEP_2000P", "STEP_3000P"];

  final deviceInfoController _deviceInfoController = Get.find();
  var info = {
    "address": "",
    "SN": "",
    "running": "1",
    "open": "",
    "con": "0",
  };

  Future<bool> reset() async {
    try {
      EasyLoading.show(status: '${tr('reseting')}...');
      var getExv = await platform.invokeMethod('reset');
      await Future.delayed(const Duration(seconds: 1));
      EasyLoading.dismiss();
      return true;
    } on PlatformException catch (e) {
      return true;
    }
  }

  fallBack() async {
    // try {
    //   var gteMaxStep = await platform.invokeMethod('fallBack');
    //   print("gteMaxStep fallBack: ${gteMaxStep}");
    // } on PlatformException catch (e) {
    //   print("gteMaxStep: $e");
    // }
  }

  gteMaxStep() async {
    try {
      if (!_deviceInfoController.loacalDevice.value.isconnected) {
        return;
      }
      var gteMaxStep = await platform.invokeMethod('gteMaxStep');
      var historydata = jsonDecode(gteMaxStep);
      setState(() {
        MaxStep = historydata["data"];
      });
      print("gteMaxStep setControlExv: ${historydata}");
    } on PlatformException catch (e) {
      print("gteMaxStep: $e");
    }
  }

  init() async {
    try {
      var getExv = await platform.invokeMethod('getExv');
      String open = getExv.toString() != "null" ? "$getExv pls" : "--";
      String con = getExv.toString() == "null"
          ? "0"
          : getExv.toString() == "0.0"
              ? "0"
              : "1";
      if (info["open"] != open) {
        setState(() {
          info["open"] = open;
        });
      }

      // if (info["con"] != con) {
      //   setState(() {
      //     info["con"] = con;
      //   });
      // }
    } on PlatformException catch (e) {}
  }

  bool iscontrolExv = false;
  setControlExv(isopen) async {
    if (!iscontrolExv) {
      try {
        setState(() {
          iscontrolExv = true;
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text("当前下发类型：${tr(MaxStep)}"),
        //     duration: const Duration(seconds: 2),
        //   ),
        // );

        print("gteMaxStep setControlExv: ${{
          "exvSteps": MaxSteplist.indexOf(MaxStep),
          "isMax": isopen
        }}");
        var controlExvback = await platform.invokeMethod('controlExv',
            {"exvSteps": MaxSteplist.indexOf(MaxStep), "isMax": isopen});

        setState(() {
          iscontrolExv = false;
        });

        // EasyLoading.show(status: '运作中...');
      } on PlatformException catch (e) {
        setState(() {
          iscontrolExv = false;
        });
      }
    } else {
      EasyLoading.showError(tr("iscontrolexv"));
    }
  }

  setRunning(val) {
    print("selectedIndex setRunning : $val");
    if (val.toString() == "-1") {
      return;
    }
    setState(() {
      info["running"] = val;
    });
  }

  setCon(val) {
    if (val.toString() == "-1") {
      return;
    }
    setState(() {
      info["con"] = val;
    });
    setControlExv(val.toString() == "0");
  }

  initRunning() async {
    if (_deviceInfoController.indoorEntityList.isEmpty) {
      return;
    }
    await fallBack();

    init();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      init();
    });
    var address = _deviceInfoController.indoorEntityList[0]["address"];
    var val = _deviceInfoController.indoorEntityList[0]["mode"];

    T2A = "${_deviceInfoController.indoorEntityList[0]["t2ATemp"]}℃";
    T2 = "${_deviceInfoController.indoorEntityList[0]["t2Temp"]}℃";
    T2B = "${_deviceInfoController.indoorEntityList[0]["t2BTemp"]}℃";
    T1 =
        "${_deviceInfoController.indoorEntityList[0]["elecHeatingTempT1Setting"]}℃";

    var imageUrl = "";
    switch (val) {
      case 'RunMode_0':
        imageUrl = '0';
        break;
      case 'RunMode_2':
        imageUrl = '1';
        break;
      case 'RunMode_7':
        imageUrl = '1';
        break;
      case 'RunMode_6':
        imageUrl = '1';
        break;
      case 'RunMode_1':
        imageUrl = '1';
        break;
      case 'RunMode_3':
        imageUrl = '2';
        break;
      default:
        imageUrl = '1';
    }
    setState(() {
      info["running"] = "1";
      info["address"] = "$address#";
      T2A;
      T2;
      T2B;
      T1;
    });
  }

  static const _selfplatform =
      MethodChannel('samples.flutter.dev/RefrigerantService');
  Future<bool> isV8() async {
    try {
      if (!_deviceInfoController.loacalDevice.value.isconnected) {
        return false;
      }
      var getProtocol =
          await _selfplatform.invokeMethod('getProtocol', <String, dynamic>{});
      var data = jsonDecode(getProtocol);
      bool isv8 = data["data"].toString().contains("V8");
      return isv8;
    } catch (e) {
      return false;
    }
  }

  _checkpass() async {
    // bool ispass = await isV8();
    // if (ispass) {
    // } else {
    //   Get.offAllNamed('/home'); //
    // }
  }

  @override
  void initState() {
    super.initState();
    _checkpass();
    initRunning();
    gteMaxStep();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool issend = await divConfirmOnlyDialog(context,
          confirmTitle: tr("device.checkDataController.confirmTitle"),
          confirmDescriptionWidget: SizedBox(
            width: 560.w,
            height: 200.h,
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: Text(
                'electronicExpansionValve.main',
                style: normalText(),
              ).tr(),
            )),
          ));
    });

    setState(() {
      info["SN"] = _deviceInfoController.loacalDevice.value.sn;
    });
  }

  @override
  void dispose() {
    super.dispose();
    try {
      _timer.cancel();
    } catch (e) {}
  }

  List showingList = [
    [
      "address",
      "SN",
      "running",
    ],
    [
      // "open",
      "con",
    ]
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // bool issend = await divConfirmOnlyDialog(context,
          //     confirmTitle: tr("device.checkDataController.confirmTitle"),
          //     confirmDescriptionWidget: SizedBox(
          //         width: 560.w,
          //         height: 200.h,
          //         child: SingleChildScrollView(
          //           child: Padding(
          //             padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          //             child: Text(
          //               'electronicExpansionValve.main',
          //               style: normalText(),
          //             ).tr(),
          //           ),
          //         )));
          await reset();
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () async {
                    // bool issend = await divConfirmOnlyDialog(context,
                    //     confirmTitle:
                    //         tr("device.checkDataController.confirmTitle"),
                    //     confirmDescriptionWidget: SizedBox(
                    //       width: 560.w,
                    //       height: 200.h,
                    //       child: SingleChildScrollView(
                    //           child: Padding(
                    //         padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    //         child: Text(
                    //           'electronicExpansionValve.main',
                    //           style: normalText(),
                    //         ).tr(),
                    //       )),
                    //     ));
                    await reset();
                    Get.offAllNamed('/home'); //
                  },
                  icon: const Icon(Icons.chevron_left,
                      color: Colors.black, size: 36)),
              title: const Text(
                'electronicExpansionValve.title',
                style: TextStyle(color: Colors.black),
              ).tr(),
              centerTitle: true,
              actions: [],
            ),
            body: Container(
                width: 720.w,
                height: 1280.h,
                color: const Color.fromRGBO(244, 244, 244, 1),
                padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int index = 0;
                          index < showingList[0].length;
                          index++)
                        InkWell(
                            onTap: () async {
                              if (index == 2) {
                                List op = [];
                                for (var i = 1; i < 3; i++) {
                                  op.add({
                                    'label': tr(
                                        'electronicExpansionValve.running.type$i'),
                                    'name': tr(
                                        'electronicExpansionValve.running.type$i'),
                                    'value': i
                                  });
                                }
                                Future<sheetBack?> selectedIndex =
                                    await showCustomModalBottomSheet(
                                        isMultiple: false,
                                        context,
                                        [...op],
                                        // ignore: unrelated_type_equality_checks
                                        baseValue: [
                                          info[showingList[0][index]].toString()
                                        ],
                                        titleName: tr(
                                            "electronicExpansionValve.showtype${index + 1}"));
                                selectedIndex.then((value) => {
                                      if (value != null &&
                                          value.baseValue![0] != -1 &&
                                          info[showingList[0][index]]
                                                  .toString() !=
                                              value.baseValue![0].toString())
                                        {
                                          setRunning(
                                              value.baseValue![0].toString())
                                        }
                                    });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color.fromRGBO(223, 223, 223, 1),
                                      width: 0.5,
                                    ),
                                  )),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(32.w, 0, 32.w, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: 720.w / 2, // 设置最大宽度
                                        ),
                                        child: Text(
                                          "electronicExpansionValve.showtype${index + 1}",
                                          style: normalTextBlack(),
                                        ).tr()),
                                    Row(
                                      children: [
                                        Text(
                                          index == 2
                                              ? tr(
                                                  "electronicExpansionValve.running.type${info[showingList[0][index]]!}")
                                              : info[showingList[0][index]]!,
                                          style: normalText(),
                                        ),
                                        if (index == 2)
                                          const Icon(
                                            Icons.arrow_drop_down,
                                            color: Color.fromRGBO(
                                                179, 179, 179, 1),
                                          )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )),
                      Container(
                          width: 720.w,
                          height: 230,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 32.w),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 27 + 20,
                                child: Image.asset(
                                  'public/images/electronicExpansionValve/${info["running"] == "2" ? "hot_doing.gif" : info["running"] == "0" ? "closestatus.png" : "cool_doing.gif"}',
                                  width: 346.w + 110.w,
                                ),
                              ),
                              Positioned(
                                top: 0 + 20,
                                left: 22.w,
                                child: Column(
                                  children: [
                                    Text(
                                      info["open"] ?? "--",
                                      style: normalTextBlack(
                                          fw: FontWeight.w700, fSize: 10),
                                    ),
                                    ChatBubble(
                                      message: "EXV",
                                      istop: 2,
                                      color: const Color.fromRGBO(
                                          101, 101, 101, 1),
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 0 + 20,
                                left: 165.w,
                                child: Column(
                                  children: [
                                    Text(
                                      T2A,
                                      style: normalTextBlack(
                                          fontcolor: const Color.fromRGBO(
                                              63, 208, 82, 1),
                                          fw: FontWeight.w700,
                                          fSize: 10),
                                    ),
                                    ChatBubble(
                                      message: "T2A",
                                      istop: 2,
                                      color:
                                          const Color.fromRGBO(63, 208, 82, 1),
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 0 + 20,
                                left: 335.w,
                                child: Column(
                                  children: [
                                    ChatBubble(
                                      message: "IDU-0",
                                      istop: 2,
                                      color: const Color.fromRGBO(
                                          101, 101, 101, 1),
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 120 + 20,
                                left: 350.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ChatBubble(
                                      message: "T1",
                                      istop: 1,
                                      color:
                                          const Color.fromRGBO(63, 208, 82, 1),
                                    ),
                                    Text(
                                      T1,
                                      style: normalTextBlack(
                                          fontcolor: const Color.fromRGBO(
                                              63, 208, 82, 1),
                                          fw: FontWeight.w700,
                                          fSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 100 + 20,
                                left: 170.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ChatBubble(
                                      message: "T2B",
                                      istop: 1,
                                      color:
                                          const Color.fromRGBO(63, 208, 82, 1),
                                    ),
                                    Text(
                                      T2B,
                                      style: normalTextBlack(
                                          fontcolor: const Color.fromRGBO(
                                              63, 208, 82, 1),
                                          fw: FontWeight.w700,
                                          fSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 117.h + 20,
                                left: 500.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ChatBubble(
                                      message: "T2",
                                      istop: 3,
                                      color:
                                          const Color.fromRGBO(63, 208, 82, 1),
                                    ),
                                    Text(
                                      T2,
                                      style: normalTextBlack(
                                          fontcolor: const Color.fromRGBO(
                                              63, 208, 82, 1),
                                          fw: FontWeight.w700,
                                          fSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 75.h + 20,
                                left: 30.w,
                                child: Image.asset(
                                    'public/images/electronicExpansionValve/close.png',
                                    width: 40.w),
                              ),
                              Positioned(
                                top: 76.h + 20,
                                left: 180.w,
                                child: Image.asset(
                                    'public/images/electronicExpansionValve/fa.png',
                                    width: 46.w),
                              ),
                              Positioned(
                                top: 85 + 20,
                                left: 180.w,
                                child: Image.asset(
                                    'public/images/electronicExpansionValve/fa.png',
                                    width: 46.w),
                              ),
                              Positioned(
                                top: 100 + 20,
                                left: 350.w,
                                child: Image.asset(
                                    'public/images/electronicExpansionValve/fa.png',
                                    width: 46.w),
                              ),
                              Positioned(
                                top: 117.h + 20,
                                left: 440.w,
                                child: Image.asset(
                                    'public/images/electronicExpansionValve/fa.png',
                                    width: 46.w),
                              )
                            ],
                          )),
                      InkWell(
                          onTap: () async {
                            List op = [];
                            for (var i = 0; i < MaxSteplist.length; i++) {
                              op.add({
                                'label':
                                    '${tr(MaxSteplist[i])}${i > 0 ? '(暂未开放)' : ''}',
                                'name':
                                    '${tr(MaxSteplist[i])}${i > 0 ? '(暂未开放)' : ''}',
                                'value': MaxSteplist[i],
                                'disabled': i > 0 ? true : null
                              });
                            }
                            Future<sheetBack?> selectedIndex =
                                await showCustomModalBottomSheet(
                                    isMultiple: false,
                                    context,
                                    [...op],
                                    // ignore: unrelated_type_equality_checks
                                    baseValue: [MaxStep],
                                    titleName: tr("maxsteptype"));
                            selectedIndex.then((value) => {
                                  if (value != null &&
                                      value.baseValue![0] != -1)
                                    {
                                      print(
                                          "gteMaxStep value.baseValue![0] : ${value.baseValue![0]}"),
                                      setState(() {
                                        MaxStep = value.baseValue![0];
                                      })
                                    }
                                });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(223, 223, 223, 1),
                                    width: 0.5,
                                  ),
                                )),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(32.w, 0, 32.w, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: (720.w - 64.w) / 2, // 设置最大宽度
                                      ),
                                      child: Text(
                                        "maxsteptype",
                                        style: normalTextBlack(),
                                      ).tr()),
                                  Row(
                                    children: [
                                      Text(
                                        tr(MaxStep),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: normalText(),
                                      ),
                                      const Icon(
                                        Icons.arrow_drop_down,
                                        color: Color.fromRGBO(179, 179, 179, 1),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )),
                      for (int index = 0;
                          index < showingList[1].length;
                          index++)
                        InkWell(
                            onTap: () async {
                              if (index == 0) {
                                if (iscontrolExv) {
                                  EasyLoading.showError(tr("iscontrolexv"));
                                  return;
                                }
                                List op = [];
                                for (var i = 0; i < 2; i++) {
                                  op.add({
                                    'label': tr(
                                        'electronicExpansionValve.con.type$i'),
                                    'name': tr(
                                        'electronicExpansionValve.con.type$i'),
                                    'value': i
                                  });
                                }
                                Future<sheetBack?> selectedIndex =
                                    await showCustomModalBottomSheet(
                                        isMultiple: false,
                                        context,
                                        [...op],
                                        // ignore: unrelated_type_equality_checks
                                        baseValue: [
                                          info[showingList[0][index]].toString()
                                        ],
                                        titleName: tr(
                                            "electronicExpansionValve.showtype${index + 4}"));
                                selectedIndex.then((value) => {
                                      if (value != null &&
                                          value.baseValue![0] != -1 &&
                                          info[showingList[0][index]]
                                                  .toString() !=
                                              value.baseValue![0].toString())
                                        {setCon(value.baseValue![0].toString())}
                                    });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color.fromRGBO(223, 223, 223, 1),
                                      width: 0.5,
                                    ),
                                  )),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(32.w, 0, 32.w, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth:
                                              (720.w - 64.w) / 2, // 设置最大宽度
                                        ),
                                        child: Text(
                                          "electronicExpansionValve.showtype${1 + 4}",
                                          style: normalTextBlack(),
                                        ).tr()),
                                    Row(
                                      children: [
                                        Text(
                                          index == 0
                                              ? tr(
                                                  "electronicExpansionValve.con.type${info[showingList[1][0]]!}")
                                              : info[showingList[1][0]]!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: normalText(),
                                        ),
                                        if (index == 0)
                                          const Icon(
                                            Icons.arrow_drop_down,
                                            color: Color.fromRGBO(
                                                179, 179, 179, 1),
                                          )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )),
                      const LineChartSample2(),
                      Container(
                        width: 720.w,
                        height: 538.h,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0), // 圆角半径
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "electronicExpansionValve.tip",
                                style:
                                    normalTextBlack(fSize: 18, lineheight: 1.5),
                              ).tr(),
                              Text(
                                "electronicExpansionValve.tip1",
                                style: normalTextBlack(lineheight: 1.5),
                              ).tr(),
                              for (int index = 0; index < 2; index++)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "electronicExpansionValve.tip${index + 2}",
                                      style: normalTextBlack(lineheight: 1.5),
                                    ).tr(),
                                    Expanded(
                                        child: Text(
                                      "electronicExpansionValve.tip${index + 2}-1",
                                      style: normalText(lineheight: 1.5),
                                    ).tr())
                                  ],
                                ),
                              Text(
                                "electronicExpansionValve.tip4",
                                style: normalTextBlack(lineheight: 1.5),
                              ).tr(),
                              for (int index = 0; index < 2; index++)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "electronicExpansionValve.tip${index + 5}",
                                      style: normalTextBlack(lineheight: 1.5),
                                    ).tr(),
                                    Expanded(
                                        child: Text(
                                      "electronicExpansionValve.tip${index + 5}-1",
                                      style: normalText(lineheight: 1.5),
                                    ).tr())
                                  ],
                                ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ))));
  }
}

class ChatBubble extends StatelessWidget {
  String message;
  int istop;
  Color color;

  ChatBubble({required this.message, required this.istop, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Stack(
        children: [
          Column(
            children: [
              if (istop == 1)
                const SizedBox(
                  height: 5,
                ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: color,
                ),
                // margin: EdgeInsets.fromLTRB(
                //     0, istop == 1 ? 5 : 0, 0, istop == 2 ? 0 : 5),
                padding:
                    const EdgeInsets.symmetric(vertical: 3.0, horizontal: 6.0),
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 9),
                ),
              ),
            ],
          ),
          if (istop == 2)
            Positioned(
                left: message.length.toDouble(),
                bottom: -8,
                child: Icon(
                  Icons.arrow_drop_down,
                  color: color,
                )),
          if (istop == 1)
            Positioned(
                left: message.length.toDouble(),
                top: -8,
                child: Icon(
                  Icons.arrow_drop_up,
                  color: color,
                )),
        ],
      ),
    );
  }
}
