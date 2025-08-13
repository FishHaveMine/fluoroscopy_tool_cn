import 'package:easy_localization/easy_localization.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:fluoroscopy_tool/compent/bottomSelectSheet.dart';
import 'package:fluoroscopy_tool/view/local/parameters/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LineChart extends StatefulWidget {
  String active;
  var connectedSystem;
  LineChart({super.key, required this.connectedSystem, required this.active});

  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  bool isJsLoadComply = false;
  int mockdata = 30;
  String selectitem = '';
  List delist = [];
  List<String> namelist = [];
  List xaxis = [];
  int key = DateTime.now().millisecondsSinceEpoch;
  List datalist = [];
  List op = [];
  Map opMap = {};
  static const platform = MethodChannel('samples.flutter.dev/battery');
  init() async {
    try {
      var getDetailBySnback = await platform.invokeMethod('getDetailBySn',
          <String, dynamic>{"sysId": widget.connectedSystem['sysId']});
      if (widget.active == "parametersPage.IDU") {
        delist = getDetailBySnback['data']["indoorList"];
      } else {
        delist = getDetailBySnback['data']["outdoorList"];
      }
      for (var deop in delist) {
        op.add({
          'label': deop['name'],
          'name': deop['name'],
          'value': deop['nid']
        });
        opMap[deop['nid']] = deop['name'];
      }
      ;
      setState(() {
        op;
        opMap;
        delist;
        selectitem = op[0]['value'];
      });
    } catch (e) {}
    refreshchar();
  }

  refreshchar() async {
    if (selectitem != "") {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      DateTime sixHoursAgo = now.subtract(Duration(hours: 6));
      String formattedSixHoursAgo =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(sixHoursAgo);
      var getHistoryData = await platform.invokeMethod(
          'getHistoryData', <String, dynamic>{
        "startTime": formattedSixHoursAgo,
        "endTime": formattedDate,
        "nid": selectitem
      });
      namelist = [];
      datalist = [];
      xaxis = [];
      try {
        List series = getHistoryData['data']['series'];
        List legend = getHistoryData['data']['legend'];
        List legendName = getHistoryData['data']['legendName'];
        for (int index = 0; index < legendName.length; index++) {
          String element = legendName[index];
          String elementkey = legend[index];
          namelist.add("\"${element.toString()}\"");
          List daitem = series
              .where((seriesietm) => seriesietm['name'] == elementkey)
              .toList();
          datalist.add(daitem[0]['originData']);
        }

        for (var xaxisitem in getHistoryData['data']['xaxis']) {
          xaxis.add("\"${xaxisitem.toString()}\"");
        }
      } catch (e) {}
      setState(() {
        namelist;
        xaxis;
        datalist;
      });
    }
  }

  setselectitem(val) {
    setState(() {
      selectitem = val;
    });
    refreshchar();
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
    return Container(
      width: 720.w,
      height: 300,
      // color: Color.fromARGB(93, 0, 0, 0),
      child: Column(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                width: double.infinity,
                child: const Text(
                        'systemCapabilityAnalysisPage.systemDetail.sysparameter',
                        style: TextStyle(
                            color: Color.fromRGBO(15, 17, 28, 0.5),
                            fontSize: 14))
                    .tr(),
              ),
              InkWell(
                onTap: () async {
                  Future<sheetBack?> selectedIndex =
                      await showCustomModalBottomSheet(
                          isMultiple: false,
                          context,
                          [...op],
                          // ignore: unrelated_type_equality_checks
                          baseValue: [],
                          titleName: '');
                  selectedIndex.then((value) => {
                        if (value!.baseValue![0] != null)
                          {setselectitem(value!.baseValue![0])}
                      });
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          const Color(0xFFF0F0F0), // 1px border, #F0F0F0 color
                      width: 1.0,
                    ),
                    borderRadius:
                        BorderRadius.circular(8.0), // 8px border radius
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    opMap[selectitem] ?? "",
                    style: TextStyle(
                        color: Color.fromRGBO(15, 17, 28, 0.5), fontSize: 14),
                  ),
                ),
              )
            ],
          ),
          if (namelist.isEmpty)
            Center(
              child: SizedBox(
                width: 200.w,
                height: 210,
                child: EmptyWidget(
                  image: null,
                  packageImage: null,
                  title: tr('device.empty'),
                  titleTextStyle: const TextStyle(
                    fontSize: 22,
                    color: Color(0xff9da9c7),
                    fontWeight: FontWeight.w500,
                  ),
                  subtitleTextStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xffabb8d6),
                  ),
                ),
              ),
            ),
          if (namelist.isNotEmpty)
            SizedBox(
              width: 720.w,
              height: 210,
              key: ValueKey('Echarts_$key'),
              child: Echarts(
                reloadAfterInit: true,
                captureAllGestures: true,
                extraScript: '''
    var base = +new Date(1968, 9, 3);
    var oneDay = 24 * 3600 * 1000;
    var date = ${xaxis.toString()};

    var listdata = [];
    var namelist = ${namelist.toString()};

    var datalist = ${datalist.toString()};
    var colorslist = ["#0080FF", "#52DD0D", "#FFC001", "#FF3367", "#0DDDA8"];

    for (var i = 0; i < namelist.length; i++) {
      listdata.push({
        name: namelist[i],
        type: 'line',
        smooth: true,
        symbol: 'none',
        sampling: 'average',
        itemStyle: {
          color: colorslist[i]
        },
        yAxisIndex: i > 2 ? 0 : 1,
        data: datalist[i]
      });
    }
                  ''',
                option: '''
                    {
      grid: {
        "borderWidth": 0,
        "top": 30,
        "left": 50,
        "right": 50,
        "bottom": 75,
        textStyle: {
          color: "#fff"
        }
      },
      legend: {
        wdith: '80%',
        bottom: '0', icon: 'rect',  // 设置图标形状为长方形
        itemWidth: 8,  // 设置图标宽度
        itemHeight: 2,  // 设置图标高度，可以根据需要调
        textStyle: {
          fontSize: 9,
          color: '#90979c',
        },
        data: namelist
      },
      tooltip: {
        trigger: 'axis',
        position: function (pt) {
          return [pt[0], '10%'];
        }
      },
      toolbox: {

      },
      xAxis: {
        type: 'category',
        boundaryGap: false,
        data: date,
        axisLabel: {
          textStyle: {
            fontSize: 9,
            color: '#556677'
          }
        },
      },
      yAxis: [{
        type: 'value',
        axisTick: {
          show: false
        },
        axisLine: {
          show: true,
          lineStyle: {
            color: '#DCE2E8'
          }
        },
        axisLabel: {
          textStyle: {
            fontSize: 9,
            color: '#556677'
          }
        },
        splitLine: {
          show: false
        }
      }, {
        type: 'value',
        position: 'right',
        axisTick: {
          show: false
        },
        axisLabel: {
          textStyle: {
            fontSize: 9,
            color: '#556677'
          },
          formatter: '{value}'
        },
        axisLine: {
          show: true,
          lineStyle: {
            color: '#DCE2E8'
          }
        },
        splitLine: {
          show: false
        }
      }],
      dataZoom: [{
        type: 'inside',
        start: 0,
        end: 10,
      }, {
        start: 0,
        end: 10,
        handleSize: '80%',
        height: 10,
        bottom: 50,
        handleStyle: {
          width: 15, // 设置图片宽度为 20px
          height: 15, // 设置图片高度为 20px
          padding: 0,
        },
        moveHandleIcon: 'none',
        moveHandleStyle: {
          opacity: 0,
        },
        textStyle: {
          color: '#fff',
        },
        borderColor: 'rgba(213, 211, 211, 0.8)',
        dataBackground: {},
        selectedDataBackground: {},
      }],
      series: [
        ...listdata
      ]
    }
                  ''',
              ),
            )
        ],
      ),
    );
  }
}
