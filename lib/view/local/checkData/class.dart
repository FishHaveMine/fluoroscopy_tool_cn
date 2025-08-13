/*
 * @Author: FishHaveMine 751174479@qq.com
 * @Date: 2024-06-06 17:59:05
 * @LastEditors: FishHaveMine 751174479@qq.com
 * @LastEditTime: 2024-06-11 17:32:30
 * @FilePath: /fluoroscopy_tool/lib/view/local/checkData/class.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'dart:convert';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// table通用包裹元素
class tabelRowItem extends StatefulWidget {
  String value;
  String imageUrl;
  Color fontColor;
  double itemWidth;
  tabelRowItem(
      {super.key,
      required this.value,
      this.imageUrl: '',
      this.itemWidth: 0.0,
      this.fontColor: Colors.black});

  @override
  State<tabelRowItem> createState() => _tabelRowItemState();
}

class _tabelRowItemState extends State<tabelRowItem> {
  List vals = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vals = toArray(widget.value);
    setState(() {
      vals;
    });
  }

  bool hasSquareBrackets(String str) {
    return str.contains('[') && str.contains(']');
  }

  List<String> toArray(String str) {
    if (hasSquareBrackets(str)) {
      List<String> arr =
          str.replaceAll('[', '').replaceAll(']', '').trim().split(',');
      return arr;
    } else {
      return [];
    }
  }

  CustomPopupMenuController _controller = CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72.h,
      width: widget.itemWidth == 0.0
          ? (720.w - 32.w * 2 - 10) / 3
          : widget.itemWidth,
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromRGBO(223, 223, 223, 1),
          width: 0.5,
        ),
      ),
      child: Center(
        child: Wrap(
          clipBehavior: Clip.antiAlias, // 设置裁剪方式
          children: [
            if (vals.isEmpty)
              Text(
                widget.value,
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                softWrap: true,
                style: TextStyle(fontSize: 12, color: widget.fontColor),
              ),
            if (vals.isNotEmpty)
              CustomPopupMenu(
                menuBuilder: () => ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    color: const Color(0xFF4C4C4C),
                    child: IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: vals
                            .map(
                              (item) => GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  child: Center(
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
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
                verticalMargin: -10,
                controller: _controller,
                child: Text(
                  widget.value,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  softWrap: true,
                  style: TextStyle(fontSize: 12, color: widget.fontColor),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// table头部分割显示元素
class DiagonalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color.fromRGBO(223, 223, 223, 1)
      ..strokeWidth = 1;
    canvas.drawLine(const Offset(0, 0), Offset(size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class DiagonalText extends StatelessWidget {
  final String text;
  final Color color;
  final bool isTop;

  DiagonalText({
    required this.text,
    this.color = Colors.black,
    this.isTop = true,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: isTop ? null : 20.w,
      right: isTop ? 20.w : null,
      top: isTop ? 10.h : null,
      bottom: isTop ? null : 10.h,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: 12,
        ),
      ),
    );
  }
}

class tableHeaderIndex extends StatelessWidget {
  String leftText;
  String rightText;
  double width;
  tableHeaderIndex({
    super.key,
    this.width: 0,
    this.leftText: 'table.parameter',
    this.rightText: 'table.address',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 72.h,
          width: width == 0 ? (720.w - 32.w * 2 - 10) / 3 : width,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromRGBO(223, 223, 223, 1),
              width: 0.5,
            ),
          ),
          child: CustomPaint(
            size: Size.infinite,
            painter: DiagonalPainter(),
          ),
        ),
        DiagonalText(
          text: tr(leftText),
          isTop: true,
        ),
        DiagonalText(
          text: tr(rightText),
          isTop: false,
        ),
      ],
    );
  }
}

List localshowType = [
  {
    "key": "System",
    "name": "table.System",
    "children": [
      "System.masterSn",
      "System.salveSnList",
      "System.systemIndoorNum",
      "System.protocol",
      // "System.systemCapacity",
      "System.mode",
      "System.settingIndoorNum",
      "System.checkIndoorNum",
      "System.workingIndoorNum",
      "System.isAllV8Indoor",
      "System.linkSetting",
      "System.indoorAvgTem",
      "System.systemEvaTem",
      "System.systemConTem",
      "System.tcMax",
      "System.teMin",
      "System.trafficUsage",
      "System.outdoor0Power",
      "System.silentMode",
      "System.powerLimit",
      "System.mpc",
      "System.priorModeSetting",
    ]
  },
  {
    "key": "OutdoorUnit",
    "name": "table.OutdoorUnit",
    "children": [
      // "OutdoorUnit.address",
      "OutdoorUnit.outdoorHorse",
      "OutdoorUnit.frequencyLimitingState",
      "OutdoorUnit.windSpeed1",
      "OutdoorUnit.windSpeed2",
      "OutdoorUnit.externalACVoltage",
      "OutdoorUnit.primaryCurrent",
      "OutdoorUnit.outdoorBlockageRate",
      "OutdoorUnit.errorCode",
      "OutdoorUnit.sysIdx",
      "OutdoorUnit.isV6",
      "OutdoorUnit.powerQuality",
      "OutdoorUnit.version"
    ]
  },
  {
    "key": "Compressor",
    "name": "table.Compressor",
    "children": [
      // "Compressor.address",
      "Compressor.highPressure",
      "Compressor.lowPressure",
      "Compressor.highPressureSaturationTemp",
      "Compressor.lowPressureSaturationTemp",
      "Compressor.compressor1Frequency",
      "Compressor.compressor2Frequency",
      "Compressor.directVoltage1",
      "Compressor.directVoltage2",
      "Compressor.compressorElectric1",
      "Compressor.compressorElectric2",
      "Compressor.compressorRunTime1",
      "Compressor.compressorRunTime2"
    ]
  },
  {
    "key": "Sensor",
    "name": "table.Sensor",
    "children": [
      // "Sensor.address",
      "Sensor.t4Temp",
      "Sensor.t3Temp",
      "Sensor.t5Temp",
      "Sensor.t6ATemp",
      "Sensor.t6BTemp",
      "Sensor.t8Temp",
      "Sensor.tlTemp",
      "Sensor.tg",
      "Sensor.radiatorTemp1",
      "Sensor.radiatorTemp2",
      "Sensor.t7C1Temp",
      "Sensor.t7C2Temp",
      "Sensor.t71Temp",
      "Sensor.t72Temp",
      "Sensor.superHeatTemp"
    ]
  },
  {
    "key": "ValveBody",
    "name": "table.ValveBody",
    "children": [
      // "ValveBody.address",
      "ValveBody.exva",
      "ValveBody.exvb",
      "ValveBody.exvc",
      "ValveBody.eevd",
      "ValveBody.sv5",
      "ValveBody.sv6",
      "ValveBody.sv7",
      "ValveBody.sv8A",
      "ValveBody.sv8B"
    ]
  },
  {
    "key": "IndoorUnitParameters",
    "name": "table.IndoorUnitParameters",
    "children": [
      // "IndoorUnitParameters.address",
      "IndoorUnitParameters.indoorType",
      "IndoorUnitParameters.indoorHouse",
      "IndoorUnitParameters.onOff",
      "IndoorUnitParameters.mode",
      "IndoorUnitParameters.fanSpeed",
      "IndoorUnitParameters.settingTemp",
      "IndoorUnitParameters.roomTemp",
      "IndoorUnitParameters.t2ATemp",
      "IndoorUnitParameters.t2Temp",
      "IndoorUnitParameters.t2BTemp",
      "IndoorUnitParameters.evx",
      "IndoorUnitParameters.errorCode",
      "IndoorUnitParameters.indoorSoftwareVersion",
      "IndoorUnitParameters.indoorSubSoftwareVersion",
      "IndoorUnitParameters.isV6",
      "IndoorUnitParameters.outletAirTemp",
      "IndoorUnitParameters.deviceName"
    ]
  }
];

List showType = [
  {
    "key": "System",
    "name": "table.System",
    "children": [
      "System.masterSn",
      "System.salveSnList",
      "System.systemIndoorNum",
      "System.protocol",
      // "System.systemCapacity",
      "System.mode",
      "System.settingIndoorNum",
      "System.checkIndoorNum",
      "System.workingIndoorNum",
      "System.isAllV8Indoor",
      "System.linkSetting",
      "System.indoorAvgTem",
      "System.systemEvaTem",
      "System.systemConTem",
      "System.tcMax",
      "System.teMin",
      "System.trafficUsage",
      "System.outdoor0Power",
      "System.silentMode",
      "System.powerLimit",
      "System.mpc",
      "System.priorModeSetting",
    ]
  },
  {
    "key": "OutdoorUnit",
    "name": "table.OutdoorUnit",
    "children": [
      // "OutdoorUnit.address",
      "OutdoorUnit.outdoorHorse",
      "OutdoorUnit.frequencyLimitingState",
      "OutdoorUnit.windSpeed1",
      "OutdoorUnit.windSpeed2",
      "OutdoorUnit.externalACVoltage",
      "OutdoorUnit.primaryCurrent",
      "OutdoorUnit.outdoorBlockageRate",
      "OutdoorUnit.errorCode",
      "OutdoorUnit.sysIdx",
      "OutdoorUnit.isV6",
      "OutdoorUnit.powerQuality",
      "OutdoorUnit.version"
    ]
  },
  {
    "key": "Compressor",
    "name": "table.Compressor",
    "children": [
      // "Compressor.address",
      "Compressor.highPressure",
      "Compressor.lowPressure",
      "Compressor.highPressureSaturationTemp",
      "Compressor.lowPressureSaturationTemp",
      "Compressor.compressor1Frequency",
      "Compressor.compressor2Frequency",
      "Compressor.directVoltage1",
      "Compressor.directVoltage2",
      "Compressor.compressorElectric1",
      "Compressor.compressorElectric2",
      "Compressor.compressorRunTime1",
      "Compressor.compressorRunTime2"
    ]
  },
  {
    "key": "Sensor",
    "name": "table.Sensor",
    "children": [
      // "Sensor.address",
      "Sensor.t4Temp",
      "Sensor.t3Temp",
      "Sensor.t5Temp",
      "Sensor.t6ATemp",
      "Sensor.t6BTemp",
      "Sensor.t8Temp",
      "Sensor.tlTemp",
      "Sensor.tg",
      "Sensor.radiatorTemp1",
      "Sensor.radiatorTemp2",
      "Sensor.t7C1Temp",
      "Sensor.t7C2Temp",
      "Sensor.t71Temp",
      "Sensor.t72Temp",
      "Sensor.superHeatTemp"
    ]
  },
  {
    "key": "ValveBody",
    "name": "table.ValveBody",
    "children": [
      // "ValveBody.address",
      "ValveBody.exva",
      "ValveBody.exvb",
      "ValveBody.exvc",
      "ValveBody.eevd",
      "ValveBody.sv5",
      "ValveBody.sv6",
      "ValveBody.sv7",
      "ValveBody.sv8A",
      "ValveBody.sv8B"
    ]
  },
  {
    "key": "IndoorUnitParameters",
    "name": "table.IndoorUnitParameters",
    "children": [
      // "IndoorUnitParameters.address",
      "IndoorUnitParameters.indoorType",
      "IndoorUnitParameters.indoorHouse",
      "IndoorUnitParameters.onOff",
      "IndoorUnitParameters.mode",
      "IndoorUnitParameters.fanSpeed",
      "IndoorUnitParameters.settingTemp",
      "IndoorUnitParameters.roomTemp",
      "IndoorUnitParameters.t2ATemp",
      "IndoorUnitParameters.t2Temp",
      "IndoorUnitParameters.t2BTemp",
      "IndoorUnitParameters.evx",
      "IndoorUnitParameters.errorCode",
      "IndoorUnitParameters.indoorSoftwareVersion",
      "IndoorUnitParameters.indoorSubSoftwareVersion",
      "IndoorUnitParameters.isV6",
      "IndoorUnitParameters.outletAirTemp",
      "IndoorUnitParameters.deviceName"
    ]
  }
];
String TemperatureUnit = '℃';
String OpenUnit = 'Pls';
String WindUnit = 'rpm';
String EVUnit = 'v';
String PressureUnit = 'Mpa';

Map typeUnit = {
  "IndoorUnitParameters.IC": "hp",
  "IndoorUnitParameters.ST": TemperatureUnit,
  "IndoorUnitParameters.IT": TemperatureUnit,
  "IndoorUnitParameters.T2AE": TemperatureUnit,
  "IndoorUnitParameters.T2E": TemperatureUnit,
  "IndoorUnitParameters.T2BE": TemperatureUnit,
  "IndoorUnitParameters.EO": OpenUnit,
  "System.avgT2T2B": TemperatureUnit,
  "System.targetTeS": TemperatureUnit,
  "System.targetTCS": TemperatureUnit,
  "System.TcMax": TemperatureUnit,
  "System.TeMin": TemperatureUnit,
  "System.flowUsage": "%",
  "OutdoorUnit.outdoorUnitCapacity": "hp",
  "OutdoorUnit.fanSpeed1": WindUnit,
  "OutdoorUnit.fanSpeed2": WindUnit,
  "OutdoorUnit.externalACVoltage": EVUnit,
  "OutdoorUnit.outdoorACVoltage": EVUnit,
  "System.powerLimitStatus": "%",
  "Compressor.highPressure": PressureUnit,
  "Compressor.lowPressure": PressureUnit,
  "Compressor.highPressureSaturationTemp": TemperatureUnit,
  "Compressor.lowPressureSaturationTemp": TemperatureUnit,
  "Compressor.compressor1Frequency": "HZ",
  "Compressor.compressor2Frequency": "HZ",
  "Compressor.compressor1DCVoltage": EVUnit,
  "Compressor.compressor2DCVoltage": EVUnit,
  "Compressor.compressor1Current": "AM",
  "Compressor.compressor2Current": "AM",
  "Compressor.compressor1RunningTime": "H",
  "Compressor.compressor2RunningTime": "H",
  "Sensor.environmentTemperatureT4": TemperatureUnit,
  "Sensor.outdoorHeatExchangerPipeTemperatureT3": TemperatureUnit,
  "Sensor.outdoorLiquidPipeTemperatureT5": TemperatureUnit,
  "Sensor.plateHeatExchangerInletTemperatureT6A": TemperatureUnit,
  "Sensor.plateHeatExchangerOutletTemperatureT6B": TemperatureUnit,
  "Sensor.outdoorHeatExchangerCoolingInletTemperatureT8": TemperatureUnit,
  "Sensor.outdoorHeatExchangerCoolingOutletTemperatureTL": TemperatureUnit,
  "Sensor.Tg": TemperatureUnit,
  "Sensor.outdoorElectronicControlRadiatorTemperatureNTC1": TemperatureUnit,
  "Sensor.outdoorElectronicControlRadiatorTemperatureNTC2": TemperatureUnit,
  "Sensor.compressor1ExhaustTemperatureT7C1": TemperatureUnit,
  "Sensor.compressor2ExhaustTemperatureT7C2": TemperatureUnit,
  "Sensor.compressor1ReturnTemperatureT71": TemperatureUnit,
  "Sensor.compressor2ReturnTemperatureT72": TemperatureUnit,
  "Sensor.t4Temp": TemperatureUnit,
  "Sensor.t3Temp": TemperatureUnit,
  "Sensor.t5Temp": TemperatureUnit,
  "Sensor.t6ATemp": TemperatureUnit,
  "Sensor.t6BTemp": TemperatureUnit,
  "Sensor.t8Temp": TemperatureUnit,
  "Sensor.tlTemp": TemperatureUnit,
  "Sensor.radiatorTemp1": TemperatureUnit,
  "Sensor.radiatorTemp2": TemperatureUnit,
  "Sensor.t7C1Temp": TemperatureUnit,
  "Sensor.t7C2Temp": TemperatureUnit,
  "Sensor.t71Temp": TemperatureUnit,
  "Sensor.t72Temp": TemperatureUnit,
  "Sensor.outdoorExhaustSuperheat": TemperatureUnit,
  "ValveBody.EXVAOpening": OpenUnit,
  "ValveBody.EXVBOpening": OpenUnit,
  "ValveBody.EXVCOpening": OpenUnit,
  "ValveBody.EEVDOpening": OpenUnit,
};
