import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/compent/textinput.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/cloud/projectCreate/oldProject/step1.dart';
import 'package:fluoroscopy_tool/view/systemCapabilityAnalysis/step2/systemDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

class bossinfo extends StatefulWidget {
  String associatedUserName;
  String phoneNumber;
  bossinfo(
      {super.key, required this.associatedUserName, required this.phoneNumber});

  @override
  State<bossinfo> createState() => _bossinfoState();
}

class _bossinfoState extends State<bossinfo> {
  String associatedUserName = "";
  String phoneNumber = "";
  @override
  void initState() {
    super.initState();
    setState(() {
      associatedUserName = widget.associatedUserName;
      phoneNumber = widget.phoneNumber;
    });
  }

  // 正则表达式用于验证手机号
  final RegExp _phoneRegex = RegExp(r'^(?:\+86)?1[3-9]\d{9}$');

  String? _validatePhone(val) {
    String phoneNumber = val;
    print(phoneNumber);
    // 检查手机号是否符合格式
    if (!_phoneRegex.hasMatch(phoneNumber)) {
      return tr('validatephone');
    } else {}
  }

  final _formKey = GlobalKey<FormState>();
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
            'project.boss',
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
                child: Form(
                    key: _formKey,
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
                                    name: tr("project.associatedUserName"),
                                    isrequired: true),
                                Expanded(
                                    child: textinput(
                                        textAlign: TextAlign
                                            .right, // 或者使用 TextAlign.end
                                        maxLines:
                                            1, // 设置为 null 或大于 1 的数字以支持多行输入
                                        val: associatedUserName,
                                        isrequired: true,
                                        onChanged: (back) {
                                          setState(() {
                                            associatedUserName = back;
                                          });
                                          _formKey.currentState!.validate();
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
                                infolabe(
                                    name: tr("project.phoneNumber"),
                                    isrequired: true),
                                Expanded(
                                    child: textinput(
                                        keyboardType: TextInputType.phone,
                                        textAlign: TextAlign
                                            .right, // 或者使用 TextAlign.end
                                        maxLines:
                                            1, // 设置为 null 或大于 1 的数字以支持多行输入
                                        val: phoneNumber,
                                        validator: _validatePhone,
                                        isrequired: true,
                                        onChanged: (back) {
                                          setState(() {
                                            phoneNumber = back;
                                          });
                                          _formKey.currentState!.validate();
                                        })),
                              ],
                            )),
                      ],
                    )),
              ),
              Container(
                height: 57,
                padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                child: Center(
                  child: submitButton(
                    isActive: associatedUserName != "" && phoneNumber != "",
                    label: tr('determine'),
                    onClick: () async {
                      if (_formKey.currentState!.validate()) {
                        Get.back(result: {
                          "associatedUserName": associatedUserName,
                          "phoneNumber": phoneNumber,
                        });
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
