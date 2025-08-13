/*
 * @Author: FishHaveMine 751174479@qq.com
 * @Date: 2024-06-03 10:33:10
 * @LastEditors: FishHaveMine 751174479@qq.com
 * @LastEditTime: 2024-06-11 14:11:05
 * @FilePath: /fluoroscopy_tool/lib/view/local/publicFunction.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
/*
 * @Author: FishHaveMine 751174479@qq.com
 * @Date: 2024-06-03 10:33:10
 * @LastEditors: FishHaveMine 751174479@qq.com
 * @LastEditTime: 2024-06-08 14:18:14
 * @FilePath: /fluoroscopy_tool/lib/view/local/class.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */

// ignore: depend_on_referenced_packages
import 'dart:convert';

import 'package:get/get.dart';

class cloudProjectController extends GetxController {
  var isMODEL_OLD_CHANGE = false.obs;
  setisMODEL_OLD_CHANGE(val) {
    isMODEL_OLD_CHANGE.value = val;
    update();
  }

  var selectProject = {}.obs;
  setSelectProject(val) {
    print("setSelectProject:  $val");
    selectProject.value = val;
    update();
  }

  var selectDevice = {}.obs;
  setSelectDevice(val) {
    var _val = jsonDecode(jsonEncode(val));
    Map updatedData = _val.map((key, value) {
      return MapEntry(
        key,
        value is Map && value.isEmpty ? '' : value,
      );
    });
    selectDevice.value = updatedData;
    update();
  }

  var selectDeviceinfo = {}.obs;
  setSelectDeviceinfo(val) {
    Map updatedData = val.map((key, value) {
      return MapEntry(
        key,
        value is Map && value.isEmpty ? '' : value,
      );
    });
    selectDeviceinfo.value = updatedData;
    update();
  }

  var sysData = {}.obs;
  setSysDevCheckData(val) {
    sysData.value = val;
    update();
  }

  var nodeTr = {}.obs;
  setNoderTr(val) {
    for (var element in val.keys) {
      print(element);
    }
    nodeTr.value = val;
    update();
  }

  var indoorList = [].obs;
  setIndoorList(val) {
    indoorList.value = val;
    update();
  }

  var outdoorList = [].obs;
  setOutdoorList(val) {
    outdoorList.value = val;
    update();
  }

  var snJumpModule = {}.obs;
  setsnJumpModule(val) {
    Map updatedData = val.map((key, value) {
      return MapEntry(
        key,
        value is Map && value.isEmpty ? '' : value,
      );
    });
    snJumpModule.value = updatedData;
    for (var element in val.keys) {
      print('setsnJumpModule  $element   --------   ${val[element]}');
    }
    update();
  }

  var routineCheckData = {}.obs;
  setRoutineCheckData(val) {
    routineCheckData.value = val;
    update();
  }

  clean() {
    print("clean");
    // selectProject = {}.obs;
    // selectDevice = {}.obs;
    // selectDeviceinfo = {}.obs;
    snJumpModule = {}.obs;
    indoorList = [].obs;
    nodeTr = {}.obs;
    sysData = {}.obs;
    routineCheckData.value = {};
    snJumpModule = {}.obs;
    outdoorList = [].obs;
  }
}

// 设备类
class Device {
  String sysid;
  String version;
  String model;
  String sn;
  String gaywaysn;
  String totalMatches;
  String matchingNumber;
  String runningModel;
  bool isconnected;
  String errorCode;
  String ODU;
  String IDU;
  List<dynamic> outdoorEntityList;
  List<dynamic> indoorEntityList;

  // 构造函数
  Device({
    required this.sysid,
    required this.version,
    required this.model,
    required this.sn,
    required this.gaywaysn,
    required this.totalMatches,
    required this.matchingNumber,
    required this.runningModel,
    required this.isconnected,
    required this.errorCode,
    required this.ODU,
    required this.IDU,
    required this.outdoorEntityList,
    required this.indoorEntityList,
  });

  // 从 JSON 构造设备对象
  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      sysid: json['sysid'],
      version: json['version'],
      model: json['model'],
      sn: json['sn'],
      gaywaysn: json['gaywaysn'],
      totalMatches: json['totalMatches'],
      matchingNumber: json['matchingNumber'],
      runningModel: json['runningModel'],
      isconnected: json['isconnected'],
      errorCode: json['errorCode'],
      ODU: json['ODU'],
      IDU: json['IDU'],
      outdoorEntityList: json['outdoorEntityList'] ?? [],
      indoorEntityList: json['indoorEntityList'] ?? [],
    );
  }

  // 将设备对象转换为 JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sysid'] = this.sysid;
    data['version'] = this.version;
    data['model'] = this.model;
    data['sn'] = this.sn;
    data['gaywaysn'] = this.gaywaysn;
    data['totalMatches'] = this.totalMatches;
    data['matchingNumber'] = this.matchingNumber;
    data['runningModel'] = this.runningModel;
    data['isconnected'] = this.isconnected;
    data['errorCode'] = this.errorCode;
    data['ODU'] = this.ODU;
    data['IDU'] = this.IDU;
    data['outdoorEntityList'] = this.outdoorEntityList;
    data['indoorEntityList'] = this.indoorEntityList;
    return data;
  }
}
