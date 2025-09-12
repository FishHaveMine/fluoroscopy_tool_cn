import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/snInput.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/cloud/projectManage/ibutler/publicFunction.dart';
import 'package:fluoroscopy_tool/view/cloud/publicFunction.dart';
import 'package:fluoroscopy_tool/view/local/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class ibutleractivePage extends StatefulWidget {
  ibutleractivePage({super.key});

  @override
  State<ibutleractivePage> createState() => _ibutleractivePageState();
}

class _ibutleractivePageState extends State<ibutleractivePage> {
  String sn = "";
  String datakey = "";
  String _dateSelectText = "";
  List data = [];
  List alldata = [];
  List select = [];
  List selectInTest = [];
  Map testEnd = {};
  String minEndTime = "";
  TimeOfDay? _startTime;
  DateTime? selectedDate;
  bool enableselecttime = false;

  bool injudgeSigned = false;

  String earliestEffectiveTime = "";
  List injudgeSigneddata = [];
  var contractStatus = {
    "0": {
      "id": 113889,
      "parentId": 113888,
      "hasChildren": false,
      "value": "0",
      "label": "未试用",
      "code": "contractStatus",
      "appCode": null,
      "tenantId": null,
      "i18nValue": null
    },
    "1": {
      "id": 113890,
      "parentId": 113888,
      "hasChildren": false,
      "value": "1",
      "label": "试用中",
      "code": "contractStatus",
      "appCode": null,
      "tenantId": null,
      "i18nValue": null
    },
    "2": {
      "id": 113891,
      "parentId": 113888,
      "hasChildren": false,
      "value": "2",
      "label": "试用已过期",
      "code": "contractStatus",
      "appCode": null,
      "tenantId": null,
      "i18nValue": null
    },
    "3": {
      "id": 113892,
      "parentId": 113888,
      "hasChildren": false,
      "value": "3",
      "label": "合约履行中",
      "code": "contractStatus",
      "appCode": null,
      "tenantId": null,
      "i18nValue": null
    },
    "4": {
      "id": 113893,
      "parentId": 113888,
      "hasChildren": false,
      "value": "4",
      "label": "合约已过期",
      "code": "contractStatus",
      "appCode": null,
      "tenantId": null,
      "i18nValue": null
    }
  };

  static const platform = MethodChannel('samples.flutter.dev/ibutler');
  final cloudProjectController _selectController = Get.find();

  final activateContractController _childController = Get.find();

  _init() async {
    EasyLoading.show(status: 'loading...');
    try {
      setState(() {
        data = [];
        alldata = [];
        select = [];
        _startTime = null;
      });
      var project = _selectController.selectProject.value["project"];
      var init_history =
          await platform.invokeMethod('getAppChargeHandler.pageDeviceList', {
        "projectCode": project["code"].toString(),
      });

      var indoorHistorydata = jsonDecode(init_history);
      for (var element in indoorHistorydata['data']) {
        Map<dynamic, dynamic> mergedMap = {
          ...element,
          ...element["outDoorInfoDTOS"][0]
        };
        // 添加 map1 的内容
        mergedMap.addAll(element);
        // 添加 map2 的内容
        mergedMap.addAll(element["outDoorInfoDTOS"][0]);
        data.add(mergedMap);
      }

      alldata = data;
      setState(() {
        data;
        datakey = DateTime.now().millisecondsSinceEpoch.toString();
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  _filterdata() {
    List fda = jsonDecode(jsonEncode(alldata));
    if (sn == "") {
      data = fda;
    } else {
      data = fda
          .where((item) =>
              item["deviceSn"].toLowerCase().contains(sn.toLowerCase()))
          .toList();
    }
    setState(() {
      data;
    });
  }

  _addTrial() async {
    EasyLoading.show(status: 'loading...');
    try {
      List fda = jsonDecode(jsonEncode(alldata));

      var judgeSignedStatusback =
          await platform.invokeMethod('getAppChargeHandler.judgeSignedStatus', {
        "sysIdList": select,
        "contractStartTime": selectedDate!.millisecondsSinceEpoch,
      });
      var judgeSignedStatusbackdata = jsonDecode(judgeSignedStatusback);
      print(judgeSignedStatusbackdata);
      EasyLoading.dismiss();
      if (!judgeSignedStatusbackdata['success']) {
        EasyLoading.showError(judgeSignedStatusbackdata['errorMsg']);
      } else {
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(
            judgeSignedStatusbackdata["data"]['earliestEffectiveTime']
                .toString()));

        var _earliestEffectiveTime = DateFormat('yyyy-MM-dd').format(dateTime);
        setState(() {
          earliestEffectiveTime = _earliestEffectiveTime;
          injudgeSigned = true;
          injudgeSigneddata = fda
              .where((item) => select.contains(item["deviceNid"]))
              .map((e) => jsonDecode(jsonEncode(e)))
              .toList();
        });
      }
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
      EasyLoading.showError("${tr("ibutleractive.showError")}$e");
    }
  }

  toactive() async {
    EasyLoading.show(status: 'loading...');
    try {
      var project = _selectController.selectProject.value["project"];
      List fda = jsonDecode(jsonEncode(alldata));

      var send = {
        ...jsonDecode(jsonEncode(_childController.card)),
        "orderNo": _childController.orderNo.value,
        "projectCode": project["code"].toString(),
        "projectName": project["name"].toString(),
        "address": project["address"].toString(),
        "contractStartTime": selectedDate!.millisecondsSinceEpoch,
        "deviceList": fda
            .where((item) => select.contains(item["deviceNid"]))
            .map((e) => jsonDecode(jsonEncode(e)))
            .toList(),
      };
      var init_history = await platform.invokeMethod(
          'getAppChargeHandler.activateContract', send);

      var historydata = jsonDecode(init_history);
      EasyLoading.dismiss();
      if (!historydata['success']) {
        EasyLoading.showError(historydata['errorMsg']);
      } else {
        EasyLoading.showSuccess(tr("ibutleractive.showSuccess"));
        Future.delayed(const Duration(seconds: 3), () {
          Get.back();
        });
      }
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
      EasyLoading.showError("${tr("ibutleractive.showError")}$e");
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  String formatTimestamp(var timestamp) {
    if (timestamp == "{}") {
      return "--";
    } else {
      return timestamp;
    }
  }

  _selectAll() {
    List fda = jsonDecode(jsonEncode(alldata));
    List setList = [];
    for (var element in fda) {
      if (element["managerStatus"].toString() != "3" &&
          element["canTrial"].toString() == "true") {
        setList.add(element["deviceNid"]);

        var _key = element["deviceNid"];
        var _endTime = element["trialEndTime"].toString() == "{}"
            ? 0
            : DateTime.parse(element["trialEndTime"].toString())
                .millisecondsSinceEpoch;
        _countimelimit(_key, _endTime);
      }
    }
    _setenableselecttime();
    setState(() {
      select = setList;
      selectInTest;
      testEnd;
      minEndTime;
    });
  }

  _setenableselecttime() {
    List fda = jsonDecode(jsonEncode(alldata))
        .where((item) => select.contains(item["deviceNid"]))
        .map((e) => jsonDecode(jsonEncode(e)))
        .toList();
    enableselecttime = fda.any(
        (element) => !["1", "3"].contains(element["managerStatus"].toString()));
    if (enableselecttime) {
      setState(() {
        enableselecttime;
      });
    } else {
      setState(() {
        enableselecttime;
        selectedDate = minEndTime == "" ? null : DateTime.parse(minEndTime);
      });
    }
  }

  _countimelimit(_key, _endTime) {
    if (select.length > _childController.card["remainingNum"]) {
      select.remove(_key);
      setState(() {
        select;
      });
      return;
    }

    if (selectInTest.contains(_key)) {
      selectInTest.remove(_key);
      testEnd[_key] = 0;
    } else {
      selectInTest.add(_key);
      testEnd[_key] = _endTime;
    }

    int min = 0;
    if (selectInTest.isNotEmpty) {
      for (var element in testEnd.keys) {
        int dateTime = testEnd[element];
        min = min < dateTime ? dateTime : min;
      }
      if (min != 0) {
        // 将时间戳转换为 DateTime 对象
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(min);

        minEndTime = DateFormat('yyyy-MM-dd').format(dateTime);
      } else {
        minEndTime = "";
      }
    } else {
      minEndTime = "";
    }
    if (minEndTime != "") {
      setState(() {
        selectedDate = null;
      });
    }
  }

  void _selectIndex(data) {
    var _key = data["deviceNid"];
    var _endTime = data["trialEndTime"].toString() == "{}"
        ? 0
        : DateTime.parse(data["trialEndTime"].toString())
            .millisecondsSinceEpoch;

    if (select.contains(_key)) {
      select.remove(_key);
    } else {
      select.add(_key);
    }
    _countimelimit(_key, _endTime);
    _setenableselecttime();
    setState(() {
      select;
      selectInTest;
      testEnd;
      minEndTime;
    });
  }

  void showDateSelect(context) async {
    DateTime now = DateTime.now();
    // 获取两年后的时间
    DateTime twoYearsLater = now.add(const Duration(days: 365 * 2));
    print(minEndTime);
    DateTime dateTime =
        minEndTime == "" ? twoYearsLater : DateTime.parse(minEndTime);

    DateTime? startt;
    startt = await DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: now,
        maxTime: dateTime,
        currentTime: DateTime.now(),
        locale: LocaleType.zh);

    if (startt != null) {
      setState(() {
        selectedDate = startt;
      });
    }

    // DateTime dateTime =
    //     minEndTime == "" ? DateTime(2101) : DateTime.parse(minEndTime);
    // final DateTime? picked = await showDatePicker(
    //   context: context,
    //   initialDate: selectedDate ?? DateTime.now(),
    //   firstDate: DateTime(2000),
    //   lastDate: dateTime,
    // );
    // if (picked != null && picked != selectedDate) {
    //   setState(() {
    //     selectedDate = picked;
    //   });
    // }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedStartTime = await showTimePicker(
      helpText: tr("starttime.helptext"),
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );

    if (pickedStartTime != null) {
      setState(() {
        _startTime = pickedStartTime;
      });
    }
  }

  showTimeTip() async {
    bool issend = await divConfirmOnlyDialog(context,
        isSubmitButton: true,
        confirmTitle: tr("ibutleractive.tip1_title"),
        confirmDescriptionWidget: SizedBox(
          width: 560.w,
          height: 140,
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'ibutleractive.tip1',
                  style: normalText(),
                ).tr(),
              ],
            ),
          )),
        ));
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
            'ibutleractive.title',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: const [],
        ),
        body: !injudgeSigned
            ? Container(
                width: 720.w,
                height: 1280.h,
                color: const Color.fromRGBO(244, 244, 244, 1),
                padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(0),
                            height: 44,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(42),
                                color: Colors.white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 30,
                                ),
                                Expanded(
                                  child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: snInput(
                                        hintText:
                                            tr("ibutleraddtest.searchhintText"),
                                        isSamll: true,
                                        lengthLimit: false,
                                        onfocus: () {
                                          setState(() {});
                                        },
                                        valBack: (back) {
                                          setState(() {
                                            sn = back;
                                          });
                                        },
                                      )),
                                ),
                                InkWell(
                                  onTap: () {
                                    _filterdata();
                                  },
                                  child: Container(
                                    width: 75,
                                    height: 36,
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(49),
                                        color: const Color.fromRGBO(
                                            25, 98, 255, 1)),
                                    child: Center(
                                      child: const Text(
                                        'search',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ).tr(),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                            child: Row(
                              children: [
                                Text(
                                  tr("ibutleractive.cardType", namedArgs: {
                                    "val": tr(
                                        "cardType${_childController.card["cardType"]}")
                                  }),
                                  style: normalTextBlack(),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text("|", style: normalTextBlack()),
                                ),
                                Text(
                                    tr("ibutleractive.buyNum", namedArgs: {
                                      "val":
                                          "${_childController.card["buyNum"] - _childController.card["remainingNum"]}"
                                    }),
                                    style: normalTextBlack()),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text("|", style: normalTextBlack()),
                                ),
                                Text(
                                    tr("ibutleractive.remainingNum",
                                        namedArgs: {
                                          "val":
                                              "${_childController.card["remainingNum"]}"
                                        }),
                                    style: normalTextBlack())
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "deviceselecttip",
                                      style: normalTextBlack(fSize: 16),
                                    ).tr(),
                                    Text(
                                      "${select.length}",
                                      style: normalTextBlack(
                                          fSize: 16,
                                          fontcolor: const Color.fromRGBO(
                                              25, 98, 255, 1)),
                                    ),
                                    Text("/${data.length})",
                                        style: normalTextBlack(fSize: 16))
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    if (_childController.card["remainingNum"] ==
                                        0) {
                                      return;
                                    }
                                    _selectAll();
                                  },
                                  child: Text(
                                    "selectAll",
                                    style: normalTextBlack(
                                        fSize: 16,
                                        fontcolor: const Color.fromRGBO(
                                            25, 98, 255, 1)),
                                  ).tr(),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: ((context, index) => InkWell(
                                  onTap: () {
                                    if (_childController.card["remainingNum"] ==
                                        0) {
                                      return;
                                    }
                                    _selectIndex(data[index]);
                                  },
                                  child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                    padding: const EdgeInsets.all(16),
                                    decoration: cardStyle(context),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            RoundCheckBox(
                                              isChecked: select.contains(
                                                  data[index]["deviceNid"]),
                                              onTap: null,
                                              size: 16,
                                              checkedWidget: const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                              disabledColor: select.contains(
                                                      data[index]["deviceNid"])
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .secondary
                                                  : Colors.white,
                                              checkedColor: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              border: Border.all(
                                                  // width: 1,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Text("${data[index]["protocol"] ?? "--"}",
                                                    style: normalTextBlack(
                                                        fSize: 18,
                                                        lineheight: 1))
                                                .tr()
                                          ],
                                        ),
                                        const Divider(),
                                        infobox(
                                          label: tr("ibutleraddtest.type1"),
                                          val: tr(
                                              "devStableTag${data[index]["devStableTag"] ?? ""}"),
                                        ),
                                        infobox(
                                          label: tr("ibutleraddtest.type2"),
                                          val:
                                              "${data[index]["deviceSn"] ?? "--"}",
                                        ),
                                        infobox(
                                          label: tr("ibutleraddtest.type3"),
                                          val:
                                              "${data[index]["managerStatus"].toString() != "{}" ? contractStatus[data[index]["managerStatus"].toString()]!["label"] : "--"}",
                                        ),
                                        infobox(
                                            label: tr("ibutleraddtest.type4"),
                                            val: formatTimestamp(data[index]
                                                    ["trialEndTime"]
                                                .toString()))
                                      ],
                                    ),
                                  ),
                                )))),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      padding: const EdgeInsets.all(16),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "ibutleractive.select",
                                style: normalTextBlack(),
                              ).tr(),
                              Expanded(
                                  child: InkWell(
                                onTap: () {
                                  if (enableselecttime) {
                                    showDateSelect(context);
                                  } else {
                                    showTimeTip();
                                  }
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        selectedDate == null
                                            ? "select.hintText"
                                            : "${DateFormat('yyyy-MM-dd').format(selectedDate!)}",
                                        textAlign: TextAlign.end,
                                        maxLines: 1,
                                        overflow: TextOverflow.clip,
                                        style: normalText(),
                                      ).tr(),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      child: Icon(Icons.chevron_right),
                                    )
                                  ],
                                ),
                              ))
                            ],
                          ),
                          if (minEndTime != "")
                            Text(
                              tr("iminendtime",
                                  namedArgs: {"minEndTime": "${minEndTime}"}),
                              style: normalText(fontcolor: Colors.red),
                            )
                        ],
                      ),
                    ),
                    Container(
                      height: 57,
                      padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                      child: Center(
                        child: submitButton(
                          isActive: select.isNotEmpty && selectedDate != null,
                          label: tr('determine'),
                          onClick: () async {
                            if (select.isNotEmpty && selectedDate != null)
                              _addTrial();
                          },
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Container(
                width: 720.w,
                height: 1280.h,
                color: const Color.fromRGBO(244, 244, 244, 1),
                padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          if (!enableselecttime)
                            Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(0),
                                  color: Colors.white),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: Icon(
                                      Icons.info,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  Expanded(
                                      child: Text(
                                    tr("ibutleractive.tip2"),
                                    style: normalText(fontcolor: Colors.orange),
                                  ).tr())
                                ],
                              ),
                            ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0),
                                color: Colors.white),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      tr("ibutleractive.activemenu1"),
                                      style: normalText(),
                                    ).tr(),
                                    Expanded(
                                        child: Text(
                                      "cardType${_childController.card["cardType"]}",
                                      style: normalText(),
                                    ).tr()),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      tr("ibutleractive.activemenu2"),
                                      style: normalText(),
                                    ).tr(),
                                    Expanded(
                                        child: Text(
                                      earliestEffectiveTime,
                                      style: normalText(),
                                    ).tr()),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      tr("ibutleractive.activemenutip"),
                                      style: normalText(),
                                    ).tr()),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: ListView.builder(
                            itemCount: injudgeSigneddata.length,
                            itemBuilder: ((context, index) {
                              var data = injudgeSigneddata;
                              return InkWell(
                                onTap: () {},
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                  padding: const EdgeInsets.all(16),
                                  decoration: cardStyle(context),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text("${data[index]["protocol"] ?? "--"}",
                                                  style: normalTextBlack(
                                                      fSize: 18, lineheight: 1))
                                              .tr()
                                        ],
                                      ),
                                      const Divider(),
                                      infobox(
                                        label: tr("ibutleraddtest.type1"),
                                        val: tr(
                                            "devStableTag${data[index]["devStableTag"] ?? ""}"),
                                      ),
                                      infobox(
                                        label: tr("ibutleraddtest.type2"),
                                        val:
                                            "${data[index]["deviceSn"] ?? "--"}",
                                      ),
                                      infobox(
                                        label: tr("ibutleraddtest.type3"),
                                        val:
                                            "${data[index]["managerStatus"].toString() != "{}" ? contractStatus[data[index]["managerStatus"].toString()]!["label"] : "--"}",
                                      ),
                                      infobox(
                                          label: tr("ibutleraddtest.type4"),
                                          val: formatTimestamp(data[index]
                                                  ["trialEndTime"]
                                              .toString()))
                                    ],
                                  ),
                                ),
                              );
                            }))),
                    Container(
                      height: 57,
                      padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 300.w,
                            child: normalButton(
                              label: tr('ibutleractive.editback'),
                              onClick: () async {
                                setState(() {
                                  injudgeSigned = false;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 300.w,
                            child: submitButton(
                              isActive: true,
                              label: tr('ibutleractive.active'),
                              onClick: () async {
                                toactive();
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ));
  }
}

class infobox extends StatelessWidget {
  String label;
  String val;
  infobox({super.key, required this.label, required this.val});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: normalText(),
          ).tr(),
        ),
        Expanded(
            child: Text(
          val,
          style: normalTextBlack(),
        ).tr())
      ],
    );
  }
}
