import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../com/compressortable.dart';
import '../com/coolingWatertable.dart';
import '../com/coolingtable.dart';
import 'InstallationInfo.dart';
import 'configObject.dart';

/** ---- 离心机 step3 ----- */
var pointmap = {
  "sn": "productSn",
  "expansionValveControllerVersion": "expansionValveControllerVersion",
  "targetTemp": "coolingHeatingTargetTemp",
  "evaporatorControlTemperature": "restartTempDiff",
  "exitPauseTemperatureDifference": "exitPauseTempDiff",
  "enterPauseTemperatureDifference": "enterPauseTempDiff",
  "capacityRegulationTemperatureDifference": "capacityAdjustmentKeepTempDiff",
  "fanRegulatesTemperatureDifference": "coolingTowerFanAdjustTempDiff",
  "coolingTowerFanUnit1ShutdownTemperature":
      "coolingTowerFanUnit1ShutdownTemperature",
  "coolingTowerFanUnit1OpeningTemperature":
      "coolingTowerFanUnit1OpeningTemperature",
  "coolingTowerFanUnit2ShutdownTemperature":
      "coolingTowerFanUnit2ShutdownTemperature",
  "coolingTowerFanUnit2OpeningTemperature":
      "coolingTowerFanUnit2OpeningTemperature",
  "controlMode": "controlMode",
  "runningMode": "centrifugeOperationMode",
  "inletAndOutletWaterControl": "waterControl",
  "ratedCurrentOfTheHost": "ratedCurrent",
  "minimumAtmosphericPressure": "localMinimumAtmosphericPressure",
  "pressureSensorUpperLimitSetting": "pressureSensorUpperLimit",
  "targetLiquidLevelOfEvaporator": "evaporatorTargetLiquidLevel",
  "fullLoadPowerRefrigeration": "coolingFullLoadPower",
  "fullLoadPowerIceStorage": "iceStorageFullLoadPower",
  "compressorShutdownInterval": "compressorShutdownInterval",
  "compressorStartupInterval": "startupInterval",
  "quickStartupSignalDetectionDelay": "quickStartSignalDelay",
  "oilElectromagneticValveOpeningTime": "oilReturnSolenoidOpenTime",
  "oilElectromagneticValveClosingTime": "oilReturnSolenoidCloseTime",
  "oilHeatingOpenTemperature": "oilHeatingOnTemperature",
  "oilHeatingClosingTemperature": "oilHeatingOffTemperature",
  "oilPumpClosingTime": "oilPumpShutOffTime",
  "guideValveTravel": "guideVaneActuatorStroke",
  "variableFrequencyConverterType": "frequencyConverterType",
  "variableFrequencyConverterBaudRate": "frequencyConverterBaudRate",
  "variableFrequencyConverterReadStartAddress": "readStartAddress",
  "variableFrequencyConverterWriteStartAddress": "writeStartAddress",
};

/** ---- 水冷螺杆机组 step3 ----- */
var pointmap_waterCooledChiller = {
  "sn": "productSn",
  "controlProgramVersion": "expansionValveControllerVersion",
  "targetTemp": "coolingHeatingTargetTemp",
  "evaporatorControlTemperature": "evaporatorActualControlTemp",
  "coolingTowerFanUnit1OpeningTemperature":
      "coolingTowerFanUnit1OpeningTemperature",
  "coolingTowerFanUnit1ShutdownTemperature":
      "coolingTowerFanUnit1ShutdownTemperature",
  "coolingTowerFanUnit2OpeningTemperature":
      "coolingTowerFanUnit2OpeningTemperature",
  "coolingTowerFanUnit2ShutdownTemperature":
      "coolingTowerFanUnit2ShutdownTemperature",
  "controlMode": "controlMode",
  "runningMode": "centrifugeOperationMode",
  "inletAndOutletWaterControl": "waterControl",
  "ratedCurrentOfTheHost": "unit1RatedPower",
  "ratedCurrentOfTheHost2": "unit2RatedPower",
  "currentPercentage": "unit1PowerPercentage",
  "currentPercentage2": "unit2PowerPercentage",
  "compressorShutdownInterval": "compressorMinStopTime",
  "compressorStartupInterval": "compressorMinRunTime",
  "quickStartupSignalDetectionDelay": "compressorStartInterval",
  "variableFrequencyConverterType": "frequencyConverterCount",
  "variableFrequencyConverterBaudRate": "frequencyConverterType1",
  "variableFrequencyConverterBaudRate2": "frequencyConverterType2"
};

/** ---- 离心机 机房数据 ----- */
var runningMap = {
  "freezeWaterInletTemperature": "chilledWaterInletTemp",
  "freezeWaterOutletTemperature": "chilledWaterOutletTemp",
  "coldWaterInletTemperature": "coolingWaterInletTemp",
  "coldWaterOutletTemperature": "coolingWaterOutletTemp",
  "evaporatorEvaporationPressure": "evaporatorEvaporationPressure",
  "evaporatorSaturationTemperature": "evaporatorSaturationTemp",
  "evaporatorTemperatureDifference": "evaporatorTerminalTempDiff",
  "condenserCondensationPressure": "condenserCondensationPressure",
  "condenserSaturationTemperature": "condenserSaturationTemp",
  "condenserTemperatureDifference": "condenserTerminalTempDiff",
  "oilSystemOilTemperature": "oilTankTemperature",
  "oilSystemSupplyTemperature": "oilSupplyTemperature",
  "oilSystemOilPressure": "oilTankPressure",
  "oilSystemSupplyPressure": "oilSupplyPressure",
  "oilSystemSupplyPressureDifference": "oilSupplyPressureDifference",
  "guideValveOpeningDegree": "guideVane1Opening",
  "currentPercentage": "currentPercentage"
};

/** ---- 水冷螺杆机组 机房数据 ----- */
var runningMap_waterCooledChiller = {
  "evaporatorInletTemperature": "evaporatorInletTemp",
  "evaporatorOutletTemperature": "evaporatorOutletTemp",
  "evaporatorTemperatureDifference": "evaporatorTerminalTempDiff",
  "condenserInletTemperature": "condenserInletTemp",
  "condenserOutletTemperature": "condenserOutletTemp",
  "condenserTemperatureDifference": "condenserTerminalTempDiff",
  "compressorExhaustTemp1": "compressor1DischargeTemp",
  "compressorExhaustTemp1CompressorElectric": "compressor1Current",
  "compressorExhaustTemp1CompressorPressure": "compressor1DischargePressure",
  "compressorInletPressure": "compressor1SuctionPressure",
  "compressorExhaustTemp1CondenserSaturationTemperature":
      "compressor1CondensingTemp",
  "compressorExhaustTemp1EvaporatorSaturationTemperature":
      "compressor1EvaporatingTemp",
  "compressorExhaustTemp2": "compressor2DischargeTemp",
  "compressorExhaustTemp2CompressorElectric": "compressor2Current",
  "compressorExhaustTemp2CompressorPressure": "compressor2DischargePressure",
  "compressorInletPressure2": "compressor2SuctionPressure",
  "compressorExhaustTemp2CondenserSaturationTemperature":
      "compressor2CondensingTemp",
  "compressorExhaustTemp2EvaporatorSaturationTemperature":
      "compressor2EvaporatingTemp",
};

class InstallController extends GetxController {
  RxBool ispreview = false.obs;

  late InstallationInfo form;
  List step1 = [];
  List step2 = [];
  List step3 = [];
  List step4 = [];
  List step5 = [];

  getrunningdataGroup() {
    var point = runningdataGroup1.toFormattedList(form.fields);
    if (form["debugModel"].val == "离心机组") {
      point = runningdataGroup2.toFormattedList(form.fields);
    }
    if (form["debugModel"].val == "水冷螺杆机组") {
      point = runningdataGroup3.toFormattedList(form.fields);
    }
    return point;
  }

  getrunningdataGroupFormKeys() {
    var point = runningdataGroup1.getAllFormKeys();
    if (form["debugModel"].val == "离心机组") {
      point = runningdataGroup2.getAllFormKeys();
    }
    if (form["debugModel"].val == "水冷螺杆机组") {
      point = runningdataGroup3.getAllFormKeys();
    }
    return point;
  }

  // 切换调试设备类型
  switchDebugModel(type) {
    switch (type) {
      case "离心机组":
        step3 = [
          //------------ 1、外观检查
          '1、外观检查', // 外观检查模块标题
          form['unitAppearanceDamage'], // 机组外观是否有损坏
          form['partsDamage'], // 是否有零部件损坏
          form['insulationDamage'], // 是否存在保温破损
          form['other'], // 其他外观检查项
          8, // 模块分隔标识（可能用于布局或分页）

          //------------ 2、电气回路检查
          '2、电气回路检查', // 电气回路检查模块标题
          form['isSeparateWiring'], // “强弱电是否分开布线
          form['isCabinetCleanedMicro'], // 微机控制柜内部是否清扫
          form['isCabinetCleanedStart'], // 启动柜内部是否清扫
          form['isWiringCompliant'], // 控制接线是否符合接线图
          form['controlPowerConnectionStatus'], // 控制电源配线连接状态
          form['relayStatus'], // 继电器状态
          form['contactorStatus'], // 接触器状态
          form['powerWiringStatus'], // 电源接线合规且无松动
          form['startCabinetGroundingStatus'], // 启动柜接地状态是否正常
          form[
              'controlCabinetStartupCabinetWiring'], // 控制柜与启动柜之间的通讯线使用双绞屏蔽线且屏蔽层单侧接地
          form['startupCabinetHandoverTest'], // 高压启动柜安装完成后，是否有做启动柜交接实验
          8, // 模块分隔标识

          //------------ 3、压缩机状态检查
          '3、压缩机状态检查', // 压缩机状态检查模块标题
          form['lowVoltageInsulationResistance'], // 低压机组电机绝缘电阻
          form['highVoltageInsulationResistance'], // 高压机组电机绝缘电阻值
          Text(
            "检测方法：低压电机采用500 V兆欧表，不低于0.5MΩ；高压电机需使用2500V兆欧表，不低于1MΩ/kV；）",
            style: tip,
          ),
          form['guidePageSwitchStatus'], // 导页手动开关零位至满位
          8, // 模块分隔标识

          '4、油系统检查', // 油系统检查模块标题
          form['oilHeaterStatus'], // 油加热是否通电状态
          form['oilLevelVisibility'], // 高位油镜是否可见油位
          form['lubricantColor'], // 润滑油颜色确认
          form['oilTankTemperature'], // 油箱温度
          Text(
            "（标准：40~62℃）",
            style: tip,
          ),
          form['oilPumpPressure'], // 油泵状态：供油压差
          Text(
            "（标准＞200kPa）",
            style: tip,
          ),
          form['oilPumpCurrent'], // 油泵电流
          Text(
            "（要求小于额定电流）",
            style: tip,
          ),
          form['oilPumpInsulationResistance'], // 油泵绝缘电阻
          Text(
            "（检查方法：采用500 V兆欧表，不低于0.5MΩ）",
            style: tip,
          ),
          8, // 模块分隔标识

          //------------ 5、氟系统检查
          '5、氟系统检查', // 氟系统检查模块标题
          form['factoryStatus'], // 出厂状态（带氟/不带氟）
          form['airTightnessTestStatus'], // 不带氟出厂机组的气密性试验结果
          form['prePressureHoldingAirTightness'], // 气密性试验保压前压力（MPa）
          form['postPressureHoldingAirTightness'], // 气密性试验保压后压力（MPa）
          Text(
            "(充注氮气压力1.15±0.05Mpa，保压24h)",
            style: tip,
          ), // 气密性试验说明
          form['vacuumTestStatus'], // 不带氟出厂机组的真空试验结果
          form['prePressureHoldingVacuum'], // 真空试验保压前压力（MPa）
          form['postPressureHoldingVacuum'], // 真空试验保压后压力（MPa）
          Text(
            "(抽真空至绝压300Pa，保压30min回升<150Pa)",
            style: tip,
          ), // 真空试验说明
          form['refrigerantChargeAmount'], // 冷媒充注量（R134a，单位：kg）
          form['refrigerantChargeAmountRadio'], // 冷媒充注量相关选项（带氟出厂标记）
          form['singlePointLeakRate'], // 单点漏率（单位：g/年）
          Text(
            "(手持卤检仪，<5g/年)",
            style: tip,
          ), // 漏率检查标准说明
          8, // 模块分隔标识

          //------------ 6、水系统检查
          '6、水系统检查', // 水系统检查模块标题
          form['isImpurityInContainer'], // 管路清洗是否有杂质进入容器
          form['flowProtectionType'], // 用户流量保护装置类别（靶流/压差）
          form['coolingSideStatus'], // 冷却侧动作是否正常
          form['freezingSideStatus'], // 冷冻侧动作是否正常
          '水泵、冷却塔检查（流量大于机组额定流量）', // 检查说明
          tableConfig,
          '水质检查', // 水质检查子模块标题
          tableConfig1, // 水质检查表格组件
          8, // 模块分隔标识

          //------------ 6、报警及网络检查
          '7、报警及网络检查', // 报警及网络检查模块标题
          form['gatewayType'], // 网关类型（普通网关/水机博士）
          form['networkStatus'], // 网络状态（信号强/弱）
          form['gatewayFixedVersion'], // 网关固定版本号
          8, // 模块分隔标识

          //------------ 7、微机控制柜参数检查
          '8、微机控制柜参数检查', // 微机控制柜参数检查模块标题
          form['isSetParamsSameAsFactory'], // 设定参数与出厂参数是否一致
          form['specificParams'], // 具体差异内容
          '用户参数设置', // 用户参数设置子模块标题
          form['coolingHeatingTargetTemp'], // 制冷/制热目标温度（°C）
          form['evaporatorActualControlTemp'], // 蒸发器实际控制温度（°C）
          form['exitPauseTempDiff'], // 退出暂停温差（°C）
          form['enterPauseTempDiff'], // 进入暂停温差（°C）
          form['capacityAdjustmentKeepTempDiff'], // 容量调节保持温差（°C）
          form['coolingTowerFanAdjustTempDiff'], // 冷却塔风机调节温差（°C）
          form['coolingTowerFanUnit1ShutdownTemperature'], // 冷却塔风机组1关闭温度（°C）
          form['coolingTowerFanUnit1OpeningTemperature'], // 冷却塔风机组1开启温度（°C）
          form['coolingTowerFanUnit2ShutdownTemperature'], // 冷却塔风机组2关闭温度（°C）
          form['coolingTowerFanUnit2OpeningTemperature'], // 冷却塔风机组2开启温度（°C）
          '串口设置', // 串口设置子模块标题
          form['baudRate'], // 波特率（9600/19200/115200）
          form['stationAddress'], // 站号地址
          form['parityBit'], // 校验位
          // form['exitPauseTemperatureDifference'], // 退出暂停温差（°C）
          // form['enterPauseTemperatureDifference'], // 进入暂停温差（°C）
          '模式设置', // 模式设置子模块标题
          form['controlMode'], // 控制模式（就地/远程/定时/BMS）
          form['centrifugeOperationMode'], // 运行模式（制冷/制热/水泵）
          form['waterControl'], // 进出水控制方式（进水/出水）
          '常规设置', // 常规设置子模块标题
          form['ratedCurrent'], // 主机额定电流（A）
          // form['ratedFrequency'], // 额定频率（Hz）
          form['localMinimumAtmosphericPressure'], // 当地最低大气压力
          form['pressureSensorUpperLimit'], // 压力传感器上限设置（kPa）
          form['evaporatorTargetLiquidLevel'], // 蒸发器目标液位（mm）
          form['coolingFullLoadPower'], // 制冷满载功率（kW）
          form['iceStorageFullLoadPower'], // 蓄冰满载功率（kW）
          form['compressorShutdownInterval'], // 压缩机停机间隔（S）
          form['startupInterval'], // 启动间隔（S）
          form['quickStartSignalDelay'], // 快速启动备妥信号判断延时（S）
          '控制参数',
          form['oilReturnSolenoidOpenTime'], // 回油电磁阀开启时间
          form['oilReturnSolenoidCloseTime'], //回油电磁阀关闭时间
          form['oilHeatingOnTemperature'], //油加热开启温度
          form['oilHeatingOffTemperature'], //油加热关闭温度
          form['oilPumpShutOffTime'], //油泵关闭时间
          form['guideVaneActuatorStroke'], //导叶执行器行程
          '变频器参数',
          form['frequencyConverterType'], // 变频器类型
          form['frequencyConverterBaudRate'], // 波特率
          form['readStartAddress'], // 读起始地址
          form['writeStartAddress'], // 写起始地址
        ];
        break;
      case "磁悬浮冷水机组":
        step3 = [
          //------------ 1、外观检查
          '1、外观检查', // 外观检查模块标题
          form['unitAppearanceDamage'], // 机组外观是否有损坏
          form['partsDamage'], // 是否有零部件损坏
          form['insulationDamage'], // 是否存在保温破损
          form['other'], // 其他外观检查项
          8, // 模块分隔标识（可能用于布局或分页）

          //------------ 2、电气回路检查
          '2、电气回路检查', // 电气回路检查模块标题
          form['isSeparateWiring'], // “强弱电是否分开布线
          form['isCabinetCleanedMicro'], // 微机控制柜内部是否清扫
          form['isCabinetCleanedStart'], // 启动柜内部是否清扫
          form['isWiringCompliant'], // 控制接线是否符合接线图
          form['controlPowerConnectionStatus'], // 控制电源配线连接状态
          form['relayStatus'], // 继电器状态
          form['contactorStatus'], // 接触器状态
          form['powerWiringStatus'], // 电源接线合规且无松动
          form['startCabinetGroundingStatus'], // 启动柜接地状态是否正常
          8, // 模块分隔标识

          //------------ 3、压缩机状态检查
          '3、压缩机状态检查', // 压缩机状态检查模块标题
          form['lowVoltageInsulationResistance'], // 低压机组电机绝缘电阻
          form['guidePageSwitchStatus'], // 导页手动开关零位至满位
          8, // 模块分隔标识

          //------------ 4、氟系统检查
          '4、氟系统检查', // 氟系统检查模块标题
          form['factoryStatus'], // 出厂状态（带氟/不带氟）
          form['airTightnessTestStatus'], // 不带氟出厂机组的气密性试验结果
          form['prePressureHoldingAirTightness'], // 气密性试验保压前压力（MPa）
          form['postPressureHoldingAirTightness'], // 气密性试验保压后压力（MPa）
          Text(
            "(充注氮气压力1.15±0.05Mpa，保压24h)",
            style: tip,
          ), // 气密性试验说明
          form['vacuumTestStatus'], // 不带氟出厂机组的真空试验结果
          form['prePressureHoldingVacuum'], // 真空试验保压前压力（MPa）
          form['postPressureHoldingVacuum'], // 真空试验保压后压力（MPa）
          Text(
            "(抽真空至绝压300Pa，保压30min回升<150Pa)",
            style: tip,
          ), // 真空试验说明
          form['refrigerantChargeAmount'], // 冷媒充注量（R134a，单位：kg）
          form['refrigerantChargeAmountRadio'], // 冷媒充注量相关选项（带氟出厂标记）
          form['singlePointLeakRate'], // 单点漏率（单位：g/年）
          Text(
            "(手持卤检仪，<5g/年)",
            style: tip,
          ), // 漏率检查标准说明
          8, // 模块分隔标识

          //------------ 5、水系统检查
          '5、水系统检查', // 水系统检查模块标题
          form['isImpurityInContainer'], // 管路清洗是否有杂质进入容器
          form['flowProtectionType'], // 用户流量保护装置类别（靶流/压差）
          form['coolingSideStatus'], // 冷却侧动作是否正常
          form['freezingSideStatus'], // 冷冻侧动作是否正常
          '水泵、冷却塔检查（流量大于机组额定流量）', // 检查说明
          const coolingtable(), // 水泵/冷却塔参数表格组件
          '水质检查', // 水质检查子模块标题
          const coolingWatertable(), // 水质检查表格组件
          8, // 模块分隔标识

          //------------ 6、报警及网络检查
          '6、报警及网络检查', // 报警及网络检查模块标题
          form['evaporationPressureLowAlarm'], // 蒸发压力过低报警状态
          form['condensationPressureHighAlarm'], // 冷凝压力过高报警状态
          form['windingTemperatureHighAlarm'], // 电机绕组温度过高报警状态
          form['startupTimeExceedAlarm'], // 启动时间过长报警状态
          form['gatewayType'], // 网关类型（普通网关/水机博士）
          form['networkStatus'], // 网络状态（信号强/弱）
          form['gatewayFixedVersion'], // 网关固定版本号
          8, // 模块分隔标识

          //------------ 7、微机控制柜参数检查
          '7、微机控制柜参数检查', // 微机控制柜参数检查模块标题
          form['isSetParamsSameAsFactory'], // 设定参数与出厂参数是否一致
          form['specificParams'], // 具体差异内容
          '用户参数设置', // 用户参数设置子模块标题
          form['waterControl'], // 进出水控制方式（进水/出水）
          form['coolingHeatingTargetTemp'], // 制冷/制热目标温度（°C）
          form['evaporatorActualControlTemp'], // 蒸发器实际控制温度（°C）
          form['exitPauseTempDiff'], // 退出暂停温差（°C）
          form['enterPauseTempDiff'], // 进入暂停温差（°C）
          form['capacityAdjustmentKeepTempDiff'], // 容量调节保持温差（°C）
          form['coolingTowerFanAdjustTempDiff'], // 冷却塔风机调节温差（°C）
          form['coolingTowerFanUnit1ShutdownTemperature'], // 冷却塔风机组1关闭温度（°C）
          form['coolingTowerFanUnit1OpeningTemperature'], // 冷却塔风机组1开启温度（°C）
          form['coolingTowerFanUnit2ShutdownTemperature'], // 冷却塔风机组2关闭温度（°C）
          form['coolingTowerFanUnit2OpeningTemperature'], // 冷却塔风机组2开启温度（°C）
          '串口设置', // 串口设置子模块标题
          form['baudRate'], // 波特率（9600/19200/115200）
          form['stationAddress'], // 站号地址
          form['parityBit'], // 校验位
          form['exitPauseTemperatureDifference'], // 退出暂停温差（°C）
          form['enterPauseTemperatureDifference'], // 进入暂停温差（°C）
          '模式设置', // 模式设置子模块标题
          form['controlMode'], // 控制模式（就地/远程/定时/BMS）
          form['operationMode'], // 运行模式（制冷/制热/水泵）
          '常规设置', // 常规设置子模块标题
          form['ratedCurrent'], // 主机额定电流（A）
          form['ratedFrequency'], // 额定频率（Hz）
          form['currentTransmitterRange'], // 电流变送器范围（A）
          form['pressureSensorUpperLimit'], // 压力传感器上限设置（kPa）
          form['evaporatorTargetLiquidLevel'], // 蒸发器目标液位（mm）
          form['coolingFullLoadPower'], // 制冷满载功率（kW）
          form['iceStorageFullLoadPower'], // 蓄冰满载功率（kW）
          form['compressorShutdownInterval'], // 压缩机停机间隔（S）
          form['startupInterval'], // 启动间隔（S）
          form['quickStartSignalDelay'], // 快速启动备妥信号判断延时（S）
          '变频器', // 变频器相关参数子模块标题
          form['inverter1SoftwareVersion'], // 1#主控软件版本
          form['inverter2SoftwareVersion'], // 2#主控软件版本
          form['inverter3SoftwareVersion'], // 3#主控软件版本
          '压缩机参数', // 压缩机参数子模块标题
          form['compressor1Version'], // 1#压缩机版本
          form['maglev1Version'], // 1#磁悬浮版本
          form['compressor2Version'], // 2#压缩机版本
          form['maglev2Version'], // 2#磁悬浮版本
          form['compressor3Version'], // 3#压缩机版本
          form['maglev3Version'], // 3#磁悬浮版本
          '磁悬浮参数', // 磁悬浮参数子模块标题
          Text(
            "(手动悬浮，位移参数在+10范围内)",
            style: tip,
          ), // 磁悬浮参数说明
          const compressortable(), // 压缩机参数表格组件
          8, // 模块分隔标识
        ];
        break;

      case "水冷螺杆机组":
        step3 = [
          //------------ 1、外观检查
          '1、外观检查', // 外观检查模块标题
          form['unitAppearanceDamage'], // 机组外观是否有损坏
          form['partsDamage'], // 是否有零部件损坏
          form['insulationDamage'], // 是否存在保温破损
          form['other'], // 其他外观检查项
          8, // 模块分隔标识（可能用于布局或分页）

          //------------ 2、电气回路检查
          '2、电气回路检查', // 电气回路检查模块标题
          form['isSeparateWiring'], // “强弱电是否分开布线
          form['isCabinetCleanedStart'], // 启动柜内部是否清扫
          form['isWiringCompliant'], // 控制接线是否符合接线图
          form['controlPowerConnectionStatus'], // 控制电源配线连接状态
          form['relayStatus'], // 继电器状态
          form['contactorStatus'], // 接触器状态
          form['powerWiringStatus'], // 电源接线合规且无松动
          form['startCabinetGroundingStatus'], // 启动柜接地状态是否正常
          8, // 模块分隔标识

          //------------ 3、油系统检查
          '3、油系统检查', // 压缩机状态检查模块标题
          form['oilHeaterStatus'], // 油加热是否通电状态
          form['oilLevelVisibility'], // 高位油镜是否可见油位
          form['lubricantColor'], // 润滑油颜色确认
          8, // 模块分隔标识

          //------------ 4、氟系统检查
          '4、氟系统检查', // 氟系统检查模块标题
          form['factoryStatus'], // 出厂状态（带氟/不带氟）
          form['airTightnessTestStatus'], // 不带氟出厂机组的气密性试验结果
          form['prePressureHoldingAirTightness'], // 气密性试验保压前压力（MPa）
          form['postPressureHoldingAirTightness'], // 气密性试验保压后压力（MPa）
          Text(
            "(充注氮气压力1.15±0.05Mpa，保压24h)",
            style: tip,
          ), // 气密性试验说明
          form['vacuumTestStatus'], // 不带氟出厂机组的真空试验结果
          form['prePressureHoldingVacuum'], // 真空试验保压前压力（MPa）
          form['postPressureHoldingVacuum'], // 真空试验保压后压力（MPa）
          Text(
            "(抽真空至绝压300Pa，保压30min回升<150Pa)",
            style: tip,
          ), // 真空试验说明
          form['refrigerantChargeAmount'], // 冷媒充注量（R134a，单位：kg）
          form['singlePointLeakRate'], // 单点漏率（单位：g/年）
          Text(
            "(手持卤检仪，<5g/年)",
            style: tip,
          ), // 漏率检查标准说明
          8, // 模块分隔标识

          //------------ 5、水系统检查
          '5、水系统检查', // 水系统检查模块标题
          form['isImpurityInContainer'], // 管路清洗是否有杂质进入容器
          form['flowProtectionType'], // 用户流量保护装置类别（靶流/压差）
          form['coolingSideStatus'], // 冷却侧动作是否正常
          form['freezingSideStatus'], // 冷冻侧动作是否正常
          '水泵、冷却塔检查（流量大于机组额定流量）', // 检查说明
          tableConfig,
          '水质检查', // 水质检查子模块标题
          tableConfig1, // 水质检查表格组件
          8, // 模块分隔标识

          //------------ 6、报警及网络检查
          '6、网络状态检查', // 报警及网络检查模块标题
          form['gatewayType'], // 网关类型（普通网关/水机博士）
          form['networkStatus'], // 网络状态（信号强/弱）
          form['gatewayFixedVersion'], // 网关固定版本号
          8, // 模块分隔标识

          //------------ 7、微机控制柜参数检查
          '7、微机控制柜参数检查', // 微机控制柜参数检查模块标题
          form['isSetParamsSameAsFactory'], // 设定参数与出厂参数是否一致
          form['specificParams'], // 具体差异内容
          '用户参数设置', // 用户参数设置子模块标题
          form['coolingHeatingTargetTemp'], // （制冷/热）目标出水温度（°C）
          form['coolingInletTemp'], //（制冷/热）目标进水温度（°C）
          form['restartTempDiff'], // 复归开机（退出暂停）温差（°C）
          form['coolingTowerFanUnit1ShutdownTemperature'], // 冷却塔风机组1关闭温度（°C）
          form['coolingTowerFanUnit1OpeningTemperature'], // 冷却塔风机组1开启温度（°C）
          form['coolingTowerFanUnit2ShutdownTemperature'], // 冷却塔风机组2关闭温度（°C）
          form['coolingTowerFanUnit2OpeningTemperature'], // 冷却塔风机组2开启温度（°C）
          '模式设置', // 模式设置子模块标题
          form['controlMode'], // 控制模式（就地/远程/定时/BMS）
          form['operationMode'], // 运行模式（制冷/制热/水泵）

          form['waterHeaterType'], // 热水机 - 单选：蓄冰/热回收
          form['unitControlMode'], // 单双机控制 - 单选：双机/1#机组/2#机组

          '固定负荷/加载限制',
          form['unit1RatedPower'], // 1#功率（或电流）额定值（kW）
          form['unit2RatedPower'], // 2#功率（或电流）额定值（kW）
          form['unit1PowerPercentage'], // 1#功率（或电流）百分比（%）
          form['unit2PowerPercentage'], // 2#功率（或电流）百分比（%）
          '延时设置',
          form['compressorMinStopTime'], // 压缩机最短停机时间（s）
          form['compressorMinRunTime'], // 压缩机最短运行时间（s）
          form['compressorStartInterval'], // 压缩机两次启动间隔（s）
          '变频器参数',
          form['frequencyConverterCount'], // 变频器台数设置
          form['frequencyConverterType1'], // 1#变频器类型
          form['frequencyConverterType2'], // 2#变频器类型
          '串口设置-COM3',
          form['baudRate'], // 波特率（9600/19200/115200）
          form['stationAddress'], // 站号地址
          form['parityBit'], // 校验位
          8, // 模块分隔标识
        ];
        step4 = [
          8,
          '其他检查事项',
          form['customerTargetTemperature'],
          form['userSideSupplyVoltagePhase1'],
          form['userSideSupplyVoltagePhase2'],
          form['userSideSupplyVoltagePhase3'],

          form['chilledWaterInletOutletPressureDifference'], //冷冻水进出口压差
          form['coolingWaterInletOutletPressureDifference'], //冷冻水进出口压差

          form['unitVibrationNoiseCheck'], //运行状态下机组振动、噪音检查
          form['vibrationNoiseIssueDesc'], // 运行状态下机组振动、噪音检查异常情况说明
          form['fluorideSideFilterTemperatureDifference'], //氟侧系统过滤器前后温差

          form['oilReturnSystemStatus'], // 回油系统检查（引射回油）
          form['oilReturnSystemIssueDesc'], // 回油系统检查（引射回油）异常情况说明
          Text(
            "（平稳运行状态下，温差应低于5℃）",
            style: tip,
          ),
          Text(
            "运行状态蒸发压力正常范围220～400KPa，冷凝压力正常范围700～1150KPa；",
            style: tip,
          ),
          Text(
            "平稳运行状态下，换热器端温差应小于3℃，高于此温差时，换热器换热效率降低，需进行清洗，建议最长1年清洗一次，如果水质较差，清洗频次需增加。敬请关注日常水系统水质管理。注：换热器清洗属于有偿服务项目。",
            style: tip,
          ),
          8,
          const SizedBox(height: 16),
          form['userFeedback'],
          form['onSiteTrainingEffect'],
          form['problemsAndSolutions'],
          8,
          '机组状态评价及整改建议',
          form['preStartupCheckStatus'],
          form['preStartupCheckDetails'],
          form['operationStatus'],
          form['operationDetails'],
          form['otherMatters'],
        ];
        break;
      default:
    }

    print("switchDebugModel -- $type -- $step3");
  }

  // 验证step3中是否存在required为true但val为空的FormItem对象
  bool validateStep(List<dynamic> step3) {
    // 遍历step3中的每个元素
    for (var item in step3) {
      // 检查是否为FormItem对象
      if (item is Map<String, dynamic> &&
          item.containsKey('required') &&
          item.containsKey('val')) {
        // 判断required为true且val为空字符串的情况
        if (item['required'] == true &&
            (item['val']?.toString()?.trim() == '')) {
          print("验证失败：发现required为true但val为空的FormItem");
          return false;
        }
      }

      // 处理嵌套列表（如果有的话）
      if (item is List) {
        final nestedResult = validateStep(item);
        if (!nestedResult) return false;
      }

      // 处理嵌套映射（如果有的话）
      if (item is Map<String, dynamic>) {
        for (var value in item.values) {
          if (value is List) {
            final nestedResult = validateStep(value);
            if (!nestedResult) return false;
          }
        }
      }
    }

    // 所有检查都通过
    return true;
  }

  // 获取表格所有属性的方法
  Map<String, dynamic> getTableAllProperties(Type type) {
    Map<String, dynamic> back = {
      "TableRow": [],
      "TableColum": [],
    };
    switch (type) {
      case coolingtable:
        back = {
          "TableRow": ["类别", "形式", "流量m³/h", "扬程m"],
          "TableColum": [
            [
              "冷冻水泵",
              form['chilledWaterPumpForm']?.val,
              form['chilledWaterPumpFlow']?.val,
              form['chilledWaterPumpHead']?.val,
            ],
            [
              "冷却水泵",
              form['coolingWaterPumpForm']?.val,
              form['coolingWaterPumpFlow']?.val,
              form['coolingWaterPumpHead']?.val,
            ],
            [
              "冷却塔",
              form['coolingTowerForm']?.val,
              form['coolingTowerFlow']?.val,
              form['coolingTowerHead']?.val,
            ],
          ]
        };
        break;
      case coolingWatertable:
        back = {
          "TableRow": ["项目", "PH值", "电导率", "是否清澈"],
          "TableColum": [
            [
              "冷冻水",
              form['chilledWaterPH']?.val,
              form['chilledWaterConductivity']?.val,
              form['isChilledWaterClear']?.val,
            ],
            [
              "冷却水",
              form['coolingWaterPH']?.val,
              form['coolingWaterConductivity']?.val,
              form['isCoolingWaterClear']?.val,
            ],
          ]
        };
        break;
      default:
    }
    return back;
  }

  InstallController(initialData) {
    form = InstallationInfo.fromJson(initialData ?? {}, isPreSetByKey: false);
    step1 = [
      form['projectCode'],
      form['projectName'],
      form['projectLocal'],
      // form['productCode'],
      form['debugModel'],
    ];
    step2 = [
      form['customerName'],
      form['customerPhone'],
      form['installationAddress'],
      form['unitModel'],
      form['controlProgramVersion'],
      form['touchscreenProgramVersion'],
      form['expansionValveControllerVersion'],
      form['productSn'],
      form['powerSupply'],
      form['factoryTime'],
      form['debugTime'],
    ];
    switchDebugModel(form['debugModel'].val);
    step4 = [
      8,
      '其他检查事项',
      form['customerTargetTemperature'],
      form['userSideSupplyVoltagePhase1'],
      form['userSideSupplyVoltagePhase2'],
      form['userSideSupplyVoltagePhase3'],
      form['chilledWaterInletOutletPressureDifference'],
      form['coolingWaterInletOutletPressureDifference'],
      form['unitVibrationNoiseCheck'],
      form['fluorideSideFilterTemperatureDifference'],
      Text(
        "（平稳运行状态下，温差应低于5℃）",
        style: tip,
      ),
      Text(
        "常规机组正常运行状态下蒸发压力正常范围220~400kPa,冷凝压力正常范围700~1000kPa。平稳运行状态下，换热器端温差应小于3℃℃，高于此温差时，换热器换热效率降低，需进行清洗，建议最长一年清洗一次，如果水质较差，清洗频次需增加。敬请关注日常水系统水质管理。(注:换热器清洗属于有偿服务项目。)",
        style: tip,
      ),
      8,
      const SizedBox(height: 16),
      form['userFeedback'],
      form['onSiteTrainingEffect'],
      form['problemsAndSolutions'],
      8,
      '机组状态评价及整改建议',
      form['preStartupCheckStatus'],
      form['preStartupCheckDetails'],
      form['operationStatus'],
      form['operationDetails'],
      form['otherMatters'],
    ];

    step5 = [
      form['mideaServicePersonName'],
      form['mideaServicePersonPhone'],
      form['mideaServiceSignatureDate'],
      form['mideaServiceSignature'],
      form['customerRepresentativeName'],
      form['customerRepresentativePhone'],
      form['customerSignatureDate'],
      form['customerSignature'],
    ];
  }

  @override
  void onInit() {
    super.onInit();
  }
}

TextStyle tip =
    const TextStyle(color: Color.fromRGBO(102, 102, 102, 1), fontSize: 12);
