import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/compent/textinput.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/view/cloud/projectCreate/oldProject/step1.dart';
import 'package:fluoroscopy_tool/view/cloud/projectManage/deviceManage.dart';
import 'package:fluoroscopy_tool/view/cloud/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../waterpumb/pumbReport/create/public/InstallationInfo.dart';
import 'publicFunction.dart';

class addmodelM0_step4 extends StatefulWidget {
  addmodelM0_step4({super.key});

  @override
  State<addmodelM0_step4> createState() => _addmodelM0_step4State();
}

class _addmodelM0_step4State extends State<addmodelM0_step4> {
  final MOaddController _selectController = Get.put(MOaddController());

  final cloudProjectController _selectcloudProjectController = Get.find();
  static const _selfplatform =
      MethodChannel('samples.flutter.dev/getProjectHandler');

  @override
  void initState() {
    super.initState();
    _getValByMOaddController();
  }

  String systemName = "";
  String waterHardness = "";
  String pieces = "";
  String usedTimeYear = ""; // 外机运行年限
  String refType = ""; // 冷媒类型 R22 / R410A / R32
  String coolCop = ""; // 额定制冷COP
  String heatCop = ""; //额定制冷COP

  _getValByMOaddController() {
    setState(() {
      systemName = _selectController.jsonObject['systemName'].toString();
      waterHardness = _selectController.jsonObject['waterHardness'].toString();
      pieces = _selectController.jsonObject['pieces'].toString();
      usedTimeYear = _selectController.jsonObject['usedTimeYear'].toString();
      refType = _selectController.jsonObject['refType'].toString();
      coolCop = _selectController.jsonObject['coolCop'].toString();
      heatCop = _selectController.jsonObject['heatCop'].toString();

      _refTypeTextEditingController.text =
          _selectController.jsonObject['refType'].toString();
    });
  }

  List<selectItem> refTypeOP = [
    selectItem(label: 'R22', val: 'R22'),
    selectItem(label: 'R410A', val: 'R410A'),
    selectItem(label: 'R32', val: 'R32'),
  ];
  TextEditingController _refTypeTextEditingController = TextEditingController();

  _showselect(context, _) async {
    var _projectName = await showBottomSheetDialog(refTypeOP, '', context);
    if (_projectName != null) {
      _refTypeTextEditingController.text = refTypeOP[_projectName].label;
      setState(() {
        refType = refTypeOP[_projectName].label;
        _.updateDeviceInfo('refType', refType);
      });
    }
  }

  final debouncer = Debouncer(milliseconds: 1000);

  void onSearchChanged() {
    debouncer.run(() {
      _toadd();
      // 调用你的搜索 API 或更新状态
    });
  }

  bool isloading = false;
  _toadd() async {
    if (waterHardness != "") {
      /** 有水质硬度输入 46-338 mg/L */
      try {
        double? waterHardnessNum = double.tryParse(waterHardness);
        if (waterHardnessNum != null) {
          if (waterHardnessNum < 46 || waterHardnessNum > 338) {
            EasyLoading.showError("水质硬度可输入范围:46~338 mg/L");
            return;
          }
        } else {
          EasyLoading.showError("水质硬度可输入范围:46~338 mg/L");
          return;
        }
      } catch (e) {}
    }
    if (isloading) {
      return;
    }

    isloading = true;
    // 创建主 JSON 对象
    Map<String, dynamic> jsonObject = {
      "deviceType": _selectController.jsonObject["deviceType"],
      "productBrand": _selectController.jsonObject["productBrand"],
      "modifyType": _selectController.jsonObject["modifyType"]
          .toString()
          .replaceAll("modifyType", ""),
      "series": _selectController.jsonObject["series"],
      "systemName": systemName,
      "eauxiliaryHeat": "1",
      "projectCode": _selectController.jsonObject["projectCode"],
      "waterHardness": waterHardness,
      "uploadLocation": _selectController.jsonObject["uploadLocation"],
      "usedTimeYear": usedTimeYear,
      "refType": refType,
      "coolCop": coolCop,
      "heatCop": heatCop,
      "moduleInfos": [] // 初始化为一个空列表
    };

    // var modifyType2map = [
    //   {"title": "旧改云联盒子(请补充照片)", "des": "完整拍摄包含空调主体及旧改模块安装盒的照片"}, - cloudConnectionBoxImg
    //   {"title": "现场取电位置(请补充照片)", "des": "根据供电方式选择拍摄供电插座或接线位置"}, - powerPositionImg
    //   {"title": "外机铭牌照片(请补充照片)", "des": "请正对外机铭牌进行拍摄，尽量保证图片高清，文字清晰"},
    //   {"title": "其它照片", "des": "上传更多可反映现场照片，不限于散热器局部"} - otherImg
    // ];

    // var modifyType1map = [
    //   {"title": "旧改云联盒子(请补充照片)", "des": "完整拍摄包含空调主体及旧改模块安装盒的照片"}, - cloudConnectionBoxImg
    //   {"title": "喷淋装置安装(请补充照片)", "des": "完整拍摄包含空调主体及喷淋装置的照片"}, - sprayDeviceInstallImg
    //   {"title": "现场取电位置(请补充照片)", "des": "根据供电方式选择拍摄供电插座或接线位置"}, - powerPositionImg
    //   {"title": "水质检测数据/水质处理装置(请补充照片)", "des": "可选择拍摄水质检测报告照片或完整拍摄水质"}, - waterTreatmentDeviceImg
    //   {"title": "外机铭牌照片(请补充照片)", "des": "请正对外机铭牌进行拍摄，尽量保证图片高清，文字清晰"},
    //   {"title": "其它照片", "des": "上传更多可反映现场照片，不限于散热器局部"} - otherImg
    // ];

    /**
     * 旧改云联盒子图片路径
     */
    // @ApiModelProperty("旧改云联盒子图片")
    // private String cloudConnectionBoxImg;

    // /**
    //  * 喷淋装置安装图片路径
    //  */
    // @ApiModelProperty("喷淋装置安装图片")
    // private String sprayDeviceInstallImg;

    // /**
    //  * 取电位置图片路径
    //  */
    // @ApiModelProperty("取电位置图片")
    // private String powerPositionImg;

    // /**
    //  * 水质处理装置图片路径
    //  */
    // @ApiModelProperty("水质处理装置图片")
    // private String waterTreatmentDeviceImg;

    // /**
    //  * 其它图片路径
    //  */
    // @ApiModelProperty("其它图片")
    // private String otherImg;

    // /**
    //  * 外机铭牌照片路径
    //  */
    // @ApiModelProperty("外机铭牌照片")
    // private String outdoorNamePlateImg;
    // 创建 moduleInfos 对象

    /**
     * 外机运行年限
     */
    // @ApiModelProperty(value = "外机运行年限")
    // private String usedTimeYear;

    // /**
    //  * 冷媒类型
    //  */
    // @ApiModelProperty("冷媒类型")
    // private String refType;

    // /**
    //  * 额定制冷COP
    //  */
    // @ApiModelProperty("额定制冷COP")
    // private String coolCop;

    // /**
    //  * 额定制冷COP
    //  */
    // @ApiModelProperty("额定制热COP")
    // private String heatCop;

    Map<String, dynamic> moduleInfos = {
      "moduleSn": _selectController.jsonObject["moduleSn"],
      "moduleType": _selectController.jsonObject["moduleType"],
      "pieces": pieces,
      "oldReformImgDataCompleteness": "ALL"
    };
    if (_selectController.jsonObject["modifyType"] == "modifyType2" ||
        _selectController.jsonObject["modifyType"] == "modifyType4") {
      moduleInfos = {
        ...moduleInfos,
        "cloudConnectionBoxImg": _selectController.imgaeList["type1"],
        "powerPositionImg": _selectController.imgaeList["type2"],
        "outdoorNamePlateImg": _selectController.imgaeList["type3"],
        "otherImg": _selectController.imgaeList["type4"],
      };
    } else {
      moduleInfos = {
        ...moduleInfos,
        "cloudConnectionBoxImg": _selectController.imgaeList["type1"],
        "sprayDeviceInstallImg": _selectController.imgaeList["type2"],
        "powerPositionImg": _selectController.imgaeList["type3"],
        "waterTreatmentDeviceImg": _selectController.imgaeList["type4"],
        "outdoorNamePlateImg": _selectController.imgaeList["type5"],
        "otherImg": _selectController.imgaeList["type6"],
      };
    }

    print(" ---------- 提交 的 moduleInfos -------------");
    for (var element in moduleInfos.keys) {
      print(
          " ---------- 提交 的 moduleInfos $element ------------- ${moduleInfos[element]}");
    }

    // 将 moduleInfos 添加到 moduleInfos 列表
    // jsonObject["moduleInfos"].add(moduleInfos);

    // 转换为 JSON 字符串以供使用
    // String jsonString = jsonEncode(jsonObject);
    print(jsonObject);
    EasyLoading.show(status: 'loading...');
    try {
      var historyback = await _selfplatform
          .invokeMethod('getAppFluorineMachineEnergyHandler.addEnergySys', {
        "jsonObject": jsonObject,
        "moduleInfos": moduleInfos,
      });

      var historydata = jsonDecode(historyback);
      print(historyback);
      isloading = false;
      if (historydata["errorCode"] != null &&
          historydata["errorCode"].toString() == "1001") {
        //登录失效
        tologout();
      }
      if (!historydata["success"]) {
        EasyLoading.showError(historydata['errorMsg']);
      } else {
        EasyLoading.showSuccess(tr('MOadd.step4.success'));
        var pro = _selectcloudProjectController.selectProject;
        Future.delayed(const Duration(seconds: 2), () {
          Get.offUntil(
            MaterialPageRoute(
              builder: (context) => deviceManage(
                  // base: pro,
                  ),
            ),
            (route) =>
                route.settings.name == '/home' ||
                route.settings.name == '/projectDetail',
          );
        });
      }
    } catch (e) {
      print(e);
      isloading = false;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _refTypeTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MOaddController>(
        init: MOaddController(),
        builder: (_) => Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.chevron_left,
                      color: Colors.black, size: 36)),
              title: const Text(
                'MOadd.step4.title',
                style: TextStyle(color: Colors.black),
              ).tr(),
              centerTitle: true,
              actions: const [],
            ),
            body: SingleChildScrollView(
              child: Container(
                width: 720.w,
                height: 1280.h - 100,
                color: const Color.fromRGBO(255, 255, 255, 1),
                padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
                child: Column(
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                        Container(
                            padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 4.h),
                            decoration: BoxDecoration(
                              color: Colors.white, // 背景色
                              border: Border.all(
                                color: const Color(0xFFDFDFDF), // 边框颜色
                                width: 0.5, // 边框宽度
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                infolabe(
                                    name: tr("MOadd.step4.type1"),
                                    isrequired: true),
                                Expanded(
                                    child: textinput(
                                        textAlign: TextAlign
                                            .right, // 或者使用 TextAlign.end
                                        maxLines:
                                            1, // 设置为 null 或大于 1 的数字以支持多行输入
                                        val: systemName,
                                        isrequired: true,
                                        onChanged: (back) {
                                          setState(() {
                                            systemName = back;
                                            _.updateDeviceInfo(
                                                'systemName', back);
                                          });
                                        })),
                              ],
                            )),
                        if (_.jsonObject['modifyType'] != "modifyType2" &&
                            _.jsonObject['modifyType'] != "modifyType4")
                          Container(
                              padding:
                                  EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 4.h),
                              decoration: BoxDecoration(
                                color: Colors.white, // 背景色
                                border: Border.all(
                                  color: const Color(0xFFDFDFDF), // 边框颜色
                                  width: 0.5, // 边框宽度
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  infolabe(
                                      name: tr("MOadd.step4.type2"),
                                      isrequired: false),
                                  Expanded(
                                      child: textinput(
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign
                                              .right, // 或者使用 TextAlign.end
                                          maxLines:
                                              1, // 设置为 null 或大于 1 的数字以支持多行输入
                                          val: "$waterHardness",
                                          isrequired: false,
                                          onChanged: (back) {
                                            setState(() {
                                              waterHardness = back;
                                              _.updateDeviceInfo(
                                                  'waterHardness', back);
                                            });
                                          })),
                                ],
                              )),
                        Container(
                            padding:
                                EdgeInsets.fromLTRB(16.w, 34.h, 16.w, 34.h),
                            width: 750.w,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(74, 223, 223, 223), // 背景色
                            ),
                            child: Row(
                              children: const [
                                Text(
                                  "*",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 18),
                                ),
                                Text('外机信息'),
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 4.h),
                            decoration: BoxDecoration(
                              color: Colors.white, // 背景色
                              border: Border.all(
                                color: const Color(0xFFDFDFDF), // 边框颜色
                                width: 0.5, // 边框宽度
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                infolabe(name: '主外机匹数(HP)', isrequired: true),
                                Expanded(
                                    child: textinput(
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign
                                            .right, // 或者使用 TextAlign.end
                                        maxLines:
                                            1, // 设置为 null 或大于 1 的数字以支持多行输入
                                        val: "$pieces",
                                        isrequired: true,
                                        onChanged: (back) {
                                          setState(() {
                                            pieces = back;
                                            _.updateDeviceInfo('pieces', back);
                                          });
                                        })),
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 4.h),
                            decoration: BoxDecoration(
                              color: Colors.white, // 背景色
                              border: Border.all(
                                color: const Color(0xFFDFDFDF), // 边框颜色
                                width: 0.5, // 边框宽度
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                infolabe(name: '外机运行年限', isrequired: true),
                                Expanded(
                                    child: textinput(
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign
                                            .right, // 或者使用 TextAlign.end
                                        maxLines:
                                            1, // 设置为 null 或大于 1 的数字以支持多行输入
                                        val: "$usedTimeYear",
                                        isrequired: true,
                                        onChanged: (back) {
                                          setState(() {
                                            usedTimeYear = back;
                                            _.updateDeviceInfo(
                                                'usedTimeYear', back);
                                          });
                                        })),
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 4.h),
                            decoration: BoxDecoration(
                              color: Colors.white, // 背景色
                              border: Border.all(
                                color: const Color(0xFFDFDFDF), // 边框颜色
                                width: 0.5, // 边框宽度
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                infolabe(name: '制冷额定功率(kW)', isrequired: true),
                                Expanded(
                                    child: textinput(
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign
                                            .right, // 或者使用 TextAlign.end
                                        maxLines:
                                            1, // 设置为 null 或大于 1 的数字以支持多行输入
                                        val: "$coolCop",
                                        isrequired: true,
                                        onChanged: (back) {
                                          setState(() {
                                            coolCop = back;

                                            _.updateDeviceInfo('coolCop', back);
                                          });
                                        })),
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 4.h),
                            decoration: BoxDecoration(
                              color: Colors.white, // 背景色
                              border: Border.all(
                                color: const Color(0xFFDFDFDF), // 边框颜色
                                width: 0.5, // 边框宽度
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                infolabe(name: '制热额定功率(kW)', isrequired: true),
                                Expanded(
                                    child: textinput(
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign
                                            .right, // 或者使用 TextAlign.end
                                        maxLines:
                                            1, // 设置为 null 或大于 1 的数字以支持多行输入
                                        val: "$heatCop",
                                        isrequired: true,
                                        onChanged: (back) {
                                          setState(() {
                                            heatCop = back;

                                            _.updateDeviceInfo('heatCop', back);
                                          });
                                        })),
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 4.h),
                            decoration: BoxDecoration(
                              color: Colors.white, // 背景色
                              border: Border.all(
                                color: const Color(0xFFDFDFDF), // 边框颜色
                                width: 0.5, // 边框宽度
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                infolabe(name: '冷媒类型', isrequired: true),
                                Expanded(
                                    child: TextFormField(
                                  controller: _refTypeTextEditingController,
                                  readOnly: true,
                                  onTap: () {
                                    _showselect(context, _);
                                  },
                                  textAlign: TextAlign.end,
                                  keyboardType: TextInputType.text,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromRGBO(140, 140, 140, 1)),
                                  decoration: const InputDecoration(
                                    hintText: '请输入',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (_) => {},
                                )),
                              ],
                            )),
                      ],
                    )),
                    Container(
                      height: 57,
                      padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                      child: Center(
                        child: submitButton(
                          isActive: () {
                            var modifyType = _.jsonObject['modifyType'];
                            var isModifyType2or4 =
                                modifyType == "modifyType2" ||
                                    modifyType == "modifyType4";

                            // 基本验证条件
                            var baseConditions = systemName != "" &&
                                pieces != "" &&
                                usedTimeYear != "" &&
                                refType != "" &&
                                coolCop != "" &&
                                heatCop != "";

                            // 当不是 modifyType2 或 modifyType4 时，额外验证 waterHardness
                            var waterHardnessCondition =
                                isModifyType2or4 || waterHardness != "";

                            return baseConditions && waterHardnessCondition;
                          }(),
                          label: tr('MOadd.step2.btn'),
                          onClick: () async {
                            var modifyType = _.jsonObject['modifyType'];
                            var isModifyType2or4 =
                                modifyType == "modifyType2" ||
                                    modifyType == "modifyType4";

                            // 验证条件与 isActive 保持一致
                            if (systemName != "" &&
                                pieces != "" &&
                                usedTimeYear != "" &&
                                refType != "" &&
                                coolCop != "" &&
                                heatCop != "" &&
                                (isModifyType2or4 || waterHardness != "")) {
                              onSearchChanged();
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel(); // 取消之前的定时器
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

Future<int?> showBottomSheetDialog(
    List<selectItem> options, String selected, BuildContext context) {
  return showModalBottomSheet<int>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '请选择',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            SizedBox(
              height: 200,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: selected == options[index].label
                                ? Colors.blue
                                : Colors.grey),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(child: Text(options[index].label ?? "--"))
                      ],
                    ),
                    onTap: () => Navigator.pop(context, index),
                  );
                },
              ),
            ),
            SizedBox(
              width: 620.w,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                child: const Text('取消'),
              ),
            )
          ],
        ),
      );
    },
  );
}
