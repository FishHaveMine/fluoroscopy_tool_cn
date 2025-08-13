import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/snInput.dart';
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

import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import '../../local/style.dart';

class moduleReplacement extends StatefulWidget {
  moduleReplacement({super.key});

  @override
  State<moduleReplacement> createState() => _moduleReplacementState();
}

class _moduleReplacementState extends State<moduleReplacement> {
  final cloudProjectController _selectController = Get.find();
  static const platform = MethodChannel('samples.flutter.dev/battery');
  static const _selfplatform =
      MethodChannel('samples.flutter.dev/getTopologyHandler');

  static const proplatform =
      MethodChannel('samples.flutter.dev/getProjectHandler');
  int _step = 1;
  int selectIndex = -1;
  String newsn = "";
  bool isnewsnexit = false;
  int _moduleReplacestep = 1; // 1 请求中；  2 成功  3 失败；
  String errorMsg = "";
  openscan() async {
    try {
      await platform.invokeMethod('SCANNER_TRIG');
    } on PlatformException catch (e) {
      print("Failed to SCANNER_TRIG: '${e.message}'.");
    }
  }

  List history = [];
  _init() async {
    EasyLoading.show(status: 'loading...');
    try {
      var project = _selectController.selectProject.value["project"];
      var historyback = await _selfplatform.invokeMethod('listOfflineGateway', {
        "key": project["code"].toString(),
      });

      var historydata = jsonDecode(historyback);
      if (historydata["errorCode"] != null &&
          historydata["errorCode"].toString() == "1001") {
        //登录失效
        tologout();
      }
      setState(() {
        history.addAll(historydata["data"]);
      });
      EasyLoading.dismiss();
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
    }
  }

  _selectIndex(index) {
    if (index != selectIndex) {
      setState(() {
        selectIndex = index;
      });
    } else {
      setState(() {
        selectIndex = -1;
      });
    }
  }

  _checkisnewsnexit() async {
    EasyLoading.show(status: 'loading...');
    try {
      var send = {"projectCode": "", "sn": newsn, "pageindex": 1};
      var historyback = await proplatform.invokeMethod(
          'getProfessionalToolsHandler.page', send);
      var historydata = jsonDecode(historyback);
      print(historydata);
      if (historydata["errorCode"] != null &&
          historydata["errorCode"].toString() == "1001") {
        //登录失效
        tologout();
      }
      if (!historydata['success']) {
        EasyLoading.showError(historydata['errorMsg']);
      }
      if (historydata["data"].isEmpty) {
        EasyLoading.showError(tr("clound.searchEmptydevice"));
        setState(() {
          isnewsnexit = false;
        });
      } else {
        setState(() {
          isnewsnexit = true;
        });
      }
      EasyLoading.dismiss();
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
    }
  }

  _startmoduleReplace() async {
    setState(() {
      _step = 3;
    });
    // return;
    try {
      var project = _selectController.selectProject.value["project"];
      var moduleReplacedataback =
          await _selfplatform.invokeMethod('moduleReplace', {
        "newSn": newsn,
        "projectCode": project["code"],
        "projectId": project["id"],
        "sysId": history[selectIndex]["sysId"],
      });

      var moduleReplacedata = jsonDecode(moduleReplacedataback);
      if (moduleReplacedata["errorCode"] != null &&
          moduleReplacedata["errorCode"].toString() == "1001") {
        //登录失效
        tologout();
      }

      if (moduleReplacedata["success"]) {
        setState(() {
          _moduleReplacestep = 2;
        });
      } else {
        setState(() {
          errorMsg = moduleReplacedata['errorMsg'];
          _moduleReplacestep = 3;
        });
      }

      EasyLoading.dismiss();
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
    print(_selectController.selectProject);
  }

  @override
  void dispose() {
    // 移除滚动监听器
    super.dispose();
    EasyLoading.dismiss();
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
          title: Text(
            'moduleReplacement.title${_step}',
            style: const TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [],
        ),
        body: Container(
          width: 720.w,
          height: 1280.h,
          color: const Color.fromRGBO(244, 244, 244, 1),
          padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
          child: _step == 1
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        "moduleReplacement.tip1",
                        style: normalText(),
                      ).tr(),
                    ),
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ListView.builder(
                                itemCount: history.length,
                                itemBuilder: ((context, index) => InkWell(
                                      onTap: () {
                                        _selectIndex(index);
                                      },
                                      child: Container(
                                        decoration: cardStyle(context),
                                        margin: const EdgeInsets.fromLTRB(
                                            12, 0, 12, 12),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14, horizontal: 16),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "moduleReplacement.label1",
                                                    style: titleText(),
                                                  ).tr(namedArgs: {
                                                    "val": history[index]
                                                            ["name"] ??
                                                        "--"
                                                  }),
                                                ),
                                                RoundCheckBox(
                                                  isChecked:
                                                      selectIndex == index,
                                                  onTap: (selected) {
                                                    _selectIndex(index);
                                                  },
                                                  size: 16,
                                                  checkedWidget: const Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                    size: 14,
                                                  ),
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
                                            Text(
                                              "moduleReplacement.label2",
                                              style: normalText(fSize: 12),
                                            ).tr(namedArgs: {
                                              "val": history[index]["sysId"] ??
                                                  "--"
                                            }),
                                            Text(
                                              "moduleReplacement.label3",
                                              style: normalText(fSize: 12),
                                            ).tr(namedArgs: {
                                              "val":
                                                  history[index]["sn"] ?? "--"
                                            })
                                          ],
                                        ),
                                      ),
                                    ))))),
                    Container(
                      height: 57,
                      padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 134,
                            child: normalButton(
                              label: tr('moduleReplacement.btn1'),
                              onClick: () async {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          SizedBox(
                            width: 134,
                            child: submitButton(
                              isActive: selectIndex != -1,
                              label: tr('moduleReplacement.btn2'),
                              onClick: () async {
                                if (selectIndex != -1) {
                                  setState(() {
                                    _step = 2;
                                  });
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
              : _step == 2
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "moduleReplacement.label4",
                                      style: titleText(),
                                    ).tr(),
                                    Text(
                                      "${history[selectIndex]["sn"] ?? "--"}",
                                      style: normalText(),
                                    ).tr(),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "moduleReplacement.label5",
                                      style: titleText(),
                                    ).tr(),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 12, 0, 12),
                                      padding: const EdgeInsets.all(0),
                                      height: 44,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(42),
                                          color: Colors.white),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              openscan();
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 0, 10, 0),
                                              child: Image.asset(
                                                'public/images/waterPump/scran.png',
                                                width: 40.w,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        5, 0, 0, 0),
                                                child: snInput(
                                                  hintText: tr("getsn"),
                                                  isSamll: true,
                                                  lengthLimit: false,
                                                  onfocus: () {},
                                                  valBack: (back) {
                                                    setState(() {
                                                      isnewsnexit = false;
                                                      newsn = back;
                                                    });
                                                  },
                                                )),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (newsn != "") {
                                                _checkisnewsnexit();
                                              }
                                            },
                                            child: Container(
                                              width: 55,
                                              height: 36,
                                              margin: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(49),
                                                  color: const Color.fromRGBO(
                                                      25, 98, 255, 1)),
                                              child: Center(
                                                child: const Text(
                                                  'search',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14),
                                                ).tr(),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "moduleReplacement.tip2",
                                      style: normalText(),
                                    ).tr()
                                  ],
                                ))),
                        Container(
                          height: 57,
                          padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: 134,
                                child: normalButton(
                                  label: tr('moduleReplacement.btn1'),
                                  onClick: () async {
                                    setState(() {
                                      _step = 1;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 134,
                                child: submitButton(
                                  isActive: isnewsnexit && newsn != "",
                                  label: tr('moduleReplacement.btn2'),
                                  onClick: () async {
                                    if (isnewsnexit && newsn != "") {
                                      _startmoduleReplace();
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  : Column(children: [
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: _moduleReplacestep == 1
                            ? [
                                Image.asset(
                                  'public/images/waterPump/loading.gif',
                                  width: 140,
                                ),
                                Text(
                                  tr("moduleReplacement.label6"),
                                  style: titleText(),
                                ),
                                Text(
                                  tr("moduleReplacement.tip3"),
                                  style: normalText(),
                                ),
                              ]
                            : _moduleReplacestep == 2
                                ? [
                                    Image.asset(
                                      'public/images/afterSalesReplacement/success.png',
                                      width: 140,
                                    ),
                                    Text(
                                      tr("moduleReplacement.label6_success"),
                                      style: titleText(),
                                    ),
                                    Text(
                                      tr("moduleReplacement.tip3_success"),
                                      style: normalText(),
                                    ),
                                  ]
                                : [
                                    Image.asset(
                                      'public/images/afterSalesReplacement/error.png',
                                      width: 140,
                                    ),
                                    Text(
                                      tr("moduleReplacement.label6_error"),
                                      style: titleText(),
                                    ),
                                    Text(
                                      errorMsg ??
                                          tr("moduleReplacement.tip3_error"),
                                      style: normalText(),
                                    ),
                                  ],
                      )),
                      Container(
                        height: 57,
                        padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                        child: Center(
                          child: submitButton(
                            isActive: true,
                            label: tr('moduleReplacement.btn3'),
                            onClick: () async {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      )
                    ]),
        ));
  }
}
