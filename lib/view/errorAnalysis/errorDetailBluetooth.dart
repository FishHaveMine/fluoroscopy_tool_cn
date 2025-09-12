import 'package:easy_localization/easy_localization.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:fluoroscopy_tool/compent/bottomSelectSheet.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_table/table_sticky_headers.dart';

import 'package:get/get.dart';

import '../local/checkData/index.dart';

class errorDetailBluetooth extends StatefulWidget {
  var item;
  errorDetailBluetooth({
    super.key,
    required this.item,
  });

  @override
  State<errorDetailBluetooth> createState() => _errorDetailBluetoothState();
}

class _errorDetailBluetoothState extends State<errorDetailBluetooth> {
  List showingtype = [
    "errorCodePage",
    "protocol",
    "timeStamp",
  ];
  var data;
  int sign = 0;
  List signList = List.generate(
    33,
    (index) => {
      'label': "sign${index}",
      'name': "sign${index}",
      'value1': "$index",
      "value": index
    },
  );
  init() async {
    setState(() {
      data = widget.item;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  updataVal(val) {
    sign = int.parse(val.toString());
    setState(() {
      sign;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? languageCode =
        EasyLocalization.of(context)?.currentLocale?.languageCode;
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
            'erroranalysis.resultbluetooth.type2',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [],
        ),
        body: Container(
          width: 720.w,
          color: const Color.fromRGBO(244, 244, 244, 1),
          padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
          child: SingleChildScrollView(
              child: Column(
            children: [
              Container(
                width: 720.w,
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
                        // ignore: prefer_interpolation_to_compose_strings
                        tr("erroranalysis.resultbluetooth.detail1"),
                        style: normalTextBlack(lineheight: 1),
                      ),
                      errorCodePage(
                        data: data,
                      )
                    ]),
              ),
              Container(
                width: 720.w,
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
                        // ignore: prefer_interpolation_to_compose_strings
                        tr("erroranalysis.resultbluetooth.detail2"),
                        style: normalTextBlack(lineheight: 1),
                      ),
                      Text(
                        data['protocol'],
                        style: TextStyle(
                            fontSize: languageCode == 'zh' ? 16 : 12,
                            color: Color.fromRGBO(15, 17, 28, 0.5),
                            fontWeight: FontWeight.w400),
                      )
                    ]),
              ),
              Container(
                width: 720.w,
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
                        // ignore: prefer_interpolation_to_compose_strings
                        tr("erroranalysis.resultbluetooth.detail3"),
                        style: normalTextBlack(lineheight: 1),
                      ),
                      Text(
                        data['timeStamp'].toString(),
                        style: TextStyle(
                            fontSize: languageCode == 'zh' ? 16 : 12,
                            color: Color.fromRGBO(15, 17, 28, 0.5),
                            fontWeight: FontWeight.w400),
                      )
                    ]),
              ),
              InkWell(
                  key: ValueKey("sign_$sign"),
                  onTap: () async {
                    Future<sheetBack?> selectedIndex =
                        await showCustomModalBottomSheet(
                            isMultiple: false,
                            context,
                            [...signList],
                            // ignore: unrelated_type_equality_checks
                            baseValue: [sign.toString()],
                            titleName:
                                tr("erroranalysis.resultbluetooth.detail4"));
                    selectedIndex.then((value) => {
                          if (value != null && value.baseValue![0] != -1)
                            {updataVal(value.baseValue![0])}
                        });
                  },
                  child: Container(
                    width: 720.w,
                    height: 50,
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            // ignore: prefer_interpolation_to_compose_strings
                            tr("erroranalysis.resultbluetooth.detail4"),
                            style: normalTextBlack(lineheight: 1),
                          ),
                          Expanded(
                            child: Text(
                              tr("sign${sign}"),
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: languageCode == 'zh' ? 16 : 12,
                                  color: Color.fromRGBO(15, 17, 28, 0.5),
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: Color.fromRGBO(140, 140, 140, 1),
                          )
                        ]),
                  )),
              tableTapselect(
                key: ValueKey("tableTapselect_$sign"),
                sign: sign,
                data: data,
              )
            ],
          )),
        ));
  }
}

class errorCodePage extends StatefulWidget {
  var data;
  errorCodePage({super.key, required this.data});

  @override
  State<errorCodePage> createState() => _errorCodePageState();
}

class _errorCodePageState extends State<errorCodePage> {
  String resul = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try {
      // 格式化 inDoorErrorMap 和 outDoorErrorMap
      var inDoorErrorMap = widget.data["inDoorErrorMap"];
      inDoorErrorMap.removeWhere((key, value) => value == "0");
      String inDoorErrors = inDoorErrorMap.entries
          .map((e) => e.value.toString() != "0" ? "${e.value}" : "")
          .join(", ");

      var outDoorErrorMap = widget.data["outDoorErrorMap"];
      outDoorErrorMap.removeWhere((key, value) => value == "0");
      String outDoorErrors = outDoorErrorMap.entries
          .map((e) => e.value.toString() != "0" ? "${e.value}" : "")
          .join(", ");

      // 合并输出
      resul = inDoorErrors + (inDoorErrors != "" ? "," : "") + outDoorErrors;
      setState(() {
        resul;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    String? languageCode =
        EasyLocalization.of(context)?.currentLocale?.languageCode;
    return Text(
      resul,
      style: TextStyle(
          fontSize: languageCode == 'zh' ? 16 : 12,
          color: Color.fromRGBO(15, 17, 28, 0.5),
          fontWeight: FontWeight.w400),
    );
  }
}

class tableTapselect extends StatefulWidget {
  int sign;
  var data;
  tableTapselect({super.key, required this.sign, required this.data});

  @override
  State<tableTapselect> createState() => _tableTapselectState();
}

class _tableTapselectState extends State<tableTapselect> {
  List showType = [
    "erroranalysis.resultbluetooth.select1",
    "erroranalysis.resultbluetooth.select2",
    "erroranalysis.resultbluetooth.select3",
    "erroranalysis.resultbluetooth.select4",
    "erroranalysis.resultbluetooth.select5"
  ];
  String activeType = "erroranalysis.resultbluetooth.select1";

  List titleColumn = [];
  List titleRow = [];
  List data = [];
  var adddata;
  var faultWaveDataDTO;
  var waveDataDTOList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (var element in widget.data['machineDataDTOList']) {
      if (element["sign"] == widget.sign) {
        adddata = element;
        setState(() {
          adddata;
        });
        continue;
      }
    }

    try {
      faultWaveDataDTO = widget.data['faultWaveDataDTO'] ?? {};
      waveDataDTOList = widget.data['waveDataDTOList'] ?? [];
    } catch (e) {}

    if (adddata != null) settabelinfo();
  }

  settabelinfo() {
    titleColumn = [];
    titleRow = [];
    data = [];
    if (activeType == "erroranalysis.resultbluetooth.select1") {
      try {
        List _data = [];
        titleRow.add("0#");
        for (var element in adddata["systemFaultDataDTO"]["odu_70_0"].keys) {
          print("_tableTapselectState : ${element}");
          titleColumn.add(element);
          _data.add(
              adddata["systemFaultDataDTO"]["odu_70_0"][element].toString());
        }
        data = [_data];
      } catch (e) {
        print("_tableTapselectState : ${e}");
      }
    }

    if (activeType == "erroranalysis.resultbluetooth.select2") {
      try {
        int index = 0;
        for (var element in adddata["outDoorFaultDataDTOList"]) {
          titleRow.add("${element['address']}#");
          List _data = [];
          for (var odu_71 in element["odu_71"].keys) {
            if (index == 0) titleColumn.add(odu_71);
            _data.add(element["odu_71"][odu_71].toString());
          }
          data.add(_data);
          index++;
        }
      } catch (e) {
        print("_tableTapselectState : ${e}");
      }
    }

    if (activeType == "erroranalysis.resultbluetooth.select3") {
      try {
        int index = 0;
        for (var element in adddata["inDoorFaultDataDTOList"]) {
          titleRow.add("${element['address']}#");
          List _data = [];
          for (var odu_71 in element["ordinary_idu_20_0"].keys) {
            if (index == 0) titleColumn.add(odu_71);
            _data.add(element["ordinary_idu_20_0"][odu_71].toString());
          }
          data.add(_data);
          index++;
        }
      } catch (e) {
        print("_tableTapselectState : ${e}");
      }
    }

    if (activeType == "erroranalysis.resultbluetooth.select4") {
      try {
        List _data = [];
        titleRow.add("0#");
        for (var element in faultWaveDataDTO.keys) {
          titleColumn.add(element);
          _data.add("${faultWaveDataDTO[element] ?? ""}");
        }
        data = [_data];
      } catch (e) {
        print("_tableTapselectState : ${e}");
      }
    }

    if (activeType == "erroranalysis.resultbluetooth.select5") {
      try {
        try {
          int index = 0;
          for (var element in waveDataDTOList) {
            titleRow.add("${element['dataFrames']}");
            List _data = [];
            for (var odu_71 in element.keys) {
              if (index == 0) titleColumn.add(odu_71);
              _data.add(element[odu_71].toString());
            }
            data.add(_data);
            index++;
          }
        } catch (e) {
          print("_tableTapselectState : ${e}");
        }
      } catch (e) {
        print("_tableTapselectState : ${e}");
      }
    }

    setState(() {
      titleColumn;
      titleRow;
      data;
    });
  }

  changActiveType(val) {
    EasyLoading.show(status: 'loading...');
    activeType = val;
    settabelinfo();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    String? languageCode =
        EasyLocalization.of(context)?.currentLocale?.languageCode;
    return Container(
      width: 720.w,
      height: 420,
      child: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          Container(
              height: 88.h,
              child: Row(
                children: [
                  Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: showType.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          child: Stack(
                            children: [
                              Container(
                                height: 88.h,
                                width: 720.w / showType.length,
                                color: Colors.white,
                                child: Center(
                                    child: Text(
                                  tr(showType[index]),
                                  textAlign: TextAlign.center,
                                  style: activeType == showType[index]
                                      ? const TextStyle(
                                          fontSize: 14,
                                          color: Color.fromRGBO(31, 31, 31, 1),
                                          fontWeight: FontWeight.w600)
                                      : const TextStyle(
                                          fontSize: 14,
                                          color:
                                              Color.fromRGBO(13, 13, 13, 0.50),
                                          fontWeight: FontWeight.w400),
                                )),
                              ),
                              if (activeType == showType[index])
                                Positioned(
                                    bottom: 0,
                                    child: Container(
                                      width: 720.w / showType.length,
                                      child: Center(
                                        child: Container(
                                          width: 40.w,
                                          height: 4,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: const Color.fromRGBO(
                                                25, 98, 255, 1),
                                          ),
                                        ),
                                      ),
                                    ))
                            ],
                          ),
                          onTap: () {
                            changActiveType(showType[index]);
                          },
                        );
                      },
                      separatorBuilder: (context, index) => Container(
                        width: 0,
                        height: 72.h,
                        color: const Color.fromRGBO(238, 238, 238, 0.3),
                      ),
                    ),
                  ),
                ],
              )),
          Expanded(
              child: Container(
            color: Colors.white,
            child: data.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(90),
                    child: EmptyWidget(
                      image: null,
                      packageImage: null,
                      title: tr('device.empty'),
                      titleTextStyle: TextStyle(
                        fontSize: EasyLocalization.of(context)
                                    ?.currentLocale!
                                    .languageCode ==
                                'zh'
                            ? 22
                            : 16,
                        color: const Color(0xff9da9c7),
                        fontWeight: FontWeight.w500,
                      ),
                      subtitleTextStyle: TextStyle(
                        fontSize: EasyLocalization.of(context)
                                    ?.currentLocale!
                                    .languageCode ==
                                'zh'
                            ? 14
                            : 12,
                        color: const Color(0xffabb8d6),
                      ),
                    ),
                  )
                : StickyHeadersTable(
                    cellDimensions:
                        CellDimensions.variableColumnWidthAndRowHeight(
                            columnWidths: List.generate(
                                titleRow.length,
                                (index) =>
                                    (720.w) /
                                    (titleRow.length == 1
                                        ? 2
                                        : titleRow.length > 2
                                            ? 4
                                            : 3)),
                            rowHeights: List.generate(
                              titleColumn.length,
                              (index) => 50,
                            ),
                            stickyLegendWidth:
                                (720.w) / (titleRow.length == 1 ? 2 : 3),
                            stickyLegendHeight: 72.h),
                    columnsLength: titleRow.length,
                    rowsLength: titleColumn.length,
                    columnsTitleBuilder: (i) => Container(
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
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            titleRow[i],
                            maxLines: languageCode == 'zh' ? 1 : 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: languageCode == 'zh'
                                ? tableLabel(context)
                                : tableLabelsmall(context),
                          ).tr()
                        ],
                      )),
                    ),
                    rowsTitleBuilder: (i) => Container(
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
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: SizedBox(
                                width:
                                    ((720.w) / (titleRow.length == 1 ? 2 : 3)) -
                                        5,
                                // ignore: prefer_interpolation_to_compose_strings
                                child: Text("errorpage." + titleColumn[i],
                                        maxLines: languageCode == 'zh' ? 1 : 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: languageCode == 'zh'
                                            ? tableLabel(context)
                                            : tableLabelsmall(context))
                                    .tr(),
                              ))
                        ],
                      )),
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
                      child: GetBuilder<deviceInfoController>(builder: (_) {
                        return Center(
                          child: Text(data[i][j]),
                        );
                      }),
                    ),
                    legendCell: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                const Color.fromRGBO(223, 223, 223, 1), // 边框颜色
                            width: 0.5, // 边框宽度
                          ),
                          borderRadius: BorderRadius.circular(0.0), // 圆角半径
                        ),
                        child: Container()),
                  ),
          )),
        ],
      ),
    );
  }
}
