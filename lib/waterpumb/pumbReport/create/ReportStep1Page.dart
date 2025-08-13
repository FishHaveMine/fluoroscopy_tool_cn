import 'dart:convert';

import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluoroscopy_tool/store/http.dart';
import 'public/buildFormItem.dart';
import 'public/publicObject.dart';

class ReportStep1Page extends StatefulWidget {
  bool ispreview = false;
  VoidCallback next;
  VoidCallback pre;

  ReportStep1Page(
      {super.key,
      required this.pre,
      required this.next,
      this.ispreview = false});
  @override
  _ReportStep1PageState createState() => _ReportStep1PageState();
}

class _ReportStep1PageState extends State<ReportStep1Page> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _inloading = false;
  toGetRunningData(_deviceInfoController) async {
    if (_inloading) return;
    _inloading = true;
    EasyLoading.show(status: 'loading...');
    try {
      int tosend = 2;
      if (_deviceInfoController.form["debugModel"].val == "离心机组") {
        tosend = 7;
      }
      if (_deviceInfoController.form["debugModel"].val == "水冷螺杆机组") {
        tosend = 8;
      }

      var GenCode =
          await platform.invokeMethod('getformdata', <String, dynamic>{
        "step": tosend,
      });
      _inloading = false;
      var data = jsonDecode(GenCode);
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      print("-------------- toGetRunningData 1 --------------");
      var dataMap = data['data'];
      var dataMapToPonit = {
        "sn": "productSn",
        "expansionValveControllerVersion": "expansionValveControllerVersion",
      };
      if (tosend == 8) {
        dataMapToPonit = {
          "sn": "productSn",
          "controlProgramVersion": "controlProgramVersion",
        };
      }
      print("-------------- toGetRunningData 1 $dataMap  --------------");
      for (var key in dataMapToPonit.keys) {
        _deviceInfoController.form['${dataMapToPonit[key]}'].val =
            "${dataMap[key] ?? ""}";
      }
      _deviceInfoController.form['productCode'].val = dataMap['sn'];
      _deviceInfoController.update();

      EasyLoading.dismiss();
      EasyLoading.showSuccess("读取成功");
    } catch (e) {
      _inloading = false;
      print("toGetRunningData showError: $e");

      EasyLoading.dismiss();
      EasyLoading.showError("读取失败: $e");
    } finally {
      _inloading = false;
    }
  }

  Future<int?> showBottomSheetDialog(var options, BuildContext context) {
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
                '选择项目',
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
                      title: Text(options[index]["projectName"] ?? "--"),
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

  static const platform =
      MethodChannel('samples.flutter.dev/getProjectHandler');
  searchByCode(search, _deviceInfoController, con) async {
    final prefs = await SharedPreferences.getInstance();
    var useinfo = await prefs.getString("useinfo");
    print("useinfo: $useinfo");
    EasyLoading.show(status: "loading...");
    try {
      var send = {
        "pageSize": 20,
        "projectType": null,
        "pageIndex": 1,
        "projectTypeList": ["201", "299"],
        "showType": "Card",
        ...search
      };

      print("send: $send");
      var getSearchHistories = await MideaApi.projectManagerPagePost(send);
      print(
          "projectManagerPagePost:$send  ---  $getSearchHistories  ${getSearchHistories["data"]}");
      EasyLoading.dismiss();
      if (getSearchHistories["errorCode"] != null &&
          getSearchHistories["errorCode"].toString() == "1001") {
        //登录失效
        tologout();
      }
      if (getSearchHistories["data"] != null &&
          getSearchHistories["data"].length > 0) {
        var _projectName =
            await showBottomSheetDialog(getSearchHistories["data"], con);
        print("_projectName:$_projectName");
        if (_projectName != null) {
          var _set = getSearchHistories["data"][_projectName];
          _deviceInfoController.form['branchName'].val = _set['branchName'];
          _deviceInfoController.form['branchCode'].val = _set['branchCode'];

          _deviceInfoController.form['projectCode'].val = _set['projectCode'];
          _deviceInfoController.form['projectName'].val = _set['projectName'];
          _deviceInfoController.form['projectId'].val = _set['projectId'];
          _deviceInfoController.form['projectLocal'].val = _set['address'];
          _deviceInfoController.form['installationAddress'].val =
              _set['address'];
          _deviceInfoController.update();
        }
        // return getSearchHistories["data"][0];
      } else {
        // return null;
        EasyLoading.showError("没找到相关项目");
      }
    } catch (e) {
      EasyLoading.dismiss();

      EasyLoading.showError("查询项目接口异常");
      // return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InstallController>(
        builder: (_) => Container(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    ..._.step1.map((field) {
                      return Row(
                        children: [
                          Expanded(
                              child: buildFormItem(
                            item: field,
                            readOnly: widget.ispreview || field.label == "项目地址",
                            onValidator: (e) => {
                              field.val = e ?? "",
                              print(field.label + '--' + field.val),
                              if (field.label == "调试机型")
                                _.switchDebugModel(field.val)
                            },
                          )),
                          if (field.label == "项目编码" || field.label == "项目名称")
                            IconButton(
                                onPressed: () async {
                                  if (field.val == "") {
                                    EasyLoading.showInfo('请输入项${field.label}');
                                    return;
                                  }
                                  if (field.label == "项目编码") {
                                    var pro = await searchByCode(
                                        {"projectCode": field.val}, _, context);
                                  } else {
                                    var pro = await searchByCode(
                                        {"projectName": field.val}, _, context);
                                  }
                                },
                                icon: Icon(Icons.search)),
                          if (field.label == "产品编号")
                            ElevatedButton(
                              onPressed: () {
                                // TODO: implement
                                toGetRunningData(_);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text("读取"),
                            ),
                        ],
                      );
                    }).toList(),
                    const SizedBox(height: 20),
                    if (!widget.ispreview)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                bool ispass = _.validateStep(_.step1);
                                if (!ispass) {
                                  // 进入下一步逻辑
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('请输入必填项')));
                                }
                                if (_formKey.currentState!.validate()) {
                                  _.switchDebugModel(_.form["debugModel"].val);
                                  widget.next();
                                } else {
                                  // 进入下一步逻辑
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('请输入必填项')));
                                }
                              },
                              child: const Text('下一步'),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ));
  }
}
