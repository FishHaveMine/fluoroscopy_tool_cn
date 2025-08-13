const fs = require("fs");

// 输入数据
const data = {
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
    "silentMode": [
      {"label": "关闭", "name": "关闭", 'value1': "SilenceMode_0", "value": 0},
      {"label": "静音1", "name": "静音1", 'value1': "SilenceMode_1", "value": 1},
      {"label": "静音2", "name": "静音2", 'value1': "SilenceMode_2", "value": 2},
      {"label": "静音3", "name": "静音3", 'value1': "SilenceMode_3", "value": 3},
      {"label": "静音4", "name": "静音4", 'value1': "SilenceMode_4", "value": 4},
      {"label": "静音5", "name": "静音5", 'value1': "SilenceMode_5", "value": 5},
      {"label": "静音6", "name": "静音6", 'value1': "SilenceMode_6", "value": 6},
      {"label": "静音7", "name": "静音7", 'value1': "SilenceMode_7", "value": 7},
      {"label": "静音8", "name": "静音8", 'value1': "SilenceMode_8", "value": 8},
      {"label": "静音9", "name": "静音9", 'value1': "SilenceMode_9", "value": 9},
      {"label": "静音10", "name": "静音10", 'value1': "SilenceMode_10", "value": 10},
      {"label": "静音11", "name": "静音11", 'value1': "SilenceMode_11", "value": 11},
      {"label": "静音12", "name": "静音12", 'value1': "SilenceMode_12", "value": 12},
      {"label": "静音13", "name": "静音13", 'value1': "SilenceMode_13", "value": 13},
      {"label": "静音14", "name": "静音14", 'value1': "SilenceMode_14", "value": 14}
    ],
    "compressorRestartWaitTime": [
      {"label": "3min", "name": "3min", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "5min", "name": "5min", 'value1': "SETTING_ENUM_1", "value": 1},
      {"label": "7min", "name": "7min", 'value1': "SETTING_ENUM_2", "value": 2},
    ],
    "lowNoiseDefrostSetting": [
      {"label": "无效", "name": "无效", 'value1': "NOT_STOP", "value": 0},
      {"label": "有效", "name": "有效", 'value1': "STOP", "value": 1},
    ],
    "taketurnsSetting": [
      {"label": "禁止", "name": "禁止", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "压缩机轮换", "name": "压缩机轮换", 'value1': "SETTING_ENUM_1", "value": 1},
      {"label": "机组轮换", "name": "机组轮换", 'value1': "SETTING_ENUM_2", "value": 2},
      {
        "label": "压缩机+机组轮换",
        "name": "压缩机+机组轮换",
        'value1': "SETTING_ENUM_3",
        "value": 3
      }
    ],
    "powerLimit": [
      {
        "label": "40%",
        "name": "PowerLimit_40",
        'value1': "SETTING_ENUM_40",
        "value": 40
      },
      {
        "label": "41%",
        "name": "PowerLimit_41",
        'value1': "SETTING_ENUM_41",
        "value": 41
      },
      {
        "label": "42%",
        "name": "PowerLimit_42",
        'value1': "SETTING_ENUM_42",
        "value": 42
      },
      {
        "label": "43%",
        "name": "PowerLimit_43",
        'value1': "SETTING_ENUM_43",
        "value": 43
      },
      {
        "label": "44%",
        "name": "PowerLimit_44",
        'value1': "SETTING_ENUM_44",
        "value": 44
      },
      {
        "label": "45%",
        "name": "PowerLimit_45",
        'value1': "SETTING_ENUM_45",
        "value": 45
      },
      {
        "label": "46%",
        "name": "PowerLimit_46",
        'value1': "SETTING_ENUM_46",
        "value": 46
      },
      {
        "label": "47%",
        "name": "PowerLimit_47",
        'value1': "SETTING_ENUM_47",
        "value": 47
      },
      {
        "label": "48%",
        "name": "PowerLimit_48",
        'value1': "SETTING_ENUM_48",
        "value": 48
      },
      {
        "label": "49%",
        "name": "PowerLimit_49",
        'value1': "SETTING_ENUM_49",
        "value": 49
      },
      {
        "label": "50%",
        "name": "PowerLimit_50",
        'value1': "SETTING_ENUM_50",
        "value": 50
      },
      {
        "label": "51%",
        "name": "PowerLimit_51",
        'value1': "SETTING_ENUM_51",
        "value": 51
      },
      {
        "label": "52%",
        "name": "PowerLimit_52",
        'value1': "SETTING_ENUM_52",
        "value": 52
      },
      {
        "label": "53%",
        "name": "PowerLimit_53",
        'value1': "SETTING_ENUM_53",
        "value": 53
      },
      {
        "label": "54%",
        "name": "PowerLimit_54",
        'value1': "SETTING_ENUM_54",
        "value": 54
      },
      {
        "label": "55%",
        "name": "PowerLimit_55",
        'value1': "SETTING_ENUM_55",
        "value": 55
      },
      {
        "label": "56%",
        "name": "PowerLimit_56",
        'value1': "SETTING_ENUM_56",
        "value": 56
      },
      {
        "label": "57%",
        "name": "PowerLimit_57",
        'value1': "SETTING_ENUM_57",
        "value": 57
      },
      {
        "label": "58%",
        "name": "PowerLimit_58",
        'value1': "SETTING_ENUM_58",
        "value": 58
      },
      {
        "label": "59%",
        "name": "PowerLimit_59",
        'value1': "SETTING_ENUM_59",
        "value": 59
      },
      {
        "label": "60%",
        "name": "PowerLimit_60",
        'value1': "SETTING_ENUM_60",
        "value": 60
      },
      {
        "label": "61%",
        "name": "PowerLimit_61",
        'value1': "SETTING_ENUM_61",
        "value": 61
      },
      {
        "label": "62%",
        "name": "PowerLimit_62",
        'value1': "SETTING_ENUM_62",
        "value": 62
      },
      {
        "label": "63%",
        "name": "PowerLimit_63",
        'value1': "SETTING_ENUM_63",
        "value": 63
      },
      {
        "label": "64%",
        "name": "PowerLimit_64",
        'value1': "SETTING_ENUM_64",
        "value": 64
      },
      {
        "label": "65%",
        "name": "PowerLimit_65",
        'value1': "SETTING_ENUM_65",
        "value": 65
      },
      {
        "label": "66%",
        "name": "PowerLimit_66",
        'value1': "SETTING_ENUM_66",
        "value": 66
      },
      {
        "label": "67%",
        "name": "PowerLimit_67",
        'value1': "SETTING_ENUM_67",
        "value": 67
      },
      {
        "label": "68%",
        "name": "PowerLimit_68",
        'value1': "SETTING_ENUM_68",
        "value": 68
      },
      {
        "label": "69%",
        "name": "PowerLimit_69",
        'value1': "SETTING_ENUM_69",
        "value": 69
      },
      {
        "label": "70%",
        "name": "PowerLimit_70",
        'value1': "SETTING_ENUM_70",
        "value": 70
      },
      {
        "label": "71%",
        "name": "PowerLimit_71",
        'value1': "SETTING_ENUM_71",
        "value": 71
      },
      {
        "label": "72%",
        "name": "PowerLimit_72",
        'value1': "SETTING_ENUM_72",
        "value": 72
      },
      {
        "label": "73%",
        "name": "PowerLimit_73",
        'value1': "SETTING_ENUM_73",
        "value": 73
      },
      {
        "label": "74%",
        "name": "PowerLimit_74",
        'value1': "SETTING_ENUM_74",
        "value": 74
      },
      {
        "label": "75%",
        "name": "PowerLimit_75",
        'value1': "SETTING_ENUM_75",
        "value": 75
      },
      {
        "label": "76%",
        "name": "PowerLimit_76",
        'value1': "SETTING_ENUM_76",
        "value": 76
      },
      {
        "label": "77%",
        "name": "PowerLimit_77",
        'value1': "SETTING_ENUM_77",
        "value": 77
      },
      {
        "label": "78%",
        "name": "PowerLimit_78",
        'value1': "SETTING_ENUM_78",
        "value": 78
      },
      {
        "label": "79%",
        "name": "PowerLimit_79",
        'value1': "SETTING_ENUM_79",
        "value": 79
      },
      {
        "label": "80%",
        "name": "PowerLimit_80",
        'value1': "SETTING_ENUM_80",
        "value": 80
      },
      {
        "label": "81%",
        "name": "PowerLimit_81",
        'value1': "SETTING_ENUM_81",
        "value": 81
      },
      {
        "label": "82%",
        "name": "PowerLimit_82",
        'value1': "SETTING_ENUM_82",
        "value": 82
      },
      {
        "label": "83%",
        "name": "PowerLimit_83",
        'value1': "SETTING_ENUM_83",
        "value": 83
      },
      {
        "label": "84%",
        "name": "PowerLimit_84",
        'value1': "SETTING_ENUM_84",
        "value": 84
      },
      {
        "label": "85%",
        "name": "PowerLimit_85",
        'value1': "SETTING_ENUM_85",
        "value": 85
      },
      {
        "label": "86%",
        "name": "PowerLimit_86",
        'value1': "SETTING_ENUM_86",
        "value": 86
      },
      {
        "label": "87%",
        "name": "PowerLimit_87",
        'value1': "SETTING_ENUM_87",
        "value": 87
      },
      {
        "label": "88%",
        "name": "PowerLimit_88",
        'value1': "SETTING_ENUM_88",
        "value": 88
      },
      {
        "label": "89%",
        "name": "PowerLimit_89",
        'value1': "SETTING_ENUM_89",
        "value": 89
      },
      {
        "label": "90%",
        "name": "PowerLimit_90",
        'value1': "SETTING_ENUM_90",
        "value": 90
      },
      {
        "label": "91%",
        "name": "PowerLimit_91",
        'value1': "SETTING_ENUM_91",
        "value": 91
      },
      {
        "label": "92%",
        "name": "PowerLimit_92",
        'value1': "SETTING_ENUM_92",
        "value": 92
      },
      {
        "label": "93%",
        "name": "PowerLimit_93",
        'value1': "SETTING_ENUM_93",
        "value": 93
      },
      {
        "label": "94%",
        "name": "PowerLimit_94",
        'value1': "SETTING_ENUM_94",
        "value": 94
      },
      {
        "label": "95%",
        "name": "PowerLimit_95",
        'value1': "SETTING_ENUM_95",
        "value": 95
      },
      {
        "label": "96%",
        "name": "PowerLimit_96",
        'value1': "SETTING_ENUM_96",
        "value": 96
      },
      {
        "label": "97%",
        "name": "PowerLimit_97",
        'value1': "SETTING_ENUM_97",
        "value": 97
      },
      {
        "label": "98%",
        "name": "PowerLimit_98",
        'value1': "SETTING_ENUM_98",
        "value": 98
      },
      {
        "label": "99%",
        "name": "PowerLimit_99",
        'value1': "SETTING_ENUM_99",
        "value": 99
      },
      {
        "label": "无限制",
        "name": "PowerLimit_100",
        'value1': "SETTING_ENUM_100",
        "value": 100
      }
    ],
    "antiSnowSetting": [
      {"label": "禁止", "name": "禁止", 'value1': "SETTING_ENUM_0", "value": 0},
      {
        "label": "使能，方式1，强度一般",
        "name": "使能，方式1，强度一般",
        'value1': "SETTING_ENUM_1",
        "value": 1
      },
      {
        "label": "使能，方式2，强度高",
        "name": "使能，方式2，强度高",
        'value1': "SETTING_ENUM_2",
        "value": 2
      }
    ],
    "backupSensor": [
      {"label": "无效", "name": "无效", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "手动进入", "name": "手动进入", 'value1': "SETTING_ENUM_1", "value": 1},
      {"label": "自动进入", "name": "自动进入", 'value1': "SETTING_ENUM_2", "value": 2}
    ],
    "backupRunDays": [
      {"label": "1天", "name": "1天", 'value1': "SETTING_ENUM_1", "value": 1},
      {"label": "2天", "name": "2天", 'value1': "SETTING_ENUM_2", "value": 2},
      {"label": "3天", "name": "3天", 'value1': "SETTING_ENUM_3", "value": 3},
      {"label": "4天", "name": "4天", 'value1': "SETTING_ENUM_4", "value": 4},
      {"label": "5天", "name": "5天", 'value1': "SETTING_ENUM_5", "value": 5},
      {"label": "6天", "name": "6天", 'value1': "SETTING_ENUM_6", "value": 6},
      {"label": "7天", "name": "7天", 'value1': "SETTING_ENUM_7", "value": 7}
    ],
    "tecChoice": [
      {"label": "最小值", "name": "最小值", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "平均值", "name": "平均值", 'value1': "SETTING_ENUM_1", "value": 1},
      {"label": "VIP", "name": "VIP", 'value1': "SETTING_ENUM_2", "value": 2}
    ],
    "mpc": [
      {"label": "禁止", "name": "禁止", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "使能", "name": "使能", 'value1': "SETTING_ENUM_1", "value": 1}
    ],
    "lockLineControl": [
      {"label": "未锁定", "name": "未锁定", 'value1': "SETTING_ENUM_0", "value": false},
      {"label": "锁定", "name": "锁定", 'value1': "SETTING_ENUM_1", "value": true}
    ],
    "mpcSelect3": [
      {
        "label": "MPC节能等级1-低",
        "name": "MPC节能等级1-低",
        'value1': "SETTING_ENUM_0",
        "value": 0
      },
      {
        "label": "MPC节能等级2-中",
        "name": "MPC节能等级2-中",
        'value1': "SETTING_ENUM_1",
        "value": 1
      },
      {
        "label": "MPC节能等级3-高",
        "name": "MPC节能等级3-高",
        'value1': "SETTING_ENUM_2",
        "value": 2
      }
    ],
    "mpcSelect4": [
      {
        "label": "MPC节能等级1-低",
        "name": "MPC节能等级1-低",
        'value1': "SETTING_ENUM_0",
        "value": 0
      },
      {
        "label": "MPC节能等级2-中",
        "name": "MPC节能等级2-中",
        'value1': "SETTING_ENUM_1",
        "value": 1
      },
      {
        "label": "MPC节能等级3-高",
        "name": "MPC节能等级3-高",
        'value1': "SETTING_ENUM_2",
        "value": 2
      }
    ],
    "dryContactInputSetting1": [
      {"label": "纯制冷锁定", "name": "纯制冷锁定", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "纯制热锁定", "name": "纯制热锁定", 'value1': "SETTING_ENUM_1", "value": 1},
      {
        "label": "系统强制无所需",
        "name": "系统强制无所需",
        'value1': "SETTING_ENUM_2",
        "value": 2
      },
      {"label": "强制禁止", "name": "强制禁止", 'value1': "SETTING_ENUM_3", "value": 3}
    ],
    "dryContactInputSetting2": [
      {"label": "纯制冷锁定", "name": "纯制冷锁定", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "纯制热锁定", "name": "纯制热锁定", 'value1': "SETTING_ENUM_1", "value": 1},
      {
        "label": "系统强制无所需",
        "name": "系统强制无所需",
        'value1': "SETTING_ENUM_2",
        "value": 2
      },
      {"label": "强制禁止", "name": "强制禁止", 'value1': "SETTING_ENUM_3", "value": 3}
    ],
    "dryContactInputSetting3": [
      {"label": "运转信号", "name": "运转信号", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "警报信号", "name": "警报信号", 'value1': "SETTING_ENUM_1", "value": 1},
      {
        "label": "压缩机运转信号",
        "name": "压缩机运转信号",
        'value1': "SETTING_ENUM_2",
        "value": 2
      },
      {"label": "除霜信号", "name": "除霜信号", 'value1': "SETTING_ENUM_3", "value": 3},
      {
        "label": "冷媒泄露信号",
        "name": "冷媒泄露信号",
        'value1': "SETTING_ENUM_4",
        "value": 4
      }
    ],
    "emergenceStop": [
      {"label": "解除急停", "name": "解除急停", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "急停", "name": "急停", 'value1': "SETTING_ENUM_1", "value": 1}
    ],
    "sprayEnabling": [
      {"label": "无效", "name": "无效", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "有效", "name": "有效", 'value1': "SETTING_ENUM_1", "value": 1}
    ],
    "sprayLevelSetting": [
      {"label": "间歇喷淋1", "name": "间歇喷淋1", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "间歇喷淋2", "name": "间歇喷淋2", 'value1': "SETTING_ENUM_1", "value": 1},
      {"label": "连续喷淋", "name": "连续喷淋", 'value1': "SETTING_ENUM_2", "value": 2},
      {"label": "关闭", "name": "关闭", 'value1': "SETTING_ENUM_3", "value": 3},
      {"label": "自动喷淋", "name": "自动喷淋", 'value1': "SETTING_ENUM_4", "value": 4}
    ],
    "sprayOpen": [
      {"label": "关闭", "name": "关闭", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "开启", "name": "开启", 'value1': "SETTING_ENUM_1", "value": 1}
    ],
    "buzzerSetting": [
      {"label": "不响", "name": "不响", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "响", "name": "响", 'value1': "SETTING_ENUM_1", "value": 1},
      {"label": "仅显示板", "name": "仅显示板", 'value1': "SETTING_ENUM_2", "value": 2}
    ],
    "displayBoardLightSetting": [
      {"label": "关", "name": "关", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "开", "name": "开", 'value1': "SETTING_ENUM_1", "value": 1}
    ],
    "autoModeSwitchTime": [
      {"label": "15min", "name": "15min", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "30min", "name": "30min", 'value1': "SETTING_ENUM_1", "value": 1},
      {"label": "60min", "name": "60min", 'value1': "SETTING_ENUM_2", "value": 2},
      {"label": "90min", "name": "90min", 'value1': "SETTING_ENUM_3", "value": 3}
    ],
    "elecHeatingOpenDisTemp": [
      {"label": "0℃", "name": "0℃", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "1℃", "name": "1℃", 'value1': "SETTING_ENUM_1", "value": 1},
      {"label": "2℃", "name": "2℃", 'value1': "SETTING_ENUM_2", "value": 2},
      {"label": "3℃", "name": "3℃", 'value1': "SETTING_ENUM_3", "value": 3},
      {"label": "4℃", "name": "4℃", 'value1': "SETTING_ENUM_4", "value": 4},
      {"label": "5℃", "name": "5℃", 'value1': "SETTING_ENUM_5", "value": 5},
      {"label": "6℃", "name": "6℃", 'value1': "SETTING_ENUM_6", "value": 6},
      {"label": "7℃", "name": "7℃", 'value1': "SETTING_ENUM_7", "value": 7}
    ],
    "elecHeatingCloseDisTemp": [
      {"label": "-4℃", "name": "-4℃", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "-3℃", "name": "-3℃", 'value1': "SETTING_ENUM_1", "value": 1},
      {"label": "-2℃", "name": "-2℃", 'value1': "SETTING_ENUM_2", "value": 2},
      {"label": "-1℃", "name": "-1℃", 'value1': "SETTING_ENUM_3", "value": 3},
      {"label": "0℃", "name": "0℃", 'value1': "SETTING_ENUM_4", "value": 4},
      {"label": "1℃", "name": "1℃", 'value1': "SETTING_ENUM_5", "value": 5},
      {"label": "2℃", "name": "2℃", 'value1': "SETTING_ENUM_6", "value": 6},
      {"label": "3℃", "name": "3℃", 'value1': "SETTING_ENUM_7", "value": 7},
      {"label": "4℃", "name": "4℃", 'value1': "SETTING_ENUM_8", "value": 8},
      {"label": "5℃", "name": "5℃", 'value1': "SETTING_ENUM_9", "value": 9},
      {"label": "6℃", "name": "6℃", 'value1': "SETTING_ENUM_10", "value": 10}
    ],
    "independentElectHeating": [
      {"label": "自动", "name": "自动", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "强制开", "name": "强制开", 'value1': "SETTING_ENUM_1", "value": 1},
      {"label": "强制关", "name": "强制关", 'value1': "SETTING_ENUM_2", "value": 2}
    ],
    "dehumidityStandbyFanSpeed": [
      {"label": "关风机", "name": "关风机", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "L1", "name": "L1", 'value1': "SETTING_ENUM_1", "value": 1},
      {"label": "L2", "name": "L2", 'value1': "SETTING_ENUM_2", "value": 2},
      {"label": "1档", "name": "1档", 'value1': "SETTING_ENUM_3", "value": 3}
    ],
    "termalStopFanTime": [
      {"label": "停风机", "name": "停风机", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "4分钟", "name": "4分钟", 'value1': "SETTING_ENUM_1", "value": 1},
      {"label": "8分钟", "name": "8分钟", 'value1': "SETTING_ENUM_2", "value": 2},
      {"label": "12分钟", "name": "12分钟", 'value1': "SETTING_ENUM_3", "value": 3},
      {"label": "16分钟", "name": "16分钟", 'value1': "SETTING_ENUM_4", "value": 4}
    ],
    "coolingAutoFanSpeedUpperLimit": [
      {"label": "4档", "name": "4档", 'value1': "SETTING_ENUM_4", "value": 4},
      {"label": "5档", "name": "5档", 'value1': "SETTING_ENUM_5", "value": 5},
      {"label": "6档", "name": "6档", 'value1': "SETTING_ENUM_6", "value": 6},
      {"label": "7档", "name": "7档", 'value1': "SETTING_ENUM_7", "value": 7}
    ],
    "heatingAutoFanSpeedUpperLimit": [
      {"label": "4档", "name": "4档", 'value1': "SETTING_ENUM_4", "value": 4},
      {"label": "5档", "name": "5档", 'value1': "SETTING_ENUM_5", "value": 5},
      {"label": "6档", "name": "6档", 'value1': "SETTING_ENUM_6", "value": 6},
      {"label": "7档", "name": "7档", 'value1': "SETTING_ENUM_7", "value": 7}
    ],
    "constantAirVolumeSetting": [
      {"label": "无恒风量", "name": "无恒风量", 'value1': "SETTING_ENUM_0", "value": 0},
      {
        "label": "有恒风量(非能力优先)",
        "name": "有恒风量(非能力优先)",
        'value1': "SETTING_ENUM_1",
        "value": 1
      },
      {
        "label": "有恒风量(能力优先)",
        "name": "有恒风量(能力优先)",
        'value1': "SETTING_ENUM_2",
        "value": 2
      }
    ],
    "highPatioCorrectionFactor": [
      {"label": "3米", "name": "3米", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "4米", "name": "4米", 'value1': "SETTING_ENUM_1", "value": 1},
      {"label": "4.5米", "name": "4.5米", 'value1': "SETTING_ENUM_2", "value": 2}
    ],
    "independentSwing1Sel": [
      {"label": "自由控制", "name": "自由控制", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "关闭", "name": "关闭", 'value1': "SETTING_ENUM_1", "value": 1}
    ],
    "multipleControlSetting": [
      {"label": "否", "name": "否", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "是", "name": "是", 'value1': "SETTING_ENUM_1", "value": 1}
    ],
    "remoteShutdownSetting": [
      {"label": "闭合远程关", "name": "闭合远程关", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "断开远程关", "name": "断开远程关", 'value1': "SETTING_ENUM_1", "value": 1}
    ],
    "remoteOnOffDelayTime": [
      {"label": "无延时", "name": "无延时", 'value1': "SETTING_ENUM_0", "value": 0},
      {
        "label": "延时1min",
        "name": "延时1min",
        'value1': "SETTING_ENUM_1",
        "value": 1
      },
      {
        "label": "延时2min",
        "name": "延时2min",
        'value1': "SETTING_ENUM_2",
        "value": 2
      },
      {
        "label": "延时3min",
        "name": "延时3min",
        'value1': "SETTING_ENUM_3",
        "value": 3
      },
      {
        "label": "延时4min",
        "name": "延时4min",
        'value1': "SETTING_ENUM_4",
        "value": 4
      },
      {
        "label": "延时5min",
        "name": "延时5min",
        'value1': "SETTING_ENUM_5",
        "value": 5
      },
      {
        "label": "延时10min",
        "name": "延时10min",
        'value1': "SETTING_ENUM_6",
        "value": 6
      }
    ],
    "indoorAlarmSetting": [
      {"label": "闭合报警", "name": "闭合报警", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "断开报警", "name": "断开报警", 'value1': "SETTING_ENUM_1", "value": 1}
    ],
    "preheatingOpenTemp": [
      {"label": "5℃", "name": "5℃", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "0℃", "name": "0℃", 'value1': "SETTING_ENUM_1", "value": 1},
      {"label": "-5℃", "name": "-5℃", 'value1': "SETTING_ENUM_2", "value": 2}
    ],
    "sterilizationSetting": [
      {"label": "无杀菌", "name": "无杀菌", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "有杀菌", "name": "有杀菌", 'value1': "SETTING_ENUM_1", "value": 1}
    ],
    "selfCleanDryingTimeSetting": [
      {"label": "10分钟", "name": "10分钟", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "20分钟", "name": "20分钟", 'value1': "SETTING_ENUM_1", "value": 1},
      {"label": "30分钟", "name": "30分钟", 'value1': "SETTING_ENUM_2", "value": 2},
      {"label": "40分钟", "name": "40分钟", 'value1': "SETTING_ENUM_3", "value": 3}
    ],
    "antiMouldyBlowTimeSetting": [
      {"label": "无效", "name": "无效", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "60s", "name": "60s", 'value1': "SETTING_ENUM_1", "value": 1},
      {"label": "90s", "name": "90s", 'value1': "SETTING_ENUM_2", "value": 2},
      {"label": "120s", "name": "120s", 'value1': "SETTING_ENUM_3", "value": 3}
    ],
    "antiBlowDirtyCeilingSetting": [
      {"label": "无效", "name": "无效", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "有效", "name": "有效", 'value1': "SETTING_ENUM_1", "value": 1}
    ],
    "antiCondensationSetting": [
      {"label": "无效", "name": "无效", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "有效", "name": "有效", 'value1': "SETTING_ENUM_1", "value": 1}
    ],
    "humanSensorNomanTime": [
      {"label": "15min", "name": "15min", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "30min", "name": "30min", 'value1': "SETTING_ENUM_1", "value": 1},
      {"label": "45min", "name": "45min", 'value1': "SETTING_ENUM_2", "value": 2},
      {"label": "60min", "name": "60min", 'value1': "SETTING_ENUM_3", "value": 3},
      {"label": "90min", "name": "90min", 'value1': "SETTING_ENUM_4", "value": 4},
      {
        "label": "120min",
        "name": "120min",
        'value1': "SETTING_ENUM_5",
        "value": 5
      }
    ],
    "humanSensorDiffTemp": [
      {"label": "1℃", "name": "1℃", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "1℃", "name": "2℃", 'value1': "SETTING_ENUM_1", "value": 1},
      {"label": "1℃", "name": "3℃", 'value1': "SETTING_ENUM_2", "value": 2},
      {"label": "1℃", "name": "4℃", 'value1': "SETTING_ENUM_3", "value": 3}
    ],
    "nomanStopDelayTimeSetting": [
      {"label": "15℃", "name": "15℃", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "30℃", "name": "30℃", 'value1': "SETTING_ENUM_1", "value": 1},
      {"label": "45℃", "name": "45℃", 'value1': "SETTING_ENUM_2", "value": 2},
      {"label": "60℃", "name": "60℃", 'value1': "SETTING_ENUM_3", "value": 3},
      {"label": "90℃", "name": "90℃", 'value1': "SETTING_ENUM_4", "value": 4},
      {"label": "120℃", "name": "120℃", 'value1': "SETTING_ENUM_5", "value": 5}
    ],
    "coolingMpcLevel": [
      {"label": "关闭节电", "name": "关闭节电", 'value1': "SETTING_ENUM_0", "value": 0},
      {
        "label": "MPC节能等级1-低",
        "name": "MPC节能等级1-低",
        'value1': "SETTING_ENUM_1",
        "value": 1
      },
      {
        "label": "MPC节能等级2-中",
        "name": "MPC节能等级2-中",
        'value1': "SETTING_ENUM_2",
        "value": 2
      }
    ],
    "heatingMpcLevel": [
      {"label": "关闭节电", "name": "关闭节电", 'value1': "SETTING_ENUM_0", "value": 0},
      {
        "label": "MPC节能等级1-低",
        "name": "MPC节能等级1-低",
        'value1': "SETTING_ENUM_1",
        "value": 1
      },
      {
        "label": "MPC节能等级2-中",
        "name": "MPC节能等级2-中",
        'value1': "SETTING_ENUM_2",
        "value": 2
      }
    ],
    "powerDownSetting": [
      {"label": "无掉电记忆", "name": "无掉电记忆", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "有掉电记忆", "name": "有掉电记忆", 'value1': "SETTING_ENUM_1", "value": 1}
    ],
    "heatingIdleOpenningSetting": [
      {"label": "224P", "name": "224P", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "288P", "name": "288P", 'value1': "SETTING_ENUM_1", "value": 1},
      {"label": "0P", "name": "0P", 'value1': "SETTING_ENUM_2", "value": 2},
      {"label": "自动调节", "name": "自动调节", 'value1': "SETTING_ENUM_14", "value": 14}
    ],
    "fieldCorrectionFactor": [
      {"label": "1", "name": "1", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "1.05", "name": "1.05", 'value1': "SETTING_ENUM_1", "value": 1},
      {"label": "1.1", "name": "1.1", 'value1': "SETTING_ENUM_2", "value": 2},
      {"label": "1.15", "name": "1.15", 'value1': "SETTING_ENUM_3", "value": 3},
      {"label": "0.95", "name": "0.95", 'value1': "SETTING_ENUM_4", "value": 4},
      {"label": "0.9", "name": "0.9", 'value1': "SETTING_ENUM_5", "value": 5},
      {"label": "0.85", "name": "0.85", 'value1': "SETTING_ENUM_6", "value": 6}
    ],
    "diffPressureStartToEnd": [
      {"label": "10Pa", "name": "10Pa", 'value1': "SETTING_ENUM_0", "value": 0},
      {"label": "20Pa", "name": "20Pa", 'value1': "SETTING_ENUM_0", "value": 1},
      {"label": "30Pa", "name": "30Pa", 'value1': "SETTING_ENUM_0", "value": 2},
      {"label": "40Pa", "name": "40Pa", 'value1': "SETTING_ENUM_0", "value": 3},
      {"label": "50Pa", "name": "50Pa", 'value1': "SETTING_ENUM_0", "value": 4},
      {"label": "60Pa", "name": "60Pa", 'value1': "SETTING_ENUM_0", "value": 5},
      {"label": "70Pa", "name": "70Pa", 'value1': "SETTING_ENUM_0", "value": 6},
      {"label": "80Pa", "name": "80Pa", 'value1': "SETTING_ENUM_0", "value": 7},
      {"label": "90Pa", "name": "90Pa", 'value1': "SETTING_ENUM_0", "value": 8},
      {"label": "100Pa", "name": "100Pa", 'value1': "SETTING_ENUM_0", "value": 9},
      {
        "label": "110Pa",
        "name": "110Pa",
        'value1': "SETTING_ENUM_0",
        "value": 10
      },
      {
        "label": "120Pa",
        "name": "120Pa",
        'value1': "SETTING_ENUM_0",
        "value": 11
      },
      {
        "label": "130Pa",
        "name": "130Pa",
        'value1': "SETTING_ENUM_0",
        "value": 12
      },
      {
        "label": "140Pa",
        "name": "140Pa",
        'value1': "SETTING_ENUM_0",
        "value": 13
      },
      {
        "label": "150Pa",
        "name": "150Pa",
        'value1': "SETTING_ENUM_0",
        "value": 14
      },
      {
        "label": "160Pa",
        "name": "160Pa",
        'value1': "SETTING_ENUM_0",
        "value": 15
      },
      {
        "label": "170Pa",
        "name": "170Pa",
        'value1': "SETTING_ENUM_0",
        "value": 16
      },
      {
        "label": "180Pa",
        "name": "180Pa",
        'value1': "SETTING_ENUM_0",
        "value": 17
      },
      {
        "label": "190Pa",
        "name": "190Pa",
        'value1': "SETTING_ENUM_0",
        "value": 18
      },
      {
        "label": "200Pa",
        "name": "200Pa",
        'value1': "SETTING_ENUM_0",
        "value": 19
      },
    ]
  };
  ;

// 提取 `name` 字段作为键值对
function extractNames(data) {
  const result = {};

  Object.keys(data).forEach((key) => {
    const items = data[key];
    if (Array.isArray(items)) {
      items.forEach((item) => {
        if (item.name) {
          result[item.name] = item.name;
        }
      });
    }
  });

  return result;
}

// 转换数据
const result = extractNames(data);

// 将结果写入 JSON 文件
const filePath = "./output.json";

fs.writeFile(filePath, JSON.stringify(result, null, 2), (err) => {
  if (err) {
    console.error("写入文件失败:", err);
  } else {
    console.log(`JSON 文件已成功生成: ${filePath}`);
  }
});
