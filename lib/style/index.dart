import 'package:flutter/material.dart';

Color? snInputColors = Colors.grey[200];
TextStyle actionsTextButtonStyle() {
  return const TextStyle(
      color: Color.fromRGBO(140, 140, 140, 1),
      fontSize: 14,
      fontWeight: FontWeight.w400);
}

TextStyle ErrorTip() {
  return const TextStyle(
      color: Color.fromRGBO(140, 140, 140, 1),
      fontSize: 14,
      height: 2,
      fontWeight: FontWeight.w400);
}

TextStyle titleText(
    {double lineheight = 2,
    Color fontcolor = const Color.fromRGBO(15, 17, 28, 1)}) {
  return TextStyle(
      color: fontcolor,
      fontSize: 17,
      height: lineheight,
      fontWeight: FontWeight.w700);
}

TextStyle normalText(
    {double lineheight = 2,
    double fSize = 14,
    Color fontcolor = const Color.fromRGBO(140, 140, 140, 1)}) {
  return TextStyle(
      color: fontcolor,
      fontSize: fSize,
      height: lineheight,
      fontWeight: FontWeight.w400);
}

TextStyle normalTextWhilte(
    {double lineheight = 1,
    double fSize = 12,
    Color fontcolor = const Color.fromRGBO(255, 255, 255, 1)}) {
  return TextStyle(
      color: fontcolor,
      fontSize: fSize,
      height: lineheight,
      fontWeight: FontWeight.w400);
}

TextStyle normalTextS(
    {double lineheight = 2,
    double fSize = 12,
    Color fontcolor = const Color.fromRGBO(140, 140, 140, 1)}) {
  return TextStyle(
      color: fontcolor,
      fontSize: fSize,
      height: lineheight,
      fontWeight: FontWeight.w400);
}

TextStyle normalTextBlack(
    {double lineheight = 2,
    double fSize = 14,
    FontWeight fw = FontWeight.w400,
    Color fontcolor = const Color.fromRGBO(15, 17, 28, 1)}) {
  return TextStyle(
      color: fontcolor, fontSize: fSize, height: lineheight, fontWeight: fw);
}

TextStyle selectText(
    {double lineheight = 2,
    double fSize = 16,
    FontWeight fw = FontWeight.w600,
    Color fontcolor = const Color.fromRGBO(25, 98, 255, 1)}) {
  return TextStyle(
      color: fontcolor, fontSize: fSize, height: lineheight, fontWeight: fw);
}
