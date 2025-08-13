import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/communication/index.dart';
import 'package:fluoroscopy_tool/view/communication/publicFunction.dart';
import 'package:fluoroscopy_tool/view/systemCapabilityAnalysis/step2/systemDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

class resultpage extends StatefulWidget {
  var result;
  resultpage({super.key, required this.result});

  @override
  State<resultpage> createState() => _copybasepageState();
}

class _copybasepageState extends State<resultpage> {
  bool iserror = false;
  String checkResultEnum = "";
  String checkSysResultEnum = "";
  final communicationController _selfController = Get.find();
  @override
  void initState() {
    super.initState();
    if (_selfController.connectType.value == "2") {
      /** 系统检测添加自定义的结果判断 */
      /**
       * 通讯正常 - 找到有地址内机台数+找到无地址地址台数=设定内机台数
       * 通讯异常 - 内机台数缺失找到有地址内机台数+找到无地址台数不等于0，且小于设症内机台数
       * 通讯异常 - 找到有地址内机台数+找到无地址台数等于0
       */
      int checkResultEnum = 0; // 找到无地址台数
      int onlineIndoorList = 0; // 找到有地址内机台数
      int indoorNum = 0; // 设定内机台数


        print("resultpage -------- : result:  ${widget.result}");

      try {
        checkResultEnum = int.parse(widget.result["noAddressNum"].toString());
      } catch (e) {
        print("resultpage -------- : checkResultEnum:  $e");
      }

      try {
        onlineIndoorList = widget.result["onlineIndoorList"].length;
      } catch (e) {
        print("resultpage -------- : onlineIndoorList:  $e");
      }

      try {
        indoorNum = int.parse(
            _selfController.needSetParameter.value["indoorNum"].toString());
      } catch (e) {
        print("resultpage -------- : indoorNum:  $e");
      }

      print(
          "resultpage -------- : checkResultEnum:$checkResultEnum  onlineIndoorList:$onlineIndoorList  indoorNum:$indoorNum ");

      if ((onlineIndoorList + checkResultEnum) != 0 &&
          (onlineIndoorList + checkResultEnum) == indoorNum) {
        iserror = false;
        checkSysResultEnum = "通讯正常";
      }

      if ((onlineIndoorList + checkResultEnum) == 0) {
        iserror = true;
        checkSysResultEnum = "通讯异常";
      }
      if ((onlineIndoorList + checkResultEnum) != 0 &&
          (onlineIndoorList + checkResultEnum) != indoorNum) {
        iserror = true;
        checkSysResultEnum = "通讯异常，内机台数不一致";
      }
      setState(() {
        iserror;
        checkSysResultEnum;
      });
    } else {
      setState(() {
        iserror = widget.result["checkResultEnum"] != "ABNORMAL";
        checkResultEnum = widget.result["checkResultEnum"] ?? "";
      });
    }
  }

  showTimeTip() async {
    bool issend = await divConfirmOnlyDialog(context,
        isSubmitButton: true,
        confirmTitle: tr("resultpage.con.title"),
        confirmDescriptionWidget: SizedBox(
          width: 600.w,
          height: 240,
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'resultpage.con.content${int.parse(_selfController.connectType.value.toString()) + 1}',
                  style: normalTextBlack(),
                ).tr(),
              ],
            ),
          )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Get.off(() => communicationTypeSelectPage());
            },
            icon:
                const Icon(Icons.chevron_left, color: Colors.black, size: 36)),
        title: const Text(
          'resultpage.con.title',
          style: TextStyle(color: Colors.black),
        ).tr(),
        centerTitle: true,
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: 720.w,
          height: 1280.h - 80,
          color: const Color.fromRGBO(255, 255, 255, 1),
          padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
          child: Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      'public/images/communication/type1.jpg',
                      width: 400.w,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                      child: Text(
                        checkSysResultEnum == ""
                            ? tr('resultpage.$checkResultEnum')
                            : checkSysResultEnum,
                        style: normalTextBlack(
                            fw: FontWeight.w700,
                            fSize: 18,
                            fontcolor: checkSysResultEnum == ""
                                ? checkResultEnum == "NORMAL"
                                    ? const Color.fromRGBO(32, 175, 66, 1)
                                    : Colors.red
                                : !iserror
                                    ? const Color.fromRGBO(32, 175, 66, 1)
                                    : Colors.red),
                      ),
                    ),
                    Container(
                        clipBehavior: Clip.antiAlias,
                        margin: EdgeInsets.fromLTRB(32.w, 0, 32.w, 0),
                        decoration: BoxDecoration(
                          color: Colors.white, // 背景色
                          border: Border.all(
                            color: const Color(0xFFDFDFDF), // 边框颜色
                            width: 0.5, // 边框宽度
                          ),
                          borderRadius: BorderRadius.circular(8.0), // 圆角
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Column(
                            children: _selfController.connectType.value == "0"
                                ? [
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white, // 背景色
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 0.5,
                                              color: Color(0xFFDFDFDF)),
                                        ),
                                      ),
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 13, 16, 13),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "resultpage.tip1",
                                                style: normalTextBlack(),
                                              ).tr(),
                                              Text(
                                                "${_selfController.needSetParameter.value["protocol"]}-${_selfController.connectType.value == "0" ? "ODU" : _selfController.connectType.value == "1" ? "IDU" : "SYS"}",
                                                style: normalText(),
                                              )
                                            ],
                                          ),
                                          const Divider(
                                              color: Color(0xFFDFDFDF)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _selfController.connectType
                                                            .value !=
                                                        "1"
                                                    ? tr("communication.type1")
                                                    : tr("communication.type2"),
                                                style: normalTextBlack(),
                                              ).tr(),
                                              Text(
                                                "${widget.result["checkResultEnum"]}",
                                                style: normalText(),
                                              ).tr()
                                            ],
                                          ),
                                          // const Divider(color: Color(0xFFDFDFDF)),
                                          // Row(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.spaceBetween,
                                          //   children: [
                                          //     Text(
                                          //       "丢包率",
                                          //       style: normalTextBlack(),
                                          //     ),
                                          //     Text(
                                          //       "${widget.result["packetLossRate"]}",
                                          //       style: normalText(),
                                          //     ).tr()
                                          //   ],
                                          // )
                                        ],
                                      ),
                                    )
                                  ]
                                : _selfController.connectType.value == "1"
                                    ? [
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white, // 背景色
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color: Color(0xFFDFDFDF)),
                                            ),
                                          ),
                                          padding: const EdgeInsets.fromLTRB(
                                              16, 13, 16, 13),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "resultpage.tip1",
                                                    style: normalTextBlack(),
                                                  ).tr(),
                                                  Text(
                                                    "${_selfController.needSetParameter.value["protocol"]}-${_selfController.connectType.value == "0" ? "ODU" : _selfController.connectType.value == "1" ? "IDU" : "SYS"}",
                                                    style: normalText(),
                                                  )
                                                ],
                                              ),
                                              const Divider(
                                                  color: Color(0xFFDFDFDF)),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    _selfController.connectType
                                                                .value !=
                                                            "1"
                                                        ? tr(
                                                            "communication.type1")
                                                        : tr(
                                                            "communication.type2"),
                                                    style: normalTextBlack(),
                                                  ),
                                                  Text(
                                                    "${widget.result["checkResultEnum"]}",
                                                    style: normalText(),
                                                  ).tr()
                                                ],
                                              ),
                                              const Divider(
                                                  color: Color(0xFFDFDFDF)),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "electronicexpansionvalve.showtype1",
                                                    style: normalTextBlack(),
                                                  ).tr(),
                                                  Text(
                                                    "${widget.result["onlineIndoorList"] != null && widget.result["onlineIndoorList"].isNotEmpty ? widget.result["onlineIndoorList"].join("#,") + "#" : '--'}",
                                                    style: normalText(),
                                                  ).tr()
                                                ],
                                              ),

                                              // const Divider(
                                              //     color: Color(0xFFDFDFDF)),
                                              // Row(
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment
                                              //           .spaceBetween,
                                              //   children: [
                                              //     Text(
                                              //       "communicationQualityEnum",
                                              //       style: normalTextBlack(),
                                              //     ).tr(),
                                              //     Text(
                                              //       "${widget.result["communicationQualityEnum"] ?? '--'}",
                                              //       style: normalText(),
                                              //     ).tr()
                                              //   ],
                                              // ),
                                              // const Divider(
                                              //     color: Color(0xFFDFDFDF)),
                                              // Row(
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment
                                              //           .spaceBetween,
                                              //   children: [
                                              //     Text(
                                              //       "packetLossRate",
                                              //       style: normalTextBlack(),
                                              //     ).tr(),
                                              //     Text(
                                              //       "${widget.result["packetLossRate"] ?? '--'}",
                                              //       style: normalText(),
                                              //     ).tr()
                                              //   ],
                                              // )
                                            ],
                                          ),
                                        )
                                      ]
                                    : [
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white, // 背景色
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color: Color(0xFFDFDFDF)),
                                            ),
                                          ),
                                          padding: const EdgeInsets.fromLTRB(
                                              16, 13, 16, 13),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "connectprotocol",
                                                    style: normalTextBlack(),
                                                  ).tr(),
                                                  Text(
                                                    "${_selfController.needSetParameter.value["protocol"]}-${_selfController.connectType.value == "0" ? "ODU" : _selfController.connectType.value == "1" ? "IDU" : "SYS"}",
                                                    style: normalText(),
                                                  )
                                                ],
                                              ),
                                              const Divider(
                                                  color: Color(0xFFDFDFDF)),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "indoorNumset",
                                                    style: normalTextBlack(),
                                                  ).tr(),
                                                  Text(
                                                    "${_selfController.needSetParameter.value["indoorNum"]}${tr("onlineIndoorList.unit")}",
                                                    style: normalText(
                                                        fontcolor: _selfController
                                                                        .needSetParameter
                                                                        .value[
                                                                    "indoorNum"] !=
                                                                null
                                                            ? int.parse(_selfController
                                                                        .needSetParameter
                                                                        .value[
                                                                            "indoorNum"]
                                                                        .toString()) ==
                                                                    widget
                                                                        .result[
                                                                            "onlineIndoorList"]
                                                                        .length
                                                                ? const Color
                                                                        .fromRGBO(
                                                                    140,
                                                                    140,
                                                                    140,
                                                                    1)
                                                                : Colors.red
                                                            : const Color
                                                                    .fromRGBO(
                                                                140,
                                                                140,
                                                                140,
                                                                1)),
                                                  ).tr()
                                                ],
                                              ),
                                              const Divider(
                                                  color: Color(0xFFDFDFDF)),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "onlineIndoorList",
                                                    style: normalTextBlack(),
                                                  ).tr(),
                                                  Text(
                                                    "${widget.result["onlineIndoorList"].length}${tr("onlineIndoorList.unit")}",
                                                    style: normalText(),
                                                  ).tr()
                                                ],
                                              ),
                                              const Divider(
                                                  color: Color(0xFFDFDFDF)),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "electronicexpansionvalve.showtype1",
                                                    style: normalTextBlack(),
                                                  ).tr(),
                                                  Text(
                                                    "${widget.result["onlineIndoorList"] != null && widget.result["onlineIndoorList"].isNotEmpty ? widget.result["onlineIndoorList"].join("#,") + "#" : '--'}",
                                                    style: normalText(),
                                                  ).tr()
                                                ],
                                              ),
                                              const Divider(
                                                  color: Color(0xFFDFDFDF)),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "electronicexpansionvalve.showtype6",
                                                    style: normalTextBlack(),
                                                  ).tr(),
                                                  Text(
                                                    "${widget.result["noAddressNum"] ?? '--'}",
                                                    style: normalText(),
                                                  ).tr()
                                                ],
                                              ),
                                              const Divider(
                                                  color: Color(0xFFDFDFDF)),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "communicationQualityEnum",
                                                    style: normalTextBlack(),
                                                  ).tr(),
                                                  Text(
                                                    "${widget.result["communicationQualityEnum"] ?? '--'}",
                                                    style: normalText(),
                                                  ).tr()
                                                ],
                                              ),
                                              const Divider(
                                                  color: Color(0xFFDFDFDF)),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "packetLossRate",
                                                    style: normalTextBlack(),
                                                  ).tr(),
                                                  Text(
                                                    "${widget.result["packetLossRate"] ?? '--'}",
                                                    style: normalText(),
                                                  ).tr()
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                          ),
                        ))
                  ],
                ),
              )),
              if (!iserror)
                Container(
                  padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        showTimeTip();
                      },
                      child: Text("${tr('checkingtip')}  >"),
                    ),
                  ),
                ),
              Container(
                height: 57,
                padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                child: Center(
                  child: submitButton(
                    isActive: true,
                    label: iserror
                        ? tr('resultpage.success')
                        : tr('resultpage.error'),
                    onClick: () async {
                      Get.off(() => communicationTypeSelectPage());
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
