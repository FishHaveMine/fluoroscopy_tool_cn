import 'package:easy_localization/easy_localization.dart';

/** 本地功能参数设置的配置属性 */
var typeSettingBase = {
  0: {
    0: {
      "priorModeSetting": {
        "type": "select",
        "val": "",
        "op": selectMap["priorModeSetting"]
      },
      "silentMode": {"type": "select", "val": 1, "op": selectMap["silentMode"]},
      "fallSetting": {
        // 自动模式制冷制热温差设定
        "type": "input",
        "val": "",
      },
      "silenceModeNight": {
        "type": "select",
        "val": "",
        "op": selectMap["silenceModeNight"]
      },
      "timeSetting": {
        "type": "select",
        "val": "",
        "op": selectMap["timeSetting"]
      },
    },
    1: {
      "outdoorPriorAutoT4Setting": {
        "type": "input",
        "val": "",
      },
      "compressorRestartWaitTime": {
        "type": "select",
        "val": "",
        "op": selectMap["compressorRestartWaitTime"]
      },
      "lowNoiseDefrostSetting": {
        "type": "select",
        "val": "",
        "op": selectMap["lowNoiseDefrostSetting"]
      },
      "taketurnsSetting": {
        "type": "select",
        "val": "",
        "op": selectMap["taketurnsSetting"]
      },
    },
    2: {
      "powerLimit": {
        "type": "select",
        "val": "",
        "op": selectMap["powerLimit"]
      },
      "tecChoice": {"type": "select", "val": "", "op": selectMap["tecChoice"]},
      // "mpcSelect1": {
      //   "type": "select",
      //   "val": "",
      //   "op": selectMap["mpcSelect1"]
      // },
      "fanEnergySaving": {
        "type": "select",
        "val": "",
        "op": selectMap["fanEnergySaving"],
        "disable": (data) {
          return data == null || (data == null && data != "OduType_9");
        }
      },

      "mpc": {"type": "select", "val": "", "op": selectMap["mpc"]},
      "mpcSelect3": {
        "type": "select",
        "val": "",
        "op": selectMap["mpcSelect3"],
        "visabel": (date, set) {
          if (set["mpc"] != null) {
            return set["mpc"] == 1;
          }
          if (date["mpc"] == null) {
            return false;
          }
          return date["mpc"]['val'] == "SETTING_ENUM_1" ||
              date["mpc"]['val'] == 1;
        },
      },
      "mpcSelect4": {
        "type": "select",
        "val": "",
        "op": selectMap["mpcSelect4"],
        "visabel": (date, set) {
          if (set["mpc"] != null) {
            return set["mpc"] == 1;
          }
          if (date["mpc"] == null) {
            return false;
          }
          return date["mpc"]['val'] == "SETTING_ENUM_1" ||
              date["mpc"]['val'] == 1;
        },
      },
      "dryContactInputSetting1": {
        "type": "select",
        "val": "",
        "op": selectMap["dryContactInputSetting1"]
      },
      "dryContactInputSetting2": {
        "type": "select",
        "val": "",
        "op": selectMap["dryContactInputSetting2"]
      },
      // "dryContactInputSetting3": {
      //   "type": "select",
      //   "val": "",
      //   "op": selectMap["dryContactInputSetting3"]
      // },

      "outputDryContact1": {
        "type": "select",
        "val": "",
        "op": selectMap["outputDryContact1"],
        "disable": (data) {
          return data == null || (data == null && data != "OduType_9");
        }
      },
      "outputDryContact2": {
        "type": "select",
        "val": "",
        "op": selectMap["outputDryContact2"],
        "disable": (data) {
          return data == null || (data == null && data != "OduType_9");
        }
      },
      "outputDryContact3": {
        "type": "select",
        "val": "",
        "op": selectMap["outputDryContact3"]
      },
    },
    3: {
      // "emergenceStop": {
      //   "type": "select",
      //   "val": "",
      //   "op": selectMap["emergenceStop"]
      // },

      "antiSnowSetting": {
        "type": "select",
        "val": "",
        "op": selectMap["antiSnowSetting"]
      },
      "backupSensor": {
        "type": "select",
        "val": "",
        "op": selectMap["backupSensor"]
      },
      "backupRunDays": {
        "type": "select",
        "val": "",
        "op": selectMap["backupRunDays"]
      },

      "chassisIceFunction": {
        "type": "select",
        "val": "",
        "op": selectMap["chassisIceFunction"]
      },
      "humidityControl": {
        "type": "select",
        "val": "",
        "op": selectMap["humiditycontrol"]
      },
      "factoryMeter": {
        "type": "select",
        "val": "",
        "op": selectMap["factorymeter"]
      },
      "xyeBaudRate": {
        "type": "select",
        "val": "",
        "op": selectMap["xyebaudrate"]
      },

      "chargingElectricMeterEnum": {
        "type": "select",
        "val": "",
        "op": selectMap["chargingElectricMeterEnum"]
      },

      "firmwareVersion": {
        "type": "select",
        "val": "",
        "op": selectMap["firmwareVersion"]
      },

      "upgradeMethodEnum": {
        "type": "select",
        "val": "",
        "op": selectMap["upgradeMethodEnum"]
      },

      "modbusAddress": {
        // 自动模式制冷制热温差设定
        "type": "input",
        "val": "",
      },
    },
    4: {
      "sprayEnabling": {
        "type": "select",
        "val": "",
        "op": selectMap["sprayEnabling"]
      },
      "sprayLevelSetting": {
        "type": "select",
        "val": "",
        "visabel": (date, set) {
          bool checkSprayEnabling(Map set, Map date) {
            if (set["sprayEnabling"] != null) {
              return set["sprayEnabling"] == 1;
            }
            if (date["sprayEnabling"] == null) {
              return false;
            }
            return date["sprayEnabling"]['val'] == "SETTING_ENUM_1" ||
                date["sprayEnabling"]['val'] == 1;
          }

          bool ispassBefore = checkSprayEnabling(set, date);
          if (ispassBefore) {
            if (set["sprayOpen"] != null) {
              return set["sprayOpen"] == 1;
            }
            if (date["sprayOpen"] == null) {
              return false;
            }
            return date["sprayOpen"]['val'] == "SETTING_ENUM_1" ||
                date["sprayOpen"]['val'] == 1;
          } else {
            return false;
          }
        },
        "op": selectMap["sprayLevelSetting"]
      },
      "sprayOpen": {
        "type": "select",
        "val": "",
        "op": selectMap["sprayOpen"],
        "visabel": (date, set) {
          if (set["sprayEnabling"] != null) {
            return set["sprayEnabling"] == 1;
          }
          if (date["sprayEnabling"] == null) {
            return false;
          }
          return date["sprayEnabling"]['val'] == "SETTING_ENUM_1" ||
              date["sprayEnabling"]['val'] == 1;
        },
      },
      "sprayTempSetting": {
        "type": "input",
        "val": "",
        "visabel": (date, set) {
          bool checkSprayEnabling(Map set, Map date) {
            if (set["sprayEnabling"] != null) {
              return set["sprayEnabling"] == 1;
            }
            if (date["sprayEnabling"] == null) {
              return false;
            }
            return date["sprayEnabling"]['val'] == "SETTING_ENUM_1" ||
                date["sprayEnabling"]['val'] == 1;
          }

          bool ispassBefore = checkSprayEnabling(set, date);
          if (ispassBefore) {
            if (set["sprayOpen"] != null) {
              return set["sprayOpen"] == 1;
            }
            if (date["sprayOpen"] == null) {
              return false;
            }
            return date["sprayOpen"]['val'] == "SETTING_ENUM_1" ||
                date["sprayOpen"]['val'] == 1;
          } else {
            return false;
          }
        },
      }
    }
  },
  1: {
    0: {
      "indoorStaticPressureSetting": {
        //室内机静压设置
        "type": "select",
        "val": "",
        "op": selectMap["indoorStaticPressureSetting"]
      },
      "lockLineControl": {
        // 锁定线控
        "type": "select",
        "val": "",
        "op": selectMap["lockLineControl"]
      },
      "buzzerSetting": {
        // 室内机蜂鸣器是否响
        "type": "select",
        "val": "",
        "op": selectMap["buzzerSetting"]
      },
      "displayBoardLightSetting": {
        // 灯光（显示板）设定
        "type": "select",
        "val": "",
        "op": selectMap["displayBoardLightSetting"]
      },
      "autoModeSwitchTime": {
        // 自动模式下模式切换时间间隔
        "type": "select",
        "val": "",
        "op": selectMap["autoModeSwitchTime"]
      },
      "autoModeD2": {
        // 自动模式制冷制热温差设定
        "type": "input",
        "val": "",
      },
      "elecHeaterT4": {
        // 电辅热开启条件室外温度设置值
        "type": "input",
        "val": "",
      },
    },
    1: {
      "elecHeatingTempT1Setting": {
        "type": "input",
        "val": "",
      },
      "elecHeatingOpenDisTemp": {
        "type": "select",
        "val": "",
        "op": selectMap["elecHeatingOpenDisTemp"]
      },
      "elecHeatingCloseDisTemp": {
        "type": "select",
        "val": "",
        "op": selectMap["elecHeatingCloseDisTemp"]
      },
      "independentElectHeating": {
        "type": "select",
        "val": "",
        "op": selectMap["independentElectHeating"]
      },
      "dehumidityStandbyFanSpeed": {
        "type": "select",
        "val": "",
        "op": selectMap["dehumidityStandbyFanSpeed"]
      },
      "termalStopFanTime": {
        "type": "select",
        "val": "",
        "op": selectMap["termalStopFanTime"]
      },
      "coolingAutoFanSpeedUpperLimit": {
        "type": "select",
        "val": "",
        "op": selectMap["coolingAutoFanSpeedUpperLimit"]
      },
      "heatingAutoFanSpeedUpperLimit": {
        "type": "select",
        "val": "",
        "op": selectMap["heatingAutoFanSpeedUpperLimit"]
      },
      "constantAirVolumeSetting": {
        "type": "select",
        "val": "",
        "op": selectMap["constantAirVolumeSetting"]
      },
      "highPatioCorrectionFactor": {
        "type": "select",
        "val": "",
        "op": selectMap["highPatioCorrectionFactor"]
      },
      "independentSwing1Sel": {
        "type": "select",
        "val": "",
        "op": selectMap["independentSwing1Sel"]
      },
      "independentSwing2Sel": {
        "type": "select",
        "val": "",
        "op": selectMap["independentSwing1Sel"]
      },
      "independentSwing3Sel": {
        "type": "select",
        "val": "",
        "op": selectMap["independentSwing1Sel"]
      },
      "independentSwing4Sel": {
        "type": "select",
        "val": "",
        "op": selectMap["independentSwing1Sel"]
      },
      "multipleControlSetting": {
        "type": "select",
        "val": "",
        "op": selectMap["multipleControlSetting"]
      },
      "remoteShutdownSetting": {
        "type": "select",
        "val": "",
        "op": selectMap["remoteShutdownSetting"]
      },
      "remoteOnOffDelayTime": {
        "type": "select",
        "val": "",
        "op": selectMap["remoteOnOffDelayTime"]
      },
      "indoorAlarmSetting": {
        "type": "select",
        "val": "",
        "op": selectMap["indoorAlarmSetting"]
      },
      "preheatingOpenTemp": {
        "type": "select",
        "val": "",
        "op": selectMap["preheatingOpenTemp"]
      },
      "remoteShutdownExitMode": {
        "type": "select",
        "val": "",
        "op": selectMap["remoteShutdownExitMode"]
      },
      "coolingTempCompensation": {
        "type": "select",
        "val": "",
        "op": selectMap["coolingTempCompensation"]
      },
      "heatingTempCompensation": {
        "type": "select",
        "val": "",
        "op": selectMap["heatingTempCompensation"]
      },
    },
    2: {
      "isSterilizing": {
        "type": "text",
        "val": "",
      },
      "sterilizationSetting": {
        "type": "select",
        "val": "",
        "op": selectMap["sterilizationSetting"]
      },
      "selfCleanDryingTimeSetting": {
        "type": "select",
        "val": "",
        "op": selectMap["selfCleanDryingTimeSetting"]
      },
      "antiMouldyBlowTimeSetting": {
        "type": "select",
        "val": "",
        "op": selectMap["antiMouldyBlowTimeSetting"]
      },
      "antiBlowDirtyCeilingSetting": {
        "type": "select",
        "val": "",
        "op": selectMap["antiBlowDirtyCeilingSetting"]
      },
      "antiCondensationSetting": {
        "type": "select",
        "val": "",
        "op": selectMap["antiCondensationSetting"]
      },
      "humanSensorNomanTime": {
        "type": "select",
        "val": "",
        "op": selectMap["humanSensorNomanTime"]
      },
      "humanSensorDiffTemp": {
        "type": "select",
        "val": "",
        "op": selectMap["humanSensorDiffTemp"]
      },
      "nomanStopDelayTimeSetting": {
        "type": "select",
        "val": "",
        "op": selectMap["nomanStopDelayTimeSetting"]
      },
      "coolingMpcLevel": {
        "type": "select",
        "val": "",
        "op": selectMap["coolingMpcLevel"]
      },
      "heatingMpcLevel": {
        "type": "select",
        "val": "",
        "op": selectMap["heatingMpcLevel"]
      },
      "powerDownSetting": {
        "type": "select",
        "val": "",
        "op": selectMap["powerDownSetting"]
      },
    },
    3: {
      "heatingIdleOpenningSetting": {
        "type": "select",
        "val": "",
        "op": selectMap["heatingIdleOpenningSetting"]
      },
      "fieldCorrectionFactor": {
        "type": "select",
        "val": "",
        "op": selectMap["fieldCorrectionFactor"]
      },
      "diffPressureStartToEnd": {
        "type": "select",
        "val": "",
        "op": selectMap["diffPressureStartToEnd"]
      },
      "openDegreeOfOilReturnSet": {
        "type": "select",
        "val": "",
        "op": selectMap["openDegreeOfOilReturnSet"]
      }
    }
  }
};

/** 本地功能参数设置的配置属性 枚举项 */
var selectMap = {
  "priorModeSetting": [
    {
      'label': "自动优先",
      'name': "自动优先",
      'value1': "MpcPriorModeSetting_0",
      "value": 0
    },
    {
      'label': "制冷优先",
      'name': "制冷优先",
      'value1': "MpcPriorModeSetting_1",
      "value": 1
    },
    {
      'label': "VIP优先",
      'name': "VIP优先",
      'value1': "MpcPriorModeSetting_2",
      "value": 2
    },
    {
      'label': "只制热",
      'name': "只制热",
      'value1': "MpcPriorModeSetting_3",
      "value": 3
    },
    {
      'label': "只制冷",
      'name': "只制冷",
      'value1': "MpcPriorModeSetting_4",
      "value": 4
    },
    {
      'label': "制热优先",
      'name': "制热优先",
      'value1': "MpcPriorModeSetting_5",
      "value": 5
    },
    {
      'label': "ChangeOver",
      'name': "ChangeOver",
      'value1': "MpcPriorModeSetting_6",
      "value": 6
    },
    {
      'label': "多开优先",
      'name': "多开优先",
      'value1': "MpcPriorModeSetting_7",
      "value": 7
    },
    {
      'label': "先开优先",
      'name': "先开优先",
      'value1': "MpcPriorModeSetting_8",
      "value": 8
    },
    {
      'label': "能需优先",
      'name': "能需优先",
      'value1': "MpcPriorModeSetting_14",
      "value": 14
    }
  ],
  "silenceModeNight": List.generate(
    14,
    (index) => {
      'label': "夜间静音模式$index",
      'name': "夜间静音模式$index",
      'value1': "SETTING_ENUM_$index",
      "value": index
    },
  ),
  "timeSetting": [
    {"label": "无夜间静音", "name": "无夜间静音", "value1": "NONE", "value": 0},
    {"label": "1-6h/10h", "name": "1-6h/10h", "value1": "ONE_HOUR", "value": 1},
    {"label": "2-6h/12h", "name": "2-6h/12h", "value1": "TWO_HOUR", "value": 2},
    {
      "label": "3-8h/10h",
      "name": "3-8h/10h",
      "value1": "THREE_HOUR",
      "value": 3
    },
    {"label": "4-8/12h", "name": "4-8/12h", "value1": "FOUR_HOUR", "value": 4},
    {
      "label": "15维持不变",
      "name": "15维持不变",
      "value1": "FIFTEEN_HOUR",
      "value": 15
    },
  ],
  "indoorStaticPressureSetting": List.generate(
    20,
    (index) => {
      'label': "${index > 10 ? index : '$index'}",
      'name': "${index > 10 ? index : '$index'}",
      'value1': "$index",
      "value": index
    },
  ),
  "silentMode": [
    {
      "label": tr("setting_silentMode0"),
      "name": tr("setting_silentMode0"),
      "value1": "SilenceMode_0",
      "value": 0
    },
    {
      "label": tr("setting_silentMode1"),
      "name": tr("setting_silentMode1"),
      "value1": "SilenceMode_1",
      "value": 1
    },
    {
      "label": tr("setting_silentMode2"),
      "name": tr("setting_silentMode2"),
      "value1": "SilenceMode_2",
      "value": 2
    },
    {
      "label": tr("setting_silentMode3"),
      "name": tr("setting_silentMode3"),
      "value1": "SilenceMode_3",
      "value": 3
    },
    {
      "label": tr("setting_silentMode4"),
      "name": tr("setting_silentMode4"),
      "value1": "SilenceMode_4",
      "value": 4
    },
    {
      "label": tr("setting_silentMode5"),
      "name": tr("setting_silentMode5"),
      "value1": "SilenceMode_5",
      "value": 5
    },
    {
      "label": tr("setting_silentMode6"),
      "name": tr("setting_silentMode6"),
      "value1": "SilenceMode_6",
      "value": 6
    },
    {
      "label": tr("setting_silentMode7"),
      "name": tr("setting_silentMode7"),
      "value1": "SilenceMode_7",
      "value": 7
    },
    {
      "label": tr("setting_silentMode8"),
      "name": tr("setting_silentMode8"),
      "value1": "SilenceMode_8",
      "value": 8
    },
    {
      "label": tr("setting_silentMode9"),
      "name": tr("setting_silentMode9"),
      "value1": "SilenceMode_9",
      "value": 9
    },
    {
      "label": tr("setting_silentMode10"),
      "name": tr("setting_silentMode10"),
      "value1": "SilenceMode_10",
      "value": 10
    },
    {
      "label": tr("setting_silentMode11"),
      "name": tr("setting_silentMode11"),
      "value1": "SilenceMode_11",
      "value": 11
    },
    {
      "label": tr("setting_silentMode12"),
      "name": tr("setting_silentMode12"),
      "value1": "SilenceMode_12",
      "value": 12
    },
    {
      "label": tr("setting_silentMode13"),
      "name": tr("setting_silentMode13"),
      "value1": "SilenceMode_13",
      "value": 13
    },
    {
      "label": tr("setting_silentMode14"),
      "name": tr("setting_silentMode14"),
      "value1": "SilenceMode_14",
      "value": 14
    }
  ],
  "compressorRestartWaitTime": [
    {
      "label": tr("setting_compressorRestartWaitTime0"),
      "name": tr("setting_compressorRestartWaitTime0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_compressorRestartWaitTime1"),
      "name": tr("setting_compressorRestartWaitTime1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_compressorRestartWaitTime2"),
      "name": tr("setting_compressorRestartWaitTime2"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    }
  ],
  "lowNoiseDefrostSetting": [
    {
      "label": tr("setting_lowNoiseDefrostSetting0"),
      "name": tr("setting_lowNoiseDefrostSetting0"),
      "value1": "NOT_STOP",
      "value": 0
    },
    {
      "label": tr("setting_lowNoiseDefrostSetting1"),
      "name": tr("setting_lowNoiseDefrostSetting1"),
      "value1": "STOP",
      "value": 1
    }
  ],
  "taketurnsSetting": [
    {
      "label": tr("setting_taketurnsSetting0"),
      "name": tr("setting_taketurnsSetting0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_taketurnsSetting1"),
      "name": tr("setting_taketurnsSetting1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_taketurnsSetting2"),
      "name": tr("setting_taketurnsSetting2"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    },
    {
      "label": tr("setting_taketurnsSetting3"),
      "name": tr("setting_taketurnsSetting3"),
      "value1": "SETTING_ENUM_3",
      "value": 3
    }
  ],
  "powerLimit": [
    {
      "label": tr("setting_powerLimit40"),
      "name": tr("setting_powerLimit40"),
      "value1": "PowerLimit_40",
      "value": 40
    },
    {
      "label": tr("setting_powerLimit41"),
      "name": tr("setting_powerLimit41"),
      "value1": "PowerLimit_41",
      "value": 41
    },
    {
      "label": tr("setting_powerLimit42"),
      "name": tr("setting_powerLimit42"),
      "value1": "PowerLimit_42",
      "value": 42
    },
    {
      "label": tr("setting_powerLimit43"),
      "name": tr("setting_powerLimit43"),
      "value1": "PowerLimit_43",
      "value": 43
    },
    {
      "label": tr("setting_powerLimit44"),
      "name": tr("setting_powerLimit44"),
      "value1": "PowerLimit_44",
      "value": 44
    },
    {
      "label": tr("setting_powerLimit45"),
      "name": tr("setting_powerLimit45"),
      "value1": "PowerLimit_45",
      "value": 45
    },
    {
      "label": tr("setting_powerLimit46"),
      "name": tr("setting_powerLimit46"),
      "value1": "PowerLimit_46",
      "value": 46
    },
    {
      "label": tr("setting_powerLimit47"),
      "name": tr("setting_powerLimit47"),
      "value1": "PowerLimit_47",
      "value": 47
    },
    {
      "label": tr("setting_powerLimit48"),
      "name": tr("setting_powerLimit48"),
      "value1": "PowerLimit_48",
      "value": 48
    },
    {
      "label": tr("setting_powerLimit49"),
      "name": tr("setting_powerLimit49"),
      "value1": "PowerLimit_49",
      "value": 49
    },
    {
      "label": tr("setting_powerLimit50"),
      "name": tr("setting_powerLimit50"),
      "value1": "PowerLimit_50",
      "value": 50
    },
    {
      "label": tr("setting_powerLimit51"),
      "name": tr("setting_powerLimit51"),
      "value1": "PowerLimit_51",
      "value": 51
    },
    {
      "label": tr("setting_powerLimit52"),
      "name": tr("setting_powerLimit52"),
      "value1": "PowerLimit_52",
      "value": 52
    },
    {
      "label": tr("setting_powerLimit53"),
      "name": tr("setting_powerLimit53"),
      "value1": "PowerLimit_53",
      "value": 53
    },
    {
      "label": tr("setting_powerLimit54"),
      "name": tr("setting_powerLimit54"),
      "value1": "PowerLimit_54",
      "value": 54
    },
    {
      "label": tr("setting_powerLimit55"),
      "name": tr("setting_powerLimit55"),
      "value1": "PowerLimit_55",
      "value": 55
    },
    {
      "label": tr("setting_powerLimit56"),
      "name": tr("setting_powerLimit56"),
      "value1": "PowerLimit_56",
      "value": 56
    },
    {
      "label": tr("setting_powerLimit57"),
      "name": tr("setting_powerLimit57"),
      "value1": "PowerLimit_57",
      "value": 57
    },
    {
      "label": tr("setting_powerLimit58"),
      "name": tr("setting_powerLimit58"),
      "value1": "PowerLimit_58",
      "value": 58
    },
    {
      "label": tr("setting_powerLimit59"),
      "name": tr("setting_powerLimit59"),
      "value1": "PowerLimit_59",
      "value": 59
    },
    {
      "label": tr("setting_powerLimit60"),
      "name": tr("setting_powerLimit60"),
      "value1": "PowerLimit_60",
      "value": 60
    },
    {
      "label": tr("setting_powerLimit61"),
      "name": tr("setting_powerLimit61"),
      "value1": "PowerLimit_61",
      "value": 61
    },
    {
      "label": tr("setting_powerLimit62"),
      "name": tr("setting_powerLimit62"),
      "value1": "PowerLimit_62",
      "value": 62
    },
    {
      "label": tr("setting_powerLimit63"),
      "name": tr("setting_powerLimit63"),
      "value1": "PowerLimit_63",
      "value": 63
    },
    {
      "label": tr("setting_powerLimit64"),
      "name": tr("setting_powerLimit64"),
      "value1": "PowerLimit_64",
      "value": 64
    },
    {
      "label": tr("setting_powerLimit65"),
      "name": tr("setting_powerLimit65"),
      "value1": "PowerLimit_65",
      "value": 65
    },
    {
      "label": tr("setting_powerLimit66"),
      "name": tr("setting_powerLimit66"),
      "value1": "PowerLimit_66",
      "value": 66
    },
    {
      "label": tr("setting_powerLimit67"),
      "name": tr("setting_powerLimit67"),
      "value1": "PowerLimit_67",
      "value": 67
    },
    {
      "label": tr("setting_powerLimit68"),
      "name": tr("setting_powerLimit68"),
      "value1": "PowerLimit_68",
      "value": 68
    },
    {
      "label": tr("setting_powerLimit69"),
      "name": tr("setting_powerLimit69"),
      "value1": "PowerLimit_69",
      "value": 69
    },
    {
      "label": tr("setting_powerLimit70"),
      "name": tr("setting_powerLimit70"),
      "value1": "PowerLimit_70",
      "value": 70
    },
    {
      "label": tr("setting_powerLimit71"),
      "name": tr("setting_powerLimit71"),
      "value1": "PowerLimit_71",
      "value": 71
    },
    {
      "label": tr("setting_powerLimit72"),
      "name": tr("setting_powerLimit72"),
      "value1": "PowerLimit_72",
      "value": 72
    },
    {
      "label": tr("setting_powerLimit73"),
      "name": tr("setting_powerLimit73"),
      "value1": "PowerLimit_73",
      "value": 73
    },
    {
      "label": tr("setting_powerLimit74"),
      "name": tr("setting_powerLimit74"),
      "value1": "PowerLimit_74",
      "value": 74
    },
    {
      "label": tr("setting_powerLimit75"),
      "name": tr("setting_powerLimit75"),
      "value1": "PowerLimit_75",
      "value": 75
    },
    {
      "label": tr("setting_powerLimit76"),
      "name": tr("setting_powerLimit76"),
      "value1": "PowerLimit_76",
      "value": 76
    },
    {
      "label": tr("setting_powerLimit77"),
      "name": tr("setting_powerLimit77"),
      "value1": "PowerLimit_77",
      "value": 77
    },
    {
      "label": tr("setting_powerLimit78"),
      "name": tr("setting_powerLimit78"),
      "value1": "PowerLimit_78",
      "value": 78
    },
    {
      "label": tr("setting_powerLimit79"),
      "name": tr("setting_powerLimit79"),
      "value1": "PowerLimit_79",
      "value": 79
    },
    {
      "label": tr("setting_powerLimit80"),
      "name": tr("setting_powerLimit80"),
      "value1": "PowerLimit_80",
      "value": 80
    },
    {
      "label": tr("setting_powerLimit81"),
      "name": tr("setting_powerLimit81"),
      "value1": "PowerLimit_81",
      "value": 81
    },
    {
      "label": tr("setting_powerLimit82"),
      "name": tr("setting_powerLimit82"),
      "value1": "PowerLimit_82",
      "value": 82
    },
    {
      "label": tr("setting_powerLimit83"),
      "name": tr("setting_powerLimit83"),
      "value1": "PowerLimit_83",
      "value": 83
    },
    {
      "label": tr("setting_powerLimit84"),
      "name": tr("setting_powerLimit84"),
      "value1": "PowerLimit_84",
      "value": 84
    },
    {
      "label": tr("setting_powerLimit85"),
      "name": tr("setting_powerLimit85"),
      "value1": "PowerLimit_85",
      "value": 85
    },
    {
      "label": tr("setting_powerLimit86"),
      "name": tr("setting_powerLimit86"),
      "value1": "PowerLimit_86",
      "value": 86
    },
    {
      "label": tr("setting_powerLimit87"),
      "name": tr("setting_powerLimit87"),
      "value1": "PowerLimit_87",
      "value": 87
    },
    {
      "label": tr("setting_powerLimit88"),
      "name": tr("setting_powerLimit88"),
      "value1": "PowerLimit_88",
      "value": 88
    },
    {
      "label": tr("setting_powerLimit89"),
      "name": tr("setting_powerLimit89"),
      "value1": "PowerLimit_89",
      "value": 89
    },
    {
      "label": tr("setting_powerLimit90"),
      "name": tr("setting_powerLimit90"),
      "value1": "PowerLimit_90",
      "value": 90
    },
    {
      "label": tr("setting_powerLimit91"),
      "name": tr("setting_powerLimit91"),
      "value1": "PowerLimit_91",
      "value": 91
    },
    {
      "label": tr("setting_powerLimit92"),
      "name": tr("setting_powerLimit92"),
      "value1": "PowerLimit_92",
      "value": 92
    },
    {
      "label": tr("setting_powerLimit93"),
      "name": tr("setting_powerLimit93"),
      "value1": "PowerLimit_93",
      "value": 93
    },
    {
      "label": tr("setting_powerLimit94"),
      "name": tr("setting_powerLimit94"),
      "value1": "PowerLimit_94",
      "value": 94
    },
    {
      "label": tr("setting_powerLimit95"),
      "name": tr("setting_powerLimit95"),
      "value1": "PowerLimit_95",
      "value": 95
    },
    {
      "label": tr("setting_powerLimit96"),
      "name": tr("setting_powerLimit96"),
      "value1": "PowerLimit_96",
      "value": 96
    },
    {
      "label": tr("setting_powerLimit97"),
      "name": tr("setting_powerLimit97"),
      "value1": "PowerLimit_97",
      "value": 97
    },
    {
      "label": tr("setting_powerLimit98"),
      "name": tr("setting_powerLimit98"),
      "value1": "PowerLimit_98",
      "value": 98
    },
    {
      "label": tr("setting_powerLimit99"),
      "name": tr("setting_powerLimit99"),
      "value1": "PowerLimit_99",
      "value": 99
    },
    {
      "label": tr("setting_powerLimit100"),
      "name": tr("setting_powerLimit100"),
      "value1": "PowerLimit_100",
      "value": 100
    }
  ],
  "antiSnowSetting": [
    {
      "label": tr("setting_antiSnowSetting0"),
      "name": tr("setting_antiSnowSetting0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_antiSnowSetting1"),
      "name": tr("setting_antiSnowSetting1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_antiSnowSetting2"),
      "name": tr("setting_antiSnowSetting2"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    }
  ],
  "backupSensor": [
    {
      "label": tr("setting_backupSensor0"),
      "name": tr("setting_backupSensor0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_backupSensor1"),
      "name": tr("setting_backupSensor1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_backupSensor2"),
      "name": tr("setting_backupSensor2"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    }
  ],
  "backupRunDays": [
    {
      "label": tr("setting_backupRunDays1"),
      "name": tr("setting_backupRunDays1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_backupRunDays2"),
      "name": tr("setting_backupRunDays2"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    },
    {
      "label": tr("setting_backupRunDays3"),
      "name": tr("setting_backupRunDays3"),
      "value1": "SETTING_ENUM_3",
      "value": 3
    },
    {
      "label": tr("setting_backupRunDays4"),
      "name": tr("setting_backupRunDays4"),
      "value1": "SETTING_ENUM_4",
      "value": 4
    },
    {
      "label": tr("setting_backupRunDays5"),
      "name": tr("setting_backupRunDays5"),
      "value1": "SETTING_ENUM_5",
      "value": 5
    },
    {
      "label": tr("setting_backupRunDays6"),
      "name": tr("setting_backupRunDays6"),
      "value1": "SETTING_ENUM_6",
      "value": 6
    },
    {
      "label": tr("setting_backupRunDays7"),
      "name": tr("setting_backupRunDays7"),
      "value1": "SETTING_ENUM_7",
      "value": 7
    }
  ],
  "tecChoice": [
    {
      "label": tr("setting_tecChoice0"),
      "name": tr("setting_tecChoice0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_tecChoice1"),
      "name": tr("setting_tecChoice1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_tecChoice2"),
      "name": tr("setting_tecChoice2"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    }
  ],
  "mpc": [
    {
      "label": tr("setting_mpc0"),
      "name": tr("setting_mpc0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_mpc1"),
      "name": tr("setting_mpc1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    }
  ],
  "lockLineControl": [
    {
      "label": tr("setting_lockLineControlFalse"),
      "name": tr("setting_lockLineControlFalse"),
      "value1": "SETTING_ENUM_0",
      "value": false
    },
    {
      "label": tr("setting_lockLineControlTrue"),
      "name": tr("setting_lockLineControlTrue"),
      "value1": "SETTING_ENUM_1",
      "value": true
    }
  ],
  "mpcSelect3": [
    {
      "label": tr("setting_mpcSelect30"),
      "name": tr("setting_mpcSelect30"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_mpcSelect31"),
      "name": tr("setting_mpcSelect31"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_mpcSelect32"),
      "name": tr("setting_mpcSelect32"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    }
  ],
  "mpcSelect4": [
    {
      "label": tr("setting_mpcSelect40"),
      "name": tr("setting_mpcSelect40"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_mpcSelect41"),
      "name": tr("setting_mpcSelect41"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_mpcSelect42"),
      "name": tr("setting_mpcSelect42"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    }
  ],
  "dryContactInputSetting1": [
    {
      "label": tr("setting_dryContactInputSetting10"),
      "name": tr("setting_dryContactInputSetting10"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_dryContactInputSetting11"),
      "name": tr("setting_dryContactInputSetting11"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_dryContactInputSetting12"),
      "name": tr("setting_dryContactInputSetting12"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    },
    {
      "label": tr("setting_dryContactInputSetting13"),
      "name": tr("setting_dryContactInputSetting13"),
      "value1": "SETTING_ENUM_3",
      "value": 3
    }
  ],
  "dryContactInputSetting2": [
    {
      "label": tr("setting_dryContactInputSetting20"),
      "name": tr("setting_dryContactInputSetting20"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_dryContactInputSetting21"),
      "name": tr("setting_dryContactInputSetting21"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_dryContactInputSetting22"),
      "name": tr("setting_dryContactInputSetting22"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    },
    {
      "label": tr("setting_dryContactInputSetting23"),
      "name": tr("setting_dryContactInputSetting23"),
      "value1": "SETTING_ENUM_3",
      "value": 3
    }
  ],
  "dryContactInputSetting3": [
    {
      "label": tr("setting_dryContactInputSetting30"),
      "name": tr("setting_dryContactInputSetting30"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_dryContactInputSetting31"),
      "name": tr("setting_dryContactInputSetting31"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_dryContactInputSetting32"),
      "name": tr("setting_dryContactInputSetting32"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    },
    {
      "label": tr("setting_dryContactInputSetting33"),
      "name": tr("setting_dryContactInputSetting33"),
      "value1": "SETTING_ENUM_3",
      "value": 3
    },
    {
      "label": tr("setting_dryContactInputSetting34"),
      "name": tr("setting_dryContactInputSetting34"),
      "value1": "SETTING_ENUM_4",
      "value": 4
    }
  ],
  "emergenceStop": [
    {
      "label": tr("setting_emergenceStop0"),
      "name": tr("setting_emergenceStop0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_emergenceStop1"),
      "name": tr("setting_emergenceStop1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    }
  ],
  "sprayEnabling": [
    {
      "label": tr("setting_sprayEnabling0"),
      "name": tr("setting_sprayEnabling0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_sprayEnabling1"),
      "name": tr("setting_sprayEnabling1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    }
  ],
  "sprayLevelSetting": [
    {
      "label": tr("setting_sprayLevelSetting0"),
      "name": tr("setting_sprayLevelSetting0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_sprayLevelSetting1"),
      "name": tr("setting_sprayLevelSetting1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_sprayLevelSetting2"),
      "name": tr("setting_sprayLevelSetting2"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    },
    {
      "label": tr("setting_sprayLevelSetting3"),
      "name": tr("setting_sprayLevelSetting3"),
      "value1": "SETTING_ENUM_3",
      "value": 3
    },
    {
      "label": tr("setting_sprayLevelSetting4"),
      "name": tr("setting_sprayLevelSetting4"),
      "value1": "SETTING_ENUM_4",
      "value": 4
    }
  ],
  "sprayOpen": [
    {
      "label": tr("setting_sprayOpen0"),
      "name": tr("setting_sprayOpen0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_sprayOpen1"),
      "name": tr("setting_sprayOpen1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    }
  ],
  "buzzerSetting": [
    {
      "label": tr("setting_buzzerSetting0"),
      "name": tr("setting_buzzerSetting0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_buzzerSetting1"),
      "name": tr("setting_buzzerSetting1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_buzzerSetting2"),
      "name": tr("setting_buzzerSetting2"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    }
  ],
  "displayBoardLightSetting": [
    {
      "label": tr("setting_displayBoardLightSetting0"),
      "name": tr("setting_displayBoardLightSetting0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_displayBoardLightSetting1"),
      "name": tr("setting_displayBoardLightSetting1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    }
  ],
  "autoModeSwitchTime": [
    {
      "label": tr("setting_autoModeSwitchTime0"),
      "name": tr("setting_autoModeSwitchTime0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_autoModeSwitchTime1"),
      "name": tr("setting_autoModeSwitchTime1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_autoModeSwitchTime2"),
      "name": tr("setting_autoModeSwitchTime2"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    },
    {
      "label": tr("setting_autoModeSwitchTime3"),
      "name": tr("setting_autoModeSwitchTime3"),
      "value1": "SETTING_ENUM_3",
      "value": 3
    }
  ],
  "elecHeatingOpenDisTemp": [
    {
      "label": tr("setting_elecHeatingOpenDisTemp0"),
      "name": tr("setting_elecHeatingOpenDisTemp0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_elecHeatingOpenDisTemp1"),
      "name": tr("setting_elecHeatingOpenDisTemp1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_elecHeatingOpenDisTemp2"),
      "name": tr("setting_elecHeatingOpenDisTemp2"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    },
    {
      "label": tr("setting_elecHeatingOpenDisTemp3"),
      "name": tr("setting_elecHeatingOpenDisTemp3"),
      "value1": "SETTING_ENUM_3",
      "value": 3
    },
    {
      "label": tr("setting_elecHeatingOpenDisTemp4"),
      "name": tr("setting_elecHeatingOpenDisTemp4"),
      "value1": "SETTING_ENUM_4",
      "value": 4
    },
    {
      "label": tr("setting_elecHeatingOpenDisTemp5"),
      "name": tr("setting_elecHeatingOpenDisTemp5"),
      "value1": "SETTING_ENUM_5",
      "value": 5
    },
    {
      "label": tr("setting_elecHeatingOpenDisTemp6"),
      "name": tr("setting_elecHeatingOpenDisTemp6"),
      "value1": "SETTING_ENUM_6",
      "value": 6
    },
    {
      "label": tr("setting_elecHeatingOpenDisTemp7"),
      "name": tr("setting_elecHeatingOpenDisTemp7"),
      "value1": "SETTING_ENUM_7",
      "value": 7
    }
  ],
  "elecHeatingCloseDisTemp": [
    {
      "label": tr("setting_elecHeatingCloseDisTemp0"),
      "name": tr("setting_elecHeatingCloseDisTemp0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_elecHeatingCloseDisTemp1"),
      "name": tr("setting_elecHeatingCloseDisTemp1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_elecHeatingCloseDisTemp2"),
      "name": tr("setting_elecHeatingCloseDisTemp2"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    },
    {
      "label": tr("setting_elecHeatingCloseDisTemp3"),
      "name": tr("setting_elecHeatingCloseDisTemp3"),
      "value1": "SETTING_ENUM_3",
      "value": 3
    },
    {
      "label": tr("setting_elecHeatingCloseDisTemp4"),
      "name": tr("setting_elecHeatingCloseDisTemp4"),
      "value1": "SETTING_ENUM_4",
      "value": 4
    },
    {
      "label": tr("setting_elecHeatingCloseDisTemp5"),
      "name": tr("setting_elecHeatingCloseDisTemp5"),
      "value1": "SETTING_ENUM_5",
      "value": 5
    },
    {
      "label": tr("setting_elecHeatingCloseDisTemp6"),
      "name": tr("setting_elecHeatingCloseDisTemp6"),
      "value1": "SETTING_ENUM_6",
      "value": 6
    },
    {
      "label": tr("setting_elecHeatingCloseDisTemp7"),
      "name": tr("setting_elecHeatingCloseDisTemp7"),
      "value1": "SETTING_ENUM_7",
      "value": 7
    },
    {
      "label": tr("setting_elecHeatingCloseDisTemp8"),
      "name": tr("setting_elecHeatingCloseDisTemp8"),
      "value1": "SETTING_ENUM_8",
      "value": 8
    },
    {
      "label": tr("setting_elecHeatingCloseDisTemp9"),
      "name": tr("setting_elecHeatingCloseDisTemp9"),
      "value1": "SETTING_ENUM_9",
      "value": 9
    },
    {
      "label": tr("setting_elecHeatingCloseDisTemp10"),
      "name": tr("setting_elecHeatingCloseDisTemp10"),
      "value1": "SETTING_ENUM_10",
      "value": 10
    }
  ],
  "independentElectHeating": [
    {
      "label": tr("setting_independentElectHeating0"),
      "name": tr("setting_independentElectHeating0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_independentElectHeating1"),
      "name": tr("setting_independentElectHeating1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_independentElectHeating2"),
      "name": tr("setting_independentElectHeating2"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    }
  ],
  "dehumidityStandbyFanSpeed": [
    {
      "label": tr("setting_dehumidityStandbyFanSpeed0"),
      "name": tr("setting_dehumidityStandbyFanSpeed0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_dehumidityStandbyFanSpeed1"),
      "name": tr("setting_dehumidityStandbyFanSpeed1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_dehumidityStandbyFanSpeed2"),
      "name": tr("setting_dehumidityStandbyFanSpeed2"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    },
    {
      "label": tr("setting_dehumidityStandbyFanSpeed3"),
      "name": tr("setting_dehumidityStandbyFanSpeed3"),
      "value1": "SETTING_ENUM_3",
      "value": 3
    }
  ],
  "termalStopFanTime": [
    {
      "label": tr("setting_termalStopFanTime0"),
      "name": tr("setting_termalStopFanTime0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_termalStopFanTime1"),
      "name": tr("setting_termalStopFanTime1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_termalStopFanTime2"),
      "name": tr("setting_termalStopFanTime2"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    },
    {
      "label": tr("setting_termalStopFanTime3"),
      "name": tr("setting_termalStopFanTime3"),
      "value1": "SETTING_ENUM_3",
      "value": 3
    },
    {
      "label": tr("setting_termalStopFanTime4"),
      "name": tr("setting_termalStopFanTime4"),
      "value1": "SETTING_ENUM_4",
      "value": 4
    }
  ],
  "coolingAutoFanSpeedUpperLimit": [
    {
      "label": tr("setting_coolingAutoFanSpeedUpperLimit4"),
      "name": tr("setting_coolingAutoFanSpeedUpperLimit4"),
      "value1": "SETTING_ENUM_4",
      "value": 4
    },
    {
      "label": tr("setting_coolingAutoFanSpeedUpperLimit5"),
      "name": tr("setting_coolingAutoFanSpeedUpperLimit5"),
      "value1": "SETTING_ENUM_5",
      "value": 5
    },
    {
      "label": tr("setting_coolingAutoFanSpeedUpperLimit6"),
      "name": tr("setting_coolingAutoFanSpeedUpperLimit6"),
      "value1": "SETTING_ENUM_6",
      "value": 6
    },
    {
      "label": tr("setting_coolingAutoFanSpeedUpperLimit7"),
      "name": tr("setting_coolingAutoFanSpeedUpperLimit7"),
      "value1": "SETTING_ENUM_7",
      "value": 7
    }
  ],
  "heatingAutoFanSpeedUpperLimit": [
    {
      "label": tr("setting_heatingAutoFanSpeedUpperLimit4"),
      "name": tr("setting_heatingAutoFanSpeedUpperLimit4"),
      "value1": "SETTING_ENUM_4",
      "value": 4
    },
    {
      "label": tr("setting_heatingAutoFanSpeedUpperLimit5"),
      "name": tr("setting_heatingAutoFanSpeedUpperLimit5"),
      "value1": "SETTING_ENUM_5",
      "value": 5
    },
    {
      "label": tr("setting_heatingAutoFanSpeedUpperLimit6"),
      "name": tr("setting_heatingAutoFanSpeedUpperLimit6"),
      "value1": "SETTING_ENUM_6",
      "value": 6
    },
    {
      "label": tr("setting_heatingAutoFanSpeedUpperLimit7"),
      "name": tr("setting_heatingAutoFanSpeedUpperLimit7"),
      "value1": "SETTING_ENUM_7",
      "value": 7
    }
  ],
  "constantAirVolumeSetting": [
    {
      "label": tr("setting_constantAirVolumeSetting0"),
      "name": tr("setting_constantAirVolumeSetting0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_constantAirVolumeSetting1"),
      "name": tr("setting_constantAirVolumeSetting1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_constantAirVolumeSetting2"),
      "name": tr("setting_constantAirVolumeSetting2"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    }
  ],
  "highPatioCorrectionFactor": [
    {
      "label": tr("setting_highPatioCorrectionFactor0"),
      "name": tr("setting_highPatioCorrectionFactor0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_highPatioCorrectionFactor1"),
      "name": tr("setting_highPatioCorrectionFactor1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_highPatioCorrectionFactor2"),
      "name": tr("setting_highPatioCorrectionFactor2"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    }
  ],
  "independentSwing1Sel": [
    {
      "label": tr("setting_independentSwing1Sel0"),
      "name": tr("setting_independentSwing1Sel0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_independentSwing1Sel1"),
      "name": tr("setting_independentSwing1Sel1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    }
  ],
  "multipleControlSetting": [
    {
      "label": tr("setting_multipleControlSetting0"),
      "name": tr("setting_multipleControlSetting0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_multipleControlSetting1"),
      "name": tr("setting_multipleControlSetting1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    }
  ],
  "remoteShutdownSetting": [
    {
      "label": tr("setting_remoteShutdownSetting0"),
      "name": tr("setting_remoteShutdownSetting0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_remoteShutdownSetting1"),
      "name": tr("setting_remoteShutdownSetting1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    }
  ],
  "remoteOnOffDelayTime": [
    {
      "label": tr("setting_remoteOnOffDelayTime0"),
      "name": tr("setting_remoteOnOffDelayTime0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_remoteOnOffDelayTime1"),
      "name": tr("setting_remoteOnOffDelayTime1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_remoteOnOffDelayTime2"),
      "name": tr("setting_remoteOnOffDelayTime2"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    },
    {
      "label": tr("setting_remoteOnOffDelayTime3"),
      "name": tr("setting_remoteOnOffDelayTime3"),
      "value1": "SETTING_ENUM_3",
      "value": 3
    },
    {
      "label": tr("setting_remoteOnOffDelayTime4"),
      "name": tr("setting_remoteOnOffDelayTime4"),
      "value1": "SETTING_ENUM_4",
      "value": 4
    },
    {
      "label": tr("setting_remoteOnOffDelayTime5"),
      "name": tr("setting_remoteOnOffDelayTime5"),
      "value1": "SETTING_ENUM_5",
      "value": 5
    },
    {
      "label": tr("setting_remoteOnOffDelayTime6"),
      "name": tr("setting_remoteOnOffDelayTime6"),
      "value1": "SETTING_ENUM_6",
      "value": 6
    }
  ],
  "indoorAlarmSetting": [
    {
      "label": tr("setting_indoorAlarmSetting0"),
      "name": tr("setting_indoorAlarmSetting0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_indoorAlarmSetting1"),
      "name": tr("setting_indoorAlarmSetting1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    }
  ],
  "preheatingOpenTemp": [
    {
      "label": tr("setting_preheatingOpenTemp0"),
      "name": tr("setting_preheatingOpenTemp0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_preheatingOpenTemp1"),
      "name": tr("setting_preheatingOpenTemp1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_preheatingOpenTemp2"),
      "name": tr("setting_preheatingOpenTemp2"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    }
  ],
  "sterilizationSetting": [
    {
      "label": tr("setting_sterilizationSetting0"),
      "name": tr("setting_sterilizationSetting0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_sterilizationSetting1"),
      "name": tr("setting_sterilizationSetting1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    }
  ],
  "selfCleanDryingTimeSetting": [
    {
      "label": tr("setting_selfCleanDryingTimeSetting0"),
      "name": tr("setting_selfCleanDryingTimeSetting0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_selfCleanDryingTimeSetting1"),
      "name": tr("setting_selfCleanDryingTimeSetting1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_selfCleanDryingTimeSetting2"),
      "name": tr("setting_selfCleanDryingTimeSetting2"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    },
    {
      "label": tr("setting_selfCleanDryingTimeSetting3"),
      "name": tr("setting_selfCleanDryingTimeSetting3"),
      "value1": "SETTING_ENUM_3",
      "value": 3
    }
  ],
  "antiMouldyBlowTimeSetting": [
    {
      "label": tr("setting_antiMouldyBlowTimeSetting0"),
      "name": tr("setting_antiMouldyBlowTimeSetting0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_antiMouldyBlowTimeSetting1"),
      "name": tr("setting_antiMouldyBlowTimeSetting1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_antiMouldyBlowTimeSetting2"),
      "name": tr("setting_antiMouldyBlowTimeSetting2"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    },
    {
      "label": tr("setting_antiMouldyBlowTimeSetting3"),
      "name": tr("setting_antiMouldyBlowTimeSetting3"),
      "value1": "SETTING_ENUM_3",
      "value": 3
    }
  ],
  "antiBlowDirtyCeilingSetting": [
    {
      "label": tr("setting_antiBlowDirtyCeilingSetting0"),
      "name": tr("setting_antiBlowDirtyCeilingSetting0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_antiBlowDirtyCeilingSetting1"),
      "name": tr("setting_antiBlowDirtyCeilingSetting1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    }
  ],
  "antiCondensationSetting": [
    {
      "label": tr("setting_antiCondensationSetting0"),
      "name": tr("setting_antiCondensationSetting0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_antiCondensationSetting1"),
      "name": tr("setting_antiCondensationSetting1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    }
  ],
  "humanSensorNomanTime": [
    {
      "label": tr("setting_humanSensorNomanTime0"),
      "name": tr("setting_humanSensorNomanTime0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_humanSensorNomanTime1"),
      "name": tr("setting_humanSensorNomanTime1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_humanSensorNomanTime2"),
      "name": tr("setting_humanSensorNomanTime2"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    },
    {
      "label": tr("setting_humanSensorNomanTime3"),
      "name": tr("setting_humanSensorNomanTime3"),
      "value1": "SETTING_ENUM_3",
      "value": 3
    },
    {
      "label": tr("setting_humanSensorNomanTime4"),
      "name": tr("setting_humanSensorNomanTime4"),
      "value1": "SETTING_ENUM_4",
      "value": 4
    },
    {
      "label": tr("setting_humanSensorNomanTime5"),
      "name": tr("setting_humanSensorNomanTime5"),
      "value1": "SETTING_ENUM_5",
      "value": 5
    }
  ],
  "humanSensorDiffTemp": [
    {
      "label": tr("setting_humanSensorDiffTemp0"),
      "name": tr("setting_humanSensorDiffTemp0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_humanSensorDiffTemp1"),
      "name": tr("setting_humanSensorDiffTemp1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_humanSensorDiffTemp2"),
      "name": tr("setting_humanSensorDiffTemp2"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    },
    {
      "label": tr("setting_humanSensorDiffTemp3"),
      "name": tr("setting_humanSensorDiffTemp3"),
      "value1": "SETTING_ENUM_3",
      "value": 3
    }
  ],
  "nomanStopDelayTimeSetting": [
    {
      "label": tr("setting_nomanStopDelayTimeSetting0"),
      "name": tr("setting_nomanStopDelayTimeSetting0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_nomanStopDelayTimeSetting1"),
      "name": tr("setting_nomanStopDelayTimeSetting1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_nomanStopDelayTimeSetting2"),
      "name": tr("setting_nomanStopDelayTimeSetting2"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    },
    {
      "label": tr("setting_nomanStopDelayTimeSetting3"),
      "name": tr("setting_nomanStopDelayTimeSetting3"),
      "value1": "SETTING_ENUM_3",
      "value": 3
    },
    {
      "label": tr("setting_nomanStopDelayTimeSetting4"),
      "name": tr("setting_nomanStopDelayTimeSetting4"),
      "value1": "SETTING_ENUM_4",
      "value": 4
    },
    {
      "label": tr("setting_nomanStopDelayTimeSetting5"),
      "name": tr("setting_nomanStopDelayTimeSetting5"),
      "value1": "SETTING_ENUM_5",
      "value": 5
    }
  ],
  "coolingMpcLevel": [
    {
      "label": tr("setting_coolingMpcLevel0"),
      "name": tr("setting_coolingMpcLevel0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_coolingMpcLevel1"),
      "name": tr("setting_coolingMpcLevel1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_coolingMpcLevel2"),
      "name": tr("setting_coolingMpcLevel2"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    }
  ],
  "heatingMpcLevel": [
    {
      "label": tr("setting_heatingMpcLevel0"),
      "name": tr("setting_heatingMpcLevel0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_heatingMpcLevel1"),
      "name": tr("setting_heatingMpcLevel1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_heatingMpcLevel2"),
      "name": tr("setting_heatingMpcLevel2"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    }
  ],
  "powerDownSetting": [
    {
      "label": tr("setting_powerDownSetting0"),
      "name": tr("setting_powerDownSetting0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_powerDownSetting1"),
      "name": tr("setting_powerDownSetting1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    }
  ],
  "heatingIdleOpenningSetting": [
    {
      "label": tr("setting_heatingIdleOpenningSetting0"),
      "name": tr("setting_heatingIdleOpenningSetting0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_heatingIdleOpenningSetting1"),
      "name": tr("setting_heatingIdleOpenningSetting1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_heatingIdleOpenningSetting2"),
      "name": tr("setting_heatingIdleOpenningSetting2"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    },
    {
      "label": tr("setting_heatingIdleOpenningSetting14"),
      "name": tr("setting_heatingIdleOpenningSetting14"),
      "value1": "SETTING_ENUM_14",
      "value": 14
    }
  ],
  "fieldCorrectionFactor": [
    {
      "label": tr("setting_fieldCorrectionFactor0"),
      "name": tr("setting_fieldCorrectionFactor0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_fieldCorrectionFactor1"),
      "name": tr("setting_fieldCorrectionFactor1"),
      "value1": "SETTING_ENUM_1",
      "value": 1
    },
    {
      "label": tr("setting_fieldCorrectionFactor2"),
      "name": tr("setting_fieldCorrectionFactor2"),
      "value1": "SETTING_ENUM_2",
      "value": 2
    },
    {
      "label": tr("setting_fieldCorrectionFactor3"),
      "name": tr("setting_fieldCorrectionFactor3"),
      "value1": "SETTING_ENUM_3",
      "value": 3
    },
    {
      "label": tr("setting_fieldCorrectionFactor4"),
      "name": tr("setting_fieldCorrectionFactor4"),
      "value1": "SETTING_ENUM_4",
      "value": 4
    },
    {
      "label": tr("setting_fieldCorrectionFactor5"),
      "name": tr("setting_fieldCorrectionFactor5"),
      "value1": "SETTING_ENUM_5",
      "value": 5
    },
    {
      "label": tr("setting_fieldCorrectionFactor6"),
      "name": tr("setting_fieldCorrectionFactor6"),
      "value1": "SETTING_ENUM_6",
      "value": 6
    }
  ],
  "diffPressureStartToEnd": [
    {
      "label": tr("setting_diffPressureStartToEnd0"),
      "name": tr("setting_diffPressureStartToEnd0"),
      "value1": "SETTING_ENUM_0",
      "value": 0
    },
    {
      "label": tr("setting_diffPressureStartToEnd1"),
      "name": tr("setting_diffPressureStartToEnd1"),
      "value1": "SETTING_ENUM_0",
      "value": 1
    },
    {
      "label": tr("setting_diffPressureStartToEnd2"),
      "name": tr("setting_diffPressureStartToEnd2"),
      "value1": "SETTING_ENUM_0",
      "value": 2
    },
    {
      "label": tr("setting_diffPressureStartToEnd3"),
      "name": tr("setting_diffPressureStartToEnd3"),
      "value1": "SETTING_ENUM_0",
      "value": 3
    },
    {
      "label": tr("setting_diffPressureStartToEnd4"),
      "name": tr("setting_diffPressureStartToEnd4"),
      "value1": "SETTING_ENUM_0",
      "value": 4
    },
    {
      "label": tr("setting_diffPressureStartToEnd5"),
      "name": tr("setting_diffPressureStartToEnd5"),
      "value1": "SETTING_ENUM_0",
      "value": 5
    },
    {
      "label": tr("setting_diffPressureStartToEnd6"),
      "name": tr("setting_diffPressureStartToEnd6"),
      "value1": "SETTING_ENUM_0",
      "value": 6
    },
    {
      "label": tr("setting_diffPressureStartToEnd7"),
      "name": tr("setting_diffPressureStartToEnd7"),
      "value1": "SETTING_ENUM_0",
      "value": 7
    },
    {
      "label": tr("setting_diffPressureStartToEnd8"),
      "name": tr("setting_diffPressureStartToEnd8"),
      "value1": "SETTING_ENUM_0",
      "value": 8
    },
    {
      "label": tr("setting_diffPressureStartToEnd9"),
      "name": tr("setting_diffPressureStartToEnd9"),
      "value1": "SETTING_ENUM_0",
      "value": 9
    },
    {
      "label": tr("setting_diffPressureStartToEnd10"),
      "name": tr("setting_diffPressureStartToEnd10"),
      "value1": "SETTING_ENUM_0",
      "value": 10
    },
    {
      "label": tr("setting_diffPressureStartToEnd11"),
      "name": tr("setting_diffPressureStartToEnd11"),
      "value1": "SETTING_ENUM_0",
      "value": 11
    },
    {
      "label": tr("setting_diffPressureStartToEnd12"),
      "name": tr("setting_diffPressureStartToEnd12"),
      "value1": "SETTING_ENUM_0",
      "value": 12
    },
    {
      "label": tr("setting_diffPressureStartToEnd13"),
      "name": tr("setting_diffPressureStartToEnd13"),
      "value1": "SETTING_ENUM_0",
      "value": 13
    },
    {
      "label": tr("setting_diffPressureStartToEnd14"),
      "name": tr("setting_diffPressureStartToEnd14"),
      "value1": "SETTING_ENUM_0",
      "value": 14
    },
    {
      "label": tr("setting_diffPressureStartToEnd15"),
      "name": tr("setting_diffPressureStartToEnd15"),
      "value1": "SETTING_ENUM_0",
      "value": 15
    },
    {
      "label": tr("setting_diffPressureStartToEnd16"),
      "name": tr("setting_diffPressureStartToEnd16"),
      "value1": "SETTING_ENUM_0",
      "value": 16
    },
    {
      "label": tr("setting_diffPressureStartToEnd17"),
      "name": tr("setting_diffPressureStartToEnd17"),
      "value1": "SETTING_ENUM_0",
      "value": 17
    },
    {
      "label": tr("setting_diffPressureStartToEnd18"),
      "name": tr("setting_diffPressureStartToEnd18"),
      "value1": "SETTING_ENUM_0",
      "value": 18
    },
    {
      "label": tr("setting_diffPressureStartToEnd19"),
      "name": tr("setting_diffPressureStartToEnd19"),
      "value1": "SETTING_ENUM_0",
      "value": 19
    }
  ],
  "openDegreeOfOilReturnSet": generateData(),
  "remoteShutdownExitMode": [
    {
      "label": tr("setting_remoteshutdownexitmode0"),
      "name": tr("setting_remoteshutdownexitmode0"),
      "value1": "RECOVER_SETTING",
      "value": 0
    },
    {
      "label": tr("setting_remoteshutdownexitmode1"),
      "name": tr("setting_remoteshutdownexitmode1"),
      "value1": "SHUTDOWN",
      "value": 1
    },
    // {
    //   "label": tr("setting_remoteshutdownexitmode3"),
    //   "name": tr("setting_remoteshutdownexitmode3"),
    //   "value1": "KEEP_UNCHANGED",
    //   "value": 3
    // }
  ],
  "mpcselect1": [
    {"label": "舒适性", "name": "舒适性", "value1": "NORMAL", "value": 0},
    {"label": "加权", "name": "加权", "value1": "WEIGHT", "value": 1},
    {"label": "VIP优先", "name": "VIP优先", "value1": "VIP", "value": 2},
  ],
  "fanEnergySaving": [
    {"label": "无效", "name": "无效", "value1": "NORMAL", "value": 0},
    {"label": "有效", "name": "有效", "value1": "WEIGHT", "value": 1},
  ],
  "outputDryContact1": [
    {"label": "运行信号", "name": "运行信号", "value1": "RUN_SIGNAL", "value": 0},
    {"label": "警报信号", "name": "警报信号", "value1": "ALERT_SIGNAL", "value": 1},
    {
      "label": "压缩机运行信号",
      "name": "压缩机运行信号",
      "value1": "COMPRESSOR_RUN_SIGNAL",
      "value": 2
    },
    {
      "label": "除霜信号",
      "name": "除霜信号",
      "value1": "DEHYDRATION_SIGNAL",
      "value": 3
    },
    {
      "label": "冷媒泄露信号",
      "name": "冷媒泄露信号",
      "value1": "LEAKAGE_SIGNAL",
      "value": 4
    }
  ],
  "outputDryContact2": [
    {"label": "喷淋", "name": "喷淋", "value1": "DryContact_0", "value": 0},
    {
      "label": "液管截断阀控制",
      "name": "液管截断阀控制",
      "value1": "DryContact_1",
      "value": 1
    }
  ],
  "outputDryContact3": [
    {
      "label": "运转信号",
      "name": "运转信号",
      "value1": "SETTING_ENUM_0",
      "value": 1,
      "code": 128
    },
    {
      "label": "警报信号",
      "name": "警报信号",
      "value1": "SETTING_ENUM_1",
      "value": 2,
      "code": 128
    },
    {
      "label": "压缩机运转信号",
      "name": "压缩机运转信号",
      "value1": "SETTING_ENUM_2",
      "value": 3,
      "code": 128
    },
    {
      "label": "除霜信号",
      "name": "除霜信号",
      "value1": "SETTING_ENUM_3",
      "value": 4,
      "code": 128
    },
    {
      "label": "冷媒泄露信号",
      "name": "冷媒泄露信号",
      "value1": "SETTING_ENUM_4",
      "value": 5,
      "code": 128
    },
    {
      "label": "气管截断阀控制",
      "name": "气管截断阀控制",
      "value1": "SETTING_ENUM_5",
      "value": 6,
      "code": 9
    },
    {
      "label": "底盘电加热",
      "name": "底盘电加热",
      "value1": "SETTING_ENUM_6",
      "value": 7,
      "code": 9
    }
  ],
  "coolingTempCompensation": [
    {
      "label": tr("setting_coolingtempcompensation0"),
      "name": tr("setting_coolingtempcompensation0"),
      "value1": "CODE_0",
      "value": 0
    },
    {
      "label": tr("setting_coolingtempcompensation1"),
      "name": tr("setting_coolingtempcompensation1"),
      "value1": "CODE_1",
      "value": 1
    },
    {
      "label": tr("setting_coolingtempcompensation2"),
      "name": tr("setting_coolingtempcompensation2"),
      "value1": "CODE_2",
      "value": 2
    },
    {
      "label": tr("setting_coolingtempcompensation3"),
      "name": tr("setting_coolingtempcompensation3"),
      "value1": "CODE_3",
      "value": 3
    },
    {
      "label": tr("setting_coolingtempcompensation4"),
      "name": tr("setting_coolingtempcompensation4"),
      "value1": "CODE_4",
      "value": 4
    }
  ],
  "heatingTempCompensation": heatingTempCompensationData(),
  "chassisIceFunction": [
    {"label": "无效", "name": "无效", "value1": "INVALID", "value": 0},
    {"label": "有效，间断开启", "name": "有效，间断开启", "value1": "ENABLED", "value": 1},
    {"label": "有效，常开", "name": "有效，常开", "value1": "ALWAYS_ENABLED", "value": 2},
    {"label": "维持不变", "name": "维持不变", "value1": "KEEP_THE_SAME", "value": 3}
  ],
  "humiditycontrol": [
    {
      "label": "恒风量",
      "name": "恒风量",
      "value1": "HUMIDITY_CONTROL_CONSTANT_FLOW",
      "value": 0
    },
    {
      "label": "恒转速",
      "name": "恒转速",
      "value1": "HUMIDITY_CONTROL_CONSTANT_SPEED",
      "value": 1
    },
  ],
  "factorymeter": [
    {"label": "不使能", "name": "不使能", "value1": "DISABLED", "value": 0},
    {"label": "使能", "name": "使能", "value1": "ENABLED", "value": 1},
  ],
  "xyebaudrate": [
    {"label": "4800", "name": "4800", "value1": "BAUD_RATE_4800", "value": 0},
    {"label": "9600", "name": "9600", "value1": "BAUD_RATE_9600", "value": 1},
    {
      "label": "19200",
      "name": "19200",
      "value1": "BAUD_RATE_19200",
      "value": 2
    },
    {
      "label": "38400",
      "name": "38400",
      "value1": "BAUD_RATE_38400",
      "value": 3
    },
  ],
  "chargingElectricMeterEnum": [
    {"label": "出厂电表", "name": "出厂电表", "value1": "FACTORY_METER", "value": 0},
    {"label": "外接电表", "name": "外接电表", "value1": "EXTERNAL_METER", "value": 1},
    {"label": "维持不变", "name": "维持不变", "value1": "KEEP_THE_SAME", "value": 3},
  ],
  "firmwareVersion": [
    {"label": "无感升级", "name": "无感升级", "value1": "NO_SENSE_UPGRADE", "value": 0},
    {"label": "有感升级", "name": "有感升级", "value1": "SENSE_UPGRADE", "value": 1},
    {"label": "维持不变", "name": "维持不变", "value1": "KEEP_THE_SAME", "value": 3},
  ],
  "upgradeMethodEnum": [
    {"label": "升级系统", "name": "升级系统", "value1": "UPGRADE_SYSTEM", "value": 0},
    {"label": "升级自身", "name": "升级自身", "value1": "UPGRADE_SELF", "value": 1},
    {"label": "维持不变", "name": "维持不变", "value1": "KEEP_THE_SAME", "value": 3},
  ],
  "maxFrequencyLimit": [
    {"label": "无限制", "name": "无限制", "value1": "NO_LIMIT", "value": 0},
    {"label": "95%", "name": "95%", "value1": "LIMIT_95", "value": 1},
    {"label": "90%", "name": "90%", "value1": "LIMIT_90", "value": 3},
  ],
  "mdvLinkVoltageVersion": [
    {"label": "24V电压", "name": "24V电压", "value1": "INVALID", "value": 0},
    {"label": "36V电压", "name": "36V电压", "value1": "ENABLED", "value": 1},
  ],
  "chipModel": [
    {"label": "ST芯片", "name": "ST芯片", "value1": "ST", "value": 0},
    {"label": "GD芯片", "name": "GD芯片", "value1": "GD", "value": 1},
  ],
  "heatStatusEnum": [
    {"label": "换热器关", "name": "换热器关", "value1": "STATUS_0", "value": 0},
    {"label": "冷凝器", "name": "冷凝器", "value1": "STATUS_1", "value": 1},
    {
      "label": "热泵D2，热回收D1",
      "name": "热泵D2，热回收D1",
      "value1": "STATUS_2",
      "value": 3
    },
    {"label": "蒸发器", "name": "蒸发器", "value1": "STATUS_3", "value": 3},
    {
      "label": "热泵F2，热回收F1",
      "name": "热泵F2，热回收F1",
      "value1": "STATUS_4",
      "value": 4
    },
  ],
  "startupType": [
    {"label": "无特殊模式", "name": "无特殊模式", "value1": "SETTING_ENUM_0", "value": 0},
    {"label": "预热", "name": "预热", "value1": "SETTING_ENUM_1", "value": 1},
    {"label": "回油", "name": "回油", "value1": "SETTING_ENUM_2", "value": 2},
    {"label": "化霜", "name": "化霜", "value1": "SETTING_ENUM_3", "value": 3},
    {"label": "启动", "name": "启动", "value1": "SETTING_ENUM_4", "value": 4},
    {"label": "停止", "name": "停止", "value1": "SETTING_ENUM_5", "value": 5},
  ],
  "indoorType": [
    {"label": "老内机", "name": "老内机", "value1": "IduType_0", "value": 0},
    {"label": "环形出风Q4", "name": "环形出风Q4", "value1": "IduType_1", "value": 1},
    {"label": "G挂壁", "name": "G挂壁", "value1": "IduType_2", "value": 2},
    {"label": "自由静压T2", "name": "自由静压T2", "value1": "IduType_3", "value": 3},
    {"label": "薄型风管机T2", "name": "薄型风管机T2", "value1": "IduType_4", "value": 4},
    {"label": "美式风管机", "name": "美式风管机", "value1": "IduType_5", "value": 5},
    {"label": "T1高静压", "name": "T1高静压", "value1": "IduType_6", "value": 6},
    {"label": "环形出风Q4_", "name": "环形出风Q4_", "value1": "IduType_7", "value": 7},
    {"label": "DL座吊", "name": "DL座吊", "value1": "IduType_8", "value": 8},
    {"label": "立式暗装", "name": "立式暗装", "value1": "IduType_9", "value": 9},
    {"label": "立式明装", "name": "立式明装", "value1": "IduType_10", "value": 10},
    {"label": "新风机", "name": "新风机", "value1": "IduType_11", "value": 11},
    {"label": "一拖一", "name": "一拖一", "value1": "IduType_12", "value": 12},
    {"label": "全热交换器", "name": "全热交换器", "value1": "IduType_13", "value": 13},
    {"label": "一面出风", "name": "一面出风", "value1": "IduType_14", "value": 14},
    {"label": "两面出风", "name": "两面出风", "value1": "IduType_15", "value": 15},
    {
      "label": "Console",
      "name": "Console",
      "value1": "IduType_16",
      "value": 16
    },
    {"label": "高温水力模块", "name": "高温水力模块", "value1": "IduType_17", "value": 17},
    {"label": "T3新风机", "name": "T3新风机", "value1": "IduType_18", "value": 18},
    {
      "label": "Clivet新风机",
      "name": "Clivet新风机",
      "value1": "IduType_19",
      "value": 19
    },
    {
      "label": "常温小风量新风机",
      "name": "常温小风量新风机",
      "value1": "IduType_20",
      "value": 20
    },
    {"label": "独立控制盒", "name": "独立控制盒", "value1": "IduType_21", "value": 21},
    {"label": "柜机", "name": "柜机", "value1": "IduType_22", "value": 22},
    {"label": "加湿器", "name": "加湿器", "value1": "IduType_23", "value": 23},
    {
      "label": "独立控制盒_出风温度控制",
      "name": "独立控制盒_出风温度控制",
      "value1": "IduType_24",
      "value": 24
    },
    {"label": "小多联新风机", "name": "小多联新风机", "value1": "IduType_25", "value": 25},
    {"label": "直棚机", "name": "直棚机", "value1": "IduType_26", "value": 26},
    {"label": "低温水力模块", "name": "低温水力模块", "value1": "IduType_27", "value": 27},
    {"label": "中温水力模块", "name": "中温水力模块", "value1": "IduType_28", "value": 28},
    {"label": "采暖水力模块", "name": "采暖水力模块", "value1": "IduType_29", "value": 29},
    {"label": "直棚机_再热", "name": "直棚机_再热", "value1": "IduType_30", "value": 30},
    {"label": "烤烟内机", "name": "烤烟内机", "value1": "IduType_31", "value": 31},
    {"label": "AT内机", "name": "AT内机", "value1": "IduType_32", "value": 32},
    {"label": "卧式", "name": "卧式", "value1": "IduType_33", "value": 33},
    {"label": "制热水箱", "name": "制热水箱", "value1": "IduType_34", "value": 34},
    {
      "label": "ByPassKit",
      "name": "ByPassKit",
      "value1": "IduType_61",
      "value": 61
    },
    {"label": "屋顶机", "name": "屋顶机", "value1": "IduType_62", "value": 62}
  ]
};

List<Map<String, dynamic>> heatingTempCompensationData() {
  List<Map<String, dynamic>> data = [];

  for (int i = 0; i < 4; i++) {
    data.add({
      "label": tr("setting_heatingtempcompensation$i"),
      "name": tr("setting_heatingtempcompensation$i"),
      "value1": "CODE_$i",
      "value": i,
    });
  }

  return data;
}

List<Map<String, dynamic>> generateData() {
  List<Map<String, dynamic>> data = [];

  for (int i = 0; i < 50; i++) {
    data.add({
      "label": "$i",
      "name": "$i",
      "value1": "$i",
      "value": i,
    });
  }

  return data;
}

selectMapfilterOp(key, val) {
  try {
    if (val == null || val == "") {
      return "--";
    }
    String _val = val.toString();

    var filter = selectMap[key]!
        .where((e) =>
            e["value"].toString() == _val || e["value1"].toString() == _val)
        .toList();
    if (filter != null) {
      return filter[0]["label"];
    }
    return "--";
  } catch (e) {
    return "--";
  }
}
