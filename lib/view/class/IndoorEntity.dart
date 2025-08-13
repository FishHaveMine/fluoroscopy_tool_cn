import 'dart:math';

class IduTypeEnum {
  final String key;
  final int value;
  final String desc;

  const IduTypeEnum(this.key, this.value, this.desc);

  static const IduTypeEnum IduType_0 = IduTypeEnum("IduType_0", 0, "老内机");
  static const IduTypeEnum IduType_1 = IduTypeEnum("IduType_1", 1, "环形出风Q4");
  static const IduTypeEnum IduType_2 = IduTypeEnum("IduType_2", 2, "G挂壁");
  static const IduTypeEnum IduType_3 = IduTypeEnum("IduType_3", 3, "自由静压T2");
  static const IduTypeEnum IduType_4 = IduTypeEnum("IduType_4", 4, "薄型风管机T2");
  static const IduTypeEnum IduType_5 = IduTypeEnum("IduType_5", 5, "美式风管机");
  static const IduTypeEnum IduType_6 = IduTypeEnum("IduType_6", 6, "T1高静压");
  static const IduTypeEnum IduType_7 = IduTypeEnum("IduType_7", 7, "环形出风Q4_");
  static const IduTypeEnum IduType_8 = IduTypeEnum("IduType_8", 8, "DL座吊");
  static const IduTypeEnum IduType_9 = IduTypeEnum("IduType_9", 9, "立式暗装");
  static const IduTypeEnum IduType_10 = IduTypeEnum("IduType_10", 10, "立式明装");
  static const IduTypeEnum IduType_11 = IduTypeEnum("IduType_11", 11, "新风机");
  static const IduTypeEnum IduType_12 = IduTypeEnum("IduType_12", 12, "一拖一");
  static const IduTypeEnum IduType_13 = IduTypeEnum("IduType_13", 13, "全热交换器");
  static const IduTypeEnum IduType_14 = IduTypeEnum("IduType_14", 14, "一面出风");
  static const IduTypeEnum IduType_15 = IduTypeEnum("IduType_15", 15, "两面出风");
  static const IduTypeEnum IduType_16 =
      IduTypeEnum("IduType_16", 16, "Console");
  static const IduTypeEnum IduType_17 = IduTypeEnum("IduType_17", 17, "高温水力模块");
  static const IduTypeEnum IduType_18 = IduTypeEnum("IduType_18", 18, "T3新风机");
  static const IduTypeEnum IduType_19 =
      IduTypeEnum("IduType_19", 19, "Clivet新风机");
  static const IduTypeEnum IduType_20 =
      IduTypeEnum("IduType_20", 20, "常温小风量新风机");
  static const IduTypeEnum IduType_21 = IduTypeEnum("IduType_21", 21, "独立控制盒");
  static const IduTypeEnum IduType_22 = IduTypeEnum("IduType_22", 22, "柜机");
  static const IduTypeEnum IduType_23 = IduTypeEnum("IduType_23", 23, "加湿器");
  static const IduTypeEnum IduType_24 =
      IduTypeEnum("IduType_24", 24, "独立控制盒_出风温度控制");
  static const IduTypeEnum IduType_25 = IduTypeEnum("IduType_25", 25, "小多联新风机");
  static const IduTypeEnum IduType_26 = IduTypeEnum("IduType_26", 26, "直棚机");
  static const IduTypeEnum IduType_27 = IduTypeEnum("IduType_27", 27, "低温水力模块");
  static const IduTypeEnum IduType_28 = IduTypeEnum("IduType_28", 28, "中温水力模块");
  static const IduTypeEnum IduType_29 = IduTypeEnum("IduType_29", 29, "采暖水力模块");
  static const IduTypeEnum IduType_30 = IduTypeEnum("IduType_30", 30, "直棚机_再热");
  static const IduTypeEnum IduType_31 = IduTypeEnum("IduType_31", 31, "烤烟内机");
  static const IduTypeEnum IduType_32 = IduTypeEnum("IduType_32", 32, "AT内机");
  static const IduTypeEnum IduType_33 = IduTypeEnum("IduType_33", 33, "卧式");
  static const IduTypeEnum IduType_34 = IduTypeEnum("IduType_34", 34, "制热水箱");
  static const IduTypeEnum IduType_61 =
      IduTypeEnum("IduType_61", 61, "ByPassKit");
  static const IduTypeEnum IduType_62 = IduTypeEnum("IduType_62", 62, "屋顶机");

  static IduTypeEnum? fromInt(int value) {
    switch (value) {
      case 0:
        return IduType_0;
      case 1:
        return IduType_1;
      case 2:
        return IduType_2;
      case 3:
        return IduType_3;
      case 4:
        return IduType_4;
      case 5:
        return IduType_5;
      case 6:
        return IduType_6;
      case 7:
        return IduType_7;
      case 8:
        return IduType_8;
      case 9:
        return IduType_9;
      case 10:
        return IduType_10;
      case 11:
        return IduType_11;
      case 12:
        return IduType_12;
      case 13:
        return IduType_13;
      case 14:
        return IduType_14;
      case 15:
        return IduType_15;
      case 16:
        return IduType_16;
      case 17:
        return IduType_17;
      case 18:
        return IduType_18;
      case 19:
        return IduType_19;
      case 20:
        return IduType_20;
      case 21:
        return IduType_21;
      case 22:
        return IduType_22;
      case 23:
        return IduType_23;
      case 24:
        return IduType_24;
      case 25:
        return IduType_25;
      case 26:
        return IduType_26;
      case 27:
        return IduType_27;
      case 28:
        return IduType_28;
      case 29:
        return IduType_29;
      case 30:
        return IduType_30;
      case 31:
        return IduType_31;
      case 32:
        return IduType_32;
      case 33:
        return IduType_33;
      case 34:
        return IduType_34;
      case 61:
        return IduType_61;
      case 62:
        return IduType_62;
      default:
        return null;
    }
  }
}

class IndoorEntity {
  int? address;
  String? sn;
  IduTypeEnum? indoorType;
  double? indoorHouse;
  String? onOff;
  String? mode;
  String? parmFan;
  double? settingTemp;
  double? roomTemp;
  double? elecHeatingTempT1Setting;
  double? t2ATemp;
  double? t2Temp;
  double? t2BTemp;
  double? evx;
  String? errorCode;
  int? indoorSoftwareVersion;
  int? indoorSubSoftwareVersion;
  bool? isV6;
  double? outletAirTemp;
  String? deviceName;

  IndoorEntity({
    this.address,
    this.sn,
    this.indoorType,
    this.indoorHouse,
    this.onOff,
    this.mode,
    this.parmFan,
    this.settingTemp,
    this.roomTemp,
    this.elecHeatingTempT1Setting,
    this.t2ATemp,
    this.t2Temp,
    this.t2BTemp,
    this.evx,
    this.errorCode,
    this.indoorSoftwareVersion,
    this.indoorSubSoftwareVersion,
    this.isV6,
    this.outletAirTemp,
    this.deviceName,
  });

  factory IndoorEntity.fromJson(Map<String, dynamic> json) {
    return IndoorEntity(
      address: json['address'] ?? 0,
      sn: json['sn'] ?? '',
      indoorType: IduTypeEnum(json['indoorType']['key'],
          json['indoorType']['value'], json['indoorType']['desc']),
      indoorHouse: json['indoorHouse'] ?? 0.0,
      onOff: json['onOff'] ?? '',
      mode: json['mode'] ?? '',
      parmFan: json['parmFan'] ?? '',
      settingTemp: json['settingTemp'] ?? 0.0,
      roomTemp: json['roomTemp'] ?? 0.0,
      elecHeatingTempT1Setting: json['elecHeatingTempT1Setting'] ?? 0.0,
      t2ATemp: json['t2ATemp'] ?? 0.0,
      t2Temp: json['t2Temp'] ?? 0.0,
      t2BTemp: json['t2BTemp'] ?? 0.0,
      evx: json['evx'] ?? 0.0,
      errorCode: json['errorCode'] ?? '',
      indoorSoftwareVersion: json['indoorSoftwareVersion'] ?? 0,
      indoorSubSoftwareVersion: json['indoorSubSoftwareVersion'] ?? 0,
      isV6: json['isV6'] ?? false,
      outletAirTemp: json['outletAirTemp'] ?? 0.0,
      deviceName: json['deviceName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'sn': sn,
      'indoorType': indoorType,
      'indoorHouse': indoorHouse,
      'onOff': onOff,
      'mode': mode,
      'parmFan': parmFan,
      'settingTemp': settingTemp,
      'roomTemp': roomTemp,
      't2ATemp': t2ATemp,
      't2Temp': t2Temp,
      't2BTemp': t2BTemp,
      'evx': evx,
      'errorCode': errorCode,
      'indoorSoftwareVersion': indoorSoftwareVersion,
      'indoorSubSoftwareVersion': indoorSubSoftwareVersion,
      'isV6': isV6,
      'outletAirTemp': outletAirTemp,
      'deviceName': deviceName,
    };
  }

  static IndoorEntity random() {
    final entity = IndoorEntity();
    final random = Random();

    entity.address = random.nextInt(1000);
    entity.sn = 'SN${random.nextInt(100)}';
    entity.indoorType = IduTypeEnum.fromInt(random.nextInt(35));
    entity.indoorHouse = random.nextDouble() * 10;
    entity.onOff = 'OnOff${random.nextInt(2)}';
    entity.mode = 'Mode${random.nextInt(5)}';
    entity.parmFan = 'ParmFan${random.nextInt(4)}';
    entity.settingTemp = random.nextDouble() * 30;
    entity.roomTemp = random.nextDouble() * 30;
    entity.t2ATemp = random.nextDouble() * 30;
    entity.t2Temp = random.nextDouble() * 30;
    entity.t2BTemp = random.nextDouble() * 30;
    entity.evx = random.nextDouble() * 30;
    entity.errorCode = 'Error${random.nextInt(10)}';
    entity.indoorSoftwareVersion = random.nextInt(100);
    entity.indoorSubSoftwareVersion = random.nextInt(100);
    entity.isV6 = random.nextBool();
    entity.outletAirTemp = random.nextDouble() * 30;
    entity.deviceName = 'Device${random.nextInt(10)}';

    return entity;
  }
}
