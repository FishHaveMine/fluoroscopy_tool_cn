import 'package:get/get.dart';

class DeviceGatewayController extends GetxController {
  // 设备序列号
  final deviceSN = ''.obs;

  // 网关序列号
  final gatewaySN = ''.obs;

  // 机组类型
  final deviceType = ''.obs;

  // 注册状态
  final registrationStatus = false.obs;

  // 网关状态：0 表示离线，1 表示在线
  final gatewayStatus = 0.obs;

  // 设备状态：0 表示离线，1 表示在线
  final deviceStatus = 0.obs;

  // 组配置信息列表
  final groupConfigInfoList = <dynamic>[].obs;

  final afterfeath = false.obs;

  // 根据状态值获取设备状态中文描述，结合你提供的枚举含义
  String getDeviceStatusDesc() {
    switch (deviceStatus.value) {
      case 0:
        return "离线";
      case 1:
        return "运行";
      case 2:
        return "故障";
      case 3:
        return "关机";
      case 5:
        return "在线";
      default:
        return "";
    }
  }

  String getGatewayStatus() {
    switch (gatewayStatus.value) {
      case 0:
        return "离线";
      case 1:
        return "运行";
      case 2:
        return "故障";
      case 3:
        return "关机";
      case 5:
        return "在线";
      default:
        return "";
    }
  }

  var deviceTypeMap = {
    "centrifugalChiller": "离心机组",
    "scrollChiller": "涡旋机组",
    "waterCooledChiller": "水冷螺杆机组",
    "airCooledChiller": "风冷螺杆机组",
    "magneticLevitationChiller": "磁悬浮机组",
    "airCompressor": "空压机",
  };

  String getFormattedDisplayValue(String key) {
    if (key == 'deviceType') {
      return deviceTypeMap[deviceType.value] ?? "-";
    }
    for (var config in groupConfigInfoList) {
      if (config is Map && config['key'] == key) {
        final displayValue = config['displayValue'];
        final value = config['value'];
        if (displayValue != null && displayValue.toString().isNotEmpty) {
          return displayValue.toString();
        } else if (value != null && value.toString().isNotEmpty) {
          return value.toString();
        }
      }
    }
    return '-'; // 未找到或值为空时返回默认值
  }

  // 更新设备序列号
  void updateDeviceSN(String newSN) {
    deviceSN.value = newSN;
  }

  // 更新网关序列号
  void updateGatewaySN(String newSN) {
    gatewaySN.value = newSN;
  }

  // 更新注册状态
  void updateRegistrationStatus(bool status) {
    registrationStatus.value = status;
  }

  // 更新网关状态
  void updateGatewayStatus(int status) {
    gatewayStatus.value = status;
  }

  // 更新设备状态
  void updateDeviceStatus(int status) {
    deviceStatus.value = status;
  }

  // 添加组配置信息
  void addGroupConfigInfo(dynamic configInfo) {
    groupConfigInfoList.add(configInfo);
  }

  // 移除组配置信息
  void removeGroupConfigInfo(dynamic configInfo) {
    groupConfigInfoList.remove(configInfo);
  }

  // 清空组配置信息列表
  void clearGroupConfigInfoList() {
    groupConfigInfoList.clear();
  }

// 重置所有属性为默认值
  void resetToDefaults() {
    deviceSN.value = '';
    deviceType.value = '';
    gatewaySN.value = '';
    registrationStatus.value = false;
    gatewayStatus.value = 0;
    deviceStatus.value = 0;
    groupConfigInfoList.clear();
    afterfeath.value = false;
    update();
  }

  // 从 JSON 对象更新控制器属性
  void updateFromJson(Map<String, dynamic> json) {
    afterfeath.value = true;
    update();

    print("updateFromJson ------- : $json");
    if (json.containsKey('deviceSN')) {
      deviceSN.value = json['deviceSN'].toString();
    }

    if (json.containsKey('deviceType')) {
      deviceType.value = json['deviceType'].toString();
      update();
    }
    if (json.containsKey('gatewaySN')) {
      print(
          "updateFromJson ------- : ${json['gatewaySN'] == null ? '' : json['gatewaySN'].toString()}");
      gatewaySN.value =
          json['gatewaySN'] == null ? '' : json['gatewaySN'].toString();

      update();
    }

    if (json.containsKey('registrationStatus')) {
      registrationStatus.value = json['registrationStatus'] as bool;
    }

    if (json.containsKey('gatewayStatus')) {
      gatewayStatus.value =
          json['gatewayStatus'] == null ? -1 : json['gatewayStatus'] as int;
      update();
    }

    if (json.containsKey('deviceStatus')) {
      deviceStatus.value =
          json['deviceStatus'] == null ? -1 : json['deviceStatus'] as int;
      update();
    }

    if (json.containsKey('groupConfigInfoList')) {
      if (json['groupConfigInfoList'] is List) {
        groupConfigInfoList
            .assignAll(json['groupConfigInfoList'][0]['groupRealDatas']);
      }
    }
    update();
  }
}
