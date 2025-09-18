import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/bottomSelectSheet.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/parametersSetting/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../userinfo.dart';

class cloundParametersSetting extends StatefulWidget {
  String sn;
  cloundParametersSetting({super.key, required this.sn});

  @override
  State<cloundParametersSetting> createState() =>
      _cloundParametersSettingState();
}

class _cloundParametersSettingState extends State<cloundParametersSetting> {
  final userinfoController _promissioncontroller = Get.find();
  bool canedit = true;
  bool isSettingVal = false;
  _setisSettingVal(val) {
    setState(() {
      isSettingVal = val;
    });
  }

  String nid = "";
  String sn = "";
  static const _selfplatform =
      MethodChannel('samples.flutter.dev/cloundFunctionParamsSetting');
  String lanage = "cn";
  String _key = "_key";
  late Timer _timer;
  int activeTap = 0;
  int selectindex = 0;
  var selectindexOp = {}; //下发的对象
  var needsend = {}; //下发的对象
  var needsendcom = {}; //下发的对象
  var showing = {}; //显示的对象
  var needset = {}; //显示的对象
  var typeSetting = {};
  var needtr = {}; //下发的对象
  /** 0:系统 外机   1:室内机 */
  var _cloundSettingBase = {
    0: {},
    1: {},
  };
  realtimeStatus() async {
    typeSetting = Map.from(_cloundSettingBase);
    var setting = Map.from(typeSetting[activeTap]![selectindex]!);
    // for (var element in historydata['data']) {
    //   print(element);
    // }
    setState(() {
      setting;
      typeSetting;
      needsend = {};
    });

    initNeedset(refresh: true);
    _startRefresh();
  }

  _settypeSettingBase(type, index, data) {
    _cloundSettingBase[type]![index] = {};
    for (var element in data) {
      needtr[element['code']] = element['title'];
      _cloundSettingBase[type]![index][element['code']] = {
        "type": element['type'] == "enum" ? "select" : "input",
        "val": "",
        "limit": element['limit'].toString() != "{}" ? element['limit'] : null,
        "op": element['type'] == "enum"
            ? element['values'].map((item) {
                return {
                  'label': item['desc']['cn'], // 使用 'cn' 作为 label
                  'name': item['desc']['cn'], // 使用 'cn' 作为 name
                  'value1': item['val'], // 使用 'val' 作为 value1
                  'value': item['val'], // 使用 'val' 作为 value
                };
              }).toList()
            : []
      };
    }
  }

  init() async {
    EasyLoading.show(status: 'loading...');
    // lanage = EasyLocalization.of(context)?.currentLocale!.languageCode ?? "cn";
    try {
      var listDevice4DeviceType = await _selfplatform
          .invokeMethod('getMideaAppV2Handler.deviceRelationship', {"sn": sn});
      var listDevice4DeviceTypedata = jsonDecode(listDevice4DeviceType);
      if (!listDevice4DeviceTypedata['success']) {
        EasyLoading.showError(listDevice4DeviceTypedata['errorMsg']);
        return;
      }

      var data = listDevice4DeviceTypedata['data'];
      const config = {
        "0": ['01', '02'],
        "1": ['03'],
        "2": ['04'],
        "3": ['05'],
        "4": ['15', '16']
      };
      const vrf_indoorconfig = {
        "0": ['02'],
        "1": ['03'],
        "2": ['04'],
        "3": ['05'],
      };
      for (var _cloundSettingBase in _cloundSettingBase.keys) {
        if (_cloundSettingBase == 0) {
          for (var keys in config.keys) {
            var send = {
              "deviceType": _cloundSettingBase == 0 ? "vrf" : "vrf_indoor",
              "mideaTongTabs": config[keys]
            };
            var featuresSearch = await _selfplatform.invokeMethod(
                'getMideaAppHandler.featuresSearch', send);
            var featuresSearchdate = jsonDecode(featuresSearch);
            print("------------------- ${{
              "deviceType": _cloundSettingBase == 0 ? "vrf" : "vrf_indoor",
              "mideaTongTabs": config[keys]
            }} $keys    ${config[keys]} --------------------------------");
            print(featuresSearchdate);
            _settypeSettingBase(_cloundSettingBase, int.parse(keys),
                featuresSearchdate['data']);
          }
        } else {
          for (var keys in vrf_indoorconfig.keys) {
            var send = {
              "deviceType": _cloundSettingBase == 0 ? "vrf" : "vrf_indoor",
              "mideaTongTabs": vrf_indoorconfig[keys]
            };
            var featuresSearch = await _selfplatform.invokeMethod(
                'getMideaAppHandler.featuresSearch', send);
            var featuresSearchdate = jsonDecode(featuresSearch);
            _settypeSettingBase(_cloundSettingBase, int.parse(keys),
                featuresSearchdate['data']);
          }
        }
      }

      // realtimeStatus();

      if (data["vrfOutdoor"][0] != null) {
        nid = data["vrfOutdoor"][0]["nid"];
        activeTap = 0;
        selectindexOp[0] = [];
      } else if (data["vrfIndoor"][0] != null) {
        nid = data["vrfOutdoor"][0]["nid"];
        activeTap = 1;
        selectindexOp[1] = [];
      }
      if (data["vrfOutdoor"] != null && data["vrfOutdoor"].toString() != "[]") {
        selectindexOp[0] = data["vrfOutdoor"].map((item) {
          return {
            "data": item,
            "label": item["deviceName"],
            "name": item["deviceName"],
            "value": item["nid"]
          };
        }).toList();
      }

      if (data["vrfIndoor"] != null && data["vrfIndoor"].toString() != "[]") {
        selectindexOp[1] = data["vrfIndoor"].map((item) {
          return {
            "data": item,
            "label": item["deviceName"],
            "name": item["deviceName"],
            "value": item["nid"]
          };
        }).toList();
      }

      setState(() {
        activeTap;
        nid;
        selectindexOp;
      });

      EasyLoading.dismiss();
      if (!listDevice4DeviceTypedata['success']) {
        EasyLoading.showError(listDevice4DeviceTypedata['errorMsg']);
      } else {
        realtimeStatus();
      }
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      sn = widget.sn;
      canedit = _promissioncontroller
          .checkCloundPromission("FunctionParamsSetting", showtoast: false);
    });
    init();
  }

  /** 处理设备类型选择 */
  _deviceTypeNameChange(val) {
    activeTap = int.parse(val);
    nid = "";
    sn = "";
    selectindex = 0;
    if (selectindexOp[activeTap] != null) {
      var data = selectindexOp[activeTap][0]["data"];
      nid = data["nid"];
      sn = data["sn"];
    }
    setState(() {
      activeTap;
      nid;
      sn;
      selectindex;
    });
    realtimeStatus();
  }

  /** 处理设备选择 */
  _deviceSnChange(val) {
    nid = val;
    setState(() {
      nid;
    });
    realtimeStatus();
  }

  updataVal(key, val) {
    setState(() {
      needset[key]["val"] = val;
      needsend[key] = val == "true" || val == "false"
          ? val == "true"
          : int.tryParse(val.toString()) ?? double.tryParse(val.toString());
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

  Future<void> initNeedset({refresh = false}) async {
    if (isSettingVal) {
      return;
    }
    if (typeSetting[activeTap] != null &&
        typeSetting[activeTap]![selectindex]! != null) {
      var setting = Map.from(typeSetting[activeTap]![selectindex]!);

      if (refresh) EasyLoading.show(status: 'loading...');
      if (!refresh) {
        SnackBar(
          content: Text(tr("getMideaAppHandler")),
          duration: const Duration(seconds: 2),
        );
      }
      try {
        var historyback = await _selfplatform
            .invokeMethod('getMideaAppHandler.realtimeStatus', {"nid": nid});

        var historydata = jsonDecode(historyback);
        if (refresh) EasyLoading.dismiss();
        if (!historydata['success']) {
          EasyLoading.showError(historydata['errorMsg']);
        }
        var _nodeAndVal = {};
        for (var element in historydata["data"]) {
          String key = element['property'];
          String val = element['propertyValue'].toString();
          _nodeAndVal[key] = val;
          if (setting[key] != null) {
            setting[key]["val"] = val == "--" ? "--" : int.parse(val);
          }
        }
      } catch (e) {
        print(e);
        EasyLoading.dismiss();
      }
      setState(() {
        needset = setting;
        if (refresh) showing = setting;
        _key = DateTime.now().millisecondsSinceEpoch.toString();
      });
    }
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
        var _needsend = [];
        for (var key in needsend.keys) {
          _needsend.add({
            "name": "$key",
            "value": "${needsend[key]}",
          });
        }
        EasyLoading.show(status: "loading...");
        var sendControl = await _selfplatform.invokeMethod(
            'getMideaAppHandler.control', {"nid": nid, "needsend": _needsend});
        var data = jsonDecode(sendControl);
        print("getMideaAppHandler.control --- ${data}");
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
      EasyLoading.dismiss();
      if (_timer != null && _timer.isActive) {
        _timer.cancel();
      }
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
          title: const Text(
            'projectDetail.parametersSetting',
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
          child: Column(
            children: [
              Column(
                children: [
                  selectBox(
                    val: "$activeTap",
                    title: "errorAnalysis.deviceTypeName",
                    op: [
                      {
                        "label": tr("outdoor"),
                        "name": tr("outdoor"),
                        "value": 0
                      },
                      {"label": tr("indoor"), "name": tr("indoor"), "value": 1}
                    ],
                    onchange: (val) {
                      _deviceTypeNameChange(val);
                    },
                  ),
                  selectBox(
                    val: nid,
                    title: "clound.device",
                    astitle: "${tr("errorAnalysis.deviceSn")} : $sn",
                    op: selectindexOp[activeTap] ?? [],
                    onchange: (val) {
                      _deviceSnChange(val);
                    },
                  )
                ],
              ),
              Container(
                color: Colors.white,
                margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                height: 88.h,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: activeTap == 0 ? 5 : 4,
                    itemBuilder: ((context, index) => activeTap == 0 &&
                            index == 3
                        ? Container()
                        : InkWell(
                            onTap: () {
                              setState(() {
                                selectindex = index;
                              });
                              initNeedset(refresh: true);
                            },
                            child: SizedBox(
                              width: 720.w / 4,
                              child: Stack(
                                children: [
                                  Center(
                                    child: Text(
                                      "parametersSetting.tye${activeTap + 1}.parameters${index + 1}",
                                      style: TextStyle(
                                          fontWeight: selectindex == index
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
                                                    (activeTap == 0
                                                        ? 4.5
                                                        : 4)) /
                                                2 -
                                            20.w,
                                        child: Container(
                                          width: 40.w,
                                          height: 4,
                                          decoration: const BoxDecoration(
                                            color:
                                                Color.fromRGBO(25, 98, 255, 1),
                                            borderRadius: BorderRadius.all(
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
                      child: RefreshIndicator(
                          onRefresh: initNeedset,
                          child: ListView.builder(
                              itemCount: showing.keys.length,
                              itemBuilder: ((context, index) {
                                String key = showing.keys.toList()[index];
                                if (needset[key]["visabel"] == null ||
                                    (needset[key]["visabel"] != null &&
                                        needset[key]
                                            ["visabel"](needset, needsend))) {
                                  return Container(
                                    color: Colors.white,
                                    padding:
                                        EdgeInsets.fromLTRB(32.w, 0, 32.w, 0),
                                    child: Row(
                                      children: [
                                        // ignore: prefer_interpolation_to_compose_strings
                                        SizedBox(
                                          width: (720.w - 64.w) / 2,
                                          child: Text(needtr[key]["cn"]),
                                        ),
                                        Expanded(
                                            key: ValueKey("needset_$_key"),
                                            child: needset[key]!['type'] ==
                                                    "input"
                                                ? canedit
                                                    ? TextFieldFocusExample(
                                                        val:
                                                            "${needsend[key] ?? needset[key]!['val']}",
                                                        limit: showing[key]
                                                            ["limit"],
                                                        focusChaneg: (val) {
                                                          if (val) {
                                                            try {
                                                              if (_timer !=
                                                                      null &&
                                                                  _timer
                                                                      .isActive) {
                                                                _timer.cancel();
                                                              }
                                                            } catch (e) {}
                                                          } else {
                                                            _startRefresh();
                                                          }
                                                        },
                                                        valChaneg: (value) => {
                                                          updataVal(key,
                                                              value.toString())
                                                        },
                                                      )
                                                    : InkWell(
                                                        onTap: () {},
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 10),
                                                          child: Text(
                                                            filterOp(key,
                                                                showval: true),
                                                            //  "${needsend[key] ?? needset[key]!['val'].toString()}",
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: normalText(),
                                                          ),
                                                        ),
                                                      )
                                                : needset[key]!['type'] ==
                                                        "text"
                                                    ? InkWell(
                                                        onTap: () {},
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 10),
                                                          child: Text(
                                                            filterOp(key),
                                                            //  "${needsend[key] ?? needset[key]!['val'].toString()}",
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: normalText(),
                                                          ),
                                                        ),
                                                      )
                                                    : InkWell(
                                                        onTap: () async {
                                                          if (!canedit) {
                                                            EasyLoading
                                                                .showError(tr(
                                                                    "withoutpromission"));
                                                            return;
                                                          }
                                                          _setisSettingVal(
                                                              true);
                                                          Future<sheetBack?>
                                                              selectedIndex =
                                                              await showCustomModalBottomSheet(
                                                                  isMultiple:
                                                                      false,
                                                                  context,
                                                                  [
                                                                    ...needset[
                                                                            key]
                                                                        ["op"]
                                                                  ],
                                                                  // ignore: unrelated_type_equality_checks
                                                                  baseValue: [
                                                                    needset[key]![
                                                                            'val']
                                                                        .toString()
                                                                  ],
                                                                  titleName:
                                                                      needtr[key]
                                                                          [
                                                                          "cn"]);
                                                          selectedIndex
                                                              .then((value) => {
                                                                    if (value !=
                                                                            null &&
                                                                        // ignore: unrelated_type_equality_checks
                                                                        value.baseValue![0] !=
                                                                            -1)
                                                                      {
                                                                        updataVal(
                                                                            key,
                                                                            value.baseValue![0].toString()),
                                                                        _setisSettingVal(
                                                                            false)
                                                                      }
                                                                  });
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 10),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                filterOp(key),
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                style:
                                                                    normalText(),
                                                              ),
                                                              const Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            5,
                                                                            0,
                                                                            0),
                                                                child: Icon(
                                                                  Icons
                                                                      .arrow_drop_down,
                                                                  color: Color
                                                                      .fromRGBO(
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
                              }))))),
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
                        EasyLoading.showError(tr("sendControlMaster.Empty"));
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class selectBox extends StatefulWidget {
  String val;
  String title;
  String? astitle;
  List op;
  Function onchange;
  selectBox(
      {super.key,
      this.astitle,
      required this.op,
      required this.title,
      required this.val,
      required this.onchange});

  @override
  State<selectBox> createState() => _selectBoxState();
}

class _selectBoxState extends State<selectBox> {
  filterOp({showval = false}) {
    try {
      String _val = widget.val;
      var filter =
          widget.op.where((e) => e["value"].toString() == _val).toList();
      if (filter != null) {
        return filter[0]["label"];
      }
      return showval ? _val : "--";
    } catch (e) {
      return "--";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
          onTap: () async {
            Future<sheetBack?> selectedIndex = await showCustomModalBottomSheet(
                isMultiple: false,
                context,
                [...widget.op],
                // ignore: unrelated_type_equality_checks
                baseValue: [widget.val],
                titleName: tr(widget.title));
            selectedIndex.then((value) => {
                  if (value != null &&
                      value.baseValue![0] != -1 &&
                      widget.val.toString() != value.baseValue![0].toString())
                    {widget.onchange(value.baseValue![0].toString())}
                });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: Padding(
              padding: EdgeInsets.fromLTRB(0.w, 0, 0.w, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: const EdgeInsets.all(16),
                      constraints: const BoxConstraints(),
                      child: Text(
                        widget.astitle != null
                            ? tr(widget.astitle!)
                            : tr(widget.title),
                        textAlign: TextAlign.left,
                        style: normalText(fSize: 14),
                      ).tr()),
                  Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            filterOp(),
                            style: normalTextBlack(lineheight: 1),
                          ),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: Color.fromRGBO(0, 0, 0, 1),
                          )
                        ],
                      ))
                ],
              ),
            ),
          )),
    );
  }
}
