package com.example.fluoroscopy_tool

import cn.hutool.json.JSONArray
import cn.hutool.json.JSONObject
import com.google.gson.Gson
import com.mideaibp.agent.container.HttpUtilContainer
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class ibutler(private val channel: MethodChannel) : MethodChannel.MethodCallHandler {

    val gson: Gson = Gson()

    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

        // i管家收费
        //// 设备合约状态
        if (call.method == "contractStatus") {
            val projectCode = call.argument<String>("projectCode")
            val model = call.argument<String>("model")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        var back = HttpUtilContainer.getAppChargeHandler()
                            .contractStatus(projectCode, model);
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


        //// 设备合约数+设备试用分析+设备剩余天数
        if (call.method == "deviceStatistic") {
            val projectCode = call.argument<String>("projectCode")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        var back =
                            HttpUtilContainer.getAppChargeHandler().deviceStatistic(projectCode);
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

        //// 到期项目
        if (call.method == "soonExpiredProject") {
            val pageIndex = call.argument<Int>("pageIndex")
            val pageSize = call.argument<Int>("pageSize")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        val js = JSONObject()
                        js.put("pageIndex", 1)
                        js.put("pageSize", 10)
                        var back = HttpUtilContainer.getAppChargeHandler().soonExpiredProject(js);
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

        //// 项目内设备列表(试用页面)
        if (call.method == "getIHouseKeepChargeHandler.pageDeviceList") {
            val projectCode = call.argument<String>("projectCode")

            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        val jsonObject6 = JSONObject();
                        jsonObject6.put("projectCode", projectCode);
                        jsonObject6.put("devStableTag", null);
                        jsonObject6.put("deviceSn", null);
                        jsonObject6.put("status", null);
                        jsonObject6.put("pageIndex", 1);
                        jsonObject6.put("pageSize", 10);
                        jsonObject6.put("orderDirection", "ASC");
                        jsonObject6.put("operation", null);
                        jsonObject6.put("totalPages", 0);
                        jsonObject6.put("orderNo", null);

                        var back = HttpUtilContainer.getIHouseKeepChargeHandler()
                            .pageDeviceList(jsonObject6);
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

        //// 添加试用
        if (call.method == "getAppChargeHandler.addTrial") {
            val projectCode = call.argument<String>("projectCode")
            val projectName = call.argument<String>("projectName")
            val address = call.argument<String>("address")
            val trailStartTime = call.argument<Long>("trailStartTime")
            val trailEndTime = call.argument<Long>("trailEndTime")
            val deviceList = call.argument<List<String>>("deviceList")
            // 创建 List<JSONObject>
            val jsonObjectList = mutableListOf<JSONObject>()
            if (deviceList != null) {
                deviceList.forEach { fruit ->
                    jsonObjectList.add(JSONObject(fruit));
                }
            }
            println("jsonObjectList:-------");
            println(jsonObjectList);

            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        val jsonObject7 = JSONObject()
                        jsonObject7.put("projectCode", projectCode)
                        if (trailStartTime != null) {
                            jsonObject7.put("trailStartTime", trailStartTime)
                        }
                        if (trailEndTime != null) {
                            jsonObject7.put("trailEndTime", trailEndTime)
                        }
                        jsonObject7.put("projectName", projectName)
                        jsonObject7.put(
                            "address",
                            address
                        )
                        jsonObject7.put(
                            "sysDeviceDTOList",
                            HttpUtilContainer.getIHouseKeepChargeHandler()
                                .formTrialDevice(jsonObjectList)
                        )

                        println("jsonObject7:-------");
                        println(jsonObject7);
                        var back = HttpUtilContainer.getAppChargeHandler().addTrial(jsonObject7);
                        val json: String = gson.toJson(back)
                        result.success(json)

                    } catch (e: Exception) {
                        println(e)
                        val js = JSONObject()
                        js.put("errorCode", 1000);
                        js.put("data", intArrayOf());
                        result.success(js)
                    }
                }
            );
        }

        if (call.method == "getAppChargeHandler.getCssOrder") {
            val projectCode = call.argument<String>("projectCode")
            val orderNo = call.argument<String>("orderNo")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        val jsonObject6 = JSONObject();
                        jsonObject6.put("projectCode", projectCode);
                        jsonObject6.put("orderNo", orderNo);

                        var back = HttpUtilContainer.getAppChargeHandler().getCssOrder(jsonObject6);
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


        if (call.method == "getAppChargeHandler.pageDeviceList") {
            val projectCode = call.argument<String>("projectCode")
            val orderNo = call.argument<String>("orderNo")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        val jsonObject9 = JSONObject();

                        jsonObject9.put("pageIndex", 1);
                        jsonObject9.put("pageSize", 10);
                        jsonObject9.put("orderDirection", "ASC");
                        jsonObject9.put("operation", 1);
                        jsonObject9.put("totalPages", 0);
                        jsonObject9.put("projectCode", projectCode);

                        var back =
                            HttpUtilContainer.getAppChargeHandler().pageDeviceList(jsonObject9);
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


//// 设备合约数+设备试用分析+设备剩余天数
        if (call.method == "getAppChargeHandler.judgeSignedStatus") {
            val sysIdList = call.argument<List<String>>("sysIdList")
            val contractStartTime = call.argument<Long>("contractStartTime")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {

                        var back = HttpUtilContainer.getAppChargeHandler()
                            .judgeSignedStatus(sysIdList, contractStartTime);
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

        //// 查询设备最早试用失效时间
        if (call.method == "getAppChargeHandler.earlyTrialFailureTime") {
            val sysIdList = call.argument<List<String>>("sysIdList")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        var back = HttpUtilContainer.getAppChargeHandler()
                            .earlyTrialFailureTime(sysIdList);
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


        //// 查询设备最早试用失效时间
        if (call.method == "getAppChargeHandler.getMaxTrialTime") {
            val sysIdList = call.argument<List<String>>("sysIdList")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        var back = HttpUtilContainer.getAppChargeHandler()
                            .getMaxTrialTime(sysIdList);
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


//// 激活已选系统的合约
        if (call.method == "getAppChargeHandler.activateContract") {

            val cardType = call.argument<Int>("cardType")
            val buyNum = call.argument<Int>("buyNum")
            val remainingNum = call.argument<Int>("remainingNum")
            val sortIndex = call.argument<Int>("sortIndex")
            val orderNo = call.argument<String>("orderNo")
            val projectCode = call.argument<String>("projectCode")
            val projectName = call.argument<String>("projectName")
            val address = call.argument<String>("address")
            val contractStartTime = call.argument<Long>("contractStartTime")
            val deviceList = call.argument<List<Map<String, Any>>>("deviceList")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        val jsonObject10 = JSONObject()
                        jsonObject10.put("cardType", cardType)
                        jsonObject10.put("buyNum", buyNum)
                        jsonObject10.put("remainingNum", remainingNum)
                        jsonObject10.put("sortIndex", sortIndex)
                        jsonObject10.put("orderNo", orderNo)
                        jsonObject10.put("projectCode", projectCode)
                        jsonObject10.put("projectName", projectName)
                        jsonObject10.put(
                            "address",
                            address
                        )
                        jsonObject10.put("contractStartTime", contractStartTime)


                        val deviceInfos = JSONArray()

                        deviceList?.forEach { item ->
                            val device = JSONObject()
                            device.put("deviceSn", item.get("deviceSn"))
                            device.put("gatewaySn", item.get("gatewaySn"))
                            device.put("deviceNid", item.get("deviceNid"))
                            device.put("deviceName", item.get("deviceName"))
                            deviceInfos.add(device)
                        }

                        jsonObject10.put("deviceInfos", deviceInfos)
                        var back = HttpUtilContainer.getAppChargeHandler()
                            .activateContract(jsonObject10);
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