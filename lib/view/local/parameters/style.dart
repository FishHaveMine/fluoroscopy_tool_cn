/*
 * @Author: FishHaveMine 751174479@qq.com
 * @Date: 2024-06-08 15:05:10
 * @LastEditors: FishHaveMine 751174479@qq.com
 * @LastEditTime: 2024-06-08 15:49:39
 * @FilePath: /fluoroscopy_tool/lib/view/local/parameters/style.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextStyle devceInfoCardTitle(context) {
  return TextStyle(
      // 文字颜色
      // fontFamily: 'PingFangMedium',
      color: Colors.black,
      // none 不显示装饰线条，underline 字体下方，overline 字体上方，lineThrough穿过文字
      decoration: TextDecoration.none,
      // solid 直线，double 双下划线，dotted 虚线，dashed 点下划线，wavy 波浪线
      decorationStyle: TextDecorationStyle.solid,
      // 装饰线的颜色
      // 文字大小
      fontSize:  34.w,
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


TextStyle devceInfoCardLabel(context) {
  return TextStyle(
      // 文字颜色
      // fontFamily: 'PingFangMedium',
      color: Color.fromRGBO(153, 153, 153, 1),
      // none 不显示装饰线条，underline 字体下方，overline 字体上方，lineThrough穿过文字
      decoration: TextDecoration.none,
      // solid 直线，double 双下划线，dotted 虚线，dashed 点下划线，wavy 波浪线
      decorationStyle: TextDecorationStyle.solid,
      // 装饰线的颜色
      // 文字大小
      fontSize:  12,
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


TextStyle devceInfoCardValue(context) {
  return TextStyle(
      // 文字颜色
      // fontFamily: 'PingFangMedium',
      color: Colors.black,
      // none 不显示装饰线条，underline 字体下方，overline 字体上方，lineThrough穿过文字
      decoration: TextDecoration.none,
      // solid 直线，double 双下划线，dotted 虚线，dashed 点下划线，wavy 波浪线
      decorationStyle: TextDecorationStyle.solid,
      // 装饰线的颜色
      // 文字大小
      fontSize:  12,
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




TextStyle settingTitle(context) {
  return TextStyle(
      // 文字颜色
      // fontFamily: 'PingFangMedium',
       color: Color.fromRGBO(136, 136, 136, 1),
      // none 不显示装饰线条，underline 字体下方，overline 字体上方，lineThrough穿过文字
      decoration: TextDecoration.none,
      // solid 直线，double 双下划线，dotted 虚线，dashed 点下划线，wavy 波浪线
      decorationStyle: TextDecorationStyle.solid,
      // 装饰线的颜色
      // 文字大小
      fontSize:  14,
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

