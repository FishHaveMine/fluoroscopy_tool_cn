package com.example.fluoroscopy_tool


import android.os.Build
import androidx.annotation.RequiresApi
import cn.hutool.json.JSONArray
import cn.hutool.json.JSONObject
import com.google.gson.Gson
import com.google.gson.JsonObject
import com.mideaibp.agent.container.HttpUtilContainer
import com.mideaibp.apps.model.common.DeviceTypeEnum
import com.mideaibp.apps.model.common.firmware.UpgradeTypeEnum
import com.mideaibp.apps.service.FirmwareUpgradeService
import com.mideaibp.apps.service.RefrigerantService
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.time.LocalDateTime
import java.time.ZoneId
class MbtBasicOtaHandler(private val channel: MethodChannel) : MethodChannel.MethodCallHandler {
    var FirmwareUpgrade =  FirmwareUpgradeService.getInstance();
    val gson: Gson = Gson()
    init {
        channel.setMethodCallHandler(this)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "listFirmwares" -> listFirmwares(call,result)
            "firmwareDetails" -> firmwareDetails(call,result)
            "firmwarePackages" -> firmwarePackages(call,result)
            "firmwareDownloadUrl" -> firmwareDownloadUrl(call,result)

            "getFirmwareVersion" -> getFirmwareVersion(call,result)
            "analysisPackage" -> analysisPackage(call,result)
            "startUpgrade" -> startUpgrade(call,result)
            "getEntity" -> getEntity(call,result)
            "interruptUpgrade" -> interruptUpgrade(call,result)
            "getFirmwareUpgradeLos" -> getFirmwareUpgradeLos(call,result)
            "getUpgradeDetail" -> getUpgradeDetail(call,result)

            else -> result.notImplemented()
        }
    }

    private fun getFirmwareVersion(call: MethodCall, result: MethodChannel.Result) {
        val deviceType = call.argument<Int>("deviceType")
        HttpUtilContainer.executor.execute(
            Runnable {
                try{
//                    ODU(0),
//                    IDU(1),
//                    SYS(2);
                    var back = FirmwareUpgrade.getFirmwareVersion(DeviceTypeEnum.fromInt(deviceType!!))
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

    private fun analysisPackage(call: MethodCall, result: MethodChannel.Result) {
        val url = call.argument<String>("url")
        val address = call.argument<Int>("address")
        val size = call.argument<Int>("size")
        HttpUtilContainer.executor.execute(
            Runnable {
                try{
                    var back = FirmwareUpgrade.analysisPackage(url,address,size)
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

    private fun startUpgrade(call: MethodCall, result: MethodChannel.Result) {
        val deviceType = call.argument<Int>("deviceType")
        val addressList = call.argument<List<Int>>("addressList")
        val upgradeTypeEnum = call.argument<Int>("upgradeTypeEnum")
        HttpUtilContainer.executor.execute(
            Runnable {
                try{
                    var u = UpgradeTypeEnum.UpgradeTypeEnum_1;
                    if(upgradeTypeEnum == 1) {
                        u = UpgradeTypeEnum.UpgradeTypeEnum_2;
                    }
                    var back = FirmwareUpgrade.startUpgrade(DeviceTypeEnum.fromInt(deviceType!!),addressList,
                        u)
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

    private fun getEntity(call: MethodCall, result: MethodChannel.Result) {
        val deviceType = call.argument<Int>("deviceType")
        HttpUtilContainer.executor.execute(
            Runnable {
                try{
//                    ODU(0),
//                    IDU(1),
//                    SYS(2);
                    var back = FirmwareUpgrade.getEntity()
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

    private fun getFirmwareUpgradeLos(call: MethodCall, result: MethodChannel.Result) {
        val pageindex = call.argument<Int>("pageindex")
        HttpUtilContainer.executor.execute(
            Runnable {
                try{
//                    ODU(0),
//                    IDU(1),
//                    SYS(2);
                    var back = FirmwareUpgrade.getFirmwareUpgradeLos(pageindex)

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

    @RequiresApi(Build.VERSION_CODES.O)
    private fun getUpgradeDetail(call: MethodCall, result: MethodChannel.Result) {
        val uuid = call.argument<String>("uuid")
        HttpUtilContainer.executor.execute(
            Runnable {
                try{
//                    ODU(0),
//                    IDU(1),
//                    SYS(2);
                    var back = FirmwareUpgrade.getUpgradeDetail(uuid)

                    // 将 LocalDateTime 转换为时间戳（毫秒）
                    val timestamp = back.data[0].time.atZone(ZoneId.systemDefault()).toInstant().toEpochMilli()
                    print("timestamp: $timestamp");

                    // 将对象序列化为 JSON
                    val jsonObject = JsonObject()
                    jsonObject.addProperty("date", gson.toJson(back.data));
                    jsonObject.addProperty("upgradeTime", timestamp) // 添加自定义属性
                    val json: String = gson.toJson(jsonObject)
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


    private fun interruptUpgrade(call: MethodCall, result: MethodChannel.Result) {
        val deviceType = call.argument<Int>("deviceType")
        HttpUtilContainer.executor.execute(
            Runnable {
                try{
//                    ODU(0),
//                    IDU(1),
//                    SYS(2);
                    var back = FirmwareUpgrade.interruptUpgrade()
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

    //// 固件列表
    private fun listFirmwares(call: MethodCall, result: MethodChannel.Result) {
        val typePath = call.argument<String>("typePath")
        val pageIndex = call.argument<Int>("pageIndex")
        HttpUtilContainer.executor.execute(
            Runnable {
                try{
                    val jsonObject = JSONObject()
                    val query = JSONObject()
                    query.put("pageIndex", pageIndex)
                    query.put("pageSize", 10)
                    query.put("typePath", typePath)
                    query.put("type", "FIRMWARE")
                    jsonObject.put("query", query)
                    // 创建一个 JSON 对象
                    var back =  HttpUtilContainer.getMbtBasicOtaHandler().listFirmwares(jsonObject)
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

    //// 固件详情
    private fun firmwareDetails(call: MethodCall, result: MethodChannel.Result) {
        val byId = call.argument<String>("byId")
        HttpUtilContainer.executor.execute(
            Runnable {
                try{
                    val jsonObject = JSONObject()
                    jsonObject.put("byId", byId)
                    // 创建一个 JSON 对象
                    var back =  HttpUtilContainer.getMbtBasicOtaHandler().firmwareDetails(jsonObject)
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


    //// 获取固件版本号列表
    private fun firmwarePackages(call: MethodCall, result: MethodChannel.Result) {
        val byId = call.argument<String>("byId")
        HttpUtilContainer.executor.execute(
            Runnable {
                try{
                    val jsonObject = JSONObject()
                    val query = JSONObject()
                    val normaljsonArray = JSONArray()
                    normaljsonArray.add(byId)
                    query.put("pageIndex", 1)
                    query.put("pageSize", 10)
                    query.put("tagOnFirstLine", "latest")
                    query.put("componentIdIn", normaljsonArray)
                    jsonObject.put("query", query)
                    // 创建一个 JSON 对象
                    var back =  HttpUtilContainer.getMbtBasicOtaHandler().firmwarePackages(jsonObject)
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

    //// 生成固件下载链接
    private fun firmwareDownloadUrl(call: MethodCall, result: MethodChannel.Result) {
        val byId = call.argument<String>("byId")
        HttpUtilContainer.executor.execute(
            Runnable {
                try{
                    val jsonObject = JSONObject()
                    if (byId != null) {
                        jsonObject.put("byId", byId.toInt())
                    }
                    // 创建一个 JSON 对象
                    var back =  HttpUtilContainer.getMbtBasicOtaHandler().firmwareDownloadUrl(jsonObject)
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
