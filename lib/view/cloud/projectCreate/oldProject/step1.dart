import 'dart:convert';

import 'package:city_pickers/city_pickers.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/bottomSelectSheet.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/compent/textinput.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/cloud/projectCreate/oldProject/step2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'bossinfo.dart';

class oldProjectCreateStep1 extends StatefulWidget {
  oldProjectCreateStep1({super.key});

  @override
  State<oldProjectCreateStep1> createState() => _oldProjectCreateStep1State();
}

class InputField {
  String val;
  String type;
  String? hintText;
  bool required;
  var op;

  InputField({
    required this.val,
    required this.type,
    required this.required,
    this.op,
    this.hintText,
  });

  factory InputField.fromJson(Map<String, dynamic> json) {
    return InputField(
      val: json['val'],
      type: json['type'],
      required: json['required'] == 'true', // 注意处理字符串转换为布尔值
      op: json['op'] ?? [], hintText: json['hintText'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'val': val,
      'type': type,
      'required': required.toString(), // 转换布尔值为字符串
    };
  }
}

class _oldProjectCreateStep1State extends State<oldProjectCreateStep1> {
  final _formKey = GlobalKey<FormState>();

  bool isActive = false;
  static const platform =
      MethodChannel('samples.flutter.dev/getProjectHandler');
  List user = [];
  List PROJECT_TYPE = [];
  List PROJECT_SCENE = [];
  List BRAND = [];
  List branchCode = [];
  var editinfo = {};
  String latitude = "";
  String longitude = "";

  var sendForm = {
    "address": "",
    "areaId": "",
    "brand": "",
    "brandCode": "",
    // "branchCode": "F4406000008",

    "countryCode": "CN",
    "latitude": "",
    "longitude": "",

    "name": "",
    "priority": "4",
    "projectScene": "TXXT",
    "projectType": "fjjngz",
    "remark": "",
    "outerTotal": 0,
    "ratio": 0,

    "associatedUserName": "",
    "phoneNumber": "",

    "contactList": [], //管理员
  };

  filterOp(key) {
    try {
      if (editinfo[key].val == null || editinfo[key].val == "") {
        return "--";
      }
      String _val = editinfo[key].val.toString();

      var filter = editinfo[key]
          .op
          .where((e) =>
              e["value"].toString() == _val || e["value1"].toString() == _val)
          .toList();
      if (filter != null) {
        return filter[0]["label"];
      }
      return "--";
    } catch (e) {
      return "--";
    }
  }

  _echangeData(e) {
    return {
      "label": e["realName"],
      "name": e["realName"],
      'value1': e["userId"],
      "value": e["userId"]
    };
  }

  _echangeDataCode(e) {
    return {
      "label": e["value"],
      "name": e["value"],
      'value1': e["code"],
      "value": e["code"]
    };
  }

  _echangeDataId(e) {
    return {
      "label": e["name"],
      "name": e["name"],
      'value1': e["code"],
      "value": e["code"]
    };
  }

  _devicetypeop() {
    var data = {
      "md_devicetypeop": "MD",
      "dk_devicetypeop": "DK",
      "gr_devicetypeop": "GR",
      "ha_devicetypeop": "HA",
      "hs_devicetypeop": "HS",
      "ht_devicetypeop": "HT",
      "mx_devicetypeop": "MX",
      "qt_devicetypeop": "QT"
    };
    List op = [];
    for (var element in data.keys) {
      op.add({
        "label": tr(element),
        "name": tr(element),
        'value1': data[element],
        "value": data[element]
      });
    }
    return op;
  }

  _sceneop() {
    List<String> categories = [
      '房产项目',
      '酒店饭店',
      '交通系统',
      '家庭用户',
      '商场卖场',
      '商业办公',
      '通讯系统',
      '体育场馆',
      '医疗系统',
      '工地厂区',
      '办公建筑',
      '旅馆酒店',
      '商业建筑',
      '居民服务',
      '文化建筑',
      '教育建筑',
      '卫生建筑',
      '科研建筑',
      '交通建筑',
      '人防建筑',
      '广播电影',
      '厂房建筑',
      '仓库建筑',
    ];
    List op = [];
    for (var element in categories) {
      op.add({
        "label": element,
        "name": element,
        'value1': element,
        "value": element
      });
    }
    return op;
  }

  _getUserList() async {
    EasyLoading.show(status: "loading...");
    try {
      var platformback =
          await platform.invokeMethod('getUserHandler.getUserList', {});

      var backdata = jsonDecode(platformback);
      user = backdata["data"].map((e) => _echangeData(e)).toList();
      editinfo = {
        "project.name": InputField(required: true, val: "", type: "input"),
        "project.projectType": InputField(
            required: false, val: tr("project.projecthintText"), type: "text"),
        "project.brand":
            InputField(required: true, val: "", type: "select", op: BRAND),
        "project.countryCode":
            InputField(required: false, val: "CN", type: "text"),
        "project.projectScene": InputField(
            required: true, val: "", type: "select", op: PROJECT_SCENE),
        "project.area": InputField(required: true, val: "", type: "location"),
        "project.remark": InputField(
            required: false,
            val: "",
            type: "textarea",
            hintText: tr("project.remarkinttext")),
        "project.contactList":
            InputField(required: true, val: "", type: "select", op: user),
        "project.boss": InputField(
            required: true,
            val: sendForm["associatedUserName"] != ""
                ? "${sendForm["associatedUserName"]}-${sendForm["phoneNumber"]}"
                : "",
            type: "text"),
        // "project.outerTotal":
        //     InputField(required: true, val: "", type: "input"),
        // "project.ratio": InputField(required: true, val: "", type: "input"),
      };
      setState(() {
        user;
        editinfo;
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  _getSystemBranchHandlerpage() async {
    EasyLoading.show(status: "loading...");
    try {
      var platformback =
          await platform.invokeMethod('getSystemBranchHandler.page', {});
      var backdata = jsonDecode(platformback);
      branchCode = backdata["data"].map((e) => _echangeDataId(e)).toList();
      setState(() {
        branchCode;
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  _getMideaAppHandler(code) async {
    EasyLoading.show(status: "loading...");
    try {
      var platformback = await platform.invokeMethod(
          'getMideaAppHandler.getDictList', {"categoryCode": code});
      var backdata = jsonDecode(platformback);
      var _op = backdata["data"].map((e) => _echangeDataCode(e)).toList();
      if (code == "BRAND") {
        _op.sort((a, b) {
          if (a['label'] == '美的') {
            return -1; // '美的' 排在前面
          } else if (b['label'] == '美的') {
            return 1; // '美的' 排在后面
          }
          return 0; // 其他按原顺序
        });
        setState(() {
          BRAND = _op;
        });
      } else {
        setState(() {
          PROJECT_SCENE = _op;
        });
      }
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  List _countryAreaTreeData = [];
  _countryAreaTree() async {
    EasyLoading.show(status: "loading...");
    try {
      var platformback = await platform
          .invokeMethod('getSystemAreaHandler.countryAreaTree', {});
      var backdata = jsonDecode(platformback);
      print("countryAreaTree : ${backdata["data"]}");
      _countryAreaTreeData = backdata["data"];
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  int? findIdByCode(List areas, String code) {
    for (var area in areas) {
      if (area["code"] == code) {
        return area["id"];
      }
      // 递归查找子区域
      if (area["children"] != null) {
        var foundId = findIdByCode(area["children"], code);
        if (foundId != null) {
          return foundId;
        }
      }
    }
    return null; // 如果没有找到，返回null
  }

  updataVal(key, val) {
    setState(() {
      editinfo[key].val = val;
    });
    _checkpass();
  }

  _checkpass() {
    bool ispadd = true;
    for (var element in editinfo.keys) {
      if (editinfo[element]!.val == "" && editinfo[element]!.required) {
        ispadd = false;
        break;
      }
    }
    print("isActive: $ispadd");
    setState(() {
      isActive = ispadd;
    });
  }

  _createproject() async {
    EasyLoading.show(status: "loading...");
    try {
      var send = {};
      for (var element in editinfo.keys) {
        if (editinfo[element]!.val == "" && editinfo[element]!.required) {
          EasyLoading.dismiss();
          EasyLoading.showError(tr("project.required"));
          return;
        }
        send[element] = editinfo[element]!.val;
      }
      sendForm["name"] = send["project.name"];
      sendForm["brandCode"] = send["project.brand"];
      var filter = BRAND
          .where((e) =>
              e["value"].toString() == send["project.brand"] ||
              e["value1"].toString() == send["project.brand"])
          .toList();
      if (filter != null) {
        sendForm["brand"] = filter[0]["label"];
      }
      // sendForm["branchCode"] = send["project.branchCode"];
      sendForm["countryCode"] = "CN";
      sendForm["priority"] = "4";
      sendForm["projectScene"] = send["project.projectScene"];
      sendForm["projectType"] = "fjjngz";
      sendForm["remark"] = send["project.remark"];
      for (var key in sendForm.keys) {
        sendForm[key] = sendForm[key].toString();
      }
      int _areaId = int.parse("1${sendForm["areaId"]}");
      sendForm["outerTotal"] = 0;
      sendForm["ratio"] = 0;

      var _id = findIdByCode(_countryAreaTreeData, "$_areaId");
      sendForm["areaId"] = int.parse("$_id");
      sendForm["contactList"] = send["project.contactList"].toString();
      var platformback = await platform.invokeMethod(
          'getAppFluorineMachineEnergyHandler.saveOrUpdateProject',
          {"sendForm": sendForm});
      var backdata = jsonDecode(platformback);
      print("backdata: $backdata");
      EasyLoading.dismiss();
      EasyLoading.dismiss();
      if (!backdata['success']) {
        EasyLoading.showError(backdata['errorMsg']);
      } else {
        // ignore: use_build_context_synchronously
        EasyLoading.showSuccess(
            tr("createProject") + tr("unlockhistory.unlocksuccess"));
        Future.delayed(const Duration(seconds: 2), () {
          // Navigator.pop(context);
          Get.off(step2page(
            project: backdata["data"],
          ));
        });
      }
    } catch (e) {
      print(e);
    }
  }

  _init() async {
    await _countryAreaTree();
    await _getMideaAppHandler("PROJECT_SCENE");
    await _getMideaAppHandler("BRAND");
    await _getSystemBranchHandlerpage();
    await _getUserList();
  }

  @override
  void initState() {
    super.initState();
    // _getMideaAppHandler("PROJECT_TYPE");
    _init();
  }

  @override
  void dispose() {
    // 移除滚动监听器
    EasyLoading.dismiss();
    super.dispose();
  }

  Future<void> show(context) async {
    Result? result = await CityPickers.showCityPicker(
      context: context,
    );
    setState(() {
      editinfo["project.area"].val = "";
    });
    print('result $result');
    if (result == null) {
      setState(() {
        editinfo["project.area"].val = "";
        isActive = false;
      });
    } else {
      setState(() {
        editinfo["project.area"].val =
            "${result?.cityName}-${result?.areaName}";
      });
      sendForm["address"] = result?.areaName ?? "";
      sendForm["areaId"] = result?.areaId ?? "";
      // _getLatLngFromDistrictId(result?.areaId ?? "");
    }
  }

  String _latLng = "";

  // 高德地图 API key
  final String _apiKey = "b30853faa0bf48ec308c5daa7242f862";

  // 根据地区 ID 查询经纬度
  Future<void> _getLatLngFromDistrictId(String districtId) async {
    final String url =
        'https://restapi.amap.com/v3/config/district?keywords=$districtId&key=$_apiKey&subdistrict=0';
    try {
      final response = await Dio().get(url);
      _latLng = response.data["districts"][0]["center"];

      sendForm["latitude"] = _latLng.split(",")[1];
      sendForm["longitude"] = _latLng.split(",")[0];
      _checkpass();
    } catch (e) {
      // EasyLoading.showError("获取地区经纬度失败: $e");
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
            'baseInfo',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [],
        ),
        body: Column(
          children: [
            Expanded(
                child: Container(
              width: 720.w,
              color: const Color.fromRGBO(244, 244, 244, 1),
              padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
              child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        for (var item in editinfo.keys)
                          Container(
                            padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 0.h),
                            decoration: BoxDecoration(
                              color: Colors.white, // 背景色
                              border: Border.all(
                                color: const Color(0xFFDFDFDF), // 边框颜色
                                width: 0.5, // 边框宽度
                              ),
                            ),
                            child: editinfo[item]!.type != "textarea"
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      infolabe(
                                          name: tr(item),
                                          isrequired: editinfo[item]!.required),
                                      editinfo[item]!.type == "text"
                                          ? Expanded(
                                              child: InkWell(
                                              onTap: () async {
                                                if (item == "project.boss") {
                                                  var back = await Get.to(
                                                      () => bossinfo(
                                                            associatedUserName:
                                                                sendForm[
                                                                        "associatedUserName"]
                                                                    .toString(),
                                                            phoneNumber: sendForm[
                                                                    "phoneNumber"]
                                                                .toString(),
                                                          ));
                                                  if (back != null) {
                                                    setState(() {
                                                      sendForm[
                                                              "associatedUserName"] =
                                                          back[
                                                              "associatedUserName"];
                                                      sendForm["phoneNumber"] =
                                                          back["phoneNumber"];
                                                      editinfo["project.boss"]!
                                                              .val =
                                                          "${sendForm["associatedUserName"]}-${sendForm["phoneNumber"]}";
                                                    });
                                                    _checkpass();
                                                  }
                                                }
                                              },
                                              child: item == "project.boss"
                                                  ? Padding(
                                                      key: ValueKey(
                                                          editinfo[item]!.val),
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 16,
                                                          horizontal: 12),
                                                      child: Text(
                                                        editinfo[item]!.val ==
                                                                ""
                                                            ? tr(
                                                                "input.hintText")
                                                            : editinfo[item]!
                                                                .val,
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: normalText(
                                                            lineheight: 1),
                                                      ),
                                                    )
                                                  : textinput(
                                                      lineheight: 1,
                                                      enabled: false,
                                                      textAlign: TextAlign
                                                          .right, // 或者使用 TextAlign.end
                                                      maxLines:
                                                          1, // 设置为 null 或大于 1 的数字以支持多行输入
                                                      onChanged: (back) {},
                                                      isrequired:
                                                          editinfo[item]!
                                                              .required,
                                                      val: editinfo[item]!.val,
                                                    ),
                                            ))
                                          : Expanded(
                                              child: editinfo[item]!.type ==
                                                      "select"
                                                  ? InkWell(
                                                      onTap: () async {
                                                        Future<sheetBack?>
                                                            selectedIndex =
                                                            await showCustomModalBottomSheet(
                                                          context,
                                                          editinfo[item]!.op,
                                                          isMultiple: false,
                                                          baseValue: editinfo[
                                                                          item]!
                                                                      .val ==
                                                                  ""
                                                              ? []
                                                              : [
                                                                  editinfo[
                                                                          item]!
                                                                      .val
                                                                ],
                                                          titleName: tr(item),
                                                        );
                                                        selectedIndex
                                                            .then((value) => {
                                                                  if (value !=
                                                                          null &&
                                                                      // ignore: unrelated_type_equality_checks
                                                                      value.baseValue![
                                                                              0] !=
                                                                          -1)
                                                                    {
                                                                      updataVal(
                                                                          item,
                                                                          value
                                                                              .baseValue![0]
                                                                              .toString())
                                                                    }
                                                                });
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 10),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              filterOp(item),
                                                              textAlign:
                                                                  TextAlign.end,
                                                              style:
                                                                  normalText(),
                                                            ),
                                                            const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          5,
                                                                          0,
                                                                          0),
                                                              child: Icon(
                                                                Icons
                                                                    .arrow_drop_down,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        140,
                                                                        140,
                                                                        140,
                                                                        1),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : editinfo[item]!.type ==
                                                          "location"
                                                      ? InkWell(
                                                          onTap: () async {
                                                            show(context);
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        10),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  editinfo[
                                                                          item]!
                                                                      .val,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .end,
                                                                  style:
                                                                      normalText(),
                                                                ),
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          5,
                                                                          0,
                                                                          0),
                                                                  child: Icon(
                                                                    Icons
                                                                        .arrow_drop_down,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            140,
                                                                            140,
                                                                            140,
                                                                            1),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : textinput(
                                                          lineheight: 1,
                                                          keyboardType: [
                                                            "project.outerTotal",
                                                            "project.ratio"
                                                          ].contains(item)
                                                              ? TextInputType
                                                                  .number
                                                              : TextInputType
                                                                  .text,
                                                          textAlign: TextAlign
                                                              .right, // 或者使用 TextAlign.end
                                                          maxLines:
                                                              1, // 设置为 null 或大于 1 的数字以支持多行输入
                                                          val: editinfo[item]!
                                                              .val,
                                                          isrequired:
                                                              editinfo[item]!
                                                                  .required,
                                                          onChanged: (back) {
                                                            _checkpass();
                                                            setState(() {
                                                              editinfo[item]!
                                                                  .val = back;
                                                            });
                                                          })),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 12, 0, 12),
                                        child: infolabe(
                                            name: tr(item),
                                            isrequired:
                                                editinfo[item]!.required),
                                      ),
                                      textinput(
                                          lineheight: 1,
                                          val: editinfo[item]!.val,
                                          isrequired: editinfo[item]!.required,
                                          hintText: editinfo[item]!.hintText,
                                          onChanged: (back) {
                                            _checkpass();
                                            setState(() {
                                              editinfo[item]!.val = back;
                                            });
                                          })
                                    ],
                                  ),
                          ),
                      ],
                    )),
              ),
            )),
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
                      isActive: isActive,
                      label: tr('createProject.btn'),
                      onClick: () async {
                        _createproject();
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}

class infolabe extends StatelessWidget {
  String name;
  bool isrequired;
  infolabe({super.key, required this.name, required this.isrequired});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          name,
          style: normalTextBlack(fSize: 16, fw: FontWeight.w500, lineheight: 1),
        ),
        if (isrequired)
          const Text(
            "*",
            style: TextStyle(color: Colors.red),
          )
      ],
    );
  }
}
