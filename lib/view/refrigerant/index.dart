// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:fluoroscopy_tool/view/refrigerant/aicheck/aicheck.dart';
import 'package:fluoroscopy_tool/view/refrigerant/updataTip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_table/table_sticky_headers.dart';

import 'package:get/get.dart';

import '../local/checkData/class.dart';
import 'aicheck/aicheckRunning.dart';
import 'autoInput/autoInputStep1.dart';
import 'autoInput/inputing.dart';
import 'water.dart';

class refrigerantTable extends StatefulWidget {
  refrigerantTable({super.key});

  @override
  State<refrigerantTable> createState() => _refrigerantTableState();
}

class _refrigerantTableState extends State<refrigerantTable> {
  static const _selfplatform =
      MethodChannel('samples.flutter.dev/RefrigerantService');

  final deviceInfoController _deviceInfoController = Get.find();
  bool isV8 = true;
  String protocol = "";
  List titleColumn = [];
  List titleRow = [
    "subCooling",
    "t4Temp",
    "compressor1Frequency",
    "compressor2Frequency",
    "frequencyLimitingState",
    "System.powerLimit",
    "System.silentMode",
    "highPressure",
    "lowPressure",
    "t7C1Temp",
    "t7C2Temp",
    "highPressureSaturationTemp",
    "tlTemp",
    "t2aAvg",
  ];

  List titleRowInBox = [
    "subCooling",
    // "t2aAvg",
  ];

  initTabel() {
    if (_deviceInfoController.outdoorEntityList.isNotEmpty) {
      titleColumn = [];
      for (var element in _deviceInfoController.outdoorEntityList) {
        titleColumn.add("${element["address"]}#");
      }
      setState(() {
        titleColumn;
      });
    }
  }

  checklessRefrigerantCondition() async {
    try {
      var lessRefrigerantCondition = await _selfplatform
          .invokeMethod('lessRefrigerantCondition', <String, dynamic>{});
      var data = jsonDecode(lessRefrigerantCondition);
      print("refrigerant lessRefrigerantCondition: $data");
      if (data["data"]) {
        Get.to(() => autoInputStep1());
      } else {
        bool isbtn1 = await divConfirmDialog(context,
            isSubmitButton: true,
            confirmTitle: tr("refrigerant.levelLow.title"),
            confirmText: tr("refrigerant.levelLow.btn2"),
            cancelText: tr("refrigerant.levelLow.btn1"),
            confirmDescriptionWidget: SingleChildScrollView(
                child: Container(
                    width: 560.w,
                    height: 180,
                    padding: EdgeInsets.fromLTRB(24.w, 24.w, 24.w, 0),
                    child: Text.rich(TextSpan(
                      style: normalTextBlack(fSize: 16),
                      text: tr("refrigerant.levelLow.content", namedArgs: {
                        "val": _deviceInfoController.loacalDevice.value.version
                      }),
                    )))));
        if (!isbtn1) {
          Get.to(() => updataTip());
        }
      }
    } catch (e) {}
  }

  checkPass() async {
    try {
      var isInto =
          await _selfplatform.invokeMethod('isInto', <String, dynamic>{});
      print("refrigerantTable isInto: $isInto");

      _iserror(isInto);

      var getProtocol =
          await _selfplatform.invokeMethod('getProtocol', <String, dynamic>{});
      _iserror(getProtocol);
      var data_getProtocol = jsonDecode(getProtocol);
      isV8 = data_getProtocol["data"] == "V8";
      protocol = data_getProtocol["data"];
      setState(() {
        isV8;
        protocol;
      });

      initTabel();

      var isFilling =
          await _selfplatform.invokeMethod('isFilling', <String, dynamic>{});
      print("refrigerantTable isFilling: $isFilling");
      var data_gisFilling = jsonDecode(isFilling);
      if (data_gisFilling["data"] == "Filling") {
        /** 设备充注中 */
        Get.to(() => inputing());
      }

      if (data_gisFilling["data"] == "CHECKING") {
        /** 设备诊断中 */
        Get.to(() => aicheckRunning());
      }
      var getParam =
          await _selfplatform.invokeMethod('getParam', <String, dynamic>{});
      print("refrigerant refrigerantTable getParam: $getParam");
      var data_getParam = jsonDecode(getParam);
      if (data_getParam["data"] != null) {
        _deviceInfoController
            .setSubCooling(data_getParam["data"]['subCooling'].toString());
        _deviceInfoController.setSystemOperation(
            data_getParam["data"]['systemOperation'].toString());
        _deviceInfoController.setT2aAvg(
            double.parse(data_getParam["data"]['t2aAvg'].toString())
                .toStringAsFixed(2));
      }
    } catch (e) {}
  }

  _iserror(val) async {
    var data = jsonDecode(val);
    if (!data["success"]) {
      bool issend = await divConfirmOnlyDialog(
        context,
        confirmTitle: tr("device.controltDialog.confirmTitle"),
        confirmDescription: data["errorMsg"],
        isSubmitButton: true,
      );
      Get.offAllNamed('/home'); //
      return;
    }
  }

  tocheckLocalState() {}

  showTip() async {
    List<String> lines = tr('refrigerant.tipbox.content1').trim().split('\n');
    bool issend = await divConfirmOnlyDialog(
      context,
      confirmText: tr('refrigerant.tipbox.btn'),
      confirmTitle: tr("refrigerant.tipbox.title"),
      isSubmitButton: true,
      confirmDescriptionWidget: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 24.w, 24.w, 0),
        child: Container(
          width: 560.w,
          height: 400,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: lines.map((line) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    line,
                    style: normalText(
                      lineheight: 1.2,
                      fSize: [0, 9, 15].contains(lines.indexOf(line)) ? 16 : 14,
                      fontcolor: [0, 9, 15].contains(lines.indexOf(line))
                          ? Colors.black
                          : const Color.fromRGBO(140, 140, 140, 1),
                    ), // 可根据需要调整字体大小
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  checkHistory() async {
    Get.to(() => aicheck());
    /**
     * 需要云端接口
     */

    // bool ischeackbefor = Random().nextBool();
    // if (ischeackbefor) {
    //   bool issend = await divConfirmDialog(context,
    //       confirmTitle: tr("refrigerant.checkBefor.title"),
    //       confirmText: tr("refrigerant.checkBefor.btn"),
    //       cancelText: tr("sendDeviceParameter.errorbutton"),
    //       confirmDescriptionWidget: Container(
    //           width: 560.w,
    //           height: 200,
    //           padding: EdgeInsets.fromLTRB(24.w, 24.w, 24.w, 0),
    //           child: Text.rich(TextSpan(
    //             style: normalTextBlack(),
    //             text: tr("refrigerant.checkBefor.content", namedArgs: {
    //               "sn": "0000CC311112CCM3303244100",
    //               "result": "多冷媒",
    //               "time": "2024-07-10"
    //             }),
    //           ))));
    //   if (issend) {
    //     Get.to(() => aicheck());
    //   }
    // } else {
    //   Get.to(() => aicheck());
    // }
  }

  showCheckResult(type) async {
    bool issend = await divConfirmDialog(context,
        isSubmitButton: true,
        confirmTitle: tr("refrigerant.checkResult.title"),
        confirmText: tr("refrigerant.checkResult.btn2"),
        cancelText: tr("refrigerant.checkResult.btn1"),
        confirmDescriptionWidget: SingleChildScrollView(
            child: Container(
                width: 560.w,
                height: 175,
                padding: EdgeInsets.fromLTRB(0.w, 24.w, 0.w, 0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 140, // 最大宽度设为屏幕一半
                              ),
                              child: Text(
                                "refrigerant.checkResult.content",
                                style: normalTextBlack(lineheight: 1),
                              ).tr()),
                          Text(
                            type == 1
                                ? "refrigerant.checkResult.more"
                                : type == 2
                                    ? "refrigerant.checkResult.normal"
                                    : "refrigerant.checkResult.less",
                            style: normalTextBlack(
                                lineheight: 1,
                                fontcolor: type == 2
                                    ? const Color.fromRGBO(25, 98, 255, 1)
                                    : const Color.fromRGBO(247, 130, 21, 1)),
                          ).tr()
                        ],
                      ),
                    ),
                    Expanded(
                        child: infotable(
                            tableWidth: 560.w,
                            key: ValueKey("infotable_${titleColumn.length}"),
                            titleColumn: titleColumn,
                            titleRow: titleRowInBox))
                  ],
                ))));
    if (issend) {
      // ignore: use_build_context_synchronously
      String key = type == 1
          ? "checkMore"
          : type == 2
              ? "checkNormal"
              : "checkLess";
      String imagkey = type == 1
          ? "more"
          : type == 2
              ? "normal"
              : "less";
      await divConfirmOnlyDialog(context,
          isSubmitButton: true,
          confirmTitle: tr("refrigerant.${key}.title"),
          confirmText: tr("refrigerant.${key}.btn"),
          confirmDescriptionWidget: Container(
              width: 560.w,
              height: 240,
              padding: EdgeInsets.fromLTRB(24.w, 24.w, 24.w, 0),
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, type != 3 ? 64.h : 0),
                    child: ProgressManager(type: type),
                  ),
                  if (type != 3)
                    Text(
                      style: normalTextBlack(),
                      tr("refrigerant.${key}.content"),
                    )
                ],
              ))));

      if (type == 3) {
        checklessRefrigerantCondition();
      }
    }
  }

  checkisTrueCondition() async {
    try {
      var isTrueCondition = await _selfplatform
          .invokeMethod('isTrueCondition', <String, dynamic>{});
      print("refrigerant isTrueCondition: $isTrueCondition");
      var data = jsonDecode(isTrueCondition);
      if (data["success"]) {
        if (!data["data"]) {
          bool isbtn1 = await divConfirmOnlyDialog(context,
              isSubmitButton: true,
              confirmTitle: tr("refrigerant.checkBefor.title"),
              confirmText: tr("refrigerant.checkBefor.btn1"),
              confirmDescriptionWidget: SingleChildScrollView(
                  child: Container(
                      width: 560.w,
                      height: 180,
                      padding: EdgeInsets.fromLTRB(24.w, 24.w, 24.w, 0),
                      child: Text.rich(TextSpan(
                        style: normalTextBlack(fSize: 16),
                        text: tr("refrigerant.checkBefor.content1",
                            namedArgs: {}),
                      )))));
        }
      } else {}
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      checkisTrueCondition();
      checkPass();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<deviceInfoController>(
        builder: (_) => Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {
                    Get.offAllNamed('/home'); //
                  },
                  icon: const Icon(Icons.chevron_left,
                      color: Colors.black, size: 36)),
              title: const Text(
                'refrigerant',
                style: TextStyle(color: Colors.black),
              ).tr(),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {
                      showTip();
                    },
                    icon: const Icon(
                      Icons.info_outline,
                      color: Colors.black,
                    ))
              ],
            ),
            body: Container(
              width: 720.w,
              height: 1280.h,
              color: const Color.fromRGBO(255, 255, 255, 1),
              padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
              child: Column(
                children: [
                  deviceInfo(
                    sn: _deviceInfoController.loacalDevice.value.sn,
                    deviceVersion: protocol,
                    systemOperation: _deviceInfoController
                                .systemOperation.value !=
                            ""
                        ? tr(
                            "systemOperation${_deviceInfoController.systemOperation.value}")
                        : "",
                  ),
                  Expanded(
                      child: infotable(
                          key: ValueKey("infotable_${titleColumn.length}"),
                          titleColumn: titleColumn,
                          titleRow: titleRow)),
                  if (!isV8)
                    Container(
                      height: 57,
                      padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                      child: Center(
                        child: submitButton(
                          isActive: true,
                          label: tr('sendDeviceParameter.errorbutton'),
                          onClick: () async {
                            Get.back();
                          },
                        ),
                      ),
                    ),
                  if (isV8)
                    Container(
                      padding: EdgeInsets.fromLTRB(32.w, 56.h, 32.w, 16.h),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 42.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 104,
                                  height: 36,
                                  child: normalButton(
                                    fillColor:
                                        const Color.fromRGBO(0, 52, 165, 1),
                                    fillTextColor: Colors.white,
                                    label: tr('refrigerant.checkResult.more'),
                                    onClick: () async {
                                      showCheckResult(1);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 104,
                                  height: 36,
                                  child: normalButton(
                                    fillColor:
                                        const Color.fromRGBO(25, 98, 255, 1),
                                    fillTextColor: Colors.white,
                                    label: tr('refrigerant.checkResult.normal'),
                                    onClick: () async {
                                      showCheckResult(2);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 104,
                                  height: 36,
                                  child: normalButton(
                                    fillColor:
                                        const Color.fromRGBO(241, 248, 255, 1),
                                    fillTextColor:
                                        const Color.fromRGBO(25, 98, 255, 1),
                                    label: tr('refrigerant.checkResult.less'),
                                    onClick: () async {
                                      showCheckResult(3);
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 36,
                            child: normalButton(
                              label: tr('refrigerant.checkResult.unKnow'),
                              onClick: () async {
                                checkHistory();
                              },
                            ),
                          )
                        ],
                      ),
                    )
                ],
              ),
            )));
  }
}

class infotable extends StatefulWidget {
  double? tableWidth;
  List titleColumn;
  List titleRow;
  infotable(
      {super.key,
      this.tableWidth,
      required this.titleColumn,
      required this.titleRow});

  @override
  State<infotable> createState() => _infotabelState();
}

class _infotabelState extends State<infotable> {
  double _scrollOffsetX = 0.0;
  double _scrollOffsetY = 0.0;

  double? tableWidth;
  late List titleColumn;
  late List titleRow;

  @override
  void initState() {
    super.initState();
    setState(() {
      tableWidth = widget.tableWidth;
      titleColumn = widget.titleColumn;
      titleRow = widget.titleRow;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isCN =
        EasyLocalization.of(context)?.currentLocale!.languageCode == 'zh';
    int splitnum = titleColumn.length == 1 ? 2 : 3;
    return StickyHeadersTable(
      cellDimensions: CellDimensions.variableColumnWidthAndRowHeight(
          columnWidths: List.generate(
              titleColumn.length, (index) => (tableWidth ?? 720.w) / splitnum),
          rowHeights: List.generate(titleRow.length, (index) => 50),
          stickyLegendWidth: (tableWidth ?? 720.w) / splitnum,
          stickyLegendHeight: 72.h),
      columnsLength: titleColumn.length,
      rowsLength: titleRow.length,
      initialScrollOffsetX: _scrollOffsetX,
      initialScrollOffsetY: _scrollOffsetY,
      onEndScrolling: (scrollOffsetX, scrollOffsetY) {
        print("onEndScrolling: $scrollOffsetX $scrollOffsetY");
        setState(() {
          _scrollOffsetX = scrollOffsetX;
          _scrollOffsetY = scrollOffsetY;
        });
      },
      columnsTitleBuilder: (i) => Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(247, 247, 247, 1),
          border: Border.all(
            color: const Color.fromRGBO(223, 223, 223, 1), // 边框颜色
            width: 0.5, // 边框宽度
          ),
          borderRadius: BorderRadius.circular(0.0), // 圆角半径
        ),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              titleColumn[i],
              textAlign: TextAlign.center,
              style: normalTextBlack(),
            ).tr()
          ],
        )),
      ),
      rowsTitleBuilder: (i) => Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: titleRow[i] == "subCooling"
              ? const Color.fromRGBO(229, 241, 255, 1)
              : Colors.white,
          border: Border.all(
            color: const Color.fromRGBO(223, 223, 223, 1), // 边框颜色
            width: 0.5, // 边框宽度
          ),
          borderRadius: BorderRadius.circular(0.0), // 圆角半径
        ),
        child: Center(
          child: Text(titleRow[i],
                  maxLines: isCN ? 1 : 2,
                  textAlign: TextAlign.center,
                  style: normalTextBlack(
                      lineheight: isCN ? 2 : 1, fSize: isCN ? 14 : 12))
              .tr(),
        ),
      ),
      contentCellBuilder: (i, j) => Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromRGBO(223, 223, 223, 1), // 边框颜色
            width: 0.5, // 边框宽度
          ),
          borderRadius: BorderRadius.circular(0.0), // 圆角半径
        ),
        child: Center(
          child: tabelInfo(index: i, nodekey: titleRow[j]),
        ),
      ),
      legendCell: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(247, 247, 247, 1),
            border: Border.all(
              color: const Color.fromRGBO(223, 223, 223, 1), // 边框颜色
              width: 0.5, // 边框宽度
            ),
            borderRadius: BorderRadius.circular(0.0), // 圆角半径
          ),
          child: tableHeaderIndex(
              width: (tableWidth ?? 720.w) / splitnum,
              leftText: tr("table.outdoor"),
              rightText: tr("table.parameter"))),
    );
  }
}

class tabelInfo extends StatefulWidget {
  int index;
  String nodekey;
  tabelInfo({super.key, required this.index, required this.nodekey});

  @override
  State<tabelInfo> createState() => _tabelInfoState();
}

class _tabelInfoState extends State<tabelInfo> {
  final deviceInfoController _deviceInfoController = Get.find();
  handleDate(val) {
    if (val.toString().contains("SilenceMode_")) {
      return tr(val);
    } else {
      return val.toString().replaceAll("PowerLimit_", "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<deviceInfoController>(
        builder: (_) => Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: widget.nodekey == "subCooling"
                  ? const Color.fromRGBO(229, 241, 255, 1)
                  : Colors.white,
            ),
            child: _deviceInfoController.loacalDevice.value.isconnected
                ? Center(
                    child: widget.nodekey.contains("System")
                        ? Text(handleDate(_deviceInfoController.systemEntity
                            .value[widget.nodekey.replaceAll("System.", "")]))
                        : "systemOperationtable" == widget.nodekey
                            ? Text(
                                tr(
                                    "systemOperation${_deviceInfoController.systemOperation.value}"),
                                style: normalText(
                                    // ignore: unrelated_type_equality_checks
                                    fontcolor: _deviceInfoController
                                                .systemOperation.value ==
                                            "1"
                                        ? const Color.fromRGBO(140, 140, 140, 1)
                                        : Colors.red))
                            : "subCooling" == widget.nodekey
                                ? Text(
                                    _deviceInfoController.subCooling.value
                                                .toString() !=
                                            "null"
                                        ? "${_deviceInfoController.subCooling.value}℃"
                                        : '--',
                                    style: normalText(),
                                  ).tr()
                                : "canauto" == widget.nodekey
                                    ? Text(
                                        _deviceInfoController.canauto.value &&
                                                // ignore: unrelated_type_equality_checks
                                                _deviceInfoController
                                                        .systemOperation
                                                        .value ==
                                                    "1"
                                            ? "canauto.pass"
                                            : "canauto.nopass",
                                        style: normalText(
                                            fontcolor: _deviceInfoController
                                                        .canauto.value &&
                                                    // ignore: unrelated_type_equality_checks
                                                    _deviceInfoController
                                                            .systemOperation
                                                            .value ==
                                                        "1"
                                                ? Colors.green
                                                : Colors.red),
                                      ).tr()
                                    : "t2aAvg" == widget.nodekey
                                        ? Text(
                                            _deviceInfoController.t2aAvg.value,
                                            style: normalText())
                                        : Text(
                                            "${_deviceInfoController.outdoorEntityList.value[widget.index][widget.nodekey] ?? ""}",
                                            style: normalText()),
                  )
                : Text("--", style: normalText())));
  }
}

class deviceInfo extends StatelessWidget {
  String sn;
  String deviceVersion;
  String systemOperation;
  deviceInfo(
      {super.key,
      required this.sn,
      required this.deviceVersion,
      required this.systemOperation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "SN ${sn.toUpperCase()}",
            style: normalText(),
          ),
          if (deviceVersion != "" && systemOperation != "")
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${tr("errorAnalysis.deviceVersion")} ${deviceVersion}",
                  style: normalText(),
                ),
                Text(
                  tr("systemOperation",
                      namedArgs: {"val": "${systemOperation}"}),
                  style: normalText(),
                ),
              ],
            )
        ],
      ),
    );
  }
}
