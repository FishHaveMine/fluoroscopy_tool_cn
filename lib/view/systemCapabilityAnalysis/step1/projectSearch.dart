import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/projectinfo.dart';
import 'package:fluoroscopy_tool/compent/snInput.dart';
import 'package:fluoroscopy_tool/store/globalData.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../selfpublicFunction.dart';
import '../systemLocation/location.dart';

class projectSearch extends StatefulWidget {
  projectSearch({super.key});

  @override
  State<projectSearch> createState() => _systemSearchState();
}

class _systemSearchState extends State<projectSearch> {
  static const platform =
      MethodChannel('samples.flutter.dev/getSystemDataHandler');
  final deviceInfoController _deviceInfoController = Get.find();

  final systemAnalysisController _selfcon = Get.find();
  List history = [];
  updatahistroy(val) {
    setState(() {
      history = val;
    });
  }

  getSearchHistories() async {
    try {
      var getSearchHistories =
          await platform.invokeMethod('getSearchHistories');
      var data = jsonDecode(getSearchHistories);
      if (data["success"] && data["data"] != null) {
        setState(() {
          history = data["data"];
        });
      }
    } catch (e) {}
  }

  searchBySn() async {
    EasyLoading.show(status: 'loading...');
    try {
      var getSearchBySnback = await platform
          .invokeMethod('getSearchBySn', <String, dynamic>{"sn": sn});
      EasyLoading.dismiss();
      if (getSearchBySnback["data"] != null) {
        setState(() {
          history = getSearchBySnback["data"];
        });
      }
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  bool ishistory = true;
  getSearchByProject() async {
    bool conn = await checkNet(true);
    if (!conn) {
      EasyLoading.dismiss();
      return;
    }
    EasyLoading.show(status: 'loading...');
    setState(() {
      ishistory = sn == "";
    });
    try {
      var getSearchByProjectback =
          await platform.invokeMethod('getSearchByProject', {"key": sn});
      print(getSearchByProjectback);
      var data = jsonDecode(getSearchByProjectback);
      EasyLoading.dismiss();
      if (data["success"] && data["data"] != null) {
        if (data["data"].isEmpty) {
          EasyLoading.showError(tr("getSearchByProject.empty"));
        }
        setState(() {
          history = data["data"];
        });
      }
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    super.initState();
    getSearchHistories();
  }

  List showmenu = ["sysName", "module4gSn", "projectName"];
  List showhistorymenu = [
    "outdoorSn",
    "sysName",
    "module4gSn",
    "systemProtocol",
    "projectName",
    "projectCode",
  ];
  bool inputfocus = false;
  String sn = '';
  openscan() async {
    try {
      await platform.invokeMethod('SCANNER_TRIG');
    } on PlatformException catch (e) {
      print("Failed to SCANNER_TRIG: '${e.message}'.");
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
            'systemCapabilityAnalysisPage.projectSearch',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [],
        ),
        body: Container(
          color: const Color.fromRGBO(244, 244, 244, 1),
          padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
          constraints: BoxConstraints(minHeight: 1280.h - 56),
          child: SingleChildScrollView(
            child: SizedBox(
              width: 720.w,
              child: Column(
                children: [
                  baseContainer(
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
                                Stack(
                                  children: [
                                    Positioned(
                                        child: Container(
                                      margin:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                                                      20, 0, 10, 0),
                                              child: Image.asset(
                                                'public/images/waterPump/scran.png',
                                                width: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 0, 0),
                                                child: snInput(
                                                  isSamll: true,
                                                  hintText:
                                                      tr("search.hintText2"),
                                                  onfocus: () {},
                                                  valBack: (back) {
                                                    setState(() {
                                                      sn = back;
                                                    });
                                                    if (back == "") {
                                                      getSearchByProject();
                                                    }
                                                  },
                                                )),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              getSearchByProject();
                                            },
                                            child: Container(
                                              width: 75,
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
                                    )),
                                  ],
                                )
                              ],
                            )),
                      ),
                    ],
                  )),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (ishistory)
                        Padding(
                          padding: EdgeInsets.fromLTRB(24.w, 16, 24.w, 8),
                          child: Text(
                            'systemCapabilityAnalysisPage.systemSearch.label5',
                            style: ErrorTip(),
                          ).tr(),
                        ),
                      for (var historyitem in history)
                        InkWell(
                          onTap: () {
                            _selfcon.setSelectedSystem(historyitem);
                            Get.to(() => systemLocationpage(
                                projectCode: historyitem["code"]));
                          },
                          child: Container(
                              width: 720.w,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white),
                              margin: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16),
                              child: projectinfo(
                                showing: historyitem,
                                onClick: () {
                                  _selfcon.setSelectedSystem(historyitem);
                                  Get.to(() => systemLocationpage(
                                      projectCode: historyitem["code"]));
                                },
                              )),
                        )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
