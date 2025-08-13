import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';
import 'com/runningdata.dart';
import 'public/publicFunction.dart';
import 'public/publicObject.dart';

class ReportStep4Page extends StatefulWidget {
  bool ispreview = false;
  VoidCallback next;
  VoidCallback pre;

  ReportStep4Page(
      {super.key,
      required this.pre,
      required this.next,
      this.ispreview = false});
  @override
  _ReportStep4PageState createState() => _ReportStep4PageState();
}

class _ReportStep4PageState extends State<ReportStep4Page>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const platform =
      MethodChannel('samples.flutter.dev/waterpumbBasicHandler');
  final List<String> tabs = ['记录一', '记录二', '记录三', '记录四', '记录五', '记录六'];

  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        int newIndex = _tabController.index;

        // ✳️ 判断条件
        if (!canSwitchTo(newIndex)) {
          // ❌ 不满足条件：退回原 index
          Future.delayed(Duration.zero, () {
            _tabController.index = _currentIndex;
          });
        } else {
          // ✅ 允许切换
          setState(() {
            _currentIndex = newIndex;
          });
        }
      }
    });
  }

  bool canSwitchTo(int newIndex) {
    // 你自己的条件判断逻辑，比如验证表单、检查状态等
    return !widget.ispreview ??
        _runningFormKey.currentState?.validate() ??
        false;
  }

  bool _inloading = false;
  toGetRunningData(_deviceInfoController) async {
    if (_inloading) return;
    _inloading = true;
    EasyLoading.show(status: 'loading...');
    try {
      int tosend = 4;
      if (_deviceInfoController.form["debugModel"].val == "离心机组") {
        tosend = 6;
      }
      if (_deviceInfoController.form["debugModel"].val == "水冷螺杆机组") {
        tosend = 10;
      }

      var GenCode =
          await platform.invokeMethod('getformdata', <String, dynamic>{
        "step": tosend,
      });
      _inloading = false;
      var data = jsonDecode(GenCode);

      print("-------------- toGetRunningData 4 --------------");
      print("toGetRunningData showSuccess: $data");
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      _deviceInfoController.form['logTime${_currentIndex + 1}'].val =
          formattedDate;
      var dataMap = data['data'];
      print("dataMap: $dataMap");
      var dataMapToPonit = {
        "inletTemperatureOfChilledWater": "chilledWaterInletTemp",
        "outletTemperatureOfChilledWater": "chilledWaterOutletTemp",
        "coolingWaterInletTemperature": "coolingWaterInletTemp",
        "coolingWaterOutletTemperature": "coolingWaterOutletTemp",
        "evaporatorEvaporationPressure": "evaporatorEvaporationPressure",
        "evaporatorSaturationTemperature": "evaporatorSaturationTemp",
        "temperatureDifferenceAtTheEvaporatorEnd": "evaporatorTerminalTempDiff",
        "condenserCondensationPressure": "condenserCondensationPressure",
        "condenserSaturationTemperature": "condenserSaturationTemp",
        "temperatureDifferenceAtTheCondenserEnd": "condenserTerminalTempDiff",
        "guideVaneOpening1": "guideVane1Opening",
        "guideVaneOpening2": "guideVane2Opening",
        "guideVaneOpening3": "guideVane3Opening",
        "powerPercentage": "currentPercentage",
      };
      if (tosend == 6) {
        dataMapToPonit = runningMap;
      }
      if (tosend == 10) {
        dataMapToPonit = runningMap_waterCooledChiller;
      }
      for (var key in dataMapToPonit.keys) {
        _deviceInfoController.form['${dataMapToPonit[key]}${_currentIndex + 1}']
            .val = "${dataMap[key] ?? ""}";
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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _runningFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InstallController>(
        builder: (_) => Container(
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: const Text(
                        '机组运行数据记录',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      )),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color.fromRGBO(238, 238, 238, 1), // 边框颜色
                          width: 1.0, // 边框宽度
                          style: BorderStyle.solid, // 边框样式
                        ),
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      indicatorColor: const Color.fromRGBO(0, 128, 255, 1),
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      indicatorWeight: 3,
                      tabs: tabs.map((label) => Tab(text: label)).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                  runningdata(
                    key: ValueKey('_currentIndex$_currentIndex'),
                    showing: _currentIndex + 1,
                    formKey: _runningFormKey, // ⬅️ 传入 key
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          ..._.step4.map((field) {
                            return builditemByType(field, widget.ispreview);
                          }).toList(),
                        ],
                      )),
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
                                    bool ispass = _.validateStep(_.step4);
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
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
            ));
  }
}
