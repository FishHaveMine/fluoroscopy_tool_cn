import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/local/parameters/style.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_table/table_sticky_headers.dart';

import 'package:get/get.dart';

import 'errorDetail.dart';

class deviceStatus extends StatefulWidget {
  const deviceStatus({super.key});

  @override
  State<deviceStatus> createState() => _deviceStatusState();
}

class _deviceStatusState extends State<deviceStatus> {
  final deviceInfoController _deviceInfoController = Get.find();

  List<List<dynamic>> data = [];

  List selectedRow = [];
  List<String> titleColumn = [
    "errorAnalysis.deviceStatus.tableColumn1",
    "errorAnalysis.deviceStatus.tableColumn2",
    "errorAnalysis.deviceStatus.tableColumn3"
  ];
  List<String> titleRow = [];
  setdata(element) {
    // element['errorCode'] = null;
    bool isError = element['errorCode'] != null &&
        element['errorCode'].toString() != "0" &&
        element['errorCode'].toString() != "";
    // element['errorCode'].isNotEmpty;
    data.add([
      "${element['address']}#",
      (isError
          ? tr("errorAnalysis.deviceStatus.tableColumn2_error")
          : tr("errorAnalysis.deviceStatus.tableColumn2_normal")),
      "${!(isError) ? "" : element['errorCode']}"
    ]);
    if (isError) {
      selectedRow.add(data.length - 1);
      print("selectedRow: $selectedRow");
    }
  }

  init() {
    var mainoutdoor = _deviceInfoController.outdoorEntityList
        .where((p0) => p0["address"].toString() == "0")
        .toList();

    var ortheroutdoor = _deviceInfoController.outdoorEntityList
        .where((p0) => p0["address"].toString() != "0")
        .toList();
    if (mainoutdoor.isNotEmpty) {
      for (var element in mainoutdoor) {
        titleRow.add(tr("errorAnalysis.deviceStatus.tableColumn1.type1"));
        setdata(element);
      }
    }
    if (ortheroutdoor.isNotEmpty) {
      for (var element in ortheroutdoor) {
        String row = titleRow
                .contains(tr("errorAnalysis.deviceStatus.tableColumn1.type2"))
            ? ""
            : tr("errorAnalysis.deviceStatus.tableColumn1.type2");
        titleRow.add(row);
        setdata(element);
      }
    }
    if (_deviceInfoController.indoorEntityList.isNotEmpty) {
      for (var element in _deviceInfoController.indoorEntityList) {
        String row = titleRow
                .contains(tr("errorAnalysis.deviceStatus.tableColumn1.type3"))
            ? ""
            : tr("errorAnalysis.deviceStatus.tableColumn1.type3");
        titleRow.add(row);
        setdata(element);
      }
    }
    // for (int i = 0; i < 20; i++) {
    //   bool iserror = Random().nextBool();
    //   titleRow.add(i == 0
    //       ? "主外机"
    //       : i == 1
    //           ? "从外机"
    //           : i == 2
    //               ? "内机"
    //               : "");
    //   data.add(["odu-00023-${i}#", "$iserror", iserror ? "J01" : ""]);
    //   if (iserror) {
    //     selectedRow.add(i);
    //   }
    // }
    setState(() {
      data;
      titleRow;
      selectedRow;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color getContentColor(int i, int j) {
    if (selectedRow.contains(j)) {
      return const Color.fromRGBO(254, 243, 243, 1);
    } else {
      return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 720.w,
      height: 1280.h - 56 - 104.h,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0.h, 0, 0.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromRGBO(223, 223, 223, 1),
                              width: 0.5,
                            ),
                          )),
                      padding: EdgeInsets.fromLTRB(32.w, 12, 32.w, 12),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              tr('errorAnalysis.deviceStatus.parameter1'),
                              style: normalTextBlack(),
                            ),
                            Text(
                              _deviceInfoController.loacalDevice.value.machine,
                              style: ErrorTip(),
                            )
                          ]),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromRGBO(223, 223, 223, 1),
                              width: 0.5,
                            ),
                          )),
                      padding: EdgeInsets.fromLTRB(32.w, 12, 32.w, 12),
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tr('errorAnalysis.deviceStatus.parameter2'),
                                style: normalTextBlack(),
                              ),
                              Text(
                                _deviceInfoController
                                            .loacalDevice.value.errorCode
                                            .toString() ==
                                        "0"
                                    ? "errorAnalysis.deviceStatus.parameter2_normal"
                                    : "errorAnalysis.deviceStatus.parameter2_error",
                                style: normalText(
                                    fontcolor: _deviceInfoController
                                                .loacalDevice.value.errorCode
                                                .toString() !=
                                            "0"
                                        ? const Color.fromRGBO(255, 0, 0, 1)
                                        : const Color.fromRGBO(
                                            140, 140, 140, 1)),
                              ).tr()
                            ]),
                      ),
                    )
                  ],
                )),
          ),
          SizedBox(
            width: 720.w,
            height: 1280.h - 104.h - 105 * 2,
            child: StickyHeadersTable(
              cellDimensions: CellDimensions.variableColumnWidthAndRowHeight(
                  columnWidths: List.generate(
                      titleColumn.length, (index) => (720.w - 80) / 3),
                  rowHeights: List.generate(titleRow.length, (index) => 50),
                  stickyLegendWidth: 80,
                  stickyLegendHeight: 50),
              columnsLength: titleColumn.length,
              rowsLength: titleRow.length,
              columnsTitleBuilder: (i) => Container(
                color: const Color.fromRGBO(244, 248, 255, 1),
                child: Center(
                  child: Text(titleColumn[i]).tr(),
                ),
              ),
              rowsTitleBuilder: (i) => Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: getContentColor(i, i),
                  border: Border.all(
                    color: const Color(0xFFDFDFDF), // 边框颜色
                    width: 0.25, // 边框宽度
                  ),
                ),
                child: Center(
                  child: Text(titleRow[i],
                      style: normalTextS(
                          fontcolor: selectedRow.contains(i)
                              ? const Color.fromRGBO(255, 0, 0, 1)
                              : Colors.black)),
                ),
              ),
              contentCellBuilder: (i, j) => Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: getContentColor(i, j),
                  border: Border.all(
                    color: const Color(0xFFDFDFDF), // 边框颜色
                    width: 0.25, // 边框宽度
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    if (data[j][2] != "") {
                      Get.to(() =>
                          errorDetailPage(item: {"errorCode": data[j][2]}));
                    }
                  },
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Text(
                          data[j][i] ?? "--",
                          textAlign: TextAlign.center,
                          style: normalTextS(
                              fontcolor: selectedRow.contains(j)
                                  ? const Color.fromRGBO(255, 0, 0, 1)
                                  : const Color.fromRGBO(140, 140, 140, 1)),
                        )),
                        if (i == 2 && selectedRow.contains(j))
                          const Icon(
                            Icons.keyboard_arrow_right,
                            size: 20,
                            color: Color.fromRGBO(255, 0, 0, 1),
                          )
                      ],
                    ),
                  ),
                ),
              ),
              legendCell: Container(
                color: const Color.fromRGBO(244, 248, 255, 1),
              ),
            ),
          )
        ],
      ),
    );
  }
}
