import 'package:flutter/material.dart';

TextStyle tipStyle() {
  return const TextStyle(
      color: Color.fromRGBO(13, 13, 13, 1),
      fontSize: 18,
      fontWeight: FontWeight.w600);
}

TextStyle titleStyle({double Size: 16}) {
  return TextStyle(
      color: Color.fromRGBO(13, 13, 13, 1),
      fontSize: Size,
      fontWeight: FontWeight.w600);
}

TextStyle titleStyleS() {
  return const TextStyle(
      color: Color.fromRGBO(13, 13, 13, 1),
      fontSize: 16,
      fontWeight: FontWeight.w400);
}

TextStyle valueStyle() {
  return const TextStyle(
      color: Color.fromRGBO(15, 17, 28, 0.5),
      fontSize: 16,
      fontWeight: FontWeight.w400);
}

TextStyle ErrorTip() {
  return const TextStyle(
      color: Color.fromRGBO(140, 140, 140, 1),
      fontSize: 14,
      height: 2,
      fontWeight: FontWeight.w400);
}

TextStyle ActiveTip() {
  return const TextStyle(
      color: Color.fromRGBO(0, 128, 255, 1),
      fontSize: 14,
      height: 2,
      fontWeight: FontWeight.w400);
}
