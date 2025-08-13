import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/bottomSelectSheet.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/compent/tapContainer.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import '../userinfo.dart';
import '../waterPumpInspection/search.dart';
import 'objectSetting.dart';

class parametersSetting extends StatefulWidget {
  parametersSetting({super.key});

  @override
  State<parametersSetting> createState() => _parametersSettingState();
}

class _parametersSettingState extends State<parametersSetting> {
  int activeIndex = 0;
  int connectType = 2;

  String _key = "_key";
  final deviceInfoController _deviceInfoController = Get.find();
  var _info = {};
  static const platform = MethodChannel('samples.flutter.dev/battery');
  getconnectbySn() async {
    if (_deviceInfoController.loacalDevice.value.isconnected) {
      try {
        var getSearchBySnback = await platform.invokeMethod(
            'getSearchBySn', <String, dynamic>{
          "sn": _deviceInfoController.loacalDevice.value.sn
        });
        if (getSearchBySnback["empty"]) {
          // EasyLoading.showError(tr("getSearchBySn.empty"));
          return;
        }
        if (getSearchBySnback["data"] != null) {
          setState(() {
            _info = getSearchBySnback["data"][0];
            _key = DateTime.now().millisecondsSinceEpoch.toString();
          });
        } else {}
      } catch (e) {
        // EasyLoading.showError(tr("getSearchBySn.empty"));
      }
    } else {}
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      connectType = _deviceInfoController.deviceTypeEnum.value;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (connectType == 2) getconnectbySn();
    });
  }

  Future<void> _refreshItems() async {
    // setState(() {
    //   _key = DateTime.now().millisecondsSinceEpoch.toString();
    // });
    // await Future.delayed(const Duration(seconds: 2)); // 模拟网络请求
  }

  _changeTap(val) {
    setState(() {
      activeIndex = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Get.offAllNamed('/home'); //
              },
              icon: const Icon(Icons.chevron_left,
                  color: Colors.black, size: 36)),
          title: const Text(
            'projectDetail.parametersSetting',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: const [],
        ),
        body: RefreshIndicator(
            onRefresh: _refreshItems,
            child: Container(
              width: 720.w,
              height: 1280.h,
              // key: ValueKey("parametersSetting_${_key}"),
              color: const Color.fromRGBO(244, 244, 244, 1),
              padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
              child: Column(
                children: [
                  Expanded(
                      child: tapContariner(
                    activechange: (val) {
                      _changeTap(val);
                    },
                    activeIndex: activeIndex,
                    tap: List.generate(
                        connectType == 2 ? 2 : 1,
                        (index) => connectType == 2
                            ? tr("parametersSetting.tye${index + 1}",
                                namedArgs: {})
                            : tr("parametersSetting.tye2", namedArgs: {})),
                    child: [
                      if (connectType == 2)
                        settingpage(
                          activeTap: 0,
                          info: _info,
                          key: ValueKey("activeTap0_${activeIndex}"),
                        ),
                      if (connectType == 2 || connectType == 1)
                        settingpage(
                            activeTap: 1,
                            info: _info,
                            key: ValueKey("activeTap1_${activeIndex}")),
                    ],
                  )),
                ],
              ),
            )));
  }
}

class settingpage extends StatefulWidget {
  int activeTap;
  var info;
  settingpage({super.key, required this.activeTap, required this.info});

  @override
  State<settingpage> createState() => _settingpageState();
}

/** 遍历显示可修改的表单属性 */
class _settingpageState extends State<settingpage> {
  final deviceInfoController _deviceInfoController = Get.find();

  static const _selfplatform =
      MethodChannel('samples.flutter.dev/functionParamHandler');
  int selectindex = 0;
  List selectList = [];
  String _key = "_key";
  bool haveset = false;
  late Timer _timer;
  var needset = {}; //显示的对象

  var showing = {}; //显示的对象
  var needsend = {}; //下发的对象
  var needsendcom = {}; //下发的对象
  var typeSetting = {};

  final userinfoController _promissioncontroller = Get.find();

  _clearsetting() {
    var setting = Map.from(typeSetting[widget.activeTap]![selectindex]!);
    for (var key in setting.keys) {
      setting[key]["val"] = null;
    }
    setState(() {
      needset = setting;
      needsend = {}; //下发的对象
      needsendcom = {}; //下发的对象
      haveset = false;
      _key = DateTime.now().millisecondsSinceEpoch.toString();
    });
  }

  initNeedset({refresh = false}) {
    bool haspromiss = _promissioncontroller
        .checkLocalPromission("FunctionParamsSetting2", showtoast: false);
    if (typeSetting[widget.activeTap] != null &&
        typeSetting[widget.activeTap]![selectindex]! != null) {
      var setting = Map.from(typeSetting[widget.activeTap]![selectindex]!);
      if (!haspromiss) {
        for (var key in setting.keys) {
          setting[key]["type"] = "text";
        }
      }
      if (widget.activeTap == 0) {
        for (var key in _deviceInfoController.systemEntity.value.keys) {
          if (setting[key] != null) {
            setting[key]["val"] =
                _deviceInfoController.systemEntity.value[key].toString();
          }
        }
      } else {
        print("selectList selectList.isNotEmpty :${selectList.length}");
        try {
          if (selectList.isNotEmpty) {
            if (selectList.length == 1) {
              List _selectItem = _deviceInfoController.indoorEntityList.value
                  .where((element) => selectList.contains(element["address"]))
                  .toList();
              if (_selectItem.isNotEmpty && _selectItem[0] != null) {
                for (var key in _selectItem[0].keys) {
                  if (setting[key] != null) {
                    setting[key]["val"] = _selectItem[0][key].toString();
                  }
                }
              }
            }
          } else {
            for (var key in setting.keys) {
              setting[key]["val"] = null;
            }
          }
        } catch (e) {}
      }
      setState(() {
        needset = setting;
        if (refresh) showing = setting;
        if (refresh) haveset = false;
        _key = DateTime.now().millisecondsSinceEpoch.toString();
      });
    } else {
      setState(() {
        needset = {};
        if (refresh) showing = {};
        if (refresh) haveset = false;
      });
    }
  }

  updataVal(key, val) {
    setState(() {
      needset[key]["val"] = val;
      needsend[key] = val == "true" || val == "false"
          ? val == "true"
          : int.parse(val.toString());
      haveset = true;
    });
  }

  filterOp(key, {showval = false}) {
    try {
      if (needset[key]!['val'] == null || needset[key]!['val'] == "") {
        return "--";
      }
      String _val = needset[key]!['val'].toString();
      if (needsend[key] != null) {
        _val = needsend[key].toString();
      }
      var filter = needset[key]!['op']
          .where((e) =>
              e["value"].toString() == _val || e["value1"].toString() == _val)
          .toList();
      if (filter != null) {
        return filter[0]["label"];
      }
      return showval ? _val : "--";
    } catch (e) {
      return "--";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      typeSetting = Map.from(typeSettingBase);
    });
    _clearsetting();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _deviceInfoController.settingIndoorEntityList.value =
            _deviceInfoController.settingIndoorEntityList.value;
      });
      initNeedset(refresh: true);
    });

    _startRefresh();
  }

  _startRefresh() {
    try {
      if (_timer != null && _timer.isActive) {
        _timer.cancel();
      }
    } catch (e) {}
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      initNeedset();
    });
  }

  @override
  void dispose() {
    super.dispose();
    try {
      if (_timer != null && _timer.isActive) {
        _timer.cancel();
      }
    } catch (e) {}
  }

  selectAll() {
    var base = [];
    if (selectList.length ==
        _deviceInfoController.settingIndoorEntityList.value.length) {
      setState(() {
        selectList = base;
      });
      _clearsetting();
      return;
    }
    for (var element in _deviceInfoController.settingIndoorEntityList.value) {
      base.add(element["address"]);
    }
    setState(() {
      selectList = base;
    });
    _clearsetting();
    initNeedset(refresh: true);
  }

  _selectIndoor(address) {
    if (!selectList.contains(address)) {
      selectList.add(address);
    } else {
      selectList.remove(address);
    }
    setState(() {
      selectList;
    });
    _clearsetting();
    initNeedset(refresh: true);
  }

  _sendSetting() async {
    try {
      bool issend = await divConfirmDialog(context,
          isSubmitButton: true,
          confirmTitle: tr("device.controltDialog.confirmTitle"),
          confirmDescriptionWidget: SingleChildScrollView(
            child: Container(
                width: 560.w,
                height: 80,
                padding: EdgeInsets.fromLTRB(24.w, 24.w, 24.w, 0),
                child: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                        style: normalTextBlack(),
                        text: tr("sendControlMaster.tip")))),
          ));
      if (issend) {
        EasyLoading.show(status: "loading...");
        var sendControl = "";
        if (widget.activeTap == 0) {
          sendControl = await _selfplatform.invokeMethod(
              'sendControlMaster', {"functionParamOutdoorDTO": needsend});
        } else {
          if (selectList.isEmpty) {
            EasyLoading.showToast(tr("select.deviceEmpty"));
            return;
          }
          sendControl = await _selfplatform.invokeMethod('sendControlIndoor', {
            "functionParamIndoorDTO": needsend,
            "addressList":
                selectList.map((e) => int.parse(e.toString())).toList()
          });
        }
        var data = jsonDecode(sendControl);
        print("setting _sendSetting:  ${{
          "functionParamIndoorDTO": needsend,
          "addressList": selectList.map((e) => int.parse(e.toString())).toList()
        }} $data");
        EasyLoading.dismiss();
        if (data["success"]) {
          EasyLoading.showSuccess(tr("refresh.tip"));
          setState(() {
            needsend = {};
            needsendcom = {};
          });
          initNeedset();
        } else {
          EasyLoading.showError(data["errorMsg"]);
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isCN =
        EasyLocalization.of(context)?.currentLocale!.languageCode == 'zh';
    return GetBuilder<deviceInfoController>(
        init: deviceInfoController(),
        builder: (_) => Container(
              color: const Color.fromRGBO(245, 245, 245, 1),
              child: Column(
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        height: 312.h,
                        padding: EdgeInsets.fromLTRB(45.w, 0, 45.w, 0),
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: widget.activeTap == 0
                            ? Row(
                                children: [
                                  SizedBox(
                                      width: 154.w,
                                      child: Center(
                                        child: Opacity(
                                            opacity: _.settingDevice.value
                                                    .isconnected
                                                ? 1
                                                : 0.6, // 设置不透明度为 50%
                                            child: Image.asset(
                                              imageTurn(),
                                              height: 154.w,
                                            )),
                                      )),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.info["sysName"] ?? "--",
                                        style: normalTextBlack(
                                          fw: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        "${_.loacalDevice.value.runningModel ?? "--"}",
                                        style: normalText(
                                            fSize: 12,
                                            fontcolor: _.loacalDevice.value
                                                        .runningModel ==
                                                    tr("close")
                                                ? const Color.fromRGBO(
                                                    140, 140, 140, 1)
                                                : const Color.fromRGBO(
                                                    6, 184, 0, 1)),
                                      ),
                                      Text(
                                        "${tr("deviceSN")}：${_.settingDevice.value.sn.toUpperCase() ?? "--"}",
                                        style: normalText(),
                                      ),
                                    ],
                                  ))
                                ],
                              )
                            : Column(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Color.fromRGBO(
                                                223, 223, 223, 1),
                                            width: 0.5,
                                          ),
                                        )),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          tr("selectAllTip", namedArgs: {
                                            "val":
                                                "${selectList.length}/${_.settingIndoorEntityList.value.length}"
                                          }),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            selectAll();
                                          },
                                          child: Row(
                                            key: ValueKey(
                                                "selectAll_${selectList.length}"),
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 8, 0),
                                                child: const Text("selectAll")
                                                    .tr(),
                                              ),
                                              RoundCheckBox(
                                                isChecked: selectList.length ==
                                                    _.settingIndoorEntityList
                                                        .value.length,
                                                onTap: (selected) {
                                                  selectAll();
                                                },
                                                size: 20,
                                                checkedWidget: const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                                checkedColor: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                border: Border.all(
                                                    // width: 1,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      child: Scrollbar(
                                          // key: ValueKey(
                                          //     "selectList_${selectList.length}"),
                                          isAlwaysShown:
                                              true, // 设置为 true 表示始终显示滚动条，false 则仅在滚动时显示
                                          child: ListView.builder(
                                              itemCount: _
                                                  .settingIndoorEntityList
                                                  .value
                                                  .length,
                                              itemBuilder:
                                                  (context, index) => Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                0.w,
                                                                24.h,
                                                                16.w,
                                                                0),
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                16.w,
                                                                36.h,
                                                                16.w,
                                                                36.h),
                                                        color: const Color
                                                                .fromRGBO(
                                                            190, 190, 190, 0.4),
                                                        width: 720.w,
                                                        height: 160.h,
                                                        child: InkWell(
                                                          onTap: () {
                                                            _selectIndoor(
                                                                _.settingIndoorEntityList
                                                                            .value[
                                                                        index][
                                                                    'address']);
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        0,
                                                                        0,
                                                                        15,
                                                                        0),
                                                                child:
                                                                    Image.asset(
                                                                  _.settingIndoorEntityList.value[index]
                                                                              [
                                                                              'indoorType'] !=
                                                                          null
                                                                      ? 'public/images/V8/${_.settingIndoorEntityList.value[index]['indoorType']}.png'
                                                                      : 'public/images/V8/IduType_99.png',
                                                                  width: 124.w,
                                                                  errorBuilder: (BuildContext
                                                                          context,
                                                                      Object
                                                                          error,
                                                                      StackTrace?
                                                                          stackTrace) {
                                                                    // 图片加载失败时显示默认图片
                                                                    return Tooltip(
                                                                      message: _
                                                                              .settingIndoorEntityList
                                                                              .value[index]['indoorType'] ??
                                                                          "undifined",
                                                                      child: Image
                                                                          .asset(
                                                                        'public/images/V8/IduType_99.png',
                                                                        width:
                                                                            124.w,
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                              Expanded(
                                                                  child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        '${_.settingIndoorEntityList.value[index]['address']}#',
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                      if (_.settingIndoorEntityList.value[index]['runningstatys'] !=
                                                                              null &&
                                                                          _.settingIndoorEntityList.value[index]
                                                                              [
                                                                              'runningstatys'])
                                                                        Text(
                                                                            '·${tr("running")}',
                                                                            style: const TextStyle(
                                                                                color: Color.fromRGBO(6, 184, 0, 1),
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.w600)),
                                                                      if (_.settingIndoorEntityList.value[index]['runningstatys'] !=
                                                                              null &&
                                                                          !_.settingIndoorEntityList.value[index]
                                                                              [
                                                                              'runningstatys'])
                                                                        Text(
                                                                            '·${tr("close")}',
                                                                            style:
                                                                                labelStyle())
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      if (modeMap[_
                                                                              .settingIndoorEntityList
                                                                              .value[index]['mode']] !=
                                                                          null)
                                                                        Padding(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              0,
                                                                              0,
                                                                              8,
                                                                              0),
                                                                          child: runningModelImage(_
                                                                              .settingIndoorEntityList
                                                                              .value[index]['mode']),
                                                                        ),
                                                                      Text('${_.settingIndoorEntityList.value[index]['mode'] ?? "--"}',
                                                                              style: labelStyle())
                                                                          .tr(),
                                                                      const Padding(
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            8,
                                                                            0,
                                                                            8,
                                                                            0),
                                                                        child: Text(
                                                                            '|'),
                                                                      ),
                                                                      Text(
                                                                          tr("tempShow",
                                                                              namedArgs: {
                                                                                "val": "${_.settingIndoorEntityList.value[index]['roomTemp'] != null ? _.settingIndoorEntityList.value[index]['roomTemp'].toStringAsFixed(1) : "--"}"
                                                                              }),
                                                                          style:
                                                                              labelStyle())
                                                                    ],
                                                                  ),
                                                                ],
                                                              )),
                                                              RoundCheckBox(
                                                                isChecked: selectList.contains(_
                                                                        .settingIndoorEntityList
                                                                        .value[index]
                                                                    [
                                                                    'address']),
                                                                onTap:
                                                                    (selected) {
                                                                  _selectIndoor(_
                                                                          .settingIndoorEntityList
                                                                          .value[index]
                                                                      [
                                                                      'address']);
                                                                },
                                                                size: 20,
                                                                checkedWidget:
                                                                    const Icon(
                                                                  Icons.check,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 16,
                                                                ),
                                                                checkedColor: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary,
                                                                border:
                                                                    Border.all(
                                                                        // width: 1,
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .secondary),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ))))
                                ],
                              ),
                      ),
                      Container(
                        color: Colors.white,
                        height: 88.h,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.activeTap == 0 ? 5 : 4,
                            itemBuilder: ((context, index) => widget
                                            .activeTap ==
                                        0 &&
                                    index == 3
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectindex = index;
                                      });

                                      _clearsetting();
                                      initNeedset(refresh: true);
                                    },
                                    child: SizedBox(
                                      width: 720.w / (4),
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: Text(
                                              "parametersSetting.tye${widget.activeTap + 1}.parameters${index + 1}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: isCN ? 14 : 12,
                                                  fontWeight:
                                                      selectindex == index
                                                          ? FontWeight.w800
                                                          : FontWeight.w400,
                                                  color: selectindex == index
                                                      ? Colors.black
                                                      : const Color.fromRGBO(
                                                          13, 13, 13, 0.5)),
                                            ).tr(),
                                          ),
                                          if (selectindex == index)
                                            Positioned(
                                                bottom: 0,
                                                left: (720.w /
                                                            (widget.activeTap ==
                                                                    0
                                                                ? 4.5
                                                                : 4)) /
                                                        2 -
                                                    20.w,
                                                child: Container(
                                                  width: 40.w,
                                                  height: 4,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        25, 98, 255, 1),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(4)),
                                                  ),
                                                ))
                                        ],
                                      ),
                                    ),
                                  ))),
                      ),
                      Expanded(
                          child: SizedBox(
                              width: 720.w,
                              child: ListView.builder(
                                  itemCount: showing.keys.length,
                                  itemBuilder: ((context, index) {
                                    String key = showing.keys.toList()[index];
                                    if (needset[key]["visabel"] == null ||
                                        (needset[key]["visabel"] != null &&
                                            needset[key]["visabel"](
                                                needset, needsend))) {
                                      return Container(
                                        color: Colors.white,
                                        padding: EdgeInsets.fromLTRB(
                                            32.w, 0, 32.w, 0),
                                        child: Row(
                                          children: [
                                            // ignore: prefer_interpolation_to_compose_strings
                                            ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2, // 最大宽度设为屏幕一半
                                                ),
                                                child: Text((widget.activeTap ==
                                                                0
                                                            ? "SystemEntity."
                                                            : "IndoorEntity.") +
                                                        key)
                                                    .tr()),
                                            Expanded(
                                                key: ValueKey("needset_$_key"),
                                                child:
                                                    needset[key]!['type'] ==
                                                            "input"
                                                        ? TextFieldFocusExample(
                                                            val:
                                                                "${(needsend[key] ?? needset[key]!['val']) ?? "--"}",
                                                            focusChaneg: (val) {
                                                              if (val) {
                                                                try {
                                                                  if (_timer !=
                                                                          null &&
                                                                      _timer
                                                                          .isActive) {
                                                                    _timer
                                                                        .cancel();
                                                                  }
                                                                } catch (e) {}
                                                              } else {
                                                                _startRefresh();
                                                              }
                                                            },
                                                            valChaneg:
                                                                (value) => {
                                                              updataVal(
                                                                  key,
                                                                  value
                                                                      .toString())
                                                            },
                                                          )
                                                        : needset[key]![
                                                                    'type'] ==
                                                                "text"
                                                            ? InkWell(
                                                                onTap: () {},
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          10),
                                                                  child: Text(
                                                                    filterOp(
                                                                        key),
                                                                    //  "${needsend[key] ?? needset[key]!['val'].toString()}",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style:
                                                                        normalText(),
                                                                  ),
                                                                ),
                                                              )
                                                            : InkWell(
                                                                onTap:
                                                                    () async {
                                                                  Future<sheetBack?>
                                                                      selectedIndex =
                                                                      await showCustomModalBottomSheet(
                                                                          isMultiple:
                                                                              false,
                                                                          context,
                                                                          [
                                                                            ...needset[key]["op"]
                                                                          ],
                                                                          // ignore: unrelated_type_equality_checks
                                                                          baseValue: [
                                                                            needset[key]!['val'].toString()
                                                                          ],
                                                                          titleName:
                                                                              tr((widget.activeTap == 0 ? "SystemEntity." : "IndoorEntity.") + key));
                                                                  selectedIndex.then(
                                                                      (value) =>
                                                                          {
                                                                            if (value !=
                                                                                    null &&
                                                                                // ignore: unrelated_type_equality_checks
                                                                                value.baseValue![0] !=
                                                                                    -1)
                                                                              {
                                                                                updataVal(key, value.baseValue![0].toString())
                                                                              }
                                                                          });
                                                                },
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          10),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          filterOp(
                                                                              key),
                                                                          textAlign:
                                                                              TextAlign.end,
                                                                          maxLines:
                                                                              2,
                                                                          style:
                                                                              normalText(),
                                                                        ),
                                                                      ),
                                                                      const Padding(
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            0,
                                                                            5,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .arrow_drop_down,
                                                                          color: Color.fromRGBO(
                                                                              140,
                                                                              140,
                                                                              140,
                                                                              1),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ))
                                          ],
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  }))))
                    ],
                  )),
                  Container(
                      height: 57,
                      padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                      child: Center(
                          child: submitButton(
                              isActive: needsend.isNotEmpty,
                              label: tr('parametersSetting.btn'),
                              onClick: () async {
                                if (needsend.isNotEmpty) {
                                  _sendSetting();
                                } else {
                                  EasyLoading.showError(
                                      tr("sendControlMaster.Empty"));
                                }
                              })))
                ],
              ),
            ));
  }
}

class TextFieldFocusExample extends StatefulWidget {
  String val;
  var limit;
  Function focusChaneg;
  Function valChaneg;
  TextFieldFocusExample({
    super.key,
    required this.val,
    this.limit,
    required this.focusChaneg,
    required this.valChaneg,
  });
  @override
  _TextFieldFocusExampleState createState() => _TextFieldFocusExampleState();
}

/** 自定义输入框 */
class _TextFieldFocusExampleState extends State<TextFieldFocusExample> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  double step = 0.00;
  double min = 0.00;
  double max = 0.00;
  bool settinglimit = false;

  @override
  void initState() {
    super.initState();
    if (widget.limit != null) {
      try {
        step = widget.limit["step"] != null
            ? double.parse(widget.limit["step"])
            : 1;
        min =
            widget.limit["min"] != null ? double.parse(widget.limit["min"]) : 0;
        max = widget.limit["max"] != null
            ? double.parse(widget.limit["max"])
            : 100;
        settinglimit = true;
      } catch (e) {
        settinglimit = false;
      }
      setState(() {
        settinglimit;
      });
    }
    _controller.text = widget.val;
    // 当TextFormField获取焦点时，将光标移动到最后
    _focusNode.addListener(() {
      widget.focusChaneg(_focusNode.hasFocus);
      if (_focusNode.hasFocus) {
        // 将光标位置设置到文本的末尾
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
      }
    });
  }

  // 用于处理用户输入，限制步长、最小值、最大值
  void _onChanged(String value) {
    double currentValue = double.tryParse(value) ?? min;

    // 限制最大值和最小值
    if (currentValue < min) {
      currentValue = min;
    } else if (currentValue > max) {
      currentValue = max;
    }

    // 保持步长限制
    currentValue = (currentValue / step).roundToDouble() * step;

    // 更新输入框的内容
    _controller.text = currentValue.toStringAsFixed(2);
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));
    widget.valChaneg(currentValue.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (settinglimit)
          IconButton(
            onPressed: () {
              double currentValue = double.tryParse(_controller.text) ?? min;
              _onChanged("${currentValue - step}");
            },
            icon: const Icon(Icons.remove),
          ),
        SizedBox(
            width: settinglimit ? 60 : 80,
            child: TextFormField(
                controller: _controller,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                style: normalText(), // 设置字体大小为 14
                textAlign: settinglimit
                    ? TextAlign.center
                    : TextAlign.right, // 或者使用 TextAlign.end
                maxLines: 1, // 设置为 null 或大于 1 的数字以支持多行输入
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: tr("self.input")),
                inputFormatters: [
                  // 限制只允许输入数字和小数点
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+(\.\d{0,2})?$')),
                ],
                onChanged: (value) {
                  if (settinglimit) {
                    _onChanged(value);
                  } else {
                    widget.valChaneg(value);
                  }
                })),
        if (settinglimit)
          IconButton(
            onPressed: () {
              double currentValue = double.tryParse(_controller.text) ?? min;
              _onChanged("${currentValue + step}");
            },
            icon: const Icon(Icons.add),
          ),
      ],
    );
  }
}
