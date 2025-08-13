import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/cloud/projectManage/addmodelM0/step1.dart';
import 'package:fluoroscopy_tool/view/systemCapabilityAnalysis/step2/systemDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../publicFunction.dart';

class step2page extends StatefulWidget {
  var project;
  step2page({super.key, this.project});

  @override
  State<step2page> createState() => _copybasepageState();
}

class _copybasepageState extends State<step2page> {
  Map mock = {};

  final cloudProjectController _selectController = Get.find();
  static const platform =
      MethodChannel('samples.flutter.dev/getProjectHandler');
  @override
  void initState() {
    super.initState();
    setState(() {
      mock = widget.project;
    });

    _getMideaAppHandler("PROJECT_SCENE");
  }

  var SCENE;
  _getMideaAppHandler(code) async {
    EasyLoading.show(status: "loading...");
    try {
      var platformback = await platform.invokeMethod(
          'getMideaAppHandler.getDictList', {"categoryCode": code});
      var backdata = jsonDecode(platformback);
      var _op = {};
      for (var e in backdata["data"]) {
        _op[e["code"]] = e["value"];
      }
      setState(() {
        SCENE = _op;
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
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
            'projecdetail',
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
          child: Column(children: [
            Expanded(
              child: Container(
                width: 720.w,
                color: const Color.fromRGBO(244, 244, 244, 1),
                padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(8),
                          child: ExpansionTile(
                            title: infobox(
                              label: "项目名称",
                              val: mock["name"],
                            ),
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                child: infobox(
                                  label: "项目编号",
                                  val: mock["code"],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                child: infobox(
                                  label: "项目类型",
                                  val: "氟机节能改造",
                                ),
                              ),
                              if (SCENE != null)
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  child: infobox(
                                    label: "项目场景",
                                    val: SCENE[mock["projectScene"]
                                            .toString()
                                            .toUpperCase()] ??
                                        mock["projectScene"],
                                  ),
                                ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                child: infobox(
                                  label: "所属区域",
                                  val: mock["completeAreaName"],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                child: infobox(
                                  label: "地址",
                                  val: mock["address"],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                child: infobox(
                                  label: "甲方信息",
                                  val: mock["associatedUserName"] +
                                      " / " +
                                      mock["phoneNumber"],
                                ),
                              ),
                            ],
                          )),
                      const Padding(padding: EdgeInsets.all(8)),
                      Text(
                        tr("project.tip"),
                        style: normalText(),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 57,
              padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
              child: submitButton(
                isActive: true,
                label: tr('moadd.step4.title'),
                onClick: () async {
                  print(mock);
                  var e = mock;
                  var pro = {
                    "project": {
                      "id": e["id"].runtimeType == String ? e["id"] : "--",
                      "name":
                          e["name"].runtimeType == String ? e["name"] : "--",
                      "code":
                          e["code"].runtimeType == String ? e["code"] : "--",
                      "systemCount": e["systemNum"].runtimeType == int
                          ? e["systemNum"]
                          : 0,
                      "indoorCount": e["indoorNum"].runtimeType == int
                          ? e["indoorNum"]
                          : 0,
                      "outdoorCount": e["outdoorNum"].runtimeType == int
                          ? e["outdoorNum"]
                          : 0,
                      "address": e["location"].runtimeType == String
                          ? e["location"]
                          : "--",
                      "projectType": e["projectType"] != null
                          ? e["projectType"].toString()
                          : ""
                    },
                  };
                  _selectController.setSelectProject(pro);

                  Get.off(addmodelM0(projectCode: mock["code"].toString()));
                },
              ),
            )
          ]),
        ));
  }
}

class infobox extends StatelessWidget {
  String label;
  String val;
  infobox({super.key, required this.label, required this.val});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: normalTextBlack(),
          ).tr(),
        ),
        Expanded(
            child: Text(
          val,
          style: normalText(),
        ))
      ],
    );
  }
}
