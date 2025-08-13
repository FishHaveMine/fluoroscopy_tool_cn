package com.example.fluoroscopy_tool

class OduSalesBoardReplaceParameters(
    var oduHorses: Double? = null,
    var productSerial: Int? = null, // Bit5：压缩机辅配2（用于后期同一品牌压缩机辅配）
    var electricChassisHeating: Int? = null, // Bit3~2：底盘电加热，0无底盘电加热，1有底盘电加热，3维持不变
    var technicalBarriers: Int? = null, // Bit7~6：技术阻隔，0无效，1有效，3维持不变
    var parallelType: Int? = null, // Bit5~4：0并联式，1独立式，3维持不变
    var compressBrand: Int? = null, // Bit2~0：压缩机品牌：0美芝，1日立，2三菱
    var multipleWaterSources: Int? = null, // Bit5：1水源多联，0非水源多联
    var bigVrf: Int? = null, // Bit3：0大多联，1小多联
    var electronicLock: Int? = null, // Bit1~0：电子锁，0无电子锁机型，1电子锁机型
    var compressSelect: Int? = null, // Bit6：压缩机辅配（用于后期同一品牌压缩机辅配）0基准，已有机型默认0；1辅配，新品设置
    var compressType: Int? = null, // Bit4~3：压缩机类型，0涡旋，1转子
    var airOutletWay: Int? = null, // Bit4：0顶出风，1侧出风
    var powerType: Int? = null, // Bit2~0:电源 0-380V,1-220V-3N,2-480V，3-220V-1N，4-直流750V，5-直流375V
    var refrigerantType: Int? = null, // Bit3~2：冷媒类型，0-410A，1-R32，2-R454B,3维持不变
    var derivedSeries: Int? = null, // 0基准版，1多联王SE，2印度版本，3欧盟版，4Pro系列，5一拖N套机,6韩国，7欧盟高能效，8科威特版本，9新加坡，10旧改新生
    var electricControlBoxHeating: Int? = null, // Bit5~4：电控盒电加热，0无电控盒加热，1有电控盒加热，3维持不变
    var packageOptions: Int? = null, // Bit3~0：0无效，1~8一拖一~八，15维持不变
    var fanMotorType: Int? = null, // Bit7~5：风机类型：0常规版，1高静压版，2反转常规版，3反转高静压版
    var refrigerationCycleSetting: Int? = null, // Bit7~6：0热泵，1热回收，2单冷
    var myhomeConnectSetting: Int? = null // Bit7：0非MyHome，1MyHome（V6协议时用，小多联时=1）
)
