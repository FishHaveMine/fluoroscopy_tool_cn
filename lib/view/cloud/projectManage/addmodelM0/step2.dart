import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/cloud/projectManage/addmodelM0/step3.dart';
import 'package:fluoroscopy_tool/view/cloud/projectManage/ibutler/ibutler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import 'publicFunction.dart';

class addmodelM0_step2 extends StatefulWidget {
  addmodelM0_step2({super.key});

  @override
  State<addmodelM0_step2> createState() => _addmodelM0_step2State();
}

class _addmodelM0_step2State extends State<addmodelM0_step2> {
  final MOaddController _selectController = Get.put(MOaddController());
  static const _selfplatform =
      MethodChannel('samples.flutter.dev/getProjectHandler');

  Map<String, List> typemap = {
    "type1": ["美的", "竞品"],
    "type2": [
      "V4+",
      "V5",
      "V6",
      "V7",
    ],
    "type3": [
      // "modifyType1", "modifyType2", "modifyType3"
    ],
  };

  List otherDeviceType = [
    {"code": "other", "value": "其他"},
    {"code": "dakin", "value": "大金"},
    {"code": "gree", "value": "格力"},
    {"code": "haier", "value": "海尔"},
    {"code": "hisense", "value": "海信"},
    {"code": "hitachi", "value": "日立"},
    // {"code": "midea", "value": "美的"},
    {"code": "toshiba", "value": "东芝"}
  ];

  _settype1(val) {
    _selectController.updateDeviceType(val);
    _selectController.updateSeries("");
    _selectController.updateModifyType("");
    if (val == "竞品") {
      typemap["type3"] = ["modifyType1", "modifyType2"];
      _selectController.updateSeries("--");
      _selectController.updateModifyType("modifyType1");

      setState(() {
        typemap;
      });
    }
    _refrshtytip();
  }

  Map<String, String> tylist = {
    "modifyType4": 'i管家控制:\n通过接入无传感器版本旧改云联装置，实现v4+/v5x等设备i管家集控。\n\n',
    "modifyType1":
        "简易喷淋:\n室外机（含竞品）需加装喷淋装置，安装喷淋传感器（T4/压缩机排气温度）如外机为V4+或V5，可实现云集控功能。\n\n",
    "modifyType2":
        "旧改分析:\n针对V4+或V5室外机需加装旧改分析传感器（高压、低压、液管温度和压缩机回气温度）可实现云集控和能耗分析功能。\n\n",
    "modifyType3":
        "智慧喷淋:\n针对V4+V5室外机需加装喷淋装置，喷淋传感器（高压、低压、液管温度和压缩机回气温度）可实现云管喷淋，云集控和能耗分析功能。\n\n",
  };
  String tytip = "";
  _settype2(val) {
    _selectController.updateSeries(val);
    if (!["V4+", "V5"].contains(val)) {
      typemap["type3"] = ["modifyType1"];
      _selectController.updateModifyType("modifyType1");
      setState(() {
        typemap;
      });
    } else {
      _selectController.updateModifyType("");
      typemap["type3"] = [
        "modifyType1",
        "modifyType2",
        "modifyType3",
        "modifyType4"
      ];
      setState(() {
        typemap;
      });
    }

    _refrshtytip();
  }

  _refrshtytip() {
    tytip = "";
    for (var element in typemap["type3"]!) {
      print("element --  $element   ${tylist[element]}");
      tytip = tytip + tylist[element]!;
    }
    setState(() {
      tytip;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MOaddController>(
        init: MOaddController(),
        builder: (_) => Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.chevron_left,
                      color: Colors.black, size: 36)),
              title: const Text(
                'MOadd.step1.title',
                style: TextStyle(color: Colors.black),
              ).tr(),
              centerTitle: true,
              actions: [],
            ),
            body: Container(
              width: 720.w,
              height: 1280.h,
              color: const Color.fromRGBO(244, 244, 244, 1),
              padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
              child: Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: 3,
                      itemBuilder: ((context, index) => Container(
                            padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (index != 1 ||
                                    (_selectController
                                                .jsonObject["deviceType"] ==
                                            "美的" &&
                                        index == 1))
                                  Container(
                                    height: 44,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Row(
                                      children: [
                                        Text(
                                          '*',
                                          style: normalTextBlack(
                                              fontcolor: Colors.red),
                                        ).tr(),
                                        Text(
                                          'MOadd.step2.type${index + 1}',
                                          style: normalTextBlack(),
                                        ).tr(),
                                        if (index == 2)
                                          Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(4, 0, 0, 0),
                                            child: TooltipOnClick(msg: tytip),
                                          )
                                      ],
                                    ),
                                  ),
                                for (var item in typemap['type${index + 1}']!)
                                  if (index == 0 ||
                                      index == 2 ||
                                      (_selectController
                                                  .jsonObject["deviceType"] ==
                                              "美的" &&
                                          index == 1))
                                    InkWell(
                                      onTap: () {
                                        if (index == 0) {
                                          _settype1(item);
                                        }
                                        if (index == 1) {
                                          _settype2(item);
                                        }
                                        if (index == 2) {
                                          _selectController
                                              .updateModifyType(item);
                                        }
                                      },
                                      child: Container(
                                        height: 48,
                                        width: 720.w,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Color.fromRGBO(
                                                    223, 223, 223, 1),
                                                width: 0.5,
                                              ),
                                            )),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              16, 8, 16, 8),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                item,
                                                style: normalTextBlack(
                                                    lineheight: 1),
                                              ).tr(),
                                              if (index == 0 &&
                                                  _.jsonObject['deviceType'] ==
                                                      item)
                                                RoundCheckBox(
                                                  isChecked: true,
                                                  onTap: null,
                                                  size: 16,
                                                  checkedWidget: const Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                    size: 14,
                                                  ),
                                                  disabledColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                  checkedColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                  border: Border.all(
                                                      // width: 1,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary),
                                                ),
                                              if (index == 1 &&
                                                  _.jsonObject['series'] ==
                                                      item)
                                                RoundCheckBox(
                                                  isChecked: true,
                                                  onTap: null,
                                                  size: 16,
                                                  checkedWidget: const Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                    size: 14,
                                                  ),
                                                  disabledColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                  checkedColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                  border: Border.all(
                                                      // width: 1,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary),
                                                ),
                                              if (index == 2 &&
                                                  _.jsonObject['modifyType'] ==
                                                      item)
                                                RoundCheckBox(
                                                  isChecked: true,
                                                  onTap: null,
                                                  size: 16,
                                                  checkedWidget: const Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                    size: 14,
                                                  ),
                                                  disabledColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                  checkedColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                  border: Border.all(
                                                      // width: 1,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                              ],
                            ),
                          ))),
                  if (_.jsonObject['deviceType'] == '竞品')
                    Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Text(
                            '*',
                            style: normalTextBlack(fontcolor: Colors.red),
                          ).tr(),
                          Text(
                            '品牌名称',
                            style: normalTextBlack(),
                          ).tr(),
                        ],
                      ),
                    ),
                  Expanded(
                      child: _.jsonObject['deviceType'] == '竞品'
                          ? ListView.builder(
                              itemCount: otherDeviceType.length,
                              itemBuilder: ((context, index) => InkWell(
                                    onTap: () {
                                      _.updateProductBrand(
                                          otherDeviceType[index]['code']);
                                    },
                                    child: Container(
                                      height: 48,
                                      width: 720.w,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Color.fromRGBO(
                                                  223, 223, 223, 1),
                                              width: 0.5,
                                            ),
                                          )),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 8, 16, 8),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              otherDeviceType[index]['value'],
                                              style: normalTextBlack(
                                                  lineheight: 1),
                                            ).tr(),
                                            if (otherDeviceType[index]
                                                    ['code'] ==
                                                _.jsonObject['productBrand'])
                                              RoundCheckBox(
                                                isChecked: true,
                                                onTap: null,
                                                size: 16,
                                                checkedWidget: const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 14,
                                                ),
                                                disabledColor: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                checkedColor: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                border: Border.all(
                                                    // width: 1,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )))
                          : Container()),
                  Container(
                    height: 57,
                    padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                    child: Center(
                      child: submitButton(
                        isActive: () {
                          final deviceType = _.jsonObject['deviceType'];
                          if (deviceType == "竞品") {
                            return _.jsonObject['series'] != "" &&
                                _.jsonObject['deviceType'] != "" &&
                                _.jsonObject['modifyType'] != "" &&
                                _.jsonObject['productBrand'] != "";
                          } else {
                            // 默认情况，保持原有逻辑
                            return _.jsonObject['series'] != "" &&
                                _.jsonObject['deviceType'] != "" &&
                                _.jsonObject['modifyType'] != "";
                          }
                        }(),
                        label: tr('MOadd.step2.btn'),
                        onClick: () async {
                          final deviceType = _.jsonObject['deviceType'];
                          bool isValid = false;
                          if (deviceType == "竞品") {
                            isValid = _.jsonObject['series'] != "" &&
                                _.jsonObject['deviceType'] != "" &&
                                _.jsonObject['modifyType'] != "" &&
                                _.jsonObject['productBrand'] != "";
                          } else {
                            // 默认情况，保持原有逻辑
                            isValid = _.jsonObject['series'] != "" &&
                                _.jsonObject['deviceType'] != "" &&
                                _.jsonObject['modifyType'] != "";
                          }
                          if (isValid) {
                            Get.to(() => addmodelM0_step3());
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
