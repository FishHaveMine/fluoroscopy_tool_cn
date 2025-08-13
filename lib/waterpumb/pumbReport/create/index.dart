import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/waterpumb/pumbReport/create/preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_stepindicator/flutter_stepindicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../view/afterSalesReplacement/style.dart';

import 'package:fluoroscopy_tool/store/http.dart';
import 'ReportStep1Page.dart';
import 'ReportStep2Page.dart';
import 'ReportStep3Page.dart';
import 'ReportStep4Page.dart';
import 'ReportStep5Page.dart';
import 'public/InstallationInfo.dart';
import 'public/configObject.dart';
import 'public/publicObject.dart';
import 'unit/jsonFileService.dart';

import 'package:fluoroscopy_tool/waterpumb/pumbReport/create/com/tableByJson.dart';

class reportCreatePage extends StatefulWidget {
  VoidCallback onFinish;
  String sn;
  reportCreatePage({super.key, required this.sn, required this.onFinish});
  @override
  State<reportCreatePage> createState() => _reportCreatePageState();
}

class _reportCreatePageState extends State<reportCreatePage> {
  int activeStep = 0;
  int page = 0;
  int counter = 3;
  List list = List.generate(5, (index) => {index});
  String key = "_key";
  savestep(_selfController) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    try {
      _selfController.form['reportTime'].val = formattedDate;
    } catch (e) {}
    final prefs = await SharedPreferences.getInstance();
    var form = _selfController.form.toJson();

    var da = form;
    // for (var element in da.keys) {
    //   print('$element ---------------- ${da[element]}');
    // }
    prefs.setString("${widget.sn}", json.encode(form));
    prefs.setInt("${widget.sn}-page", page);

    print('// 本地保存值 _selfController.form.toJson()');
  }

  Future<InstallController>? _loadFuture;

  Future<InstallController> loadController() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString("${widget.sn}");
      print("loadController ${widget.sn} : jsonStr $jsonStr");
      page = prefs.getInt("${widget.sn}-page") ?? 0;
      setState(() {
        page;
      });
      final data = jsonStr != null ? json.decode(jsonStr) : {};
      final controller = InstallController(data);
      // 仅初始化一次
      if (!Get.isRegistered<InstallController>()) {
        Get.put(controller);
      }
      return controller;
    } catch (e) {
      final controller = InstallController({});
      Get.put(controller);
      print("loadController: error $e");
      return controller;
    }
  }

  Future<void> generateAndShareJsonFile(
      Map<String, dynamic> jsonData, String filename) async {
    try {
      // 获取临时目录
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/$filename.json';

      // 写入文件
      final file = File(filePath);
      await file.writeAsString(jsonEncode(jsonData));

      // 分享文件
      ShareExtend.share(filePath, "file");
    } catch (e) {
      debugPrint("分享 JSON 文件失败: $e");
    }
  }

  bool issubmiting = false;
  Future<void> toWaterMachineDebuggingSubmit(
      Map<String, dynamic> jsonData, context) async {
    if (issubmiting) return;
    EasyLoading.show(status: "loading...");
    issubmiting = true;
    try {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      jsonData['reportTime'] = formattedDate;
      jsonData['productCode'] = jsonData['productSn'];

      //  /**
      //  * 离心机组
      //  */
      // CENTRIFUGAL_CHILLER(1, "centrifugalChiller", "离心机组"),

      // /**
      //  * 涡旋机组
      //  */
      // SCROLL_CHILLER(2, "scrollChiller","涡旋机组"),

      // /**
      //  * 水冷螺杆机组
      //  */
      // WATERCOOLED_CHILLER(3,"waterCooledChiller","水冷螺杆机组"),

      // /**
      //  * 风冷螺杆机组
      //  */
      // AIRCOOLED_CHILLER(4,"airCooledChiller","风冷螺杆机组"),

      // /**
      //  * 磁悬浮机组
      //  */
      // MAGNETICLEVITATION_CHILLER(5,"magneticLevitationChiller","磁悬浮机组");

      var productModelMap = {
        "离心机组": "centrifugalChiller",
        "磁悬浮冷水机组": "magneticLevitationChiller",
        "涡旋机组": "scrollChiller",
        "水冷螺杆机组": "waterCooledChiller",
        "风冷螺杆机组": "airCooledChiller",
      };
      var send = {
        "sn": jsonData['productSn'],
        "productModel": productModelMap[jsonData['debugModel']],
        "branchCode": jsonData['branchCode'],
        "branchName": jsonData['branchName'],
        "projectCode": jsonData['projectCode'],
        "projectName": jsonData['projectName'],
        "projectId": jsonData['projectId'],
        "projectLocation": jsonData['projectLocal'],
        "contactPerson": jsonData["customerRepresentativeName"],
        "contactNumber": jsonData["customerRepresentativePhone"],
        "debugUserName": jsonData["mideaServicePersonName"],
        "debugUserPhone": jsonData["mideaServicePersonPhone"],
        "jsonData": json.encode(jsonData),
      };

      print("getSearchHistories send -- : $send");
      var getSearchHistories = await MideaApi.waterMachineDebuggingSubmit(send);
      EasyLoading.dismiss();
      print("getSearchHistories: $getSearchHistories");
      if (getSearchHistories["errorCode"] == 200) {
        EasyLoading.showSuccess("提交成功");
        final prefs = await SharedPreferences.getInstance();
        prefs.remove("${widget.sn}");
        prefs.remove("${widget.sn}-page");
        widget.onFinish();
        Future.delayed(const Duration(seconds: 2), () {
          issubmiting = false;
          Navigator.pop(context);
        });
      } else {
        EasyLoading.showSuccess("提交失败");
        issubmiting = false;
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showSuccess("提交失败");
      issubmiting = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadFuture = loadController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get height of app bar
    double appBarHeight = AppBar().preferredSize.height;

    // Calculate remaining height for page content
    double contentHeight = MediaQuery.of(context).size.height - appBarHeight;
    return FutureBuilder<InstallController>(
        future: _loadFuture,
        key: ValueKey(key),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          }

          final controller = snapshot.data!;
          return GetBuilder<InstallController>(
              builder: (_) => Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      leading: IconButton(
                          onPressed: () {
                            widget.onFinish();
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.chevron_left,
                              color: Colors.black, size: 36)),
                      title: const Text(
                        '冷水机组调试报告',
                        style: TextStyle(color: Colors.black),
                      ),
                      centerTitle: true,
                      actions: [
                        // if (page == 0 && kDebugMode)
                        //   TextButton(
                        //       onPressed: () {
                        //         toWaterMachineDebuggingSubmit(
                        //             mockdata, context);
                        //       },
                        //       child: Text("模拟")),
                        if (page == 3)
                          TextButton(
                              onPressed: () {
                                _.ispreview.value = true;
                                Get.to(() => reportPreviewPage());
                              },
                              child: Text("预览"))
                      ],
                    ),
                    body: Container(
                        width: 720.w,
                        color: Colors.white,
                        height: contentHeight,
                        padding: EdgeInsets.fromLTRB(0.w, 24.w, 0.w, 0.w),
                        child: SingleChildScrollView(
                            child: Column(
                          children: [
                            Container(
                              width: double.maxFinite,
                              height: 30,
                              margin: EdgeInsets.fromLTRB(32.w, 0.w, 32.w, 0.w),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 7),
                                child: FlutterStepIndicator(
                                  height: 28,
                                  paddingLine:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  positiveColor:
                                      const Color.fromRGBO(0, 128, 255, 1),
                                  progressColor:
                                      const Color.fromRGBO(0, 128, 255, 1),
                                  negativeColor: const Color(0xFFD5D5D5),
                                  padding: const EdgeInsets.all(4),
                                  list: list,
                                  division: list.length,
                                  onChange: (i) {},
                                  page: page,
                                  onClickItem: (p0) {},
                                ),
                              ),
                            ),
                            Container(
                              height: 30,
                              padding:
                                  EdgeInsets.fromLTRB(32.w, 0.w, 32.w, 0.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  for (int index = 0;
                                      index < list.length;
                                      index++)
                                    Text(
                                      tr("Step${index + 1}"),
                                      style: page >= index
                                          ? ActiveTip()
                                          : ErrorTip(),
                                    ),
                                ],
                              ),
                            ),
                            if (page == 0)
                              ReportStep1Page(
                                next: () {
                                  savestep(_);
                                  setState(() {
                                    page = 1;
                                  });
                                },
                                pre: () {
                                  print(controller.form.toJson());
                                },
                              ),
                            if (page == 1)
                              ReportStep2Page(
                                next: () {
                                  savestep(_);
                                  setState(() {
                                    page = 2;
                                  });
                                },
                                pre: () {
                                  setState(() {
                                    page = 0;
                                  });
                                },
                              ),
                            if (page == 2)
                              ReportStep3Page(
                                next: () {
                                  savestep(_);
                                  _.switchDebugModel(_.form["debugModel"].val);
                                  setState(() {
                                    page = 3;
                                  });
                                },
                                pre: () {
                                  setState(() {
                                    page = 1;
                                  });
                                },
                              ),
                            if (page == 3)
                              ReportStep4Page(
                                next: () {
                                  savestep(_);
                                  setState(() {
                                    page = 4;
                                  });
                                },
                                pre: () {
                                  setState(() {
                                    page = 2;
                                  });
                                },
                              ),
                            if (page == 4)
                              ReportStep5Page(
                                next: () async {
                                  savestep(_);
                                  var form = _.form.toJson();
                                  try {
                                    var page = [];
                                    for (var element in _.step3) {
                                      if (element.runtimeType == String) {
                                        page.add(element);
                                      } else if (element.runtimeType ==
                                          FormItem) {
                                        page.add(element.toJson());
                                      } else if (element.runtimeType ==
                                          TableConfig) {
                                        page.add(element.toFormValueJson(_));
                                      } else {
                                        Map<String, dynamic> back =
                                            _.getTableAllProperties(
                                                element.runtimeType);
                                        //如果是表格 back 有数据返回
                                        if (back['TableRow'].length != 0) {
                                          page.add(back);
                                        }
                                      }
                                    }
                                    var orthercheck = [];
                                    try {
                                      if (_.form['debugModel'].val ==
                                          "水冷螺杆机组") {
                                        orthercheck = [
                                          '其他检查事项',
                                          _.form['customerTargetTemperature']
                                              .toJson(),
                                          _.form['userSideSupplyVoltagePhase1']
                                              .toJson(),
                                          _.form['userSideSupplyVoltagePhase2']
                                              .toJson(),
                                          _.form['userSideSupplyVoltagePhase3']
                                              .toJson(),

                                          _.form['chilledWaterInletOutletPressureDifference']
                                              .toJson(), //冷冻水进出口压差
                                          _.form['coolingWaterInletOutletPressureDifference']
                                              .toJson(), //冷冻水进出口压差

                                          _.form['unitVibrationNoiseCheck']
                                              .toJson(), //运行状态下机组振动、噪音检查
                                          _.form['vibrationNoiseIssueDesc']
                                              .toJson(), // 运行状态下机组振动、噪音检查异常情况说明
                                          _.form['fluorideSideFilterTemperatureDifference']
                                              .toJson(), //氟侧系统过滤器前后温差

                                          _.form['oilReturnSystemStatus']
                                              .toJson(), // 回油系统检查（引射回油）
                                          _.form['oilReturnSystemIssueDesc']
                                              .toJson(), // 回油
                                          "（平稳运行状态下，温差应低于5℃）",
                                          "运行状态蒸发压力正常范围220～400KPa，冷凝压力正常范围700～1150KPa；",
                                          "平稳运行状态下，换热器端温差应小于3℃，高于此温差时，换热器换热效率降低，需进行清洗，建议最长1年清洗一次，如果水质较差，清洗频次需增加。敬请关注日常水系统水质管理。注：换热器清洗属于有偿服务项目。",
                                        ];
                                      }
                                    } catch (e) {}
                                    /** 完成构建自动分布的表单 */
                                    form["pageAutoFlex"] = page;
                                    form["orthercheck"] = orthercheck;
                                    form["runningdataGroup"] =
                                        _.getrunningdataGroup();

                                    // try {
                                    //   await JsonFileService.saveJsonToFile(
                                    //     'form_data(${_.form['debugModel'].val}_${_.form['productSn'].val}).json',
                                    //     form,
                                    //     subDirectory: 'forms', // 可选子目录
                                    //   );
                                    //   print('保存成功');
                                    // } catch (e) {
                                    //   print('保存失败: $e');
                                    // }
                                  } catch (e) {}
                                  toWaterMachineDebuggingSubmit(form, context);
                                },
                                pre: () {
                                  setState(() {
                                    page = 3;
                                  });
                                },
                              )
                          ],
                        ))),
                  ));
        });
  }
}
