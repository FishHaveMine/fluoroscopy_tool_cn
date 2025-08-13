/*
 * @Author: FishHaveMine 751174479@qq.com
 * @Date: 2022-09-07 09:14:46
 * @LastEditors: FishHaveMine 751174479@qq.com
 * @LastEditTime: 2024-06-06 16:16:58
 * @FilePath: /kong_matser/lib/views/themes/index.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:flutter/material.dart';

class Themes {
  static final black = ThemeData.dark();
  static final white = ThemeData.light().copyWith(
      brightness: Brightness.light,
      indicatorColor: const Color.fromRGBO(15, 17, 28, 0.75),
      toggleableActiveColor: const Color.fromARGB(255, 104, 28, 236),
      focusColor: const Color.fromRGBO(25, 80, 123, 1),
      shadowColor: const Color.fromARGB(38, 18, 79, 123),
      dividerColor: Colors.transparent,
      hintColor: const Color.fromRGBO(169, 169, 169, 1),
      primaryColor: Colors.black,
      disabledColor: const Color.fromRGBO(133, 133, 133, 0.316),
      unselectedWidgetColor: const Color.fromRGBO(13, 13, 13, 0.5),
      backgroundColor: const Color.fromRGBO(247, 247, 247, 1),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent), // 设置全局边框颜色
        ),
      ),
      appBarTheme: const AppBarTheme(
          shadowColor: Colors.transparent,
          backgroundColor: Color.fromRGBO(31, 100, 144, 1),
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          textTheme: TextTheme(
              bodyText1: TextStyle(
                fontFamily: 'PingFangMedium',
              ),
              bodyText2: TextStyle(
                fontFamily: 'Arial',
              ),
              headline6: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500))),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.all(
                  const Color.fromRGBO(28, 108, 236, 1)))),
      colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromRGBO(28, 108, 236, 1),
          secondary: const Color.fromRGBO(28, 108, 236, 1)));
}
