import 'dart:convert';
import 'dart:math';

class SystemEntity {
  String? masterSn;
  List<String>? salveSnList;
  int? systemIndoorNum;
  String? protocol;
  String? mode;
  int? settingIndoorNum;
  int? checkIndoorNum;
  int? workingIndoorNum;
  bool? isAllV8Indoor;
  String? linkSetting;
  double? indoorAvgTem;
  double? systemEvaTem;
  double? systemConTem;
  double? tcMax;
  double? teMin;
  String? trafficUsage;
  double? outdoor0Power;
  String? silentMode;
  String? powerLimit;
  String? mpc;
  String? priorModeSetting;

  SystemEntity({
    this.masterSn,
    this.salveSnList,
    this.systemIndoorNum,
    this.protocol,
    this.mode,
    this.settingIndoorNum,
    this.checkIndoorNum,
    this.workingIndoorNum,
    this.isAllV8Indoor,
    this.linkSetting,
    this.indoorAvgTem,
    this.systemEvaTem,
    this.systemConTem,
    this.tcMax,
    this.teMin,
    this.trafficUsage,
    this.outdoor0Power,
    this.silentMode,
    this.powerLimit,
    this.mpc,
    this.priorModeSetting,
  });

  factory SystemEntity.fromJson(String jsonString) {
    final jsonData = json.decode(jsonString);
    return SystemEntity(
      masterSn: jsonData['masterSn'],
      salveSnList: jsonData['salveSnList'] != null
          ? List<String>.from(jsonData['salveSnList'])
          : null,
      systemIndoorNum: jsonData['systemIndoorNum'],
      protocol: jsonData['protocol'],
      mode: jsonData['mode'],
      settingIndoorNum: jsonData['settingIndoorNum'],
      checkIndoorNum: jsonData['checkIndoorNum'],
      workingIndoorNum: jsonData['workingIndoorNum'],
      isAllV8Indoor: jsonData['isAllV8Indoor'],
      linkSetting: jsonData['linkSetting'],
      indoorAvgTem: jsonData['indoorAvgTem'],
      systemEvaTem: jsonData['systemEvaTem'],
      systemConTem: jsonData['systemConTem'],
      tcMax: jsonData['tcMax'],
      teMin: jsonData['teMin'],
      trafficUsage: jsonData['trafficUsage'],
      outdoor0Power: jsonData['outdoor0Power'],
      silentMode: jsonData['silentMode'],
      powerLimit: jsonData['powerLimit'],
      mpc: jsonData['mpc'],
      priorModeSetting: jsonData['priorModeSetting'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['masterSn'] = masterSn;
    data['salveSnList'] = salveSnList;
    data['systemIndoorNum'] = systemIndoorNum;
    data['protocol'] = protocol;
    data['mode'] = mode;
    data['settingIndoorNum'] = settingIndoorNum;
    data['checkIndoorNum'] = checkIndoorNum;
    data['workingIndoorNum'] = workingIndoorNum;
    data['isAllV8Indoor'] = isAllV8Indoor;
    data['linkSetting'] = linkSetting;
    data['indoorAvgTem'] = indoorAvgTem;
    data['systemEvaTem'] = systemEvaTem;
    data['systemConTem'] = systemConTem;
    data['tcMax'] = tcMax;
    data['teMin'] = teMin;
    data['trafficUsage'] = trafficUsage;
    data['outdoor0Power'] = outdoor0Power;
    data['silentMode'] = silentMode;
    data['powerLimit'] = powerLimit;
    data['mpc'] = mpc;
    data['priorModeSetting'] = priorModeSetting;
    return data;
  }

  bool isEmpty() {
    return masterSn == null &&
        salveSnList == null &&
        systemIndoorNum == null &&
        protocol == null &&
        mode == null &&
        settingIndoorNum == null &&
        checkIndoorNum == null &&
        workingIndoorNum == null &&
        isAllV8Indoor == null &&
        linkSetting == null &&
        indoorAvgTem == null &&
        systemEvaTem == null &&
        systemConTem == null &&
        tcMax == null &&
        teMin == null &&
        trafficUsage == null &&
        outdoor0Power == null &&
        silentMode == null &&
        powerLimit == null &&
        mpc == null &&
        priorModeSetting == null;
  }

    static SystemEntity random() {
    final random = Random();

    return SystemEntity(
      masterSn: 'MASTER-${random.nextInt(1000)}',
      salveSnList: List.generate(
        random.nextInt(4),
        (index) => 'SALVE-${random.nextInt(1000)}',
      ),
      systemIndoorNum: random.nextInt(10),
      protocol: 'Protocol-${random.nextInt(5)}',
      mode: 'Mode-${random.nextInt(3)}',
      settingIndoorNum: random.nextInt(10),
      checkIndoorNum: random.nextInt(10),
      workingIndoorNum: random.nextInt(10),
      isAllV8Indoor: random.nextBool(),
      linkSetting: 'Link Setting-${random.nextInt(3)}',
      indoorAvgTem: random.nextDouble() * 30,
      systemEvaTem: random.nextDouble() * 30,
      systemConTem: random.nextDouble() * 30,
      tcMax: random.nextDouble() * 30,
      teMin: random.nextDouble() * 30,
      trafficUsage: 'Traffic Usage-${random.nextInt(3)}',
      outdoor0Power: random.nextDouble() * 1000,
      silentMode: 'Silent Mode-${random.nextInt(3)}',
      powerLimit: 'Power Limit-${random.nextInt(3)}',
      mpc: 'MPC-${random.nextInt(3)}',
      priorModeSetting: 'Prior Mode Setting-${random.nextInt(3)}',
    );
  }
}
