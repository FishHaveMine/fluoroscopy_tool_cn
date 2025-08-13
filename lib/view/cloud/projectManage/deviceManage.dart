import 'dart:convert';
import 'dart:ffi';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/deviceListinfo.dart';
import 'package:fluoroscopy_tool/compent/snInput.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/cloud/device/%20deviceDetail.dart';
import 'package:fluoroscopy_tool/view/cloud/projectManage/addmodel4g.dart';
import 'package:fluoroscopy_tool/view/cloud/projectManage/addmodelM0/step1.dart';
import 'package:fluoroscopy_tool/view/cloud/publicFunction.dart';
import 'package:fluoroscopy_tool/view/userinfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: depend_on_referenced_packages
import 'package:get/get.dart';

import 'batchUnbindDevices.dart';
import 'moduleReplacement.dart';
import 'projectDetail.dart';

class deviceManage extends StatefulWidget {
  var base;
  deviceManage({super.key, this.base});

  @override
  State<deviceManage> createState() => _copybasepageState();
}

class _copybasepageState extends State<deviceManage> {
  static const platform =
      MethodChannel('samples.flutter.dev/getProjectHandler');

  final userinfoController _promissioncontroller = Get.find();
  final cloudProjectController _selectController = Get.find();
  List<String> menuItems = [
    'projectDetail.deviceManage.action1',
    'projectDetail.deviceManage.action2',
    'projectDetail.deviceManage.action3',
    'projectDetail.deviceManage.action4',
    'projectDetail.deviceManage.action5',
  ];
  CustomPopupMenuController _controller = CustomPopupMenuController();
  String search = "";

  int pageindex = 1;
  int total = 999;
  // 加载更多的标志
  bool isLoading = true;
  bool isMODEL_OLD_CHANGE = false;
  // 控制器用于监听滚动事件
  ScrollController _scrollController = ScrollController();

  List history = [];
  List systemSelectDTOList = [];

  Map netModelEnumMap = {
    "all": "all",
    "0": "MODEL_4G",
    "1": "MODEL_M0",
    "2": "MODEL_OLD_CHANGE"
  };
  Map statusMap = {
    "all": "all",
    "0": "device_status0",
    "5": "device_status5",
    "1": "device_status1",
    "2": "device_status2",
    "3": "device_status3",
  };
  Map systemSelectDTOListMap = {};
  String _selectedValue = "";
  String _netModelEnumValue = "";
  String _statusMapalue = "";

  String? IndoorLockStatusEnum;
  String? outdoorModeSettingEnum;
  bool? indoorEnergySaveStatus;
  bool? outdoorPowerRationing;
  bool? outdoorMuteSetting;
  searchsn() {
    setState(() {
      history = [];
      pageindex = 1;
      total = 999;
    });
    getSearchHistories();
  }

  var getProjectSystemPropertyCountdata;
  _showBottom() async {
    try {
      var project = _selectController.selectProject.value["project"];

      var SystemSelectList = await platform
          .invokeMethod('getProfessionalToolsHandler.getSystemSelectList', {
        "projectCode": project["code"].toString(),
        "vrfNid": _selectedValue,
        "netModelEnum": _netModelEnumValue,
        "status": _statusMapalue,
      });
      var SystemList = jsonDecode(SystemSelectList);
      List _nid = SystemList["data"]["systemSelectDTOList"]
          .map((item) => item['nid'] as String)
          .toList();

      var historyback1 = await platform.invokeMethod(
          'getProfessionalToolsHandler.getProjectSystemPropertyCount',
          {"sysNidList": _nid});
      var historydata1 = jsonDecode(historyback1);
      getProjectSystemPropertyCountdata = historydata1["data"];

      var result = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        builder: (BuildContext context) {
          return FilterBottomSheet(
              data: getProjectSystemPropertyCountdata,
              IndoorLockStatusEnum: IndoorLockStatusEnum,
              outdoorModeSettingEnum: outdoorModeSettingEnum,
              indoorEnergySaveStatus: indoorEnergySaveStatus,
              outdoorPowerRationing: outdoorPowerRationing,
              outdoorMuteSetting: outdoorMuteSetting);
        },
      );
      if (result != null) {
        IndoorLockStatusEnum = result["IndoorLockStatusEnum"];
        outdoorModeSettingEnum = result["outdoorModeSettingEnum"];
        indoorEnergySaveStatus = result["indoorEnergySaveStatus"];
        outdoorPowerRationing = result["outdoorPowerRationing"];
        outdoorMuteSetting = result["outdoorMuteSetting"];
        searchsn();
      }
    } catch (e) {}
  }

  _initSys() async {
    try {
      var project = _selectController.selectProject.value["project"];
      isMODEL_OLD_CHANGE = project["projectType"] != "129";
      if (isMODEL_OLD_CHANGE) {
        menuItems = [
          'projectDetail.deviceManage.action1',
          // 'projectDetail.deviceManage.action4',
          'projectDetail.deviceManage.action5',
        ];
      } else {
        menuItems = [
          'projectDetail.deviceManage.action2',
          'projectDetail.deviceManage.action3',
          'projectDetail.deviceManage.action4',
          'projectDetail.deviceManage.action5',
        ];
      }
      setState(() {
        isMODEL_OLD_CHANGE;
        menuItems;
      });
      var SystemSelectList = await platform
          .invokeMethod('getProfessionalToolsHandler.getSystemSelectList', {
        "projectCode": project["code"].toString(),
        "vrfNid": "",
        "netModelEnum": "",
        "status": "",
      });
      var SystemList = jsonDecode(SystemSelectList);
      print("getSystemSelectList: $SystemList");
      if (SystemList["data"] != null &&
          SystemList["data"]["systemSelectDTOList"] != null) {
        systemSelectDTOList.addAll(SystemList["data"]["systemSelectDTOList"]);
        for (var element in systemSelectDTOList) {
          systemSelectDTOListMap[element["nid"]] = element["name"];
        }
        setState(() {
          systemSelectDTOList;
          systemSelectDTOListMap;
        });
      }
    } catch (e) {}
  }

  getSearchHistories() async {
    EasyLoading.show(status: 'loading...');
    try {
      var project = _selectController.selectProject.value["project"];
      print(
          " ---------------------------  getSearchHistories   ---------------------------");
      print(project);
      var send = {
        "projectCode": project["code"].toString(),
        "sn": search,
        "vrfNid": _selectedValue,
        "netModelEnum": _netModelEnumValue,
        "status": _statusMapalue,
        "pageindex": pageindex,
      };
      if (IndoorLockStatusEnum != null) {
        send["indoorLockStatusEnum"] = IndoorLockStatusEnum!;
      }
      if (outdoorModeSettingEnum != null) {
        send["outdoorModeSettingEnum"] = outdoorModeSettingEnum!;
      }
      if (indoorEnergySaveStatus != null) {
        send["indoorEnergySaveStatus"] = indoorEnergySaveStatus!;
      }
      if (outdoorPowerRationing != null) {
        send["outdoorPowerRationing"] = outdoorPowerRationing!;
      }
      if (outdoorMuteSetting != null) {
        send["outdoorMuteSetting"] = outdoorMuteSetting!;
      }

      var historyback =
          await platform.invokeMethod('getProfessionalToolsHandler.page', send);

      var historydata = jsonDecode(historyback);
      if (historydata["errorCode"] != null &&
          historydata["errorCode"].toString() == "1001") {
        //登录失效
        tologout();
      }

      if (!historydata['success']) {
        EasyLoading.showError(historydata['errorMsg']);
      }
      total = historydata["totalCount"];
      setState(() {
        history.addAll(historydata["data"]);
        isLoading = false;
      });
      EasyLoading.dismiss();
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      EasyLoading.dismiss();
    }
  }

  bool SystemDetailEdit = true;
  @override
  void initState() {
    super.initState();
    SystemDetailEdit = _promissioncontroller
        .checkCloundPromission("SystemDetailEdit", showtoast: false);
    setState(() {
      SystemDetailEdit;
    });
    _initSys();
    getSearchHistories();
    // 添加滚动监听器
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // 移除滚动监听器
    _scrollController.dispose();
    EasyLoading.dismiss();
    super.dispose();
  }

  // 滚动监听器
  void _scrollListener() {
    // 如果滚动到底部并且不在加载状态中，则加载更多数据
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading &&
        history.length < total) {
      // setState(() {
      //   isLoading = true;
      // });
      pageindex++;
      // 模拟异步加载数据
      getSearchHistories();
    }
  }

  refesh() {
    setState(() {
      search = "";
    });
    // 模拟异步加载数据
    searchsn();
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
            'projectDetail.sysdetail',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [
            if (SystemDetailEdit)
              CustomPopupMenu(
                  horizontalMargin: 10.0,
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
                                        if (item ==
                                            "projectDetail.deviceManage.action5") {
                                          await Get.to(
                                              () => batchUnbindDevices());
                                          refesh();
                                        } else if (item ==
                                            "projectDetail.deviceManage.action4") {
                                          await Get.to(
                                              () => moduleReplacement());
                                          refesh();
                                        } else if (item ==
                                            "projectDetail.deviceManage.action2") {
                                          await Get.to(() => addmodel4g());
                                          refesh();
                                          // EasyLoading.showInfo(
                                          //     tr("codingtip.Text"));
                                          // return;
                                        } else if (item ==
                                            "projectDetail.deviceManage.action1") {
                                          var project = _selectController
                                              .selectProject.value["project"];

                                          await Get.to(() => addmodelM0(
                                              projectCode:
                                                  project["code"].toString()));
                                          refesh();
                                          // EasyLoading.showInfo(
                                          //     tr("codingtip.Text"));
                                          // return;
                                        } else {
                                          EasyLoading.showInfo(
                                              tr("codingtip.Text"));
                                          return;
                                        }
                                      },
                                      child: Container(
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                // margin:
                                                //     const EdgeInsets.only(left: 10),
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                  child: Row(
                    children: [
                      const Text(
                        "projectDetail.deviceManage.action",
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Color.fromRGBO(17, 20, 26, 1)),
                      ).tr(),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 0, 24.w, 0),
                        child: Image.asset(
                          'public/images/cloud/manage.png',
                          height: 20,
                        ),
                      ),
                    ],
                  )),
          ],
        ),
        body: Container(
          width: 720.w,
          height: 1280.h,
          color: const Color.fromRGBO(244, 244, 244, 1),
          padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(32.w, 0.h, 32.w, 0.h),
                width: double.infinity,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 24.h, 0, 0.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Positioned(
                                child: Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              padding: const EdgeInsets.all(0),
                              height: 44,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(42),
                                  color: Colors.white),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 0, 0, 0),
                                        child: snInput(
                                          hintText: tr("search.hintText1"),
                                          isSamll: true,
                                          onfocus: () {},
                                          valBack: (back) {
                                            setState(() {
                                              search = back;
                                            });
                                            if (back == "") {
                                              searchsn();
                                            }
                                          },
                                        )),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      searchsn();
                                    },
                                    child: Container(
                                      width: 55,
                                      height: 36,
                                      margin: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(49),
                                          color: const Color.fromRGBO(
                                              25, 98, 255, 1)),
                                      child: Center(
                                        child: const Text(
                                          'search',
                                          style: TextStyle(
                                              color: Colors.white,
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
              Container(
                margin: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                height: 42,
                color: Colors.white,
                child: Row(
                  children: [
                    Container(
                      width: 720.w / 4,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                        items: [
                          DropdownMenuItem<String>(
                            value: "all",
                            child: Text(
                              "all",
                              style: normalText(),
                            ).tr(),
                          ),
                          for (var item in systemSelectDTOList)
                            DropdownMenuItem<String>(
                              value: item["nid"],
                              child: Text(
                                item["name"],
                                overflow: TextOverflow
                                    .ellipsis, // Add ellipsis if text overflows
                                softWrap: false, // Prevent line breaks
                                style: normalText(
                                  lineheight: 1,
                                ),
                              ),
                            )
                        ],
                        onChanged: (val) {
                          setState(() {
                            _selectedValue = val == "all" ? "" : val!;
                          });
                          searchsn();
                        },
                        isExpanded:
                            true, // Ensure the button takes full width of the container
                        hint: Text(
                          _selectedValue == ""
                              ? "${tr("sys")}${systemSelectDTOList.length}"
                              : systemSelectDTOListMap[_selectedValue],
                          style: normalText(
                            lineheight: 1,
                          ),
                          overflow: TextOverflow
                              .ellipsis, // Add ellipsis if text overflows
                          softWrap: false, // Prevent line breaks
                        ),
                      )),
                    ),
                    Container(
                      width: 720.w / 4,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                        items: [
                          for (var item in statusMap.keys)
                            DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                statusMap[item],
                                style: normalText(
                                  lineheight: 1,
                                ),
                              ).tr(),
                            )
                        ],
                        onChanged: (val) {
                          setState(() {
                            _statusMapalue = val == "all" ? "" : val!;
                          });
                          searchsn();
                        },
                        isExpanded:
                            true, // Ensure the button takes full width of the container
                        hint: Text(
                          _statusMapalue == ""
                              ? tr("sysStatus")
                              : tr(statusMap[_statusMapalue]),
                          style: normalText(
                            lineheight: 1,
                          ),
                          overflow: TextOverflow
                              .ellipsis, // Add ellipsis if text overflows
                          softWrap: false, // Prevent line breaks
                        ),
                      )),
                    ),
                    Container(
                      width: 720.w / 4,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                        items: [
                          for (var item in netModelEnumMap.keys)
                            DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                netModelEnumMap[item],
                                style: normalText(
                                  lineheight: 1,
                                ),
                              ).tr(),
                            )
                        ],
                        onChanged: (val) {
                          setState(() {
                            _netModelEnumValue = val == "all" ? "" : val!;
                          });
                          searchsn();
                        },
                        isExpanded:
                            true, // Ensure the button takes full width of the container
                        hint: Text(
                          _netModelEnumValue == ""
                              ? tr("netModelEnum")
                              : tr(netModelEnumMap[_netModelEnumValue]),
                          style: normalText(
                            lineheight: 1,
                          ),
                          overflow: TextOverflow
                              .ellipsis, // Add ellipsis if text overflows
                          softWrap: false, // Prevent line breaks
                        ),
                      )),
                    ),
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              // searchsn();
                              _showBottom();
                            },
                            child: Text(
                              "filter",
                              style: normalText(
                                  lineheight: 1,
                                  fontcolor: (IndoorLockStatusEnum != null ||
                                          outdoorModeSettingEnum != null ||
                                          indoorEnergySaveStatus != null ||
                                          outdoorPowerRationing != null ||
                                          outdoorMuteSetting != null)
                                      ? const Color.fromRGBO(25, 98, 255, 1)
                                      : const Color.fromRGBO(140, 140, 140, 1)),
                            ).tr()))
                  ],
                ),
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: history.length,
                      controller: _scrollController,
                      itemBuilder: ((context, index) {
                        return Container(
                            padding: EdgeInsets.fromLTRB(32.w, 0.h, 32.w, 0.h),
                            child: InkWell(
                                onTap: () {
                                  if (_promissioncontroller
                                      .checkCloundPromission(
                                          "DeviceView_Archived")) {
                                    _selectController
                                        .setSelectDevice(history[index]);

                                    Get.to(() => deviceDetail());
                                  }
                                },
                                child: Container(
                                    width: 720.w - 24.w * 2,
                                    padding: const EdgeInsets.all(11),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white),
                                    margin:
                                        EdgeInsets.fromLTRB(0.w, 0, 0.w, 16),
                                    child: deviceListinfo(
                                        search: search,
                                        showproject: false,
                                        showing: history[index]))));
                      })))
            ],
          ),
        ));
  }
}

class FilterBottomSheet extends StatefulWidget {
  String? IndoorLockStatusEnum;
  String? outdoorModeSettingEnum;
  bool? indoorEnergySaveStatus;
  bool? outdoorPowerRationing;
  bool? outdoorMuteSetting;
  var data;
  FilterBottomSheet(
      {super.key,
      this.data,
      this.IndoorLockStatusEnum,
      this.outdoorModeSettingEnum,
      this.indoorEnergySaveStatus,
      this.outdoorPowerRationing,
      this.outdoorMuteSetting});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? IndoorLockStatusEnum;
  String? outdoorModeSettingEnum;
  bool? indoorEnergySaveStatus;
  bool? outdoorPowerRationing;
  bool? outdoorMuteSetting;

  Map<String, Map<String, String>> counttype1 = {
    'AutoPriority': {
      'name': '自动优先',
      'val': '--',
      'icon': 'AutoPriority',
      'Enum': "Auto_priority"
    },
    'CoolPriority': {
      'name': '制冷优先',
      'val': '--',
      'icon': 'CoolPriority',
      'Enum': "Cooling_priority"
    },
    'HeatPriority': {
      'name': '制热优先',
      'val': '--',
      'icon': 'HeatPriority',
      'Enum': "Heating_priority"
    },
    'MultiOpenPriority': {
      'name': '多开优先',
      'val': '--',
      'icon': 'MultiOpenPriority',
      'Enum': "FirstOpen_Prior"
    },
    'VIPPriority': {
      'name': 'VIP优先',
      'val': '--',
      'icon': 'VIPPriority',
      'Enum': "VIP_priority"
    },
    'ChangeOver': {
      'name': 'Change Over',
      'val': '--',
      'icon': 'ChangeOver',
      'Enum': "ChangeOver"
    },
    'HeatOnly': {
      'name': '只制热',
      'val': '--',
      'icon': 'HeatOnly',
      'Enum': "Heating_only"
    },
    'CoolOnly': {
      'name': '只制冷',
      'val': '--',
      'icon': 'CoolOnly',
      'Enum': "Cooling_only"
    },
    'StartFirstPriority': {
      'name': '先开优先',
      'val': '--',
      'icon': 'StartFirstPriority',
      'Enum': "FirstOpen_Prior"
    },
    'DemandPriority': {
      'name': '能需优先',
      'val': '--',
      'icon': 'DemandPriority',
      'Enum': "Energy_demand_priority"
    },
  };

  Map<String, Map<String, String>> counttype2 = {
    'OnlyRespondtoPowerOn': {
      'name': '只响应开机',
      'val': '--',
      'icon': 'AutoPriority',
      'Enum': "LOCK_OPEN"
    },
    'CoolingTemperatureLowerLimit': {
      'name': '制冷温度下限',
      'val': '--',
      'icon': 'CoolingTemperatureLowerLimit',
      'Enum': "LOCK_CLOUD_LOWER"
    },
    'FanSpeedLock': {
      'name': '风速锁定',
      'val': '--',
      'icon': 'FanSpeedLock',
      'Enum': "LOCK_FANSPEED"
    },
    'DisableRemoteControl': {
      'name': '禁用遥控器',
      'val': '--',
      'icon': 'DisableRemoteControl',
      'Enum': "LOCK_REMOTE"
    },
    'OnlyRespondtoPowerOff': {
      'name': '只响应关机',
      'val': '--',
      'icon': 'OnlyRespondtoPowerOff',
      'Enum': "LOCK_CLOSE"
    },
    'HeatingTemperatureUpperLimit': {
      'name': '制热温度上限',
      'val': '--',
      'icon': 'HeatingTemperatureUpperLimit',
      'Enum': "LOCK_HEAT_HIGH"
    },
    'ModeLock': {
      'name': '模式锁定',
      'val': '--',
      'icon': 'ModeLock',
      'Enum': "LOCK_MODE"
    },
    'DisableWiredController': {
      'name': '禁用线控器',
      'val': '--',
      'icon': 'DisableWiredController',
      'Enum': "LOCK_LINE"
    },
  };

  var valmap = {};
  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      for (var outside in widget.data.keys) {
        if (widget.data[outside].runtimeType != int) {
          var _data = widget.data[outside];
          for (var keys in _data.keys) {
            valmap[keys] = _data[keys];
          }
        } else {
          valmap[outside] = widget.data[outside];
        }
      }
    }
    setState(() {
      IndoorLockStatusEnum = widget.IndoorLockStatusEnum;
      outdoorModeSettingEnum = widget.outdoorModeSettingEnum;
      indoorEnergySaveStatus = widget.indoorEnergySaveStatus;
      outdoorPowerRationing = widget.outdoorPowerRationing;
      outdoorMuteSetting = widget.outdoorMuteSetting;
    });
  }

  _clearval(key) {
    setState(() {
      if (key != "IndoorLockStatusEnum") IndoorLockStatusEnum = null;
      if (key != "outdoorModeSettingEnum") outdoorModeSettingEnum = null;
      if (key != "indoorEnergySaveStatus") indoorEnergySaveStatus = null;
      if (key != "outdoorPowerRationing") outdoorPowerRationing = null;
      if (key != "outdoorMuteSetting") outdoorMuteSetting = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.9, // 设置弹框高度
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(),
                Text(
                  "全部筛选",
                  style: titleText(),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context); // 关闭底部弹框
                  },
                  child: const Icon(
                    Icons.close,
                    color: Color.fromRGBO(140, 140, 140, 1),
                  ),
                )
              ],
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "projectDetail.expend4",
                      style: titleText(),
                    ).tr(),
                    Container(
                      width: 720.w,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Wrap(
                        spacing: 10.0,
                        runSpacing: 10,
                        // alignment: WrapAlignment.spaceAround,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          for (var index in counttype2.keys)
                            InkWell(
                              onTap: () {
                                _clearval("IndoorLockStatusEnum");
                                setState(() {
                                  IndoorLockStatusEnum = IndoorLockStatusEnum ==
                                          counttype2[index]!['Enum']
                                      ? null
                                      : counttype2[index]!['Enum'];
                                });
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(8),
                                  width:
                                      (MediaQuery.of(context).size.width - 52) /
                                          3, // 每行三个元素
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: IndoorLockStatusEnum ==
                                              counttype2[index]!['Enum']
                                          ? const Color.fromRGBO(25, 98, 255, 1)
                                          : const Color(
                                              0xFFF3F3F3), // 边框颜色 rgba(25,98,255,1)
                                      width: 1, // 边框宽度 2px
                                    ),
                                    color:
                                        const Color(0xFFF3F3F3), // 背景色 #F3F3F3
                                    borderRadius:
                                        BorderRadius.circular(10), // 圆角 10px
                                  ),
                                  child: Center(
                                    child: Builder(
                                      builder: (context) {
                                        // 修改 counttype2[index] 的 val 属性为 valmap[index] 的值
                                        counttype2[index]!["val"] =
                                            valmap[counttype2[index]!['Enum']]
                                                .toString();
                                        if (counttype2[index]!["val"] ==
                                            "null") {
                                          counttype2[index]!["val"] = "0";
                                        }
                                        // 传递修改后的对象给 CardInfo
                                        return cardinfo(
                                            item: counttype2[index]);
                                      },
                                    ),
                                  )),
                            )
                        ],
                      ),
                    ),
                    const Divider(),
                    Text(
                      "projectDetail.expend1",
                      style: titleText(),
                    ).tr(),
                    Container(
                      width: 720.w,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Wrap(
                        spacing: 10.0,
                        runSpacing: 10,
                        // alignment: WrapAlignment.spaceAround,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          for (var index in counttype1.keys)
                            InkWell(
                              onTap: () {
                                _clearval("outdoorModeSettingEnum");
                                setState(() {
                                  outdoorModeSettingEnum =
                                      outdoorModeSettingEnum ==
                                              counttype1[index]!['Enum']
                                          ? null
                                          : counttype1[index]!['Enum'];
                                });
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(8),
                                  width:
                                      (MediaQuery.of(context).size.width - 52) /
                                          3, // 每行三个元素
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: outdoorModeSettingEnum ==
                                              counttype1[index]!['Enum']
                                          ? const Color.fromRGBO(25, 98, 255, 1)
                                          : const Color(
                                              0xFFF3F3F3), // 边框颜色 rgba(25,98,255,1)
                                      width: 1, // 边框宽度 2px
                                    ),
                                    color:
                                        const Color(0xFFF3F3F3), // 背景色 #F3F3F3
                                    borderRadius:
                                        BorderRadius.circular(10), // 圆角 10px
                                  ),
                                  child: Center(child: Builder(
                                    builder: (context) {
                                      // 修改 counttype2[index] 的 val 属性为 valmap[index] 的值
                                      counttype1[index]!["val"] =
                                          valmap[counttype1[index]!['Enum']]
                                              .toString();
                                      if (counttype1[index]!["val"] == "null") {
                                        counttype1[index]!["val"] = "0";
                                      }
                                      // 传递修改后的对象给 CardInfo
                                      return cardinfo(item: counttype1[index]);
                                    },
                                  ))),
                            )
                        ],
                      ),
                    ),
                    const Divider(),
                    Text(
                      "projectDetail.expend2",
                      style: titleText(),
                    ).tr(),
                    Container(
                        width: 720.w,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Wrap(
                          children: [
                            InkWell(
                                onTap: () {
                                  _clearval("outdoorPowerRationing");
                                  setState(() {
                                    outdoorPowerRationing =
                                        outdoorPowerRationing == true
                                            ? null
                                            : true;
                                  });
                                },
                                child: Container(
                                  height: 61,
                                  width:
                                      (MediaQuery.of(context).size.width - 52) /
                                          3, // 每行三个元素
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: outdoorPowerRationing == true
                                          ? const Color.fromRGBO(25, 98, 255, 1)
                                          : const Color(
                                              0xFFF3F3F3), // 边框颜色 rgba(25,98,255,1)
                                      width: 1, // 边框宽度 2px
                                    ),
                                    color:
                                        const Color(0xFFF3F3F3), // 背景色 #F3F3F3
                                    borderRadius:
                                        BorderRadius.circular(10), // 圆角 10px
                                  ),
                                  child: Center(
                                    child: Text(
                                        "限电台数 ${valmap["outdoorPowerRationing"] ?? "0"}"),
                                  ),
                                ))
                          ],
                        )),
                    const Divider(),
                    Text(
                      "projectDetail.expend3",
                      style: titleText(),
                    ).tr(),
                    Container(
                        width: 720.w,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Wrap(
                          children: [
                            InkWell(
                                onTap: () {
                                  _clearval("outdoorMuteSetting");
                                  setState(() {
                                    outdoorMuteSetting =
                                        outdoorMuteSetting == true
                                            ? null
                                            : true;
                                  });
                                },
                                child: Container(
                                  height: 61,
                                  width:
                                      (MediaQuery.of(context).size.width - 52) /
                                          3, // 每行三个元素
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: outdoorMuteSetting == true
                                          ? const Color.fromRGBO(25, 98, 255, 1)
                                          : const Color(
                                              0xFFF3F3F3), // 边框颜色 rgba(25,98,255,1)
                                      width: 1, // 边框宽度 2px
                                    ),
                                    color:
                                        const Color(0xFFF3F3F3), // 背景色 #F3F3F3
                                    borderRadius:
                                        BorderRadius.circular(10), // 圆角 10px
                                  ),
                                  child: Center(
                                    child: Text(
                                        "静音设置 ${valmap["outdoorMuteSetting"] ?? "0"}"),
                                  ),
                                ))
                          ],
                        )),
                    const Divider(),
                    Text(
                      "projectDetail.expend5",
                      style: titleText(),
                    ).tr(),
                    Container(
                        width: 720.w,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Wrap(
                          children: [
                            InkWell(
                                onTap: () {
                                  _clearval("indoorEnergySaveStatus");
                                  indoorEnergySaveStatus =
                                      indoorEnergySaveStatus == null
                                          ? true
                                          : null;
                                  print(
                                      "indoorEnergySaveStatus: $indoorEnergySaveStatus");
                                  setState(() {
                                    indoorEnergySaveStatus;
                                  });
                                },
                                child: Container(
                                  height: 61,
                                  width:
                                      (MediaQuery.of(context).size.width - 52) /
                                          3, // 每行三个元素
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: indoorEnergySaveStatus == true
                                          ? const Color.fromRGBO(25, 98, 255, 1)
                                          : const Color(
                                              0xFFF3F3F3), // 边框颜色 rgba(25,98,255,1)
                                      width: 1, // 边框宽度 2px
                                    ),
                                    color:
                                        const Color(0xFFF3F3F3), // 背景色 #F3F3F3
                                    borderRadius:
                                        BorderRadius.circular(10), // 圆角 10px
                                  ),
                                  child: Center(
                                    child: Text(
                                        "ECO开启 ${valmap["indoorEnergySaveStatus"] ?? "0"}"),
                                  ),
                                ))
                          ],
                        )),
                    const Divider(),
                  ],
                ),
              ),
            )),
            Container(
              height: 57,
              padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
              child: Center(
                child: submitButton(
                  isActive: true,
                  label: tr('filter'),
                  onClick: () async {
                    Navigator.pop(context, {
                      "IndoorLockStatusEnum": IndoorLockStatusEnum,
                      "outdoorModeSettingEnum": outdoorModeSettingEnum,
                      "indoorEnergySaveStatus": indoorEnergySaveStatus,
                      "outdoorPowerRationing": outdoorPowerRationing,
                      "outdoorMuteSetting": outdoorMuteSetting,
                    }); // 关闭底部弹框
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class cardinfo extends StatelessWidget {
  var item;
  cardinfo({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
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
            Text(
              item!['name']!,
              style: const TextStyle(
                  fontSize: 12.0, color: Color.fromRGBO(13, 13, 13, 0.5)),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: Text(
                item!['val']!,
                style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(13, 13, 13, 1)),
              ),
            ),
            const Text(
              'unit.tai',
              style: TextStyle(
                  fontSize: 12.0, color: Color.fromRGBO(13, 13, 13, 0.5)),
            ).tr()
          ]),
        )
      ],
    );
  }
}
