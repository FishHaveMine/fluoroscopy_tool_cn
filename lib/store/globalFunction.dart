/*
 * @Author: FishHaveMine 751174479@qq.com
 * @Date: 2023-03-01 16:27:06
 * @LastEditors: FishHaveMine 751174479@qq.com
 * @LastEditTime: 2024-06-04 17:39:01
 * @FilePath: /kong_matser/lib/globalData.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:get/get.dart';

//通用弹框方法
Future<bool> divConfirmDialog(
  context, {
  confirmTitle: '',
  confirmDescription: '',
  confirmDescriptionWidget: null,
  isSubmitButton: false,
  cancelText: 'cancel',
  confirmText: 'determine',
}) async {
  AlertDialog alert = AlertDialog(
    title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
          child: Text(
        confirmTitle,
        style: dialogTitleG(context),
      )),
      if (confirmTitle != "")
        InkWell(
          onTap: () {
            Navigator.of(context).pop(false);
          },
          child: Icon(Icons.close),
        )
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
    // 内容控件
    content: confirmDescriptionWidget ??
        SizedBox(
          width: 640.w,
          height: 50,
          child: Center(
            child: Text(confirmDescription),
          ),
        ),

    backgroundColor: Theme.of(context).backgroundColor, // 背景色

    actionsPadding: EdgeInsets.zero, // 事件子控件间距
    // 事件子控件
    actions: [
      if (!isSubmitButton)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: 560.w / 2,
                height: 98.h,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).backgroundColor),
                        side: MaterialStateProperty.all(BorderSide(
                            width: 1, color: Theme.of(context).dividerColor)),
                        //定义文本的样式 这里设置的文本颜色，但是是不会起作用的
                        textStyle: MaterialStateProperty.all(TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.primary)),
                        foregroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.primary),
                        // 设置按钮圆角大小
                        shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0.0), // 设置左上角的圆角半径为 10
                          topRight: Radius.circular(0.0), // 设置右上角的圆角半径为 20
                          bottomLeft: Radius.circular(15.0), // 设置左下角的圆角半径为 30
                          bottomRight: Radius.circular(0.0), // 设置右下角的圆角半径为 40
                        )))),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(cancelText).tr())),
            SizedBox(
                width: 560.w / 2,
                height: 98.h,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).backgroundColor),
                        side: MaterialStateProperty.all(BorderSide(
                            width: 1, color: Theme.of(context).dividerColor)),
                        //定义文本的样式 这里设置的文本颜色，但是是不会起作用的
                        textStyle: MaterialStateProperty.all(TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.primary)),
                        foregroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.primary),
                        // 设置按钮圆角大小
                        shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0.0), // 设置左上角的圆角半径为 10
                          topRight: Radius.circular(0.0), // 设置右上角的圆角半径为 20
                          bottomLeft: Radius.circular(0.0), // 设置左下角的圆角半径为 30
                          bottomRight: Radius.circular(15.0), // 设置右下角的圆角半径为 40
                        )))),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(confirmText).tr()))
          ],
        ),
      if (isSubmitButton)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: 560.w / 2,
                height: 98.h,
                padding: const EdgeInsets.all(10),
                child: normalButton(
                    onClick: () {
                      Navigator.of(context).pop(false);
                    },
                    label: tr(cancelText))),
            Container(
                width: 560.w / 2,
                height: 98.h,
                padding: const EdgeInsets.all(10),
                child: submitButton(
                    onClick: () {
                      Navigator.of(context).pop(true);
                    },
                    isActive: true,
                    label: tr(confirmText)))
          ],
        )
    ],
    // shape 形状
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
      side: const BorderSide(
        color: Colors.transparent,
        width: 1,
      ),
    ),
  );
  ;
  bool? isback = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );

  return isback ?? false;
}

Future<bool> divConfirmOnlyDialog(
  context, {
  confirmTitle: '',
  confirmDescription: '',
  confirmDescriptionWidget: null,
  isSubmitButton: false,
  confirmText: 'determine',
}) async {
  AlertDialog alert = AlertDialog(
    title: confirmTitle.isNotEmpty
        ? Container(
            child: Center(
              child: Text(
                confirmTitle,
                style: dialogTitleG(context),
              ),
            ),
          )
        : null,
    titlePadding: confirmTitle.isEmpty
        ? const EdgeInsets.all(0)
        : EdgeInsets.fromLTRB(24.w, 40.w, 24.w, 0), // 标题外间距
    // 标题样式 TextStyle
    titleTextStyle: dialogTitleG(context),
    contentPadding: const EdgeInsets.all(0), // 内容外间距
    // 内容样式 TextStyle
    contentTextStyle: const TextStyle(
      color: Color.fromRGBO(38, 38, 38, 1),
      fontSize: 16,
    ),
    elevation: 0,
    // 内容控件
    content: confirmDescriptionWidget ??
        Container(
          width: 560.w,
          height: 50,
          child: Center(
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 16.0),
                    text: confirmDescription,
                  ),
                )),
          ),
        ),

    backgroundColor: Theme.of(context).backgroundColor, // 背景色

    actionsPadding: EdgeInsets.zero, // 事件子控件间距
    // 事件子控件
    actions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: 560.w,
              height: !isSubmitButton ? 98.h : 72.h + 40.h * 2,
              child: !isSubmitButton
                  ? ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).backgroundColor),
                          side: MaterialStateProperty.all(BorderSide(
                              width: 1, color: Theme.of(context).dividerColor)),
                          //定义文本的样式 这里设置的文本颜色，但是是不会起作用的
                          textStyle: MaterialStateProperty.all(TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary)),
                          foregroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary),
                          // 设置按钮圆角大小
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0.0), // 设置左上角的圆角半径为 10
                            topRight: Radius.circular(0.0), // 设置右上角的圆角半径为 20
                            bottomLeft: Radius.circular(15.0), // 设置左下角的圆角半径为 30
                            bottomRight:
                                Radius.circular(15.0), // 设置右下角的圆角半径为 40
                          )))),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text(confirmText).tr())
                  : Center(
                      child: SizedBox(
                        width: 480.w,
                        height: 72.h,
                        child: submitButton(
                            label: tr(confirmText),
                            onClick: () {
                              Navigator.of(context).pop(true);
                            },
                            isActive: true),
                      ),
                    ))
        ],
      )
    ],
    // shape 形状
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
      side: const BorderSide(
        color: Colors.transparent,
        width: 1,
      ),
    ),
  );
  ;
  var isback = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );

  return isback != null ? (isback.toString().toLowerCase() == 'true') : false;
}

TextStyle dialogTitleG(context) {
  return const TextStyle(
      // 文字颜色
      // fontFamily: 'PingFangMedium',
      color: Color.fromRGBO(13, 13, 13, 1),
      // none 不显示装饰线条，underline 字体下方，overline 字体上方，lineThrough穿过文字
      decoration: TextDecoration.none,
      // solid 直线，double 双下划线，dotted 虚线，dashed 点下划线，wavy 波浪线
      decorationStyle: TextDecorationStyle.solid,
      // 装饰线的颜色
      // 文字大小
      fontSize: 18,
      // normal 正常，italic 斜体
      fontStyle: FontStyle.normal,
      // 字体的粗细
      fontWeight: FontWeight.bold,
      // 文字间的宽度
      letterSpacing: 1.0,
      // 文本行与行的高度，作为字体大小的倍数（取值1~2，如1.2）
      height: 1.5,
      //对齐文本的水平线:
      //TextBaseline.alphabetic：文本基线是标准的字母基线
      //TextBaseline.ideographic：文字基线是表意字基线；
      //如果字符本身超出了alphabetic 基线，那么ideograhpic基线位置在字符本身的底部。
      textBaseline: TextBaseline.alphabetic);
}

TextStyle dialogContentG(context) {
  return const TextStyle(
      // 文字颜色
      // fontFamily: 'PingFangMedium',
      color: Color.fromRGBO(22, 119, 255, 1),
      // none 不显示装饰线条，underline 字体下方，overline 字体上方，lineThrough穿过文字
      decoration: TextDecoration.none,
      // solid 直线，double 双下划线，dotted 虚线，dashed 点下划线，wavy 波浪线
      decorationStyle: TextDecorationStyle.solid,
      // 装饰线的颜色
      // 文字大小
      fontSize: 14,
      // normal 正常，italic 斜体
      fontStyle: FontStyle.normal,
      // 字体的粗细
      fontWeight: FontWeight.w400,
      // 文字间的宽度
      letterSpacing: 1.0,
      // 文本行与行的高度，作为字体大小的倍数（取值1~2，如1.2）
      height: 1.5,
      //对齐文本的水平线:
      //TextBaseline.alphabetic：文本基线是标准的字母基线
      //TextBaseline.ideographic：文字基线是表意字基线；
      //如果字符本身超出了alphabetic 基线，那么ideograhpic基线位置在字符本身的底部。
      textBaseline: TextBaseline.alphabetic);
}

signout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('username');
  await prefs.remove('token');
}

const _colundplatform =
    MethodChannel('samples.flutter.dev/getDeviceUnlockHandler');
uploadclound(data) async {
  final prefs = await SharedPreferences.getInstance();
  var useinfoSting = prefs.getString("useinfo");
  String phone = "";
  if (useinfoSting != null) {
    try {
      var useinfo = jsonDecode(useinfoSting);
      phone = useinfo["phone"];
    } catch (e) {}
  }
  String? usernameprefs = await prefs.getString("usernameA");
  String? location = await prefs.getString("location");
  for (var element in data.keys) {
    print("${element} : ${data[element]}");
  }
  var send = {
    "deviceSn": data["device_sn"] ?? "",
    "nowSn": data["now_device_sn"] ?? "",
    "agreementType": data["agreement_type"] ?? "",
    "operationDevice": data["operation_device"] ?? "",
    "functionType": data["function_type"] ?? "",
    "executionResult": data["execution_result"] ?? "",
    "number": data["number"] ?? "",
    "phone": phone,
    "uid": usernameprefs,
    "operation": data["operation"] ?? "",
    "location": location ?? "",
    "modelDetail": data["model_detail"] ?? null,
  };
  var _colundupload =
      await _colundplatform.invokeMethod('insertOperationLog', send);
  print("_colundupload  --  ${_colundupload}");
}

tologout() async {
  EasyLoading.dismiss();
  const platform = MethodChannel('samples.flutter.dev/battery');
  final prefs = await SharedPreferences.getInstance();
  try {
    await platform.invokeMethod('logout', <String, dynamic>{});
  } catch (e) {}
  try {
    await prefs.remove('permissions');
    await prefs.remove('username');
    await prefs.remove('token');
    await prefs.remove('cloundRefreshTime');
  } catch (e) {}
  Get.offAllNamed('/login'); //
}

String formatTimestamp(var timestamp) {
  if (timestamp == "{}") {
    return "--";
  } else {
    // 将毫秒时间戳转换为 DateTime 对象
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp.toString()));

    // 定义格式
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

    // 格式化日期
    String formattedDate = formatter.format(dateTime);

    return formattedDate;
  }
}

class SafeText extends StatelessWidget {
  final Object? data;
  final TextStyle? style;
  final TextAlign? textAlign;
  bool needTr = true;

  SafeText(this.data,
      {this.style, this.textAlign, this.needTr = true, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String textContent;

    if (data == null || data == '' || data.toString() == '{}') {
      textContent = '--';
    } else if (data is int || data is double) {
      textContent = data.toString();
    } else {
      textContent = data.toString();
    }

    return Text(
      needTr ? tr(textContent) : textContent,
      style: style,
      textAlign: textAlign ?? TextAlign.left,
    );
  }
}

class IconTextButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const IconTextButton({
    required this.icon,
    required this.text,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: const Color.fromRGBO(255, 255, 255, 0.5), // 设置按钮背景色
        padding:
            const EdgeInsets.symmetric(vertical: 8, horizontal: 8), // 设置内边距
        elevation: 20, // 控制阴影的高度
        shadowColor: Colors.black.withOpacity(0.5), // 阴影颜色
        side: const BorderSide(color: Color(0xFFDFDFDF), width: 0.5), // 边框颜色和宽度
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // 圆角
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.black), // 图标
          const SizedBox(height: 4), // 图标和文字之间的间距
          Text(
            text,
            style: const TextStyle(color: Colors.black, fontSize: 9), // 文字颜色
          ),
        ],
      ),
    );
  }
}
