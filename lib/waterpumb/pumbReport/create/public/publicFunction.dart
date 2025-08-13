import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../com/tableByJson.dart';
import 'InstallationInfo.dart';
import 'buildFormItem.dart';

enum meunRefreshstate { none, refreshing, didrefresh }

class meunListItem {
  final String title;
  final String unit;
  final String min;
  final String max;
  final String step;
  final String defaultVal;
  final String name;
  final TextEditingController textEditingController;
  final List Enum;

  String initVal = "";
  FocusNode focusNode = FocusNode();
  bool didEdit = false;
  int enumVal = 0;
  String timeVal = "";
  meunRefreshstate refreshState = meunRefreshstate.none;

  get value {
    //有Enum就是Enum，没有就是textEditingController.text + unit
    if (Enum.isEmpty) {
      return "${textEditingController.text} ${unit}";
    }

    List enumList = Enum.where((e) {
      return e['index'] == enumVal;
    }).toList();
    if (enumList.isEmpty) {
      return "--";
    }

    return enumList.first["languageKey"].toString().tr;
  }

  meunListItem({
    required this.title,
    required this.name,
    required this.unit,
    required this.defaultVal,
    required this.max,
    required this.min,
    required this.textEditingController,
    required this.Enum,
    required this.step,
  });

  // 工厂方法用于从 Map 转换为模型
  factory meunListItem.fromJson(Map<String, dynamic> json) {
    String def = json['defaultVal'] ?? "0";
    if (def.isEmpty) {
      def = "0";
    }
    var item = meunListItem(
      title: json['title'] ?? '',
      name: json['name'] ?? '',
      unit: json['unit'] ?? '',
      defaultVal: def,
      textEditingController: TextEditingController(text: def),
      max: json['max'] ?? '',
      min: json['min'] ?? '',
      Enum: json["enum"] ?? [],
      step: json['step'] ?? "",
    );

    return item;
  }
}

Widget builditemByType(field, ispreview) {
  if (field.runtimeType == String) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Text(
        field,
        textAlign: TextAlign.left,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  } else if (field.runtimeType == Text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: field,
    );
  } else if (field.runtimeType == int) {
    return Container(
      width: double.infinity,
      height: double.parse(field.toString()),
      color: const Color.fromRGBO(245, 245, 245, 1),
    );
  } else if (field.runtimeType == FormItem) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: buildFormItem(
          item: field,
          readOnly: ispreview,
          onValidator: (e) => {field.val = e ?? "", print(field.val)},
        ));
  } else if (field.runtimeType == TableConfig) {
// 在界面中使用组件
    return tableByJson(
      setting: field,
    );
  } else {
    return field;
  }
}
