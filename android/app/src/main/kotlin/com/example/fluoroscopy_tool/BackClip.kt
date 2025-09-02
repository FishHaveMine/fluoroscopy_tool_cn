package com.example.fluoroscopy_tool

import cn.hutool.json.JSONObject
import com.google.gson.Gson
import com.mideaibp.agent.container.HttpUtilContainer
import com.mideaibp.apps.service.BackClipService
import com.mideaibp.apps.service.CacheFileService
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

import android.os.Environment
import android.util.Base64

import java.io.File
import java.io.FileOutputStream
import java.text.SimpleDateFormat
import java.util.Date

class BackClip (private val channel: MethodChannel) : MethodChannel.MethodCallHandler {
    var BackClip =  BackClipService.getInstance();    var TestServiceob =  com.mideaibp.apps.service.TestService.getInstance();
    var CacheFile =  CacheFileService.getInstance();
    val gson: Gson = Gson()

    init {
        channel.setMethodCallHandler(this)
    }



    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "TestServiceob") {
            try {
                TestServiceob.test();

                val js = JSONObject()
                js.put("errorCode", 1000);
                js.put("data", intArrayOf());
                result.success(js)
            } catch (e: Exception) {
                println(e)
                val js = JSONObject()
                js.put("errorCode", 1000);
                js.put("data", e.message);
                result.success(js)
            }
        }


        if (call.method == "TestServiceob2") {
            try {
                // TestServiceob.testEle();

                val js = JSONObject()
                js.put("errorCode", 1000);
                js.put("data", intArrayOf());
                result.success(js)
            } catch (e: Exception) {
                println(e)
                val js = JSONObject()
                js.put("errorCode", 1000);
                js.put("data", e.message);
                result.success(js)
            }
        }

        if (call.method == "getCacheFile") {
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {

                        var back = CacheFile.getCacheFile();
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




        if (call.method == "clearCacheFile") {
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {

                        var back = CacheFile.clearCacheFile();
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

        if (call.method == "getBackClipIAPVersion") {
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {

                        var back = BackClip.getBackClipIAPVersion();
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

        if (call.method == "getBackClipAPPVersion") {
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {

                        var back = BackClip.getBackClipAPPVersion();
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

        if (call.method == "getBackClipSDKVersion") {
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {

                        var back = BackClip.getBackClipSDKVersion();
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




        if (call.method == "upgradeBackClipIAP") {
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {

                        var back = BackClip.upgradeBackClipIAP();
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


        if (call.method == "upgradeBackClipApp") {
            val resources = call.argument<String>("resources")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {

                        var back = BackClip.upgradeBackClipApp(resources);
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




        if (call.method == "getDeviceSn") {
            HttpUtilContainer.executor.execute(
                Runnable {
                    val file = File("/sys/bus/platform/devices/newland-misc/SN")
                     try {
                         var sn = "";
                        if (file.exists() && file.canRead()) {
                            sn = file.readText().trim() // 读取内容并去除首尾空白
                        } else {
                            null // 文件不存在或不可读
                        }
                         val js = JSONObject()
                         js.put("errorCode", 200);
                         js.put("data", sn)
                         val json: String = gson.toJson(js)
                         result.success(json)
                    } catch (e: Exception) {
                        e.printStackTrace()
                        null
                    }

                }
            );
        }



    }
}