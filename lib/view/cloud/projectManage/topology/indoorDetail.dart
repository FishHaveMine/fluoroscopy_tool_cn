import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/cloud/projectManage/topology/editIndoorName.dart';
import 'package:fluoroscopy_tool/view/cloud/projectManage/topology/groupManage.dart';
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

class indoorDetail extends StatefulWidget {
  String nid;
  indoorDetail({super.key, required this.nid});

  @override
  State<indoorDetail> createState() => _indoorDetailState();
}

class _indoorDetailState extends State<indoorDetail> {
  static const platform = MethodChannel('samples.flutter.dev/topology');
  var data;

  Map baseinfo = {
    "name": "设备名称",
    "levelOne": "所在位置",
    "sn": "设备SN",
    "deviceNo": "设备编号",
    "idxDesc": "设备通讯地址",
    "statusName": "设备状态",
  };

  Map baseinfo1 = {
    "indoorRunningHorses": "室内机能力",
    "lineControl": "线控器组号",
    "registerTime": "注册时间",
    "filthBlockageStatus": "脏堵率",
    "indoorTempT2": "T2传感器温度",
    "indoorTempT2B": "T2B传感器温度",
    "exv1Opening": "EXV开度",
  };

  final cloudProjectController _selectController = Get.find();

  _addAssociatedExisted(groupId) async {
    EasyLoading.show(status: 'loading...');
    try {
      var project = _selectController.selectProject.value["project"];
      var invokeMethodback =
          await platform.invokeMethod('getTopologyHandler.associatedExisted', {
        "projectId": project["id"],
        "deviceList": [
          {
            "deviceName": data["name"],
            "deviceSn": data["sn"],
            "nid": data["nid"],
          }
        ],
        "groupId": int.parse(groupId.toString())
      });
      var josndata = jsonDecode(invokeMethodback);

      EasyLoading.dismiss();
      if (josndata["success"]) {
        EasyLoading.showSuccess(tr("topology.onOffControl_success"));
      } else {
        EasyLoading.showError(josndata["errorMsg"]);
      }
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  _init() async {
    EasyLoading.show(status: 'loading...');
    Map<String, String> result = {};
    try {
      var getIndoorDeviceParamback = await platform
          .invokeMethod('getTopologyHandler.getIndoorDeviceParam', {
        "nid": widget.nid,
      });

      var getIndoorDeviceParam = jsonDecode(getIndoorDeviceParamback);
      for (var element in getIndoorDeviceParam['data'].keys) {
        var eldata = getIndoorDeviceParam['data'][element];
        if (eldata is Map) {
          if (eldata.containsKey('groupName')) {
            result[element] = eldata['groupName'].toString();
          } else if (eldata.containsKey('name')) {
            result[element] = eldata['name'].toString();
          } else {
            result[element] = '';
          }
        } else {
          result[element] = eldata.toString();
        }
      }
    } catch (e) {}
    try {
      var invokeMethodback =
          await platform.invokeMethod('getTopologyHandler.getDeviceDetail', {
        "nid": widget.nid,
      });

      var josndata = jsonDecode(invokeMethodback);

      try {
        for (var element in josndata['data'].keys) {
          var eldata = josndata['data'][element];
          if (eldata is Map) {
            if (eldata.containsKey('groupName')) {
              result[element] = eldata['groupName'].toString();
            } else if (eldata.containsKey('name')) {
              result[element] = eldata['name'].toString();
            } else {
              result[element] = '';
            }
          } else {
            result[element] = eldata.toString();
          }
        }
        for (var k in result.keys) {
          print("$k : ${result[k]}");
        }
        setState(() {
          data = result;
        });
      } catch (e) {
        print("result  error : $e");
      }
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
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
            'topology.title',
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
                  child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 720.w,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      child: Text(
                        tr("baseinfo"),
                        style: normalText(),
                      ),
                    ),
                    if (data != null)
                      for (var i in baseinfo.keys)
                        Container(
                          color: Colors.white,
                          height: 48,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          child: InkWell(
                              onTap: () async {
                                if (i == 'name') {
                                  var project = _selectController
                                      .selectProject.value["project"];
                                  var back = await Get.to(() => editIndoorName(
                                        nid: data["nid"],
                                        projectId: project["id"],
                                      ));

                                  _init();
                                }
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    tr("baseinfo.${i.toString().toLowerCase()}"),
                                    style: normalTextBlack(lineheight: 1),
                                  ),
                                  Expanded(
                                      child: SafeText(
                                    i == 'levelOne'
                                        ? '${data['levelOne']}${data['levelTwo'] != "" ? '> ${data['levelTwo']}' : data['levelTwo']}${data['levelThree'] != "" ? '> ${data['levelThree']}' : data['levelThree']}'
                                        : data[i],
                                    textAlign: TextAlign.right,
                                    style: normalText(lineheight: 1),
                                    needTr: false,
                                  )),
                                  if (i == 'name')
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14,
                                      color: Color.fromRGBO(140, 140, 140, 1),
                                    ),
                                ],
                              )),
                        ),
                    Container(
                      width: 720.w,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      child: Text(
                        tr("baseinfo1"),
                        style: normalText(),
                      ),
                    ),
                    if (data != null)
                      for (var i in baseinfo1.keys)
                        Container(
                          color: Colors.white,
                          height: 48,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                tr("baseinfo1.${i.toString().toLowerCase()}"),
                                style: normalTextBlack(lineheight: 1),
                              ),
                              Expanded(
                                  child: SafeText(
                                data[i],
                                textAlign: TextAlign.right,
                                style: normalText(lineheight: 1),
                                needTr: false,
                              ))
                            ],
                          ),
                        ),
                  ],
                ),
              )),
              Container(
                height: 57,
                padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                child: Center(
                  child: submitButton(
                    isActive: true,
                    label: tr('topology.bottom_btn3'),
                    onClick: () async {
                      var back = await Get.to(() => groupManage(
                            selecting: true,
                          ));
                      if (back != null && back['select'] != null) {
                        _addAssociatedExisted(back['select']['id']);
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
