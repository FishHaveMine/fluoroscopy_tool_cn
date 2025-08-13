package com.example.fluoroscopy_tool

import android.R.attr.value
import cn.hutool.json.JSONObject
import com.google.gson.Gson
import com.mideaibp.agent.container.HttpUtilContainer
import com.mideaibp.apps.service.AntiTamperingService
import com.mideaibp.apps.service.TestRunService
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.io.InputStream


class AntiTamperingServiceHandler (private val channel: MethodChannel) : MethodChannel.MethodCallHandler  {
    var TestRunServiceob =  AntiTamperingService.getInstance();
    val gson: Gson = Gson()
    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getAntiTampering" -> getAntiTampering(call,result)
            else -> result.notImplemented()
        }
    }


    private fun getAntiTampering(call: MethodCall, result: MethodChannel.Result) {
        HttpUtilContainer.executor.execute(
            Runnable {
                try{
                    var back = TestRunServiceob.getAntiTampering()
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