package com.example.fluoroscopy_tool


import cn.hutool.json.JSONArray
import cn.hutool.json.JSONObject
import com.google.gson.Gson
import com.mideaibp.agent.container.HttpUtilContainer
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

class getProjectHandler(private val channel: MethodChannel) : MethodChannel.MethodCallHandler {

    val gson: Gson = Gson()

    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

        //// 查询工程带设备数据(es查询)
        ////// online - true/false ：在线/离线
        ////// open - true/false ：运行/关闭
        ////// fault - true/false ：故障/正常
        ////// gateWayStatus - 0/5/1/2/3 ：离线/在线/运行/故障/关机
        ////// projectType = fjjngz: 含旧改云联
        ////// key:XM221104186950
        if (call.method == "listProjectsWithDevices") {
            val history: Boolean? = call.argument<Boolean>("history");
            val key = call.argument<String>("key")
            val pageIndex = call.argument<Int>("pageIndex")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        val immutableList: List<String> = listOf()
                        var back = HttpUtilContainer.getProjectHandler().listProjectsWithDevices(
                            "", "", "", "",
                            "",
                            immutableList, "", "",
                            "", key, "", "", "", "", "",
                            "", "", "", "", "",
                            "", true, null, pageIndex, 5,
                            history == true
                        );
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



        if (call.method == "getSearchHistories") {
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        val immutableList: List<String> = listOf()
                        var back = HttpUtilContainer.getProjectHandler().getSearchHistories(
                            "projectDetail",
                        );
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


        if (call.method == "getPageProject") {
            val key = call.argument<String>("key")
            val pageIndex = call.argument<Int>("pageIndex")
            val pageSize = call.argument<Int>("pageSize")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        val jsonObject = JSONObject()
                        jsonObject.put("pageIndex", pageIndex)
                        jsonObject.put("pageSize", 2)
                        jsonObject.put("projectName", key)
                        jsonObject.put("projectCode", key)
                        var back = HttpUtilContainer.getProfessionalToolsHandler()
                            .getPageProject(jsonObject);
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
        //// 距离最近项目
        if (call.method == "nearestProject") {
            val pageSize = call.argument<Int>("pageSize")
            val latitude = call.argument<String>("latitude")
            val longitude = call.argument<String>("longitude")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        val jsonObject = JSONObject()
                        jsonObject.put("pageIndex", 1)
                        jsonObject.put("pageSize", pageSize)
                        jsonObject.put("latitude", latitude)
                        jsonObject.put("longitude", longitude)
                        var back = HttpUtilContainer.getAppChargeHandler()
                            .nearestProject(jsonObject);
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


        //// 点击进入工程详细页面
        if (call.method == "getIndoorTopologyData") {

            val projectCode = call.argument<String>("projectCode")

            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        val outdoor = JSONObject()
                        outdoor.put("group", "topology");
                        outdoor.put("projectCode", projectCode);
                        var back =
                            HttpUtilContainer.getSystemDataHandler().getIndoorTopologyData(outdoor);
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
//// 统计工程外机i管家合同状态（i管家）
        if (call.method == "deviceUnlockRunStatisticRun") {

            val type = call.argument<String>("type")
            val projectId = call.argument<String>("projectId")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        val outdoor = JSONObject()
                        outdoor.put("deviceType", "outdoor")
                        outdoor.put("projectId", projectId)
                        outdoor.put("origin", "2")
                        var back = HttpUtilContainer.getIManagerHomepageHandler()
                            .deviceUnlockRunStatisticRun(outdoor);
                        val json: String = gson.toJson(back)
                        result.success(json)

                    } catch (e: Exception) {
                        print("deviceUnlockRunStatisticRun : ${e}");
                        val js = JSONObject()
                        js.put("errorCode", 1000);
                        js.put("data", intArrayOf());
                        result.success(js)
                    }
                }
            );
        }


        //// 统计工程内机设置（i管家）
        if (call.method == "deviceLockRunStatistic") {
            val indoor = call.argument<String>("indoor")
            val projectId = call.argument<String>("projectId")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        val outdoor = JSONObject()
                        outdoor.put("deviceType", "indoor");
                        outdoor.put("projectId", projectId);
                        var back = HttpUtilContainer.getIManagerHomepageHandler()
                            .deviceLockRunStatistic(outdoor);
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
//// 获取用户下拉
        if (call.method == "getUserHandler.getUserList") {
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        var back = HttpUtilContainer.getUserHandler().getUserList("")
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


//// 分中心分页查询
        if (call.method == "getSystemBranchHandler.page") {

            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        var back = HttpUtilContainer.getSystemBranchHandler().page("")
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


//// 获取字典数据下拉
        if (call.method == "getMideaAppHandler.getDictList") {

            val categoryCode = call.argument<String>("categoryCode")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        var back = HttpUtilContainer.getMideaAppHandler().getDictList(categoryCode)
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


//// 获取字典数据下拉
        if (call.method == "getSystemAreaHandler.countryAreaTree") {

            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        var back = HttpUtilContainer.getSystemAreaHandler().countryAreaTree(null)
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

        if (call.method == "getSystemAreaHandler.byCode") {

            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        var back = HttpUtilContainer.getSystemAreaHandler().byCode("1110100")
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
//// 添加旧改项目（氟机节能改造）
        if (call.method == "getProjectHandler.add") {

            val sendForm = call.argument<Map<String, Any>>("sendForm")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        println(sendForm)
                        println(JSONObject(sendForm))

                        val areaId = sendForm?.get("areaId") as? Int

                        val js = JSONObject()
                        js.put("address", sendForm?.get("address") ?: "")
                        if (areaId != null) {
                            js.put("areaId", areaId.toLong())
                        }
                        js.put("brand", sendForm?.get("brand") ?: "")
                        js.put("brandCode", sendForm?.get("brandCode") ?: "")
                        js.put("branchCode", sendForm?.get("branchCode") ?: "")
                        js.put("countryCode", "CN")
                        js.put("latitude", sendForm?.get("latitude") ?: "")
                        js.put("longitude", sendForm?.get("longitude") ?: "")
                        js.put("name", sendForm?.get("name") ?: "")
                        js.put("priority", sendForm?.get("priority") ?: "")
                        js.put("projectScene", sendForm?.get("projectScene") ?: "")
                        js.put("projectType", sendForm?.get("projectType") ?: "")
                        js.put("remark", sendForm?.get("remark") ?: "")
                        val contactList = JSONArray()
                        contactList.add(sendForm?.get("contactList") ?: "")
                        js.put("contactList", contactList)
                        println(js);
                        var back = HttpUtilContainer.getProjectHandler().add(js)
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


        //// 编辑旧改项目（氟机节能改造）
        if (call.method == "getAppFluorineMachineEnergyHandler.saveOrUpdateProject") {

            val sendForm = call.argument<Map<String, Any>>("sendForm")
            println("编辑旧改项目（氟机节能改造）: $sendForm");
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        val js = JSONObject()
//                        js.put("id", "7930725") // 更新时传参
//                        js.put("projectCode", "JG24-10-24MD0004") // 更新时传参
                        val areaId = sendForm?.get("areaId") as? Int
                        js.put("name", sendForm?.get("name") ?: "")
                        js.put("projectScene", sendForm?.get("projectScene") ?: "")

                        js.put("address", sendForm?.get("address") ?: "")
                        if (areaId != null) {
                            js.put("areaId", areaId.toLong())
                        }
                        js.put("projectType", sendForm?.get("projectType") ?: "")
                        js.put("remark", sendForm?.get("remark") ?: "")

                        js.put("associatedUserName", sendForm?.get("associatedUserName") ?: "")
                        js.put("phoneNumber", sendForm?.get("phoneNumber") ?: "")

                        js.put("major", 0)
                        js.put(
                            "deviceType",
                            "${sendForm?.get("brand")}-${sendForm?.get("brandCode")}"
                        ) // HttpUtilContainer.getMideaAppHandler().getDictList("BRAND") -> value + code

                        val outerTotal = sendForm?.get("outerTotal") as? Int
                        val ratio = sendForm?.get("ratio") as? Int
                        js.put("outerTotal", outerTotal)
                        js.put("ratio", ratio)

                        js.put("contactList", intArrayOf())

                        println("编辑旧改项目（氟机节能改造）js: $js");
                        var back = HttpUtilContainer.getAppFluorineMachineEnergyHandler()
                            .saveOrUpdateProject(js)
                        val json: String = gson.toJson(back)
                        result.success(json)

                    } catch (e: Exception) {
                        println("编辑旧改项目（氟机节能改造）失败: $e");
                        val js = JSONObject()
                        js.put("errorCode", 1000);
                        js.put("data", e);
                        result.success(js)
                    }
                }
            );
        }
        ////  设备搜索历史+系统详细信
        if (call.method == "getProfessionalToolsHandler.getSearchHisWithTags") {
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        var back = HttpUtilContainer.getDeviceHandler()
                            .getSearchHistories("sysDetail")
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


        ////  设备搜索历史+系统详细信
        if (call.method == "getProfessionalToolsHandler.insertSearchHistory") {

            val deviceSn = call.argument<String>("deviceSn")

            val projectDetail = call.argument<String>("projectDetail")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        val js = JSONObject();
                        if(deviceSn != "")js.put("deviceSn",deviceSn);
                        if(projectDetail != "")js.put("projectDetail",projectDetail);
                        var back = HttpUtilContainer.getProfessionalToolsHandler()
                            .insertSearchHistory(js);
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

        //// 获取项目内系统列表
        if (call.method == "getProfessionalToolsHandler.page") {
            val projectCode = call.argument<String>("projectCode")
            val sn = call.argument<String>("sn")
            val pageindex = call.argument<Int>("pageindex")

            val vrfNid = call.argument<String>("vrfNid")
            val netModelEnum = call.argument<String>("netModelEnum")
            val status = call.argument<String>("status")

            val indoorLockStatusEnum = call.argument<String?>("indoorLockStatusEnum")
            val outdoorModeSettingEnum = call.argument<String?>("outdoorModeSettingEnum")
            val outdoorPowerRationing = call.argument<Boolean?>("outdoorPowerRationing")
            val outdoorMuteSetting = call.argument<Boolean?>("outdoorMuteSetting")
            val indoorEnergySaveStatus = call.argument<Boolean?>("indoorEnergySaveStatus")

            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        val jsonObject = JSONObject()
                        jsonObject.put("pageIndex", pageindex);
                        jsonObject.put("pageSize", 10);
                        jsonObject.put("projectCode", projectCode);

                        if (sn != "") jsonObject.put("sn", sn);
                        if (vrfNid != "") jsonObject.put("vrfNid", vrfNid);
                        if (netModelEnum != null && netModelEnum != "") {
                            jsonObject.put("netModelEnum", netModelEnum.toInt())
                        };
                        if (status != null && status != "") jsonObject.put(
                            "status",
                            status.toInt()
                        );

                        if (indoorLockStatusEnum != null && indoorLockStatusEnum != "") jsonObject.put(
                            "indoorLockStatusEnum",
                            indoorLockStatusEnum
                        );
                        if (outdoorModeSettingEnum != null && outdoorModeSettingEnum != "") jsonObject.put(
                            "outdoorModeSettingEnum",
                            outdoorModeSettingEnum
                        );

                        if (outdoorPowerRationing != null) jsonObject.put(
                            "outdoorPowerRationing",
                            outdoorPowerRationing
                        );
                        if (outdoorMuteSetting != null) jsonObject.put(
                            "outdoorMuteSetting",
                            outdoorMuteSetting
                        );
                        if (indoorEnergySaveStatus != null) jsonObject.put(
                            "indoorEnergySaveStatus",
                            indoorEnergySaveStatus
                        );

                        println("jsonObject.toString() ${jsonObject.toString()}")

                        var back = HttpUtilContainer.getProfessionalToolsHandler().page2(jsonObject)
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


        //// 获取项目内系统列表
        if (call.method == "getProfessionalToolsHandler.getSystemSelectList") {
            val projectCode = call.argument<String>("projectCode")

            val vrfNid = call.argument<String>("vrfNid")
            val netModelEnum = call.argument<String>("netModelEnum")
            val status = call.argument<String>("status")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {

                        var back =
                            HttpUtilContainer.getProfessionalToolsHandler().getSystemSelectList(
                                projectCode,
                                vrfNid, status, netModelEnum
                            )
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

        //// 获取项目内所有内机状态统计
        if (call.method == "getProfessionalToolsHandler.getDevicePropertyCount") {
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        val jsonObject = JSONObject()
                        var back = HttpUtilContainer.getProfessionalToolsHandler()
                            .getDevicePropertyCount("XM221104186950")
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


        //// 获取所选系统所有状态统计
        if (call.method == "getProfessionalToolsHandler.getProjectSystemPropertyCount") {

            val sysNidList = call.argument<List<String>>("sysNidList")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        var back = HttpUtilContainer.getProfessionalToolsHandler()
                            .getProjectSystemPropertyCount(sysNidList);
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


        // 点击进入设备
        // 非旧改设备
        //// 系统详情
        if (call.method == "getSystemDataHandler.getDetailBySn") {
            val sysid = call.argument<String>("sysid")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        var back = HttpUtilContainer.getSystemDataHandler().getDetailBySn(sysid)
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

        //// 系统点检
        if (call.method == "getDeviceHandler.sysDevCheckData") {
            val sysid = call.argument<String>("sysid")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        var back =
                            HttpUtilContainer.getDeviceHandler().sysDevCheckData(sysid, null, null)
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

        // 旧改设备
        //// 点击进入旧改设备
        if (call.method == "getAppFluorineMachineEnergyHandler.snJumpModule") {
            val sysid = call.argument<String>("sysid")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        var back = HttpUtilContainer.getAppFluorineMachineEnergyHandler()
                            .snJumpModule(sysid)
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

        //// 喷淋时长重置
        if (call.method == "getAppFluorineMachineEnergyHandler.sprayDurationReset") {
            val sysid = call.argument<String>("sysid")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        var back = HttpUtilContainer.getAppFluorineMachineEnergyHandler()
                            .sprayDurationReset(sysid)
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

        //// 获取调试剩余时间
        if (call.method == "getAppFluorineMachineEnergyHandler.queryDebugModeTimeRemaining") {
            val sysid = call.argument<String>("sysid")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        var back = HttpUtilContainer.getAppFluorineMachineEnergyHandler()
                            .queryDebugModeTimeRemaining(sysid)
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

        //// 开启/关闭调试
        if (call.method == "getAppFluorineMachineEnergyHandler.controlDebugging") {
            val sysid = call.argument<String>("sysid")
            val start = call.argument<Boolean>("start")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {

                        val jsonObject = JSONObject()
                        jsonObject.put("nid", sysid)
                        jsonObject.put("start", start)
                        // 创建一个 JSON 对象
                        var back = HttpUtilContainer.getAppFluorineMachineEnergyHandler()
                            .controlDebugging(jsonObject)
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
            val sysid = call.argument<Long>("sysid")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {

                        val jsonObject = JSONObject()
                        jsonObject.put("gearSetting", 1)
                        jsonObject.put("sprayStartTemp", 21)
                        jsonObject.put("enableSetting", 1)
                        jsonObject.put("systemId", sysid?.toLong())
                        // 创建一个 JSON 对象
                        var back =
                            HttpUtilContainer.getAppFluorineMachineEnergyHandler().spray(jsonObject)
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
            val sysid = call.argument<String>("sysid")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        var back =
                            HttpUtilContainer.getAppFluorineMachineEnergyHandler().getSpray(sysid)
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


        //// 旧改系统点检
        if (call.method == "getAppFluorineMachineEnergyHandler.getRoutineCheckData") {
            val sn = call.argument<String>("sn")
            val id = call.argument<Long>("id")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        var back = HttpUtilContainer.getAppFluorineMachineEnergyHandler()
                            .getRoutineCheckData(
                                sn,
                                id?.toLong()
                            )
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

        //// 批量解绑设备
        if (call.method == "getDeviceHandler.batchUnbindDevices") {
            val projectId = call.argument<String>("projectId")
            val deviceList = call.argument<List<Map<String, Any>>>("deviceList")
            println("projectCode: ${projectId}")
            println("deviceList: ${deviceList}")


            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        val jsonObject = JSONObject()
                        jsonObject.put("projectId", projectId)
                        jsonObject.put("deviceList", deviceList)
                        println(jsonObject)
                        // 创建一个 JSON 对象
                        var back =
                            HttpUtilContainer.getProjectHandler().deleteDevice(jsonObject)
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


        //// 设备线上解锁
        if (call.method == "getDeviceUnlockHandler.toolUnlock") {
            val sn = call.argument<String>("sn")
            val operator = call.argument<String>("operator")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        val barCodeList = JSONObject()
                        val barCode1 = JSONObject()
                        barCode1.put("barCode", sn)
                        barCode1.put("operator", operator)
                        val list = JSONArray()
                        list.add(barCode1)
                        barCodeList.put("barCodeList", list)
                        // 创建一个 JSON 对象
                        var back =
                            HttpUtilContainer.getDeviceUnlockHandler().toolUnlock(barCodeList)
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


        //// 节能模块检查(查重)
        if (call.method == "getAppFluorineMachineEnergyHandler.moduleCheck") {
            val sn = call.argument<String>("sn")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        val jsonObject = JSONObject()
                        val sns = JSONObject()
                        sns.put("0#", sn)
                        jsonObject.put("sns", sns)
                        // 创建一个 JSON 对象
                        var back = HttpUtilContainer.getAppFluorineMachineEnergyHandler()
                            .moduleCheck(jsonObject)
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
        if (call.method == "getAppFluorineMachineEnergyHandler.deviceImportUploadImg") {
            val filePath = call.argument<String>("filePath")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        val file = File(filePath)
                        var back = HttpUtilContainer.getAppFluorineMachineEnergyHandler()
                            .deviceImportUploadImg(file)
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


        //// 添加设备
        if (call.method == "getAppFluorineMachineEnergyHandler.addEnergySys") {

            val getjsonObject = call.argument<Map<String, Any>>("jsonObject")
            val getmoduleInfos = call.argument<Map<String, Any>>("moduleInfos")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {

                        val jsonObject = JSONObject()
                        jsonObject.put("deviceType", getjsonObject?.get("deviceType") ?: "");
                        jsonObject.put("productBrand", getjsonObject?.get("productBrand") ?: "");
                        jsonObject.put("modifyType",getjsonObject?.get("modifyType") ?: "");
                        jsonObject.put("series", getjsonObject?.get("series") ?: "");
                        jsonObject.put("systemName", getjsonObject?.get("systemName") ?: "");
                        jsonObject.put("eauxiliaryHeat", getjsonObject?.get("eauxiliaryHeat") ?: "");
                        jsonObject.put("projectCode", getjsonObject?.get("projectCode") ?: "");
                        jsonObject.put("waterHardness", getjsonObject?.get("waterHardness") ?: "");
                        jsonObject.put(
                            "uploadLocation",
                            getjsonObject?.get("uploadLocation") ?: ""
                        );



                        jsonObject.put("usedTimeYear", getjsonObject?.get("usedTimeYear") ?: "");
                        jsonObject.put("refType", getjsonObject?.get("refType") ?: "");
                        jsonObject.put("coolCop", getjsonObject?.get("coolCop") ?: "");
                        jsonObject.put("heatCop", getjsonObject?.get("heatCop") ?: "");

                        println(jsonObject)
                        val jsonArray = JSONArray();

                        val moduleInfos = JSONObject();
                        moduleInfos.put("moduleSn", getmoduleInfos?.get("moduleSn") ?: "");
                        moduleInfos.put("moduleType", getmoduleInfos?.get("moduleType") ?: "");
                        moduleInfos.put("pieces", getmoduleInfos?.get("pieces") ?: "");

                        val keysToCopy = listOf(
                            "cloudConnectionBoxImg",
                            "sprayDeviceInstallImg",
                            "powerPositionImg",
                            "waterTreatmentDeviceImg",
                            "otherImg",
                            "outdoorNamePlateImg",
                            "oldReformImgDataCompleteness"
                        )

                        for (key in keysToCopy) {
                            val value = getmoduleInfos?.get(key)?.toString()
                            if (!value.isNullOrBlank()) {
                                moduleInfos.put(key, value)
                            }
                        }


                        jsonArray.add(moduleInfos);
                        jsonObject.put("moduleInfos", jsonArray);
                        // 创建一个 JSON 对象
                        var back = HttpUtilContainer.getAppFluorineMachineEnergyHandler()
                            .addEnergySys(jsonObject)
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
        if (call.method == "getProfessionalToolsHandler.getSimFrequency") {
            val gatewayNid = call.argument<String>("gatewayNid")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        var back = HttpUtilContainer.getProfessionalToolsHandler().getSimFrequency(gatewayNid);
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
//
        if (call.method == "getProfessionalToolsHandler.updateSimFrequency") {
            val nid = call.argument<String>("gatewayNid")
            val setFrequency = call.argument<String>("setFrequency")
            val simFrequency = call.argument<String>("recoverFrequency")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        val sns = JSONObject()
                        sns.put("gatewayNid", nid)
                        sns.put("setFrequency", setFrequency)
                        sns.put("recoverFrequency", simFrequency)
                        var back = HttpUtilContainer.getProfessionalToolsHandler().updateSimFrequency(sns)
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

        if (call.method == "getMideaAppHandler.searchFaultInfo") {
            val keyword = call.argument<String>("keyword")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        var back = HttpUtilContainer.getMideaAppHandler().searchFaultInfo(keyword)
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


        if (call.method == "getMideaAppHandler.getFaultDetail") {
            val id = call.argument<Int>("id")
            HttpUtilContainer.executor.execute(
                Runnable {
                    try {
                        // 创建一个 JSON 对象
                        var back = HttpUtilContainer.getMideaAppHandler().getFaultDetail(id?.toLong()
                            ?: 0, "", "", "", "")
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
