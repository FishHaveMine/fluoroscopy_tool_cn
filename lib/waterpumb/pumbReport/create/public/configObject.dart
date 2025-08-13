import '../com/tableByJson.dart';
import 'InstallationInfo.dart';

// 表格构建对象 ----------------------------------》

// 离心机组 - 水泵、冷却塔检查（流量大于机组额定流量
final tableConfig = TableConfig(
  tableRow: ["类别", "形式", "流量m³/h", "扬程m"],
  tableColum: [
    [
      "冷冻水泵",
      'chilledWaterPumpForm',
      'chilledWaterPumpFlow',
      'chilledWaterPumpHead',
    ],
    [
      "冷却水泵",
      'coolingWaterPumpForm',
      'coolingWaterPumpFlow',
      'coolingWaterPumpHead',
    ],
    [
      "冷却塔",
      'coolingTowerForm',
      'coolingTowerFlow',
      'coolingTowerHead',
    ],
    [
      "热回收",
      'heatRecoveryForm',
      'heatRecoveryFlow',
      'heatRecoveryHead',
    ],
  ],
);

// 离心机组 - 水质检查
final tableConfig1 = TableConfig(
  tableRow: ["项目", "PH值", "电导率", "是否清澈"],
  tableColum: [
    [
      "冷冻水",
      'chilledWaterPH',
      'chilledWaterConductivity',
      'isChilledWaterClear',
    ],
    [
      "冷却水",
      'coolingWaterPH',
      'coolingWaterConductivity',
      'isCoolingWaterClear',
    ],
    [
      "热回收",
      'heatRecoveryPH',
      'heatRecoveryConductivity',
      'isheatRecoveryClear',
    ],
  ],
);
// 《---------------------------------- 表格构建对象

// 机组运行数据记录表构建对象 ----------------------------------》
// 磁悬浮离心式冷水机组 - 表单数据
final runningdataGroup1 = RunningDataGroup(items: [
  GroupItem(group: Group(data: [DataItem(formkey: 'logTime')], name: '记录时间')),
  GroupItem(
      group: Group(data: [
    DataItem(formkey: 'chilledWaterInletTemp'),
    DataItem(formkey: 'chilledWaterOutletTemp'),
  ], name: '冷冻水')),
  GroupItem(
      group: Group(data: [
    DataItem(formkey: 'coolingWaterInletTemp'),
    DataItem(formkey: 'coolingWaterOutletTemp'),
  ], name: '冷却水')),
  GroupItem(
      group: Group(data: [
    DataItem(formkey: 'evaporatorEvaporationPressure'),
    DataItem(formkey: 'evaporatorSaturationTemp'),
    DataItem(formkey: 'evaporatorTerminalTempDiff'),
  ], name: '蒸发器')),
  GroupItem(
      group: Group(data: [
    DataItem(formkey: 'condenserCondensationPressure'),
    DataItem(formkey: 'condenserSaturationTemp'),
    DataItem(formkey: 'condenserTerminalTempDiff'),
  ], name: '冷凝器')),
  GroupItem(
      group: Group(
          data: [DataItem(formkey: 'guideVane1Opening')], name: '1#导叶开度')),
  GroupItem(
      group: Group(
          data: [DataItem(formkey: 'guideVane2Opening')], name: '2#导叶开度')),
  GroupItem(
      group: Group(
          data: [DataItem(formkey: 'guideVane3Opening')], name: '3#导叶开度')),
  GroupItem(
      group:
          Group(data: [DataItem(formkey: 'currentPercentage')], name: '电流百分比')),
]);

// 离心机组 - 表单数据
final runningdataGroup2 = RunningDataGroup(items: [
  GroupItem(group: Group(data: [DataItem(formkey: 'logTime')], name: '记录时间')),
  GroupItem(
      group: Group(data: [
    DataItem(formkey: 'chilledWaterInletTemp'),
    DataItem(formkey: 'chilledWaterOutletTemp'),
  ], name: '冷冻水')),
  GroupItem(
      group: Group(data: [
    DataItem(formkey: 'coolingWaterInletTemp'),
    DataItem(formkey: 'coolingWaterOutletTemp'),
  ], name: '冷却水')),
  GroupItem(
      group: Group(data: [
    DataItem(formkey: 'evaporatorEvaporationPressure'),
    DataItem(formkey: 'evaporatorSaturationTemp'),
    DataItem(formkey: 'evaporatorTerminalTempDiff'),
  ], name: '蒸发器')),
  GroupItem(
      group: Group(data: [
    DataItem(formkey: 'condenserCondensationPressure'),
    DataItem(formkey: 'condenserSaturationTemp'),
    DataItem(formkey: 'condenserTerminalTempDiff'),
  ], name: '冷凝器')),
  GroupItem(
      group: Group(data: [
    DataItem(formkey: 'oilTankTemperature'),
    DataItem(formkey: 'oilSupplyTemperature'),
    DataItem(formkey: 'oilTankPressure'),
    DataItem(formkey: 'oilSupplyPressure'),
    DataItem(formkey: 'oilSupplyPressureDifference'),
  ], name: '油系统')),
  GroupItem(
      group:
          Group(data: [DataItem(formkey: 'guideVane1Opening')], name: '导叶开度')),
  GroupItem(
      group:
          Group(data: [DataItem(formkey: 'currentPercentage')], name: '电流百分比')),
]);

// 水冷螺杆机组 - 表单数据
final runningdataGroup3 = RunningDataGroup(items: [
  GroupItem(group: Group(data: [DataItem(formkey: 'logTime')], name: '记录时间')),
  GroupItem(
      group: Group(data: [
    DataItem(formkey: 'evaporatorInletTemp'), // 蒸发器入口温度 -- 需要补充
    DataItem(formkey: 'evaporatorOutletTemp'), // 蒸发器出口温度 -- 需要补充
    DataItem(formkey: 'evaporatorTerminalTempDiff'), // 蒸发器端温差
  ], name: '蒸发器')),
  GroupItem(
      group: Group(data: [
    DataItem(formkey: 'condenserInletTemp'), // 冷凝器入口温度 -- 需要补充
    DataItem(formkey: 'condenserOutletTemp'), // 冷凝器出口温度 -- 需要补充
    DataItem(formkey: 'condenserTerminalTempDiff'), // 蒸发器端温差
  ], name: '冷凝器')),
  GroupItem(
      group: Group(data: [
    DataItem(formkey: 'compressor1DischargeTemp'), // 1#压缩机 排气温度 -- 需要补充
    DataItem(formkey: 'compressor1Current'), // 1#压缩机 压缩机电流  -- 需要补充
    DataItem(formkey: 'compressor1DischargePressure'), // 1#压缩机 排气压力 -- 需要补充
    DataItem(formkey: 'compressor1SuctionPressure'), // 1#压缩机 吸气压力  -- 需要补充
    DataItem(formkey: 'compressor1CondensingTemp'), // 1#压缩机 冷凝饱和温度 -- 需要补充
    DataItem(formkey: 'compressor1EvaporatingTemp'), // 1#压缩机 蒸发饱和温度  -- 需要补充
  ], name: '1#压缩机')),
  GroupItem(
      group: Group(data: [
    DataItem(formkey: 'compressor2DischargeTemp'), // 2#压缩机 排气温度 -- 需要补充
    DataItem(formkey: 'compressor2Current'), // 2#压缩机 压缩机电流  -- 需要补充
    DataItem(formkey: 'compressor2DischargePressure'), // 2#压缩机 排气压力 -- 需要补充
    DataItem(formkey: 'compressor2SuctionPressure'), // 2#压缩机 吸气压力  -- 需要补充
    DataItem(formkey: 'compressor2CondensingTemp'), // 2#压缩机 冷凝饱和温度 -- 需要补充
    DataItem(formkey: 'compressor2EvaporatingTemp'), // 2#压缩机 蒸发饱和温度  -- 需要补充
  ], name: '2#压缩机')),
]);
// 《---------------------------------- 机组运行数据记录表构建对象

class RunningDataGroup {
  List<GroupItem> items;

  RunningDataGroup({required this.items});

  factory RunningDataGroup.fromJson(List<dynamic> json) {
    return RunningDataGroup(
      items: json.map((item) => GroupItem.fromJson(item)).toList(),
    );
  }
  List<String> getAllFormKeys() {
    return items
        .expand((item) => item.group.data.map((data) => data.formkey))
        .toList();
  }

  List<Map<String, dynamic>> toFormattedList(
      Map<String, FormItem> installationInfoMap) {
    return items.map((item) {
      final groupName = item.group.name;
      final dataList = item.group.data.map((data) {
        final info = installationInfoMap["${data.formkey}1"];
        return {
          "formkey": data.formkey,
          "name": info!.label,
          "unit": info.unit,
        };
      }).toList();
      return {groupName: dataList};
    }).toList();
  }
}

class GroupItem {
  Group group;

  GroupItem({required this.group});

  factory GroupItem.fromJson(Map<String, dynamic> json) {
    return GroupItem(
      group: Group.fromJson(json['group']),
    );
  }
}

class Group {
  String name;
  List<DataItem> data;

  Group({required this.name, required this.data});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      name: json['name'],
      data: (json['data'] as List<dynamic>)
          .map((item) => DataItem.fromJson(item))
          .toList(),
    );
  }
}

class DataItem {
  String formkey;

  DataItem({required this.formkey});

  factory DataItem.fromJson(Map<String, dynamic> json) {
    return DataItem(
      formkey: json['formkey'],
    );
  }
}
