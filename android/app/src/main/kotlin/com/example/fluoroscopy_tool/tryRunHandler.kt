package com.example.fluoroscopy_tool

import android.R.attr.value
import cn.hutool.json.JSONObject
import com.google.gson.Gson
import com.mideaibp.agent.container.HttpUtilContainer
import com.mideaibp.apps.service.TestRunService
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.io.InputStream


class tryRunHandler (private val channel: MethodChannel) : MethodChannel.MethodCallHandler  {
    var TestRunServiceob =  TestRunService.getInstance();
    val gson: Gson = Gson()
    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getTestRunStatus" -> getTestRunStatus(call,result)
            "openTestRun" -> openTestRun(call,result)
            "getHtmlResult" -> getHtmlResult(call,result)
            "getTrailOperationSimpleReport" -> getTrailOperationSimpleReport(call,result)
            "testRunReportSendEmail" -> testRunReportSendEmail(call,result)
            "uploadTestRunFile" -> uploadTestRunFile(call,result)
            else -> result.notImplemented()
        }
    }

    fun saveByteArrayOutputStreamToFile(byteArrayOutputStream: ByteArrayOutputStream, filePath: String) {
        val file = File(filePath)
        try {
            // 将 ByteArrayOutputStream 转换为字节数组
            val byteArray = byteArrayOutputStream.toByteArray()

            // 使用 FileOutputStream 将字节数组写入文件
            FileOutputStream(file).use { outputStream ->
                outputStream.write(byteArray)
            }

            println("文件保存成功: $filePath")
        } catch (e: IOException) {
            println("保存文件时发生错误: ${e.message}")
        }
    }

    private fun getTrailOperationSimpleReport(call: MethodCall, result: MethodChannel.Result) {
        val sysid = call.argument<String>("sysid")
        HttpUtilContainer.executor.execute(
            Runnable {
                try{
                    var back = HttpUtilContainer.getMideaAppHandler().getTrailOperationSimpleReport(sysid)
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


    private fun testRunReportSendEmail(call: MethodCall, result: MethodChannel.Result) {
        val email = call.argument<String>("email")
        val diviceSn = call.argument<String>("diviceSn")
        val reportUrl = call.argument<String>("reportUrl")
        HttpUtilContainer.executor.execute(
            Runnable {
                try{
                    val js = JSONObject()
                    js.put("email", email)
                    js.put("reportUrl", reportUrl)
                    js.put("diviceSn", diviceSn)
                    var back = HttpUtilContainer.getMideaAppHandler().testRunReportSendEmail(js)
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


    private fun getTestRunStatus(call: MethodCall, result: MethodChannel.Result) {
        HttpUtilContainer.executor.execute(
            Runnable {
                try{
                    var back = TestRunServiceob.getTestRunStatus()
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

    private fun openTestRun(call: MethodCall, result: MethodChannel.Result) {
        HttpUtilContainer.executor.execute(
            Runnable {
                try{
                    var back = TestRunServiceob.openTestRun()
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


    private fun getHtmlResult(call: MethodCall, result: MethodChannel.Result) {
        HttpUtilContainer.executor.execute(
            Runnable {
                try{
                    var back = TestRunServiceob.getHtmlResult()
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



    private fun uploadTestRunFile(call: MethodCall, result: MethodChannel.Result) {
        val datadataString = call.argument<String>("data")

        HttpUtilContainer.executor.execute(
            Runnable {
                try{
                    val jsonObject4 = JSONObject(datadataString);

                    println("uploadTestRunFile: $jsonObject4")


                    var back = HttpUtilContainer.getProfessionalToolsHandler().uploadTestRunFile(jsonObject4);

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