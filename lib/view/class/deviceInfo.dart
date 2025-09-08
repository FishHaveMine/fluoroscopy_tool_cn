// ignore: camel_case_types
class deviceInfo {
  String sn;
  String machine;
  String version; //版本
  String model; //协议
  int ODU; //外机数
  int IDU; //内机数
  double totalMatches; //总匹数
  double matchingNumber; //配比数
  String runningModel; //运行模式: 制冷、制热
  bool isconnected; //是否连接
  String errorCode; //故障代码
  String oduTypeEnum; //机器类型
  deviceInfo({
    required this.sn,
    required this.machine,
    required this.version,
    required this.model,
    required this.ODU,
    required this.IDU,
    required this.totalMatches,
    required this.matchingNumber,
    required this.runningModel,
    required this.isconnected,
    required this.errorCode,
    required this.oduTypeEnum,
  });

  // 将对象转换为 JSON 格式的方法
  Map<String, dynamic> toJson() {
    return {
      'sn': sn,
      'machine': machine,
      'version': version,
      'model': model,
      'ODU': ODU,
      'IDU': IDU,
      'totalMatches': totalMatches,
      'matchingNumber': matchingNumber,
      'runningModel': runningModel,
      'isconnected': isconnected,
      'errorCode': errorCode,
      'oduTypeEnum': oduTypeEnum,
    };
  }

  // 添加转 Map 方法
  Map<String, dynamic> toMap() {
    return {
      'sn': sn,
      'machine': machine,
      'version': version,
      'model': model,
      'ODU': ODU,
      'IDU': IDU,
      'totalMatches': totalMatches,
      'matchingNumber': matchingNumber,
      'runningModel': runningModel,
      'oduTypeEnum': oduTypeEnum,
      'isconnected': isconnected,
      'errorCode': errorCode,
    };
  }

  // 工厂构造函数
  factory deviceInfo.copy(deviceInfo other) {
    return deviceInfo(
      sn: other.sn,
      machine: other.machine,
      version: other.version,
      model: other.model,
      ODU: other.ODU,
      IDU: other.IDU,
      totalMatches: other.totalMatches,
      matchingNumber: other.matchingNumber,
      runningModel: other.runningModel,
      isconnected: other.isconnected,
      errorCode: other.errorCode,
      oduTypeEnum: other.oduTypeEnum,
    );
  }

  factory deviceInfo.fromJson(Map<String, dynamic> json) {
    try {
      return deviceInfo(
        sn: json['sn'] ?? '',
        machine: json['machine'] ?? '',
        version: json['version'] ?? '',
        model: json['model'] ?? '',
        ODU: json['ODU'] ?? 0,
        IDU: json['IDU'] ?? 0,
        totalMatches: json['totalMatches'] ?? 0,
        matchingNumber: json['matchingNumber'] ?? 0,
        runningModel: json['runningModel'] ?? '--',
        isconnected: json['isconnected'] ?? false,
        errorCode: json['errorCode'] ?? '--',
        oduTypeEnum: json['oduTypeEnum'] ?? '--',
      );
    } catch (e) {
      return deviceInfo(
        sn: '',
        machine: '',
        version: '',
        model: '',
        ODU: 0,
        IDU: 0,
        totalMatches: 0,
        matchingNumber: 0,
        runningModel: '--',
        isconnected: false,
        errorCode: '--',
        oduTypeEnum: '--',
      );
    }
  }
}
