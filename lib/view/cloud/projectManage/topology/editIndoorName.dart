import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/cloud/publicFunction.dart';
import 'package:fluoroscopy_tool/view/local/style.dart';
import 'package:fluoroscopy_tool/view/systemCapabilityAnalysis/step2/systemDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

class editIndoorName extends StatefulWidget {
  String nid;
  String projectId;
  editIndoorName({super.key, required this.nid, required this.projectId});

  @override
  State<editIndoorName> createState() => _editIndoorNameState();
}

class _editIndoorNameState extends State<editIndoorName> {
  String deviceName = '';

  static const platform = MethodChannel('samples.flutter.dev/topology');
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  _setname() async {
    EasyLoading.show(status: 'loading...');
    try {
      var invokeMethodback =
          await platform.invokeMethod('getTopologyHandler.deviceNameUpdate', {
        "projectId": widget.projectId,
        "nid": widget.nid,
        "deviceName": deviceName,
      });
      var josndata = jsonDecode(invokeMethodback);

      EasyLoading.dismiss();
      if (josndata["success"]) {
        EasyLoading.showSuccess(tr("topology.onOffControl_success"));
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      } else {
        EasyLoading.showError(josndata["errorMsg"]);
      }
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.unfocus();
    _focusNode.dispose();
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
            '编辑设备名称',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [],
        ),
        body: Container(
          color: const Color.fromRGBO(244, 244, 244, 1),
          padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.all(16),
                      decoration: cardStyle(context),
                      child: TextField(
                        focusNode: _focusNode,
                        decoration: const InputDecoration(
                          hintText: '请输入设备名称',
                          border: InputBorder.none, // 去掉默认的下划线边框
                        ),
                        onChanged: (val) {
                          setState(() {
                            deviceName = val;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 57,
                padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                child: Center(
                  child: submitButton(
                    isActive: deviceName != "",
                    label: tr('determine'),
                    onClick: () async {
                      if (deviceName != "") {
                        _setname();
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
