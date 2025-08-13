import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/systemCapabilityAnalysis/selfpublicFunction.dart';
import 'package:fluoroscopy_tool/view/systemCapabilityAnalysis/step2/systemDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

class systemLocationpage extends StatefulWidget {
  String projectCode;
  systemLocationpage({super.key, required this.projectCode});

  @override
  State<systemLocationpage> createState() => _copybasepageState();
}

class _copybasepageState extends State<systemLocationpage> {
  static const platform =
      MethodChannel('samples.flutter.dev/getSystemDataHandler');
  int status = 0;
  bool issuccess = true;
  bool showResult = false;
  List indoors = [];

  final systemAnalysisController _selfcon = Get.find();
  List getIndoorTopologyDataBack = [];

  int _remainingSeconds = 10; //超时时间
  late Timer _timer;

  getIndoorTopologyData(val) async {
    if (!val) {
      EasyLoading.show(status: 'loading...');
    }
    try {
      var getIndoorTopologyData = await platform
          .invokeMethod('getIndoorTopologyData', <String, dynamic>{
        "projectCode": "XM221104186950",
        "latestIndoor": val,
      });

      var data = jsonDecode(getIndoorTopologyData);
      print(
          "data: $val ${data["data"].isEmpty} ${data["data"].length}  ${data["data"]}");
      if (val) {
        try {
          _timer.cancel();
        } catch (e) {}
        if (data["data"].isEmpty) {
          setState(() {
            status = 2;
            issuccess = false;
          });
        } else {
          setState(() {
            status = 2;
            issuccess = true;
            getIndoorTopologyDataBack = data["data"];
          });
          Future.delayed(const Duration(seconds: 3), () {
            setState(() {
              showResult = true;
            });
          });
        }
        return;
      }
      if (data["success"] && data['data'] != null) {
        setState(() {
          indoors = data['data'];
        });
      }

      EasyLoading.dismiss();
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
    }
  }

  successhander() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.back();
    });
  }

  startloaction() {
    /**
     * 定时器处理超时
     */
    setState(() {
      _remainingSeconds = 60;
      status = 1;
      issuccess = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer.cancel();
          setState(() {
            status = 2;
            issuccess = false;
          });
        }
      });
    });

    getIndoorTopologyData(true);
  }

  @override
  void initState() {
    super.initState();
    getIndoorTopologyData(false);
  }

  @override
  void dispose() {
    super.dispose();
    try {
      _timer.cancel();
    } catch (e) {}
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
            icon:
                const Icon(Icons.chevron_left, color: Colors.black, size: 36)),
        title: const Text(
          'systemCapabilityAnalysisPage.projectSearch',
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 720.w,
                // height: issuccess ? 353 : 480,
                padding: !showResult
                    ? const EdgeInsets.fromLTRB(0, 20, 0, 25)
                    : const EdgeInsets.all(0),
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: status == 0
                        ? [
                            Image.asset(
                              'public/images/systemCapabilityAnalysis/start.png',
                              width: 140,
                            ),
                            Center(
                              child: SizedBox(
                                width: 560.w,
                                child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 17, 0, 0),
                                    child: Text(
                                      "systemCapabilityAnalysisPage.projectSearch.start.tip1",
                                      style: normalTextBlack(
                                        fSize: 16,
                                        fw: FontWeight.w500,
                                      ),
                                    ).tr()),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                              child: Text(
                                "systemCapabilityAnalysisPage.projectSearch.start.tip2",
                                style: normalTextBlack(
                                    lineheight: 1,
                                    fontcolor:
                                        const Color.fromRGBO(249, 83, 78, 1)),
                              ).tr(),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 12, 0, 18),
                              child: Text(
                                "systemCapabilityAnalysisPage.projectSearch.start.tip2_1",
                                style: normalTextBlack(
                                    lineheight: 1,
                                    fontcolor:
                                        const Color.fromRGBO(249, 83, 78, 1)),
                              ).tr(),
                            ),
                            SizedBox(
                              width: 112,
                              height: 36,
                              child: normalButton(
                                  label: tr(
                                      'systemCapabilityAnalysisPage.projectSearch.start.btn'),
                                  onClick: () {
                                    startloaction();
                                  }),
                            )
                          ]
                        : status == 1
                            ? [
                                Image.asset(
                                  'public/images/waterPump/loading.gif',
                                  width: 140,
                                ),
                                Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 17, 0, 0),
                                    child: Text(
                                      "systemCapabilityAnalysisPage.projectSearch.start.tip3",
                                      style: normalTextBlack(
                                        fSize: 16,
                                        fw: FontWeight.w500,
                                      ),
                                    ).tr()),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 12, 0, 18),
                                  child: Text(
                                    "systemCapabilityAnalysisPage.projectSearch.start.tip4",
                                    style: normalText(),
                                  ).tr(),
                                ),
                              ]
                            : showResult
                                ? [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 720.w,
                                          color: const Color.fromRGBO(
                                              244, 244, 244, 1),
                                          padding: EdgeInsets.fromLTRB(
                                              24.w, 24, 0, 8),
                                          child: Text(
                                            textAlign: TextAlign.left,
                                            tr('systemCapabilityAnalysisPage.projectSearch.localnum',
                                                namedArgs: {
                                                  "val":
                                                      "${getIndoorTopologyDataBack.length}"
                                                }),
                                            style: normalText(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    for (var item in getIndoorTopologyDataBack)
                                      InkWell(
                                          onTap: () {
                                            _selfcon.setSelectedSystem(item);
                                            Get.off(() => systemDetail());
                                          },
                                          child: indoorinfo(
                                              item: item,
                                              isDisable: !showResult,
                                              clickAble: true))
                                  ]
                                : [
                                    Image.asset(
                                      issuccess
                                          ? 'public/images/afterSalesReplacement/success.png'
                                          : 'public/images/afterSalesReplacement/error.png',
                                      width: 140,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 8, 0, 0),
                                        child: Text(
                                          issuccess
                                              ? "systemCapabilityAnalysisPage.projectSearch.start.success"
                                              : "systemCapabilityAnalysisPage.projectSearch.start.error",
                                          style: normalTextBlack(
                                            fSize: 16,
                                            lineheight: 1,
                                            fw: FontWeight.w500,
                                          ),
                                        ).tr()),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 12, 0, 27),
                                      child: Text.rich(
                                          TextSpan(
                                              style: normalText(
                                                  fontcolor: Colors.red),
                                              text: tr(issuccess
                                                  ? 'systemCapabilityAnalysisPage.projectSearch.start.successtip'
                                                  : "systemCapabilityAnalysisPage.projectSearch.start.errortip")),
                                          textAlign: TextAlign.center),
                                    ),
                                    if (!issuccess)
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 25),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 112,
                                                  height: 36,
                                                  child: normalButton(
                                                    label: tr(
                                                        "systemCapabilityAnalysisPage.projectSearch.start.errorBtn1"),
                                                    onClick: () {
                                                      Get.back();
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 40,
                                                ),
                                                SizedBox(
                                                  width: 112,
                                                  height: 36,
                                                  child: submitButton(
                                                    label: tr(
                                                        "systemCapabilityAnalysisPage.projectSearch.start.errorBtn2"),
                                                    onClick: () {
                                                      startloaction();
                                                    },
                                                    isActive: true,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ))
                                  ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(24.w, 24, 0, 8),
                    child: Text(
                      textAlign: TextAlign.left,
                      tr('systemCapabilityAnalysisPage.projectSearch.indoornum',
                          namedArgs: {"val": "${indoors.length}"}),
                      style: normalText(),
                    ),
                  ),
                ],
              ),
              ListView.builder(
                  shrinkWrap: true, // 根据子项的大小调整高度
                  physics: NeverScrollableScrollPhysics(), // 禁用滑动
                  itemCount: indoors.length,
                  itemBuilder: ((context, index) => indoorinfo(
                      item: indoors[index],
                      isDisable: showResult,
                      clickAble: false)))
            ],
          ),
        ),
      ),
    );
  }
}

class indoorinfo extends StatefulWidget {
  var item;
  bool isDisable;
  bool clickAble;
  indoorinfo(
      {super.key,
      required this.item,
      required this.isDisable,
      required this.clickAble});

  @override
  State<indoorinfo> createState() => _indoorinfoState();
}

class _indoorinfoState extends State<indoorinfo> {
  var item;
  String runningmode = "";
  String temp = "";
  String idx = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.item['propertyList'] != null) {
        for (var element in widget.item['propertyList']) {
          if (element["name"] == "tempSetting") {
            temp = element["value"] + element["unit"];
          }

          if (element["name"] == "runMode") {
            runningmode = element["desc"];
          }
          if (element["name"] == "idx") {
            idx = element["desc"];
          }
        }
      }
      setState(() {
        temp;
        runningmode;
        idx;
      });
    });
    setState(() {
      item = widget.item;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 720.w,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: widget.isDisable
              ? const Color.fromRGBO(244, 244, 244, 1)
              : Colors.white,
          border: const Border(
            bottom: BorderSide(
              color: Color.fromRGBO(223, 223, 223, 1),
              width: 0.5,
            ),
          )),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item["name"],
                  style: normalTextBlack(fSize: 17, lineheight: 1.2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: item["statusName"] == "运行"
                          ? const Color(0xFF20AF42)
                          : const Color.fromRGBO(
                              249, 83, 78, 1), // 使用十六进制颜色码定义颜色
                      width: 0.5, // 边框宽度，单位为逻辑像素
                    ),
                    borderRadius: BorderRadius.circular(2), // 圆角半径，单位为逻辑像素
                  ),
                  child: Text(
                    item["statusName"],
                    style: normalText(
                        fontcolor: item["statusName"] == "运行"
                            ? const Color(0xFF20AF42)
                            : const Color.fromRGBO(249, 83, 78, 1),
                        lineheight: 1),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: Row(
              children: [
                Text(runningmode),
                Container(
                  width: 1,
                  height: 14,
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  color: const Color.fromRGBO(223, 223, 223, 1),
                ),
                Text(temp)
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                    child: Icon(
                      Icons.room,
                      size: 16,
                      color: Color.fromRGBO(15, 17, 28, 0.5),
                    ),
                  ),
                  Text(
                    "${tr("table.address")}:",
                    style: normalText(),
                  ),
                  Text(
                    idx,
                    style: normalText(),
                  )
                ],
              ),
              if (widget.clickAble)
                const Icon(
                  Icons.chevron_right,
                  color: Color.fromRGBO(140, 140, 140, 1),
                )
            ],
          )
        ],
      ),
    );
  }
}
