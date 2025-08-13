import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'submitbutton.dart';

class EmailInputDialog {
  static Future<void> show(
    BuildContext context, {
    String? initialValue,
    required Function(String email) onConfirm,
  }) async {
    final TextEditingController _controller = TextEditingController(
      text: initialValue,
    );

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      barrierDismissible: false, // 点击外部不关闭
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
                child: Text(
              "发送到邮箱",
              style: dialogTitleG(context),
            ))
          ]),
          titlePadding: EdgeInsets.fromLTRB(24.w, 40.w, 24.w, 0), // 标题外间距
          // 标题样式 TextStyle
          titleTextStyle: dialogTitleG(context),
          contentPadding: const EdgeInsets.all(0), // 内容外间距
          // 内容样式 TextStyle
          contentTextStyle: const TextStyle(
            color: Color.fromRGBO(38, 38, 38, 1),
            fontSize: 16,
          ),
          elevation: 0,
          content: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Container(
                width: 200,
                height: 110,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text(
                        "邮箱地址：",
                        textAlign: TextAlign.left,
                      ),
                    ),
                    TextFormField(
                      controller: _controller,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: '请输入邮箱地址',
                        labelText: '',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '邮箱不能为空';
                        }
                        // 简单的邮箱格式验证
                        if (!RegExp(
                                r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                            .hasMatch(value)) {
                          return '请输入有效的邮箱地址';
                        }
                        return null;
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: 250.w,
                    height: 98.h,
                    padding: const EdgeInsets.all(10),
                    child: normalButton(
                        onClick: () {
                          Navigator.of(context).pop(false);
                        },
                        label: tr('cancel'))),
                Container(
                    width: 250.w,
                    height: 98.h,
                    padding: const EdgeInsets.all(10),
                    child: submitButton(
                        onClick: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            onConfirm(_controller.text.trim());
                            Navigator.of(context).pop();
                          }
                        },
                        isActive: true,
                        label: tr('determine')))
              ],
            )
          ],
        );
      },
    );
  }
}
