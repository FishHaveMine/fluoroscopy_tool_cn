import 'dart:convert';
import 'dart:math';

class OutdoorEntity {
  int? address;
  String? sn;
  String? outdoorHorse;
  String? frequencyLimitingState;
  int? windSpeed1;
  int? windSpeed2;
  int? externalACVoltage;
  int? primaryCurrent;
  int? outdoorBlockageRate;
  String? errorCode;
  String? sysIdx;
  int? powerQuality;
  String? version;
  double? highPressure;
  double? lowPressure;
  double? highPressureSaturationTemp;
  double? lowPressureSaturationTemp;
  int? compressor1Frequency;
  int? compressor2Frequency;
  int? directVoltage1;
  int? directVoltage2;
  int? compressorElectric1;
  int? compressorElectric2;
  int? compressorRunTime1;
  int? compressorRunTime2;
  double? t4Temp;
  double? t3Temp;
  double? t5Temp;
  double? t6ATemp;
  double? t6BTemp;
  double? t8Temp;
  double? tlTemp;
  double? tg;
  int? radiatorTemp1;
  int? radiatorTemp2;
  int? t7C1Temp;
  int? t7C2Temp;
  double? t71Temp;
  double? t72Temp;
  int? superHeatTemp;
  int? exva;
  int? exvb;
  int? exvc;
  int? eevd;
  String? sv5;
  String? sv6;
  String? sv7;
  String? sv8A;
  String? sv8B;

  OutdoorEntity({
    this.address,
    this.sn,
    this.outdoorHorse,
    this.frequencyLimitingState,
    this.windSpeed1,
    this.windSpeed2,
    this.externalACVoltage,
    this.primaryCurrent,
    this.outdoorBlockageRate,
    this.errorCode,
    this.sysIdx,
    this.powerQuality,
    this.version,
    this.highPressure,
    this.lowPressure,
    this.highPressureSaturationTemp,
    this.lowPressureSaturationTemp,
    this.compressor1Frequency,
    this.compressor2Frequency,
    this.directVoltage1,
    this.directVoltage2,
    this.compressorElectric1,
    this.compressorElectric2,
    this.compressorRunTime1,
    this.compressorRunTime2,
    this.t4Temp,
    this.t3Temp,
    this.t5Temp,
    this.t6ATemp,
    this.t6BTemp,
    this.t8Temp,
    this.tlTemp,
    this.tg,
    this.radiatorTemp1,
    this.radiatorTemp2,
    this.t7C1Temp,
    this.t7C2Temp,
    this.t71Temp,
    this.t72Temp,
    this.superHeatTemp,
    this.exva,
    this.exvb,
    this.exvc,
    this.eevd,
    this.sv5,
    this.sv6,
    this.sv7,
    this.sv8A,
    this.sv8B,
  });

  factory OutdoorEntity.fromJson(Map<String, dynamic> json) {
    return OutdoorEntity(
      address: json['address'],
      sn: json['sn'],
      outdoorHorse: json['outdoorHorse'],
      frequencyLimitingState: json['frequencyLimitingState'],
      windSpeed1: json['windSpeed1'],
      windSpeed2: json['windSpeed2'],
      externalACVoltage: json['externalACVoltage'],
      primaryCurrent: json['primaryCurrent'],
      outdoorBlockageRate: json['outdoorBlockageRate'],
      errorCode: json['errorCode'],
      sysIdx: json['sysIdx'],
      powerQuality: json['powerQuality'],
      version: json['version'],
      highPressure: json['highPressure'],
      lowPressure: json['lowPressure'],
      highPressureSaturationTemp: json['highPressureSaturationTemp'],
      lowPressureSaturationTemp: json['lowPressureSaturationTemp'],
      compressor1Frequency: json['compressor1Frequency'],
      compressor2Frequency: json['compressor2Frequency'],
      directVoltage1: json['directVoltage1'],
      directVoltage2: json['directVoltage2'],
      compressorElectric1: json['compressorElectric1'],
      compressorElectric2: json['compressorElectric2'],
      compressorRunTime1: json['compressorRunTime1'],
      compressorRunTime2: json['compressorRunTime2'],
      t4Temp: json['t4Temp'],
      t3Temp: json['t3Temp'],
      t5Temp: json['t5Temp'],
      t6ATemp: json['t6ATemp'],
      t6BTemp: json['t6BTemp'],
      t8Temp: json['t8Temp'],
      tlTemp: json['tlTemp'],
      tg: json['tg'],
      radiatorTemp1: json['radiatorTemp1'],
      radiatorTemp2: json['radiatorTemp2'],
      t7C1Temp: json['t7C1Temp'],
      t7C2Temp: json['t7C2Temp'],
      t71Temp: json['t71Temp'],
      t72Temp: json['t72Temp'],
      superHeatTemp: json['superHeatTemp'],
      exva: json['exva'],
      exvb: json['exvb'],
      exvc: json['exvc'],
      eevd: json['eevd'],
      sv5: json['sv5'],
      sv6: json['sv6'],
      sv7: json['sv7'],
      sv8A: json['sv8A'],
      sv8B: json['sv8B'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'sn': sn,
      'outdoorHorse': outdoorHorse,
      'frequencyLimitingState': frequencyLimitingState,
      'windSpeed1': windSpeed1,
      'windSpeed2': windSpeed2,
      'externalACVoltage': externalACVoltage,
      'primaryCurrent': primaryCurrent,
      'outdoorBlockageRate': outdoorBlockageRate,
      'errorCode': errorCode,
      'sysIdx': sysIdx,
      'powerQuality': powerQuality,
      'version': version,
      'highPressure': highPressure,
      'lowPressure': lowPressure,
      'highPressureSaturationTemp': highPressureSaturationTemp,
      'lowPressureSaturationTemp': lowPressureSaturationTemp,
      'compressor1Frequency': compressor1Frequency,
      'compressor2Frequency': compressor2Frequency,
      'directVoltage1': directVoltage1,
      'directVoltage2': directVoltage2,
      'compressorElectric1': compressorElectric1,
      'compressorElectric2': compressorElectric2,
      'compressorRunTime1': compressorRunTime1,
      'compressorRunTime2': compressorRunTime2,
      't4Temp': t4Temp,
      't3Temp': t3Temp,
      't5Temp': t5Temp,
      't6ATemp': t6ATemp,
      't6BTemp': t6BTemp,
      't8Temp': t8Temp,
      'tlTemp': tlTemp,
      'tg': tg,
      'radiatorTemp1': radiatorTemp1,
      'radiatorTemp2': radiatorTemp2,
      't7C1Temp': t7C1Temp,
      't7C2Temp': t7C2Temp,
      't71Temp': t71Temp,
      't72Temp': t72Temp,
      'superHeatTemp': superHeatTemp,
      'exva': exva,
      'exvb': exvb,
      'exvc': exvc,
      'eevd': eevd,
      'sv5': sv5,
      'sv6': sv6,
      'sv7': sv7,
      'sv8A': sv8A,
      'sv8B': sv8B,
    };
  }

  static OutdoorEntity random() {
    final entity = OutdoorEntity();
    final random = Random();

    entity.address = random.nextInt(1000);
    entity.sn = 'SN${random.nextInt(100)}';
    entity.outdoorHorse = 'Horse${random.nextInt(10)}';
    entity.frequencyLimitingState = 'State${random.nextInt(5)}';
    entity.windSpeed1 = random.nextInt(10);
    entity.windSpeed2 = random.nextInt(10);
    entity.externalACVoltage = random.nextInt(100);
    entity.primaryCurrent = random.nextInt(100);
    entity.outdoorBlockageRate = random.nextInt(100);
    entity.errorCode = 'Error${random.nextInt(10)}';
    entity.sysIdx = 'Idx${random.nextInt(100)}';
    entity.powerQuality = random.nextInt(100);
    entity.version = 'Version${random.nextInt(10)}';
    entity.highPressure = random.nextDouble() * 10;
    entity.lowPressure = random.nextDouble() * 10;
    entity.highPressureSaturationTemp = random.nextDouble() * 10;
    entity.lowPressureSaturationTemp = random.nextDouble() * 10;
    entity.compressor1Frequency = random.nextInt(100);
    entity.compressor2Frequency = random.nextInt(100);
    entity.directVoltage1 = random.nextInt(100);
    entity.directVoltage2 = random.nextInt(100);
    entity.compressorElectric1 = random.nextInt(100);
    entity.compressorElectric2 = random.nextInt(100);
    entity.compressorRunTime1 = random.nextInt(100);
    entity.compressorRunTime2 = random.nextInt(100);
    entity.t4Temp = random.nextDouble() * 10;
    entity.t3Temp = random.nextDouble() * 10;
    entity.t5Temp = random.nextDouble() * 10;
    entity.t6ATemp = random.nextDouble() * 10;
    entity.t6BTemp = random.nextDouble() * 10;
    entity.t8Temp = random.nextDouble() * 10;
    entity.tlTemp = random.nextDouble() * 10;
    entity.tg = random.nextDouble() * 10;
    entity.radiatorTemp1 = random.nextInt(100);
    entity.radiatorTemp2 = random.nextInt(100);
    entity.t7C1Temp = random.nextInt(100);
    entity.t7C2Temp = random.nextInt(100);
    entity.t71Temp = random.nextDouble() * 10;
    entity.t72Temp = random.nextDouble() * 10;
    entity.superHeatTemp = random.nextInt(100);
    entity.exva = random.nextInt(100);
    entity.exvb = random.nextInt(100);
    entity.exvc = random.nextInt(100);
    entity.eevd = random.nextInt(100);
    entity.sv5 = 'SV5-${random.nextInt(10)}';
    entity.sv6 = 'SV6-${random.nextInt(10)}';
    entity.sv7 = 'SV7-${random.nextInt(10)}';
    entity.sv8A = 'SV8A-${random.nextInt(10)}';
    entity.sv8B = 'SV8B-${random.nextInt(10)}';

    return entity;
  }
}
