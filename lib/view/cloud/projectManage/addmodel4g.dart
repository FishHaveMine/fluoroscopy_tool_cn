import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/snInput.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/cloud/publicFunction.dart';
import 'package:fluoroscopy_tool/view/systemCapabilityAnalysis/step2/pie_chart_sample.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import '../../systemCapabilityAnalysis/step2/sysinfo.dart';

class addmodel4g extends StatefulWidget {
  addmodel4g({super.key});

  @override
  State<addmodel4g> createState() => _addmodel4gState();
}

class _addmodel4gState extends State<addmodel4g> {
  final cloudProjectController _selectController =
      Get.put(cloudProjectController());
  static const platform = MethodChannel('samples.flutter.dev/battery');
  static const _selfplatform =
      MethodChannel('samples.flutter.dev/getTopologyHandler');
  String search = "";
  int selectIndex = -1;
  openscan() async {
    try {
      await platform.invokeMethod('SCANNER_TRIG');
    } on PlatformException catch (e) {
      print("Failed to SCANNER_TRIG: '${e.message}'.");
    }
  }

  _selectIndex(index) {
    if (selectIndex == index) {
      setState(() {
        selectIndex = -1;
      });
    } else {
      setState(() {
        selectIndex = index;
      });
    }
  }

  String cleanString(String input) {
    // 使用正则表达式匹配所有非字母数字的字符并替换为 ""
    return input.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
  }

  List history = [];
  getSearchHistories() async {
    EasyLoading.show(status: 'loading...');
    try {
      var project = _selectController.selectProject.value["project"];
      var send = {
        "sn": cleanString(search),
        "projectId": project["id"],
      };
      print("send:  $send");
      var historyback =
          await _selfplatform.invokeMethod('getUnArchivedDevice', {
        "sn": search,
        "projectId": project["id"],
      });

      var historydata = jsonDecode(historyback);
      print("historydata: $historydata");
      if (historydata["errorCode"] != null &&
          historydata["errorCode"].toString() == "1001") {
        //登录失效
        tologout();
      }

      EasyLoading.dismiss();
      if (!historydata['success']) {
        EasyLoading.showError(historydata['errorMsg']);
        return;
      }
      if (history.isEmpty) {
        // EasyLoading.showError(tr("snsearhingerror"));
      }
      // 根据 sysId 去重
      var uniqueData = {};
      for (var item in historydata["data"]) {
        uniqueData[item['sysId']!] = item;
      }

      // 转回去重后的 List
      var result = uniqueData.values.toList();
      setState(() {
        history.addAll(result);
      });
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
    }
  }

  _bindmodel() async {
    EasyLoading.show(status: 'loading...');
    try {
      var project = _selectController.selectProject.value["project"];
      var send = {
        "deviceNid": history[selectIndex]["nid"],
        "deviceSn": history[selectIndex]["sn"],
        "sysId": history[selectIndex]["sysId"],
        "projectId": project["id"],
      };
      print("send: $send");
      var addDeviceback = await _selfplatform.invokeMethod('addDevice', send);

      var historydata = jsonDecode(addDeviceback);
      print(historydata);
      if (historydata["errorCode"] != null &&
          historydata["errorCode"].toString() == "1001") {
        //登录失效
        tologout();
      }
      if (historydata['success']) {
        EasyLoading.showSuccess(tr("addmodel4g"));
        Future.delayed(const Duration(seconds: 3), () {
          EasyLoading.dismiss();
          Navigator.pop(context);
        });
      } else {
        EasyLoading.showError(historydata['errorMsg']);
      }
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    super.initState();
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
          // ignore: prefer_const_constructors
          title: Text(
            'addmodel4g.title',
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
          child: Column(children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  padding: const EdgeInsets.all(0),
                  height: 44,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(42),
                      color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          openscan();
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                          child: Image.asset(
                            'public/images/waterPump/scran.png',
                            width: 40.w,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: snInput(
                              hintText: tr("getsn"),
                              isSamll: true,
                              lengthLimit: false,
                              onfocus: () {},
                              valBack: (back) {
                                setState(() {
                                  search = back;
                                });
                                if (back == "") {
                                  setState(() {
                                    history = [];
                                  });
                                  // getSearchHistories();
                                }
                              },
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          if (search != "") {
                            setState(() {
                              history = [];
                            });
                            getSearchHistories();
                          }
                        },
                        child: Container(
                          width: 75,
                          height: 36,
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(49),
                              color: const Color.fromRGBO(25, 98, 255, 1)),
                          child: Center(
                            child: const Text(
                              'search',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ).tr(),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: ListView.builder(
                        itemCount: history.length,
                        itemBuilder: ((context, index) => InkWell(
                              onTap: () {
                                _selectIndex(index);
                              },
                              child: sysinfoadd(
                                connectedSystem: history[index],
                                isselect: selectIndex == index,
                              ),
                            ))))),
            Container(
              height: 57,
              padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
              child: Center(
                child: submitButton(
                  isActive: selectIndex != -1,
                  label: tr('addmodel4g.btn1'),
                  onClick: () async {
                    if (selectIndex != -1) _bindmodel();
                  },
                ),
              ),
            )
          ]),
        ));
  }
}

class sysinfoadd extends StatefulWidget {
  var connectedSystem;
  bool isselect;
  sysinfoadd({
    super.key,
    required this.connectedSystem,
    required this.isselect,
  });

  @override
  State<sysinfoadd> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<sysinfoadd>
    with SingleTickerProviderStateMixin {
  var info = {};
  var data = {};

  static const platform =
      MethodChannel('samples.flutter.dev/getProjectHandler');
  _init(sn) async {
    var send = {"projectCode": "", "sn": sn, "pageindex": 1};
    var historyback =
        await platform.invokeMethod('getProfessionalToolsHandler.page', send);
    var historydata = jsonDecode(historyback);
    try {
      print("insertSearchHistory: $historydata");
      if (historydata['success'] &&
          historydata['data'] != null &&
          historydata['data'][0] != null) {
        data = historydata['data'][0];
        online = historydata['data'][0]['indoorOnline'] ?? 0;
        error = historydata['data'][0]['indoorFault'] ?? 0;
        offline = historydata['data'][0]['indoorOffline'] ?? 0;
        indoorListlength = historydata['data'][0]['indoorNum'] ?? 0;
        setState(() {
          data;
          online;
          error;
          offline;
          indoorListlength;
        });
      }
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      info = widget.connectedSystem;
    });
    _init(info['sn']);
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _key = DateTime.now().millisecondsSinceEpoch.toString();
  int online = 0;
  int error = 0;
  int offline = 0;
  int indoorListlength = 0;
  countstatus(element) {
    if (element["status"] == 2) {
      error++;
    } else if (element["status"] == 0 || element["status"] == 3) {
      offline++;
    } else {
      online++;
    }
  }

  String sn = "";

  Map statusMap = {
    "0": "device_status0",
    "5": "device_status5",
    "1": "device_status1",
    "2": "device_status2",
    "3": "device_status3",
  };

  Map statusMapColor = {
    "0": Colors.grey,
    "5": Colors.green,
    "1": Colors.green,
    "2": Colors.red,
    "3": Colors.grey,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey("info_$_key"),
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      margin: const EdgeInsets.fromLTRB(0, 22, 0, 0),
      child: info.isNotEmpty
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
                  child: RoundCheckBox(
                    isChecked: widget.isselect,
                    onTap: null,
                    size: 24,
                    checkedWidget: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 14,
                    ),
                    disabledColor: widget.isselect
                        ? Theme.of(context).colorScheme.secondary
                        : Colors.white,
                    checkedColor: Theme.of(context).colorScheme.secondary,
                    border: Border.all(
                        // width: 1,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 200, // Maximum width
                                ),
                                child: SizedBox(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 15, 0),
                                    child: Text(
                                      info['name'].toString(),
                                      style: titleText(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 720.w - 17 * 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(TextSpan(children: [
                            TextSpan(
                                style: normalText(),
                                text: '${tr('deviceListinfo.sn', namedArgs: {
                                      'val': info['sn'].toString(),
                                    })}:${info['sn'].toString()}'),
                            if (info['gatewaySn'] != null)
                              TextSpan(
                                  style: normalText(),
                                  text:
                                      '\n${tr('systemCapabilityAnalysisPage.systemDetail.syslabel2', namedArgs: {
                                        'val': info['gatewaySn'].toString()
                                      })}'),
                            if (data['outdoorNum'] != null)
                              TextSpan(
                                  style: normalText(),
                                  text:
                                      '\n${tr('local.odu')}: ${data["outdoorNum"].toString()}'),
                            if (data['indoorNum'] != null)
                              TextSpan(
                                  style: normalText(),
                                  text:
                                      '\n${tr('local.idu')}: ${data["indoorNum"].toString()}'),
                          ])),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: (720.w - 17 * 2) * 0.6,
                            height: 114,
                            key: ValueKey("$online _ $error _ $offline"),
                            child: Stack(
                              children: [
                                PieChartSample2(dataPieChar: [
                                  {"key": tr("online"), "value": "$online"},
                                  {"key": tr("error"), "value": "$error"},
                                  {"key": tr("offline"), "value": "$offline"}
                                ]),
                                if (data['indoorNum'] != null)
                                  Positioned(
                                      left: 40,
                                      child: SizedBox(
                                          width: 80,
                                          height: 114,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                data["indoorNum"].toString(),
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              const Text(
                                                "indoorNum",
                                                style: TextStyle(fontSize: 10),
                                              ).tr()
                                            ],
                                          )))
                              ],
                            )),
                        Expanded(
                            child: Container(
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: Image.asset(
                                  'public/images/systemCapabilityAnalysis/outdoor.png',
                                  width: 16,
                                ),
                              ),
                              if (data['outdoorNum'] != null)
                                Text(
                                    '${tr('local.ODU')} ${data["outdoorNum"].toString()}'),
                            ],
                          )),
                        ))
                      ],
                    )
                  ],
                ))
              ],
            )
          : null,
    );
  }
}
