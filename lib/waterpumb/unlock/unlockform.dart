import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/bottomSelectSheet.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/waterpumb/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import 'package:get/get.dart';

class UnlockPage extends StatefulWidget {
  @override
  _UnlockPageState createState() => _UnlockPageState();
}

class _UnlockPageState extends State<UnlockPage> {
  String unlockModel = '';
  String unlockScenario = '首次解锁';
  String code = "";
  List<String> unlockModels = [];

  static const McuUtilplatform = MethodChannel('samples.flutter.dev/McuUtil');

  final waterpumbInfoController _deviceInfoController =
      Get.put(waterpumbInfoController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getWaterDeviceTypeEnum();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _deviceInfoController.clearloacalDevice();
    });
  }

  static const platform =
      MethodChannel('samples.flutter.dev/waterpumbBasicHandler');

  _getWaterDeviceTypeEnum() async {
    try {
      var GenCode = await platform.invokeMethod(
          'getWaterDeviceTypeEnum', <String, dynamic>{"isCn": true});
      var data = jsonDecode(GenCode);
      List<String> _unlockModels = [];
      for (var element in data) {
        print("_offLineToGenCode: $element");
        _unlockModels.add(element);
      }
      setState(() {
        unlockModels = _unlockModels;
        unlockModel = _unlockModels[0];
      });
    } catch (e) {
      print("getWaterDeviceTypeEnum catch: $e");
    }
  }

  _offLineToGenCode() async {
    print("_offLineToGenCode");
    try {
      var GenCode =
          await platform.invokeMethod('toOffLineToGenCode', <String, dynamic>{
        "devicetype": unlockModel,
        "sn": _deviceInfoController.loacalDevice.value.sn,
        "version": _deviceInfoController.loacalDevice.value.version,
        "date": _deviceInfoController.loacalDevice.value.date
      });
      var data = jsonDecode(GenCode);
      setState(() {
        code = data["data"];
      });
      EasyLoading.showSuccess("读取成功");
    } catch (e) {
      print("_offLineToGenCode catch: $e");
      EasyLoading.showError("读取失败: $e");
    }
  }

  _sendPassword() async {
    if (_deviceInfoController.loacalDevice.value.random == "" ||
        _deviceInfoController.loacalDevice.value.date == "" ||
        _deviceInfoController.loacalDevice.value.version == "") {
      EasyLoading.showError("请先读取设备信息");
      return;
    }
    print("_sendPassword");
    try {
      var GenCode =
          await platform.invokeMethod('sendPassword', <String, dynamic>{});
      var data = jsonDecode(GenCode);
      setState(() {
        code = data["data"];
      });
      EasyLoading.showSuccess("下发成功");
    } catch (e) {
      print("_sendPassword catch: $e");
      EasyLoading.showError("下发失败: $e");
    }
  }

  Timer? _timerisPolling;
  bool is_getConnection = false;
  _getConnection() async {
    if (is_getConnection) {
      return;
    }

    print("getConnection");
    setState(() {
      code = "";
    });
    _deviceInfoController.clearloacalDevice();
    _deviceInfoController.stopPolling();
    EasyLoading.show(status: 'loading...', dismissOnTap: false);
    is_getConnection = true;
    try {
      await McuUtilplatform.invokeMethod('powerOff');
      await Future.delayed(const Duration(seconds: 1));
      await McuUtilplatform.invokeMethod('powerOn');

      var GenCode = await platform.invokeMethod(
          'getConnection', <String, dynamic>{"devicetype": unlockModel});
      var data = jsonDecode(GenCode);

      _deviceInfoController.startPolling();
      print("getConnection: $data");

      await Future.delayed(const Duration(seconds: 3), () {});
      is_getConnection = false;
    } catch (e) {
      EasyLoading.dismiss();

      is_getConnection = false;
      EasyLoading.showError("getConnection: $e");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    code = "";
    _deviceInfoController.stopPolling();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<waterpumbInfoController>(
        init: waterpumbInfoController(),
        builder: (_) => Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: IconButton(
                    onPressed: () {
                      code = "";
                      _deviceInfoController.stopPolling();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.chevron_left,
                        color: Colors.black, size: 36)),
                title: const Text(
                  '解锁功能',
                  style: TextStyle(color: Colors.black),
                ).tr(),
                centerTitle: true,
                actions: [],
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 解锁机型 Dropdown
                          buildDropdownField(
                            label: '解锁机型',
                            value: unlockModel,
                            context: context,
                            options: unlockModels,
                            isRequired: true,
                            onChanged: (value) {
                              setState(() {
                                unlockModel = value!;
                              });
                            },
                          ),
                          // const SizedBox(height: 12),
                          // // 解锁场景 Radio
                          // RichText(
                          //   text: const TextSpan(
                          //     text: '* ',
                          //     style: TextStyle(color: Colors.red, fontSize: 14),
                          //     children: [
                          //       TextSpan(
                          //         text: "解锁场景",
                          //         style: TextStyle(color: Colors.black87, fontSize: 14),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // const SizedBox(
                          //   width: 6,
                          //   height: 12,
                          // ),
                          // Row(
                          //   children: [
                          //     RoundCheckBox(
                          //       isChecked: unlockScenario == "首次解锁",
                          //       onTap: (selected) {
                          //         setState(() {
                          //           unlockScenario = "首次解锁";
                          //         });
                          //       },
                          //       size: 16,
                          //       checkedWidget: const Icon(
                          //         Icons.check,
                          //         color: Colors.white,
                          //         size: 14,
                          //       ),
                          //       checkedColor: Theme.of(context).colorScheme.secondary,
                          //       border: Border.all(
                          //           // width: 1,
                          //           color: Theme.of(context).colorScheme.secondary),
                          //     ),
                          //     const SizedBox(
                          //       width: 6,
                          //       height: 12,
                          //     ),
                          //     const Text('首次解锁'),
                          //     const SizedBox(
                          //       width: 24,
                          //       height: 12,
                          //     ),
                          //     RoundCheckBox(
                          //       isChecked: unlockScenario == "清除维护提示",
                          //       onTap: (selected) {
                          //         setState(() {
                          //           unlockScenario = "清除维护提示";
                          //         });
                          //       },
                          //       size: 16,
                          //       checkedWidget: const Icon(
                          //         Icons.check,
                          //         color: Colors.white,
                          //         size: 14,
                          //       ),
                          //       checkedColor: Theme.of(context).colorScheme.secondary,
                          //       border: Border.all(
                          //           // width: 1,
                          //           color: Theme.of(context).colorScheme.secondary),
                          //     ),
                          //     const SizedBox(
                          //       width: 6,
                          //       height: 12,
                          //     ),
                          //     const Text('清除维护提示'),
                          //   ],
                          // ),

                          const SizedBox(height: 12),
                          // SN输入框
                          buildTextField('机组SN', _.loacalDevice.value.sn,
                              isRequired: true),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                            child: Divider(height: 1, color: Color(0xFFDFDFDF)),
                          ),

                          // 读取按钮
                          SizedBox(
                            width: 720.w,
                            height: 72.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("机组信息",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  width: 160.w,
                                  height: 72.h,
                                  child: submitButton(
                                    isActive: true,
                                    label: '读取',
                                    onClick: () {
                                      _getConnection();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    Container(height: 8, color: const Color(0xFFDFDFDF)),

                    // 机组信息
                    Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTextField(
                                '1-3位随机数', _.loacalDevice.value.random,
                                isRequired: true),
                            const SizedBox(height: 12),
                            buildTextField('显示器日期',
                                "${_.loacalDevice.value.year}-${_.loacalDevice.value.month}-${_.loacalDevice.value.date}",
                                isRequired: true),
                            const SizedBox(height: 12),
                            buildTextField(
                                '设备版本号', _.loacalDevice.value.version,
                                isRequired: true),
                            // const SizedBox(height: 12),
                            // buildTextField(
                            //     'address1281', _.loacalDevice.value.address1281,
                            //     isRequired: true),
                            // const SizedBox(height: 12),
                            // buildTextField(
                            //     'address10', _.loacalDevice.value.address10,
                            //     isRequired: true),
                          ],
                        )),

                    // Container(height: 8, color: const Color(0xFFDFDFDF)),

                    // // 解锁码生成
                    // Padding(
                    //     padding: const EdgeInsets.all(16),
                    //     child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.start,
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           const Text(
                    //             '解锁码生成',
                    //             style: TextStyle(
                    //                 fontSize: 16, fontWeight: FontWeight.w600),
                    //           ),
                    //           const Padding(
                    //             padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    //             child: Divider(height: 1, color: Color(0xFFDFDFDF)),
                    //           ),
                    //           SizedBox(
                    //             width: 720.w,
                    //             height: 72.h,
                    //             child: Row(
                    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Text(code == "" ? "请点击生成" : code,
                    //                     style: code == "" ? info() : infonormal()),
                    //                 SizedBox(
                    //                   width: 160.w,
                    //                   height: 72.h,
                    //                   child: submitButton(
                    //                     isActive: true,
                    //                     label: '生成',
                    //                     onClick: () {
                    //                       _offLineToGenCode();
                    //                     },
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           )
                    //         ])),

                    Container(height: 8, color: const Color(0xFFDFDFDF)),
                    Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 解锁指令下发
                              const Text(
                                '解锁指令下发',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),

                              const Padding(
                                padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: Divider(
                                    height: 1, color: Color(0xFFDFDFDF)),
                              ),
                              SizedBox(
                                width: 720.w,
                                height: 72.h,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      code == "" ? "下发解锁码" : code,
                                      style: info(),
                                    ),
                                    SizedBox(
                                      width: 160.w,
                                      height: 72.h,
                                      child: submitButton(
                                        isActive: !(_.loacalDevice.value
                                                    .random ==
                                                "" ||
                                            _.loacalDevice.value.date == "" ||
                                            _.loacalDevice.value.version == ""),
                                        label: '下发',
                                        onClick: () {
                                          _sendPassword();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: Divider(
                                    height: 1, color: Color(0xFFDFDFDF)),
                              ),
                              SizedBox(
                                width: 720.w,
                                height: 72.h,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        _.loacalDevice.value.locks != ""
                                            ? _.loacalDevice.value.locks == "32"
                                                ? "已解锁"
                                                : _.loacalDevice.value.locks ==
                                                        "30"
                                                    ? "未解锁"
                                                    : _.loacalDevice.value.locks
                                            : "查询解锁状态",
                                        style: _.loacalDevice.value.locks != ""
                                            ? infonormal()
                                            : info()),
                                    SizedBox(
                                      width: 160.w,
                                      height: 72.h,
                                      child: submitButton(
                                        isActive: true,
                                        label: '查询',
                                        onClick: () {
                                          _getConnection();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ]))
                  ],
                ),
              ),
            ));
  }
}

TextStyle info() {
  return const TextStyle(
      color: Color.fromRGBO(187, 187, 187, 1),
      fontSize: 14,
      height: 1.5,
      fontWeight: FontWeight.w400);
}

TextStyle infonormal() {
  return const TextStyle(
      color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w400);
}

Widget buildTextField(String label, String val, {bool isRequired = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            text: isRequired ? '* ' : '',
            style: const TextStyle(color: Colors.red, fontSize: 14),
            children: [
              TextSpan(
                text: label,
                style: const TextStyle(color: Colors.black87, fontSize: 14),
              ),
            ],
          ),
        ),
        Expanded(
            child: Text(
          val,
          textAlign: TextAlign.end,
          style: val == "" ? info() : infonormal(),
        )),
      ],
    ),
  );
}

Widget buildDropdownField({
  required String label,
  required String value,
  required dynamic context,
  required List<String> options,
  required void Function(String?) onChanged,
  bool isRequired = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 14, 0, 0),
          child: RichText(
            text: TextSpan(
              text: isRequired ? '* ' : '',
              style: const TextStyle(color: Colors.red, fontSize: 14),
              children: [
                TextSpan(
                  text: label,
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () async {
              Future<sheetBack?> selectedIndex =
                  await showCustomModalBottomSheet(
                context,
                options
                    .map(
                        (e) => {"label": e, "name": e, 'value1': e, "value": e})
                    .toList(),
                isMultiple: false,
                baseValue: [value],
                titleName: label,
              );
              selectedIndex.then((value) => {
                    if (value != null &&
                        // ignore: unrelated_type_equality_checks
                        value.baseValue![0] != -1)
                      {onChanged(value.baseValue![0].toString())}
                  });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    value,
                    textAlign: TextAlign.end,
                    style: normalText(),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: Color.fromRGBO(140, 140, 140, 1),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    ),
  );
}
