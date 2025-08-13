// ignore: depend_on_referenced_packages
import 'dart:convert';

import 'package:get/get.dart';

// ignore: camel_case_types
class systemAnalysisController extends GetxController {
  RxInt analysisType = 99.obs;
  void setAnalysisType(val) {
    analysisType.value = val;
    update();
  }

  RxInt selectType = 99.obs;
  void setSelectType(val) {
    selectType.value = val;
    update();
  }

  /**
   * 工装连接中的设备
   */
  RxMap<dynamic, dynamic> connectedSystem = {}.obs;

  void setConnectedSystem(val) {
    connectedSystem.value = jsonDecode(jsonEncode(val));
    update();
  }

  /**
   * 选择查询的设备
   */
  RxMap<dynamic, dynamic> selectedSystem = {}.obs;
  void setSelectedSystem(val) {
    selectedSystem.value = jsonDecode(jsonEncode(val));
    update();
  }
}
