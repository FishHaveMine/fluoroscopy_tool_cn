package com.example.fluoroscopy_tool


import cn.hutool.json.JSONObject
import com.google.gson.Gson
import com.mideaibp.agent.container.HttpUtilContainer
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class getSystemDataHandlerHandler(private val channel: MethodChannel) : MethodChannel.MethodCallHandler {

    val gson: Gson = Gson()
    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        // 定位系统搜索--支持项目编码、项目名称搜索
        if(call.method == "getSearchByProject"){
            val key = call.argument<String>("key")
            HttpUtilContainer.executor.execute(
                Runnable {   // 创建一个 JSON 对象
                    val js = JSONObject()
                    js.put("key", key);
                    var back = HttpUtilContainer.getSystemDataHandler().getSearchByProject(js);
                    val json: String = gson.toJson(back)
                    result.success(json)
                }
            );
        }

        //// 拓扑-内机数据
        if(call.method == "getIndoorTopologyData"){
            val projectCode = call.argument<String>("projectCode")
            val latestIndoor = call.argument<Boolean>("latestIndoor")
            HttpUtilContainer.executor.execute(
                Runnable {   // 创建一个 JSON 对象
                    val js = JSONObject()
                    js.put("group", "topology");
                    js.put("projectCode", projectCode);
                    if(latestIndoor == true)js.put("latestIndoor", latestIndoor);

                    var back = HttpUtilContainer.getSystemDataHandler().getIndoorTopologyData(js);
                    val json: String = gson.toJson(back)
                    result.success(json)
                }
            );
        }

        //// 获取搜索记录--sn搜索、项目搜索
        if(call.method == "getSearchHistories"){
            HttpUtilContainer.executor.execute(
                Runnable {   // 创建一个 JSON 对象
                    var back = HttpUtilContainer.getSystemDataHandler().getSearchHistories("projectDetail");
                    val json: String = gson.toJson(back)
                    result.success(json)
                }
            );
        }

        //// 系统参数--实时数据
        if(call.method == "getRealTimeData"){
            val sysId = call.argument<String>("sysId")
            val deviceType = call.argument<String>("deviceType")
            HttpUtilContainer.executor.execute(
                Runnable {   // 创建一个 JSON 对象
                    val inuJs = JSONObject()
                    inuJs.put("sysId", sysId);
                    inuJs.put("group", "realTime");
                    inuJs.put("deviceType", deviceType);
                    var back = HttpUtilContainer.getSystemDataHandler().getRealTimeData(inuJs);
                    val json: String = gson.toJson(back)
                    result.success(json)
                }
            );
        }


        //// 系统参数--历史数据
        if(call.method == "getHistoryData"){
            val endTime = call.argument<String>("endTime")
            val startTime = call.argument<String>("startTime")
            val nid = call.argument<String>("nid")
            HttpUtilContainer.executor.execute(
                Runnable {   // 创建一个 JSON 对象
                    val ouHisJs = JSONObject()
                    ouHisJs.put("startTime", startTime);
                    ouHisJs.put("endTime", endTime);
                    ouHisJs.put("nid", nid);
                    ouHisJs.put("group", "legend");
                    var back = HttpUtilContainer.getSystemDataHandler().getHistoryData(ouHisJs);
                    val json: String = gson.toJson(back)
                    result.success(json)
                }
            );
        }

        //// 启动系统检测
        if(call.method == "startCheck"){
            val sysId = call.argument<String>("sysId")
            val mode = call.argument<String>("mode")

            HttpUtilContainer.executor.execute(
                Runnable {   // 创建一个 JSON 对象
                    val checkJs = JSONObject()
                    checkJs.put("type", "HISTORY");
                    checkJs.put("sysId", sysId);
                    checkJs.put("mode", mode);
                    var back = HttpUtilContainer.getSystemCheckHandler().startCheck(checkJs);
                    val json: String = gson.toJson(back)
                    result.success(json)
                }
            );
        }

        //// 启动系统检测
        if(call.method == "queryCheckRecord"){
            val pageIndex = call.argument<Int>("pageIndex")
            val sysId = call.argument<String>("sysId")
            val mode = call.argument<String>("mode")
            HttpUtilContainer.executor.execute(
                Runnable {   // 创建一个 JSON 对象
                    val checkHisJs = JSONObject();
                    checkHisJs.put("pageIndex", pageIndex);
                    checkHisJs.put("sysId", sysId);
                    checkHisJs.put("mode", mode);
                    var back = HttpUtilContainer.getSystemCheckHandler().queryCheckRecord(checkHisJs);
                    val json: String = gson.toJson(back)
                    result.success(json)
                }
            );
        }


        //// 查询检测记录详情
        if(call.method == "queryCheckRecordDetail"){
            val id = call.argument<Int>("id")
            val sysId = call.argument<String>("sysId")
            print("sysId:$sysId  id:$id");
            HttpUtilContainer.executor.execute(
                Runnable {   // 创建一个 JSON 对象
                    var back = HttpUtilContainer.getSystemCheckHandler().queryCheckRecordDetail(
                        id!!.toLong(), sysId)
                    val json: String = gson.toJson(back)
                    result.success(json)
                }
            );
        }

        if(call.method == "queryAnalysisResult"){
            val id = call.argument<Int>("id")
            val code = call.argument<String>("code")

            print("code:$code  id:$id");
            HttpUtilContainer.executor.execute(
                Runnable {   // 创建一个 JSON 对象
                    var back = HttpUtilContainer.getSystemCheckHandler().queryAnalysisResult(
                        code, id!!.toLong())
                    val json: String = gson.toJson(back)
                    result.success(json)
                }
            );
        }



        if(call.method == "startBuzzer"){
            val sysId = call.argument<String>("sysId")

            HttpUtilContainer.executor.execute(
                Runnable {   // 创建一个 JSON 对象
                    val jsonObject = JSONObject()
                    jsonObject.put("sysId", sysId)
                    var back = HttpUtilContainer.getSystemCheckHandler().startBuzzer(
                        jsonObject)
                    val json: String = gson.toJson(back)
                    result.success(json)
                }
            );
        }

    }

}
