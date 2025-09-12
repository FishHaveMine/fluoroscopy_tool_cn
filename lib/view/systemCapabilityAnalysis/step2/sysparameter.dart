import 'package:easy_localization/easy_localization.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/tap_handler_page.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/systemCapabilityAnalysis/selfpublicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_table/table_sticky_headers.dart';

import 'package:get/get.dart';

import 'line_chart.dart';

class sysparameter extends StatefulWidget {
  var connectedSystem;
  sysparameter({super.key, required this.connectedSystem});

  @override
  State<sysparameter> createState() => sysparameterState();
}

class sysparameterState extends State<sysparameter> {
  List tap = ["parametersPage.ODU", "parametersPage.IDU"];
  String active = 'parametersPage.ODU';

  final GlobalKey<_tableviewState> _childKey = GlobalKey();

  void triggerChildRefresh() {
    try {
      _childKey.currentState?.init();
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 720.w,
      color: const Color.fromRGBO(240, 240, 240, 1),
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          baseContainer(
            child: Text(
              'systemCapabilityAnalysisPage.systemDetail.sysparameter',
              style: normalText(),
            ).tr(),
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    for (var tapitem in tap)
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              active = tapitem;
                            });
                          },
                          child: SizedBox(
                            height: 42,
                            child: Column(
                              children: [
                                SizedBox(
                                    height: 40,
                                    child: Center(
                                      child: Text(
                                        tapitem,
                                        style: TextStyle(
                                            color: active == tapitem
                                                ? Colors.blue
                                                : Colors.black),
                                      ).tr(),
                                    )),
                                Center(
                                  child: Container(
                                    width: 48,
                                    height: 2,
                                    color: active == tapitem
                                        ? Colors.blue
                                        : Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                  ],
                ),
                switchshowPage(
                    childKey: _childKey,
                    key: ValueKey(active),
                    connectedSystem: widget.connectedSystem,
                    active: active)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class switchshowPage extends StatefulWidget {
  final GlobalKey<_tableviewState> childKey;
  var connectedSystem;
  String active;
  switchshowPage(
      {super.key,
      required this.connectedSystem,
      required this.active,
      required this.childKey});

  @override
  State<switchshowPage> createState() => _switchshowPageState();
}

class _switchshowPageState extends State<switchshowPage> {
  int showing = 0;
  List switchMenu = ["table", "charts"];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 720.w,
      height: 400,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
      padding: const EdgeInsets.all(0),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            // height: 44,
            padding: const EdgeInsets.fromLTRB(17, 12, 17, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 42 * (switchMenu.length + 1),
                  child: Row(
                    children: [
                      for (int index = 0; index < switchMenu.length; index++)
                        Expanded(
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  showing = index;
                                });
                              },
                              child: Container(
                                  width: 42,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: showing == index
                                        ? const Color.fromRGBO(0, 128, 255, 0.6)
                                        : const Color.fromRGBO(
                                            191, 191, 191, 0.09), // 背景色
                                    border: Border.all(
                                      color: showing == index
                                          ? const Color.fromRGBO(
                                              0, 128, 255, 0.6)
                                          : const Color.fromRGBO(
                                              191, 191, 191, 0.09), // 背景色
                                      width: 0.6, // 边框宽度
                                    ),
                                    borderRadius: index == 0
                                        ? const BorderRadius.only(
                                            topLeft: Radius.circular(4.8),
                                            bottomLeft: Radius.circular(4.8),
                                          )
                                        : index == switchMenu.length - 1
                                            ? const BorderRadius.only(
                                                topRight: Radius.circular(4.8),
                                                bottomRight:
                                                    Radius.circular(4.8),
                                              )
                                            : null, // 圆角
                                  ),
                                  child: Center(
                                    child: Text(
                                      switchMenu[index],
                                      style: normalTextS(
                                          fontcolor: showing == index
                                              ? Colors.white
                                              : const Color.fromRGBO(
                                                  140, 140, 140, 1),
                                          lineheight: 1.2),
                                    ).tr(),
                                  ))),
                        )
                    ],
                  ),
                ),
                Weather()
              ],
            ),
          ),
          Expanded(
              key: ValueKey("Expanded${widget.active}"),
              child: showing == 0
                  ? tableview(
                      connectedSystem: widget.connectedSystem,
                      active: widget.active)
                  : LineChart(
                      connectedSystem: widget.connectedSystem,
                      active: widget.active))
        ],
      ),
    );
  }
}

// ignore: camel_case_types
class tableview extends StatefulWidget {
  var connectedSystem;
  String active;
  tableview({super.key, required this.connectedSystem, required this.active});

  @override
  State<tableview> createState() => _tableviewState();
}

// ignore: camel_case_types
class _tableviewState extends State<tableview> {
  static const platform = MethodChannel('samples.flutter.dev/battery');
  List titleColumn = [];
  List titleRow = [];
  List data = [];
  init() async {
    print("active: ${widget.active}");
    EasyLoading.show(status: "loading...");
    try {
      var getRealTimeData =
          await platform.invokeMethod('getRealTimeData', <String, dynamic>{
        "sysId": widget.connectedSystem['sysId'],
        "deviceType":
            widget.active == "parametersPage.IDU" ? "indoor" : "outdoor"
      });
      EasyLoading.dismiss();
      if (getRealTimeData['success']) {
        refreshtable(widget.active == "parametersPage.IDU"
            ? getRealTimeData['data']["indoorList"]
            : getRealTimeData['data']["outdoorList"]);
      }
      if (!getRealTimeData['success']) {
        EasyLoading.showError(getRealTimeData['errorMsg']);
      }
    } catch (e) {
      print(e.toString());
      EasyLoading.dismiss();
    }
  }

  Future<void> _init() async {
    init();
  }

  refreshtable(arr) {
    titleRow = [];
    titleColumn = [];
    data = [];
    for (var row in arr[0]['propertyList']) {
      titleRow.add(row['title']);
    }
    var _propertyListmap = {};
    for (var element in arr) {
      print(element);
      titleColumn.add(element['name']);
      List tabledata = [];
      for (var dateitem in element['propertyList']) {
        var _val = dateitem['value'] == ""
            ? "--"
            : dateitem['type'] == "enum"
                ? dateitem['desc']
                : dateitem['value'];

        tabledata.add('${_val} ${dateitem['unit'] ?? ""}');
      }
      data.add(tabledata);
    }
    setState(() {
      titleRow;
      titleColumn;
      data;
    });
  }

  List<double> rowHeightsList(leng) {
    List<double> out = [];
    for (var i = 0; i < leng; i++) {
      out.add(50.0);
    }
    return out;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      init();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return data.isEmpty
        ? Center(
            child: SizedBox(
              width: 200.w,
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
            ),
          )
        : StickyHeadersTable(
            cellDimensions: CellDimensions.variableColumnWidthAndRowHeight(
                columnWidths: List.generate(
                    titleColumn.length,
                    (index) =>
                        (720.w - 32.w * 2 - 10) /
                        (titleColumn.length < 3 ? titleColumn.length : 4)),
                rowHeights: rowHeightsList(titleRow.length),
                stickyLegendWidth: (720.w - 32.w * 2 - 10) / 3,
                stickyLegendHeight: 72.h),
            columnsLength: titleColumn.length,
            rowsLength: titleRow.length,
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
                    titleColumn[i],
                    textAlign: TextAlign.center,
                    style: tableLabel(context),
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
                  Expanded(
                      child: Text(titleRow[i],
                          textAlign: TextAlign.center,
                          style: tableLabel(context)))
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
              child: Center(
                child: Text(
                  data[i][j],
                  style: tableLabel(context),
                ),
              ),
            ),
            legendCell: Container(
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
                  child: Text(
                    'project.name',
                    style: tableLabel(context),
                  ).tr(),
                )),
          );
  }
}

class Weather extends StatefulWidget {
  Weather({super.key});

  @override
  State<Weather> createState() => _getWeatherState();
}

class _getWeatherState extends State<Weather>
    with SingleTickerProviderStateMixin {
  static const platform = MethodChannel('samples.flutter.dev/battery');

  final systemAnalysisController _systemController = Get.find();
  var weatherinfo;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        print({
          "getWeather projectCode":
              _systemController.selectedSystem.value["projectCode"].toString(),
        });
        var getWeather = await platform.invokeMethod('getWeather', {
          "projectCode":
              _systemController.selectedSystem.value["projectCode"].toString(),
        });

        if (getWeather['data'] != null) {
          setState(() {
            weatherinfo = getWeather['data'];
          });
        }
      } catch (e) {}
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 获取当前日期
    DateTime now = DateTime.now();

    // 使用DateFormat来格式化日期
    String formattedDate = DateFormat('MM月dd日').format(now);
    return Container(
      child: Text.rich(
          textAlign: TextAlign.end,
          TextSpan(
              style: normalTextS(lineheight: 1.2),
              text: tr('systemCapabilityAnalysisPage.systemDetail.weatherinfo',
                  namedArgs: {
                    'formattedDate': formattedDate,
                    'time': weatherinfo != null
                        ? weatherinfo['publicTime'] ?? ''
                        : '',
                    'temperature': weatherinfo != null
                        ? weatherinfo['temperature'] ?? '--'
                        : '--',
                    'wetness': weatherinfo != null
                        ? weatherinfo['wetness'] ?? '--'
                        : '--',
                  }))),
    );
  }
}
