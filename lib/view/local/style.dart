/*
 * @Author: FishHaveMine 751174479@qq.com
 * @Date: 2024-05-29 11:20:03
 * @LastEditors: FishHaveMine 751174479@qq.com
 * @LastEditTime: 2024-06-07 11:16:52
 * @FilePath: /fluoroscopy_tool/lib/view/local/style.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

double paddingLR = 32.w;
TextStyle versionTitle(context) {
  return TextStyle(
      // 文字颜色
      // fontFamily: 'PingFangMedium',
      color: Colors.white,
      // none 不显示装饰线条，underline 字体下方，overline 字体上方，lineThrough穿过文字
      decoration: TextDecoration.none,
      // solid 直线，double 双下划线，dotted 虚线，dashed 点下划线，wavy 波浪线
      decorationStyle: TextDecorationStyle.solid,
      // 装饰线的颜色
      // 文字大小
      fontSize: 38.w,
      // normal 正常，italic 斜体
      fontStyle: FontStyle.normal,
      // 字体的粗细
      fontWeight: FontWeight.bold,
      // 文字间的宽度
      letterSpacing: 1.0,
      // 文本行与行的高度，作为字体大小的倍数（取值1~2，如1.2）
      height: 1,
      //对齐文本的水平线:
      //TextBaseline.alphabetic：文本基线是标准的字母基线
      //TextBaseline.ideographic：文字基线是表意字基线；
      //如果字符本身超出了alphabetic 基线，那么ideograhpic基线位置在字符本身的底部。
      textBaseline: TextBaseline.alphabetic);
}

TextStyle versionValue(context, {fs: null}) {
  bool isCN = EasyLocalization.of(context)?.currentLocale!.languageCode == 'zh';
  return TextStyle(
      // 文字颜色
      // fontFamily: 'PingFangMedium',
      color: Colors.white,
      // none 不显示装饰线条，underline 字体下方，overline 字体上方，lineThrough穿过文字
      decoration: TextDecoration.none,
      // solid 直线，double 双下划线，dotted 虚线，dashed 点下划线，wavy 波浪线
      decorationStyle: TextDecorationStyle.solid,
      // 装饰线的颜色
      // 文字大小
      fontSize: fs ?? 12,
      // normal 正常，italic 斜体
      fontStyle: FontStyle.normal,
      // 字体的粗细
      fontWeight: FontWeight.w400,
      // 文字间的宽度
      letterSpacing: 1.0,
      // 文本行与行的高度，作为字体大小的倍数（取值1~2，如1.2）
      height: 1,
      //对齐文本的水平线:
      //TextBaseline.alphabetic：文本基线是标准的字母基线
      //TextBaseline.ideographic：文字基线是表意字基线；
      //如果字符本身超出了alphabetic 基线，那么ideograhpic基线位置在字符本身的底部。
      textBaseline: TextBaseline.alphabetic);
}

TextStyle versionValueActive(context) {
  bool isCN = EasyLocalization.of(context)?.currentLocale!.languageCode == 'zh';
  return TextStyle(
      // 文字颜色
      // fontFamily: 'PingFangMedium',
      color: Theme.of(context).colorScheme.primary,
      // none 不显示装饰线条，underline 字体下方，overline 字体上方，lineThrough穿过文字
      decoration: TextDecoration.none,
      // solid 直线，double 双下划线，dotted 虚线，dashed 点下划线，wavy 波浪线
      decorationStyle: TextDecorationStyle.solid,
      // 装饰线的颜色
      // 文字大小
      fontSize: 12,
      // normal 正常，italic 斜体
      fontStyle: FontStyle.normal,
      // 字体的粗细
      fontWeight: FontWeight.w400,
      // 文字间的宽度
      letterSpacing: 1.0,
      // 文本行与行的高度，作为字体大小的倍数（取值1~2，如1.2）
      height: 1,
      //对齐文本的水平线:
      //TextBaseline.alphabetic：文本基线是标准的字母基线
      //TextBaseline.ideographic：文字基线是表意字基线；
      //如果字符本身超出了alphabetic 基线，那么ideograhpic基线位置在字符本身的底部。
      textBaseline: TextBaseline.alphabetic);
}

TextStyle versionValueBlock(context) {
  return TextStyle(
      // 文字颜色
      // fontFamily: 'PingFangMedium',
      color: Colors.white,
      // none 不显示装饰线条，underline 字体下方，overline 字体上方，lineThrough穿过文字
      decoration: TextDecoration.none,
      // solid 直线，double 双下划线，dotted 虚线，dashed 点下划线，wavy 波浪线
      decorationStyle: TextDecorationStyle.solid,
      // 装饰线的颜色
      // 文字大小
      fontSize: 34.w,
      // normal 正常，italic 斜体
      fontStyle: FontStyle.normal,
      // 字体的粗细
      fontWeight: FontWeight.w600,
      // 文字间的宽度
      letterSpacing: 1.0,
      // 文本行与行的高度，作为字体大小的倍数（取值1~2，如1.2）
      height: 1,
      //对齐文本的水平线:
      //TextBaseline.alphabetic：文本基线是标准的字母基线
      //TextBaseline.ideographic：文字基线是表意字基线；
      //如果字符本身超出了alphabetic 基线，那么ideograhpic基线位置在字符本身的底部。
      textBaseline: TextBaseline.alphabetic);
}

TextStyle funName(context) {
  bool isCN = EasyLocalization.of(context)?.currentLocale!.languageCode == 'zh';
  return TextStyle(
      // 文字颜色
      // fontFamily: 'PingFangMedium',
      color: const Color.fromRGBO(102, 102, 102, 1),
      // none 不显示装饰线条，underline 字体下方，overline 字体上方，lineThrough穿过文字
      decoration: TextDecoration.none,
      // solid 直线，double 双下划线，dotted 虚线，dashed 点下划线，wavy 波浪线
      decorationStyle: TextDecorationStyle.solid,
      // 装饰线的颜色
      // 文字大小
      fontSize: isCN ? 28.w : 12,
      // normal 正常，italic 斜体
      fontStyle: FontStyle.normal,
      // 字体的粗细
      fontWeight: FontWeight.w400,
      // 文字间的宽度
      letterSpacing: 1.0,
      // 文本行与行的高度，作为字体大小的倍数（取值1~2，如1.2）
      height: 1,
      //对齐文本的水平线:
      //TextBaseline.alphabetic：文本基线是标准的字母基线
      //TextBaseline.ideographic：文字基线是表意字基线；
      //如果字符本身超出了alphabetic 基线，那么ideograhpic基线位置在字符本身的底部。
      textBaseline: TextBaseline.alphabetic);
}

TextStyle cardFunName(context) {
  return TextStyle(
      // 文字颜色
      // fontFamily: 'PingFangMedium',
      color: const Color.fromRGBO(102, 102, 102, 1),
      // none 不显示装饰线条，underline 字体下方，overline 字体上方，lineThrough穿过文字
      decoration: TextDecoration.none,
      // solid 直线，double 双下划线，dotted 虚线，dashed 点下划线，wavy 波浪线
      decorationStyle: TextDecorationStyle.solid,
      // 装饰线的颜色
      // 文字大小
      fontSize: 24.w,
      // normal 正常，italic 斜体
      fontStyle: FontStyle.normal,
      // 字体的粗细
      fontWeight: FontWeight.w400,
      // 文字间的宽度
      letterSpacing: 1.0,
      // 文本行与行的高度，作为字体大小的倍数（取值1~2，如1.2）
      height: 1,
      //对齐文本的水平线:
      //TextBaseline.alphabetic：文本基线是标准的字母基线
      //TextBaseline.ideographic：文字基线是表意字基线；
      //如果字符本身超出了alphabetic 基线，那么ideograhpic基线位置在字符本身的底部。
      textBaseline: TextBaseline.alphabetic);
}

TextStyle cardFunNameSmall(context) {
  return TextStyle(
      // 文字颜色
      // fontFamily: 'PingFangMedium',
      color: const Color.fromRGBO(102, 102, 102, 1),
      // none 不显示装饰线条，underline 字体下方，overline 字体上方，lineThrough穿过文字
      decoration: TextDecoration.none,
      // solid 直线，double 双下划线，dotted 虚线，dashed 点下划线，wavy 波浪线
      decorationStyle: TextDecorationStyle.solid,
      // 装饰线的颜色
      // 文字大小
      fontSize: 10,
      // normal 正常，italic 斜体
      fontStyle: FontStyle.normal,
      // 字体的粗细
      fontWeight: FontWeight.w400,
      // 文字间的宽度
      letterSpacing: 1.0,
      // 文本行与行的高度，作为字体大小的倍数（取值1~2，如1.2）
      height: 1,
      //对齐文本的水平线:
      //TextBaseline.alphabetic：文本基线是标准的字母基线
      //TextBaseline.ideographic：文字基线是表意字基线；
      //如果字符本身超出了alphabetic 基线，那么ideograhpic基线位置在字符本身的底部。
      textBaseline: TextBaseline.alphabetic);
}

TextStyle deviceError(context) {
  return TextStyle(
      // 文字颜色
      // fontFamily: 'PingFangMedium',
      color: const Color.fromRGBO(238, 89, 67, 1),
      // none 不显示装饰线条，underline 字体下方，overline 字体上方，lineThrough穿过文字
      decoration: TextDecoration.none,
      // solid 直线，double 双下划线，dotted 虚线，dashed 点下划线，wavy 波浪线
      decorationStyle: TextDecorationStyle.solid,
      // 装饰线的颜色
      // 文字大小
      fontSize: 42.w,
      // normal 正常，italic 斜体
      fontStyle: FontStyle.normal,
      // 字体的粗细
      fontWeight: FontWeight.w500,
      // 文字间的宽度
      letterSpacing: 1.0,
      // 文本行与行的高度，作为字体大小的倍数（取值1~2，如1.2）
      height: 1,
      //对齐文本的水平线:
      //TextBaseline.alphabetic：文本基线是标准的字母基线
      //TextBaseline.ideographic：文字基线是表意字基线；
      //如果字符本身超出了alphabetic 基线，那么ideograhpic基线位置在字符本身的底部。
      textBaseline: TextBaseline.alphabetic);
}

TextStyle deviceErrorInfo(context) {
  return TextStyle(
      // 文字颜色
      // fontFamily: 'PingFangMedium',
      color: const Color.fromRGBO(136, 136, 136, 1),
      // none 不显示装饰线条，underline 字体下方，overline 字体上方，lineThrough穿过文字
      decoration: TextDecoration.none,
      // solid 直线，double 双下划线，dotted 虚线，dashed 点下划线，wavy 波浪线
      decorationStyle: TextDecorationStyle.solid,
      // 装饰线的颜色
      // 文字大小
      fontSize: 24.w,
      // normal 正常，italic 斜体
      fontStyle: FontStyle.normal,
      // 字体的粗细
      fontWeight: FontWeight.w400,
      // 文字间的宽度
      letterSpacing: 1.0,
      // 文本行与行的高度，作为字体大小的倍数（取值1~2，如1.2）
      height: 1,
      //对齐文本的水平线:
      //TextBaseline.alphabetic：文本基线是标准的字母基线
      //TextBaseline.ideographic：文字基线是表意字基线；
      //如果字符本身超出了alphabetic 基线，那么ideograhpic基线位置在字符本身的底部。
      textBaseline: TextBaseline.alphabetic);
}

BoxDecoration cardStyle(context) {
  return BoxDecoration(
      color: const Color.fromRGBO(255, 255, 255, 0.6),
      border: Border.all(
        color: const Color.fromRGBO(255, 255, 255, 0.6),
        width: 1,
      ),
      borderRadius: BorderRadius.circular(10));
}

TextStyle cardInfoName(context) {
  return const TextStyle(
      // 文字颜色
      // fontFamily: 'PingFangMedium',
      color: Color.fromRGBO(102, 102, 102, 1),
      // none 不显示装饰线条，underline 字体下方，overline 字体上方，lineThrough穿过文字
      decoration: TextDecoration.none,
      // solid 直线，double 双下划线，dotted 虚线，dashed 点下划线，wavy 波浪线
      decorationStyle: TextDecorationStyle.solid,
      // 装饰线的颜色
      // 文字大小
      fontSize: 12,
      // normal 正常，italic 斜体
      fontStyle: FontStyle.normal,
      // 字体的粗细
      fontWeight: FontWeight.w400,
      // 文字间的宽度
      letterSpacing: 1.0,
      // 文本行与行的高度，作为字体大小的倍数（取值1~2，如1.2）
      height: 1.2,
      //对齐文本的水平线:
      //TextBaseline.alphabetic：文本基线是标准的字母基线
      //TextBaseline.ideographic：文字基线是表意字基线；
      //如果字符本身超出了alphabetic 基线，那么ideograhpic基线位置在字符本身的底部。
      textBaseline: TextBaseline.alphabetic);
}

TextStyle cardInfoTap(context) {
  return TextStyle(
      // 文字颜色
      // fontFamily: 'PingFangMedium',
      color: Theme.of(context).colorScheme.primary,
      // none 不显示装饰线条，underline 字体下方，overline 字体上方，lineThrough穿过文字
      decoration: TextDecoration.none,
      // solid 直线，double 双下划线，dotted 虚线，dashed 点下划线，wavy 波浪线
      decorationStyle: TextDecorationStyle.solid,
      // 装饰线的颜色
      // 文字大小
      fontSize: 12,
      // normal 正常，italic 斜体
      fontStyle: FontStyle.normal,
      // 字体的粗细
      fontWeight: FontWeight.w400,
      // 文字间的宽度
      letterSpacing: 1.0,
      // 文本行与行的高度，作为字体大小的倍数（取值1~2，如1.2）
      height: 1.2,
      //对齐文本的水平线:
      //TextBaseline.alphabetic：文本基线是标准的字母基线
      //TextBaseline.ideographic：文字基线是表意字基线；
      //如果字符本身超出了alphabetic 基线，那么ideograhpic基线位置在字符本身的底部。
      textBaseline: TextBaseline.alphabetic);
}

TextStyle dialogTitle(context) {
  return TextStyle(
      // 文字颜色
      // fontFamily: 'PingFangMedium',
      color: Theme.of(context).primaryColor,
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

TextStyle dialogContent(context) {
  return TextStyle(
      // 文字颜色
      // fontFamily: 'PingFangMedium',
      color: Theme.of(context).primaryColor,
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

TextStyle tableNormal(context) {
  TextStyle titleStyle = TextStyle(
      // 文字颜色
      color: const Color.fromRGBO(51, 51, 51, 0.4),
      // none 不显示装饰线条，underline 字体下方，overline 字体上方，lineThrough穿过文字
      decoration: TextDecoration.none,
      // solid 直线，double 双下划线，dotted 虚线，dashed 点下划线，wavy 波浪线
      decorationStyle: TextDecorationStyle.solid,
      // 装饰线的颜色
      decorationColor: Theme.of(context).colorScheme.secondary,
      // 文字大小
      fontSize: 16.0,
      // normal 正常，italic 斜体
      fontStyle: FontStyle.normal,
      // 字体的粗细
      fontWeight: FontWeight.normal,
      // 文字间的宽度
      letterSpacing: 1.0,
      // 文本行与行的高度，作为字体大小的倍数（取值1~2，如1.2）
      height: 1,
      //对齐文本的水平线:
      //TextBaseline.alphabetic：文本基线是标准的字母基线
      //TextBaseline.ideographic：文字基线是表意字基线；
      //如果字符本身超出了alphabetic 基线，那么ideograhpic基线位置在字符本身的底部。
      textBaseline: TextBaseline.alphabetic);
  return titleStyle;
}
