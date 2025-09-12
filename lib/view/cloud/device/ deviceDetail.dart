import 'dart:async';
import 'dart:convert';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/bottomSelectSheet.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/store/http.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/cloud/device/SprinklerSetting.dart';
import 'package:fluoroscopy_tool/view/cloud/publicFunction.dart';
import 'package:fluoroscopy_tool/view/errorAnalysis/cloundErrorList.dart';
import 'package:fluoroscopy_tool/view/parametersSetting/clound.dart';
import 'package:fluoroscopy_tool/view/trialRun/result.dart';
import 'package:fluoroscopy_tool/view/userinfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_table/table_sticky_headers.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../../local/checkData/class.dart';
import '../../local/publicFunction.dart';
import 'oldReformImageInfoWebList.dart';
import 'style.dart';

class deviceDetail extends StatefulWidget {
  deviceDetail({super.key});

  @override
  State<deviceDetail> createState() => _checkDataPageState();
}

class _checkDataPageState extends State<deviceDetail> {
  bool isload = true;
  bool isMODEL_OLD_CHANGE = false;
  static const platform =
      MethodChannel('samples.flutter.dev/getProjectHandler');
  final cloudProjectController _deviceInfoController = Get.find();

  final userinfoController _promissioncontroller = Get.find();
  late Timer _timer;

  final GlobalKey<_oldChangeState> _oldChangeStatekey =
      GlobalKey<_oldChangeState>();
  final GlobalKey<_tablePageState> _tablePageStatekey =
      GlobalKey<_tablePageState>();

  refresh(doing) async {
    doing();
    try {
      if (_timer != null) {
        _timer.cancel();
      }
    } catch (e) {}
    final prefs = await SharedPreferences.getInstance();

    _timer = Timer.periodic(Duration(seconds: 60), (timer) {
      doing();
      if (isMODEL_OLD_CHANGE && !isload) {
        _oldChangeStatekey.currentState?.refreshTable();
      }
      if (!isMODEL_OLD_CHANGE && !isload) {
        _tablePageStatekey.currentState?.refreshTable();
      }
    });
  }

  var nodeTr = {};
  initDatil() async {
    try {
      if (_timer != null && _timer.isActive) _timer.cancel();
    } catch (e) {}
    String sn = _deviceInfoController.selectDevice.value["sn"].isEmpty
        ? _deviceInfoController.selectDevice.value["gatewaySn"]
        : _deviceInfoController.selectDevice.value["sn"];

    var insertSearchHistory = await platform.invokeMethod(
        'getProfessionalToolsHandler.insertSearchHistory',
        {"deviceSn": sn, "projectDetail": ""});

    isMODEL_OLD_CHANGE =
        _deviceInfoController.selectDevice.value["netModelEnum"] != null &&
            _deviceInfoController.selectDevice.value["netModelEnum"] ==
                "MODEL_OLD_CHANGE";
    // print(
    //     "netModelEnum  ${isMODEL_OLD_CHANGE}:${_deviceInfoController.selectDevice.value["netModelEnum"]}");
    // isMODEL_OLD_CHANGE = true;
    setState(() {
      isMODEL_OLD_CHANGE;
    });
    _deviceInfoController.setisMODEL_OLD_CHANGE(isMODEL_OLD_CHANGE);
    EasyLoading.show(status: 'loading...');

    final prefs = await SharedPreferences.getInstance();
    try {
      if (!isMODEL_OLD_CHANGE) {
        String nid = _deviceInfoController.selectDevice.value["nid"];
        var getDetailBySnback = await platform
            .invokeMethod('getSystemDataHandler.getDetailBySn', {"sysid": nid});
        var info = jsonDecode(getDetailBySnback);
        // print('getSystemDataHandler.getDetailBySn: $info');
        if (info["success"]) {
          _deviceInfoController.setSelectDeviceinfo(info["data"]);
        }

        refresh(() async {
          try {
            String projectCode =
                _deviceInfoController.selectDevice.value['projectCode'] ?? "";
            // var sysDevCheckData = await platform.invokeMethod(
            //     'getDeviceHandler.sysDevCheckData', {"sysid": nid});

            var sys = await MideaApi.sysDevCheckDataV2(nid, projectCode);

            // var sys = jsonDecode(sysDevCheckData);
            // print('getSystemDataHandler.sysDevCheckData: $sys');
            for (var element in sys["data"].keys) {
              print(
                  'sysData.data - [${element}]: [${sys["data"]["$element"]}]');
            }
            if (sys["success"]) {
              var sysmap = {};
              if (sys["data"]["sysData"] != null) {
                // for (var element in sys["data"]["sysData"]["properties"]) {
                //   print(
                //       'getSystemDataHandler.sysData.properties - [${element["title"]["cn"]}]: [${element["value"]}]');
                // }

                sysmap = fixValue(sys["data"]["sysData"], "system.", nodeTr);
                for (var element in sysmap.keys) {
                  print('sysmap.$element: ${sysmap[element]}');
                }
              }
              _deviceInfoController.setSysDevCheckData(sysmap);

              var outdoorList = [];
              if (sys["data"]["outdoorList"] != null) {
                fixValue(sys["data"]["outdoorList"][0], "outdoor.", nodeTr);
                for (var element in sys["data"]["outdoorList"]) {
                  outdoorList.add({}
                    ..addAll(element)
                    ..addAll(fixValue(element, "outdoor.", nodeTr)));
                }
                _deviceInfoController.setOutdoorList(outdoorList);
              } else {
                _deviceInfoController.setOutdoorList([]);
              }

              var compressorList = [];
              if (sys["data"]["compressorList"] != null) {
                fixValue(sys["data"]["compressorList"][0], "compressorlist.",
                    nodeTr);
                for (var element in sys["data"]["compressorList"]) {
                  compressorList.add({}
                    ..addAll(element)
                    ..addAll(fixValue(element, "compressorlist.", nodeTr)));
                }
                _deviceInfoController.setCompressorlist(compressorList);
              } else {
                _deviceInfoController.setCompressorlist([]);
              }

              var sensorList = [];
              if (sys["data"]["sensorList"] != null) {
                fixValue(sys["data"]["sensorList"][0], "sensorlist.", nodeTr);
                for (var element in sys["data"]["sensorList"]) {
                  sensorList.add({}
                    ..addAll(element)
                    ..addAll(fixValue(element, "sensorlist.", nodeTr)));
                }
                _deviceInfoController.setSensorList(sensorList);
              } else {
                _deviceInfoController.setSensorList([]);
              }

              var valveList = [];
              if (sys["data"]["valveList"] != null) {
                fixValue(sys["data"]["valveList"][0], "valvelist.", nodeTr);
                for (var element in sys["data"]["valveList"]) {
                  valveList.add({}
                    ..addAll(element)
                    ..addAll(fixValue(element, "valvelist.", nodeTr)));
                }
                _deviceInfoController.setValveList(valveList);
              } else {
                _deviceInfoController.setValveList([]);
              }

              // print(
              //     'getSystemDataHandler.outdoorList.length:  --------- ${outdoorList.where((number) => number["idx"] != "").toList().length}');
              var indoorList = [];

              if (sys["data"]["indoorList"] != null) {
                for (var element in sys["data"]["indoorList"]) {
                  indoorList.add({}
                    ..addAll(element)
                    ..addAll(fixValue(element, "indoor.", nodeTr)));
                }
              }
              _deviceInfoController.setIndoorList(indoorList);
            }
            _deviceInfoController.setNoderTr(nodeTr);

            setState(() {
              isload = false;
            });
            EasyLoading.dismiss();
          } catch (e) {
            setState(() {
              isload = false;
            });
            EasyLoading.dismiss();
          }
        });
      } else {
        /**
         * 旧改设备
         */
        String nid = _deviceInfoController.selectDevice.value["nid"];
        String sn = _deviceInfoController.selectDevice.value["sn"].isEmpty
            ? _deviceInfoController.selectDevice.value["gatewaySn"]
            : _deviceInfoController.selectDevice.value["sn"];
        var getDetailBySnSnback = await platform
            .invokeMethod('getSystemDataHandler.getDetailBySn', {"sysid": sn});
        var info = jsonDecode(getDetailBySnSnback);
        // print('getSystemDataHandler.getDetailBySn: $info');
        if (info["success"]) {
          _deviceInfoController.setSelectDeviceinfo(info["data"]);
        }

        refresh(() async {
          try {
            var snJumpModuleback = await platform.invokeMethod(
                'getAppFluorineMachineEnergyHandler.snJumpModule',
                {"sysid": sn});
            var snJumpModule = jsonDecode(snJumpModuleback);
            // print(
            //     "getAppFluorineMachineEnergyHandler.snJumpModule: $snJumpModule");

            if (snJumpModule["success"]) {
              _deviceInfoController.setsnJumpModule(snJumpModule["data"]);
            }
            if (snJumpModule["data"]["systemId"] != null) {
              var getRoutineCheckDataback = await platform.invokeMethod(
                  'getAppFluorineMachineEnergyHandler.getRoutineCheckData',
                  {"sn": sn, "id": snJumpModule["data"]["systemId"]});
              var sys = jsonDecode(getRoutineCheckDataback);
              if (sys["success"]) {
                var outdoorList = [];
                if (sys["data"]["vrfOutdoor"] != null) {
                  for (var element in sys["data"]["vrfOutdoor"]) {
                    outdoorList.add(fixoldchange(element["runParams"], nodeTr,
                        key: "outdoor."));
                  }
                }
                _deviceInfoController.setOutdoorList(outdoorList
                    .where((number) => number["idx"] != "")
                    .toList());

                var indoorList = [];
                if (sys["data"]["vrfInfoor"] != null) {
                  for (var element in sys["data"]["vrfInfoor"]) {
                    indoorList.add(fixoldchange(element["runParams"], nodeTr,
                        key: "indoor."));
                  }
                }
                _deviceInfoController.setIndoorList(
                    indoorList.where((number) => number["idx"] != "").toList());
              }
              _deviceInfoController.setNoderTr(nodeTr);
            }

            setState(() {
              isload = false;
            });
            EasyLoading.dismiss();
          } catch (e) {
            setState(() {
              isload = false;
            });
            EasyLoading.dismiss();
          }
        });
      }
    } catch (e) {
      setState(() {
        isload = false;
      });
      EasyLoading.dismiss();
    }
  }

  fixoldchange(data, nodeTr, {key = ""}) {
    var sysmap = {};
    if (data != null) {
      for (var element in data) {
        sysmap[element["nameEn"].toString().toLowerCase().replaceAll(" ", "")] =
            element["val"].toString();
        nodeTr[(key + element["nameEn"])
            .toString()
            .toLowerCase()
            .replaceAll(" ", "")] = element["name"];
      }
    }
    return sysmap;
  }

  fixValue(sys, key, nodeTr) {
    var sysmap = {};
    if (sys["properties"] != null) {
      for (var element in sys["properties"]) {
        // print("${element["name"]}  :   ${element["value"]}");
        if (element["name"] != null &&
            element["name"].runtimeType.toString() == "String") {
          // ignore: prefer_interpolation_to_compose_strings
          nodeTr[key + element["name"].toString().toLowerCase()] =
              element["title"]['cn'];

          // nodeTr[element["name"].toString().toLowerCase()] =
          //     element["title"]['cn'];

          if (element["propertyEnums"].runtimeType.toString() ==
                  "List<dynamic>" &&
              element["value"] != "") {
            List propertyEnums = element["propertyEnums"];
            var found = propertyEnums.firstWhere(
                (item) => item['val'] == element["value"],
                orElse: () => null);
            sysmap[element["name"].toString().toLowerCase()] =
                found != null ? found["desc"]["cn"] : element["value"];
          } else {
            sysmap[element["name"].toString().toLowerCase()] = element["value"];
          }
        } else {
          nodeTr[key + element["title"]['en'].toString().toLowerCase()] =
              element["title"]['cn'];
          // nodeTr[key + element["title"]['en']] = element["title"]['cn'];
          // nodeTr[element["title"]['en'].toString().toLowerCase()] =
          //     element["title"]['cn'];
        }
      }
    } else {
      sysmap = sys.map((key, value) {
        return MapEntry(
          key,
          value is Map && value.isEmpty ? '' : value,
        );
      });
    }
    return sysmap;
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    if (_promissioncontroller.checkCloundPromission("DeviceView_Archived",
            showtoast: false) ||
        _promissioncontroller.checkCloundPromission("DeviceView_Unarchived",
            showtoast: false)) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        initDatil();
      });
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pop(context);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _deviceInfoController.clean();
    EasyLoading.dismiss();
    try {
      if (_timer != null && _timer.isActive) _timer.cancel();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    // Get height of app bar
    double appBarHeight = AppBar().preferredSize.height;

    // Calculate remaining height for page content
    double contentHeight = MediaQuery.of(context).size.height - appBarHeight;
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromRGBO(43, 103, 234, 1),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.chevron_left,
                      color: Colors.white, size: 36)),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: Text(_deviceInfoController
                        .selectDevice.value["systemName"]
                        .toString()),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Text(
                      //   "程序版本${_deviceInfoController.sysData.value["systemName"]}",
                      //   style: normalTextWhilte(),
                      // ),
                      // const SizedBox(
                      //   width: 10,
                      // ),
                      Text(
                        "${_deviceInfoController.sysData.value["systemprotocoltype"] ?? "--"}${tr("local.model")}",
                        style: normalTextWhilte(),
                      )
                    ],
                  )
                ],
              ),
              centerTitle: true,
              actions: [
                TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Image.asset(
                          'public/images/checkData/import_export.png',
                          width: 36.w,
                        ),
                        const Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
                        Text(
                          'table.export',
                          style: versionValue(context),
                        ).tr()
                      ],
                    ))
              ],
            ),
            body: Container(
                width: 720.w,
                height: 1280.h,
                constraints: BoxConstraints(
                  minHeight: contentHeight,
                ),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('public/images/devicePageBg.png'),
                        fit: BoxFit.fill)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      deviceVersion(),
                      const deviceInfoPage(),
                      countODUandIDUPage(onSetCloundRefreshTime: () {
                        print(
                            "__________________ onSetCloundRefreshTime ________________________");
                        initDatil();
                      }),
                      if (!isMODEL_OLD_CHANGE && !isload)
                        tablePage(key: _tablePageStatekey),
                      if (isMODEL_OLD_CHANGE && !isload)
                        oldChange(key: _oldChangeStatekey)
                    ],
                  ),
                ))));
  }
}

class deviceVersion extends StatefulWidget {
  deviceVersion({super.key});

  @override
  State<deviceVersion> createState() => _deviceVersionState();
}

class _deviceVersionState extends State<deviceVersion> {
  final cloudProjectController _deviceInfoController = Get.find();

  imageTurn() {
    if (_deviceInfoController.sysData.value["systemprotocoltype"] != null &&
        _deviceInfoController.sysData.value["systemprotocoltype"] == 'V8') {
      return 'public/images/local/v8.png';
    }
    return 'public/images/local/outdoor.png';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(32.w, 54.h, 32.w, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Image.asset(
              imageTurn(),
              width: 120.w,
            ),
          ),
          Expanded(
              child: Column(
            children: [
              SizedBox(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Text(
                          "${tr("deviceListinfo.sn")}: ${_deviceInfoController.selectDevice.value["sn"]}",
                          style: normalTextWhilte(lineheight: 1.5),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        width: 1,
                        height: 14,
                        color: Colors.white,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(width: 1, color: Colors.white)),
                        child: Text(
                          tr(_deviceInfoController
                              .selectDevice.value["netModelEnum"]),
                          style: normalTextWhilte(lineheight: 1),
                        ),
                      )
                    ]),
              ),
              const Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
              Row(children: [
                Expanded(
                  child: Text(
                      "${tr("deviceListinfo.gaywaysn")}: ${_deviceInfoController.selectDevice.value["gatewaySn"]}",
                      style: normalTextWhilte(lineheight: 1.5)),
                )
              ])
            ],
          ))
        ],
      ),
    );
  }
}

class deviceInfoPage extends StatefulWidget {
  const deviceInfoPage({super.key});

  @override
  State<deviceInfoPage> createState() => _deviceInfoPageState();
}

class _deviceInfoPageState extends State<deviceInfoPage> {
  final cloudProjectController _deviceInfoController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<cloudProjectController>(
        init: cloudProjectController(),
        builder: (_) => Container(
              padding: EdgeInsets.fromLTRB(paddingLR, 28.h, paddingLR, 28.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _deviceInfoController
                        .selectDeviceinfo.value.isNotEmpty
                    ? [
                        Column(
                          children: [
                            SizedBox(
                              height: 48.h,
                              child: Center(
                                child: Text(
                                        _deviceInfoController.selectDeviceinfo
                                                .value["outdoorTotal"] ??
                                            '--',
                                        style: versionValueBlock(context))
                                    .tr(),
                              ),
                            ),
                            SizedBox(
                              height: 33.h,
                              child: Center(
                                child: Text('totalMatches',
                                        textAlign: TextAlign.center,
                                        style: versionValue(context))
                                    .tr(),
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 48.h,
                              child: Center(
                                child: Text(
                                        _deviceInfoController.selectDeviceinfo
                                                    .value["ratio"] ==
                                                ""
                                            ? '--'
                                            : _deviceInfoController
                                                .selectDeviceinfo
                                                .value["ratio"],
                                        style: versionValueBlock(context))
                                    .tr(),
                              ),
                            ),
                            SizedBox(
                              height: 33.h,
                              child: Center(
                                child: Text('matchingNumber',
                                        textAlign: TextAlign.center,
                                        style: versionValue(context))
                                    .tr(),
                              ),
                            )
                          ],
                        ),
                        if (_deviceInfoController.sysData.value.isNotEmpty)
                          Column(
                            children: [
                              if (modeMap[_deviceInfoController
                                      .sysData.value['runmode']] !=
                                  null)
                                Image.asset(
                                  'public/images/icon/${modeMap[_deviceInfoController.sysData.value['runmode']]!['key']}.png',
                                  width: 48.w,
                                ),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 4.h)),
                              SizedBox(
                                height: 33.h,
                                child: Center(
                                  child: Text(
                                          '${_deviceInfoController.sysData.value['runmode'] ?? '--'}',
                                          textAlign: TextAlign.center,
                                          style: versionValue(context))
                                      .tr(),
                                ),
                              )
                            ],
                          ),
                        if (_deviceInfoController
                                .selectDevice.value["errorCode"] !=
                            null)
                          Column(
                            children: [
                              Image.asset(
                                'public/images/checkData/error.png',
                                width: 48.w,
                              ),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 4.h)),
                              SizedBox(
                                height: 33.h,
                                child: Center(
                                  child: Text(
                                          '${_deviceInfoController.selectDevice.value["errorCode"] == "" ? '--' : _deviceInfoController.selectDevice.value["errorCode"]}',
                                          textAlign: TextAlign.center,
                                          style: versionValue(context))
                                      .tr(),
                                ),
                              )
                            ],
                          )
                      ]
                    : [],
              ),
            ));
  }
}

class countODUandIDUPage extends StatefulWidget {
  Function onSetCloundRefreshTime;

  countODUandIDUPage({super.key, required this.onSetCloundRefreshTime});

  @override
  State<countODUandIDUPage> createState() => _countODUandIDUPageState();
}

class _countODUandIDUPageState extends State<countODUandIDUPage> {
  final cloudProjectController _deviceInfoController = Get.find();

  final userinfoController _promissioncontroller = Get.find();
  late Timer _timer;
  late Timer _getSimFrequencytimer;
  bool isRunning = false;
  int timecount = 0;
  int cloundRefreshTime = 5;
  List op = [
    {'label': '1min/组', 'name': '1min/组', 'value': 1},
    {'label': '5min/组', 'name': '5min/组', 'value': 5},
    {'label': '10min/组', 'name': '10min/组', 'value': 10},
    {'label': '20min/组', 'name': '20min/组', 'value': 20},
  ];
  _setupdatatip(val) async {
    String nid = _deviceInfoController.selectDevice.value["gatewayNid"];
    var send = {
      "gatewayNid": nid,
      "setFrequency": val.toString(),
      "recoverFrequency": cloundRefreshTime.toString()
    };
    try {
      // print('getProfessionalToolsHandler.updateSimFrequency:   $send');
      var controlDebugging = await platform.invokeMethod(
          'getProfessionalToolsHandler.updateSimFrequency', send);
      var _data = jsonDecode(controlDebugging);
      // print('getProfessionalToolsHandler.updateSimFrequency:   $_data');
      if (_data['success']) {
        EasyLoading.showSuccess('设置成功');
      } else {
        EasyLoading.showError(_data['errorMsg']);
      }
    } catch (e) {
      print('getProfessionalToolsHandler.updateSimFrequency:   $e');
    }
  }

  static const platform =
      MethodChannel('samples.flutter.dev/getProjectHandler');
  var data = {};
  _init() async {
    final prefs = await SharedPreferences.getInstance();
    String nid = _deviceInfoController.selectDevice.value["nid"];
    try {
      var queryDebugModeTimeRemaining = await platform.invokeMethod(
          'getAppFluorineMachineEnergyHandler.queryDebugModeTimeRemaining',
          {"sysid": nid});
      var _data = jsonDecode(queryDebugModeTimeRemaining);
      if (_data["errorCode"] != null &&
          _data["errorCode"].toString() == "1001") {
        //登录失效
        tologout();
      }
      if (_data["data"].isNotEmpty) {
        for (var element in _data["data"].keys) {
          data[element] = _data["data"][element];
        }
      }
    } catch (e) {}
    if (data["countdownStatusEnum"] != null) {
      isRunning = !["NOT_OPEN", "COUNTDOWN_FAILED"]
          .contains(data["countdownStatusEnum"]);
      if (data["timeRemaining"] != null) {
        try {
          timecount = int.tryParse(data["timeRemaining"].toString())!;
          if (timecount > 0) {
            _count();
          }
        } catch (e) {}
      }
      setState(() {
        isRunning;
        timecount;
      });
    }
  }

  _count() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timecount = timecount - 1;
      if (timecount > 1) {
        setState(() {
          timecount;
        });
      } else {
        _timer.cancel();
        _init();
        Future.delayed(const Duration(seconds: 2), () {
          _init();
        });
      }
    });
  }

  _switch() async {
    String nid = _deviceInfoController.selectDevice.value["nid"];
    try {
      var controlDebugging = await platform.invokeMethod(
          'getAppFluorineMachineEnergyHandler.controlDebugging',
          {"sysid": nid, "start": isRunning});
      var _data = jsonDecode(controlDebugging);

      EasyLoading.show(status: 'loading...');
      Future.delayed(const Duration(seconds: 3), () async {
        await _init();
        EasyLoading.dismiss();
      });
    } catch (e) {}
  }

  bool isGetSimFrequencyEmpty = false;
  _getSimFrequency() async {
    String nid = _deviceInfoController.selectDevice.value["gatewayNid"];
    try {
      var controlDebugging = await platform.invokeMethod(
          'getProfessionalToolsHandler.getSimFrequency', {"gatewayNid": nid});
      var _data = jsonDecode(controlDebugging);
      if (_data['data'] != null) {
        int setting = int.tryParse(_data['data'].toString()) ?? 5;
        if (![1, 5, 10, 20].contains(setting)) {
          setting = 5;
        }
        setState(() {
          cloundRefreshTime = setting;
          isGetSimFrequencyEmpty = false;
        });
      } else {
        setState(() {
          isGetSimFrequencyEmpty = true;
        });
      }
    } catch (e) {
      print('getProfessionalToolsHandler.getSimFrequency:   $e');
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _init();
      _getSimFrequency();
      _getSimFrequencytimer =
          Timer.periodic(const Duration(seconds: 10), (timer) {
        _getSimFrequency();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    try {
      _timer.cancel();
    } catch (e) {}
    try {
      _getSimFrequencytimer.cancel();
    } catch (e) {}
  }

  Future<bool> _onWillPop() async {
    // 在这里处理退出前的逻辑，例如弹出确认对话框
    return timecount > 0
        ? (await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('timecount.layout').tr(),
                  content: const Text('timecount.layout.tip').tr(),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('timecount.Cancel').tr(),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    TextButton(
                      child: const Text('timecount.Exit').tr(),
                      onPressed: () {
                        setState(() {
                          isRunning = !isRunning;
                        });
                        _switch();
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                );
              },
            )) ??
            false
        : true;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<cloudProjectController>(
        init: cloudProjectController(),
        builder: (_) => WillPopScope(
            onWillPop: _onWillPop,
            child: baseContainer(
                child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${tr('local.ODU')} ${_deviceInfoController.selectDevice.value["outdoorNum"]}  ${tr('local.IDU')} ${_deviceInfoController.selectDevice.value["indoorNum"]}',
                      style: versionValue(context),
                    ),
                    if (_deviceInfoController.isMODEL_OLD_CHANGE.value)
                      Text(
                        tr("systemtype", namedArgs: {
                          "val": tr(_deviceInfoController.snJumpModule
                                      .value["oldReformSystemInfoVO"] !=
                                  null
                              ? "modifyType${_deviceInfoController.snJumpModule.value["oldReformSystemInfoVO"]["modifyType"].toString()}"
                              : "SPRAY_AND_OLD")
                        }),
                        style: versionValue(context),
                      ),
                    if (!_deviceInfoController.isMODEL_OLD_CHANGE.value)
                      TextButton(
                          onPressed: () {
                            if (_promissioncontroller.checkCloundPromission(
                                    "FunctionParamsView",
                                    showtoast: false) ||
                                _promissioncontroller.checkCloundPromission(
                                    "FunctionParamsSetting",
                                    showtoast: false)) {
                              Get.to(() => cloundParametersSetting(
                                    sn: _deviceInfoController
                                        .selectDevice.value["sn"],
                                  ));
                            } else {
                              EasyLoading.showError(tr("withoutpromission"));
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("projectDetail.parametersSetting",
                                      style: normalTextWhilte())
                                  .tr(),
                              const Icon(
                                Icons.chevron_right,
                                color: Color.fromRGBO(204, 204, 204, 1),
                              )
                            ],
                          ))
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 15.h, 0, 15.h),
                  height: 1,
                  color: const Color.fromRGBO(238, 238, 238, 1),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: 720.w - 64.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_deviceInfoController.isMODEL_OLD_CHANGE.value)
                          Text(
                            tr("isMODEL_OLD_CHANGE", namedArgs: {
                              "val": !isRunning
                                  ? tr("noRunning")
                                  : tr("timecount",
                                      namedArgs: {"val": "$timecount"})
                            }),
                            style: versionValue(context),
                          ),
                        if (_deviceInfoController.isMODEL_OLD_CHANGE.value)
                          Switch(
                            value: isRunning,
                            onChanged: (val) {
                              setState(() {
                                isRunning = !isRunning;
                              });
                              _switch();
                            },
                            activeColor: Colors.white, // 选中状态颜色
                            inactiveTrackColor: Colors.white, // 未选中状态背景颜色
                            inactiveThumbColor: const Color.fromRGBO(
                                140, 140, 140, 1), // 未选中状态滑块颜色
                            activeTrackColor:
                                const Color(0xFF33D053), // 选中状态背景颜色
                          ),
                        if (!_deviceInfoController.isMODEL_OLD_CHANGE.value)
                          TextButton(
                              onPressed: () async {
                                if (_promissioncontroller.checkCloundPromission(
                                    "ModifyDataReportFrequency")) {
                                  Future<sheetBack?> selectedIndex =
                                      await showCustomModalBottomSheet(
                                          isMultiple: false,
                                          context,
                                          [...op],
                                          // ignore: unrelated_type_equality_checks
                                          baseValue: [
                                            cloundRefreshTime.toString()
                                          ],
                                          titleName: tr('updatatip.title'));
                                  selectedIndex.then((value) => {
                                        if (value != null &&
                                            value.baseValue![0] != -1)
                                          {_setupdatatip(value.baseValue![0])}
                                      });
                                }
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'updatatip',
                                    style: versionValue(context),
                                  ).tr(namedArgs: {
                                    "val": op
                                        .where((element) =>
                                            element['value'] ==
                                            cloundRefreshTime)
                                        .toList()[0]["name"]
                                  }),
                                  const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  )
                                ],
                              )),
                        if (!_deviceInfoController.isMODEL_OLD_CHANGE.value)
                          Row(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    if (_promissioncontroller
                                            .checkCloundPromission(
                                                "TestRunReport",
                                                showtoast: false) ||
                                        _promissioncontroller
                                            .checkCloundPromission(
                                                "TestRunReport",
                                                showtoast: false)) {
                                      String nid = _deviceInfoController
                                          .selectDevice.value["nid"];
                                      Get.to(() => tryResult(
                                            islocation: false,
                                            nid: nid,
                                            sn: _deviceInfoController
                                                .selectDevice.value["sn"],
                                          ));
                                    } else {
                                      EasyLoading.showError(
                                          tr("withoutpromission"));
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                            width: 1, color: Colors.white)),
                                    child: Text("trialRun.getreport.title",
                                            style: normalTextWhilte(
                                                lineheight: 1.2))
                                        .tr(),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    if (_promissioncontroller
                                        .checkCloundPromission(
                                            "HistoryFault")) {
                                      String nid = _deviceInfoController
                                          .selectDevice.value["nid"];
                                      Get.to(() => cloundErrorList(
                                          nid: nid,
                                          sn: _deviceInfoController
                                              .selectDevice.value["sn"],
                                          deviceversion: _deviceInfoController
                                              .sysData
                                              .value["systemprotocoltype"]));
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                            width: 1, color: Colors.white)),
                                    child: Text("smartFaultAnalysis",
                                            style: normalTextWhilte(
                                                lineheight: 1.2))
                                        .tr(),
                                  ))
                            ],
                          )
                      ],
                    ),
                  ),
                )
              ],
            ))));
  }
}

class tablePage extends StatefulWidget {
  const tablePage({super.key});

  @override
  State<tablePage> createState() => _tablePageState();
}

class _tablePageState extends State<tablePage> {
  // WidgetsToImageController to access widget
  WidgetsToImageController controller = WidgetsToImageController();
  // to save image bytes of widget

  final deviceInfoController _deviceInfoController = Get.find();

  final cloudProjectController _cloudProjectController = Get.find();
  Uint8List? bytes;

  final MethodChannel methodChannel =
      const MethodChannel('sample.channel.data');
  Widget tableContainer = Container();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      changActiveType("System");
    });
    super.initState();
  }

  String activeType = "System";

  CustomPopupMenuController _controller = CustomPopupMenuController();
  List<String> menuItems = [
    'table.IndoorUnitCentralControl',
    'table.UnlockAllonPowerOn',
    'table.UnlockAllonPowerOff'
  ];

  List titleColumn = [];
  List titleRow = [];
  List data = [];
  int widthsp = 4;
  changActiveType(val) {
    // EasyLoading.show(status: 'loading...');
    activeType = val;
    refreshTable();
    // EasyLoading.dismiss();
  }

  List showTypeColund = [
    {
      "key": "System",
      "name": "table.System",
      "children": [
        "System.indoorCount",
        "System.systemProtocolType",
        "System.runMode",
        "System.indoorCountSetting",
        "System.openedIndoorCount",
        "System.indoorOutdoorProtocolType",
        "System.communicationSettings",
        "System.t2bAvgTemp",
        "System.Tes",
        "System.TCS",
        "System.TcMax",
        "System.TeMin",
        "System.silenceSetting",
        "System.powerLimit",
      ]
    },
    {
      "key": "OutdoorUnit",
      "name": "table.OutdoorUnit",
      "children": [
        "outdoor.idx",
        "outdoor.outdoorPlateHorses",
        "outdoor.limitFrequencyStatus",
        "outdoor.fanLevel1",
        "outdoor.fanLevel2",
        "outdoor.alternatingVoltage",
        "outdoor.electricity",
        "outdoor.filthBlockageLevel",
        "outdoor.errorCode",
        "outdoor.sysIdx",
        "outdoor.powerQuality",
        "outdoor.outdoorSoftwareVersion"
      ]
    },
    {
      "key": "Compressor",
      "name": "table.Compressor",
      "children": [
        "outdoor.idx",
        "outdoor.highPressure",
        "outdoor.lowPressure",
        "outdoor.highPressureSaturationTemp",
        "outdoor.lowPressureSaturationTemp",
        "outdoor.compressor1Frequency",
        "outdoor.compressor2Frequency",
        "outdoor.directVoltage1",
        "outdoor.directVoltage2",
        "outdoor.compressorElectric1",
        "outdoor.compressorElectric2",
        "outdoor.compressorRunTime1",
        "outdoor.compressorRunTime2"
      ]
    },
    {
      "key": "Sensor",
      "name": "table.Sensor",
      "children": [
        "outdoor.idx",
        "outdoor.t4Temp",
        "outdoor.t3Temp",
        "outdoor.t5Temp",
        "outdoor.t6ATemp",
        "outdoor.t6BTemp",
        "outdoor.t8Temp",
        "outdoor.tlTemp",
        "outdoor.tg",
        "outdoor.radiatorTemp1",
        "outdoor.radiatorTemp2",
        "outdoor.t7C1Temp",
        "outdoor.t7C2Temp",
        "outdoor.t71Temp",
        "outdoor.t72Temp",
        "outdoor.superHeatTemp"
      ]
    },
    {
      "key": "ValveBody",
      "name": "table.ValveBody",
      "children": [
        "outdoor.idx",
        "outdoor.exv1Opening",
        "outdoor.exv2Opening",
        "outdoor.exv3Opening",
        "outdoor.exv4Opening",
        "outdoor.sv5",
        "outdoor.sv6",
        "outdoor.sv7",
        "outdoor.sv8",
        "outdoor.SV8B"
      ]
    },
    {
      "key": "IndoorUnitParameters",
      "name": "table.IndoorUnitParameters",
      "children": [
        "indoor.idx",
        "indoor.indoorType",
        "indoor.indoorHorses",
        "indoor.onOff",
        "indoor.runMode",
        "indoor.fan7SpeedSetting",
        "indoor.tempSetting",
        "indoor.roomTemp",
        "indoor.indoorTempT2A",
        "indoor.indoorTempT2",
        "indoor.indoorTempT2B",
        "indoor.exv1Opening",
        "indoor.errorCode",
        "indoor.indoorSoftwareVersion",
        "indoor.indoorSubSoftwareVersion",
        "indoor.isV6Outdoor",
        "indoor.mlinkchipmodel",
        "indoor.t1temp",
        "indoor.humansensorsetting",
        "indoor.MLinkVoltageVersion",
      ]
    }
  ];

  refreshTable() {
    try {
      List headerList = [];
      print(_cloudProjectController.nodeTr);
      if (activeType != "IndoorUnitParameters") {
        headerList = showTypeColund
            .where((element) => element['key'] == activeType)
            .toList()[0]['children'];
      } else {
        headerList = _cloudProjectController.nodeTr.keys
            .toList()
            .where((element) => element.toString().contains("indoor."))
            .toList();

        List sort = showTypeColund
            .where((element) => element['key'] == activeType)
            .toList()[0]['children'];

        Map<String, int> sortOrderMap = {};
        for (int i = 0; i < sort.length; i++) {
          sortOrderMap[sort[i].toString().toLowerCase()] = i;
        }

        // 根据给定的顺序对原数组进行排序
        headerList.sort((a, b) {
          int indexA = sortOrderMap[a] ?? 999;
          int indexB = sortOrderMap[b] ?? 999;
          return indexA.compareTo(indexB); // 按照指定顺序比较
        });
      }
      if (activeType == "System") {
        headerList = _cloudProjectController.nodeTr.keys
            .toList()
            .where((element) => element.toString().contains("system."))
            .toList();
      }

      if (activeType == "OutdoorUnit") {
        headerList = _cloudProjectController.nodeTr.keys
            .toList()
            .where((element) => element.toString().contains("outdoor."))
            .toList();
      }

      if (activeType == "Compressor") {
        headerList = _cloudProjectController.nodeTr.keys
            .toList()
            .where((element) => element.toString().contains("compressorlist."))
            .toList();
      }

      if (activeType == "Sensor") {
        headerList = _cloudProjectController.nodeTr.keys
            .toList()
            .where((element) => element.toString().contains("sensorlist."))
            .toList();
      }

      if (activeType == "ValveBody") {
        headerList = _cloudProjectController.nodeTr.keys
            .toList()
            .where((element) => element.toString().contains("valvelist."))
            .toList();
      }

      List<Widget> itemList = [tableHeaderIndex()];
      data = [];
      titleRow = [];
      titleColumn = headerList;
      // .where((element) =>
      //     _cloudProjectController.nodeTr[element.toString().toLowerCase()] !=
      //     null)
      // .toList();
      List tablebase = [];
      if (activeType == 'System') {
        tablebase = [_cloudProjectController.sysData];
      }
      if (activeType == 'OutdoorUnit') {
        tablebase = [..._cloudProjectController.outdoorList];
      }

      if (activeType == 'Compressor') {
        tablebase = [..._cloudProjectController.compressorlist];
      }

      if (activeType == 'Sensor') {
        tablebase = [..._cloudProjectController.sensorList];
      }

      if (activeType == 'ValveBody') {
        tablebase = [..._cloudProjectController.valveList];
      }

      if (['IndoorUnitParameters'].contains(activeType)) {
        tablebase = _cloudProjectController.indoorList;
      }

      print("tablebase.length: $tablebase");
      for (var i = 0; i < tablebase.length; i++) {
        List base = [];
        try {
          for (var element in headerList) {
            String elementKey = element.split('.')[1].toString().toLowerCase();
            var val = tablebase[i][elementKey] == null ||
                    tablebase[i][elementKey].toString() == ""
                ? "--"
                : '${tablebase[i][elementKey] ?? '--'} ${typeUnit[element] ?? ''}';
            if (elementKey.toString().toUpperCase().contains("SN")) {
              val = val.toString().toUpperCase();
            }
            base.add(val);
          }
        } catch (e) {}
        if (activeType == 'System') {
          titleRow.add('$i#');
        } else {
          titleRow.add("${tablebase[i]['name']}");
        }
        print("titleRow.length: $titleRow");
        data.add(base);
      }
      setState(() {
        activeType;
        titleRow;
        data;
        titleColumn;
      });
    } catch (e) {}
  }

  List<double> rowHeightsList(leng) {
    List<double> out = [];
    for (var i = 0; i < leng; i++) {
      out.add(50.0);
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    // Get height of app bar
    double appBarHeight = AppBar().preferredSize.height;

    // Calculate remaining height for page content
    double contentHeight = MediaQuery.of(context).size.height -
        appBarHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return baseContainer(
        child: Column(
      children: [
        Container(
            height: 72.h,
            decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 255, 255, 0.2),
                borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: showType.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: Container(
                          height: 72.h,
                          width: (720.w - 32.w * 2 - showType.length + 1) /
                              showType.length,
                          decoration: BoxDecoration(
                            color: activeType == showType[index]['key']
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: index == 0
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(16.0),
                                    bottomLeft: Radius.circular(16.0),
                                  )
                                : showType.length - 1 == index
                                    ? const BorderRadius.only(
                                        topRight: Radius.circular(16.0),
                                        bottomRight: Radius.circular(16.0),
                                      )
                                    : null,
                          ),
                          child: Center(
                              child: Text(
                            tr(showType[index]['name']),
                            textAlign: TextAlign.center,
                            style: activeType == showType[index]['key']
                                ? versionValueActive(context)
                                : versionValue(context),
                          )),
                        ),
                        onTap: () {
                          changActiveType(showType[index]['key']);
                        },
                      );
                    },
                    separatorBuilder: (context, index) => Container(
                      width: 1,
                      height: 72.h,
                      color: const Color.fromRGBO(238, 238, 238, 0.3),
                    ),
                  ),
                ),
              ],
            )),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 28.h),
        ),
        WidgetsToImage(
            controller: controller,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: titleColumn.isNotEmpty
                      ? Container(
                          color: Colors.white,
                          height: (titleColumn.length + 1) * 50,
                          width: 720.w - 32.w * 2,
                          child: StickyHeadersTable(
                            cellDimensions:
                                CellDimensions.variableColumnWidthAndRowHeight(
                                    columnWidths: List.generate(
                                        titleRow.length,
                                        (index) => titleRow.length == 1
                                            ? (720.w - 32.w * 2 - 120)
                                            : (720.w - 32.w * 2 - 120) / 2),
                                    rowHeights:
                                        rowHeightsList(titleColumn.length),
                                    stickyLegendWidth: 120,
                                    stickyLegendHeight: 72.h),
                            columnsLength: titleRow.length,
                            rowsLength: titleColumn.length,
                            columnsTitleBuilder: (i) => Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromRGBO(
                                      223, 223, 223, 1), // 边框颜色
                                  width: 0.5, // 边框宽度
                                ),
                                borderRadius:
                                    BorderRadius.circular(0.0), // 圆角半径
                              ),
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    titleRow[i],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: tableLabel(context),
                                  )
                                ],
                              )),
                            ),
                            rowsTitleBuilder: (i) => Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromRGBO(
                                      223, 223, 223, 1), // 边框颜色
                                  width: 0.5, // 边框宽度
                                ),
                                borderRadius:
                                    BorderRadius.circular(0.0), // 圆角半径
                              ),
                              child: Center(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: SizedBox(
                                        width: 117,
                                        child: Text(
                                            _cloudProjectController.nodeTr[
                                                    titleColumn[i]
                                                        .toString()
                                                        .toLowerCase()] ??
                                                tr(titleColumn[i]
                                                    .toString()
                                                    .toLowerCase()),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: tableLabel(context)),
                                      ))
                                ],
                              )),
                            ),
                            contentCellBuilder: (i, j) => Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromRGBO(
                                      223, 223, 223, 1), // 边框颜色
                                  width: 0.5, // 边框宽度
                                ),
                                borderRadius:
                                    BorderRadius.circular(0.0), // 圆角半径
                              ),
                              child: GetBuilder<deviceInfoController>(
                                  builder: (_) {
                                return Center(
                                    child: Text(
                                  data[i][j].toString() == ""
                                      ? "--"
                                      : data[i][j],
                                  style: normalText(fSize: 12, lineheight: 1),
                                ));
                              }),
                            ),
                            legendCell: Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color.fromRGBO(
                                        223, 223, 223, 1), // 边框颜色
                                    width: 0.5, // 边框宽度
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(0.0), // 圆角半径
                                ),
                                child: tableHeaderIndex(
                                  width: 120,
                                  rightText: 'table.parameter',
                                  leftText: 'project.name',
                                )),
                          ),
                        )
                      : Center(
                          child: SizedBox(
                            width: 320.w,
                            height: 320.w,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 30.h, 0, 30.h),
                              child: EmptyWidget(
                                image: null,
                                packageImage: null,
                                title: tr('device.empty'),
                                titleTextStyle: const TextStyle(
                                  fontSize: 22,
                                  color: Color(0xff9da9c7),
                                  fontWeight: FontWeight.w500,
                                ),
                                subtitleTextStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xffabb8d6),
                                ),
                              ),
                            ),
                          ),
                        )),
            ))
      ],
    ));
  }
}

TextStyle tableLabel(context) {
  return const TextStyle(
      color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400);
}

TextStyle tableValue(context) {
  return const TextStyle(
      color: Color.fromRGBO(136, 136, 136, 1),
      fontSize: 12,
      fontWeight: FontWeight.w400);
}

class oldChange extends StatefulWidget {
  const oldChange({super.key});

  @override
  State<oldChange> createState() => _oldChangeState();
}

class _oldChangeState extends State<oldChange> {
  final cloudProjectController _cloudProjectController = Get.find();

  String activeType = "System";

  List titleColumn = [];
  List titleRow = [];
  List data = [];

  List showType_oldChange = [
    {"key": "System", "name": "table.Systeminfo", "children": []},
    {
      "key": "OutdoorUnit",
      "name": "table.OutdoorUnitinfo",
      "children": [
        "outdoor.oduaddress",
        "outdoor.hp",
        "outdoor.oduheatexchangerpipetempt3",
        "outdoor.ambienttempt4",
        "outdoor.compressor1frequency",
        "outdoor.compressor2frequency",
        "outdoor.dischargetemptp1ofcompressor1",
        "outdoor.dischargetemptp2ofcompressor2",
        "outdoor.compressor1current",
        "outdoor.compressor2current",
        "outdoor.exvaopening",
        "outdoor.exvbopening",
        "outdoor.currentfault"
      ]
    },
    {
      "key": "IndoorUnitParameters",
      "name": "table.IndoorUnitParametersinfo",
      "children": [
        "indoor.idx",
        "indoor.indoorType",
        "indoor.indoorHorses",
        "indoor.onOff",
        "indoor.runMode",
        "indoor.fan7SpeedSetting",
        "indoor.tempSetting",
        "indoor.roomTemp",
        "indoor.indoorTempT2A",
        "indoor.indoorTempT2",
        "indoor.indoorTempT2B",
        "indoor.exv1Opening",
        "indoor.errorCode",
        "indoor.softwareVersion",
      ]
    }
  ];

  int widthsp = 4;
  refreshTable() {
    try {
      List headerList = showType_oldChange
          .where((element) => element['key'] == activeType)
          .toList()[0]['children'];
      if (headerList.isEmpty) {
        return;
      }
      List<Widget> itemList = [tableHeaderIndex()];
      data = [];
      titleRow = [];
      titleColumn = headerList
          .where((element) =>
              _cloudProjectController.nodeTr[element]
                      .toString()
                      .toLowerCase() !=
                  null &&
              _cloudProjectController.nodeTr.keys
                  .contains(element.toString().toLowerCase()))
          .toList();

      List tablebase = [];
      if (activeType == 'System') {
        tablebase = [_cloudProjectController.sysData];
      }
      if (['OutdoorUnit', 'Compressor', 'Sensor', 'ValveBody']
          .contains(activeType)) {
        tablebase = _cloudProjectController.outdoorList;
      }
      if (['IndoorUnitParameters'].contains(activeType)) {
        tablebase = _cloudProjectController.indoorList;
      }
      for (var i = 0; i < tablebase.length; i++) {
        List base = [];
        for (var element in headerList) {
          String elementKey = element.split('.')[1].toString().toLowerCase();

          var val =
              '${tablebase[i][elementKey] ?? '--'} ${typeUnit[element] == null ? '' : typeUnit[element]}';
          if (elementKey.toString().toUpperCase().contains("SN")) {
            val = val.toString().toUpperCase();
          }
          base.add(val);
        }
        if (activeType == 'System') {
          titleRow.add('$i#');
        } else {
          titleRow.add("${tablebase[i]['idx'] ?? tablebase[i]['oduaddress']}");
        }
        data.add(base);
      }
      setState(() {
        titleRow;
        data;
        titleColumn;
      });
    } catch (e) {}
  }

  List<double> rowHeightsList(leng) {
    List<double> out = [];
    for (var i = 0; i < leng; i++) {
      out.add(50.0);
    }
    return out;
  }

  init() {
    if (_cloudProjectController.snJumpModule.value.isNotEmpty) {
      if (_cloudProjectController
              .snJumpModule.value["oldReformSystemInfoVO"]["modifyType"]
              .toString() ==
          "1") {
        setState(() {
          showType_oldChange = [
            {"key": "System", "name": "table.Systeminfo", "children": []},
          ];
        });
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      init();
    });
    super.initState();
  }

  changActiveType(val) {
    setState(() {
      activeType = val;
    });
    refreshTable();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<cloudProjectController>(
        init: cloudProjectController(),
        builder: (_) => baseContainer(
              child: Column(
                children: [
                  SizedBox(
                      height: 72.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          for (int index = 0;
                              index < showType_oldChange.length;
                              index++)
                            GestureDetector(
                              child: Container(
                                height: 72.h,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: activeType ==
                                          showType_oldChange[index]['key']
                                      ? Colors.white
                                      : const Color.fromRGBO(
                                          255, 255, 255, 0.2),
                                  borderRadius: index == 0
                                      ? BorderRadius.only(
                                          topLeft: const Radius.circular(16.0),
                                          bottomLeft:
                                              const Radius.circular(16.0),
                                          topRight:
                                              showType_oldChange.length == 1
                                                  ? const Radius.circular(8.0)
                                                  : const Radius.circular(0),
                                          bottomRight:
                                              showType_oldChange.length == 1
                                                  ? const Radius.circular(8.0)
                                                  : const Radius.circular(0),
                                        )
                                      : showType_oldChange.length - 1 == index
                                          ? const BorderRadius.only(
                                              topRight: Radius.circular(16.0),
                                              bottomRight:
                                                  Radius.circular(16.0),
                                            )
                                          : null,
                                ),
                                child: Center(
                                    child: SafeText(
                                  tr(showType_oldChange[index]['name']),
                                  style: activeType ==
                                          showType_oldChange[index]['key']
                                      ? versionValueActive(context)
                                      : versionValue(context),
                                )),
                              ),
                              onTap: () {
                                changActiveType(
                                    showType_oldChange[index]['key']);
                              },
                            )
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 28.h),
                  ),
                  if (activeType == "System")
                    _cloudProjectController.snJumpModule.value.isNotEmpty
                        ? const SystemShow()
                        : SizedBox(
                            width: 200.w,
                            height: 210,
                            child: EmptyWidget(
                              image: null,
                              packageImage: null,
                              title: tr('device.empty'),
                              titleTextStyle: const TextStyle(
                                fontSize: 22,
                                color: Color(0xff9da9c7),
                                fontWeight: FontWeight.w500,
                              ),
                              subtitleTextStyle: const TextStyle(
                                fontSize: 14,
                                color: Color(0xffabb8d6),
                              ),
                            ),
                          ),
                  if (activeType != "System")
                    titleColumn.isNotEmpty
                        ? Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: titleColumn.isNotEmpty
                                    ? Container(
                                        color: Colors.white,
                                        height: (titleColumn.length + 1) * 50,
                                        width: 720.w - 32.w * 2,
                                        child: StickyHeadersTable(
                                          cellDimensions: CellDimensions
                                              .variableColumnWidthAndRowHeight(
                                                  columnWidths: List.generate(
                                                      titleRow.length,
                                                      (index) =>
                                                          (720.w - 32.w * 2) /
                                                          (titleRow.length == 1
                                                              ? 2
                                                              : 3)),
                                                  rowHeights: rowHeightsList(
                                                      titleColumn.length),
                                                  stickyLegendWidth:
                                                      (720.w - 32.w * 2) /
                                                          (titleRow.length == 1
                                                              ? 2
                                                              : 3),
                                                  stickyLegendHeight: 72.h),
                                          columnsLength: titleRow.length,
                                          rowsLength: titleColumn.length,
                                          columnsTitleBuilder: (i) => Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color.fromRGBO(
                                                    223, 223, 223, 1), // 边框颜色
                                                width: 0.5, // 边框宽度
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      0.0), // 圆角半径
                                            ),
                                            child: Center(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  titleRow[i],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: tableLabel(context),
                                                )
                                              ],
                                            )),
                                          ),
                                          rowsTitleBuilder: (i) => Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color.fromRGBO(
                                                    223, 223, 223, 1), // 边框颜色
                                                width: 0.5, // 边框宽度
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      0.0), // 圆角半径
                                            ),
                                            child: Center(
                                                child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0, 0, 0),
                                                    child: SizedBox(
                                                      width: ((720.w -
                                                                  32.w * 2 -
                                                                  10) /
                                                              (titleRow.length ==
                                                                      1
                                                                  ? 2
                                                                  : 3)) -
                                                          5,
                                                      child: Text(
                                                          _cloudProjectController
                                                                      .nodeTr[
                                                                  titleColumn[i]
                                                                      .toString()
                                                                      .toLowerCase()] ??
                                                              titleColumn[i]
                                                                  .toString()
                                                                  .toLowerCase(),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: tableLabel(
                                                              context)),
                                                    ))
                                              ],
                                            )),
                                          ),
                                          contentCellBuilder: (i, j) =>
                                              Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color.fromRGBO(
                                                    223, 223, 223, 1), // 边框颜色
                                                width: 0.5, // 边框宽度
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      0.0), // 圆角半径
                                            ),
                                            child: GetBuilder<
                                                    deviceInfoController>(
                                                builder: (_) {
                                              return Center(
                                                  child: SafeText(
                                                data[i][j],
                                                style: normalText(),
                                              ));
                                            }),
                                          ),
                                          legendCell: Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: const Color.fromRGBO(
                                                      223, 223, 223, 1), // 边框颜色
                                                  width: 0.5, // 边框宽度
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        0.0), // 圆角半径
                                              ),
                                              child: tableHeaderIndex(
                                                width: titleRow.length == 1
                                                    ? (720.w - 32.w * 2) / 2
                                                    : 0,
                                                rightText: 'table.parameter',
                                                leftText: 'table.address',
                                              )),
                                        ),
                                      )
                                    : Center(
                                        child: SizedBox(
                                          width: 320.w,
                                          height: 320.w,
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 30.h, 0, 30.h),
                                            child: EmptyWidget(
                                              image: null,
                                              packageImage: null,
                                              title: tr('device.empty'),
                                              titleTextStyle: const TextStyle(
                                                fontSize: 22,
                                                color: Color(0xff9da9c7),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              subtitleTextStyle:
                                                  const TextStyle(
                                                fontSize: 14,
                                                color: Color(0xffabb8d6),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                          )
                        : SizedBox(
                            width: 200.w,
                            height: 210,
                            child: EmptyWidget(
                              image: null,
                              packageImage: null,
                              title: tr('device.empty'),
                              titleTextStyle: const TextStyle(
                                fontSize: 22,
                                color: Color(0xff9da9c7),
                                fontWeight: FontWeight.w500,
                              ),
                              subtitleTextStyle: const TextStyle(
                                fontSize: 14,
                                color: Color(0xffabb8d6),
                              ),
                            ),
                          )
                ],
              ),
            ));
  }
}

class SystemShow extends StatefulWidget {
  const SystemShow({super.key});

  @override
  State<SystemShow> createState() => _SystemShowState();
}

class _SystemShowState extends State<SystemShow> {
  static const platform =
      MethodChannel('samples.flutter.dev/getProjectHandler');
  final cloudProjectController _cloudProjectController = Get.find();

  final cloudProjectController _deviceInfoController = Get.find();
  double fsize = 16;
  final userinfoController _promissioncontroller = Get.find();
  var data = {};
  var oldReformSystemInfoVO = null;
  List oldReformSystemInfoVOKeys = [
    "deviceBrand",
    "pieces",
    "modifyType",
    "usedTimeYear",
    "refType",
    "coolCop",
    "heatCop"
  ];
  var isFluorineEnergyImgListBack;
  init() async {
    String projectCode =
        _deviceInfoController.selectDevice.value['projectCode'] ?? "";
    print('projectCode ------  $projectCode');
    if (projectCode != "") {
      var getFluorineEnergyImgListBack =
          await MideaApi.getFluorineEnergyImgList(
              {"pageSize": 20, "projectCode": "$projectCode", "pageIndex": 1});
      print(
          'getFluorineEnergyImgListBack ------  ${getFluorineEnergyImgListBack['data']}');
      setState(() {
        isFluorineEnergyImgListBack = getFluorineEnergyImgListBack['data'];
      });
    }
    if (_cloudProjectController.snJumpModule.value.isNotEmpty) {
      // for (var element in _cloudProjectController.snJumpModule.value.keys) {
      //   print(
      //       "$element : ${_cloudProjectController.snJumpModule.value[element]}");
      // }

      if (_cloudProjectController.snJumpModule.value["oldSensor"] != null) {
        for (var element
            in _cloudProjectController.snJumpModule.value["oldSensor"]) {
          // print(element);
          data[element["name"]] = element["value"];
        }
        if (_cloudProjectController.snJumpModule.value["spraySensor"] != null) {
          for (var element
              in _cloudProjectController.snJumpModule.value["spraySensor"]) {
            // print(element);
            data[element["name"]] = element["value"];
          }
        }
        if (_cloudProjectController.snJumpModule.value["powerInfo"] != null) {
          for (var element
              in _cloudProjectController.snJumpModule.value["powerInfo"]) {
            // print(element);
            data[element["name"]] = element["value"];
          }
        }
        if (_cloudProjectController.snJumpModule.value["communicationStatus"] !=
            null) {
          for (var element in _cloudProjectController
              .snJumpModule.value["communicationStatus"]) {
            // print(element);
            data[element["name"]] = element["value"];
          }
        }

        try {
          /**{deviceBrand: 美的, pieces: 24.0, modifyType: 2, usedTimeYear: 58, refType: R410A, coolCop: 12, heatCop: 11} */
          if (_cloudProjectController
                  .snJumpModule.value["oldReformSystemInfoVO"] !=
              null) {
            for (var element in _cloudProjectController
                .snJumpModule.value["oldReformSystemInfoVO"].keys) {
              // print(element);
              data[element] = _cloudProjectController
                  .snJumpModule.value["oldReformSystemInfoVO"][element]
                  .toString();
            }
            setState(() {
              oldReformSystemInfoVO = _cloudProjectController
                  .snJumpModule.value["oldReformSystemInfoVO"];
            });
          }
        } catch (e) {}

        // for (var element in data.keys) {
        //   print('$element   --------   ${data[element]}');
        // }
        setState(() {
          data;
        });
      }
    }
  }

  _loadimage() async {
    try {
      EasyLoading.show(status: 'loading...');
      String systemId = isFluorineEnergyImgListBack['oldReformImageInfoWebList']
              ['data'][0]['systemId']
          .toString();
      if (systemId != "") {
        var getFluorineEnergyImgDetailBack =
            await MideaApi.getFluorineEnergyImgDetail(systemId);
        EasyLoading.dismiss();
        print(
            'getFluorineEnergyImgDetailBack ------  ${getFluorineEnergyImgDetailBack['data']}');
        if (getFluorineEnergyImgDetailBack['data'][0] != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => oldReformImageInfoWebListPage(
                  data: getFluorineEnergyImgDetailBack['data'][0]),
            ),
          );
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      init();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  _reset() {
    if (_promissioncontroller.checkCloundPromission("SprinklerSetting")) {
      divConfirmDialog(
        context,
        isSubmitButton: true,
        confirmTitle: tr("oldChangecard.resetTip"),
      ).then((value) => {
            if (value) {_toreset()}
          });
    }
  }

  _toreset() async {
    String nid = _cloudProjectController.selectDevice.value["nid"];
    String sn = _cloudProjectController.selectDevice.value["sn"].isEmpty
        ? _cloudProjectController.selectDevice.value["gatewaySn"]
        : _cloudProjectController.selectDevice.value["sn"];
    if (nid.isNotEmpty) {
      EasyLoading.show(status: 'loading...');
      try {
        var snJumpModuleback = await platform.invokeMethod(
            'getAppFluorineMachineEnergyHandler.sprayDurationReset',
            {"sysid": nid});
        var snJumpModule = jsonDecode(snJumpModuleback);
        if (snJumpModule["success"]) {
          var snJumpModuleback = await platform.invokeMethod(
              'getAppFluorineMachineEnergyHandler.snJumpModule', {"sysid": sn});
          var snJumpModule = jsonDecode(snJumpModuleback);
          print(
              "getAppFluorineMachineEnergyHandler.snJumpModule: $snJumpModule");
          if (snJumpModule["success"]) {
            _cloudProjectController.setsnJumpModule(snJumpModule["data"]);
          }

          EasyLoading.dismiss();
        } else {
          EasyLoading.dismiss();
          EasyLoading.showError(snJumpModule["errorMsg"]);
        }
      } catch (e) {
        EasyLoading.dismiss();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (oldReformSystemInfoVO != null)
          Container(
            width: 720.w,
            decoration: cardStyleFull(context),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 24.h),
            padding: EdgeInsets.all(26.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "旧改系统信息",
                  style: titleText(lineheight: 1.5),
                ).tr(),
                Row(
                  children: [
                    Text(
                      "功能:",
                      style: normalText(fSize: fsize),
                    ).tr(),
                    const Padding(padding: EdgeInsets.all(4)),
                    SafeText(
                      data["modifyType"] != null
                          ? tr('modifyType' + data["modifyType"])
                          : "--",
                      style: normalTextBlack(fSize: fsize),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "设备品牌:",
                      style: normalText(fSize: fsize),
                    ).tr(),
                    const Padding(padding: EdgeInsets.all(4)),
                    SafeText(
                      data["deviceBrand"] ?? "--",
                      style: normalTextBlack(fSize: fsize),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "外机匹数(HP):",
                      style: normalText(fSize: fsize),
                    ).tr(),
                    const Padding(padding: EdgeInsets.all(4)),
                    SafeText(
                      data["pieces"] ?? "--",
                      style: normalTextBlack(fSize: fsize),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "外机运行年限:",
                      style: normalText(fSize: fsize),
                    ).tr(),
                    const Padding(padding: EdgeInsets.all(4)),
                    SafeText(
                      data["usedTimeYear"] ?? "--",
                      style: normalTextBlack(fSize: fsize),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "制冷额定功率:",
                      style: normalText(fSize: fsize),
                    ).tr(),
                    const Padding(padding: EdgeInsets.all(4)),
                    SafeText(
                      data["coolCop"] ?? "--",
                      style: normalTextBlack(fSize: fsize),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "制热额定功率:",
                      style: normalText(fSize: fsize),
                    ).tr(),
                    const Padding(padding: EdgeInsets.all(4)),
                    SafeText(
                      data["heatCop"] ?? "--",
                      style: normalTextBlack(fSize: fsize),
                    )
                  ],
                ),
              ],
            ),
          ),
        Container(
          width: 720.w,
          decoration: cardStyleFull(context),
          margin: EdgeInsets.fromLTRB(0, 0, 0, 24.h),
          padding: EdgeInsets.all(26.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "oldChangecard.title1",
                style: titleText(lineheight: 1.5),
              ).tr(),
              Row(
                children: [
                  Text(
                    "oldChangecard.highPressure",
                    style: normalText(fSize: fsize),
                  ).tr(),
                  const Padding(padding: EdgeInsets.all(4)),
                  SafeText(
                    data["highPressure"] ?? "--",
                    style: normalTextBlack(fSize: fsize),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "oldChangecard.lowPressure",
                    style: normalText(fSize: fsize),
                  ).tr(),
                  const Padding(padding: EdgeInsets.all(4)),
                  SafeText(
                    data["lowPressure"] ?? "--",
                    style: normalTextBlack(fSize: fsize),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "oldChangecard.returnAirTemp",
                    style: normalText(fSize: fsize),
                  ).tr(),
                  const Padding(padding: EdgeInsets.all(4)),
                  SafeText(
                    data["returnAirTemp"] ?? "--",
                    style: normalTextBlack(fSize: fsize),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "oldChangecard.t5Temp",
                    style: normalText(fSize: fsize),
                  ).tr(),
                  const Padding(padding: EdgeInsets.all(4)),
                  SafeText(
                    data["t5Temp"] ?? "--",
                    style: normalTextBlack(fSize: fsize),
                  )
                ],
              )
            ],
          ),
        ),
        if (_cloudProjectController
                .snJumpModule.value["oldReformSystemInfoVO"].isNotEmpty &&
            _cloudProjectController
                    .snJumpModule.value["oldReformSystemInfoVO"]["modifyType"]
                    .toString() !=
                "2")
          Container(
            width: 720.w,
            decoration: cardStyleFull(context),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 24.h),
            padding: EdgeInsets.all(26.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "oldChangecard.title2",
                      style: titleText(lineheight: 1.5),
                    ).tr(),
                    InkWell(
                      onTap: () {
                        try {
                          if (["0", "2", "3"].contains(_deviceInfoController
                              .selectDevice.value["status"]
                              .toString())) {
                            EasyLoading.showError(tr("deviceoutline"));
                            return;
                          }
                        } catch (e) {}
                        if (_promissioncontroller
                            .checkCloundPromission("SprinklerSetting")) {
                          Get.to(() => SprinklerSetting());
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            "oldChangecard.title2setting",
                            style: normalText(lineheight: 1.5),
                          ).tr(),
                          const Icon(Icons.chevron_right)
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "oldChangecard.tpTemp",
                      style: normalText(fSize: fsize),
                    ).tr(),
                    const Padding(padding: EdgeInsets.all(4)),
                    SafeText(
                      data["tpTemp"] ?? "--",
                      style: normalTextBlack(fSize: fsize),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "oldChangecard.sprayingDuration",
                      style: normalText(fSize: fsize),
                    ).tr(),
                    const Padding(padding: EdgeInsets.all(4)),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SafeText(
                          data["sprayingDuration"] ?? "--",
                          style: normalTextBlack(fSize: fsize),
                        ),
                        TextButton(
                            onPressed: () {
                              _reset();
                            },
                            child: Text(
                              "oldChangecard.reset",
                              style: TextStyle(fontSize: fsize),
                            ).tr())
                      ],
                    ))
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "oldChangecard.t4Temp",
                      style: normalText(fSize: fsize),
                    ).tr(),
                    const Padding(padding: EdgeInsets.all(4)),
                    SafeText(
                      data["t4Temp"] ?? "--",
                      style: normalTextBlack(fSize: fsize),
                    )
                  ],
                ),
                // Row(
                //   children: [
                //     Text(
                //       "oldChangecard.wh",
                //       style: normalText(),
                //     ).tr(),
                //     const Padding(padding: EdgeInsets.all(4)),
                //     Text(
                //       data["outdoorXyeConnectStatus"] ?? "--",
                //       style: normalTextBlack(),
                //     )
                //   ],
                // )
              ],
            ),
          ),
        Container(
          width: 720.w,
          decoration: cardStyleFull(context),
          margin: EdgeInsets.fromLTRB(0, 0, 0, 24.h),
          padding: EdgeInsets.all(26.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "oldChangecard.title3",
                style: titleText(lineheight: 1.5),
              ).tr(),
              Row(
                children: [
                  Text(
                    "oldChangecard.controlXyeConnectStatus",
                    style: normalText(fSize: fsize),
                  ).tr(),
                  const Padding(padding: EdgeInsets.all(4)),
                  Text(
                    tr("statusNormal${data["controlXyeConnectStatus"] ?? "--"}"),
                    style: normalTextBlack(fSize: fsize),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "oldChangecard.controlK1K2ConnectStatus",
                    style: normalText(fSize: fsize),
                  ).tr(),
                  const Padding(padding: EdgeInsets.all(4)),
                  Text(
                    tr("statusNormal${data["controlK1K2ConnectStatus"] ?? "--"}"),
                    style: normalTextBlack(fSize: fsize),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "oldChangecard.K1K2ConnectStatus",
                    style: normalText(fSize: fsize),
                  ).tr(),
                  const Padding(padding: EdgeInsets.all(4)),
                  Text(
                    tr("statusNormal${data["K1K2ConnectStatus"] ?? "--"}"),
                    style: normalTextBlack(fSize: fsize),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "oldChangecard.outdoorXyeConnectStatus",
                    style: normalText(fSize: fsize),
                  ).tr(),
                  const Padding(padding: EdgeInsets.all(4)),
                  Text(
                    tr("statusNormal${data["outdoorXyeConnectStatus"] ?? "--"}"),
                    style: normalTextBlack(fSize: fsize),
                  )
                ],
              )
            ],
          ),
        ),
        Container(
          width: 720.w,
          decoration: cardStyleFull(context),
          margin: EdgeInsets.fromLTRB(0, 0, 0, 24.h),
          padding: EdgeInsets.all(26.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (data["sprayMeter"] != null)
                Row(
                  children: [
                    Text(
                      "oldChangecard.sprayMeter",
                      style: normalText(fSize: fsize),
                    ).tr(),
                    const Padding(padding: EdgeInsets.all(4)),
                    Text(
                      data["sprayMeter"].toString() != "{}"
                          ? data["sprayMeter"]
                          : "--",
                      style: normalTextBlack(fSize: fsize),
                    )
                  ],
                ),
              if (isFluorineEnergyImgListBack != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "主机旧改照片:",
                      style: normalText(),
                    ),
                    TextButton(
                        onPressed: () {
                          _loadimage();
                        },
                        child: Text('查看'))
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
