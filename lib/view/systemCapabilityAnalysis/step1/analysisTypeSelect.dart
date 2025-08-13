import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:fluoroscopy_tool/view/systemCapabilityAnalysis/selfpublicFunction.dart';
import 'package:fluoroscopy_tool/view/systemCapabilityAnalysis/step1/systemSearch.dart';
import 'package:fluoroscopy_tool/view/systemCapabilityAnalysis/step2/systemDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

class analysisTypeSelect extends StatefulWidget {
  String title;
  analysisTypeSelect({super.key, required this.title});

  @override
  State<analysisTypeSelect> createState() => _analysisTypeSelectState();
}

class _analysisTypeSelectState extends State<analysisTypeSelect> {
  int _currentIndex = -1; // 用于跟踪当前展开的索引

  List<String> items = [
    'Item 1',
    'Item 2',
  ];

  final systemAnalysisController _selfcon = Get.find();
  var info = {};

  static const platform = MethodChannel('samples.flutter.dev/battery');

  final deviceInfoController _deviceInfoController = Get.find();
  getconnectbySn() async {
    if (_deviceInfoController.loacalDevice.value.isconnected) {
      try {
        if (_deviceInfoController.deviceTypeEnum.value == 1 &&
            (_deviceInfoController.loacalDevice.value.IDU == 0 ||
                _deviceInfoController.loacalDevice.value.IDU == 1)) {
          _selfcon.setConnectedSystem({});
          return;
        }
      } catch (e) {}
      try {
        var getSearchBySnback = await platform.invokeMethod(
            'getSearchBySn', <String, dynamic>{
          "sn": _deviceInfoController.loacalDevice.value.sn
        });
        print("getSearchBySnback   ${{
          "sn": _deviceInfoController.loacalDevice.value.sn
        }}: $getSearchBySnback");

        if (getSearchBySnback["empty"]) {
          EasyLoading.showError(tr("getSearchBySn.empty"));
          return;
        }
        if (getSearchBySnback["data"] != null) {
          info = getSearchBySnback["data"][0];
          _selfcon.setConnectedSystem(info);
          setState(() {
            info = getSearchBySnback["data"][0];
          });
        } else {
          if (getSearchBySnback["errorCode"] != null &&
              getSearchBySnback["errorCode"].toString() == "1001") {
            //登录失效
            tologout();
          }
        }
      } catch (e) {
        EasyLoading.showError(tr("getSearchBySn.empty"));
      }
    } else {
      _selfcon.setConnectedSystem({});
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getconnectbySn();
    });
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
            widget.title,
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
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      color: Colors.white,
                      margin: const EdgeInsets.fromLTRB(0, 13, 0, 13),
                      padding: const EdgeInsets.fromLTRB(24, 13, 24, 13),
                      child: Column(
                        children: [
                          InkWell(
                              onTap: () async {
                                if (index == 1) {
                                  EasyLoading.showInfo(tr("codingtip.Text"));
                                  return;
                                }
                                _selfcon.setSelectType(index);
                                if (_deviceInfoController
                                        .loacalDevice.value.isconnected &&
                                    info.isNotEmpty) {
                                  bool issend = await divConfirmDialog(context,
                                      confirmText: tr(
                                          "systemCapabilityAnalysisPage.analysisTypeSelect.Confirm"),
                                      confirmTitle: tr(
                                          "device.controltDialog.confirmTitle"),
                                      confirmDescriptionWidget:
                                          SingleChildScrollView(
                                              child: SizedBox(
                                        width: 560.w,
                                        height: 240,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              24, 0, 24, 0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                      style: normalTextBlack(),
                                                      'systemCapabilityAnalysisPage.analysisTypeSelect.ConfirmTip')
                                                  .tr(),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 15, 0, 0),
                                                child: Text(
                                                        style:
                                                            normalTextBlack(),
                                                        'systemCapabilityAnalysisPage.analysisTypeSelect.ConfirmTip1')
                                                    .tr(namedArgs: {
                                                  'val': info['sysName'] ?? "--"
                                                }),
                                              ),
                                              Text(
                                                      style: normalTextBlack(),
                                                      'systemCapabilityAnalysisPage.analysisTypeSelect.ConfirmTip2')
                                                  .tr(namedArgs: {
                                                'val':
                                                    info['module4gSn'] ?? "--"
                                              }),
                                              Text(
                                                      style: normalTextBlack(),
                                                      'systemCapabilityAnalysisPage.analysisTypeSelect.ConfirmTip3')
                                                  .tr(namedArgs: {
                                                'val':
                                                    info['projectName'] ?? "--"
                                              }),
                                            ],
                                          ),
                                        ),
                                      )));
                                  if (issend) {
                                    _selfcon.setSelectedSystem(info);
                                    Get.to(() => systemDetail());
                                  } else {
                                    Get.to(() =>
                                        systemSearch(connectedSystem: info));
                                  }
                                } else {
                                  Get.to(() =>
                                      systemSearch(connectedSystem: info));
                                }
                              },
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'public/images/menu/menu${index + 1}_active.png',
                                            width: 20,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                5, 0, 0, 5),
                                            child: Text(
                                              'systemCapabilityAnalysisPage.analysisTypeSelect.type${index + 1}',
                                              style: titleText(),
                                            ).tr(),
                                          )
                                        ],
                                      ),
                                      const Icon(Icons.chevron_right,
                                          color: Colors.black, size: 24)
                                    ],
                                  ),
                                  Text.rich(TextSpan(
                                      style: normalText(),
                                      text: tr(
                                          'systemCapabilityAnalysisPage.analysisTypeSelect.type${index + 1}.des'))),
                                ],
                              )),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                            margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            color: Colors.white,
                            child: ExpansionTile(
                              initiallyExpanded: _currentIndex == index,
                              backgroundColor: Colors.white, // 设置折叠时的背景为透明
                              collapsedBackgroundColor:
                                  Colors.white, // 设置折叠时的背景为透明
                              textColor: Colors.black, // 设置文本颜色为黑色
                              iconColor: Colors.black, // 设置图标颜色为黑色
                              tilePadding: const EdgeInsets.symmetric(
                                  horizontal: 0.0, vertical: 0.0),
                              onExpansionChanged: (bool expanded) {
                                setState(() {
                                  _currentIndex =
                                      expanded ? index : -1; // 更新当前展开的索引
                                });
                              },
                              title: const Text(
                                'showMore',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold),
                              ).tr(),
                              children: <Widget>[
                                // 可以在这里添加更多的子项或内容
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                  width: 720.w - 32.w * 2,
                                  child: Text.rich(TextSpan(
                                      style: normalText(),
                                      text: tr(
                                          'systemCapabilityAnalysisPage.analysisTypeSelect.type${index + 1}.detail'))),
                                ),
                              ],
                            ),
                          )
                        ],
                      ));
                })));
  }
}
