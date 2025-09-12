import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/snInput.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/store/intInput.dart';
import 'package:fluoroscopy_tool/style/color.dart';
import 'package:fluoroscopy_tool/style/index.dart' hide ErrorTip;
import 'package:fluoroscopy_tool/view/afterSalesReplacement/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: depend_on_referenced_packages
import 'package:get/get.dart';

import '../style.dart';
import 'parametersSelectMap.dart';

class getDeviceParameter extends StatefulWidget {
  VoidCallback preStep;
  VoidCallback nextStep;
  getDeviceParameter(
      {super.key, required this.nextStep, required this.preStep});

  @override
  State<getDeviceParameter> createState() => _getDeviceParameterState();
}

class _getDeviceParameterState extends State<getDeviceParameter> {
  final MethodChannel methodChannel = const MethodChannel('scan.data');
  static const platform = MethodChannel('samples.flutter.dev/battery');
  static const _selfplatform =
      MethodChannel('samples.flutter.dev/afterSalesReplacement');
  int showpage = 0;

  TextEditingController _controller = TextEditingController();
  String sn = '';
  openscan() async {
    try {
      await platform.invokeMethod('SCANNER_TRIG');
    } on PlatformException catch (e) {
      print("Failed to SCANNER_TRIG: '${e.message}'.");
    }
  }

  Map propertyNames = {};
  /**
   * networkAddress 0-7
   * outdoorAddress 0-3
   * indoorAddress 0-63
   */

  Map<String, TextInputFormatter> limitByKey = {
    "networkAddress": MinMaxTextInputIntFormatter(0, 7),
    "outdoorAddress": MinMaxTextInputIntFormatter(0, 3),
    "indoorAddress": MinMaxTextInputIntFormatter(0, 63),
  };

  Map needSetParameter = {"networkAddress": "", "outdoorAddress": ""};
  final _formKey = GlobalKey<FormState>();
  final afterSalesReplacementController _selfController =
      Get.put(afterSalesReplacementController());

  final List<String> sortedKeys = [
    "oduHorses",
    "productSerial",
    "electricChassisHeating",
    "technicalBarriers",
    "parallelType",
    "compressBrand",
    "multipleWaterSources",
    "bigVrf",
    "electronicLock",
    "compressSelect",
    "compressType",
    "airOutletWay",
    "powerType",
    "refrigerantType",
    "derivedSeries",
    "electricControlBoxHeating",
    "packageOptions",
    "fanMotorType",
    "refrigerationCycleSetting",
    "myhomeConnectSetting",
    "indoorAlarmSetting",
    "powerDownSetting",
    "derivativeSeriesSetting",
    "elecHeatingSetting",
    "sterilizationSetting",
    "remoteShutdownSetting",
    "indoorType",
    "constantAirVolumeSetting",
    "bypassEnable",
    "indoorPlateHorses",
  ];

  getcodeParameters() async {
    // "afterSalesReplacement.NewBoardParameter1": "室外机模块板", 0
    // "afterSalesReplacement.NewBoardParameter2": "室外机主板",  1
    // "afterSalesReplacement.NewBoardParameter3": "室内机主板",  2
    // "afterSalesReplacement.NewBoardParameter4": "全热交换器主板",  3
    showpage = NewBoardParameterList.indexOf(
        _selfController.NewBoardParameterType.value);

    setState(() {
      showpage;
    });
    if (showpage != 0) {
      List parametersList = _selfController.parameterWritingParameter
          .replaceAll("[", "")
          .replaceAll("]", "")
          .split(",");
      if (showpage != 1) {
        needSetParameter = {"indoorAddress": ""};
        try {
          var codeParameters = await _selfplatform.invokeMethod(
              'getIduSalesBoardReplaceParameters', <String, dynamic>{
            'p1': parametersList[0].replaceAll("\"", ""),
            'p2': parametersList[1].replaceAll("\"", ""),
            'p3': parametersList,
          });

          Map originalMap = jsonDecode(codeParameters);

          if (showpage == 3 && originalMap["indoorType"] != "13") {
            bool issend = await divConfirmOnlyDialog(context,
                isSubmitButton: true,
                confirmTitle: tr("device.controltDialog.confirmTitle"),
                confirmDescriptionWidget: SingleChildScrollView(
                  child: SizedBox(
                      width: 560.w,
                      height: 140,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text("该二维码不属于全热交换器的售后二维码，请扫描正确的售后二维码"),
                          ],
                        ),
                      )),
                ));
            widget.preStep();
            return;
          }
          Map sortedMap = Map.fromEntries(
            sortedKeys.where((key) => originalMap.containsKey(key)).map((key) {
              return MapEntry(key, originalMap[key]!);
            }),
          );
          _selfController.setCodeParameter(originalMap);
          setState(() {
            propertyNames = sortedMap;
          });

          // 添加判断
        } on PlatformException catch (e) {
          print("Failed to SCANNER_TRIG: '${e.message}'.");
        }
      } else {
        try {
          var codeParameters = await _selfplatform.invokeMethod(
              'getOduSalesBoardReplaceParameters', <String, dynamic>{
            'p1': parametersList[0].replaceAll("\"", ""),
            'p2': parametersList[1].replaceAll("\"", ""),
            'p3': parametersList,
          });

          print({
            'p1': parametersList[0].replaceAll("\"", ""),
            'p2': parametersList[1].replaceAll("\"", ""),
            'p3': parametersList,
          });

          Map originalMap = jsonDecode(codeParameters);
          for (var k in originalMap.keys) {
            print("$k : ${originalMap[k]}");
          }
          Map sortedMap = Map.fromEntries(
            sortedKeys.where((key) => originalMap.containsKey(key)).map((key) {
              return MapEntry(key, originalMap[key]!);
            }),
          );
          _selfController.setCodeParameter(originalMap);
          setState(() {
            propertyNames = sortedMap;
          });
        } on PlatformException catch (e) {
          print("Failed to SCANNER_TRIG: '${e.message}'.");
        }
      }
    } else {
      setState(() {
        needSetParameter = {};
      });
    }
  }

  getTheOpvalue(showing, val) {
    String key = showing.toString().toLowerCase();
    if (showpage != 1) {
      return indoorParameters["$key"] != null
          ? tr((indoorParameters["$key"]![val]!).toLowerCase())
          : '$val';
    } else {
      return OduSalesBoardReplaceParameters[key] != null
          ? tr(OduSalesBoardReplaceParameters[key]![val]!)
          : '$val';
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    getcodeParameters();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Container(
          width: 720.w,
          height: 1280.h - 155,
          color: showpage == 0
              ? Colors.white
              : const Color.fromRGBO(223, 223, 223, 1),
          child: Column(
            children: [
              if (showpage == 0)
                Expanded(
                    child: baseContainer(
                        child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 24.h, 0, 0.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'afterSalesReplacement.sn',
                                style: ErrorTip(),
                              ).tr(),
                              Stack(
                                children: [
                                  Positioned(
                                      child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 9, 0, 0),
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(42),
                                        color: snInputColors),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            openscan();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            child: Image.asset(
                                              'public/images/waterPump/scran.png',
                                              width: 40.w,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: snInput(
                                            valBack: (back) {
                                              setState(() {
                                                sn = back;
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                                ],
                              )
                            ],
                          )),
                    ),
                  ],
                ))),
              if (showpage != 0)
                Padding(
                  padding: EdgeInsets.fromLTRB(32.w, 24.h, 32.w, 24.h),
                  child: Row(
                    children: [
                      const Text(
                        'afterSalesReplacement.sn',
                        style:
                            TextStyle(color: Color.fromRGBO(136, 136, 136, 1)),
                      ).tr(),
                      Text(
                        _selfController.parameterWritingSn.value,
                        style: const TextStyle(
                            color: Color.fromRGBO(136, 136, 136, 1)),
                      ).tr()
                    ],
                  ),
                ),
              if (needSetParameter.isNotEmpty)
                Padding(
                    padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 24.h),
                    child: Container(
                      width: 720.w,
                      height: needSetParameter.keys.length * 96.h,
                      child: Form(
                        key: _formKey,
                        child: ListView.builder(
                            itemCount: needSetParameter.keys.length,
                            itemBuilder: ((context, index) => Container(
                                  height: 96.h,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      border: Border(
                                        bottom: BorderSide(
                                          color:
                                              Color.fromRGBO(223, 223, 223, 1),
                                          width: 0.5,
                                        ),
                                      )),
                                  padding:
                                      EdgeInsets.fromLTRB(32.w, 0.h, 32.w, 0.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: (720.w - 32.w * 2) * 0.4,
                                        child: Row(
                                          children: [
                                            Text(
                                                    maxLines: 1,
                                                    style: titleStyle(),
                                                    overflow: TextOverflow
                                                        .ellipsis, // 或者 TextOverflow.clip
                                                    "${needSetParameter.keys.toList()[index]}")
                                                .tr(),
                                            const Text(
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                    overflow: TextOverflow
                                                        .ellipsis, // 或者 TextOverflow.clip
                                                    "*")
                                                .tr()
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          width: (720.w - 32.w * 2) * 0.6,
                                          child: intInputField(
                                            inputFormatters: limitByKey[
                                                        needSetParameter.keys
                                                            .toList()[index]] !=
                                                    null
                                                ? [
                                                    limitByKey[needSetParameter
                                                        .keys
                                                        .toList()[index]]!
                                                  ]
                                                : [],
                                            // ignore: unrelated_type_equality_checks
                                            maxValue: needSetParameter.keys ==
                                                    'networkAddress'
                                                ? 3
                                                : 63,
                                            changeback: (back) {
                                              try {
                                                _formKey.currentState
                                                    ?.validate();
                                              } catch (e) {}
                                              needSetParameter[needSetParameter
                                                  .keys
                                                  .toList()[index]] = back!;
                                            },
                                            initialValue: needSetParameter[
                                                needSetParameter.keys
                                                    .toList()[index]],
                                          )

                                          // TextFormField(
                                          //     textAlign: TextAlign.end,
                                          //     keyboardType: TextInputType.number,
                                          //     initialValue: needSetParameter[
                                          //         needSetParameter.keys
                                          //             .toList()[index]],
                                          //     decoration: const InputDecoration(
                                          //       border: InputBorder.none,
                                          //     ),
                                          //     onSaved: (back) {
                                          //       needSetParameter[needSetParameter
                                          //           .keys
                                          //           .toList()[index]] = back!;
                                          //     },
                                          //     onChanged: (back) {
                                          //       needSetParameter[needSetParameter
                                          //           .keys
                                          //           .toList()[index]] = back!;
                                          //     },
                                          //     validator: (v) {
                                          //       return validateEmpty(v);
                                          //     })
                                          )
                                    ],
                                  ),
                                ))),
                      ),
                    )),
              if (showpage != 0)
                Expanded(
                    child: SizedBox(
                        width: 720.w,
                        child: ListView.builder(
                            itemCount: propertyNames.keys.length,
                            itemBuilder: (context, index) => Container(
                                  height: 96.h,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      border: Border(
                                        bottom: BorderSide(
                                          color:
                                              Color.fromRGBO(223, 223, 223, 1),
                                          width: 0.5,
                                        ),
                                      )),
                                  padding:
                                      EdgeInsets.fromLTRB(32.w, 0.h, 32.w, 0.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: (720.w - 32.w * 2) * 0.4,
                                        child: Text(
                                                maxLines: 1,
                                                style: titleStyle(),
                                                overflow: TextOverflow
                                                    .ellipsis, // 或者 TextOverflow.clip
                                                "afterSalesReplacement.ParameterWriting.${propertyNames.keys.toList()[index]}")
                                            .tr(),
                                      ),
                                      SizedBox(
                                          width: (720.w - 32.w * 2) * 0.6,
                                          child: Text(
                                            // propertyNames[propertyNames.keys
                                            //         .toList()[index]]
                                            //     .toString(),
                                            tr(getTheOpvalue(
                                                propertyNames.keys
                                                    .toList()[index],
                                                propertyNames[propertyNames.keys
                                                    .toList()[index]])),
                                            textAlign: TextAlign.end,
                                            style: valueStyle(),
                                          ))
                                    ],
                                  ),
                                )))),
              Container(
                height: 57,
                padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                child: Center(
                  child: submitButton(
                    isActive: true,
                    label: tr('afterSalesReplacement.ParameterWritingStep3'),
                    onClick: () async {
                      if (showpage != 0 && _formKey.currentState!.validate()) {
                        bool issend = await divConfirmDialog(context,
                            confirmTitle:
                                tr("device.controltDialog.confirmTitle"),
                            confirmDescriptionWidget: SingleChildScrollView(
                              child: SizedBox(
                                  width: 560.w,
                                  height: 140,
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                                'afterSalesReplacement.ParameterWriting.writingParameteTip')
                                            .tr(),
                                      ],
                                    ),
                                  )),
                            ));
                        if (issend) {
                          _selfController.setNeedSetParameter(needSetParameter);
                          widget.nextStep();
                        }
                      } else if (showpage == 0) {
                        /**
                     * 室外机模块写入sn
                     */
                        bool issend = await divConfirmDialog(context,
                            confirmTitle:
                                tr("device.controltDialog.confirmTitle"),
                            confirmDescriptionWidget: SingleChildScrollView(
                              child: SizedBox(
                                  width: 560.w,
                                  height: 140,
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                                'afterSalesReplacement.ParameterWriting.writingParameteTip')
                                            .tr(),
                                      ],
                                    ),
                                  )),
                            ));
                        if (issend) {
                          widget.nextStep();
                        }
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
