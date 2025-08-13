package com.example.fluoroscopy_tool

import cn.hutool.json.JSONArray
import cn.hutool.json.JSONObject
import com.google.gson.Gson
import com.mideaibp.agent.container.HttpUtilContainer
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class topology(private val channel: MethodChannel) : MethodChannel.MethodCallHandler {

    val gson: Gson = Gson()

    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {


// 项目拓扑
//// 工程设备查询
        if (call.method == "getTopologyHandler.projectDevices") {
            val projectCode = call.argument<String>("projectCode")
            val projectId = call.argument<String>("projectId")
            val vrfNid = call.argument<String>("vrfNid")
            val groupId = call.argument<List<Int>>("groupId")
            val status = call.argument<Int>("status")
            val deviceAddress = call.argument<Int>("deviceAddress")
            val pageIndex = call.argument<Int>("pageIndex")
            val pageSize = call.argument<Int>("pageSize")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        val jsonObject = JSONObject()
                        jsonObject.put("projectCode", projectCode)
                        jsonObject.put("projectId", projectId)
                        jsonObject.put("vrfNid", vrfNid)
                        if (deviceAddress != -1) jsonObject.put("deviceAddress", deviceAddress)
                        if (status != -1) jsonObject.put("status", status)
                        jsonObject.put("pageIndex", pageIndex)
                        jsonObject.put("pageSize", pageSize)
                        val groupQries = JSONArray()

                        groupId?.forEach { item ->
                            val group = JSONObject()
                            group.put("groupId", item)
                            group.put("ungrouped", false)
                            if (item != -2) groupQries.add(group)
                        }


                        jsonObject.put("groupQries", groupQries)
                        println(jsonObject);
                        var back =
                            HttpUtilContainer.getTopologyV2Handler().projectDevices(jsonObject);
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


//// 拓扑-设备开关机控制
        if (call.method == "getTopologyHandler.onOffControl") {

            val nidList = call.argument<List<String>>("nidList")
            val projectId = call.argument<String>("projectId")
            val onOffValue = call.argument<Int>("onOffValue")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {

                        val jsonObject2 = JSONObject()
                        val nids = JSONArray()
                        nidList?.forEach { nid ->
                            nids.put(nid)
                        }
                        jsonObject2.put("nids", nids)
                        jsonObject2.put("projectId", projectId)
                        jsonObject2.put("onOffValue", onOffValue)
                        var back = HttpUtilContainer.getTopologyHandler().onOffControl(jsonObject2);
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


//// 工程分区列表
        if (call.method == "getTopologyHandler.treeWithDevice") {
            val projectId : Int? = call.argument<Int>("projectId")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {

                        val longValue: Long = projectId?.toLong() ?: 0  // 使用 toLong() 转换为 Long
                        println("longValue: $longValue")
                        var back = HttpUtilContainer.getTopologyV2Handler().treeWithDevice(longValue);
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


//// 工程内机设备地址列表
        if (call.method == "getTopologyHandler.projectDeviceAddress") {
            val projectId = call.argument<String>("projectId")
            val projectCode = call.argument<String>("projectCode")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        val jsonObject5 = JSONObject()
                        jsonObject5.put("projectCode", projectCode)
                        jsonObject5.put("projectId", projectId)
                        jsonObject5.put("vrfNid", "")
                        jsonObject5.put("status", "")
                        jsonObject5.put("pageIndex", 1)
                        jsonObject5.put("pageSize", 9999)
                        var back = HttpUtilContainer.getTopologyHandler()
                            .projectDeviceAddress(jsonObject5);
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

//// 工程系统列表
        if (call.method == "getTopologyHandler.listVrfSelect") {
            val projectId = call.argument<String>("projectId")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        var back = HttpUtilContainer.getTopologyHandler().listVrfSelect(projectId);
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
//// 设备移入已创建的分区
        if (call.method == "getTopologyHandler.associatedExisted") {

            val groupId = call.argument<Int>("groupId")
            val projectId = call.argument<String>("projectId")
            val deviceList = call.argument<List<Map<String, Any>>>("deviceList")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {

                        val devices = JSONArray()

                        deviceList?.forEach { item ->
                            val device = JSONObject()
                            device.put("deviceName", item.get("deviceName"))
                            device.put("deviceSn", item.get("deviceSn"))
                            device.put("nid", item.get("nid"))
                            devices.add(device)
                        }


                        val jsonObject4 = JSONObject()
                        jsonObject4.put("devices", devices)
                        jsonObject4.put("groupId", groupId)
                        jsonObject4.put("projectId", projectId)
                        println(jsonObject4);
                        var back =
                            HttpUtilContainer.getTopologyHandler().associatedExisted(jsonObject4);
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

//// 添加分区
        if (call.method == "getTopologyHandler.addGroup") {

            val projectId = call.argument<String>("projectId")
            val levelOne = call.argument<Map<String, Any>>("levelOne")
            val levelTwo = call.argument<Map<String, Any>>("levelTwo")
            val levelThree = call.argument<Map<String, Any>>("levelThree")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {

                        val level_One = JSONObject();
                        if (levelOne != null) {
                            level_One.put("groupName",levelOne.get("groupName"));
                            level_One.put("unit", "栋");
                            level_One.put("unitGroup", "栋|层|室");
                        };

                        val level_Two = JSONObject();
                        if (levelTwo != null) {
                            if(levelTwo.get("parentId") != null)level_Two.put("parentId",levelTwo.get("parentId"));
                            level_Two.put("groupName",levelTwo.get("groupName"));
                            level_Two.put("unit", "层");
                            level_Two.put("unitGroup", "栋|层|室");
                        };


                        val level_Three = JSONObject();
                        if (levelThree != null) {
                            if(levelThree.get("parentId") != null)level_Three.put("parentId",levelThree.get("parentId"));
                            level_Three.put("groupName",levelThree.get("groupName"));
                            level_Three.put("unit", "层");
                            level_Three.put("unitGroup", "栋|层|室");
                        };

                        val jsonObject3 = JSONObject();
                        if (levelOne != null)jsonObject3.put("levelOne", level_One);
                        if (levelTwo != null)jsonObject3.put("levelTwo", level_Two);
                        if (levelThree != null) jsonObject3.put("levelThree", level_Three);
                        jsonObject3.put("projectId", projectId);

                        println(jsonObject3)
                        var back = HttpUtilContainer.getTopologyHandler().addGroup(jsonObject3);
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


//// 编辑分区
        if (call.method == "getTopologyHandler.editGroup") {

            val projectId = call.argument<String>("projectId")
            val area = call.argument<Int>("area")
            val id = call.argument<Int>("id")
            val name = call.argument<String>("name")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {

                        val group = JSONObject();  group.put("projectId", projectId);
                        group.put("area", area);
                        group.put("id", id);
                        group.put("name", name);
                        var back = HttpUtilContainer.getTopologyHandler().editGroup(group);
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




        //// 批量删除分区
        if (call.method == "getTopologyHandler.deletesGroup") {

            val deviceList = call.argument<List<Long>>("deviceList")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
    println(deviceList);
                        var back =
                            HttpUtilContainer.getTopologyHandler().deletesGroup(deviceList);
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




        ////
        if (call.method == "getTopologyHandler.getDeviceDetail") {

            val nid = call.argument<String>("nid")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        var back =
                            HttpUtilContainer.getTopologyHandler().getDeviceDetail(nid);
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


        if (call.method == "getTopologyHandler.getIndoorDeviceParam") {

            val nid = call.argument<String>("nid")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        var back =
                            HttpUtilContainer.getTopologyHandler().getIndoorDeviceParam(nid);
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


        if (call.method == "getTopologyHandler.deviceNameUpdate") {

            val projectId = call.argument<String>("projectId")
            val deviceName = call.argument<String>("deviceName")
            val nid = call.argument<String>("nid")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {


                        val group = JSONObject();  group.put("projectId", projectId);
                        group.put("deviceName", deviceName);
                        group.put("nid", nid);
                        var back =
                            HttpUtilContainer.getTopologyHandler().deviceNameUpdate(group);
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