import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/HorizontalPercentageBarChart.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/projectinfo.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/cloud/projectManage/ibutler/ibutler.dart';
import 'package:fluoroscopy_tool/view/systemCapabilityAnalysis/step2/systemDetail.dart';
import 'package:fluoroscopy_tool/view/userinfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../publicFunction.dart';
import 'deviceManage.dart';
import 'topology/index.dart';

class projectDetail extends StatefulWidget {
  projectDetail({super.key});

  @override
  State<projectDetail> createState() => _copybasepageState();
}

class _copybasepageState extends State<projectDetail> {
  final cloudProjectController _selectController = Get.find();

  final userinfoController _promissioncontroller = Get.find();
  final List _expansionPanel = [
    "projectDetail.expend1",
    "projectDetail.expend2",
    "projectDetail.expend3",
    "projectDetail.expend4",
    "projectDetail.expend5",
    "projectDetail.expend6",
    "projectDetail.expend7"
  ];

  Map nodemap = {
    "自动优先": "AutoPriority",
    "制冷优先": "CoolPriority",
    "VIP优先": "VIPPriority",
    "只制热": "HeatOnly",
    "只制冷": "CoolOnly",
    "制热优先": "HeatPriority",
    "ChangeOver": "ChangeOver",
    "多开优先": "MultiOpenPriority",
    "先开优先": "StartFirstPriority",
    "能需优先": "DemandPriority",
    "Auto_priority": "AutoPriority",
    "Cooling_priority": "CoolPriority",
    "Heating_priority": "HeatPriority",
    "VIP_priority": "VIPPriority",
    "Energy_demand_priority": "DemandPriority",
    "FirstOpen_Prior": "StartFirstPriority",
    "Heating_only": "HeatOnly",
    "Cooling_only": "CoolOnly",
    "First_enabled": "MultiOpenPriority"
  };

  late Timer _timer;
  int indoorEnergySaveStatus = 0;
  int outdoorPowerRationing = 0;
  int outdoorMuteSetting = 0;
  static const platform =
      MethodChannel('samples.flutter.dev/getProjectHandler');

  static const ibutlerplatform = MethodChannel('samples.flutter.dev/ibutler');
  var contractStatusBack;
  init() async {
    EasyLoading.show(status: 'loading...');
    try {
      var project = _selectController.selectProject.value["project"];
      var contractStatusBackawait = await ibutlerplatform.invokeMethod(
          'contractStatus', {"projectCode": project["code"], "model": "all"});

      contractStatusBack = jsonDecode(contractStatusBackawait);
      setState(() {
        contractStatusBack;
      });

      if (_selectController.selectProject["alldata"] != null) {
        for (var index in _selectController
            .selectProject["alldata"]["outdoorModeSettingEnumIntegerMap"]
            .keys) {
          counttype1[nodemap[index]]!["val"] = _selectController
              .selectProject["alldata"]["outdoorModeSettingEnumIntegerMap"]
                  [index]
              .toString();
        }
      } else {
        var out_history = await platform.invokeMethod(
            'deviceUnlockRunStatisticRun',
            {"projectId": project["id"].toString()});
        var out_historydata = jsonDecode(out_history);

        print("out_historydata: $out_historydata");

        if (out_historydata["data"] != null) {
          for (var element in out_historydata["data"]) {
            String? key = nodemap[element["cn"]];
            if (key != null) {
              counttype1[key]!["val"] = element["value"].toString();
            }
          }
        }
      }

      // var init_history = await platform.invokeMethod(
      //     'getIndoorTopologyData', {"projectCode": project["code"]});
      var insertSearchHistory = await platform.invokeMethod(
          'getProfessionalToolsHandler.insertSearchHistory',
          {"deviceSn": "", "projectDetail": project["code"].toString()});

      print("insertSearchHistory ${{
        "deviceSn": "",
        "projectDetail": project["code"].toString()
      }}: $insertSearchHistory");

      var indoor_history = await platform.invokeMethod(
          'deviceLockRunStatistic', {"projectId": project["id"].toString()});

      var indoor_historydata = jsonDecode(indoor_history);

      print("deviceLockRunStatistic: $indoor_historydata");
      var indoorstatus = indoor_historydata["data"] ?? {};

      counttype2 = {
        'OnlyRespondtoPowerOn': {
          'name': '只响应开机',
          'val': indoorstatus["lockOn"] != null
              ? indoorstatus["lockOn"].toString()
              : "0",
          'icon': 'AutoPriority'
        },
        'CoolingTemperatureLowerLimit': {
          'name': '制冷温度下限',
          'val': indoorstatus["lockCoolingTempLower"] != null
              ? indoorstatus["lockCoolingTempLower"].toString()
              : "0",
          'icon': 'CoolingTemperatureLowerLimit'
        },
        'FanSpeedLock': {
          'name': '风速锁定',
          'val': indoorstatus["lockFanSpeed"] != null
              ? indoorstatus["lockFanSpeed"].toString()
              : "0",
          'icon': 'FanSpeedLock'
        },
        'DisableRemoteControl': {
          'name': '禁用遥控器',
          'val': indoorstatus["lockRemoteController"] != null
              ? indoorstatus["lockRemoteController"].toString()
              : "0",
          'icon': 'DisableRemoteControl'
        },
        'OnlyRespondtoPowerOff': {
          'name': '只响应关机',
          'val': indoorstatus["lockOff"] != null
              ? indoorstatus["lockOff"].toString()
              : "0",
          'icon': 'OnlyRespondtoPowerOff'
        },
        'HeatingTemperatureUpperLimit': {
          'name': '制热温度上限',
          'val': indoorstatus["lockHeatingTempUpper"] != null
              ? indoorstatus["lockHeatingTempUpper"].toString()
              : "0",
          'icon': 'HeatingTemperatureUpperLimit'
        },
        'ModeLock': {
          'name': '模式锁定',
          'val': indoorstatus["lockMode"] != null
              ? indoorstatus["lockMode"].toString()
              : "0",
          'icon': 'ModeLock'
        },
        'DisableWiredController': {
          'name': '禁用线控器',
          'val': indoorstatus["lockLineController"] != null
              ? indoorstatus["lockLineController"].toString()
              : "0",
          'icon': 'DisableWiredController'
        },
      };

      setState(() {
        outdoorPowerRationing = _selectController.selectProject["alldata"]
                ["outdoorPowerRationing"] ??
            "0";
        outdoorMuteSetting = _selectController.selectProject["alldata"]
                ["outdoorMuteSetting"] ??
            "0";
        indoorEnergySaveStatus = _selectController.selectProject["alldata"]
                ["indoorEnergySaveStatus"] ??
            "0";
        counttype1;
        counttype2;
      });
      EasyLoading.dismiss();
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
    }
  }

  TextStyle trailingStyle =
      const TextStyle(fontSize: 16, color: Color.fromRGBO(15, 17, 28, 0.5));
  setTrailing(index) {
    String type = _expansionPanel[index];
    switch (type) {
      case "projectDetail.expend1":
        return const Text("");
      case "projectDetail.expend2":
        return Text(
          "${tr('outdoorPowerRationing')} $outdoorPowerRationing",
          style: trailingStyle,
        );
      case "projectDetail.expend3":
        return Text(
          "${tr('outdoorMuteSetting')} $outdoorMuteSetting",
          style: trailingStyle,
        );

      case "projectDetail.expend4":
        return Text(
          "",
          style: trailingStyle,
        );

      case "projectDetail.expend5":
        return Text(
          "${tr('indoorEnergySaveStatus')}  $indoorEnergySaveStatus",
          style: trailingStyle,
        );
      default:
        return InkWell(
            onTap: () {
              if (index == 5) {
                if (_promissioncontroller
                    .checkCloundPromission("IndoorUnitTopo_StatusView")) {
                  Get.to(() => topologyIndex());
                }
              }
              if (index == 6) {
                Get.to(() => ibutler());
              }
            },
            child: SizedBox(
              width: 110,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "showMore",
                      style: selectText(
                        lineheight: 1,
                        fw: FontWeight.w400,
                      ),
                    ).tr(),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: Icon(
                      Icons.chevron_right,
                      size: 28,
                      color: Color.fromRGBO(25, 98, 255, 1),
                    ),
                  )
                ],
              ),
            ));
    }
  }

  Map<String, Map<String, String>> counttype1 = {
    'AutoPriority': {'name': '自动优先', 'val': '--', 'icon': 'AutoPriority'},
    'CoolPriority': {'name': '制冷优先', 'val': '--', 'icon': 'CoolPriority'},
    'HeatPriority': {'name': '制热优先', 'val': '--', 'icon': 'HeatPriority'},
    'MultiOpenPriority': {
      'name': '多开优先',
      'val': '--',
      'icon': 'MultiOpenPriority'
    },
    'VIPPriority': {'name': 'VIP优先', 'val': '--', 'icon': 'VIPPriority'},
    'ChangeOver': {'name': 'Change Over', 'val': '--', 'icon': 'ChangeOver'},
    'HeatOnly': {'name': '只制热', 'val': '--', 'icon': 'HeatOnly'},
    'CoolOnly': {'name': '只制冷', 'val': '--', 'icon': 'CoolOnly'},
    'StartFirstPriority': {
      'name': '先开优先',
      'val': '--',
      'icon': 'StartFirstPriority'
    },
    'DemandPriority': {'name': '能需优先', 'val': '--', 'icon': 'DemandPriority'},
  };

  Map<String, Map<String, String>> counttype2 = {
    'OnlyRespondtoPowerOn': {
      'name': '只响应开机',
      'val': '--',
      'icon': 'AutoPriority'
    },
    'CoolingTemperatureLowerLimit': {
      'name': '制冷温度下限',
      'val': '--',
      'icon': 'CoolingTemperatureLowerLimit'
    },
    'FanSpeedLock': {'name': '风速锁定', 'val': '--', 'icon': 'FanSpeedLock'},
    'DisableRemoteControl': {
      'name': '禁用遥控器',
      'val': '--',
      'icon': 'DisableRemoteControl'
    },
    'OnlyRespondtoPowerOff': {
      'name': '只响应关机',
      'val': '--',
      'icon': 'OnlyRespondtoPowerOff'
    },
    'HeatingTemperatureUpperLimit': {
      'name': '制热温度上限',
      'val': '--',
      'icon': 'HeatingTemperatureUpperLimit'
    },
    'ModeLock': {'name': '模式锁定', 'val': '--', 'icon': 'ModeLock'},
    'DisableWiredController': {
      'name': '禁用线控器',
      'val': '--',
      'icon': 'DisableWiredController'
    },
  };

  setContent(index) {
    String type = _expansionPanel[index];

    switch (type) {
      case "projectDetail.expend7":
        var vrf = _selectController.selectProject.value["vrf"];
        double notUse = 0;
        double trying = 0;
        double using = 0;
        double expired = 0;
        print(vrf["data"]);
        if (vrf != null &&
            vrf["data"] != null &&
            vrf["data"]["contractStatus"] != null) {
          for (var element in vrf["data"]["contractStatus"]) {
            if (element["en"] == "notUse") {
              notUse = double.parse(element["value"].toString());
            }
            if (element["en"] == "trying") {
              trying = double.parse(element["value"].toString());
            }
            if (element["en"] == "using") {
              using = double.parse(element["value"].toString());
            }
            if (element["en"] == "expired") {
              expired = double.parse(element["value"].toString());
            }
          }
        } else {
          // data: {dataBoard: {}, allDevices: 34, notTried: 1, inTrial: 26, overTrial: 0, inContract: 6, overContract: 1, over: 1}

          //  NamedValueColor(
          //           name: tr('NamedValueColor.trying'),
          //           value: trying,
          //           color: const Color.fromRGBO(108, 164, 255, 1)),
          //       NamedValueColor(
          //           name: tr('NamedValueColor.using'),
          //           value: using,
          //           color: const Color.fromRGBO(145, 112, 207, 1)),
          //       NamedValueColor(
          //           name: tr('NamedValueColor.expired'),
          //           value: expired,
          //           color: const Color.fromRGBO(248, 208, 114, 1)),
          //       NamedValueColor(
          //           name: tr('NamedValueColor.notUse'),
          //           value: notUse,
          //           color: const Color.fromRGBO(242, 161, 90, 1)),

          if (contractStatusBack['data'] != null) {
            var element = contractStatusBack['data'];
            try {
              if (element["notTried"].toString() != "{}") {
                notUse = double.parse(element["notTried"].toString());
              }
              if (element["inTrial"].toString() != "{}") {
                trying = double.parse(element["inTrial"].toString());
              }
              if (element["inContract"].toString() != "{}") {
                using = double.parse(element["inContract"].toString());
              }
              if (element["over"].toString() != "{}") {
                expired = double.parse(element["over"].toString());
              }
            } catch (e) {}
          }
        }
        return [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 50),
            child: HorizontalPercentageBarChart(
              barHeight: 16,
              barWidth: 720.w - 64.w,
              borderRadius: 16,
              iscountAlll: true,
              data: [
                NamedValueColor(
                    name: tr('NamedValueColor.trying'),
                    value: trying,
                    color: const Color.fromRGBO(108, 164, 255, 1)),
                NamedValueColor(
                    name: tr('NamedValueColor.using'),
                    value: using,
                    color: const Color.fromRGBO(145, 112, 207, 1)),
                NamedValueColor(
                    name: tr('NamedValueColor.expired'),
                    value: expired,
                    color: const Color.fromRGBO(248, 208, 114, 1)),
                NamedValueColor(
                    name: tr('NamedValueColor.notUse'),
                    value: notUse,
                    color: const Color.fromRGBO(242, 161, 90, 1)),
              ],
            ),
          )
        ];
      case "projectDetail.expend1":
        return [
          SizedBox(
              width: 720.w - 16 * 2,
              child: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  for (var index in counttype1.keys)
                    if (counttype1[index]!['val'] != '--' &&
                        counttype1[index]!['val'] != '0')
                      cardinfo(item: counttype1[index])
                ],
              ))
        ];
      case "projectDetail.expend4":
        return [
          SizedBox(
              width: 720.w - 16 * 2,
              child: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  for (var index in counttype2.keys)
                    if (counttype2[index]!['val'] != '--' &&
                        counttype2[index]!['val'] != '0')
                      cardinfo(item: counttype2[index])
                ],
              ))
        ];
      default:
        return [Container()];
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    try {
      _timer.cancel();
    } catch (e) {}
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
          title: Text(
            _selectController.selectProject.value["project"]['name'],
            style: const TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [],
        ),
        body: Container(
            width: 720.w,
            height: 1280.h,
            color: const Color.fromRGBO(200, 218, 246, 1),
            padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0.w, 49.h, 0.w, 0),
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                        border: null,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8)),
                        color: Colors.white),
                    child: Column(
                      children: [
                        Container(
                            width: 720.w,
                            child: projectinfo(
                                search: "",
                                showing: {}
                                  ..addAll(_selectController
                                      .selectProject.value["project"])
                                  ..addAll(_selectController
                                      .selectProject.value["alldata"])
                                  ..addAll(_selectController
                                      .selectProject.value["vrf"]))),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                          decoration: const BoxDecoration(
                              color: Colors.white, border: null),
                          child: InkWell(
                            onTap: () {
                              if (_promissioncontroller
                                  .checkCloundPromission("SystemDetailView")) {
                                Get.to(() => deviceManage());
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 110,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "showMore",
                                          style: selectText(
                                            lineheight: 1,
                                            fw: FontWeight.w400,
                                          ),
                                        ).tr(),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 5),
                                        child: Icon(
                                          Icons.chevron_right,
                                          size: 28,
                                          color: Color.fromRGBO(25, 98, 255, 1),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  for (int index = 0; index < _expansionPanel.length; index++)
                    if (contractStatusBack != null)
                      Container(
                          color: Colors.white,
                          child: ExpansionTile(
                            initiallyExpanded: true,
                            title: Text(
                              "${_expansionPanel[index]}",
                              style: normalText(
                                  fSize: 16,
                                  lineheight: 1,
                                  fontcolor: Colors.black),
                            ).tr(),
                            trailing: setTrailing(index),
                            children: setContent(index),
                          ))
                ],
              ),
            )));
  }
}

class cardinfo extends StatelessWidget {
  var item;
  cardinfo({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (720.w - 64.w) / 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: Image.asset(
                  'public/images/cloud/${item!['icon']}.png',
                  height: 28.w,
                ),
              ),
              SafeText(
                item!['name']!,
                style: const TextStyle(
                    fontSize: 14.0, color: Color.fromRGBO(13, 13, 13, 0.5)),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: SafeText(
                  item!['val']!,
                  style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(13, 13, 13, 1)),
                ),
              ),
              SafeText(
                'unit.tai',
                style: TextStyle(
                    fontSize: 12.0, color: Color.fromRGBO(13, 13, 13, 0.5)),
              )
            ]),
          )
        ],
      ),
    );
  }
}
