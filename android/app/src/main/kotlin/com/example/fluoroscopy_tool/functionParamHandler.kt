package com.example.fluoroscopy_tool

import android.os.Build
import androidx.annotation.RequiresApi
import cn.hutool.json.JSONObject
import com.google.gson.Gson
import com.mideaibp.agent.container.HttpUtilContainer
import com.mideaibp.apps.model.common.*
import com.mideaibp.apps.model.dto.FunctionParamIndoorDTO
import com.mideaibp.apps.model.dto.FunctionParamOutdoorDTO
import com.mideaibp.apps.service.FunctionParamService
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class functionParamHandler(private val channel: MethodChannel) : MethodChannel.MethodCallHandler  {
    var FirmwareUpgrade =  FunctionParamService.getInstance();
    val gson: Gson = Gson()
    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "sendControlMaster" -> sendControlMaster(call,result)
            "sendControlIndoor" -> sendControlIndoor(call,result)
            else -> result.notImplemented()
        }
    }


    fun mapToFunctionParamOutdoorDTO(data: Map<String, Any?>): FunctionParamOutdoorDTO {
        val dto = FunctionParamOutdoorDTO()

        // 使用枚举类的 fromValue() 方法进行转换
        data["priorModeSetting"]?.let {
            if (it is Int) {
                dto.setPriorModeSettingEnum(PriorModeSettingEnum.fromValue(it))
            }
        }

        data["silentMode"]?.let {
            if (it is Int) {
                dto.setSilenceModeEnum(SilenceModeEnum.fromValue(it))
            }
        }

        data["compressorRestartWaitTime"]?.let {
            if (it is Int) {
                dto.setCompressorRestartWaitTime(CompressorRestartWaitTimeEnum.fromValue(it))
            }
        }


        data["lowNoiseDefrostSetting"]?.let {
            if (it is Int) {
                dto.setLowNoiseDefrostSetting(LowNoiseDefrostSettingEnum.fromValue(it))
            }
        }

        data["taketurnsSetting"]?.let {
            if (it is Int) {
                dto.setTaketurnsSetting(TaketurnsSettingEnum.fromValue(it))
            }
        }

        data["powerLimit"]?.let {
            if (it is Int) {
                dto.setPowerLimit(PowerLimitEnum.fromValue(it))
            }
        }

        data["antiSnowSetting"]?.let {
            if (it is Int) {
                dto.setAntiSnowSetting(AntiSnowSettingEnum.fromValue(it))
            }
        }

        data["backupSensor"]?.let {
            if (it is Int) {
                dto.setBackupSensor(BackupSensorEnum.fromValue(it))
            }
        }

        data["backupRunDays"]?.let {
            if (it is Int) {
                dto.setBackupRunDays(BackupRunDaysEnum.fromValue(it))
            }
        }

        data["tecChoice"]?.let {
            if (it is Int) {
                dto.setTecChoice(TecChoiceEnum.fromValue(it))
            }
        }

        data["mpc"]?.let {
            if (it is Int) {
                dto.setMpc(EnableMPCEnum.fromValue(it))
            }
        }

        data["mpcSelect3"]?.let {
            if (it is Int) {
                dto.setMpcSelect3(MpcSelect3Enum.fromValue(it))
            }
        }

        data["mpcSelect4"]?.let {
            if (it is Int) {
                dto.setMpcSelect4(MpcSelect4Enum.fromValue(it))
            }
        }

        data["dryContactInputSetting1"]?.let {
            if (it is Int) {
                dto.setDryContactInputSetting1(DryContactInputSetting1Enum.fromValue(it))
            }
        }

        data["dryContactInputSetting2"]?.let {
            if (it is Int) {
                dto.setDryContactInputSetting2(DryContactInputSetting2Enum.fromValue(it))
            }
        }

        data["dryContactInputSetting3"]?.let {
            if (it is Int) {
                dto.setDryContactInputSetting3(DryContactInputSetting3Enum.fromValue(it))
            }
        }

        data["emergenceStop"]?.let {
            if (it is Int) {
                dto.setEmergenceStop(EmergenceStopEnum.fromValue(it))
            }
        }

        data["sprayEnabling"]?.let {
            if (it is Int) {
                dto.setSprayEnabling(SprayEnablingEnum.fromValue(it))
            }
        }

        data["sprayOpen"]?.let {
            if (it is Int) {
                dto.setSprayOpen(SprayOpenEnum.fromValue(it))
            }
        }

        data["sprayLevelSetting"]?.let {
            if (it is Int) {
                dto.setSprayLevelSetting(SprayLevelSettingEnum.fromValue(it))
            }
        }

        // 普通字段直接赋值
        data["fallSetting"]?.let { dto.setFallSetting(it as? Int) }

        data["outdoorPriorAutoT4Setting"]?.let {
            dto.setOutdoorPriorAutoT4Setting(
                when (it) {
                    is Int -> it.toDouble()  // 如果是 Int，则转换为 Double
                    is String -> it.toDoubleOrNull()  // 如果是 String，尝试转换为 Double
                    else -> null  // 其他类型返回 null
                }
            )
        }

        data["sprayTempSetting"]?.let {
            dto.setSprayTempSetting(
                when (it) {
                    is Double -> it
                    is Int -> it.toDouble()  // 如果是 Int，则转换为 Double
                    is String -> it.toDoubleOrNull()  // 如果是 String，尝试转换为 Double
                    else -> null  // 其他类型返回 null
                }
            )
        }


        return dto
    }


    private fun sendControlMaster(call: MethodCall, result: MethodChannel.Result) {
        val functionParamOutdoorDTO = call.argument<Map<String, Any>>("functionParamOutdoorDTO")
        HttpUtilContainer.executor.execute(
            Runnable {
                try{
                    println("setting needsend:  Map" + gson.toJson(functionParamOutdoorDTO).toString());
//                    ODU(0),
//                    IDU(1),
//                    SYS(2);
                    var send = functionParamOutdoorDTO?.let { mapToFunctionParamOutdoorDTO(it) };
                    println("setting needsend:  functionParamOutdoorDTO"+send.toString());


                    var back = FirmwareUpgrade.sendControlMaster(send)
                    val json: String = gson.toJson(back)
                    result.success(json)

                } catch (e: Exception) {
                    val js = JSONObject()
                    js.put("errorCode", 1000);
                    js.put("data", intArrayOf());
                    result.success(js)
                }
            }
        );
    }


    fun mapToFunctionParamIndoorDTO(data: Map<String, Any?>): FunctionParamIndoorDTO {
        val dto = FunctionParamIndoorDTO()

        // 使用枚举类的 fromValue() 方法进行转换

        data["remoteShutdownExitMode"]?.let {
            if (it is Int) {
                dto.setRemoteShutdownExitMode(RemoteShutdownExitModeEnum.getByCode(it))
            }
        }
        data["coolingTempCompensation"]?.let {
            if (it is Int) {
                dto.setCoolingTempCompensation(CoolingTempCompensationEnum.getByCode(it))
            }
        }
        data["heatingTempCompensation"]?.let {
            if (it is Int) {
                dto.setHeatingTempCompensation(HeatingTempCompensationEnum.getByCode(it))
            }
        }


        data["lockLineControl"]?.let {
            if (it is Boolean) {
                dto.setLockLineControl(it)
            }
        }



        data["buzzerSetting"]?.let {
            if (it is Int) {
                dto.setBuzzerSetting(BuzzerSettingEnum.fromValue(it))
            }
        }

        data["displayBoardLightSetting"]?.let {
            if (it is Int) {
                dto.setDisplayBoardLightSetting(DisplayBoardLightSettingEnum.fromValue(it))
            }
        }

        data["autoModeSwitchTime"]?.let {
            if (it is Int) {
                dto.setAutoModeSwitchTime(AutoModeSwitchTimeEnum.fromValue(it))
            }
        }

        data["elecHeatingOpenDisTemp"]?.let {
            if (it is Int) {
                dto.setElecHeatingOpenDisTemp(ElecHeatingOpenDisTempEnum.fromValue(it))
            }
        }

        data["elecHeatingCloseDisTemp"]?.let {
            if (it is Int) {
                dto.setElecHeatingCloseDisTemp(ElecHeatingCloseDisTempEnum.fromValue(it))
            }
        }

        data["independentElectHeating"]?.let {
            if (it is Int) {
                dto.setIndependentElectHeating(IndependentElectHeatingEnum.fromValue(it))
            }
        }

        data["dehumidityStandbyFanSpeed"]?.let {
            if (it is Int) {
                dto.setDehumidityStandbyFanSpeed(DehumidityStandbyFanSpeedEnum.fromValue(it))
            }
        }

        data["termalStopFanTime"]?.let {
            if (it is Int) {
                dto.setTermalStopFanTime(TermalStopFanTimeEnum.fromValue(it))
            }
        }

        data["coolingAutoFanSpeedUpperLimit"]?.let {
            if (it is Int) {
                dto.setCoolingAutoFanSpeedUpperLimit(CoolingAutoFanSpeedUpperLimitEnum.fromValue(it))
            }
        }

        data["heatingAutoFanSpeedUpperLimit"]?.let {
            if (it is Int) {
                dto.setHeatingAutoFanSpeedUpperLimit(HeatingAutoFanSpeedUpperLimitEnum.fromValue(it))
            }
        }

        data["constantAirVolumeSetting"]?.let {
            if (it is Int) {
                dto.setConstantAirVolumeSetting(ConstantAirVolumeSettingEnum.fromValue(it))
            }
        }

        data["highPatioCorrectionFactor"]?.let {
            if (it is Int) {
                dto.setHighPatioCorrectionFactor(HighPatioCorrectionFactorEnum.fromValue(it))
            }
        }

        data["independentSwing1Sel"]?.let {
            if (it is Int) {
                dto.setIndependentSwing1Sel(IndependentSwing1SelEnum.fromValue(it))
            }
        }

        data["independentSwing2Sel"]?.let {
            if (it is Int) {
                dto.setIndependentSwing2Sel(IndependentSwing2SelEnum.fromValue(it))
            }
        }

        data["independentSwing3Sel"]?.let {
            if (it is Int) {
                dto.setIndependentSwing3Sel(IndependentSwing3SelEnum.fromValue(it))
            }
        }

        data["independentSwing4Sel"]?.let {
            if (it is Int) {
                dto.setIndependentSwing4Sel(IndependentSwing4SelEnum.fromValue(it))
            }
        }

        data["multipleControlSetting"]?.let {
            if (it is Int) {
                dto.setMultipleControlSetting(MultipleControlSettingEnum.fromValue(it))
            }
        }

        data["remoteShutdownSetting"]?.let {
            if (it is Int) {
                dto.setRemoteShutdownSetting(RemoteShutdownSettingEnum.fromValue(it))
            }
        }

        data["remoteOnOffDelayTime"]?.let {
            if (it is Int) {
                dto.setRemoteOnOffDelayTime(RemoteOnOffDelayTimeEnum.fromValue(it))
            }
        }

        data["indoorAlarmSetting"]?.let {
            if (it is Int) {
                dto.setIndoorAlarmSetting(IndoorAlarmSettingEnum.fromValue(it))
            }
        }

        data["preheatingOpenTemp"]?.let {
            if (it is Int) {
                dto.setPreheatingOpenTemp(PreheatingOpenTempEnum.fromValue(it))
            }
        }

        data["sterilizationSetting"]?.let {
            if (it is Int) {
                dto.setSterilizationSetting(SterilizationSettingEnum.fromValue(it))
            }
        }

        data["selfCleanDryingTimeSetting"]?.let {
            if (it is Int) {
                dto.setSelfCleanDryingTimeSetting(SelfCleanDryingTimeSettingEnum.fromValue(it))
            }
        }

        data["antiMouldyBlowTimeSetting"]?.let {
            if (it is Int) {
                dto.setAntiMouldyBlowTimeSetting(AntiMouldyBlowTimeSettingEnum.fromValue(it))
            }
        }

        data["antiBlowDirtyCeilingSetting"]?.let {
            if (it is Int) {
                dto.setAntiBlowDirtyCeilingSetting(AntiBlowDirtyCeilingSettingEnum.fromValue(it))
            }
        }

        data["antiCondensationSetting"]?.let {
            if (it is Int) {
                dto.setAntiCondensationSetting(AntiCondensationSettingEnum.fromValue(it))
            }
        }

        data["humanSensorNomanTime"]?.let {
            if (it is Int) {
                dto.setHumanSensorNomanTime(HumanSensorNomanTimeEnum.fromValue(it))
            }
        }

        data["humanSensorDiffTemp"]?.let {
            if (it is Int) {
                dto.setHumanSensorDiffTemp(HumanSensorDiffTempEnum.fromValue(it))
            }
        }

        data["nomanStopDelayTimeSetting"]?.let {
            if (it is Int) {
                dto.setNomanStopDelayTimeSetting(NomanStopDelayTimeSettingEnum.fromValue(it))
            }
        }

        data["coolingMpcLevel"]?.let {
            if (it is Int) {
                dto.setCoolingMpcLevel(CoolingMpcLevelEnum.fromValue(it))
            }
        }

        data["heatingMpcLevel"]?.let {
            if (it is Int) {
                dto.setHeatingMpcLevel(HeatingMpcLevelEnum.fromValue(it))
            }
        }

        data["powerDownSetting"]?.let {
            if (it is Int) {
                dto.setPowerDownSetting(PowerDownSettingEnum.fromValue(it))
            }
        }

        data["heatingIdleOpenningSetting"]?.let {
            if (it is Int) {
                dto.setHeatingIdleOpenningSetting(HeatingIdleOpenningSettingEnum.fromValue(it))
            }
        }

        data["fieldCorrectionFactor"]?.let {
            if (it is Int) {
                dto.setFieldCorrectionFactor(FieldCorrectionFactorEnum.fromValue(it))
            }
        }

        // 处理普通字段
        data["indoorStaticPressureSetting"]?.let {
            dto.setIndoorStaticPressureSetting(
                when (it) {
                    is Int -> it
                    is String -> it.toIntOrNull()  // 尝试将 String 转换为 Int
                    else -> null  // 其他类型返回 null
                }
            )
        }

        data["autoModeD2"]?.let {
            dto.setAutoModeD2(
                when (it) {
                    is Int -> it
                    is String -> it.toIntOrNull()  // 尝试将 String 转换为 Int
                    else -> null  // 其他类型返回 null
                }
            )
        }

        data["elecHeaterT4"]?.let {
            dto.setElecHeaterT4(
                when (it) {
                    is Double -> it
                    is Int -> it.toDouble()  // 如果是 Int，则转换为 Double
                    is String -> it.toDoubleOrNull()  // 尝试将 String 转换为 Double
                    else -> null  // 其他类型返回 null
                }
            )
        }

        data["elecHeatingTempT1Setting"]?.let {
            dto.setElecHeatingTempT1Setting(
                when (it) {
                    is Double -> it
                    is Int -> it.toDouble()  // 如果是 Int，则转换为 Double
                    is String -> it.toDoubleOrNull()  // 尝试将 String 转换为 Double
                    else -> null  // 其他类型返回 null
                }
            )
        }

        data["diffPressureStartToEnd"]?.let {
            dto.setDiffPressureStartToEnd(
                when (it) {
                    is Int -> it
                    is String -> it.toIntOrNull()  // 尝试将 String 转换为 Int
                    else -> null  // 其他类型返回 null
                }
            )
        }

        data["openDegreeOfOilReturnSet"]?.let {
            dto.setOpenDegreeOfOilReturnSet(
                when (it) {
                    is Double -> it
                    is Int -> it.toDouble()  // 如果是 Int，则转换为 Double
                    is String -> it.toDoubleOrNull()  // 尝试将 String 转换为 Double
                    else -> null  // 其他类型返回 null
                }
            )
        }


        return dto
    }


    private fun sendControlIndoor(call: MethodCall, result: MethodChannel.Result) {
        val functionParamIndoorDTO = call.argument<Map<String, Any>>("functionParamIndoorDTO")
        val addressList = call.argument<List<Int>>("addressList")
        HttpUtilContainer.executor.execute(
            Runnable {
                try{
                    println("setting needsend:  addressList ${addressList}");
                    println("setting needsend:  Map" + gson.toJson(functionParamIndoorDTO).toString());
//                    ODU(0),
//                    IDU(1),
//                    SYS(2);
                    var send = functionParamIndoorDTO?.let { mapToFunctionParamIndoorDTO(it) };
                    println("setting needsend:  functionParamIndoorDTO"+send.toString());

                    var back = FirmwareUpgrade.sendControlIndoor(addressList,send)
                    val json: String = gson.toJson(back)
                    result.success(json)

                } catch (e: Exception) {
                    val js = JSONObject()
                    js.put("errorCode", 1000);
                    js.put("data", intArrayOf());
                    result.success(js)
                }
            }
        );
    }

}