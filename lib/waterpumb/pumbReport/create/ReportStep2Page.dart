import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'public/InstallationInfo.dart';
import 'public/buildFormItem.dart';
import 'public/publicObject.dart';

class ReportStep2Page extends StatefulWidget {
  bool ispreview = false;
  VoidCallback next;
  VoidCallback pre;

  ReportStep2Page(
      {super.key,
      required this.pre,
      required this.next,
      this.ispreview = false});
  @override
  _ReportStep2PageState createState() => _ReportStep2PageState();
}

class _ReportStep2PageState extends State<ReportStep2Page> {
  final _formKey = GlobalKey<FormState>();
  // 存储所有输入框的FocusNode
  late List<FocusNode> _focusNodes;
  init() {
    InstallController _ = Get.find();
    _focusNodes = List.generate(
      _.step2.where((field) => field is FormItem).length,
      (index) => FocusNode(),
    );
    setState(() {
      _focusNodes;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  static const platform =
      MethodChannel('samples.flutter.dev/waterpumbBasicHandler');
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

      print("-------------- toGetRunningData 2 --------------");
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
      print("-------------- toGetRunningData 2 $dataMap  --------------");
      for (var key in dataMapToPonit.keys) {
        try {
          _deviceInfoController.form['${dataMapToPonit[key]}'].val =
              dataMap[key];
        } catch (e) {}
      }
      _deviceInfoController.update();

      EasyLoading.dismiss();
      EasyLoading.showSuccess("读取成功");
    } catch (e) {
      print("toGetRunningData showError: $e");
      _inloading = false;
      EasyLoading.dismiss();
      EasyLoading.showError("读取失败: $e");
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
                    if (!widget.ispreview)
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              const Text(
                                "RS485本地获取",
                                style: TextStyle(fontSize: 14),
                              ),
                              const Spacer(),
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
                          )),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                              '注意事项\n1. 现场工作必须严格遵循国家法律法规和随机说明书的相关安全规范内容，以确保相关人员的安全！\n2. 操作设备必须具备相应的资质证书，且操作过程必须符合操作规范！',
                              style: TextStyle(color: Colors.black)),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_focusNodes.isNotEmpty)
                      ..._.step2.asMap().entries.map((entry) {
                        final index = entry.key; // 当前元素的索引
                        final field = entry.value; // 当前元素的值

                        // 使用索引和字段构建组件
                        return buildFormItem(
                          item: field,
                          focusNodes: _focusNodes[index],
                          onInputFieldSubmitted: () {
                            if (index < _focusNodes.length - 1) {
                              _focusNodes[index + 1].requestFocus();
                            } else {
                              _focusNodes[index].unfocus();
                            }
                          },
                          readOnly: widget.ispreview,
                          onValidator: (e) =>
                              {field.val = e ?? "", print(field.val)},
                        );
                      }).toList(),
                    const SizedBox(height: 20),
                    if (!widget.ispreview)
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                widget.pre();
                              },
                              child: const Text('上一步'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  bool ispass = _.validateStep(_.step2);
                                  if (!ispass) {
                                    // 进入下一步逻辑
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('请输入必填项')));
                                    return;
                                  }
                                  // 释放FocusNode和TextEditingController资源
                                  try {
                                    for (var node in _focusNodes) {
                                      node.dispose();
                                    }
                                  } catch (e) {}
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
