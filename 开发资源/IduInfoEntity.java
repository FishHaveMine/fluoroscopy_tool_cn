package com.mideaibp.apps.service.dto;

import com.mideaibp.apps.model.common.IduTypeEnum;
import lombok.Data;

public class IduInfoEntity {

  /**
   * 机型
   */
  private Object iduType = 0;

  /**
   * 运行模式
   */
  private String runModel;

  /**
   * 运行模式标识
   */
  private int runModelIndex;

  /**
   * 锁定
   */
  private Object locks = 0;

  /**
   * 设备控制面板的参数
   */
  private IDUData _iduData;
} 
public class IndoorEntity {

    /**
     * 室内机地址
     */
    private int address;

    /**
     * sn
     */
    private String sn;

    /**
     * 内机类型
     */
    private IduTypeEnum indoorType;

    /**
     * 室内机匹数
     */
    private Double indoorHouse;

    /**
     * 开关机状态
     */
    private String onOff;

    /**
     * 运行模式
     */
    private String mode;

    /**
     * 风档
     */
    private String parmFan;

    /**
     * 设定温度
     */
    private Double settingTemp;

    /**
     * 室内温度
     */
    private Double roomTemp;

    /**
     * T2A蒸入温度
     */
    private Double t2ATemp;

    /**
     * T2蒸中温度
     */
    private Double t2Temp;

    /**
     * T2B蒸出温度
     */
    private Double t2BTemp;

    /**
     * EXV开度
     */
    private Double evx;

    /**
     * 当前故障
     */
    private String errorCode;

    /**
     * 内机软件主版本
     */
    private Integer indoorSoftwareVersion;

    /**
     * 内机软件子版本
     */
    private Integer indoorSubSoftwareVersion;

    /**
     * V6室外机
     */
    private Boolean isV6;

    /**
     * 出风温度
     */
    private Double outletAirTemp;

    /**
     * 设备名称
     */
    private String deviceName;
}
