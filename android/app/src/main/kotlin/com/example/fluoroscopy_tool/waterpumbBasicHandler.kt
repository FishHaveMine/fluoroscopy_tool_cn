package com.example.fluoroscopy_tool


import android.os.Build
import androidx.annotation.RequiresApi
import cn.hutool.json.JSONObject
import com.alibaba.fastjson.JSON
import com.google.gson.Gson
import com.mideaibp.agent.container.HttpUtilContainer
import com.mideaibp.apps.model.dto.MonitorData
import com.mideaibp.apps.service.ApplicationService
import com.mideaibp.apps.service.waterMachine.ConnectionService
import com.mideaibp.apps.service.waterMachine.DeviceUnlockService
import com.mideaibp.apps.service.waterMachine.constant.WaterDeviceTypeEnum
import com.mideaibp.apps.service.waterMachine.dto.CentrifugalChiller
import com.mideaibp.apps.service.waterMachine.dto.GenerateCodeRequest
import com.mideaibp.apps.service.waterMachine.dto.MagneticLevitationChiller
import com.mideaibp.apps.service.waterMachine.dto.WaterCooledChiller
import com.mideaibp.apps.service.waterMachine.dto.WaterMachineDTO
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.Calendar
import kotlin.random.Random

class waterpumbBasicHandler(flutterEngine: BinaryMessenger, private val channel: MethodChannel) : MethodChannel.MethodCallHandler {
    var DeviceUnlock =  DeviceUnlockService.getInstance();
    var Connection =  ConnectionService.getInstance();
    val gson: Gson = Gson()
    init {
        channel.setMethodCallHandler(this)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "initwaterData" -> initwaterData(call,result)
            "getformdata" -> getformdata(call,result)
            "getConnection" -> getConnection(call,result)
            "applicationSwitching" -> applicationSwitching(call,result)
            "clearInstance" -> clearInstance(call,result)
            "getWaterMachineDTO" -> getWaterMachineDTO(call,result)
            "getWaterDeviceTypeEnum" -> getWaterDeviceTypeEnum(call,result)
            "sendPassword" -> sendPassword(call,result)
            "toOffLineToGenCode" -> offLineToGenCodefun(call,result)
        }
    }
    private fun gettypebyName( devicetype:String): WaterDeviceTypeEnum {
        var enumObj:WaterDeviceTypeEnum  = WaterDeviceTypeEnum.CENTRIFUGAL_CHILLER;
        var back = WaterDeviceTypeEnum.values()
        back.forEach { file ->
            if (file.cn == devicetype || file.en == devicetype ) {
                enumObj = file;
            }
        }
        return enumObj;
    }
    private fun initwaterData(call: MethodCall, result: MethodChannel.Result) {
        try{
            Connection.initData()
            val js = JSONObject()
            js.put("errorCode", 200);
            js.put("data", intArrayOf());
            val json: String = gson.toJson(js)
            result.success(json)
        } catch (e: Exception) {
            println("offLineToGenCode: $e");
            val js = JSONObject()
            js.put("errorCode", 1000);
            js.put("data", intArrayOf());
            result.success(js)
        }
    }
    // 为Double添加格式化扩展函数
    fun Double.format(digits: Int): String {
        return "%.${digits}f".format(this)
    }
    private fun getformdata(call: MethodCall, result: MethodChannel.Result) {
        val step = call.argument<Int>("step")

        HttpUtilContainer.executor.execute(
            Runnable {
                try{
                    val isDebug = false
                    if(step == 2) {
                        val js = JSONObject()
                        if (isDebug) {
                            val deviceInfo = JSONObject()
                            deviceInfo.put("sn", "SIMULATED-SN-20250526") // 模拟序列号
                            deviceInfo.put("expansionValveControllerVersion", "V1.5.2") // 模拟膨胀阀控制器版本
                            js.put("errorCode", 200);
                            js.put("data", deviceInfo);
                        } else {
                            var back = Connection.getExpansionValveControllerVersion()
                            var realdata = WaterMachineDTO.getInstance();

                            println("Connection.getExpansionValveControllerVersion() 1 : ${back}")
                            if (back.data) {
                                val deviceInfo = JSONObject()
                                deviceInfo.put("sn", realdata.getMagneticLevitationChiller().sn)
                                deviceInfo.put(
                                    "expansionValveControllerVersion",
                                    realdata.getMagneticLevitationChiller().expansionValveControllerVersion
                                )
                                js.put("errorCode", 200);
                                js.put("data", deviceInfo);
                            } else {
                                js.put("errorCode", 500);
                            }
                        }
                        val json: String = gson.toJson(js)
                        result.success(json)
                    }

                    if(step == 3) {
                        val js = JSONObject()
                        if (isDebug) {
                            val deviceInfo = JSONObject()
                            deviceInfo.put("sn", "SIMULATED-SN-20250526") // 模拟序列号
                            deviceInfo.put("targetTemp", "7.0")
                            deviceInfo.put("evaporatorControlTemperature", "5.5")
                            deviceInfo.put("exitPauseTemperatureDifference", "1.0")
                            deviceInfo.put("enterPauseTemperatureDifference", "2.0")
                            deviceInfo.put("capacityRegulationTemperatureDifference", "0.5")
                            deviceInfo.put("fanRegulatesTemperatureDifference", "2.5")
                            deviceInfo.put("coolingTowerFanUnit1ShutdownTemperature", "28.0")
                            deviceInfo.put("coolingTowerFanUnit1OpeningTemperature", "30.0")
                            deviceInfo.put("coolingTowerFanUnit2ShutdownTemperature", "26.0")
                            deviceInfo.put("coolingTowerFanUnit2OpeningTemperature", "29.0")
                            deviceInfo.put("controlMode", "就地")
                            deviceInfo.put("runningMode", "制冷")
                            deviceInfo.put("inletAndOutletWaterControl", "进水控制")
                            deviceInfo.put("ratedCurrentOfTheHost", "150.0")
                            deviceInfo.put("minimumAtmosphericPressure", "98.5")
                            deviceInfo.put("pressureSensorUpperLimitSetting", "120.0")
                            deviceInfo.put("targetLiquidLevelOfEvaporator", "50")
                            deviceInfo.put("fullLoadPowerRefrigeration", "350.0")
                            deviceInfo.put("refrigerationAndIceStoragePower", "280.0")
                            deviceInfo.put("compressorShutdownInterval", "15")
                            deviceInfo.put("compressorStarInterval", "30")
                            deviceInfo.put("fastStartReadySignalJudgmentDelay", "500")
                            deviceInfo.put("inverterMainControlSoftwareVersion", "V2.3.1")
                            deviceInfo.put("compressorVersion", "V1.8.2")
                            deviceInfo.put("maglevVersion", "V3.0.0")
                            deviceInfo.put("az1", "0")
                            deviceInfo.put("fx1", "0")
                            deviceInfo.put("fy1", "0")
                            deviceInfo.put("rx1", "0")
                            deviceInfo.put("ry1", "0")


                            deviceInfo.put("az3", "0")
                            deviceInfo.put("fx3", "0")
                            deviceInfo.put("fy3", "0")
                            deviceInfo.put("rx3", "0")
                            deviceInfo.put("ry3", "0")


                            deviceInfo.put("az2", "0")
                            deviceInfo.put("fx2", "0")
                            deviceInfo.put("fy2", "0")
                            deviceInfo.put("rx2", "0")
                            deviceInfo.put("ry2", "0")
                            js.put("errorCode", 200);
                            js.put("data", deviceInfo);
                        } else {
                            var back = Connection.getMagneticLevitationChillerUserParam()
                            if (back.data) {
                                var realdata = WaterMachineDTO.getInstance();
                                val deviceInfo = JSONObject()
                                deviceInfo.put("sn", realdata.sn)

                                val chiller = realdata.getMagneticLevitationChiller()
                                deviceInfo.put("targetTemp", chiller.targetTemp)
                                deviceInfo.put(
                                    "evaporatorControlTemperature",
                                    chiller.evaporatorControlTemperature
                                )
                                deviceInfo.put(
                                    "exitPauseTemperatureDifference",
                                    chiller.exitPauseTemperatureDifference
                                )
                                deviceInfo.put(
                                    "enterPauseTemperatureDifference",
                                    chiller.enterPauseTemperatureDifference
                                )
                                deviceInfo.put(
                                    "capacityRegulationTemperatureDifference",
                                    chiller.capacityRegulationTemperatureDifference
                                )
                                deviceInfo.put(
                                    "fanRegulatesTemperatureDifference",
                                    chiller.fanRegulatesTemperatureDifference
                                )
                                deviceInfo.put(
                                    "coolingTowerFanUnit1ShutdownTemperature",
                                    chiller.coolingTowerFanUnit1ShutdownTemperature
                                )
                                deviceInfo.put(
                                    "coolingTowerFanUnit1OpeningTemperature",
                                    chiller.coolingTowerFanUnit1OpeningTemperature
                                )
                                deviceInfo.put(
                                    "coolingTowerFanUnit2ShutdownTemperature",
                                    chiller.coolingTowerFanUnit2ShutdownTemperature
                                )
                                deviceInfo.put(
                                    "coolingTowerFanUnit2OpeningTemperature",
                                    chiller.coolingTowerFanUnit2OpeningTemperature
                                )
                                // 将controlMode数值映射为文字描述
                                val controlModeMap = mapOf(
                                    "0" to "就地",
                                    "1" to "远程",
                                    "2" to "定时",
                                    "3" to "BMS"
                                )
                                // 0=就地，1=远程，2=定时，3=BMS
                                // 根据实际值获取描述，如果不存在则使用原始值
                                val controlModeDesc = controlModeMap[chiller.controlMode] ?: chiller.controlMode
                                deviceInfo.put("controlMode", controlModeDesc)

                                // runningModeMap
                                val runningModeMap = mapOf(
                                    "0" to "制冷",
                                    "1" to "制热",
                                    "2" to "水泵",
                                    "3" to "蓄冰"
                                )
                                // 0=就地，1=远程，2=定时，3=BMS
                                // 根据实际值获取描述，如果不存在则使用原始值
                                val runningModeDesc = runningModeMap[chiller.runningMode] ?: chiller.runningMode
                                deviceInfo.put("runningMode", runningModeDesc)


                                // runningModeMap
                                val inletAndOutletWaterControlMap = mapOf(
                                    "0" to "出水控制",
                                    "1" to "进水控制",
                                )
                                // 0=就地，1=远程，2=定时，3=BMS
                                // 根据实际值获取描述，如果不存在则使用原始值
                                val inletAndOutletWaterControlDesc = inletAndOutletWaterControlMap[chiller.inletAndOutletWaterControl] ?: chiller.inletAndOutletWaterControl
                                deviceInfo.put(
                                    "inletAndOutletWaterControl",
                                    inletAndOutletWaterControlDesc
                                )
                                deviceInfo.put(
                                    "ratedCurrentOfTheHost",
                                    chiller.ratedCurrentOfTheHost
                                )
                                deviceInfo.put(
                                    "minimumAtmosphericPressure",
                                    chiller.minimumAtmosphericPressure
                                )
                                deviceInfo.put(
                                    "pressureSensorUpperLimitSetting",
                                    chiller.pressureSensorUpperLimitSetting
                                )
                                deviceInfo.put(
                                    "targetLiquidLevelOfEvaporator",
                                    chiller.targetLiquidLevelOfEvaporator
                                )
                                deviceInfo.put(
                                    "fullLoadPowerRefrigeration",
                                    chiller.fullLoadPowerRefrigeration
                                )
                                deviceInfo.put(
                                    "refrigerationAndIceStoragePower",
                                    chiller.refrigerationAndIceStoragePower
                                )
                                deviceInfo.put(
                                    "compressorShutdownInterval",
                                    chiller.compressorShutdownInterval
                                )
                                deviceInfo.put(
                                    "compressorStarInterval",
                                    chiller.compressorStarInterval
                                )
                                deviceInfo.put(
                                    "fastStartReadySignalJudgmentDelay",
                                    chiller.fastStartReadySignalJudgmentDelay
                                )
                                deviceInfo.put(
                                    "inverterMainControlSoftwareVersion",
                                    chiller.inverterMainControlSoftwareVersion
                                )
                                deviceInfo.put("compressorVersion", chiller.compressorVersion)
                                deviceInfo.put("maglevVersion", chiller.maglevVersion)
                                deviceInfo.put("az1", chiller.az1)
                                deviceInfo.put("fx1", chiller.fx1)
                                deviceInfo.put("fy1", chiller.fy1)
                                deviceInfo.put("rx1", chiller.rx1)
                                deviceInfo.put("ry1", chiller.ry1)
                                deviceInfo.put("az2", chiller.az2)
                                deviceInfo.put("fx2", chiller.fx2)
                                deviceInfo.put("fy2", chiller.fy2)
                                deviceInfo.put("rx2", chiller.rx2)
                                deviceInfo.put("ry2", chiller.ry2)
                                deviceInfo.put("az3", chiller.az3)
                                deviceInfo.put("fx3", chiller.fx3)
                                deviceInfo.put("fy3", chiller.fy3)
                                deviceInfo.put("rx3", chiller.rx3)
                                deviceInfo.put("ry3", chiller.ry3)
                                js.put("errorCode", 200);
                                js.put("data", deviceInfo);
                            } else {
                                js.put("errorCode", 500);
                            }
                        }
                        val json: String = gson.toJson(js)
                        result.success(json)
                    }

                    if(step == 4) {

                        val js = JSONObject()
                        if (isDebug) {

                            val deviceInfo = JSONObject()
                            deviceInfo.put("sn", "SIMULATED-SN-20250526")


                            // 生成随机数的辅助函数
                            val random = java.util.Random()

                            // 温度参数 (范围 ±2°C)
                            val baseChilledInTemp = 12.5
                            val baseChilledOutTemp = 7.0
                            val baseCoolingInTemp = 32.0
                            val baseCoolingOutTemp = 37.0

                            // 压力参数 (范围 ±5%)
                            val baseEvaporatorPressure = 450.0
                            val baseCondenserPressure = 1200.0

                            // 设备运行参数（随机数值）
                            deviceInfo.put("inletTemperatureOfChilledWater", (baseChilledInTemp + random.nextDouble() * 4 - 2).format(1))
                            deviceInfo.put("outletTemperatureOfChilledWater", (baseChilledOutTemp + random.nextDouble() * 4 - 2).format(1))
                            deviceInfo.put("coolingWaterInletTemperature", (baseCoolingInTemp + random.nextDouble() * 4 - 2).format(1))
                            deviceInfo.put("coolingWaterOutletTemperature", (baseCoolingOutTemp + random.nextDouble() * 4 - 2).format(1))
                            deviceInfo.put("evaporatorEvaporationPressure", (baseEvaporatorPressure + baseEvaporatorPressure * random.nextDouble() * 0.1 - baseEvaporatorPressure * 0.05).format(1))
                            deviceInfo.put("evaporatorSaturationTemperature", (deviceInfo.getDouble("inletTemperatureOfChilledWater") - 5 + random.nextDouble() * 2).format(1))
                            deviceInfo.put("temperatureDifferenceAtTheEvaporatorEnd", (random.nextDouble() * 2 + 1).format(1))
                            deviceInfo.put("condenserCondensationPressure", (baseCondenserPressure + baseCondenserPressure * random.nextDouble() * 0.1 - baseCondenserPressure * 0.05).format(1))
                            deviceInfo.put("condenserSaturationTemperature", (deviceInfo.getDouble("coolingWaterInletTemperature") + 5 + random.nextDouble() * 3).format(1))
                            deviceInfo.put("temperatureDifferenceAtTheCondenserEnd", (random.nextDouble() * 2 + 2).format(1))

                            // 导叶开度 (50-80%)
                            deviceInfo.put("guideVaneOpening1", (50 + random.nextInt(30)).toString())
                            deviceInfo.put("guideVaneOpening2", (50 + random.nextInt(30)).toString())
                            deviceInfo.put("guideVaneOpening3", (50 + random.nextInt(30)).toString())

                            // 功率百分比 (60-90%)
                            deviceInfo.put("powerPercentage", (60 + random.nextInt(30)).toString())


                            js.put("errorCode", 200);
                            js.put("data", deviceInfo);
                        } else{
                            var back = Connection.getMagneticLevitationChillerMachineRunData()
                            if (back.data) {
                                var realdata = WaterMachineDTO.getInstance();
                                val deviceInfo = JSONObject()
                                deviceInfo.put("sn", realdata.sn)
                                val chiller = realdata.getMagneticLevitationChiller()
                                deviceInfo.put("inletTemperatureOfChilledWater", chiller.inletTemperatureOfChilledWater)
                                deviceInfo.put("outletTemperatureOfChilledWater", chiller.outletTemperatureOfChilledWater)
                                deviceInfo.put("coolingWaterInletTemperature", chiller.coolingWaterInletTemperature)
                                deviceInfo.put("coolingWaterOutletTemperature", chiller.coolingWaterOutletTemperature)
                                deviceInfo.put("evaporatorEvaporationPressure", chiller.evaporatorEvaporationPressure)
                                deviceInfo.put("evaporatorSaturationTemperature", chiller.evaporatorSaturationTemperature)
                                deviceInfo.put("temperatureDifferenceAtTheEvaporatorEnd", chiller.temperatureDifferenceAtTheEvaporatorEnd)
                                deviceInfo.put("condenserCondensationPressure", chiller.condenserCondensationPressure)
                                deviceInfo.put("condenserSaturationTemperature", chiller.condenserSaturationTemperature)
                                deviceInfo.put("temperatureDifferenceAtTheCondenserEnd", chiller.temperatureDifferenceAtTheCondenserEnd)
                                deviceInfo.put("guideVaneOpening1", chiller.guideVaneOpening1)
                                deviceInfo.put("guideVaneOpening2", chiller.guideVaneOpening2)
                                deviceInfo.put("guideVaneOpening3", chiller.guideVaneOpening3)
                                deviceInfo.put("powerPercentage", chiller.powerPercentage)
                                js.put("errorCode", 200);
                                js.put("data", deviceInfo);
                            } else {
                                js.put("errorCode", 500);
                            }
                        }

                        val json: String = gson.toJson(js)
                        result.success(json)
                    }

                    /** 离心机组 */
                    if(step == 5){
                        val js = JSONObject()
                        var back = Connection.getCentrifugalChillerUserParam()
                        if (back.data) {

                            val properties = arrayOf(
                                "sn",
                                "targetTemp",
                                "evaporatorControlTemperature",
                                "exitPauseTemperatureDifference",
                                "enterPauseTemperatureDifference",
                                "capacityRegulationTemperatureDifference",
                                "fanRegulatesTemperatureDifference",
                                "coolingTowerFanUnit1ShutdownTemperature",
                                "coolingTowerFanUnit1OpeningTemperature",
                                "coolingTowerFanUnit2ShutdownTemperature",
                                "coolingTowerFanUnit2OpeningTemperature",
                                "controlMode",
                                "runningMode",
                                "inletAndOutletWaterControl",
                                "ratedCurrentOfTheHost",
                                "minimumAtmosphericPressure",
                                "pressureSensorUpperLimitSetting",
                                "targetLiquidLevelOfEvaporator",
                                "fullLoadPowerRefrigeration",
                                "fullLoadPowerIceStorage",
                                "compressorShutdownInterval",
                                "compressorStartupInterval",
                                "quickStartupSignalDetectionDelay",
                                "oilElectromagneticValveOpeningTime",
                                "oilElectromagneticValveClosingTime",
                                "oilHeatingOpenTemperature",
                                "oilHeatingClosingTemperature",
                                "oilPumpClosingTime",
                                "guideValveTravel",
                                "variableFrequencyConverterType",
                                "variableFrequencyConverterBaudRate",
                                "variableFrequencyConverterReadStartAddress",
                                "variableFrequencyConverterWriteStartAddress"
                            )

                            val realdata = WaterMachineDTO.getInstance().getCentrifugalChiller()
                            val deviceInfo = JSONObject()

                            for (property in properties) {
                                try {
                                    val field = CentrifugalChiller::class.java.getDeclaredField(property)
                                    field.isAccessible = true
                                    var value = field.get(realdata)
                                    if(property == "variableFrequencyConverterType"){
                                        // 将controlMode数值映射为文字描述
                                        val variableFrequencyConverterTypeMap = mapOf(
                                            "0" to "汇川",
                                            "1" to "四方",
                                            "2" to "预留",
                                            "3" to "汇川",
                                            "4" to "中车",
                                            "5" to "中车",
                                            "6" to "合康",
                                            "7" to "自制",
                                            "8" to "自制",
                                            "9" to "施耐德",
                                            "10" to "日业",
                                            "11" to "丹佛斯"
                                        )
                                        // 0=就地，1=远程，2=定时，3=BMS
                                        // 根据实际值获取描述，如果不存在则使用原始值
                                        value = variableFrequencyConverterTypeMap[value] ?:value
                                    }

                                    if(property == "controlMode") {
                                        // 将controlMode数值映射为文字描述
                                        val controlModeMap = mapOf(
                                            "0" to "就地",
                                            "1" to "远程",
                                            "2" to "定时",
                                            "3" to "BMS"
                                        )
                                        // 0=就地，1=远程，2=定时，3=BMS
                                        // 根据实际值获取描述，如果不存在则使用原始值
                                        value = controlModeMap[value] ?:value
                                    }

                                    if(property == "runningMode") {
                                        val runningModeMap = mapOf(
                                            "0" to "制冷",
                                            "1" to "制热",
                                            "2" to "水泵",
                                            "3" to "蓄冰"
                                        )
                                        // 0=就地，1=远程，2=定时，3=BMS
                                        // 根据实际值获取描述，如果不存在则使用原始值
                                        value = runningModeMap[value] ?: value
                                    }

                                    if(property == "inletAndOutletWaterControl"){
                                        // runningModeMap
                                        val inletAndOutletWaterControlMap = mapOf(
                                            "0" to "出水控制",
                                            "1" to "进水控制",
                                        )
                                        // 0=就地，1=远程，2=定时，3=BMS
                                        // 根据实际值获取描述，如果不存在则使用原始值
                                        value = inletAndOutletWaterControlMap[value] ?: value
                                    }

                                    println(" --------  ${property} : ${value}  --------  ")
                                    deviceInfo.put(property, value)
                                } catch (e: NoSuchFieldException) {

                                    println("CentrifugalChiller: $e");
                                    e.printStackTrace()
                                } catch (e: IllegalAccessException) {
                                    e.printStackTrace()
                                    println("CentrifugalChiller: $e");
                                }
                            }

                            println(" --------  ${deviceInfo}   --------  ")
                            js.put("errorCode", 200);
                            js.put("data", deviceInfo);

                        } else {
                            js.put("errorCode", 500);
                        }
                        val json: String = gson.toJson(js)
                        result.success(json)
                    }

                    /** 离心机组 */
                    if(step == 6){
                        val js = JSONObject()
                        var back = Connection.getCentrifugalChillerMachineRunData()
                        if (back.data) {
                            val properties = arrayOf(
                                "freezeWaterInletTemperature",
                                "freezeWaterOutletTemperature",
                                "coldWaterInletTemperature",
                                "coldWaterOutletTemperature",
                                "evaporatorEvaporationPressure",
                                "evaporatorSaturationTemperature",
                                "evaporatorTemperatureDifference",
                                "condenserCondensationPressure",
                                "condenserSaturationTemperature",
                                "condenserTemperatureDifference",
                                "oilSystemOilTemperature",
                                "oilSystemSupplyTemperature",
                                "oilSystemOilPressure",
                                "oilSystemSupplyPressure",
                                "oilSystemSupplyPressureDifference",
                                "guideValveOpeningDegree",
                                "currentPercentage"
                            )

                            val realdata = WaterMachineDTO.getInstance().getCentrifugalChiller()
                            val deviceInfo = JSONObject()

                            for (property in properties) {
                                try {
                                    val field = CentrifugalChiller::class.java.getDeclaredField(property)
                                    field.isAccessible = true
                                    val value = field.get(realdata)

                                    println(" --------  ${property} : ${value}  --------  ")
                                    deviceInfo.put(property, value)
                                } catch (e: NoSuchFieldException) {
                                    e.printStackTrace()
                                } catch (e: IllegalAccessException) {
                                    e.printStackTrace()
                                }
                            }

                            println(" --------  ${deviceInfo}   --------  ")
                            js.put("errorCode", 200);
                            js.put("data", deviceInfo);
                        }else {
                            js.put("errorCode", 500);
                        }
                        val json: String = gson.toJson(js)
                        result.success(json)
                    }

                    /** 离心机组 */
                    if(step == 7){
                        val js = JSONObject()
                        var back = Connection.getCentrifugalChillerExpansionValveControllerVersion()
                        if (back.data) {
                            val properties = arrayOf(
                                "sn", "expansionValveControllerVersion"
                            )
                            val realdata = WaterMachineDTO.getInstance().getCentrifugalChiller()
                            val deviceInfo = JSONObject()

                            for (property in properties) {
                                try {
                                    val field = CentrifugalChiller::class.java.getDeclaredField(property)
                                    field.isAccessible = true
                                    val value = field.get(realdata)
                                    println(" --------  ${property} : ${value}  --------  ")
                                    deviceInfo.put(property, value)
                                } catch (e: NoSuchFieldException) {
                                    e.printStackTrace()
                                } catch (e: IllegalAccessException) {
                                    e.printStackTrace()
                                }
                            }

                            println(" --------  ${deviceInfo}   --------  ")
                            js.put("errorCode", 200);
                            js.put("data", deviceInfo);
                        }else {
                            js.put("errorCode", 500);
                        }
                        val json: String = gson.toJson(js)
                        result.success(json)
                    }

                    /** 水冷螺杆机组 */
                    if(step == 8){
                        val js = JSONObject()
                        var back = Connection.getWaterCooledChillerSnAndVersion()
                        if (back.data) {
                            val properties = arrayOf(
                                "sn", "controlProgramVersion"
                            )
                            val realdata = WaterMachineDTO.getInstance().getWaterCooledChiller()
                            val deviceInfo = JSONObject()

                            for (property in properties) {
                                try {
                                    val field = WaterCooledChiller::class.java.getDeclaredField(property)
                                    field.isAccessible = true
                                    val value = field.get(realdata)
                                    println(" --------  ${property} : ${value}  --------  ")
                                    deviceInfo.put(property, value)
                                } catch (e: NoSuchFieldException) {
                                    e.printStackTrace()
                                } catch (e: IllegalAccessException) {
                                    e.printStackTrace()
                                }
                            }

                            println(" --------  ${deviceInfo}   --------  ")
                            js.put("errorCode", 200);
                            js.put("data", deviceInfo);
                        }else {
                            js.put("errorCode", 500);
                        }
                        val json: String = gson.toJson(js)
                        result.success(json)
                    }

                    /** 水冷螺杆机组 */
                    if(step == 9){
                        val js = JSONObject()
                        var back = Connection.getWaterCooledChillerUserParam()
                        if (back.data) {

                            val properties = arrayOf(
                                "targetTemp", "evaporatorControlTemperature", "coolingTowerFanUnit1OpeningTemperature",
                                "coolingTowerFanUnit1ShutdownTemperature", "coolingTowerFanUnit2OpeningTemperature",
                                "coolingTowerFanUnit2ShutdownTemperature",
                                "controlMode", "runningMode", "inletAndOutletWaterControl",
                                "ratedCurrentOfTheHost", "ratedCurrentOfTheHost2", "currentPercentage", "currentPercentage2",
                                "compressorShutdownInterval", "compressorStartupInterval", "quickStartupSignalDetectionDelay",
                                "variableFrequencyConverterType", "variableFrequencyConverterBaudRate", "variableFrequencyConverterBaudRate2"
                            )

                            val realdata = WaterMachineDTO.getInstance().getWaterCooledChiller()
                            val deviceInfo = JSONObject()

                            for (property in properties) {
                                try {
                                    val field = WaterCooledChiller::class.java.getDeclaredField(property)
                                    field.isAccessible = true
                                    var value = field.get(realdata)
                                    if(property == "variableFrequencyConverterBaudRate" || property == "variableFrequencyConverterBaudRate2"){
                                        // 将controlMode数值映射为文字描述
                                        val variableFrequencyConverterTypeMap = mapOf(
                                            "0" to "汇川",
                                            "1" to "四方",
                                            "2" to "预留",
                                            "3" to "汇川",
                                            "4" to "中车",
                                            "5" to "中车",
                                            "6" to "合康",
                                            "7" to "自制",
                                            "8" to "自制",
                                            "9" to "施耐德",
                                            "10" to "日业",
                                            "11" to "丹佛斯"
                                        )
                                        // 0=就地，1=远程，2=定时，3=BMS
                                        // 根据实际值获取描述，如果不存在则使用原始值
                                        value = variableFrequencyConverterTypeMap[value] ?:value
                                    }

                                    if(property == "controlMode") {
                                        // 将controlMode数值映射为文字描述
                                        val controlModeMap = mapOf(
                                            "0" to "就地",
                                            "1" to "远程",
                                            "2" to "定时",
                                            "3" to "BMS"
                                        )
                                        // 0=就地，1=远程，2=定时，3=BMS
                                        // 根据实际值获取描述，如果不存在则使用原始值
                                        value = controlModeMap[value] ?:value
                                    }

                                    if(property == "runningMode") {
                                        val runningModeMap = mapOf(
                                            "0" to "制冷",
                                            "1" to "制热",
                                            "2" to "水泵",
                                            "3" to "蓄冰"
                                        )
                                        // 0=就地，1=远程，2=定时，3=BMS
                                        // 根据实际值获取描述，如果不存在则使用原始值
                                        value = runningModeMap[value] ?: value
                                    }

                                    if(property == "inletAndOutletWaterControl"){
                                        // runningModeMap
                                        val inletAndOutletWaterControlMap = mapOf(
                                            "0" to "出水控制",
                                            "1" to "进水控制",
                                        )
                                        // 0=就地，1=远程，2=定时，3=BMS
                                        // 根据实际值获取描述，如果不存在则使用原始值
                                        value = inletAndOutletWaterControlMap[value] ?: value
                                    }

                                    println(" --------  ${property} : ${value}  --------  ")
                                    deviceInfo.put(property, value)
                                } catch (e: NoSuchFieldException) {

                                    println("CentrifugalChiller: $e");
                                    e.printStackTrace()
                                } catch (e: IllegalAccessException) {
                                    e.printStackTrace()
                                    println("CentrifugalChiller: $e");
                                }
                            }

                            println(" --------  ${deviceInfo}   --------  ")
                            js.put("errorCode", 200);
                            js.put("data", deviceInfo);

                        } else {
                            js.put("errorCode", 500);
                        }
                        val json: String = gson.toJson(js)
                        result.success(json)
                    }

                    /** 水冷螺杆机组 */
                    if(step == 10){
                        val js = JSONObject()
                        var back = Connection.getWaterCooledChillerMachineRunData()
                        if (back.data) {
                            val properties = arrayOf(
                                "evaporatorInletTemperature", "evaporatorOutletTemperature", "evaporatorTemperatureDifference", "condenserInletTemperature", "condenserOutletTemperature", "condenserTemperatureDifference", "compressorExhaustTemp1", "compressorExhaustTemp1CompressorElectric", "compressorExhaustTemp1CompressorPressure", "compressorInletPressure", "compressorExhaustTemp1CondenserSaturationTemperature", "compressorExhaustTemp1EvaporatorSaturationTemperature", "compressorExhaustTemp2", "compressorExhaustTemp2CompressorElectric", "compressorExhaustTemp2CompressorPressure", "compressorInletPressure2", "compressorExhaustTemp2CondenserSaturationTemperature", "compressorExhaustTemp2EvaporatorSaturationTemperature"
                            )

                            val realdata = WaterMachineDTO.getInstance().getWaterCooledChiller()
                            val deviceInfo = JSONObject()

                            for (property in properties) {
                                try {
                                    val field = WaterCooledChiller::class.java.getDeclaredField(property)
                                    field.isAccessible = true
                                    val value = field.get(realdata)

                                    println(" --------  ${property} : ${value}  --------  ")
                                    deviceInfo.put(property, value)
                                } catch (e: NoSuchFieldException) {
                                    e.printStackTrace()
                                } catch (e: IllegalAccessException) {
                                    e.printStackTrace()
                                }
                            }

                            println(" --------  ${deviceInfo}   --------  ")
                            js.put("errorCode", 200);
                            js.put("data", deviceInfo);
                        }else {
                            js.put("errorCode", 500);
                        }
                        val json: String = gson.toJson(js)
                        result.success(json)
                    }


                } catch (e: Exception) {
                    println("offLineToGenCode: $e");
                    val js = JSONObject()
                    js.put("errorCode", 1000);
                    js.put("data", intArrayOf());
                    result.success(js)
                }
            }
        );


    }
    private fun getWaterDeviceTypeEnum(call: MethodCall, result: MethodChannel.Result) {

        val isCn = call.argument<Boolean>("isCn")
        HttpUtilContainer.executor.execute(
            Runnable {
                try{
                    val anotherMutableList = mutableListOf<String>()
                    var back = WaterDeviceTypeEnum.values()
                    back.forEach { file ->
                        if (isCn == true) {
                            anotherMutableList.add(file.cn)
                        } else {
                            anotherMutableList.add(file.en)
                        }
                    }
                    val json: String = gson.toJson(anotherMutableList)
                    result.success(json)
                } catch (e: Exception) {
                    println("offLineToGenCode: $e");
                    val js = JSONObject()
                    js.put("errorCode", 1000);
                    js.put("data", intArrayOf());
                    result.success(js)
                }
            }
        );
    }
    private fun getConnection(call: MethodCall, result: MethodChannel.Result) {
        HttpUtilContainer.executor.execute(
            Runnable {
                try {
                    val devicetype = call.argument<String>("devicetype")
                    var back = Connection.getDeviceClockInfo(devicetype?.let { gettypebyName(it) })
                    val json: String = gson.toJson(back)
                    result.success(json)
                } catch (e: Exception) {
                    println("getConnection: $e");
                    val js = JSONObject()
                    js.put("errorCode", 1000);
                    js.put("data", intArrayOf());
                    result.success(js)
                }
            });
    }



    private fun getWaterMachineDTO(call: MethodCall, result: MethodChannel.Result) {
        var back = WaterMachineDTO.getInstance();
        println("getWaterMachineDTO:")
        println(back)
        channel.invokeMethod("monitorData", JSON.toJSONString(back));
        val js = JSONObject()
        js.put("errorCode", 1000);
        js.put("data", intArrayOf());
        result.success(js)
    }

    // 清空水泵对象
    private fun clearInstance(call: MethodCall, result: MethodChannel.Result) {
        var back = WaterMachineDTO.clearInstance();
        val js = JSONObject()
        js.put("errorCode", 1000);
        js.put("data", intArrayOf());
        result.success(js)
    }


    private fun applicationSwitching(call: MethodCall, result: MethodChannel.Result) {
        try{
            println("! -------------------  applicationSwitching ------------------- !");
            var back = ApplicationService.getInstance().applicationSwitching();
            val json: String = gson.toJson(back)
            result.success(json)

        } catch (e: Exception) {
            println("offLineToGenCode: $e");
            val js = JSONObject()
            js.put("errorCode", 1000);
            js.put("data", intArrayOf());
            result.success(js)
        }
    }




    private fun offLineToGenCodefun(call: MethodCall, result: MethodChannel.Result) {
        val devicetype = call.argument<String>("devicetype")
        val sn = call.argument<String>("sn")
        val version = call.argument<String>("version")
        val date = call.argument<String>("date")
        var enumObj: WaterDeviceTypeEnum? =devicetype?.let { gettypebyName(it) }
        HttpUtilContainer.executor.execute(
            Runnable {
                try{
                   var send = GenerateCodeRequest();
                    if (enumObj != null) {
                        send.deviceType = enumObj.en
                    }
                   send.sn =sn
                   send.random = 8 // 0～100
                   send.date = date // 2024-01-12
                   send.version = version //
                   println("offLineToGenCode: $send");
                   var back = DeviceUnlock.offLineToGenCode(send)
                   val json: String = gson.toJson(back)
                    result.success(json)

                } catch (e: Exception) {
                    println("offLineToGenCode: $e");
                    val js = JSONObject()
                    js.put("errorCode", 1000);
                    js.put("data", intArrayOf());
                    result.success(js)
                }
            }
        );
    }


    private fun sendPassword(call: MethodCall, result: MethodChannel.Result) {
        HttpUtilContainer.executor.execute(
            Runnable {
                try{
                    var back = DeviceUnlock.sendPassword()
                    val json: String = gson.toJson(back)
                    result.success(json)
                } catch (e: Exception) {
                    println("offLineToGenCode: $e");
                    val js = JSONObject()
                    js.put("errorCode", 1000);
                    js.put("data", intArrayOf());
                    result.success(js)
                }
            }
        );
    }




}
