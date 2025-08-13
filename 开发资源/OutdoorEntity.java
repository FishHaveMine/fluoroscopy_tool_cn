package com.mideaibp.apps.service.dto;

import lombok.Data;


@Data
public class OutdoorEntity {

    /**
     *地址
     */
    private Integer address;

    /**
     * sn
     */
    private String sn;

    /**
     * 匹数
     */
    private String outdoorHorse;

    /**
     * 限频状态
     */
    private String frequencyLimitingState;

    /**
     * 风速1
     */
    private Integer windSpeed1;

    /**
     * 风速2
     */
    private Integer windSpeed2;

    /**
     * 外机交流电压
     */
    private Integer externalACVoltage;

    /**
     * 一次电流
     */
    private Integer primaryCurrent;

    /**
     * 外机脏堵率
     */
    private Integer outdoorBlockageRate;

    /**
     * 当前故障
     */
    private String errorCode;

    /**
     * 网络地址
     */
    private String sysIdx;

    /**
     * 电源质量
     */
    private Integer powerQuality;

    /**
     * 程序版本
     */
    private String version;

    /**
     * 高压压力
     */
    private Double highPressure;

    /**
     * 低压压力
     */
    private Double lowPressure;

    /**
     * 高压饱和温度
     */
    private Double highPressureSaturationTemp;

    /**
     * 低压饱和温度
     */
    private Double lowPressureSaturationTemp;

    /**
     * 压缩机1频率
     */
    private Integer compressor1Frequency;

    /**
     * 压缩机2频率
     */
    private Integer compressor2Frequency;

    /**
     * 压缩机1直流电压
     */
    private Integer directVoltage1;

    /**
     * 压缩机2直流电压
     */
    private Integer directVoltage2;

    /**
     * 压缩机1电流
     */
    private Integer compressorElectric1;

    /**
     * 压缩机2电流
     */
    private Integer compressorElectric2;

    /**
     * 压缩机1累计运行时间
     */
    private Integer compressorRunTime1;

    /**
     * 压缩机2累计运行时间
     */
    private Integer compressorRunTime2;

    /**
     * 环境温度T4
     */
    private Double t4Temp;

    /**
     * 外机换热器管温T3
     */
    private Double t3Temp;

    /**
     * 外机液管温度T5
     */
    private Double t5Temp;

    /**
     * 板换入口温度T6A
     */
    private Double t6ATemp;

    /**
     * 板换出口温度T6B
     */
    private Double t6BTemp;

    /**
     * 外机换热器冷入温度T8
     */
    private Double t8Temp;

    /**
     * 外机换热器冷出温度TL
     */
    private Double tlTemp;

    /**
     * Tg
     */
    private Double tg;

    /**
     * 外机电控散热器温度NTC1
     */
    private Integer radiatorTemp1;

    /**
     * 外机电控散热器温度NTC2
     */
    private Integer radiatorTemp2;

    /**
     * 压缩机1排气温度T7C1
     */
    private Integer t7C1Temp;

    /**
     * 压缩机2排气温度T7C2
     */
    private Integer t7C2Temp;

    /**
     * 压缩机1回气温度T71
     */
    private Double t71Temp;

    /**
     * 压缩机2回气温度T72
     */
    private Double t72Temp;

    /**
     * 外机排气过热度
     */
    private Integer superHeatTemp;

    /**
     * EXVA开度
     */
    private Integer exva;

    /**
     * EXVB开度
     */
    private Integer exvb;

    /**
     * EXVC开度
     */
    private Integer exvc;

    /**
     * EEVD开度
     */
    private Integer eevd;

    /**
     * SV5
     */
    private String sv5;

    /**
     * SV6
     */
    private String sv6;

    /**
     * SV7
     */
    private String sv7;

    /**
     * SV8A
     */
    private String sv8A;

    /**
     * SV8B
     */
    private String sv8B;

}
