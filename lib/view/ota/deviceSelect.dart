import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/compent/tapContainer.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:fluoroscopy_tool/view/ota/publicFunction.dart';
import 'package:fluoroscopy_tool/view/waterPumpInspection/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import '../../store/globalData.dart';
import 'firmwareSelect.dart';

class deviceSelect extends StatefulWidget {
  deviceSelect({super.key});

  @override
  State<deviceSelect> createState() => _copybasepageState();
}

class _copybasepageState extends State<deviceSelect> {
  final otaController _selfController = Get.put(otaController());
  final deviceInfoController _deviceInfoController = Get.find();
  int active = 0;
  List selectID = [];
  List getFirmwareVersion = [];
  String _key = DateTime.now().millisecondsSinceEpoch.toString();
  static const _selfplatform =
      MethodChannel('samples.flutter.dev/MbtBasicOtaHandler');
  _init() async {
    if (getFirmwareVersion.contains(active)) {
      return;
    }
    EasyLoading.show(status: 'loading...');
    try {
      var getSearchHistories = await _selfplatform
          .invokeMethod('getFirmwareVersion', {"deviceType": active});
      var data = jsonDecode(getSearchHistories);
      getFirmwareVersion.add(active);
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          _key = DateTime.now().millisecondsSinceEpoch.toString();
        });
        EasyLoading.dismiss();
      });
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    EasyLoading.dismiss();
    super.dispose();
  }

  setselect(address) {
    if (selectID.contains(address)) {
      selectID.remove(address);
    } else {
      selectID.add(address);
    }
    setState(() {
      selectID;
    });
    _selfController.setSelectID(selectID);
  }

  _selectAll() {
    List setList = [];
    if (active == 0) {
      for (var element in _deviceInfoController.outdoorEntityList.value) {
        setList.add(element["address"]);
      }
    } else {
      for (var element in _deviceInfoController.indoorEntityList.value) {
        setList.add(element["address"]);
      }
    }
    setState(() {
      selectID = setList;
    });
    _selfController.setSelectID(setList);
  }

  bool isnetconnecd = false;
  Future<bool> _checkNet(show) async {
    if (show) {
      EasyLoading.show(status: 'loading...');
    }
    try {
      final response = await Dio().get('https://${apiHost}/');
      isnetconnecd = response.statusCode == 200;
      EasyLoading.dismiss();
      if (!isnetconnecd) {
        EasyLoading.showError(tr("netword.empty"));
      }
      setState(() {
        isnetconnecd;
      });
      return isnetconnecd;
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(tr("netword.empty"));
      return false;
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
            'ota.title',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [
            TextButton(
                onPressed: () {
                  _selectAll();
                },
                child: Text("selectAll").tr())
          ],
        ),
        body: GetBuilder<deviceInfoController>(
            init: deviceInfoController(),
            builder: (_) => Container(
                  width: 720.w,
                  height: 1280.h,
                  key: ValueKey(_key),
                  color: const Color.fromRGBO(244, 244, 244, 1),
                  padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
                  child: Column(
                    children: [
                      Expanded(
                          child: tapContariner(
                        activechange: (val) {
                          setState(() {
                            selectID = [];
                            active = val;
                          });
                          _init();
                          _selfController.clearSelectID();
                        },
                        activeIndex: active,
                        tap: List.generate(
                            2,
                            (index) => tr(index == 0 ? "ota.ODU" : "ota.IDU",
                                    namedArgs: {
                                      "val": index == 0
                                          ? "${_deviceInfoController.outdoorEntityList.length}"
                                          : "${_deviceInfoController.indoorEntityList.length}"
                                    })),
                        child: [
                          ListView.builder(
                              itemCount: _deviceInfoController
                                  .outdoorEntityList.length,
                              itemBuilder: (context, index) => InkWell(
                                    onTap: () {
                                      setselect(_deviceInfoController
                                          .outdoorEntityList[index]['address']);
                                    },
                                    child: selectbox(
                                      onclick: () {
                                        setselect(_deviceInfoController
                                                .outdoorEntityList[index]
                                            ['address']);
                                      },
                                      type: 0,
                                      item: _deviceInfoController
                                          .outdoorEntityList[index],
                                    ),
                                  )),
                          ListView.builder(
                              itemCount:
                                  _deviceInfoController.indoorEntityList.length,
                              itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    setselect(_deviceInfoController
                                        .indoorEntityList[index]['address']);
                                  },
                                  child: selectbox(
                                    onclick: () {
                                      setselect(_deviceInfoController
                                          .indoorEntityList[index]['address']);
                                    },
                                    type: 1,
                                    item: _deviceInfoController
                                        .indoorEntityList[index],
                                  ))),
                        ],
                      )),
                      Container(
                        height: 57,
                        padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                        child: Center(
                          child: submitButton(
                            isActive: selectID.isNotEmpty,
                            label: tr('ota.list.btn'),
                            onClick: () async {
                              if (selectID.isNotEmpty) {
                                _selfController.setSelectType(active);
                                EasyLoading.dismiss();
                                bool _net = await _checkNet(false);
                                if (_net) Get.to(() => firmwareSelect());
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                )));
  }
}

class selectbox extends StatefulWidget {
  int type;
  var item;
  Function onclick;
  selectbox({
    super.key,
    required this.type,
    required this.item,
    required this.onclick,
  });

  @override
  State<selectbox> createState() => _selectboxState();
}

class _selectboxState extends State<selectbox> {
  var showingItem;

  imageTurn(model) {
    if (model == 'V8') {
      return 'public/images/local/v8.png';
    }
    return 'public/images/local/outdoor.png';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      showingItem = widget.item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<otaController>(
        init: otaController(),
        builder: (_) => Container(
              margin: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
              padding: EdgeInsets.fromLTRB(16.w, 36.h, 16.w, 36.h),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: Color.fromRGBO(223, 223, 223, 1),
                      width: 0.5,
                    ),
                  )),
              width: 720.w,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                    child: Image.asset(
                      widget.type == 0
                          ? imageTurn(showingItem["model"])
                          : showingItem['indoorType'] != null
                              ? 'public/images/V8/${showingItem['indoorType']}.png'
                              : 'public/images/V8/IduType_99.png',
                      width: 124.w,
                    ),
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '${showingItem['address'] ?? "--"}#',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          if (showingItem['onOff'] != null)
                            Text(
                              ' · ${showingItem['onOff'] == "OFF" ? tr("device.checkData.off") : tr("device.checkData.on")}',
                              style: TextStyle(
                                  color: showingItem['onOff'] == "OFF"
                                      ? const Color.fromRGBO(153, 153, 153, 1)
                                      : const Color.fromRGBO(6, 184, 0, 1),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Text("${tr('ota.list.show1')}: ",
                                    style: labelStyle()),
                                Expanded(
                                    child: Text(
                                        showingItem['firmwareVersion'] ?? "--",
                                        style: labelStyle()))
                              ],
                            ),
                          ),
                          if (widget.type == 0)
                            Row(
                              children: [
                                Text("${tr('ota.list.show2')}: ",
                                    style: labelStyle()),
                                Text(showingItem['sn'] ?? "--",
                                    style: labelStyle())
                              ],
                            )
                        ],
                      ),
                    ],
                  )),
                  RoundCheckBox(
                    key: ValueKey(
                        "${showingItem['address']}_${_.selectID.value.length}"),
                    isChecked:
                        _.selectID.value.contains(showingItem['address']),
                    onTap: (sel) {
                      widget.onclick();
                    },
                    size: 20,
                    checkedWidget: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                    checkedColor: Theme.of(context).colorScheme.secondary,
                    border: Border.all(
                        // width: 1,
                        color: Theme.of(context).colorScheme.secondary),
                  )
                ],
              ),
            ));
  }
}
