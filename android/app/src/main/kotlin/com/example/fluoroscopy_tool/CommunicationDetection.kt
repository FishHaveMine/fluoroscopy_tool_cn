package com.example.fluoroscopy_tool

import cn.hutool.json.JSONObject
import com.google.gson.Gson
import com.mideaibp.agent.container.HttpUtilContainer
import com.mideaibp.apps.service.CommunicationDetectionService
import com.mideaibp.apps.service.FirmwareUpgradeService
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class CommunicationDetection(private val channel: MethodChannel) : MethodChannel.MethodCallHandler {
    var CommunicationService =  CommunicationDetectionService.getInstance();
    val gson: Gson = Gson()

    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "setStop") {
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {

                        var back = CommunicationService.setStop();
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
        if (call.method == "outdoorDetection") {
            val protocolType = call.argument<Int>("protocolType")
            val indoorAddress = call.argument<Int>("indoorAddress")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        val shortValue1 = protocolType?.toShort()
                        val shortValue2 = indoorAddress?.toShort()

                        var back = CommunicationService.outdoorDetection(shortValue1,shortValue2);
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

        if (call.method == "singleIndoorDetection") {
            val protocolType = call.argument<Int>("protocolType")

            val isAssignAddress = call.argument<Boolean>("isAssignAddress")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        val shortValue1 = protocolType?.toShort()
                        var back = CommunicationService.singleIndoorDetection(shortValue1,isAssignAddress);
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
        if (call.method == "multiIndoorDetection") {
            val protocolType = call.argument<Int>("protocolType")
            val isAssignAddress = call.argument<Boolean>("isAssignAddress")
            val indoorNum = call.argument<Int>("indoorNum")

            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        val shortValue1 = protocolType?.toShort()
                        var back = CommunicationService.multiIndoorDetection(shortValue1,isAssignAddress,indoorNum);
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