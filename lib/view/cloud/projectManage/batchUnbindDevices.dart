import 'dart:convert';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/deviceListinfo.dart';
import 'package:fluoroscopy_tool/compent/deviceSearchListinfo.dart';
import 'package:fluoroscopy_tool/compent/snInput.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/cloud/device/%20deviceDetail.dart';
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

class batchUnbindDevices extends StatefulWidget {
  batchUnbindDevices({super.key});

  @override
  State<batchUnbindDevices> createState() => _copybasepageState();
}

class _copybasepageState extends State<batchUnbindDevices> {
  static const platform =
      MethodChannel('samples.flutter.dev/getProjectHandler');

  final cloudProjectController _selectController =
      Get.put(cloudProjectController());
  List<String> menuItems = [
    // 'projectDetail.deviceManage.action1',
    // 'projectDetail.deviceManage.action2',
    // 'projectDetail.deviceManage.action3',
    // 'projectDetail.deviceManage.action4',

    'projectDetail.deviceManage.action5',
  ];
  CustomPopupMenuController _controller = CustomPopupMenuController();
  String search = "";

  int pageindex = 1;
  int total = 999;
  // 加载更多的标志
  bool isLoading = true;
  // 控制器用于监听滚动事件
  ScrollController _scrollController = ScrollController();

  List history = [];
  List select = [];

  getSearchHistories() async {
    EasyLoading.show(status: 'loading...');
    try {
      var project = _selectController.selectProject.value["project"];
      var historyback = await platform.invokeMethod(
          'getProfessionalToolsHandler.page', {
        "projectCode": project["code"].toString(),
        "sn": search,
        "pageindex": pageindex
      });

      var historydata = jsonDecode(historyback);
      total = historydata["totalCount"];
      setState(() {
        select = [];
        history.addAll(historydata["data"]);
        isLoading = false;
      });
      EasyLoading.dismiss();
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      EasyLoading.dismiss();
    }
  }

  unbind() async {
    EasyLoading.show(status: 'loading...');
    try {
      List normal = [];
      for (var element in select) {
        var selectDevice = history[element];
        normal.add({
          "deviceNid": selectDevice["nid"],
          "deviceSn": selectDevice["sn"].toString() == "{}"
              ? selectDevice["gatewaySn"]
              : selectDevice["sn"],
          "sysId": selectDevice["nid"],
        });
      }
      var project = _selectController.selectProject.value["project"];
      var send = {
        "projectId": project["id"].toString(),
        "deviceList": normal,
      };
      print("send:  $send");
      var batchUnbindDevices = await platform.invokeMethod(
          'getDeviceHandler.batchUnbindDevices', send);

      print(batchUnbindDevices);

      var historydata = jsonDecode(batchUnbindDevices);
      if (historydata["success"].toString() == "true") {
        EasyLoading.showSuccess(tr("batchUnbindDevices.success"));
      } else {
        if (historydata['errorMsg'] == null) {
          EasyLoading.showError(tr("batchUnbindDevices.error"));
        } else {
          EasyLoading.showError(historydata['errorMsg']);
        }
      }

      setState(() {
        select = [];
        history = [];
        pageindex = 1;
      });

      await Future.delayed(const Duration(seconds: 3), () {
        getSearchHistories();
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      EasyLoading.showError(tr("batchUnbindDevices.error"));
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    super.initState();
    getSearchHistories();
    // 添加滚动监听器
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // 移除滚动监听器
    _scrollController.dispose();
    super.dispose();
  }

  // 滚动监听器
  void _scrollListener() {
    // 如果滚动到底部并且不在加载状态中，则加载更多数据
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading &&
        history.length < total) {
      // setState(() {
      //   isLoading = true;
      // });
      pageindex++;
      // 模拟异步加载数据
      getSearchHistories();
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
            'projectDetail.deviceManage.action5',
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
              Container(
                margin: const EdgeInsets.fromLTRB(0, 12, 0, 12),
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: history.length,
                      controller: _scrollController,
                      itemBuilder: ((context, index) {
                        return Container(
                            padding: EdgeInsets.fromLTRB(32.w, 0.h, 32.w, 0.h),
                            child: InkWell(
                                onTap: () {
                                  if (!select.contains(index)) {
                                    select.add(index);
                                  } else {
                                    select.remove(index);
                                  }
                                  setState(() {
                                    select;
                                  });
                                  // _selectController
                                  //     .setSelectDevice(history[index]);

                                  // Get.to(() => deviceDetail());
                                },
                                child: Container(
                                    width: 720.w - 24.w * 2,
                                    padding: const EdgeInsets.all(11),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white),
                                    margin:
                                        EdgeInsets.fromLTRB(0.w, 0, 0.w, 16),
                                    child: deviceListinfo(
                                        search: search,
                                        showproject: false,
                                        isSelect: select.contains(index),
                                        onSelect: () {
                                          if (!select.contains(index)) {
                                            select.add(index);
                                          } else {
                                            select.remove(index);
                                          }
                                          setState(() {
                                            select;
                                          });
                                        },
                                        showing: history[index]))));
                      }))),
              Container(
                height: 57,
                padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                child: Center(
                  child: submitButton(
                    isActive: select.isNotEmpty,
                    label: tr('projectDetail.deviceManage.action5.btn'),
                    onClick: () async {
                      if (select.isNotEmpty) {
                        for (var element in select) {
                          print(history[element]);
                        }
                        bool issend = await divConfirmDialog(context,
                            isSubmitButton: true,
                            confirmTitle:
                                tr("device.controltDialog.confirmTitle"),
                            confirmDescriptionWidget: SizedBox(
                              width: 640.w,
                              height: 260,
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'batchUnbindDevices.tip1',
                                        style: normalTextBlack(
                                            fSize: 16, lineheight: 1.5),
                                      ).tr(),
                                      for (var element in select)
                                        Text(
                                          'batchUnbindDevices.tip2',
                                          style: normalTextBlack(
                                              fSize: 16, lineheight: 1.5),
                                        ).tr(namedArgs: {
                                          "sysname": history[element]
                                              ["systemName"],
                                          "sn1": history[element]["sn"]
                                                      .runtimeType
                                                      .toString() !=
                                                  "String"
                                              ? "--"
                                              : history[element]["sn"],
                                          "sn2": history[element]["gatewaySn"]
                                                      .runtimeType
                                                      .toString() !=
                                                  "String"
                                              ? "--"
                                              : history[element]["gatewaySn"]
                                        }),
                                      Text(
                                        'batchUnbindDevices.tip3',
                                        style: normalTextBlack(
                                            fSize: 16, lineheight: 1.5),
                                      ).tr(namedArgs: {
                                        "name": _selectController.selectProject
                                                .value["project"]["name"] ??
                                            ""
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                            ));
                        if (issend) {
                          unbind();
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
