package com.example.fluoroscopy_tool

import cn.hutool.json.JSONObject
import com.google.gson.Gson
import com.mideaibp.agent.container.HttpUtilContainer
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class SprinklerSetting(private val channel: MethodChannel) : MethodChannel.MethodCallHandler {

    val gson: Gson = Gson()

    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        //// 喷淋时长重置
        if (call.method == "getAppFluorineMachineEnergyHandler.sprayDurationReset") {
            val nid = call.argument<String>("nid")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        var back = HttpUtilContainer.getAppFluorineMachineEnergyHandler().sprayDurationReset(nid)
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

        //// 喷淋调试
        if (call.method == "getAppFluorineMachineEnergyHandler.spray") {
            val gearSetting = call.argument<Int>("gearSetting")
            val sprayStartTemp = call.argument<Double>("sprayStartTemp")
            val enableSetting = call.argument<Int>("enableSetting")
            val systemId = call.argument<Long>("systemId")

            val nid = call.argument<String>("nid")
            val sn = call.argument<String>("sn")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        val jsonObject = JSONObject()
                        jsonObject.put("gearSetting", gearSetting)
                        jsonObject.put("sprayStartTemp", sprayStartTemp)
                        jsonObject.put("enableSetting", enableSetting)
                        jsonObject.put("systemId", systemId)
//                        jsonObject.put("nid", nid)
//                        jsonObject.put("sn", sn)
                        var back = HttpUtilContainer.getAppFluorineMachineEnergyHandler().spray(jsonObject)
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
        //// 喷淋调试回显

        if (call.method == "getAppFluorineMachineEnergyHandler.getSpray") {
            val sn = call.argument<String>("sn")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        var back = HttpUtilContainer.getAppFluorineMachineEnergyHandler().getSpray(sn)
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
}