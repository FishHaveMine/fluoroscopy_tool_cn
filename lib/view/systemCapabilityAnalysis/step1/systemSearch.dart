import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/snInput.dart';
import 'package:fluoroscopy_tool/store/globalData.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:fluoroscopy_tool/view/systemCapabilityAnalysis/step2/systemDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../selfpublicFunction.dart';
import 'projectSearch.dart';

class systemSearch extends StatefulWidget {
  var connectedSystem;
  systemSearch({super.key, required this.connectedSystem});

  @override
  State<systemSearch> createState() => _systemSearchState();
}

class _systemSearchState extends State<systemSearch> {
  static const platform = MethodChannel('samples.flutter.dev/battery');
  final deviceInfoController _deviceInfoController = Get.find();

  final systemAnalysisController _selfcon = Get.find();
  List history = [];
  updatahistroy(val) {
    setState(() {
      history = val;
    });
  }

  getSearchHistories() {
    try {
      platform.invokeMethod('getSearchHistories').then((value) => {
            if (value['data'] != null) {updatahistroy(value['data'])}
          });
    } catch (e) {}
  }

  searchBySn() async {
    bool conn = await checkNet(true);
    if (!conn) {
      EasyLoading.dismiss();
      return;
    }
    EasyLoading.show(status: 'loading...');
    try {
      var getSearchBySnback = await platform
          .invokeMethod('getSearchBySn', <String, dynamic>{"sn": sn});
      EasyLoading.dismiss();
      print("getSearchBySnback: $getSearchBySnback");
      if (getSearchBySnback["data"] != null) {
        if (getSearchBySnback["data"].isEmpty) {
          EasyLoading.showError(tr("search.empty"));
        }
        setState(() {
          history = getSearchBySnback["data"];
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
    "sysName",
    "outdoorSn",
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
            'systemCapabilityAnalysisPage.systemSearch',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [
            TextButton(
                onPressed: () {},
                child: Text(
                  'help',
                  style: normalTextS(),
                ).tr())
          ],
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
                  Container(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 22, 0, 0.h),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Positioned(
                                            child: Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 0),
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
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0, 0, 0),
                                                    child: snInput(
                                                      hintText: tr(
                                                          "snInput.hintText"),
                                                      isSamll: true,
                                                      onfocus: () {
                                                        setState(() {
                                                          sn = "";
                                                          history = [];
                                                          inputfocus = true;
                                                        });
                                                        getSearchHistories();
                                                      },
                                                      valBack: (back) {
                                                        setState(() {
                                                          sn = back;
                                                        });
                                                      },
                                                    )),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    inputfocus = true;
                                                    history = [];
                                                  });
                                                  searchBySn();
                                                },
                                                child: Container(
                                                  width: 55,
                                                  height: 36,
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              49),
                                                      color:
                                                          const Color.fromRGBO(
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
                          InkWell(
                            onTap: () {
                              Get.to(() => projectSearch());
                            },
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              color: const Color.fromRGBO(25, 98, 255, 0.06),
                              child: Center(
                                child: Text(
                                  'systemCapabilityAnalysisPage.systemSearch.label2',
                                  style: normalText(
                                      lineheight: 1,
                                      fSize: 14,
                                      fontcolor:
                                          const Color.fromRGBO(25, 98, 255, 1)),
                                ).tr(),
                              ),
                            ),
                          ),
                        ],
                      )),
                  if (!inputfocus)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_deviceInfoController
                                .loacalDevice.value.isconnected &&
                            widget.connectedSystem.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.fromLTRB(24.w, 16, 24.w, 8),
                            child: Text(
                              'systemCapabilityAnalysisPage.systemSearch.label3',
                              style: ErrorTip(),
                            ).tr(),
                          ),
                        if (_deviceInfoController
                                .loacalDevice.value.isconnected &&
                            widget.connectedSystem.isNotEmpty)
                          InkWell(
                              onTap: () {
                                _selfcon
                                    .setSelectedSystem(widget.connectedSystem);
                                Get.to(() => systemDetail());
                              },
                              child: Container(
                                color: Colors.white,
                                width: 720.w,
                                padding:
                                    const EdgeInsets.fromLTRB(13, 16, 13, 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (var item in showmenu)
                                      Row(
                                        children: [
                                          Text(
                                            // ignore: prefer_interpolation_to_compose_strings
                                            '${tr('info.' + item)}:',
                                            style: normalText(),
                                          ),
                                          Text(
                                            '${widget.connectedSystem[item] ?? "--"}',
                                            style: normalText(
                                                fontcolor: Colors.black),
                                          )
                                        ],
                                      )
                                  ],
                                ),
                              )),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                          child: Text(
                            'systemCapabilityAnalysisPage.systemSearch.label4',
                            style: ErrorTip(),
                          ).tr(),
                        ),
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.fromLTRB(13, 16, 13, 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'systemCapabilityAnalysisPage.systemSearch.label4_1',
                                style: titleText(),
                              ).tr(),
                              Text.rich(TextSpan(
                                  style: normalText(),
                                  text: tr(
                                      'systemCapabilityAnalysisPage.systemSearch.label4_2'))),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: Image.asset(
                                  'public/images/systemCapabilityAnalysis/indoor.jpg',
                                  width: 720.w - 26,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          margin: const EdgeInsets.fromLTRB(0, 16, 0, 50),
                          padding: const EdgeInsets.fromLTRB(13, 16, 13, 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'systemCapabilityAnalysisPage.systemSearch.label4_3',
                                style: titleText(),
                              ).tr(),
                              Text.rich(TextSpan(
                                  style: normalText(),
                                  text: tr(
                                      'systemCapabilityAnalysisPage.systemSearch.label4_4'))),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: const Color.fromRGBO(
                                          223, 223, 223, 1),
                                      width: 1,
                                    )),
                                margin: const EdgeInsets.all(4),
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'public/images/systemCapabilityAnalysis/gayway.jpg',
                                      width: 120,
                                    ),
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "0000CC311178CC",
                                          style: normalTextBlack(),
                                        ),
                                        Text("M262A244100094",
                                            style: normalTextBlack()),
                                        Text("17211200002941",
                                            style: normalTextBlack())
                                      ],
                                    ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  if (inputfocus)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (sn == "")
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                            child: Text(
                              'systemCapabilityAnalysisPage.systemSearch.label5',
                              style: ErrorTip(),
                            ).tr(),
                          ),
                        for (var historyitem in history)
                          InkWell(
                            onTap: () {
                              _selfcon.setSelectedSystem(historyitem);
                              print(historyitem);
                              Get.to(() => systemDetail());
                            },
                            child: Container(
                                width: 720.w,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white),
                                margin: EdgeInsets.fromLTRB(24.w, 0, 24.w, 12),
                                child: Column(
                                  children: [
                                    for (int index = 0;
                                        index < showhistorymenu.length;
                                        index++)
                                      Row(
                                        children: [
                                          Text(
                                            // ignore: prefer_interpolation_to_compose_strings
                                            '${tr('info.' + showhistorymenu[index])}:',
                                            style: normalText(),
                                          ),
                                          Expanded(
                                              child: Text(
                                            '${historyitem[showhistorymenu[index]] ?? '--'}',
                                            overflow: TextOverflow.ellipsis,
                                            style: normalText(
                                                fontcolor: Colors.black),
                                          )),
                                          if (index == 0)
                                            const Icon(Icons.chevron_right,
                                                color: Colors.black, size: 24),
                                        ],
                                      )
                                  ],
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
