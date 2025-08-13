import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';
import 'public/InstallationInfo.dart';
import 'public/publicFunction.dart';
import 'public/publicObject.dart';

class ReportStep3Page extends StatefulWidget {
  VoidCallback next;
  bool ispreview = false;
  VoidCallback pre;

  ReportStep3Page(
      {super.key,
      required this.pre,
      required this.next,
      this.ispreview = false});
  @override
  _ReportStep3PageState createState() => _ReportStep3PageState();
}

class _ReportStep3PageState extends State<ReportStep3Page> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  static const platform =
      MethodChannel('samples.flutter.dev/waterpumbBasicHandler');
  bool _inloading = false;
  toGetRunningData(_deviceInfoController) async {
    if (_inloading) return;
    _inloading = true;
    EasyLoading.show(status: 'loading...');
    try {
      int tosend = 3;
      if (_deviceInfoController.form["debugModel"].val == "离心机组") {
        tosend = 5;
      }
      if (_deviceInfoController.form["debugModel"].val == "水冷螺杆机组") {
        tosend = 9;
      }
      var GenCode =
          await platform.invokeMethod('getformdata', <String, dynamic>{
        "step": tosend,
      });
      _inloading = false;
      var data = jsonDecode(GenCode);
      print("-------------- toGetRunningData 3 --------------");
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      var dataMap = data['data'];
      print("dataMap: $dataMap");
      var dataMapToPonit = {
        "targetTemp": "coolingHeatingTargetTemp",
        "evaporatorControlTemperature": "evaporatorActualControlTemp",
        "exitPauseTemperatureDifference": "exitPauseTempDiff",
        "enterPauseTemperatureDifference": "enterPauseTempDiff",
        "capacityRegulationTemperatureDifference":
            "capacityAdjustmentKeepTempDiff",
        "fanRegulatesTemperatureDifference": "coolingTowerFanAdjustTempDiff",
        "coolingTowerFanUnit1ShutdownTemperature":
            "coolingTowerFanUnit1ShutdownTemperature",
        "coolingTowerFanUnit1OpeningTemperature":
            "coolingTowerFanUnit1OpeningTemperature",
        "coolingTowerFanUnit2ShutdownTemperature":
            "coolingTowerFanUnit2ShutdownTemperature",
        "coolingTowerFanUnit2OpeningTemperature":
            "coolingTowerFanUnit2OpeningTemperature",
        "controlMode": "controlMode",
        "runningMode": "operationMode",
        "inletAndOutletWaterControl": "waterControl",
        "ratedCurrentOfTheHost": "ratedCurrent",
        // "minimumAtmosphericPressure": "最低大气压力",
        "pressureSensorUpperLimitSetting": "pressureSensorUpperLimit",
        "targetLiquidLevelOfEvaporator": "evaporatorTargetLiquidLevel",
        "fullLoadPowerRefrigeration": "coolingFullLoadPower",
        "refrigerationAndIceStoragePower": "iceStorageFullLoadPower",
        "compressorShutdownInterval": "compressorShutdownInterval",
        "compressorStarInterval": "startupInterval",
        "fastStartReadySignalJudgmentDelay": "quickStartSignalDelay",
        "inverterMainControlSoftwareVersion": "inverter1SoftwareVersion",
        "compressorVersion": "compressor1Version",
        "maglevVersion": "maglev1Version",
        "az1": "compressor1AZ",
        "fx1": "compressor1FX",
        "fy1": "compressor1FY",
        "rx1": "compressor1RX",
        "ry1": "compressor1RY",
        "az2": "compressor2AZ",
        "fx2": "compressor2FX",
        "fy2": "compressor2FY",
        "rx2": "compressor2RX",
        "ry2": "compressor2RY",
        "az3": "compressor3AZ",
        "fx3": "compressor3FX",
        "fy3": "compressor3FY",
        "rx3": "compressor3RX",
        "ry3": "compressor3RY"
      };
      if (tosend == 5) {
        dataMapToPonit = pointmap;
      }
      if (tosend == 9) {
        dataMapToPonit = pointmap_waterCooledChiller;
      }
      for (var key in dataMapToPonit.keys) {
        _deviceInfoController.form['${dataMapToPonit[key]}'].val =
            "${dataMap[key] ?? ""}";
      }
      _deviceInfoController.update();

      EasyLoading.dismiss();
      EasyLoading.showSuccess("读取成功");
    } catch (e) {
      print("toGetRunningData showError: $e");

      _inloading = false;
      EasyLoading.dismiss();
      EasyLoading.showError("读取失败: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InstallController>(
        builder: (_) => Container(
              padding: const EdgeInsets.all(0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (!widget.ispreview)
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              const Text(
                                "RS485本地获取",
                                style: TextStyle(fontSize: 14),
                              ),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  // TODO: implement
                                  toGetRunningData(_);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text("读取"),
                              ),
                            ],
                          )),
                    ..._.step3.map((field) {
                      return builditemByType(field, widget.ispreview);
                    }).toList(),
                    const SizedBox(height: 20),
                    if (!widget.ispreview)
                      Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    widget.pre();
                                  },
                                  child: const Text('上一步'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      bool ispass = _.validateStep(_.step3);
                                      if (!ispass) {
                                        // 进入下一步逻辑
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text('请输入必填项')));
                                        return;
                                      }
                                      widget.next();
                                    } else {
                                      // 进入下一步逻辑
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text('请输入必填项')));
                                    }
                                  },
                                  child: const Text('下一步'),
                                ),
                              ),
                            ],
                          )),
                  ],
                ),
              ),
            ));
  }
}
