package com.example.fluoroscopy_tool

import cn.hutool.core.collection.CollUtil
import cn.hutool.core.util.StrUtil
import cn.hutool.json.JSONArray
import cn.hutool.json.JSONObject
import com.google.gson.Gson
import com.mideaibp.agent.container.HttpUtilContainer
import com.mideaibp.agent.model.dto.ProjectAddDeviceDto
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class getTopologyHandler (private val channel: MethodChannel) : MethodChannel.MethodCallHandler {

    val gson: Gson = Gson()
    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

        if (call.method == "listOfflineGateway") {
            val key = call.argument<String>("key")
            HttpUtilContainer.executor.execute(
                Runnable {   // 创建一个 JSON 对象
                    var back = HttpUtilContainer.getTopologyHandler().listOfflineGateway(key);
                    val json: String = gson.toJson(back)
                    result.success(json)
                }
            );
        }

        if(call.method == "moduleReplace"){
            val newSn = call.argument<String>("newSn")
            val projectCode = call.argument<String>("projectCode")
            val projectId = call.argument<Int>("projectId")
            val sysId = call.argument<String>("sysId")
            HttpUtilContainer.executor.execute(
                Runnable {   // 创建一个 JSON 对象
                    val jsonObject = JSONObject()
                    jsonObject.put("newSn", newSn)
                    jsonObject.put("projectCode", projectCode)
                    if (projectId != null) {
                        jsonObject.put("projectId", projectId.toLong())
                    }
                    jsonObject.put("sysId", sysId)


                    var back = HttpUtilContainer.getTopologyHandler().moduleReplace(jsonObject);
                    val json: String = gson.toJson(back)
                    result.success(json)
                }
            );
        }


        // 添加4g模块
        //// 根据sn搜索设备
        if (call.method == "getUnArchivedDevice") {
            val sn = call.argument<String>("sn")
            val projectId = call.argument<String>("projectId")
            HttpUtilContainer.executor.execute(
                Runnable {   // 创建一个 JSON 对象
                    var back = HttpUtilContainer.getDeviceHandler().getUnArchivedDevice(
                        "","",sn,"",
                        projectId, sn, "es",
                        "", "", "", "", true, "",
                        1, 20
                    );
                    val json: String = gson.toJson(back)
                    result.success(json)
                }
            );
        }


        //// 绑定4g模块设备至项目
        if (call.method == "addDevice") {
            val deviceNid = call.argument<String>("deviceNid")
            val deviceSn = call.argument<String>("deviceSn")
            val sysId = call.argument<String>("sysId")
            val projectId = call.argument<String>("projectId")
            HttpUtilContainer.executor.execute(
                Runnable {
                  try {
                      val js = JSONObject()
                      js.put("projectId", projectId)
                      val jsArray = JSONArray()

                      val js1 = JSONObject()
                      js1.put("deviceNid", deviceNid)
                      js1.put("deviceSn", deviceSn)
                      js1.put("sysId", sysId)
                      jsArray.add(
                          js1
                      )
                      js.put("deviceList", jsArray)
                      var back =HttpUtilContainer.getProjectHandler().addDevice(js);
                      val json: String = gson.toJson(back)
                      result.success(json)
                  }catch (e: Exception){
                      println(e)
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