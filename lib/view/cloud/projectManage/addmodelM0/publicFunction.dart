import 'dart:convert';
import 'package:get/get.dart';

class MOaddController extends GetxController {
  var imgaeList = {
    "type1": "",
    "type2": "",
    "type3": "",
    "type4": "",
    "type5": "",
    "type6": "",
  }.obs; // 将对象设置为可观察的

  void cleanimgaeList() {
    imgaeList.value = {
      "type1": "",
      "type2": "",
      "type3": "",
      "type4": "",
      "type5": "",
      "type6": "",
    };
    update(); // 更新状态
  }

  void updateDeviceImgaeList(String Type, String url) {
    imgaeList[Type] = url; // 更新 deviceType
    update(); // 更新状态
  }

  // 使用 RxMap 来实现响应式更新
  var jsonObject = <String, dynamic>{
    "deviceType": "",
    "modifyType": "",
    "series": "",
    "systemName": "",
    "eauxiliaryHeat": "",
    "projectCode": "",
    "waterHardness": "",
    "uploadLocation": "",
    "moduleSn": "",
    "moduleType": "",
    "pieces": 0,
    "cloudConnectionBoxImg": "",
    "sprayDeviceInstallImg": "",
    "powerPositionImg": "",
    "waterTreatmentDeviceImg": "",
    "otherImg": "",
    "oldReformImgDataCompleteness": "ALL",
    "productBrand": "",
    "usedTimeYear": "",
    "refType": "",
    "coolCop": "",
    "heatCop": "",
  }.obs; // 将对象设置为可观察的

  // 清空默认值的方法
  void clearDefaultValues() {
    jsonObject.updateAll((key, value) {
      if (value is String) {
        return ""; // 对于字符串，重置为空字符串
      } else if (value is int) {
        return 0; // 对于整数，重置为 0
      } else if (value is List) {
        return []; // 对于列表，重置为空列表
      } else if (value is Map) {
        return {}; // 对于嵌套 Map，重置为空 Map
      }
      return null; // 其他情况，设置为 null
    });
  }

// 动态设置值的方法

  void updateDeviceInfo(
    String key,
    String val,
  ) {
    jsonObject['$key'] = val; // 更新 deviceType
    update(); // 更新状态
  }

  void updateDeviceType(String newType) {
    jsonObject['deviceType'] = newType; // 更新 deviceType
    update(); // 更新状态
  }

  void updateProductBrand(String newType) {
    jsonObject['productBrand'] = newType; // 更新 deviceType
    update(); // 更新状态
  }

  void updateModifyType(String newType) {
    jsonObject['modifyType'] = newType; // 更新 modifyType
    cleanimgaeList();
    update(); // 更新状态
  }

  void updateSeries(String newSeries) {
    jsonObject['series'] = newSeries; // 更新 series
    update(); // 更新状态
  }

  void updateSystemName(String newName) {
    jsonObject['systemName'] = newName; // 更新 systemName
    update(); // 更新状态
  }

  void updateEauxiliaryHeat(String newHeat) {
    jsonObject['eauxiliaryHeat'] = newHeat; // 更新 eauxiliaryHeat
    update(); // 更新状态
  }

  void updateProjectCode(String newCode) {
    jsonObject['projectCode'] = newCode; // 更新 projectCode
    update(); // 更新状态
  }

  void updateWaterHardness(String newHardness) {
    jsonObject['waterHardness'] = newHardness; // 更新 waterHardness
    update(); // 更新状态
  }

  void updateUploadLocation(String newLocation) {
    jsonObject['uploadLocation'] = newLocation; // 更新 uploadLocation
    update(); // 更新状态
  }

  void updatePropertyName(propertyName, newValue) {
    jsonObject[propertyName] = newValue; // 更新指定属性
    update(); // 更新状态（如果使用 GetBuilder 或类似方式）
  }

  String createJson() {
    // 将 Map 转换为 JSON 字符串
    return jsonEncode(jsonObject);
  }
}
