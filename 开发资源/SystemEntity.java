package com.mideaibp.apps.service.dto;

import com.mideaibp.apps.model.SystemInfo;
import lombok.Data;

import java.util.List;

@Data
public class SystemEntity {

    /**
     * 主机sn
     */
    private String masterSn;

    /**
     * 从机sn
     */
    private List<String> salveSnList;

    /**
     * 系统内机台数
     */
    private Integer systemIndoorNum;

    /**
     * 系统协议类型
     */
    private String protocol = SystemInfo.Instance().get_ProtocolVersion().name();

    /**
     * 运行模式
     */
    private String mode;

    /**
     * 设置内机台数
     */
    private Integer settingIndoorNum;

    /**
     * 检测内机台数
     */
    private Integer checkIndoorNum;

    /**
     * 内机运行台数
     */
    private Integer workingIndoorNum;

    /**
     * 是否全V8内机
     */
    private boolean isAllV8Indoor;

    /**
     * 连接设置
     */
    private String linkSetting;

    /**
     * 室内机管温平均T2/T2B
     */
    private Double indoorAvgTem;

    /**
     * 系统目标蒸发温度TeS
     */
    private Double systemEvaTem;

    /**
     * 系统目标冷凝温度TCS
     */
    private Double systemConTem;

    /**
     * TcMax
     */
    private Double tcMax;

    /**
     * TeMin
     */
    private Double teMin;

    /**
     * 流量使用
     */
    private String trafficUsage;

    /**
     * 主外机功率
     */
    private Double outdoor0Power;

    /**
     * 静音模式
     */
    private String silentMode;

    /**
     * 限电状态
     */
    private String powerLimit;

    /**
     * MPC
     */
    private String mpc;

    /**
     * 模式优先设置
     */
    private String priorModeSetting;
}
