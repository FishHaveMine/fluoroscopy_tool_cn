import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/bottomSelectSheet.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/cloud/publicFunction.dart';
import 'package:fluoroscopy_tool/view/systemCapabilityAnalysis/step2/systemDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/avd.dart';

import 'package:get/get.dart';

class SprinklerSetting extends StatefulWidget {
  SprinklerSetting({super.key});

  @override
  State<SprinklerSetting> createState() => _SprinklerSettingState();
}

class _SprinklerSettingState extends State<SprinklerSetting> {
  final cloudProjectController _cloudProjectController = Get.find();

  static const platform = MethodChannel('samples.flutter.dev/SprinklerSetting');
  var needset = {};
  bool haveset = false;
  init({String? languageCode}) async {
    EasyLoading.show(status: 'loading...');
    try {
      needset = {};
      String nid = _cloudProjectController.selectDevice.value["nid"];
      String sn = _cloudProjectController.selectDevice.value["sn"].isEmpty
          ? _cloudProjectController.selectDevice.value["gatewaySn"]
          : _cloudProjectController.selectDevice.value["sn"];

      var init_history = await platform
          .invokeMethod('getAppFluorineMachineEnergyHandler.getSpray', {
        "sn": sn,
      });

      var indoorHistorydata = jsonDecode(init_history);
      for (var element in indoorHistorydata["data"]) {
        needset[element["name"]] = {
          "val": element["value"],
          "title": element["title"].toString() != "{}"
              ? element["title"][languageCode]
              : element["name"],
          "op": processValues(element['values'])
        };
      }
      setState(() {
        needset;
      });
      EasyLoading.dismiss();
    } catch (e) {
      print(e);
      setState(() {
        needset;
      });
      EasyLoading.dismiss();
    }
  }

  _sendcon() async {
    EasyLoading.show(status: 'loading...');
    try {
      // print(needset);
      // return;

      String nid = _cloudProjectController.selectDevice.value["nid"];
      String sn = _cloudProjectController.selectDevice.value["sn"].isEmpty
          ? _cloudProjectController.selectDevice.value["gatewaySn"]
          : _cloudProjectController.selectDevice.value["sn"];
      String sid =
          _cloudProjectController.snJumpModule.value["systemId"].toString();
      var init_history = await platform
          .invokeMethod('getAppFluorineMachineEnergyHandler.spray', {
        "systemId": int.parse(sid),
        "sn": sn,
        "nid": nid,
        "gearSetting": int.parse(needset["gearSetting"]["val"].toString()),
        "sprayStartTemp":
            double.parse(needset["sprayStartTemp"]["val"].toString()),
        "enableSetting": int.parse(needset["onOff"]["val"].toString())
      });

      var backdata = jsonDecode(init_history);
      print("backdata: $backdata");
      EasyLoading.dismiss();
      if (!backdata['success']) {
        EasyLoading.showError(backdata['errorMsg']);
      } else {
        // ignore: use_build_context_synchronously
        EasyLoading.showSuccess(tr("oldChangecard.title2setting") +
            tr("unlockhistory.unlocksuccess"));
        // init();
      }
    } catch (e) {
      print(e);
      setState(() {
        needset;
      });
      EasyLoading.dismiss();
    }
  }

  List processValues(values) {
    if (values.toString() != "{}") {
      return values.map((item) {
        return {
          "label": item['desc']['cn'], // 使用中文描述
          "value": item['val']
        };
      }).toList();
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String? languageCode =
          EasyLocalization.of(context)?.currentLocale?.languageCode;
      init(languageCode: languageCode);
    });
  }

  @override
  void dispose() {
    // 移除滚动监听器
    EasyLoading.dismiss();
    super.dispose();
  }

  updataVal(key, val) {
    setState(() {
      needset[key]["val"] = val;
      haveset = true;
    });
  }

  filterOp(key) {
    try {
      if (needset[key]!['val'] == null || needset[key]!['val'] == "") {
        return "--";
      }
      String _val = needset[key]!['val'].toString();
      var filter = needset[key]!['op']
          .where((e) =>
              e["value"].toString() == _val || e["value1"].toString() == _val)
          .toList();
      if (filter != null) {
        return filter[0]["label"];
      }
      return "--";
    } catch (e) {
      return "--";
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
            'oldChangecard.title2setting',
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
              Expanded(
                  child: Column(
                children: needset.isNotEmpty
                    ? [
                        for (var key in needset.keys)
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.fromLTRB(32.w, 0, 32.w, 0),
                            child: Row(children: [
                              // ignore: prefer_interpolation_to_compose_strings
                              Text(needset[key]["title"]).tr(),
                              Expanded(
                                  key: ValueKey("needset_$key"),
                                  child: needset[key]["op"].isNotEmpty
                                      ? InkWell(
                                          onTap: () async {
                                            Future<sheetBack?> selectedIndex =
                                                await showCustomModalBottomSheet(
                                                    isMultiple: false,
                                                    context,
                                                    [...needset[key]["op"]],
                                                    // ignore: unrelated_type_equality_checks
                                                    baseValue: [
                                                      needset[key]!['val']
                                                          .toString()
                                                    ],
                                                    titleName: "");
                                            selectedIndex.then((value) => {
                                                  if (value != null &&
                                                      // ignore: unrelated_type_equality_checks
                                                      value.baseValue![0] != -1)
                                                    {
                                                      updataVal(
                                                          key,
                                                          value.baseValue![0]
                                                              .toString())
                                                    }
                                                });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  filterOp(key),
                                                  textAlign: TextAlign.end,
                                                  style: normalText(),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 5, 0, 0),
                                                  child: Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Color.fromRGBO(
                                                        140, 140, 140, 1),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  if (double.parse(
                                                          needset[key]!['val']
                                                              .toString()) >
                                                      16) {
                                                    updataVal(
                                                        key,
                                                        (double.parse(needset[
                                                                            key]![
                                                                        'val']
                                                                    .toString()) -
                                                                0.5)
                                                            .toString());
                                                  }
                                                },
                                                child: const Icon(
                                                  Icons.remove_circle,
                                                  color: Color.fromRGBO(
                                                      140, 140, 140, 1),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 80,
                                                child: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8),
                                                    child: Text(
                                                      "${needset[key]!['val'].toString()} ℃",
                                                      style: normalText(
                                                          lineheight: 1.2),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    if (double.parse(
                                                            needset[key]!['val']
                                                                .toString()) <
                                                        36) {
                                                      updataVal(
                                                          key,
                                                          (double.parse(needset[
                                                                              key]![
                                                                          'val']
                                                                      .toString()) +
                                                                  0.5)
                                                              .toString());
                                                    }
                                                  },
                                                  child: const Icon(
                                                    Icons.add_circle,
                                                    color: Color.fromRGBO(
                                                        140, 140, 140, 1),
                                                  ))
                                            ],
                                          )))
                            ]),
                          )
                      ]
                    : [],
              )),
              Container(
                height: 57,
                padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                child: Center(
                  child: submitButton(
                    isActive: haveset,
                    label: tr('SprinklerSetting.btn'),
                    onClick: () async {
                      _sendcon();
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
