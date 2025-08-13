package com.example.fluoroscopy_tool;

import cn.hutool.json.JSONArray
import cn.hutool.json.JSONObject
import com.google.gson.Gson
import com.mideaibp.agent.container.HttpUtilContainer
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
public class cloundFunctionParamsSetting (private val channel: MethodChannel) : MethodChannel.MethodCallHandler {

    val gson: Gson = Gson()

    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        //// 查询设备关系
        if (call.method == "getMideaAppV2Handler.deviceRelationship") {
            val sn = call.argument<String>("sn")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        var back = HttpUtilContainer.getMideaAppV2Handler().deviceRelationship(sn);
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

//// 根据nid获取基础/专家参数数据
        if (call.method == "getMideaAppHandler.realtimeStatus") {
            val nid = call.argument<String>("nid")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        var back = HttpUtilContainer.getMideaAppHandler().realtimeStatus(nid);
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



        //// 获取基础/专家参数数据（默认配置）
        if (call.method == "getMideaAppHandler.featuresSearch") {
            val deviceType = call.argument<String>("deviceType")
            val mideaTongTabs = call.argument<List<String>>("mideaTongTabs")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        println("   //// 获取基础/专家参数数据（默认配置）")
                        // 创建一个 JSON 对象
                        var jsonObject =  JSONObject();
                        jsonObject.put("productVersion", "v8");
                        jsonObject.put("typeLevel", "base");
                        jsonObject.put("userId", "13726259684");
                        jsonObject.put("deviceType", deviceType);
                        var mideaTongTabsList =  JSONArray();
                        if (mideaTongTabs != null) {
                            mideaTongTabs.forEach {   item -> mideaTongTabsList.add(item);}
                        }
                        jsonObject.put("mideaTongTabs", mideaTongTabsList);
                        println(jsonObject);
                        var back = HttpUtilContainer.getMideaAppHandler().featuresSearch(jsonObject);
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


        //* 单命令执行
//* 制冷试运行（云端）
//* 制热试运行（云端）
//* 模式控制操作,温度控制操作,风速控制操作,摇摆控制操作,节能控制操作
        if (call.method == "getMideaAppHandler.control") {
            val nid = call.argument<String>("nid")
            val needsend = call.argument<List<Map<String, Any>>>("needsend")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象

                        val jsonObject2 = JSONObject()
                        val controls = JSONArray()
                        needsend?.forEach { item ->
                            val actoin = JSONObject()
                            actoin.put("name", item.get("name"))
                            actoin.put("value", item.get("value"))
                            controls.add(actoin)
                        }
                        jsonObject2.put("controls", controls)
                        jsonObject2.put("nid", nid)
                        println(jsonObject2)
                        var back = HttpUtilContainer.getMideaAppHandler().control(jsonObject2);
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
