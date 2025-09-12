import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/bottomSelectSheet.dart';
import 'package:fluoroscopy_tool/compent/snInput.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/cloud/publicFunction.dart';
import 'package:fluoroscopy_tool/view/local/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: unused_import
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class addtest extends StatefulWidget {
  addtest({super.key});

  @override
  State<addtest> createState() => _addtestState();
}

class _addtestState extends State<addtest> {
  String sn = "";
  String datakey = "";
  String _dateSelectText = "";
  List data = [];
  List alldata = [];
  List select = [];
  DateTimeRange? _selectedDateRange;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
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

  _init() async {
    EasyLoading.show(status: 'loading...');
    try {
      setState(() {
        data = [];
        alldata = [];
        select = [];
        _startTime = null;
        _selectedDateRange = null;
        _endTime = null;
      });
      var project = _selectController.selectProject.value["project"];
      print({
        "projectCode": project["code"].toString(),
      });

      var init_history = await platform
          .invokeMethod('getIHouseKeepChargeHandler.pageDeviceList', {
        "projectCode": project["code"].toString(),
      });

      var indoorHistorydata = jsonDecode(init_history);

      if (indoorHistorydata["errorCode"] != null &&
          indoorHistorydata["errorCode"].toString() == "1001") {
        //登录失效
        tologout();
      }
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
      var project = _selectController.selectProject.value["project"];
      List fda = jsonDecode(jsonEncode(alldata));
      var init_history =
          await platform.invokeMethod('getAppChargeHandler.addTrial', {
        "projectCode": project["code"].toString(),
        "projectName": project["name"].toString(),
        "address": project["address"].toString(),
        "trailStartTime":
            DateTime.parse(_selectedDateRangeStart!).millisecondsSinceEpoch,
        "trailEndTime":
            DateTime.parse(_selectedDateRangeEnd!).millisecondsSinceEpoch,
        "deviceList": fda
            .where((item) => select.contains(item["deviceNid"]))
            .map((e) => jsonEncode(e))
            .toList(),
      });

      var historydata = jsonDecode(init_history);
      EasyLoading.dismiss();
      if (!historydata['success']) {
        EasyLoading.showError(historydata['errorMsg']);
      } else {
        EasyLoading.showSuccess(tr("ibutleraddtest.showSuccess"));
        Future.delayed(const Duration(seconds: 3), () {
          _init();
        });
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("${tr("ibutleraddtest.showError")}$e");
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  String formatTimestamp(var timestamp) {
    print("formatTimestamp: $timestamp");
    if (timestamp == "{}") {
      return "- -";
    } else {
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
      return DateFormat('yyyy/MM/dd').format(dateTime);
    }
  }

  _selectAll() {
    List fda = jsonDecode(jsonEncode(alldata));
    List setList = [];
    for (var element in fda) {
      if (element["managerStatus"].toString() != "3") {
        setList.add(element["deviceNid"]);
      }
    }
    setState(() {
      select = setList;
    });
  }

  void _selectIndex(data) {
    if (select.contains(data)) {
      select.remove(data);
    } else {
      select.add(data);
    }
    if (select.isEmpty) {
      _selectedDateRange = null;
    }
    setState(() {
      select;
      _selectedDateRange;
    });
  }

  String? get _selectedDateRangeStart {
    if (_selectedDateRange != null && _selectedDateRange!.start != null) {
      return DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateRange!.start!);
      // ' ${_startTime!.hour < 10 ? '0${_startTime!.hour}' : _startTime!.hour}:${_startTime!.minute < 10 ? '0${_startTime!.minute}' : _startTime!.minute}';
    }
    return null;
  }

  String? get _selectedDateRangeEnd {
    if (_selectedDateRange != null && _selectedDateRange!.end != null) {
      return DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateRange!.end!);
      // ' ${_endTime!.hour < 10 ? '0${_endTime!.hour}' : _endTime!.hour}:${_endTime!.minute < 10 ? '0${_endTime!.minute}' : _endTime!.minute}';
    }
    return null;
  }

  void showDateSelect(context) async {
    List fda = jsonDecode(jsonEncode(alldata));
    List setList = fda
        .where((element) => select.contains(element["deviceNid"]))
        // .where((element) => element["trialEndTime"].toString() != "{}")
        .map((e) => e["sysId"])
        .toList();

    /** 处理添加试用时间 */
    DateTime? maxDateTime;
    if (setList.isNotEmpty) {
      // List<DateTime> dateTimes =
      //     setList.map((dateStr) => DateTime.parse(dateStr)).toList();

      EasyLoading.show(status: 'loading...');
      try {
        var init_history =
            await platform.invokeMethod('getAppChargeHandler.getMaxTrialTime', {
          "sysIdList": setList,
        });

        var indoorHistorydata = jsonDecode(init_history);
        if (indoorHistorydata["success"]) {
          print(indoorHistorydata);
          maxDateTime = DateTime.tryParse(indoorHistorydata["data"].toString());
        }
      } catch (e) {}
      // 找到最大值
      // maxDateTime = dateTimes.reduce((a, b) => a.isAfter(b) ? a : b);
    }
    EasyLoading.dismiss();

    DateTime now = DateTime.now();

    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    // 获取两年后的时间
    DateTime twoYearsLater = startOfDay.add(const Duration(days: 365 * 2));
    DateTimeRange picked =
        DateTimeRange(end: maxDateTime ?? twoYearsLater, start: startOfDay);

    Future<bool?> back = await showCustomModalBottomBox(
        context,
        YearMonthDayPicker(
            minDate: startOfDay,
            maxDate: maxDateTime ?? twoYearsLater,
            startDate: _selectedDateRange == null
                ? startOfDay
                : _selectedDateRange!.start,
            endDate: _selectedDateRange == null
                ? maxDateTime ?? twoYearsLater
                : _selectedDateRange!.end,
            timechange: (data) {
              picked =
                  DateTimeRange(end: data["endDate"], start: data["startDate"]);
              print(picked);
            }),
        titleName: tr("ibutleraddtest.select"),
        // determine: "Instructionspage.next",
        next: () {
      if (picked != null && picked?.start != picked!.end) {
        setState(() {
          _selectedDateRange = picked;
        });
        // await _selectStartTime(context);
      } else if (picked != null && picked!.start == picked!.end) {
        // 可以在这里显示提示信息
        EasyLoading.showError(tr('timepickerror'));
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('开始日期和结束日期不能是同一天')),
        // );
      }
    });
    // final DateTimeRange? picked = await showDateRangePicker(
    //   context: context,
    //   firstDate: now,
    //   lastDate: maxDateTime ?? twoYearsLater,
    //   initialDateRange: null,
    //   builder: (BuildContext context, Widget? child) {
    //     return Theme(
    //       data: ThemeData.light().copyWith(
    //         primaryColor: const Color.fromRGBO(
    //             25, 98, 255, 1), // Customize the primary color
    //         accentColor: const Color.fromRGBO(
    //             25, 98, 255, 1), // Customize the accent color
    //         colorScheme: const ColorScheme.light(
    //             primary: Color.fromRGBO(
    //                 25, 98, 255, 1)), // Customize the color scheme
    //         buttonTheme: const ButtonThemeData(
    //             textTheme: ButtonTextTheme.primary), // Customize button theme
    //       ),
    //       child: child!,
    //     );
    //   },
    // );
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedStartTime = await showTimePicker(
      helpText: tr("startTime.helpText"),
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );

    if (pickedStartTime != null) {
      setState(() {
        _startTime = pickedStartTime;
      });
      await _selectEndTime(context);
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedEndTime = await showTimePicker(
      helpText: tr("endTime.helpText"),
      context: context,
      initialTime: _endTime ?? TimeOfDay.now(),
    );

    if (pickedEndTime != null) {
      setState(() {
        _endTime = pickedEndTime;
      });
    }
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
            'ibutleraddtest.title',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: const [],
        ),
        body: Container(
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
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: snInput(
                                  hintText: tr("ibutleraddtest.searchhintText"),
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
                                  color: const Color.fromRGBO(25, 98, 255, 1)),
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
                                    fontcolor:
                                        const Color.fromRGBO(25, 98, 255, 1)),
                              ),
                              Text("/${data.length})",
                                  style: normalTextBlack(fSize: 16))
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              _selectAll();
                            },
                            child: Text(
                              "selectAll",
                              style: normalTextBlack(
                                  fSize: 16,
                                  fontcolor:
                                      const Color.fromRGBO(25, 98, 255, 1)),
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
                              print(data[index]);
                              if (data[index]["contractStartTime"].toString() !=
                                      '{}' &&
                                  data[index]["contractEndTime"].toString() !=
                                      '{}') {
                                EasyLoading.showError(tr("havecontracttime"));
                                return;
                              }

                              if (data[index]["managerStatus"].toString() !=
                                  "3") {
                                _selectIndex(data[index]["deviceNid"]);
                              } else {
                                EasyLoading.showError(tr("managerStatus3"));
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                              padding: const EdgeInsets.all(16),
                              decoration: cardStyle(context),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      RoundCheckBox(
                                        isChecked: select
                                            .contains(data[index]["deviceNid"]),
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
                                                  fSize: 18, lineheight: 1))
                                          .tr()
                                    ],
                                  ),
                                  const Divider(),
                                  infobox(
                                    label: tr("ibutleraddtest.type1"),
                                    val: data[index]["devStableTag"]
                                                .toString() ==
                                            "1"
                                        ? tr("devstabletag1")
                                        : tr(
                                            "devStableTag${data[index]["devStableTag"]}"),
                                  ),
                                  infobox(
                                    label: tr("ibutleraddtest.type2"),
                                    val: "${data[index]["deviceSn"] ?? "--"}",
                                  ),
                                  infobox(
                                    label: tr("ibutleraddtest.type3"),
                                    val:
                                        "${data[index]["managerStatus"].toString() != "{}" ? contractStatus[data[index]["managerStatus"].toString()]!["label"] : "--"}",
                                  ),
                                  infobox(
                                      label: tr("ibutleraddtest.type4"),
                                      val: formatTimestamp(
                                          data[index]["endTime"].toString()))
                                ],
                              ),
                            ),
                          )))),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Row(
                  children: [
                    Text(
                      "ibutleraddtest.select",
                      style: normalTextBlack(),
                    ).tr(),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        if (select.isNotEmpty) {
                          showDateSelect(context);
                        } else {
                          EasyLoading.showError(tr("select.isNotEmpty"));
                        }
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedDateRange != null
                                  ? '$_selectedDateRangeStart - $_selectedDateRangeEnd\n'
                                  : "select.hintText",
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
              ),
              Container(
                height: 57,
                padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                child: Center(
                  child: submitButton(
                    isActive: _selectedDateRangeStart != null &&
                        _selectedDateRangeEnd != null &&
                        select.isNotEmpty,
                    label: tr('determine'),
                    onClick: () async {
                      if (_selectedDateRangeStart != null &&
                          _selectedDateRangeEnd != null &&
                          select.isNotEmpty) _addTrial();
                    },
                  ),
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
    return Padding(
      // ignore: prefer_const_constructors
      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: normalText(lineheight: 1),
            ).tr(),
          ),
          Expanded(
              child: Text(
            val,
            style: normalTextBlack(lineheight: 1),
          ))
        ],
      ),
    );
  }
}

class YearMonthDayPicker extends StatefulWidget {
  DateTime minDate;
  DateTime maxDate;
  DateTime startDate;
  DateTime endDate;
  Function timechange;
  YearMonthDayPicker(
      {super.key,
      required this.minDate,
      required this.maxDate,
      required this.startDate,
      required this.endDate,
      required this.timechange});
  @override
  _YearMonthDayPickerState createState() => _YearMonthDayPickerState();
}

class _YearMonthDayPickerState extends State<YearMonthDayPicker> {
  // 设置最小和最大日期
  DateTime minDate = DateTime(2000, 1, 1);
  DateTime maxDate = DateTime(2030, 12, 31);

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  // 当前选中的日期
  late int selectedYear;
  late int selectedMonth;
  late int selectedDay;

  bool setStart = true;

  @override
  void initState() {
    super.initState();
    minDate = widget.minDate;
    maxDate = widget.maxDate;

    startDate = widget.startDate;
    endDate = widget.endDate;

    final now = minDate;
    selectedYear = now.year;
    selectedMonth = now.month;
    selectedDay = now.day;
  }

  // 动态生成年份范围
  List<int> get years => List.generate(
      maxDate.year - minDate.year + 1, (index) => minDate.year + index);

  // 动态生成月份范围
  List<int> get months {
    if (selectedYear == minDate.year) {
      return selectedYear == maxDate.year
          ? List.generate(maxDate.month, (index) => index + 1)
          : List.generate(
              12 - minDate.month + 1, (index) => minDate.month + index - 1);
    } else if (selectedYear == maxDate.year) {
      return List.generate(maxDate.month, (index) => index + 1);
    } else {
      return List.generate(12, (index) => index + 1);
    }
  }

  // 动态生成日期范围
  List<int> get days {
    final firstDay = DateTime(selectedYear, selectedMonth, 1);
    final lastDay = DateTime(selectedYear, selectedMonth + 1, 0);

    int startDay = 1;
    int endDay = lastDay.day;

    if (selectedYear == minDate.year && selectedMonth == minDate.month) {
      startDay = minDate.day;
    }
    if (selectedYear == maxDate.year && selectedMonth == maxDate.month) {
      endDay = maxDate.day;
    }

    return List.generate(endDay - startDay + 1, (index) => startDay + index);
  }

  _onchange() {
    if (setStart) {
      startDate = DateTime(selectedYear, selectedMonth, selectedDay);
    } else {
      endDate = DateTime(selectedYear, selectedMonth, selectedDay);
    }
    if (endDate.microsecondsSinceEpoch < startDate.microsecondsSinceEpoch) {
      endDate = startDate.add(const Duration(days: 1));
    }

    widget.timechange({
      "startDate": startDate,
      "endDate": endDate,
    });
    setState(() {
      startDate;
      endDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      minDate = widget.minDate;

                      selectedYear = startDate.year;
                      selectedMonth = startDate.month;
                      selectedDay = startDate.day;

                      setStart = true;
                    });
                  },
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr("tryusesetstart"),
                          style: normalTextBlack(
                              fontcolor: setStart
                                  ? const Color.fromRGBO(25, 98, 255, 1)
                                  : Colors.black),
                        ),
                        Text(
                          "${startDate.year}/${startDate.month < 10 ? '0${startDate.month}' : startDate.month}/${startDate.day < 10 ? '0${startDate.day}' : startDate.day}",
                          style: normalTextBlack(
                              fontcolor: setStart
                                  ? const Color.fromRGBO(25, 98, 255, 1)
                                  : Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                    onTap: () {
                      setState(() {
                        minDate = startDate;
                        selectedYear = endDate.year;
                        selectedMonth = endDate.month;
                        selectedDay = endDate.day;

                        setStart = false;
                      });
                    },
                    child: SizedBox(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr("tryusesetend"),
                          style: normalTextBlack(
                              fontcolor: !setStart
                                  ? const Color.fromRGBO(25, 98, 255, 1)
                                  : Colors.black),
                        ),
                        Text(
                          "${endDate.year}/${endDate.month < 10 ? '0${endDate.month}' : endDate.month}/${endDate.day < 10 ? '0${endDate.day}' : endDate.day}",
                          style: normalTextBlack(
                              fontcolor: !setStart
                                  ? const Color.fromRGBO(25, 98, 255, 1)
                                  : Colors.black),
                        )
                      ],
                    )))
              ],
            ),
          ),
          Text(
            "${tr("tryuse")}${maxDate.year}/${maxDate.month < 10 ? '0${maxDate.month}' : maxDate.month}/${maxDate.day < 10 ? '0${maxDate.day}' : maxDate.day}",
            style: const TextStyle(fontSize: 12, color: Colors.red),
          ),
          Expanded(
            child: Row(
              key: ValueKey("setStart_$setStart"),
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 年份选择
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedYear = years[index];
                        // 当年份改变时，确保月份和日期在范围内
                        if (selectedYear == minDate.year &&
                            selectedMonth < minDate.month) {
                          selectedMonth = minDate.month;
                        }
                        if (selectedYear == maxDate.year &&
                            selectedMonth > maxDate.month) {
                          selectedMonth = maxDate.month;
                        }
                        if (!days.contains(selectedDay)) {
                          selectedDay = days.first;
                        }
                      });
                      _onchange();
                    },
                    children: years
                        .map((year) => Center(child: Text('$year 年')))
                        .toList(),
                  ),
                ),
                // 月份选择
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedMonth = months[index];
                        // 当月份改变时，确保日期在范围内
                        if (!days.contains(selectedDay)) {
                          selectedDay = days.first;
                        }
                      });
                      _onchange();
                    },
                    children: months
                        .map((month) => Center(child: Text('$month 月')))
                        .toList(),
                  ),
                ),
                // 日期选择
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedDay = days[index];
                      });
                      _onchange();
                    },
                    children: days
                        .map((day) => Center(child: Text('$day 日')))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
