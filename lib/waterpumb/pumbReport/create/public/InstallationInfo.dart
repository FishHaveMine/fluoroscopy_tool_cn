import 'package:flutter/foundation.dart';

class selectItem {
  String label;
  String val;

  selectItem({
    required this.label,
    required this.val,
  });
}

enum FormItemType { input, time, select, radio, number, textarea, image }

class FormItem {
  bool required;
  String label;
  String val;
  FormItemType type;
  String unit;
  List<selectItem>? op = [
    selectItem(label: "有", val: "有"),
    selectItem(label: "无", val: "无")
  ];

  FormItem({
    required this.required,
    required this.label,
    this.val = '',
    this.unit = '',
    this.op,
    this.type = FormItemType.input,
  }) {
    // 如果 op 没有传入且类型是 radio，则使用默认 ['有', '无']
    if (op == null && type == FormItemType.radio) {
      op = [
        selectItem(label: "有", val: "有"),
        selectItem(label: "无", val: "无"),
      ];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'required': required,
      'label': label,
      'val': val,
      'type': typeString,
      'unit': unit,
    };
  }

  // 添加类型转换方法，方便JSON序列化
  String get typeString {
    switch (type) {
      case FormItemType.input:
        return 'input';
      case FormItemType.time:
        return 'time';
      case FormItemType.select:
        return 'select';
      case FormItemType.radio:
        return 'radio';
      case FormItemType.number:
        return 'number';
      case FormItemType.textarea:
        return 'textarea';
      case FormItemType.image:
        return 'image';
    }
  }

  // 从字符串创建 FormItemType
  static FormItemType typeFromString(String? typeStr) {
    switch (typeStr?.toLowerCase()) {
      case 'time':
        return FormItemType.time;
      case 'select':
        return FormItemType.select;
      case 'radio':
        return FormItemType.radio;
      case 'number':
        return FormItemType.number;
      case 'textarea':
        return FormItemType.textarea;
      default:
        return FormItemType.input;
    }
  }
}

List<selectItem> normal_op = [
  selectItem(label: "正常", val: "正常"),
  selectItem(label: "异常", val: "异常")
];

List<selectItem> pumpFormOptions = [
  selectItem(label: "并联", val: "并联"),
  selectItem(label: "一对一", val: "一对一")
];

List<selectItem> towerFormOptions = [
  selectItem(label: "开式", val: "开式"),
  selectItem(label: "闭式", val: "闭式")
];

List<selectItem> yesnoOptions = [
  selectItem(label: "是", val: "是"),
  selectItem(label: "否", val: "否")
];

class InstallationInfo {
  final Map<String, FormItem> fields;

  InstallationInfo({required this.fields});

  FormItem operator [](String key) => fields[key]!;

  factory InstallationInfo.fromJson(
    var json, {
    bool isPreSetByKey = kDebugMode,
  }) {
    print("json ($isPreSetByKey) ------- : $json");
    Map<String, FormItem> formFields = {
      /** -------- 固定的基本信息 ------------*/
      'customerName': FormItem(
          required: true, label: '客户名称', val: json['customerName'] ?? ''),
      'customerPhone': FormItem(
          type: FormItemType.number,
          required: true,
          label: '客户电话',
          val: json['customerPhone'] ?? ''),
      'installationAddress': FormItem(
          required: true,
          label: '安装地址',
          val: json['installationAddress'] ?? ''),

      'projectLocal': FormItem(
          required: true, label: '项目地址', val: json['projectLocal'] ?? ''),

      'branchName':
          FormItem(required: true, label: '分中心', val: json['branchName'] ?? ''),
      'branchCode': FormItem(
          required: true, label: '分中心code', val: json['branchCode'] ?? ''),

      'reportTime':
          FormItem(required: true, label: '报告期', val: json['reportTime'] ?? ''),
      'productCode': FormItem(
          required: true, label: '产品编号', val: json['productCode'] ?? ''),
      'unitModel':
          FormItem(required: true, label: '机组型号', val: json['unitModel'] ?? ''),
      'controlProgramVersion': FormItem(
          required: true,
          label: '控制程序版本',
          val: json['controlProgramVersion'] ?? ''),
      'touchscreenProgramVersion': FormItem(
          required: false,
          label: '触摸屏程序版本',
          val: json['touchscreenProgramVersion'] ?? ''),
      'expansionValveControllerVersion': FormItem(
          required: false,
          label: '膨胀阀控制器版本',
          val: json['expansionValveControllerVersion'] ?? ''),
      'productSn': FormItem(
          required: true, label: '产品序列号', val: json['productSn'] ?? ''),
      'powerSupply':
          FormItem(required: true, label: '电源', val: json['powerSupply'] ?? ''),
      'factoryTime': FormItem(
          required: true,
          label: '出厂时间',
          val: json['factoryTime'] ?? '',
          type: FormItemType.time),
      'debugTime': FormItem(
          required: true,
          label: '调试时间',
          val: json['debugTime'] ?? '',
          type: FormItemType.time),
      'projectCode': FormItem(
          required: true, label: '项目编码', val: json['projectCode'] ?? ''),
      'projectName': FormItem(
          required: true, label: '项目名称', val: json['projectName'] ?? ''),
      'projectId':
          FormItem(required: true, label: '项目名称', val: json['projectId'] ?? ''),
      'debugModel': FormItem(
          required: true,
          label: '调试机型',
          type: FormItemType.select,
          op: [
            selectItem(label: "离心机组", val: "离心机组"),
            selectItem(label: "磁悬浮冷水机组", val: "磁悬浮冷水机组"),
            // selectItem(label: "风冷涡旋机组", val: "风冷涡旋机组"),
            // selectItem(label: "水冷涡旋机组", val: "水冷涡旋机组"),
            selectItem(label: "水冷螺杆机组", val: "水冷螺杆机组"),
            // selectItem(label: "风冷螺杆机组", val: "风冷螺杆机组")
          ],
          val: json['debugModel'] ?? '磁悬浮冷水机组'),
      /** -------- 固定的基本信息 ------------*/

      /** -------- 表格内容 ------------*/
      'unitAppearanceDamage': FormItem(
          required: true,
          label: '机组外观是否有损坏',
          val: json['unitAppearanceDamage'] ?? '',
          type: FormItemType.radio),
      'partsDamage': FormItem(
          required: true,
          label: '是否有零部件损坏',
          val: json['partsDamage'] ?? '',
          type: FormItemType.radio),
      'insulationDamage': FormItem(
          required: true,
          label: '是否存在保温破损',
          val: json['insulationDamage'] ?? '',
          type: FormItemType.radio),
      'other': FormItem(required: true, label: '其它', val: json['other'] ?? ''),
      'isSeparateWiring': FormItem(
          required: true,
          label: '强弱电是否分开布线',
          val: json['isSeparateWiring'] ?? '',
          type: FormItemType.radio),
      'isCabinetCleanedMicro': FormItem(
          required: true,
          label: '微机控制柜内部是否清扫',
          val: json['isCabinetCleanedMicro'] ?? '',
          type: FormItemType.radio),
      'isCabinetCleanedStart': FormItem(
          required: true,
          label: '启动柜内部是否清扫',
          val: json['isCabinetCleanedStart'] ?? '',
          type: FormItemType.radio),
      'isWiringCompliant': FormItem(
          required: true,
          label: '控制接线是否符合接线图',
          val: json['isWiringCompliant'] ?? '',
          type: FormItemType.radio),
      'controlPowerConnectionStatus': FormItem(
          required: true,
          label: '控制电源配线连接状态',
          val: json['controlPowerConnectionStatus'] ?? '',
          type: FormItemType.radio,
          op: normal_op),
      'relayStatus': FormItem(
          required: true,
          label: '继电器状态',
          val: json['relayStatus'] ?? '',
          type: FormItemType.radio,
          op: normal_op),
      'contactorStatus': FormItem(
          required: true,
          label: '接触器状态',
          val: json['contactorStatus'] ?? '',
          type: FormItemType.radio,
          op: normal_op),
      'powerWiringStatus': FormItem(
          required: true,
          label: '电源接线合规且无松动',
          val: json['powerWiringStatus'] ?? '',
          type: FormItemType.radio,
          op: normal_op),
      'startCabinetGroundingStatus': FormItem(
          required: true,
          label: '启动柜接地状态是否正常',
          val: json['startCabinetGroundingStatus'] ?? '',
          type: FormItemType.radio,
          op: normal_op),

      // 添加“压缩机状态检查 - 低压机组点击绝缘电阻”
      'lowVoltageInsulationResistance': FormItem(
          required: true,
          label: '低压机组点击绝缘电阻',
          type: FormItemType.number,
          val: json['lowVoltageInsulationResistance'] ?? ''),
      // 添加“压缩机状态检查 - 导页手动开关零位至满位”
      'guidePageSwitchStatus': FormItem(
          required: true,
          label: '导页手动开关零位至满位',
          val: json['guidePageSwitchStatus'] ?? '',
          type: FormItemType.radio,
          op: normal_op),
      // 添加“氟系统检查 - 出厂状态”
      'factoryStatus': FormItem(
          required: true,
          label: '出厂状态',
          val: json['factoryStatus'] ?? '',
          type: FormItemType.radio,
          op: [
            selectItem(label: "带氟出厂", val: "带氟出厂"),
            selectItem(label: "不带氟出厂", val: "不带氟出厂")
          ]),
      // 添加“氟系统检查 - 不带氟出厂机组，气密性试验”
      'airTightnessTestStatus': FormItem(
          required: false,
          label: '不带氟出厂机组，气密性试验',
          val: json['airTightnessTestStatus'] ?? '',
          type: FormItemType.radio,
          op: normal_op),
      // 添加“氟系统检查 - 保压前（气密性试验）”
      'prePressureHoldingAirTightness': FormItem(
          required: false,
          label: '保压前（气密性试验）',
          type: FormItemType.number,
          unit: 'MPa',
          val: json['prePressureHoldingAirTightness'] ?? ''),
      // 添加“氟系统检查 - 保压后（气密性试验）”
      'postPressureHoldingAirTightness': FormItem(
          required: false,
          label: '保压后（气密性试验）',
          type: FormItemType.number,
          unit: 'MPa',
          val: json['postPressureHoldingAirTightness'] ?? ''),
      // 添加“氟系统检查 - 不带氟出厂机组，真空试验”
      'vacuumTestStatus': FormItem(
          required: false,
          label: '不带氟出厂机组，真空试验',
          val: json['vacuumTestStatus'] ?? '',
          type: FormItemType.radio,
          op: normal_op),
      // 添加“氟系统检查 - 保压前（真空试验）”
      'prePressureHoldingVacuum': FormItem(
          required: false,
          label: '保压前（真空试验）',
          type: FormItemType.number,
          unit: 'MPa',
          val: json['prePressureHoldingVacuum'] ?? ''),
      // 添加“氟系统检查 - 保压后（真空试验）”
      'postPressureHoldingVacuum': FormItem(
          required: false,
          label: '保压后（真空试验）',
          type: FormItemType.number,
          unit: 'MPa',
          val: json['postPressureHoldingVacuum'] ?? ''),
      // 添加“氟系统检查 - 冷媒充注量（R134a）”
      'refrigerantChargeAmount': FormItem(
          required: true,
          label: '冷媒充注量（R134a）',
          type: FormItemType.number,
          unit: 'kg',
          val: json['refrigerantChargeAmount'] ?? ''),

      'refrigerantChargeAmountRadio': FormItem(
          required: false,
          label: '',
          unit: '',
          type: FormItemType.radio,
          val: json['refrigerantChargeAmountRadio'] ?? '',
          op: [selectItem(label: "带氟出厂", val: "带氟出厂")]),
      // 添加“氟系统检查 - 单点漏率”
      'singlePointLeakRate': FormItem(
          required: true,
          label: '单点漏率',
          type: FormItemType.number,
          unit: 'g/年',
          val: json['singlePointLeakRate'] ?? ''),

      'isImpurityInContainer': FormItem(
          required: true,
          label: '管路清洗是否有杂质进入容器',
          val: json['isImpurityInContainer'] ?? '',
          type: FormItemType.radio,
          op: yesnoOptions),
      // 添加“水系统检查 - 用户流量保护装置类别”
      'flowProtectionType': FormItem(
          required: true,
          label: '用户流量保护装置类别',
          val: json['flowProtectionType'] ?? '',
          type: FormItemType.radio,
          op: [
            selectItem(label: "靶流", val: "靶流"),
            selectItem(label: "压差", val: "压差")
          ]),
      // 添加“水系统检查 - 冷却侧动作是否正常”
      'coolingSideStatus': FormItem(
          required: true,
          label: '冷却侧动作是否正常',
          val: json['coolingSideStatus'] ?? '',
          type: FormItemType.radio,
          op: normal_op),
      // 添加“水系统检查 - 冷冻侧动作是否正常”
      'freezingSideStatus': FormItem(
          required: true,
          label: '冷冻侧动作是否正常',
          val: json['freezingSideStatus'] ?? '',
          type: FormItemType.radio,
          op: normal_op),

      // 冷冻水泵属性
      'chilledWaterPumpForm': FormItem(
          required: false,
          label: '冷冻水泵形式',
          val: json['chilledWaterPumpForm'] ?? '',
          type: FormItemType.radio,
          op: pumpFormOptions // 假设这是预定义的选项列表
          ),
      'chilledWaterPumpFlow': FormItem(
          required: false,
          label: '冷冻水泵流量(m³/h)',
          val: json['chilledWaterPumpFlow'] ?? '',
          type: FormItemType.number // 假设添加了数字类型
          ),
      'chilledWaterPumpHead': FormItem(
          required: false,
          label: '冷冻水泵扬程(m)',
          val: json['chilledWaterPumpHead'] ?? '',
          type: FormItemType.number),

      // 冷却水泵属性
      'coolingWaterPumpForm': FormItem(
          required: false,
          label: '冷却水泵形式',
          val: json['coolingWaterPumpForm'] ?? '',
          type: FormItemType.radio,
          op: pumpFormOptions),
      'coolingWaterPumpFlow': FormItem(
          required: false,
          label: '冷却水泵流量(m³/h)',
          val: json['coolingWaterPumpFlow'] ?? '',
          type: FormItemType.number),
      'coolingWaterPumpHead': FormItem(
          required: false,
          label: '冷却水泵扬程(m)',
          val: json['coolingWaterPumpHead'] ?? '',
          type: FormItemType.number),

      // 冷却塔属性
      'coolingTowerForm': FormItem(
          required: false,
          label: '冷却塔形式',
          val: json['coolingTowerForm'] ?? '',
          type: FormItemType.radio,
          op: towerFormOptions // 假设这是预定义的选项列表
          ),
      'coolingTowerFlow': FormItem(
          required: false,
          label: '冷却塔流量(m³/h)',
          val: json['coolingTowerFlow'] ?? '',
          type: FormItemType.number),
      'coolingTowerHead': FormItem(
          required: false,
          label: '冷却塔扬程(m)',
          val: json['coolingTowerHead'] ?? '',
          type: FormItemType.number),

      // 冷冻水水质检查
      'chilledWaterPH': FormItem(
        required: true,
        label: '冷冻水PH值',
        val: json['chilledWaterPH'] ?? '',
        type: FormItemType.number,
      ),
      'chilledWaterConductivity': FormItem(
          required: true,
          label: '冷冻水电导率(μS/cm)',
          val: json['chilledWaterConductivity'] ?? '',
          type: FormItemType.number),
      'isChilledWaterClear': FormItem(
          required: true,
          label: '冷冻水是否清澈',
          val: json['isChilledWaterClear'] ?? '',
          type: FormItemType.radio,
          op: yesnoOptions),

      // 冷却水水质检查
      'coolingWaterPH': FormItem(
        required: true,
        label: '冷却水PH值',
        val: json['coolingWaterPH'] ?? '',
        type: FormItemType.number,
      ),
      'coolingWaterConductivity': FormItem(
          required: true,
          label: '冷却水电导率(μS/cm)',
          val: json['coolingWaterConductivity'] ?? '',
          type: FormItemType.number),
      'isCoolingWaterClear': FormItem(
          required: true,
          label: '冷却水是否清澈',
          val: json['isCoolingWaterClear'] ?? '',
          type: FormItemType.radio,
          op: yesnoOptions),

      // 蒸发压力过低报警
      'evaporationPressureLowAlarm': FormItem(
          required: true,
          label: '蒸发压力过低报警',
          val: json['evaporationPressureLowAlarm'] ?? '',
          op: normal_op,
          type: FormItemType.radio),
      // 冷凝压力过高报警
      'condensationPressureHighAlarm': FormItem(
          required: true,
          label: '冷凝压力过高报警',
          op: normal_op,
          val: json['condensationPressureHighAlarm'] ?? '',
          type: FormItemType.radio),
      // 点击绕组温度过高报警
      'windingTemperatureHighAlarm': FormItem(
          required: true,
          label: '点击绕组温度过高报警',
          op: normal_op,
          val: json['windingTemperatureHighAlarm'] ?? '',
          type: FormItemType.radio),
      // 启动时间过长报警
      'startupTimeExceedAlarm': FormItem(
          required: true,
          label: '启动时间过长报警',
          op: normal_op,
          val: json['startupTimeExceedAlarm'] ?? '',
          type: FormItemType.radio),
      // 网关类型
      'gatewayType': FormItem(
          required: true,
          label: '网关类型',
          op: [
            selectItem(label: '普通网关', val: '普通网关'),
            selectItem(label: '水机博士', val: '水机博士')
          ],
          val: json['gatewayType'] ?? '',
          type: FormItemType.radio),
      // 网络状态
      'networkStatus': FormItem(
          required: true,
          label: '网络状态',
          val: json['networkStatus'] ?? '',
          op: [
            selectItem(label: '信号强', val: '信号强'),
            selectItem(label: '信号弱/无信号', val: '信号弱/无信号')
          ],
          type: FormItemType.radio),
      // 网关固定版本
      'gatewayFixedVersion': FormItem(
          required: true,
          label: '网关固定版本',
          val: json['gatewayFixedVersion'] ?? ''),

      // “设定参数与出厂参数是否一致”
      'isSetParamsSameAsFactory': FormItem(
          required: true,
          label: '设定参数与出厂参数是否一致',
          val: json['isSetParamsSameAsFactory'] ?? '',
          op: yesnoOptions,
          type: FormItemType.radio),
      'specificParams': FormItem(
        required: false,
        label: '具体差异',
        val: json['specificParams'] ?? '',
      ),
      // 用户参数设置部分
      'waterControl': FormItem(
          required: true,
          label: '进出水控制',
          val: json['waterControl'] ?? '',
          op: [
            selectItem(label: '进水控制', val: '进水控制'),
            selectItem(label: '出水控制', val: '出水控制')
          ],
          type: FormItemType.radio),
      'coolingHeatingTargetTemp': FormItem(
          required: true,
          label: '制冷/制热目标温度',
          unit: '°C',
          val: json['coolingHeatingTargetTemp'] ?? '',
          type: FormItemType.number),
      'evaporatorActualControlTemp': FormItem(
          required: true,
          label: '蒸发器实际控制温度',
          unit: '°C',
          val: json['evaporatorActualControlTemp'] ?? '',
          type: FormItemType.number),
      'exitPauseTempDiff': FormItem(
          required: true,
          label: '退出暂停温差',
          unit: '°C',
          val: json['exitPauseTempDiff'] ?? '',
          type: FormItemType.number),
      'enterPauseTempDiff': FormItem(
          required: true,
          label: '进入暂停温差',
          unit: '°C',
          val: json['enterPauseTempDiff'] ?? '',
          type: FormItemType.number),
      'capacityAdjustmentKeepTempDiff': FormItem(
          required: true,
          label: '容量调节保持温差',
          unit: '°C',
          val: json['capacityAdjustmentKeepTempDiff'] ?? '',
          type: FormItemType.number),
      'coolingTowerFanAdjustTempDiff': FormItem(
          required: true,
          label: '冷却塔风机调节温差',
          unit: '°C',
          val: json['coolingTowerFanAdjustTempDiff'] ?? '',
          type: FormItemType.number),
      'coolingTowerFanUnit1ShutdownTemperature': FormItem(
          required: true,
          label: '冷却塔风机组1关闭温度',
          unit: '°C',
          val: json['coolingTowerFanUnit1ShutdownTemperature'] ?? '',
          type: FormItemType.number),

      'coolingTowerFanUnit1OpeningTemperature': FormItem(
          required: true,
          label: '冷却塔风机组1开启温度',
          unit: '°C',
          val: json['coolingTowerFanUnit1OpeningTemperature'] ?? '',
          type: FormItemType.number),
      'coolingTowerFanUnit2ShutdownTemperature': FormItem(
          required: true,
          label: '冷却塔风机组2关闭温度',
          unit: '°C',
          val: json['coolingTowerFanUnit2ShutdownTemperature'] ?? '',
          type: FormItemType.number),
      'coolingTowerFanUnit2OpeningTemperature': FormItem(
          required: true,
          label: '冷却塔风机组2开启温度',
          unit: '°C',
          val: json['coolingTowerFanUnit2OpeningTemperature'] ?? '',
          type: FormItemType.number),
      // 串口设置部分
      'baudRate': FormItem(
          required: true,
          label: '波特率',
          val: json['baudRate'] ?? '',
          op: [
            selectItem(label: '9600', val: '9600'),
            selectItem(label: '19200', val: '19200'),
            selectItem(label: '115200', val: '115200'),
          ],
          type: FormItemType.radio),
      'stationAddress': FormItem(
        required: false,
        label: '站号地址',
        val: json['stationAddress'] ?? '',
      ),
      'parityBit': FormItem(
        required: false,
        label: '校验位',
        val: json['parityBit'] ?? '',
      ),
      'exitPauseTemperatureDifference': FormItem(
          required: true,
          label: '退出暂停温差',
          unit: '°C',
          val: json['exitPauseTemperatureDifference'] ?? '',
          type: FormItemType.number),
      'enterPauseTemperatureDifference': FormItem(
          required: true,
          label: '进入暂停温差',
          unit: '°C',
          val: json['enterPauseTemperatureDifference'] ?? '',
          type: FormItemType.number),
      // 模式设置 - 控制模式
      'controlMode': FormItem(
          required: true,
          label: '控制模式',
          op: [
            selectItem(label: '就地', val: '就地'),
            selectItem(label: '远程', val: '远程'),
            selectItem(label: '定时', val: '定时'),
            selectItem(label: 'BMS', val: 'BMS'),
          ],
          val: json['controlMode'] ?? '',
          type: FormItemType.radio),
      // 模式设置 - 运行模式
      'operationMode': FormItem(
          required: true,
          label: '运行模式',
          op: [
            selectItem(label: "制冷", val: "制冷"),
            selectItem(label: "制热", val: "制热"),
            selectItem(label: "水泵", val: "水泵"),
          ],
          val: json['operationMode'] ?? '',
          type: FormItemType.radio),
      // 常规设置
      'ratedCurrent': FormItem(
          required: true,
          label: '主机额定电流',
          unit: "A",
          val: json['ratedCurrent'] ?? '',
          type: FormItemType.number),
      'ratedFrequency': FormItem(
          required: true,
          label: '额定频率',
          unit: "Hz",
          val: json['ratedFrequency'] ?? '',
          type: FormItemType.number),
      'currentTransmitterRange': FormItem(
          required: true,
          label: '电流变送器范围',
          unit: "A",
          val: json['currentTransmitterRange'] ?? '',
          type: FormItemType.number),
      'pressureSensorUpperLimit': FormItem(
          required: true,
          label: '压力传感器上限设置',
          unit: 'kPa',
          val: json['pressureSensorUpperLimit'] ?? '',
          type: FormItemType.number),
      'evaporatorTargetLiquidLevel': FormItem(
          required: true,
          label: '蒸发器目标液位',
          unit: 'mm',
          val: json['evaporatorTargetLiquidLevel'] ?? '',
          type: FormItemType.number),
      'coolingFullLoadPower': FormItem(
          required: true,
          label: '制冷满载功率',
          unit: 'kW',
          val: json['coolingFullLoadPower'] ?? '',
          type: FormItemType.number),
      'iceStorageFullLoadPower': FormItem(
          required: true,
          label: '蓄冰满载功率',
          unit: 'kW',
          val: json['iceStorageFullLoadPower'] ?? '',
          type: FormItemType.number),
      'compressorShutdownInterval': FormItem(
          required: false,
          label: '压缩机停机间隔',
          unit: 'S',
          val: json['compressorShutdownInterval'] ?? '',
          type: FormItemType.number),
      'startupInterval': FormItem(
          required: false,
          label: '启动间隔',
          unit: 'S',
          val: json['startupInterval'] ?? '',
          type: FormItemType.number),
      'quickStartSignalDelay': FormItem(
          required: false,
          label: '快速启动备妥信号判断延时',
          unit: 'S',
          val: json['quickStartSignalDelay'] ?? '',
          type: FormItemType.number),
      // 变频器
      'inverter1SoftwareVersion': FormItem(
        required: true,
        label: '1#主控软件版本',
        val: json['inverter1SoftwareVersion'] ?? '',
      ),
      'inverter2SoftwareVersion': FormItem(
        required: false,
        label: '2#主控软件版本',
        val: json['inverter2SoftwareVersion'] ?? '',
      ),
      'inverter3SoftwareVersion': FormItem(
        required: false,
        label: '3#主控软件版本',
        val: json['inverter3SoftwareVersion'] ?? '',
      ),
      // 1#压缩机版本
      'compressor1Version': FormItem(
        required: true,
        label: '1#压缩机版本',
        val: json['compressor1Version'] ?? '',
      ),
      // 1#磁悬浮版本
      'maglev1Version': FormItem(
        required: true,
        label: '1#磁悬浮版本',
        val: json['maglev1Version'] ?? '',
      ),
      // 2#压缩机版本
      'compressor2Version': FormItem(
        required: false,
        label: '2#压缩机版本',
        val: json['compressor2Version'] ?? '',
      ),
      // 2#磁悬浮版本
      'maglev2Version': FormItem(
        required: false,
        label: '2#磁悬浮版本',
        val: json['maglev2Version'] ?? '',
      ),
      // 3#压缩机版本
      'compressor3Version': FormItem(
        required: false,
        label: '3#压缩机版本',
        val: json['compressor3Version'] ?? '',
      ),
      // 3#磁悬浮版本
      'maglev3Version': FormItem(
        required: false,
        label: '3#磁悬浮版本',
        val: json['maglev3Version'] ?? '',
      ),

      // 1#机头磁悬浮参数
      'compressor1AZ': FormItem(
          required: true,
          label: '1#机头 AZ (μm)',
          val: json['compressor1AZ'] ?? '',
          type: FormItemType.number),
      'compressor1FX': FormItem(
          required: true,
          label: '1#机头 FX (μm)',
          val: json['compressor1FX'] ?? '',
          type: FormItemType.number),
      'compressor1FY': FormItem(
          required: true,
          label: '1#机头 FY (μm)',
          val: json['compressor1FY'] ?? '',
          type: FormItemType.number),
      'compressor1RX': FormItem(
          required: true,
          label: '1#机头 RX (μm)',
          val: json['compressor1RX'] ?? '',
          type: FormItemType.number),
      'compressor1RY': FormItem(
          required: true,
          label: '1#机头 RY (μm)',
          val: json['compressor1RY'] ?? '',
          type: FormItemType.number),

      // 2#机头磁悬浮参数
      'compressor2AZ': FormItem(
          required: false,
          label: '2#机头 AZ (μm)',
          val: json['compressor2AZ'] ?? '',
          type: FormItemType.number),
      'compressor2FX': FormItem(
          required: false,
          label: '2#机头 FX (μm)',
          val: json['compressor2FX'] ?? '',
          type: FormItemType.number),
      'compressor2FY': FormItem(
          required: false,
          label: '2#机头 FY (μm)',
          val: json['compressor2FY'] ?? '',
          type: FormItemType.number),
      'compressor2RX': FormItem(
          required: false,
          label: '2#机头 RX (μm)',
          val: json['compressor2RX'] ?? '',
          type: FormItemType.number),
      'compressor2RY': FormItem(
          required: false,
          label: '2#机头 RY (μm)',
          val: json['compressor2RY'] ?? '',
          type: FormItemType.number),

      // 3#机头磁悬浮参数
      'compressor3AZ': FormItem(
          required: false,
          label: '3#机头 AZ (μm)',
          val: json['compressor3AZ'] ?? '',
          type: FormItemType.number),
      'compressor3FX': FormItem(
          required: false,
          label: '3#机头 FX (μm)',
          val: json['compressor3FX'] ?? '',
          type: FormItemType.number),
      'compressor3FY': FormItem(
          required: false,
          label: '3#机头 FY (μm)',
          val: json['compressor3FY'] ?? '',
          type: FormItemType.number),
      'compressor3RX': FormItem(
          required: false,
          label: '3#机头 RX (μm)',
          val: json['compressor3RX'] ?? '',
          type: FormItemType.number),
      'compressor3RY': FormItem(
          required: false,
          label: '3#机头 RY (μm)',
          val: json['compressor3RY'] ?? '',
          type: FormItemType.number),
/** -------- 表格内容 ------------*/

/** -------- 机组运行数据记录表内容 ------------*/
      ...List.generate(6, (index) {
        final int i = index + 1;
        return <String, FormItem>{
          'logTime$i': FormItem(
              required: true,
              label: '记录时间$i',
              val: json['logTime$i'] ?? '',
              type: FormItemType.time),
          // 冷冻水入口温度
          'chilledWaterInletTemp$i': FormItem(
              required: true,
              label: '冷冻水入口温度',
              unit: '°C',
              val: json['chilledWaterInletTemp$i'] ?? '',
              type: FormItemType.number),
          // 冷冻水出口温度
          'chilledWaterOutletTemp$i': FormItem(
              required: true,
              label: '冷冻水出口温度',
              unit: '°C',
              val: json['chilledWaterOutletTemp$i'] ?? '',
              type: FormItemType.number),
          // 冷却水入口温度
          'coolingWaterInletTemp$i': FormItem(
              required: true,
              label: '冷却水入口温度',
              unit: '°C',
              val: json['coolingWaterInletTemp$i'] ?? '',
              type: FormItemType.number),
          // 冷却水出口温度
          'coolingWaterOutletTemp$i': FormItem(
              required: true,
              label: '冷却水出口温度',
              unit: '°C',
              val: json['coolingWaterOutletTemp$i'] ?? '',
              type: FormItemType.number),
          // 蒸发器蒸发压力
          'evaporatorEvaporationPressure$i': FormItem(
              required: true,
              label: '蒸发器蒸发压力',
              unit: 'kPa',
              val: json['evaporatorEvaporationPressure$i'] ?? '',
              type: FormItemType.number),
          // 蒸发器饱和温度
          'evaporatorSaturationTemp$i': FormItem(
              required: true,
              label: '蒸发器饱和温度',
              unit: '°C',
              val: json['evaporatorSaturationTemp$i'] ?? '',
              type: FormItemType.number),
          // 蒸发器端温差
          'evaporatorTerminalTempDiff$i': FormItem(
              required: true,
              label: '蒸发器端温差',
              unit: '°C',
              val: json['evaporatorTerminalTempDiff$i'] ?? '',
              type: FormItemType.number),
          // 冷凝器冷凝压力
          'condenserCondensationPressure$i': FormItem(
              required: true,
              label: '冷凝器冷凝压力',
              unit: 'kPa',
              val: json['condenserCondensationPressure$i'] ?? '',
              type: FormItemType.number),
          // 冷凝器饱和温度
          'condenserSaturationTemp$i': FormItem(
              required: true,
              label: '冷凝器饱和温度',
              unit: '°C',
              val: json['condenserSaturationTemp$i'] ?? '',
              type: FormItemType.number),
          // 冷凝器端温差
          'condenserTerminalTempDiff$i': FormItem(
              required: true,
              label: '冷凝器端温差',
              unit: '°C',
              val: json['condenserTerminalTempDiff$i'] ?? '',
              type: FormItemType.number),
          // 1#导叶开度（这里按顺序对应，实际可按需调整逻辑）
          'guideVane1Opening$i': FormItem(
              required: true,
              label: '1#导叶开度',
              unit: '%',
              val: json['guideVane1Opening$i'] ?? '',
              type: FormItemType.number),
          // 2#导叶开度
          'guideVane2Opening$i': FormItem(
              required: false,
              label: '2#导叶开度',
              unit: '%',
              val: json['guideVane2Opening$i'] ?? '',
              type: FormItemType.number),
          // 3#导叶开度
          'guideVane3Opening$i': FormItem(
              required: false,
              label: '3#导叶开度',
              unit: '%',
              val: json['guideVane3Opening$i'] ?? '',
              type: FormItemType.number),
          // 电流百分比
          'currentPercentage$i': FormItem(
              required: true,
              label: '电流百分比',
              unit: '%',
              val: json['currentPercentage$i'] ?? '',
              type: FormItemType.number),

          /** -------- 离心机组 -- 油系统参数 ------------*/
          'oilTankTemperature$i': FormItem(
            required: true,
            label: '油箱温度',
            type: FormItemType.number,
            unit: '℃',
            val: json['oilTankTemperature$i'] ?? '',
          ),

          'oilSupplyTemperature$i': FormItem(
            required: true,
            label: '供油温度',
            type: FormItemType.number,
            unit: '℃',
            val: json['oilSupplyTemperature$i'] ?? '',
          ),

          'oilTankPressure$i': FormItem(
            required: true,
            label: '油箱压力',
            type: FormItemType.number,
            unit: 'MPa',
            val: json['oilTankPressure$i'] ?? '',
          ),

          'oilSupplyPressure$i': FormItem(
            required: true,
            label: '供油压力',
            type: FormItemType.number,
            unit: 'MPa',
            val: json['oilSupplyPressure$i'] ?? '',
          ),

          'oilSupplyPressureDifference$i': FormItem(
            required: true,
            label: '供油压差',
            type: FormItemType.number,
            unit: 'MPa',
            val: json['oilSupplyPressureDifference$i'] ?? '',
          ),

          'evaporatorInletTemp$i': FormItem(
              required: true,
              label: '蒸发器入口温度',
              unit: '°C',
              val: json['evaporatorInletTemp$i'] ?? '',
              type: FormItemType.number),
          'evaporatorOutletTemp$i': FormItem(
              required: true,
              label: '蒸发器出口温度',
              unit: '°C',
              val: json['evaporatorOutletTemp$i'] ?? '',
              type: FormItemType.number),

          // 冷凝器温度设置
          'condenserInletTemp$i': FormItem(
              required: true,
              label: '冷凝器入口温度',
              unit: '°C',
              val: json['condenserInletTemp$i'] ?? '',
              type: FormItemType.number),
          'condenserOutletTemp$i': FormItem(
              required: true,
              label: '冷凝器出口温度',
              unit: '°C',
              val: json['condenserOutletTemp$i'] ?? '',
              type: FormItemType.number),

          // 1#压缩机参数设置
          'compressor1DischargeTemp$i': FormItem(
              required: true,
              label: '1#压缩机 排气温度',
              unit: '°C',
              val: json['compressor1DischargeTemp$i'] ?? '',
              type: FormItemType.number),
          'compressor1Current$i': FormItem(
              required: true,
              label: '1#压缩机 压缩机电流 ',
              unit: 'A',
              val: json['compressor1Current$i'] ?? '',
              type: FormItemType.number),
          'compressor1DischargePressure$i': FormItem(
              required: true,
              label: '1#压缩机 排气压力',
              unit: 'MPa',
              val: json['compressor1DischargePressure$i'] ?? '',
              type: FormItemType.number),
          'compressor1SuctionPressure$i': FormItem(
              required: true,
              label: '1#压缩机 吸气压力 ',
              unit: 'MPa',
              val: json['compressor1SuctionPressure$i'] ?? '',
              type: FormItemType.number),
          'compressor1CondensingTemp$i': FormItem(
              required: true,
              label: '1#压缩机 冷凝饱和温度',
              unit: '°C',
              val: json['compressor1CondensingTemp$i'] ?? '',
              type: FormItemType.number),
          'compressor1EvaporatingTemp$i': FormItem(
              required: true,
              label: '1#压缩机 蒸发饱和温度',
              unit: '°C',
              val: json['compressor1EvaporatingTemp$i'] ?? '',
              type: FormItemType.number),

          // 2#压缩机参数设置
          'compressor2DischargeTemp$i': FormItem(
              required: true,
              label: '2#压缩机 排气温度',
              unit: '°C',
              val: json['compressor2DischargeTemp$i'] ?? '',
              type: FormItemType.number),
          'compressor2Current$i': FormItem(
              required: true,
              label: '2#压缩机 压缩机电流 ',
              unit: 'A',
              val: json['compressor2Current$i'] ?? '',
              type: FormItemType.number),
          'compressor2DischargePressure$i': FormItem(
              required: true,
              label: '2#压缩机 排气压力 ',
              unit: 'MPa',
              val: json['compressor2DischargePressure$i'] ?? '',
              type: FormItemType.number),
          'compressor2SuctionPressure$i': FormItem(
              required: true,
              label: '2#压缩机 吸气压力',
              val: json['compressor2SuctionPressure$i'] ?? '',
              type: FormItemType.number),
          'compressor2CondensingTemp$i': FormItem(
              required: true,
              label: '2#压缩机 冷凝饱和温度',
              unit: '°C',
              val: json['compressor2CondensingTemp$i'] ?? '',
              type: FormItemType.number),
          'compressor2EvaporatingTemp$i': FormItem(
              required: true,
              label: '2#压缩机 蒸发饱和温度',
              unit: '°C',
              val: json['compressor2EvaporatingTemp$i'] ?? '',
              type: FormItemType.number)
        };
      }).reduce((a, b) => {...a, ...b}), // 将多个 map 合并为一个
      // 1. 客户设定的目标温度
      'customerTargetTemperature': FormItem(
        required: true,
        label: '客户设定的目标温度',
        val: json['customerTargetTemperature'] ?? '',
        type: FormItemType.number,
        unit: '°C', // 添加单位信息
      ),
      // 用户侧供电电压
      'userSideSupplyVoltagePhase1': FormItem(
        required: true,
        label: '用户侧供电电压相1',
        val: json['userSideSupplyVoltagePhase1'] ?? '',
        type: FormItemType.number,
        unit: 'V',
      ),
      'userSideSupplyVoltagePhase2': FormItem(
        required: true,
        label: '用户侧供电电压相2',
        val: json['userSideSupplyVoltagePhase2'] ?? '',
        type: FormItemType.number,
        unit: 'V',
      ),
      'userSideSupplyVoltagePhase3': FormItem(
        required: true,
        label: '用户侧供电电压相3',
        val: json['userSideSupplyVoltagePhase3'] ?? '',
        type: FormItemType.number,
        unit: 'V',
      ),
      // 2. 冷冻水进出口压差
      'chilledWaterInletOutletPressureDifference': FormItem(
        required: true,
        label: '冷冻水进出口压差',
        val: json['chilledWaterInletOutletPressureDifference'] ?? '',
        type: FormItemType.number,
        unit: 'kPa',
      ),

      'coolingWaterInletOutletPressureDifference': FormItem(
        required: true,
        label: '冷冻水进出口压差',
        val: json['coolingWaterInletOutletPressureDifference'] ?? '',
        type: FormItemType.number,
        unit: 'kPa',
      ),

      // 3. 运行状态下机组振动、噪音检查
      'unitVibrationNoiseCheck': FormItem(
        required: true,
        label: '运行状态下机组振动、噪音检查',
        val: json['unitVibrationNoiseCheck'] ?? '',
        type: FormItemType.radio,
        op: [
          selectItem(label: "无异常震动，无异响", val: "无异常震动，无异响"),
          selectItem(label: "异常", val: "异常"),
        ],
        // 无单位，unit 可以省略或设为 null
      ),

      // 4. 制冷系统检查 - 氟侧系统过滤器前后温差
      'fluorideSideFilterTemperatureDifference': FormItem(
        required: true,
        label: '氟侧系统过滤器前后温差',
        val: json['fluorideSideFilterTemperatureDifference'] ?? '',
        type: FormItemType.number,
        unit: '°C',
      ),
/** -------- 机组运行数据记录表内容 ------------*/

/** -------- 用户意见收集固定内容 ------------*/
      // 用户意见收集
      'userFeedback': FormItem(
          required: true,
          label: '用户意见收集',
          val: json['userFeedback'] ?? '',
          type: FormItemType.textarea),
      // 现场培训效果
      'onSiteTrainingEffect': FormItem(
          required: true,
          label: '现场培训效果',
          val: json['onSiteTrainingEffect'] ?? '',
          type: FormItemType.textarea),
      // 问题及处理结果
      'problemsAndSolutions': FormItem(
          required: true,
          label: '问题及处理结果',
          val: json['problemsAndSolutions'] ?? '',
          type: FormItemType.textarea),

      'preStartupCheckStatus': FormItem(
          required: true,
          label: '客户开机前检查情况',
          val: json['preStartupCheckStatus'] ?? '',
          type: FormItemType.radio,
          op: normal_op),
      'preStartupCheckDetails': FormItem(
          required: false,
          label: '具体问题描述',
          val: json['preStartupCheckDetails'] ?? '',
          type: FormItemType.textarea),
      // 运行状态下机组表现
      'operationStatus': FormItem(
          required: true,
          label: '运行状态下机组表现',
          val: json['operationStatus'] ?? '',
          type: FormItemType.radio,
          op: normal_op),
      'operationDetails': FormItem(
          required: false,
          label: '具体问题描述',
          val: json['operationDetails'] ?? '',
          type: FormItemType.textarea),
      // 其它事项
      'otherMatters': FormItem(
          required: false,
          label: '其它事项',
          val: json['otherMatters'] ?? '',
          type: FormItemType.textarea),

      // 美的服务人员姓名
      'mideaServicePersonName': FormItem(
          required: true,
          label: '美的服务人员姓名',
          val: json['mideaServicePersonName'] ?? ''),
      // 美的服务人员电话
      'mideaServicePersonPhone': FormItem(
          required: true,
          label: '美的服务人员电话',
          val: json['mideaServicePersonPhone'] ?? '',
          type: FormItemType.number),
      // 美的服务人员签名日期
      'mideaServiceSignatureDate': FormItem(
          required: true,
          label: '签名日期',
          val: json['mideaServiceSignatureDate'] ?? '',
          type: FormItemType.time),
      // 美的服务人员签名
      'mideaServiceSignature': FormItem(
          required: true,
          label: '美的服务人员签名',
          val: json['mideaServiceSignature'] ?? '',
          type: FormItemType.image),
      // 客户代表人员姓名
      'customerRepresentativeName': FormItem(
        required: true,
        label: '客户代表人员姓名',
        val: json['customerRepresentativeName'] ?? '',
      ),
      // 客户代表人员电话
      'customerRepresentativePhone': FormItem(
          required: true,
          label: '客户代表人员电话',
          val: json['customerRepresentativePhone'] ?? '',
          type: FormItemType.number),
      // 客户代表签名日期
      'customerSignatureDate': FormItem(
          required: true,
          label: '签名日期',
          val: json['customerSignatureDate'] ?? '',
          type: FormItemType.time),
      // 客户代表签名
      'customerSignature': FormItem(
          required: true,
          label: '客户代表签名',
          val: json['customerSignature'] ?? '',
          type: FormItemType.image),

/** -------- 用户意见收集固定内容 ------------*/

/** -------- 离心机添加的表格内容 ------------*/
// 控制柜与启动柜之间的通讯线使用双绞屏蔽线且屏蔽层单侧接地
      'controlCabinetStartupCabinetWiring': FormItem(
          required: true,
          label: '控制柜与启动柜之间的通讯线使用双绞屏蔽线且屏蔽层单侧接地',
          val: json['controlCabinetStartupCabinetWiring'] ?? '',
          type: FormItemType.radio,
          op: yesnoOptions), // 控制柜与启动柜通讯线检查
// 高压启动柜安装完成后，是否有做启动柜交接实验
      'startupCabinetHandoverTest': FormItem(
          required: true,
          label: '高压启动柜安装完成后，是否有做启动柜交接实验',
          val: json['startupCabinetHandoverTest'] ?? '',
          type: FormItemType.radio,
          op: normal_op), // 启动柜交接实验检查
      'highVoltageInsulationResistance': FormItem(
          required: true,
          label: '高压机组电机绝缘电阻',
          type: FormItemType.number,
          unit: 'MΩ', // 绝缘电阻单位通常为兆欧
          val: json['highVoltageInsulationResistance'] ?? ''), // 高压机组电机绝缘电阻值

      'oilHeaterStatus': FormItem(
          required: true,
          label: '油加热是否通电状态',
          val: json['oilHeaterStatus'] ?? '',
          type: FormItemType.radio,
          op: yesnoOptions), // 油加热通电状态

      'oilLevelVisibility': FormItem(
          required: true,
          label: '高位油镜是否可见油位',
          val: json['oilLevelVisibility'] ?? '',
          type: FormItemType.radio,
          op: yesnoOptions), // 油位可见性

      'lubricantColor': FormItem(
          required: true,
          label: '润滑油颜色确认',
          val: json['lubricantColor'] ?? '',
          type: FormItemType.radio,
          op: [
            selectItem(label: '清澈', val: '清澈'),
            selectItem(label: '浑浊', val: '浑浊'),
          ]), // 润滑油颜色

      'oilTankTemperature': FormItem(
          required: true,
          label: '油箱温度',
          type: FormItemType.number,
          unit: '℃',
          val: json['oilTankTemperature'] ?? ''), // 油箱温度

      'oilPumpPressure': FormItem(
          required: true,
          label: '油泵状态：供油压差',
          type: FormItemType.number,
          unit: 'kPa',
          val: json['oilPumpPressure'] ?? ''), // 供油压差

      'oilPumpCurrent': FormItem(
          required: true,
          label: '油泵电流',
          type: FormItemType.number,
          unit: 'A',
          val: json['oilPumpCurrent'] ?? ''), // 油泵电流

      'oilPumpInsulationResistance': FormItem(
          required: true,
          label: '油泵绝缘电阻',
          type: FormItemType.number,
          unit: 'MΩ',
          val: json['oilPumpInsulationResistance'] ?? ''), // 油泵绝缘电阻

      // 冷却水泵属性
      'heatRecoveryForm': FormItem(
          required: false,
          label: '热回收形式',
          val: json['heatRecoveryForm'] ?? '',
          type: FormItemType.radio,
          op: pumpFormOptions),
      'heatRecoveryFlow': FormItem(
          required: false,
          label: '热回收流量(m³/h)',
          val: json['heatRecoveryFlow'] ?? '',
          type: FormItemType.number),
      'heatRecoveryHead': FormItem(
          required: false,
          label: '热回收扬程(m)',
          val: json['heatRecoveryHead'] ?? '',
          type: FormItemType.number),

      // 冷冻水水质检查
      'heatRecoveryPH': FormItem(
        required: true,
        label: '热回收PH值',
        val: json['heatRecoveryPH'] ?? '',
        type: FormItemType.number,
      ),
      'heatRecoveryConductivity': FormItem(
          required: true,
          label: '热回收电导率(μS/cm)',
          val: json['heatRecoveryConductivity'] ?? '',
          type: FormItemType.number),
      'isheatRecoveryClear': FormItem(
          required: true,
          label: '热回收是否清澈',
          val: json['isheatRecoveryClear'] ?? '',
          type: FormItemType.radio,
          op: yesnoOptions),
      // 模式设置 - 运行模式
      'centrifugeOperationMode': FormItem(
          required: true,
          label: '运行模式',
          op: [
            selectItem(label: "制冷", val: "制冷"),
            selectItem(label: "制热", val: "制热"),
            selectItem(label: "水泵", val: "水泵"),
            selectItem(label: "蓄冰", val: "蓄冰"),
          ],
          val: json['centrifugeOperationMode'] ?? '',
          type: FormItemType.radio),
      'localMinimumAtmosphericPressure': FormItem(
          required: true,
          label: '当地最低大气压力',
          type: FormItemType.number,
          unit: 'kPa',
          val: json['localMinimumAtmosphericPressure'] ?? ''), // 当地最低大气压力(kPa)

      /** -------- 电磁阀参数 ------------*/
      'oilReturnSolenoidOpenTime': FormItem(
        required: true,
        label: '回油电磁阀开启时间',
        type: FormItemType.number,
        unit: 's',
        val: json['oilReturnSolenoidOpenTime'] ?? '',
      ), // 回油电磁阀开启时间(s)

      'oilReturnSolenoidCloseTime': FormItem(
        required: true,
        label: '回油电磁阀关闭时间',
        type: FormItemType.number,
        unit: 's',
        val: json['oilReturnSolenoidCloseTime'] ?? '',
      ), // 回油电磁阀关闭时间(s)

      /** -------- 油加热参数 ------------*/
      'oilHeatingOnTemperature': FormItem(
        required: true,
        label: '油加热开启温度',
        type: FormItemType.number,
        unit: '℃',
        val: json['oilHeatingOnTemperature'] ?? '',
      ), // 油加热开启温度(℃)

      'oilHeatingOffTemperature': FormItem(
        required: true,
        label: '油加热关闭温度',
        type: FormItemType.number,
        unit: '℃',
        val: json['oilHeatingOffTemperature'] ?? '',
      ), // 油加热关闭温度(℃)

      /** -------- 油泵参数 ------------*/
      'oilPumpShutOffTime': FormItem(
        required: true,
        label: '油泵关闭时间',
        type: FormItemType.number,
        unit: 's',
        val: json['oilPumpShutOffTime'] ?? '',
      ), // 油泵关闭时间(s)

      /** -------- 导叶执行器参数 ------------*/
      'guideVaneActuatorStroke': FormItem(
        required: true,
        label: '导叶执行器行程',
        type: FormItemType.number,
        unit: 's',
        val: json['guideVaneActuatorStroke'] ?? '',
      ), // 导叶执行器行程(s)

      /** -------- 变频器参数 ------------*/
      'frequencyConverterType': FormItem(
          required: true,
          label: '变频器类型',
          val: json['frequencyConverterType'] ?? '',
          op: [
            selectItem(label: '汇川', val: '汇川'),
            selectItem(label: '四方', val: '四方'),
            selectItem(label: '预留', val: '预留'),
            selectItem(label: '中车', val: '中车'),
            selectItem(label: '合康', val: '合康'),
            selectItem(label: '自制', val: '自制'),
            selectItem(label: '施耐德', val: '施耐德'),
            selectItem(label: '日业', val: '日业'),
            selectItem(label: '丹佛斯', val: '丹佛斯'),
          ],
          type: FormItemType.select), // 变频器类型

      'frequencyConverterBaudRate': FormItem(
        required: true,
        label: '波特率(bps)',
        val: json['frequencyConverterBaudRate'] ?? '',
        type: FormItemType.number,
      ), // 波特率

      'readStartAddress': FormItem(
        required: true,
        label: '读起始地址',
        val: json['readStartAddress'] ?? '',
        type: FormItemType.number,
      ), // 读起始地址

      'writeStartAddress': FormItem(
        required: true,
        label: '写起始地址',
        val: json['writeStartAddress'] ?? '',
        type: FormItemType.number,
      ), // 写起始地址
      /** -------- 离心机添加的表格内容 ------------*/

/** -------- 风冷螺杆机组添加的表格内容 ------------*/
// 温度相关设置
      'coolingInletTemp': FormItem(
          required: true,
          label: '（制冷/热）目标进水温度',
          unit: '°C',
          val: json['coolingInletTemp'] ?? '',
          type: FormItemType.number),
      'restartTempDiff': FormItem(
          required: true,
          unit: '°C',
          label: '复归开机（退出暂停）温差',
          val: json['restartTempDiff'] ?? '',
          type: FormItemType.number),

      // 设备类型设置
      'waterHeaterType': FormItem(
          required: true,
          label: '热水机类型',
          val: json['waterHeaterType'] ?? '',
          op: [
            selectItem(label: '蓄冰', val: '蓄冰'),
            selectItem(label: '热回收', val: '热回收'),
          ],
          type: FormItemType.radio),
      'unitControlMode': FormItem(
          required: true,
          label: '单双机控制',
          val: json['unitControlMode'] ?? '',
          op: [
            selectItem(label: '双机', val: '双机'),
            selectItem(label: '1#机组', val: '1#机组'),
            selectItem(label: '2#机组', val: '2#机组'),
          ],
          type: FormItemType.radio),

      // 功率设置
      'unit1RatedPower': FormItem(
          required: true,
          label: '1#功率（或电流）额定值（kW）',
          val: json['unit1RatedPower'] ?? '',
          type: FormItemType.number),
      'unit2RatedPower': FormItem(
          required: true,
          label: '2#功率（或电流）额定值（kW）',
          val: json['unit2RatedPower'] ?? '',
          type: FormItemType.number),
      'unit1PowerPercentage': FormItem(
          required: true,
          label: '1#功率（或电流）百分比（%）',
          val: json['unit1PowerPercentage'] ?? '',
          type: FormItemType.number),
      'unit2PowerPercentage': FormItem(
          required: true,
          label: '2#功率（或电流）百分比（%）',
          val: json['unit2PowerPercentage'] ?? '',
          type: FormItemType.number),

      // 压缩机时间设置
      'compressorMinStopTime': FormItem(
          required: true,
          label: '压缩机最短停机时间（s）',
          val: json['compressorMinStopTime'] ?? '',
          type: FormItemType.number),
      'compressorMinRunTime': FormItem(
          required: true,
          label: '压缩机最短运行时间（s）',
          val: json['compressorMinRunTime'] ?? '',
          type: FormItemType.number),
      'compressorStartInterval': FormItem(
          required: true,
          label: '压缩机两次启动间隔（s）',
          val: json['compressorStartInterval'] ?? '',
          type: FormItemType.number),

      // 变频器设置
      'frequencyConverterCount': FormItem(
          required: true,
          label: '变频器台数设置',
          val: json['frequencyConverterCount'] ?? '',
          type: FormItemType.number),
      'frequencyConverterType1': FormItem(
          required: true,
          label: '1#变频器类型',
          val: json['frequencyConverterType1'] ?? '',
          op: [
            selectItem(label: '汇川', val: '汇川'),
            selectItem(label: '四方', val: '四方'),
            selectItem(label: '施耐德', val: '施耐德'),
            selectItem(label: '美的', val: '美的'),
            selectItem(label: '海利普', val: '海利普'),
          ],
          type: FormItemType.select),
      'frequencyConverterType2': FormItem(
          required: true,
          label: '2#变频器类型',
          val: json['frequencyConverterType2'] ?? '',
          op: [
            selectItem(label: '汇川', val: '汇川'),
            selectItem(label: '四方', val: '四方'),
            selectItem(label: '施耐德', val: '施耐德'),
            selectItem(label: '美的', val: '美的'),
            selectItem(label: '海利普', val: '海利普'),
          ],
          type: FormItemType.select),

      "vibrationNoiseIssueDesc": FormItem(
        required: false,
        label: '运行状态下机组振动、噪音检查异常情况说明',
        val: json['vibrationNoiseIssueDesc'] ?? '',
        type: FormItemType.textarea,
      ),
      "oilReturnSystemStatus": FormItem(
          required: true,
          label: '回油系统检查（引射回油）',
          val: json['oilReturnSystemStatus'] ?? '',
          op: [
            selectItem(label: '正常', val: '正常'),
            selectItem(label: '异常', val: '异常')
          ],
          type: FormItemType.radio),
      "oilReturnSystemIssueDesc": FormItem(
        required: false,
        label: '回油系统检查（引射回油）异常情况说明',
        val: json['oilReturnSystemIssueDesc'] ?? '',
        type: FormItemType.textarea,
      )

/** -------- 风冷螺杆机组添加的表格内容 ------------*/
    };
    if (isPreSetByKey) {
      for (var k in formFields.keys) {
        var v = formFields[k]!.label.contains("电话") ? '13726259684' : k;
        formFields[k]!.val =
            formFields[k]!.op != null ? formFields[k]!.op![0].val : v;
      }
    }
    return InstallationInfo(fields: formFields);
  }

  Map<String, dynamic> toJson() {
    return fields.map((key, item) => MapEntry(key, item.val));
  }
}
