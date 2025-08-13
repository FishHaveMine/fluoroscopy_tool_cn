Map<String, Map<int, String>> OduSalesBoardReplaceParameters = {
  "productserial": {0: "productserial0", 1: "productserial1"},
  "electricchassisheating": {
    0: "electricchassisheating0",
    1: "electricchassisheating1",
    3: "electricchassisheating3"
  },
  "technicalbarriers": {
    0: "technicalbarriers0",
    1: "technicalbarriers1",
    3: "technicalbarriers3"
  },
  "paralleltype": {0: "paralleltype0", 1: "paralleltype1", 3: "paralleltype3"},
  "compressbrand": {
    0: "compressbrand0",
    1: "compressbrand1",
    2: "compressbrand2"
  },
  "multiplewatersources": {
    0: "multiplewatersources0",
    1: "multiplewatersources1"
  },
  "bigvrf": {0: "bigvrf0", 1: "bigvrf1"},
  "electroniclock": {0: "electroniclock0", 1: "electroniclock1"},
  "compressselect": {0: "compressselect0", 1: "compressselect1"},
  "compresstype": {0: "compresstype0", 1: "compresstype1"},
  "airoutletway": {0: "airoutletway0", 1: "airoutletway1"},
  "powertype": {
    0: "powertype0",
    1: "powertype1",
    2: "powertype2",
    3: "powertype3",
    4: "powertype4",
    5: "powertype5"
  },
  "refrigeranttype": {
    0: "refrigeranttype0",
    1: "refrigeranttype1",
    2: "refrigeranttype2",
    3: "refrigeranttype3"
  },
  "derivedseries": {
    0: "derivedseries0",
    1: "derivedseries1",
    2: "derivedseries2",
    3: "derivedseries3",
    4: "derivedseries4",
    5: "derivedseries5",
    6: "derivedseries6",
    7: "derivedseries7",
    8: "derivedseries8",
    9: "derivedseries9",
    10: "derivedseries10"
  },
  "electriccontrolboxheating": {
    0: "electriccontrolboxheating0",
    1: "electriccontrolboxheating1",
    3: "electriccontrolboxheating3"
  },
  "packageoptions": {
    0: "packageoptions0",
    1: "packageoptions1",
    2: "packageoptions2",
    3: "packageoptions3",
    4: "packageoptions4",
    5: "packageoptions5",
    6: "packageoptions6",
    7: "packageoptions7",
    8: "packageoptions8",
    15: "packageoptions15"
  },
  "fanmotortype": {
    0: "fanmotortype0",
    1: "fanmotortype1",
    2: "fanmotortype2",
    3: "fanmotortype3"
  },
  "refrigerationcyclesetting": {
    0: "refrigerationcyclesetting0",
    1: "refrigerationcyclesetting1",
    2: "refrigerationcyclesetting2"
  },
  "myhomeconnectsetting": {
    0: "myhomeconnectsetting0",
    1: "myhomeconnectsetting1"
  }
};

class OduSalesBoardReplaceParametersMock {
  double? oduHorses;
  int? productSerial;
  int? electricChassisHeating;
  int? technicalBarriers;
  int? parallelType;
  int? compressBrand;
  int? multipleWaterSources;
  int? bigVrf;
  int? electronicLock;
  int? compressSelect;
  int? compressType;
  int? airOutletWay;
  int? powerType;
  int? refrigerantType;
  int? derivedSeries;
  int? electricControlBoxHeating;
  int? packageOptions;
  int? fanMotorType;
  int? refrigerationCycleSetting;
  int? myhomeConnectSetting;

  OduSalesBoardReplaceParametersMock({
    this.oduHorses,
    this.productSerial,
    this.electricChassisHeating,
    this.technicalBarriers,
    this.parallelType,
    this.compressBrand,
    this.multipleWaterSources,
    this.bigVrf,
    this.electronicLock,
    this.compressSelect,
    this.compressType,
    this.airOutletWay,
    this.powerType,
    this.refrigerantType,
    this.derivedSeries,
    this.electricControlBoxHeating,
    this.packageOptions,
    this.fanMotorType,
    this.refrigerationCycleSetting,
    this.myhomeConnectSetting,
  });

  factory OduSalesBoardReplaceParametersMock.fromJson(
      Map<String, dynamic> json) {
    return OduSalesBoardReplaceParametersMock(
      oduHorses: json['oduHorses'] ?? 0.0,
      productSerial: json['productSerial'] ?? 0,
      electricChassisHeating: json['electricChassisHeating'] ?? 0,
      technicalBarriers: json['technicalBarriers'] ?? 0,
      parallelType: json['parallelType'] ?? 0,
      compressBrand: json['compressBrand'] ?? 0,
      multipleWaterSources: json['multipleWaterSources'] ?? 0,
      bigVrf: json['bigVrf'] ?? 0,
      electronicLock: json['electronicLock'] ?? 0,
      compressSelect: json['compressSelect'] ?? 0,
      compressType: json['compressType'] ?? 0,
      airOutletWay: json['airOutletWay'] ?? 0,
      powerType: json['powerType'] ?? 0,
      refrigerantType: json['refrigerantType'] ?? 0,
      derivedSeries: json['derivedSeries'] ?? 0,
      electricControlBoxHeating: json['electricControlBoxHeating'] ?? 0,
      packageOptions: json['packageOptions'] ?? 0,
      fanMotorType: json['fanMotorType'] ?? 0,
      refrigerationCycleSetting: json['refrigerationCycleSetting'] ?? 0,
      myhomeConnectSetting: json['myhomeConnectSetting'] ?? 0,
    );
  }
  factory OduSalesBoardReplaceParametersMock.sampleData() {
    return OduSalesBoardReplaceParametersMock(
      oduHorses: 0.0,
      productSerial: 0,
      electricChassisHeating: 0,
      technicalBarriers: 0,
      parallelType: 0,
      compressBrand: 0,
      multipleWaterSources: 0,
      bigVrf: 0,
      electronicLock: 0,
      compressSelect: 0,
      compressType: 0,
      airOutletWay: 0,
      powerType: 0,
      refrigerantType: 0,
      derivedSeries: 0,
      electricControlBoxHeating: 0,
      packageOptions: 0,
      fanMotorType: 0,
      refrigerationCycleSetting: 0,
      myhomeConnectSetting: 0,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oduHorses'] = this.oduHorses;
    data['productSerial'] = this.productSerial;
    data['electricChassisHeating'] = this.electricChassisHeating;
    data['technicalBarriers'] = this.technicalBarriers;
    data['parallelType'] = this.parallelType;
    data['compressBrand'] = this.compressBrand;
    data['multipleWaterSources'] = this.multipleWaterSources;
    data['bigVrf'] = this.bigVrf;
    data['electronicLock'] = this.electronicLock;
    data['compressSelect'] = this.compressSelect;
    data['compressType'] = this.compressType;
    data['airOutletWay'] = this.airOutletWay;
    data['powerType'] = this.powerType;
    data['refrigerantType'] = this.refrigerantType;
    data['derivedSeries'] = this.derivedSeries;
    data['electricControlBoxHeating'] = this.electricControlBoxHeating;
    data['packageOptions'] = this.packageOptions;
    data['fanMotorType'] = this.fanMotorType;
    data['refrigerationCycleSetting'] = this.refrigerationCycleSetting;
    data['myhomeConnectSetting'] = this.myhomeConnectSetting;
    return data;
  }
}

// 定义一个映射，将整数值映射到对应的描述文本
Map<String, Map<int, String>> indoorParameters = {
  "productserial": {
    0: "indoorparameters.productserial0",
    1: "indoorparameters.productserial1"
  },
  "indooralarmsetting": {
    0: "indoorparameters.indooralarmsetting0",
    1: "indoorparameters.indooralarmsetting1",
    3: "indoorparameters.indooralarmsetting3"
  },
  "powerdownsetting": {
    0: "indoorparameters.powerdownsetting0",
    1: "indoorparameters.powerdownsetting1",
    3: "indoorparameters.powerdownsetting3"
  },
  "derivativeseriessetting": {
    0: "indoorparameters.derivativeseriessetting0",
    1: "indoorparameters.derivativeseriessetting1",
    2: "indoorparameters.derivativeseriessetting2",
    3: "indoorparameters.derivativeseriessetting3",
    4: "indoorparameters.derivativeseriessetting4",
    5: "indoorparameters.derivativeseriessetting5",
    6: "indoorparameters.derivativeseriessetting6",
    7: "indoorparameters.derivativeseriessetting7",
    8: "indoorparameters.derivativeseriessetting8",
    9: "indoorparameters.derivativeseriessetting9"
  },
  "elecheatingsetting": {
    0: "indoorparameters.elecheatingsetting0",
    1: "indoorparameters.elecheatingsetting1"
  },
  "sterilizationsetting": {
    0: "indoorparameters.sterilizationsetting0",
    1: "indoorparameters.sterilizationsetting1",
    3: "indoorparameters.sterilizationsetting3"
  },
  "remoteshutdownsetting": {
    0: "indoorparameters.remoteshutdownsetting0",
    1: "indoorparameters.remoteshutdownsetting1",
    3: "indoorparameters.remoteshutdownsetting3"
  },
  "constantairvolumesetting": {
    0: "indoorparameters.constantairvolumesetting0",
    1: "indoorparameters.constantairvolumesetting1",
    2: "indoorparameters.constantairvolumesetting2",
    3: "indoorparameters.constantairvolumesetting3"
  },
  "myhomeconnectsetting": {
    0: "indoorparameters.myhomeconnectsetting0",
    1: "indoorparameters.myhomeconnectsetting1"
  },
  "bypassenable": {
    0: "indoorparameters.bypassenable0",
    1: "indoorparameters.bypassenable1"
  },
  "indoortype": {
    0: "indoorparameters.indoortype0",
    1: "indoorparameters.indoortype1",
    2: "indoorparameters.indoortype2",
    3: "indoorparameters.indoortype3",
    4: "indoorparameters.indoortype4",
    5: "indoorparameters.indoortype5",
    6: "indoorparameters.indoortype6",
    7: "indoorparameters.indoortype7",
    8: "indoorparameters.indoortype8",
    9: "indoorparameters.indoortype9",
    10: "indoorparameters.indoortype10",
    11: "indoorparameters.indoortype11",
    12: "indoorparameters.indoortype12",
    13: "indoorparameters.indoortype13",
    14: "indoorparameters.indoortype14",
    15: "indoorparameters.indoortype15",
    16: "indoorparameters.indoortype16",
    17: "indoorparameters.indoortype17",
    18: "indoorparameters.indoortype18",
    19: "indoorparameters.indoortype19",
    20: "indoorparameters.indoortype20",
    21: "indoorparameters.indoortype21",
    22: "indoorparameters.indoortype22",
    23: "indoorparameters.indoortype23",
    24: "indoorparameters.indoortype24",
    25: "indoorparameters.indoortype25",
    26: "indoorparameters.indoortype26",
    27: "indoorparameters.indoortype27",
    28: "indoorparameters.indoortype28",
    29: "indoorparameters.indoortype29",
    30: "indoorparameters.indoortype30",
    31: "indoorparameters.indoortype31",
    32: "indoorparameters.indoortype32",
    33: "indoorparameters.indoortype33",
    34: "indoorparameters.indoortype34",
    61: "indoorparameters.indoortype61",
    62: "indoorparameters.indoortype62"
  }
};

class IndoorSettings {
  int indoorAlarmSetting; // Bit7~6
  int powerDownSetting; // Bit1~0
  int derivativeSeriesSetting; // 0-9
  int elecHeatingSetting; // Bit7
  int sterilizationSetting; // Bit1~0
  int remoteShutdownSetting; // Bit3~2
  int indoorType;
  int constantAirVolumeSetting; // Bit1~0
  int myhomeConnectSetting; // Bit6
  int bypassEnable; // Bit4
  double indoorPlateHorses;

  IndoorSettings({
    required this.indoorAlarmSetting,
    required this.powerDownSetting,
    required this.derivativeSeriesSetting,
    required this.elecHeatingSetting,
    required this.sterilizationSetting,
    required this.remoteShutdownSetting,
    required this.indoorType,
    required this.constantAirVolumeSetting,
    required this.myhomeConnectSetting,
    required this.bypassEnable,
    required this.indoorPlateHorses,
  });

  // Factory method to create an instance with simulated data
  factory IndoorSettings.sampleData() {
    return IndoorSettings(
      indoorAlarmSetting: 1, // Example value
      powerDownSetting: 0, // Example value
      derivativeSeriesSetting: 5, // Example value
      elecHeatingSetting: 1, // Example value
      sterilizationSetting: 3, // Example value
      remoteShutdownSetting: 1, // Example value
      indoorType: 0, // Example value
      constantAirVolumeSetting: 2, // Example value
      myhomeConnectSetting: 1, // Example value
      bypassEnable: 1, // Example value
      indoorPlateHorses: 2.5, // Example value
    );
  }
}
