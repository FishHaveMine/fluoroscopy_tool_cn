package com.example.fluoroscopy_tool

import FileLoggingOutputStream
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.PowerManager
import android.provider.Settings
import android.view.WindowManager
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import cn.hutool.json.JSONArray
import cn.hutool.json.JSONObject
import com.alibaba.fastjson.JSON
import com.google.gson.Gson
import com.mideaibp.agent.container.HttpUtilContainer
import com.mideaibp.agent.enums.Environment
import com.mideaibp.agent.handler.MideaAppHandler
import com.mideaibp.apps.frontEnd.FanSpeedSelectEnum
import com.mideaibp.apps.frontEnd.OnOffSelectEnum
import com.mideaibp.apps.frontEnd.RunModeSelectEnum
import com.mideaibp.apps.helper.ProtocolHandler
import com.mideaibp.apps.model.SystemInfo
import com.mideaibp.apps.model.common.ExvTypeEnum
import com.mideaibp.apps.model.common.LinkSettingEnum
import com.mideaibp.apps.model.common.UserDTO
import com.mideaibp.apps.model.dto.MonitorData
import com.mideaibp.apps.model.logback.UnlockLog
import com.mideaibp.apps.service.CenterControlService
import com.mideaibp.apps.service.CommunicationDetectionService
import com.mideaibp.apps.service.DeviceUnLockService
import com.mideaibp.apps.service.ElectronicService
import com.mideaibp.apps.service.InitService
import com.mideaibp.apps.service.InstallService
import com.mideaibp.apps.service.ProtocolCheckService
import com.mideaibp.apps.service.PumpDetectionService
import com.mideaibp.apps.service.RefrigerantService
import com.mideaibp.apps.service.SalesBoardReplaceService
import com.mideaibp.apps.service.WriteSnService
import com.mideaibp.apps.util.McuUtil
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.io.File
import java.io.PrintStream
import java.io.RandomAccessFile
import java.text.SimpleDateFormat
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.time.temporal.ChronoUnit
import java.util.Calendar
import java.util.Date
import java.util.Locale

class MainActivity : FlutterActivity() {
    var controlService = CenterControlService.getInstance()
    var instance = InitService.getInstance()

    private var wakeLock: PowerManager.WakeLock? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        println("-----------------------MainActivity  onCreate----------------------------------")
        try {
            val context = applicationContext
            System.setProperty("app.base.dir", context.filesDir.absolutePath);
            InitService.getInstance().init() //后台http服务初始化
        } catch (e: Exception) {
            println(e)
        }

        redirectToLogFile()
    }


    // 禁用自动熄屏
    private fun disableAutoSleep() {
        // 获取窗口对象，设置屏幕常亮
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
    }

    // 恢复自动熄屏
    private fun enableAutoSleep() {
        // 清除屏幕常亮标志，恢复系统默认的自动熄屏
        window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
    }

    private fun requestInstallPermission() {
        val intent = Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES)
        intent.setData(Uri.parse("package:$packageName"))
        startActivityForResult(intent, 100)
    }

    override fun onDestroy() {
        super.onDestroy()
        HttpUtilContainer.executor.shutdown();

        // 释放 WakeLock
        wakeLock?.release()
        wakeLock = null
    }

    private fun redirectToLogFile() {
        val dateFormat = SimpleDateFormat("yyyy-MM-dd-HH-mm", Locale.getDefault())
        val currentDate = dateFormat.format(Date())

        val logDir = File(context.filesDir, "log")
        if (!logDir.exists()) logDir.mkdirs()

        val logFile = File(logDir, "app_log_$currentDate.txt")

        val fileLoggingOutputStream = FileLoggingOutputStream(logFile)

        println("日志输出路径: ${logFile.path}")

        deleteOldLogFiles(context) // 你已有的删除旧日志函数

        // ✅ 同时写入文件和 Logcat
        System.setOut(PrintStream(fileLoggingOutputStream, true))
        System.setErr(PrintStream(fileLoggingOutputStream, true))
    }




    // 删除三天前的日志文件
    fun deleteOldLogFiles(context: Context) {
        // 获取当前日期
        val currentDate = Date()
        val calendar = Calendar.getInstance()
        calendar.time = currentDate
        calendar.add(Calendar.DATE, -5) // 获取三天前的日期
        val threeDaysAgo = calendar.time

        val logDir = File(context.filesDir, "log")
        if (!logDir.exists()) {
            logDir.mkdirs()
        }


        // 遍历目录中的所有文件
        val logFiles = logDir.listFiles { file ->
            // 仅筛选以 "app_log_" 开头的文件
            file.isFile && file.name.startsWith("app_log_")
        }

        logFiles?.forEach { file ->
            // 检查文件的最后修改时间是否早于三天前
            if (file.lastModified() < threeDaysAgo.time) {
                // 删除三天前的日志文件
                file.delete()
                println("Deleted old log file: ${file.name}")
            }
        }
    }

    private fun readLogFile(fileName: String?, maxBytes: Int = 500 * 1024): String {
        val logDir = File(context.filesDir, "log")
        if (!logDir.exists()) {
            logDir.mkdirs()
        }

        val logFile = File(logDir, fileName)
        if (!logFile.exists()) {
            return "Log file not found."
        }

        val fileLength = logFile.length()
        val start = if (fileLength > maxBytes) fileLength - maxBytes else 0

        val raf = RandomAccessFile(logFile, "r")
        raf.seek(start)
        val bytes = ByteArray((fileLength - start).toInt())
        raf.readFully(bytes)
        raf.close()

        return String(bytes)
    }

    private fun getLogFiles(): List<String> {
        val logDir = File(context.filesDir, "log")
        if (!logDir.exists()) {
            logDir.mkdirs()
        }
        val files = logDir?.listFiles { _, name -> true }
        return files?.map { it.name } ?: emptyList()
    }

    private fun deleteLogFile(fileName: String): Boolean {
        val logDir = File(context.filesDir, "log")
        if (!logDir.exists()) {
            logDir.mkdirs()
        }
        val logFile = File(logDir, fileName)
        return logFile.delete()
    }

    private fun clearFileContent(filePath: String) {

        val logDir = File(context.filesDir, "log")
        if (!logDir.exists()) {
            logDir.mkdirs()
        }
        val file = File(logDir, filePath)
        if (file.exists()) {
            file.writeText("")
        }
    }

    private val CHANNEL = "samples.flutter.dev/battery"
    private val CHANNEL_MbtBasicOtaHandler = "samples.flutter.dev/MbtBasicOtaHandler"
    private val CHANNEL_afterSalesReplacement = "samples.flutter.dev/afterSalesReplacement"
    private val CHANNEL_writeSnService = "samples.flutter.dev/writeSnService"
    private val CHANNEL_waterPumpInspec = "samples.flutter.dev/waterPumpInspec"

    private val CHANNEL_getDeviceFaultHandler = "samples.flutter.dev/getDeviceFaultHandler"
    private val CHANNEL_ProtocolCheckService = "samples.flutter.dev/ProtocolCheckService"
    private val CHANNEL_getSystemDataHandler = "samples.flutter.dev/getSystemDataHandler"
    private val CHANNEL_getProjectHandler = "samples.flutter.dev/getProjectHandler"
    private val CHANNEL_ibutler = "samples.flutter.dev/ibutler"
    private val CHANNEL_topology = "samples.flutter.dev/topology"
    private val CHANNEL_SprinklerSetting = "samples.flutter.dev/SprinklerSetting"
    private val CHANNEL_functionParamHandler = "samples.flutter.dev/functionParamHandler"
    private val CHANNEL_tryRunHandler = "samples.flutter.dev/tryRunHandler"
    private val CHANNEL_AntiTamperingServiceHandler = "samples.flutter.dev/AntiTamperingServiceHandler"
    private val CHANNEL_waterpumbBasicHandler = "samples.flutter.dev/waterpumbBasicHandler"
    private val CHANNEL_ElectronicService = "samples.flutter.dev/ElectronicService"
    private val CHANNEL_RefrigerantService = "samples.flutter.dev/RefrigerantService"
    private val CHANNEL_getTopologyHandler = "samples.flutter.dev/getTopologyHandler"


    private val CHANNEL_getDeviceUnlockHandler = "samples.flutter.dev/getDeviceUnlockHandler"


    private val CHANNEL_McuUtil = "samples.flutter.dev/McuUtil"
    private val CHANNEL_init = "samples.flutter.dev/init"
    private val CHANNEL_data = "sample.channel.data"

    val gson: Gson = Gson()
    private var isReceiverSet = false;

    class LogPrintStream(private val onLogReceived: (String) -> Unit) : PrintStream(System.out) {
        override fun println(x: String) {
            super.println(x)
            onLogReceived(x)
        }
    }


    private val CHANNEL_logs = "samples.flutter.dev/logs"

    private val logMessages = StringBuilder()
    private lateinit var logPrintStream: LogPrintStream

    private lateinit var mbtBasicOtaHandler: MbtBasicOtaHandler


    private val CHANNELUSB = "com.example.usb_channel"
    private var usbReceiver: BroadcastReceiver? = null



    private fun startUsbListener(result: MethodChannel.Result) {

        val filter = IntentFilter()
        filter.addAction(Intent.ACTION_MEDIA_MOUNTED)
        filter.addAction(Intent.ACTION_MEDIA_UNMOUNTED)
        filter.addAction(Intent.ACTION_MEDIA_REMOVED)
        filter.addAction(Intent.ACTION_MEDIA_EJECT)
        filter.addDataScheme("file") // 必须指定数据类型为 file


        usbReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                val action = intent.action
                if (Intent.ACTION_MEDIA_MOUNTED == action) {
                    val path = intent.data?.path
                    println("USB U盘已挂载，路径：$path")
                    // 通过MethodChannel将路径发送给Flutter
                    MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNELUSB).invokeMethod("onUsbMounted", path)
                } else if (Intent.ACTION_MEDIA_UNMOUNTED == action) {
                    println("USB U盘已卸载")
                    MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNELUSB).invokeMethod("onUsbMounted", "USB U盘已卸载")
                }
            }
        }


        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNELUSB).invokeMethod("onUsbMounted", "启动监听 发送 filter")
        registerReceiver(usbReceiver, filter)
        result.success(null)
    }

    private fun stopUsbListener() {
        usbReceiver?.let {
            unregisterReceiver(it)
            usbReceiver = null
            MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNELUSB).invokeMethod("onUsbMounted", "已取消监听")
            println("已取消监听")
        }
    }

    private fun sendBroadcast_TRIG(timeout: Int) {
        println("sendBroadcast_TRIG--- start")
        val intent = Intent("nlscan.action.SCANNER_TRIG")

        try {
            applicationContext.sendBroadcast(intent)
            println("广播发送成功")
        } catch (e: Exception) {
            println("广播发送失败: ${e.message}")
            e.printStackTrace()
        }

        println("sendBroadcast_TRIG--- end")
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        mbtBasicOtaHandler = MbtBasicOtaHandler(
            MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                CHANNEL_MbtBasicOtaHandler
            )
        )





        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNELUSB).setMethodCallHandler { call, result ->
            if (call.method == "setusdhost") {
                println("发送 nlscan.action.SET_USB_HOST")
                val usbHostIntent = Intent("nlscan.action.SET_USB_HOST")
                usbHostIntent.putExtra("mode", 1)
                sendBroadcast(usbHostIntent)
                MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNELUSB).invokeMethod("onUsbMounted", "发送 nlscan.action.SET_USB_HOST")
            } else if (call.method == "startUsbListener") {
                startUsbListener(result)
            } else if (call.method == "stopUsbListener") {
                stopUsbListener()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // This method is invoked on the main thread.
                call, result ->


            if (call.method == "disableAutoSleep") {
                // 禁用自动熄屏
                disableAutoSleep()
                result.success(null)
            }
            if (call.method == "enableAutoSleep") {
                // 恢复自动熄屏
                enableAutoSleep()
                result.success(null)
            }

            if (call.method == "outdoorDetection") {
                var FirmwareUpgrade = CommunicationDetectionService.getInstance();

                try {
                    HttpUtilContainer.executor.execute(
                        Runnable {
                            try {
                                var back = FirmwareUpgrade.outdoorDetection(2, 1);
                                val json: String = gson.toJson(back)
                            } catch (e: Exception) {
                                println("SCANNER_TRIG error ${e.message}")
                            }
                        }
                    );

                } catch (e: Exception) {
                    println(e)
                }
            }

            if (call.method == "readLogFile") {
                val fileName = call.argument<String>("fileName")
                val logContent = readLogFile(fileName)
                result.success(logContent)
            }
            if (call.method == "createLogFile") {
                val dateFormat = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
                val currentDate = dateFormat.format(Date())
                val logFile = File(externalCacheDir, "app_log_$currentDate.txt")
            }
            if (call.method == "deleteLogFile") {
                val fileName = call.argument<String>("fileName")
                val success = deleteLogFile(fileName.toString())
                result.success(success)
            }
            if (call.method == "clearFileContent") {
                val filePath = call.argument<String>("fileName")
                if (filePath != null) {
                    clearFileContent(filePath)
                    result.success(null)
                } else {
                    result.error("INVALID_ARGUapiMENT", "File path is null", null)
                }
            }
            if (call.method == "getLogFiles") {
                val fileList = getLogFiles()
                result.success(fileList)
            }



            if (call.method == "SCANNER_TRIG") {


                try {
                    HttpUtilContainer.executor.execute(
                        Runnable {
                            try {
                                println("广播开启扫描");
                                sendBroadcast_TRIG(4)
                                println("发送广播开启扫描");
                            } catch (e: Exception) {
                                println("SCANNER_TRIG error ${e.message}")
                            }
                        }
                    );

                } catch (e: Exception) {
                    println(e)
                }
            }


            if (call.method == "SCANNER_RESULT") {
//                println("SCAN_BARCODE 注册广播接收器");
//                val intent = Intent("ACTION_BAR_SCANCFG")
//                intent.putExtra("EXTRA_SCAN_MODE", 3)
//                intent.putExtra("EXTRA_SCAN_AUTOENT", 1)
//                sendBroadcast(intent)
//                isReceiverSet = true;
//                registerReceiver(receiver, IntentFilter("nlscan.action.SCANNER_RESULT"))
            }

            if (call.method == "REMOVE_RESULT") {
                println("SCAN_BARCODE 注销广播接收器");
//                if(isReceiverSet) {
//                    try {
//                        unregisterReceiver(receiver)
//                    } catch (e: Exception) {
//                        println("REMOVE_RESULT error")
//                    }
//                    isReceiverSet = false;
//                }
                result.success(true)
            }

            if (call.method == "getConnection") {
                var getConnectionback = InitService.getInstance().getConnection();
                val json: String = gson.toJson(getConnectionback)
                result.success(json)
            }

            if (call.method == "startPolling") {
                try {
                    HttpUtilContainer.executor.execute(
                        Runnable {
                            try {
                                var back = instance.startPolling();
                                val json: String = gson.toJson(back)
                                result.success(json)
                            } catch (e: Exception) {
                                println("startPolling error ${e.message}")
                            }
                        }
                    );
                } catch (e: Exception) {
                    print("Failed to invoke method: '${e.message}'.");
                    result.success(false)
                }
            }


            if (call.method == "getPolling") {
                MethodChannel(
                    flutterEngine.dartExecutor.binaryMessenger,
                    CHANNEL_data
                ).invokeMethod("monitorData", JSON.toJSONString(MonitorData.Instance().getValue()));
            }

            if (call.method == "getDeviceTypeEnum") {
                println("getDeviceTypeEnum ---------------------------------  ${SystemInfo.Instance().deviceTypeEnum}")
                if (SystemInfo.Instance().deviceTypeEnum != null) {
                    result.success(SystemInfo.Instance().deviceTypeEnum.code)
                } else {
                    result.error("0", "getDeviceTypeEnum error", {})
                }
            }

            if (call.method == "getParametersPageInfo") {
                result.success(JSON.toJSONString(InstallService.getInstance().value))
            }

            if (call.method == "setParametersPageInfo") {
                val networkAddress = call.argument<Int?>("networkAddress")
                val deviceAddress = call.argument<Int?>("deviceAddress")
                val indoorNum = call.argument<Int?>("indoorNum")
                val indoorVipAddress = call.argument<Int?>("indoorVipAddress")
                val connectionSettings = call.argument<Int?>("connectionSettings")

                var setRunMode: LinkSettingEnum? = null
                if (connectionSettings != null) {
                    when (connectionSettings) {
                        0 -> setRunMode = LinkSettingEnum.V8_PQ
                        1 -> setRunMode = LinkSettingEnum.V6
                        2 -> setRunMode = LinkSettingEnum.V8_M1M2_Multi
                        3 -> setRunMode = LinkSettingEnum.V8_M1M2_Single
                        else -> setRunMode = null
                    }
                }

                println("networkAddress ${networkAddress}")
                println("deviceAddress ${deviceAddress}")
                println("indoorNum ${indoorNum}")
                println("indoorVipAddress ${indoorVipAddress}")
                println("setRunMode ${setRunMode}")
                var setParam = InstallService.getInstance().setParam(
                    networkAddress,
                    deviceAddress,
                    indoorNum,
                    indoorVipAddress,
                    setRunMode
                );
                val json: String = gson.toJson(setParam)
                result.success(json);
            }

            if (call.method == "clearIndoorAddress") {
                result.success(InstallService.getInstance().clearIndoorAddress().data);
            }

            if (call.method == "indoorAutoSearchAddress") {
                result.success(InstallService.getInstance().indoorAutoSearchAddress().data);
            }


            if (call.method == "stopPolling") {
                try {
                    HttpUtilContainer.executor.execute(
                        Runnable {
                            try {
                                var back = instance.stopPolling();
                                val json: String = gson.toJson(back)
                                result.success(json)
                                println("stopPolling ---------------------------------  ")
                            } catch (e: Exception) {
                                println("startPolling error ${e.message}")
                            }
                        }
                    );

                } catch (e: Exception) {
                    println(e)
                }
            }

            if (call.method == "ProtocolHandlerStop") {
                try {
                    HttpUtilContainer.executor.execute(
                        Runnable {
                            try {
                                var back = ProtocolHandler.Instance().stop();
                                val json: String = gson.toJson(back)
                                result.success(json)
                                println("ProtocolHandlerStop ---------------------------------  ${ProtocolHandler.Instance().isRetry}")
                            } catch (e: Exception) {
                                println("startPolling error ${e.message}")
                            }
                        }
                    );

                } catch (e: Exception) {
                    println(e)
                }
            }


            if (call.method == "unLockgetData") {
                try {
                    val unLockgetDataisall: Boolean? = call.argument<Boolean>("isall")
                    val unLockgetDatasn: String? = call.argument<String>("sn")
                    val unLockgetDatareport: Int? = call.argument<Int>("report")
                    val unLockgetDataresult: Int? = call.argument<Int>("result")
                    val unLockgetDatapageindex: Int? = call.argument<Int>("pageindex")
                    var check = UnlockLog();
                    if (unLockgetDataisall != true) {
                        if (unLockgetDatasn != null) check.sn = unLockgetDatasn; //是否上报
                        if (unLockgetDatareport != null) check.report = unLockgetDatareport; //是否上报
                        if (unLockgetDataresult != null) check.result = unLockgetDataresult; //是否成功
                    }
                    println("unLockgetData ---------------------------------  ${check}");
                    var unLockback =
                        DeviceUnLockService.getInstance().getData(check, unLockgetDatapageindex);

                    val json: String = gson.toJson(unLockback)
                    result.success(json);
                    println("unLockgetData ---------------------------------  ${unLockback.data}");
                } catch (e: Exception) {
                    println(e)
                    val js = JSONObject()
                    js.put("errorCode", 1000);
                    js.put("data", intArrayOf());
                    result.success(js)
                }
            }


            if (call.method == "unLock") {
                try {
                    val sn: String = call.argument<String>("sn").toString()
                    val machineType: String = call.argument<String>("machineType").toString()
                    var unLockback = DeviceUnLockService.getInstance().unLock(sn, machineType);

                    val json: String = gson.toJson(unLockback)
                    result.success(json);
                } catch (e: Exception) {
                    println(e)
                }
            }

            if (call.method == "updateReport") {
                try {
                    val id: Int? = call.argument<Int>("id")
                    var updateReport = DeviceUnLockService.getInstance().updateReport(id);
                    result.success(updateReport.data);
                } catch (e: Exception) {
                    println(e)
                }
            }

            if (call.method == "controlSet") {
                val addressList: List<Int>? = call.argument<List<Int>>("addressList");
                val runMode: Int? = call.argument<Int>("runMode")
                val fanSpeed: Int? = call.argument<Int>("fanSpeed")
                val onOff: Int? = call.argument<Int>("onOff")
                val tempValue: Double? = call.argument<Double>("tempValue")

                var setRunMode: RunModeSelectEnum? = null
                when (runMode) {
                    7 -> setRunMode = RunModeSelectEnum.RunMode_7
                    2 -> setRunMode = RunModeSelectEnum.RunMode_2
                    6 -> setRunMode = RunModeSelectEnum.RunMode_6
                    3 -> setRunMode = RunModeSelectEnum.RunMode_3
                    1 -> setRunMode = RunModeSelectEnum.RunMode_1
                    else -> setRunMode = null
                }

                var setFanSpeed: FanSpeedSelectEnum? = null
                when (fanSpeed) {
                    1 -> setFanSpeed = FanSpeedSelectEnum.FanSpeed_1
                    2 -> setFanSpeed = FanSpeedSelectEnum.FanSpeed_2
                    3 -> setFanSpeed = FanSpeedSelectEnum.FanSpeed_3
                    4 -> setFanSpeed = FanSpeedSelectEnum.FanSpeed_4
                    5 -> setFanSpeed = FanSpeedSelectEnum.FanSpeed_5
                    6 -> setFanSpeed = FanSpeedSelectEnum.FanSpeed_6
                    7 -> setFanSpeed = FanSpeedSelectEnum.FanSpeed_7
                    8 -> setFanSpeed = FanSpeedSelectEnum.FanSpeed_8

                    else -> setFanSpeed = null
                }

                var setOnOff: OnOffSelectEnum? = null
                when (onOff) {
                    0 -> setOnOff = OnOffSelectEnum.OFF
                    1 -> setOnOff = OnOffSelectEnum.ON
                    else -> setOnOff = null
                }
                var back = controlService.controlSet(
                    addressList, setOnOff,
                    setRunMode, setFanSpeed, tempValue
                );
                result.success(back.data)
            }

            if (call.method == "getcodeParameters") {
                val type: String = call.argument<String>("type").toString()
                val parameters = OduSalesBoardReplaceParameters(
                    oduHorses = 2.5,
                    productSerial = 1,
                    electricChassisHeating = 1,
                    technicalBarriers = 0,
                    parallelType = 0,
                    compressBrand = 1,
                    multipleWaterSources = 1,
                    bigVrf = 0,
                    electronicLock = 1,
                    compressSelect = 0,
                    compressType = 0,
                    airOutletWay = 0,
                    powerType = 2,
                    refrigerantType = 1,
                    derivedSeries = 4,
                    electricControlBoxHeating = 1,
                    packageOptions = 3,
                    fanMotorType = 0,
                    refrigerationCycleSetting = 0,
                    myhomeConnectSetting = 1
                )

                result.success(JSON.toJSONString(parameters))
            }

            if (call.method == "unLockLineControl") {
                val command: String = call.argument<String>("command").toString()
                val addressList: List<Int>? = call.argument<List<Int>>("addressList");
                println("unLockLineControl addressList: $addressList");
                if (addressList != null) {
                    if (addressList.isNotEmpty()) {
                        if (command == "unLockOpenOrClose") {
                            var back = controlService.unLockOpenOrClose(addressList);
                            println("unLockOpenOrClose back: ${back.data}");
                            result.success(back.data)
                        }
                        if (command == "unLockLineControl") {
                            var back = controlService.unLockLineControl(addressList);
                            println("unLockLineControl back: ${back.data}");
                            result.success(back.data)
                        }
                        if (command == "unLockRemoteControl") {
                            var back = controlService.unLockRemoteControl(addressList);
                            println("unLockRemoteControl back: ${back.data}");
                            result.success(back.data)
                        }
                        if (command == "unlockmode") {
                            var back = controlService.unLockRunMode(addressList);
                            println("unLockRemoteControl back: ${back.data}");
                            result.success(back.data)
                        }
                    } else {
                        result.success(false)
                    }
                }
            }

            if (call.method == "getuserRolelist") {
                HttpUtilContainer.executor.execute(
                    Runnable {
                        var back = HttpUtilContainer.getUserLoginHandler()
                            .getUserRoleList();


                        val json: String = gson.toJson(back)
                        result.success(json)
                    }
                );
            }

            if (call.method == "login") {
                val username: String = call.argument<String>("username").toString()
                val passwoed: String = call.argument<String>("passwoed").toString()

                val sit: Boolean? = call.argument<Boolean>("issit")
                val iscss: Boolean? = call.argument<Boolean>("iscss")
                println("username: $username")
                println("passwoed: $passwoed")
                println("issit: $sit")
                println("iscss: $iscss")
                HttpUtilContainer.executor.execute(
                    Runnable {
                        if (username != "") {

                            if(iscss == true) {
                                var env = Environment.SIT;
                                if (!sit!!) {
                                    env = Environment.PROD;
                                }
                                println("loginByPhone -- username: $username")
                                println("loginByPhone -- passwoed: $passwoed")
                                var back = HttpUtilContainer.getUserLoginHandler()
                                    .loginByPhone("${username}", "${passwoed}", env);
                                UserDTO.instance().username = username;
                                println("login:" + back)
                                result.success(back)
                            } else {
                                println("login --  username: $username")
                                println("login -- passwoed: $passwoed")
                                var back = HttpUtilContainer.getUserLoginHandler()
                                    .login("${username}", "${passwoed}");
                                UserDTO.instance().username = username;
                                println("login:" + back)
                                result.success(back)
                            }
                        } else {
                            result.error("500", "", {})
                        }
                    }
                );
            }

            if (call.method == "logout") {
                HttpUtilContainer.executor.execute(
                    Runnable {
                        var back = HttpUtilContainer.getUserLoginHandler().logout();
                        result.success(back)
                    }
                );
            }

            if (call.method == "getUserMessage") {
                HttpUtilContainer.executor.execute(
                    Runnable {
                        var back = HttpUtilContainer.getUserLoginHandler().getUserMessage();

                        val json: String = gson.toJson(back)
                        result.success(json)
                    }
                );
            }



            if (call.method == "setlocation") {
                val username: String = call.argument<String>("username").toString()
                val location: String = call.argument<String>("location").toString()
                UserDTO.instance().username = username;
                UserDTO.instance().location = location;
//                UserDTO.instance().phone = phone;

                print("getlocation setlocation : $username   $location")
                result.success(true)
            }

            /**
             * 系统分析-制冷能力分析-系统搜索
             */
            if (call.method == "getSearchBySn") {
                val sn: String = call.argument<String>("sn").toString()
                HttpUtilContainer.executor.execute(
                    Runnable {
                        println("getSearchBySn:" + sn)
                        var back =
                            HttpUtilContainer.getSystemDataHandler().getSearchBySn(sn);
                        println("getSearchBySn:" + back)

                        result.success(back)
                    }
                );
            }

            /**
             * 系统分析-制冷能力分析-系统详情
             */
            if (call.method == "getDetailBySn") {
                val sysId: String = call.argument<String>("sysId").toString()
                HttpUtilContainer.executor.execute(
                    Runnable {
                        var back =
                            HttpUtilContainer.getSystemDataHandler().getDetailBySn(sysId);
                        println("getDetailBySn:" + back)

                        result.success(back)
                    }
                );
            }


            /**
             * 系统分析-制冷能力分析-系统搜索-历史搜索系统
             */
            if (call.method == "getSearchHistories") {
                /**
                 * searchType : sysDetail
                 */
                val searchType: String = call.argument<String>("searchType").toString()
                HttpUtilContainer.executor.execute(
                    Runnable {
                        var back =
                            HttpUtilContainer.getSystemDataHandler()
                                .getSearchHistories("sysDetail");
                        println("getSearchHistories:" + back)

                        result.success(back)
                    }
                );
            }


            if (call.method == "getRealTimeData") {
                val sysId: String = call.argument<String>("sysId").toString()
                val deviceType: String = call.argument<String>("deviceType").toString()
                HttpUtilContainer.executor.execute(
                    Runnable {
                        // 创建一个 JSON 对象
                        val js = JSONObject()
                        js.put("sysId", sysId);
                        js.put("group", "realTime");
                        js.put("deviceType", deviceType);
                        var back =
                            HttpUtilContainer.getSystemDataHandler().getRealTimeData(js);
                        result.success(back)
                    }
                );
            }

            if (call.method == "getHistoryData") {
                val nid: String = call.argument<String>("nid").toString()
                HttpUtilContainer.executor.execute(
                    Runnable {
                        val currentDateTime = LocalDateTime.now()
                        val formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")
                        val endtime = currentDateTime.format(formatter)


                        val sixHoursAgoDateTime = currentDateTime.minus(6, ChronoUnit.HOURS)
                        val sixformatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")
                        val startime = sixHoursAgoDateTime.format(sixformatter)

                        // 创建一个 JSON 对象
                        val js = JSONObject()
                        js.put("nid", nid);
                        js.put("group", "legend");
                        js.put("startTime", startime);
                        js.put("endTime", endtime);
                        var back =
                            HttpUtilContainer.getSystemDataHandler().getHistoryData(js);
                        result.success(back)
                    }
                );
            }

            if (call.method == "getWeather") {

                val projectCode: String = call.argument<String>("projectCode").toString()
                HttpUtilContainer.executor.execute(
                    Runnable {
                        var back =
                            HttpUtilContainer.getSystemDataHandler().getWeather(projectCode);
                        println("getWeather:" + back)
                        result.success(back)
                    }
                );
            }




            if (call.method == "layout") {
                HttpUtilContainer.executor.shutdown();
            }
        }


        var SalesBoardReplace = SalesBoardReplaceService.getInstance();
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL_afterSalesReplacement
        ).setMethodCallHandler {
            // This method is invoked on the main thread.
                call, result ->
            if (call.method == "getOduSalesBoardReplaceParameters") {
                val s1 = call.argument<String>("p1")
                val s2 = call.argument<String>("p2")
                val trimmedList = listOf(s1, s2)
                var getOduSalesBoardReplaceParameters_back =
                    SalesBoardReplace.getOduSalesBoardReplaceParameters(trimmedList);
                result.success(JSON.toJSONString(getOduSalesBoardReplaceParameters_back))
            }

            if (call.method == "getIduSalesBoardReplaceParameters") {
                val s1 = call.argument<String>("p1")
                val s2 = call.argument<String>("p2")
                val trimmedList = listOf(s1, s2)
                var getIduSalesBoardReplaceParameters_back =
                    SalesBoardReplace.getIduSalesBoardReplaceParameters(trimmedList);
                result.success(JSON.toJSONString(getIduSalesBoardReplaceParameters_back))
            }

            if (call.method == "writeOduParameters") {
                val s1 = call.argument<String>("p1")
                val s2 = call.argument<String>("p2")
                val sn = call.argument<String>("sn")

                HttpUtilContainer.executor.execute(
                    Runnable {
                        val systemAddress = call.argument<Int>("systemAddress")
                        val oduAddress = call.argument<Int>("oduAddress")
                        println("systemAddress: $systemAddress")
                        println("oduAddress: $oduAddress")
                        val trimmedList = listOf(s1, s2)
                        var writeOduParameters_back = SalesBoardReplace.writeOduParameters(
                            sn,
                            systemAddress,
                            oduAddress,
                            trimmedList
                        );
                        val json: String = gson.toJson(writeOduParameters_back)
                        result.success(json)
                    }
                );
            }

            if (call.method == "writeIduParameters") {
                val s1 = call.argument<String>("p1")
                val s2 = call.argument<String>("p2")

                val sn = call.argument<String>("sn")

                val iduAddress = call.argument<Int>("iduAddress")
                val trimmedList = listOf(s1, s2)
                HttpUtilContainer.executor.execute(
                    Runnable {
                        var writeIduParameters_back =
                            SalesBoardReplace.writeIduParameters(sn, iduAddress, trimmedList);
                        val json: String = gson.toJson(writeIduParameters_back)
                        result.success(json)
                    }
                );
            }
        }


        var WriteSnInstance = WriteSnService.getInstance();
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL_writeSnService
        ).setMethodCallHandler {
            // This method is invoked on the main thread.
                call, result ->
            if (call.method == "writeSn") {
                val sn = call.argument<String>("sn")
                var writeSn_back = WriteSnInstance.writeSn(sn);

                val json: String = gson.toJson(writeSn_back)
                result.success(json)
            }

            if (call.method == "unblock") {
                val sn = call.argument<String>("sn")
                var writeSn_back = WriteSnInstance.unblock(sn);

                val json: String = gson.toJson(writeSn_back)
                result.success(json)
            }
        }

        var PumpDetection = PumpDetectionService.getInstance();
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL_waterPumpInspec
        ).setMethodCallHandler {
            // This method is invoked on the main thread.
                call, result ->
            if (call.method == "PumpDetectioncheck") {
                HttpUtilContainer.executor.execute(
                    Runnable {
                        try {
                            val indoorAddressList = call.argument<List<Int>>("indoorAddressList")
                            var PumpDetectioncheck = PumpDetection.check(indoorAddressList);
                            result.success(PumpDetectioncheck.data)

                        } catch (e: Exception) {
                            val js = JSONObject()
                            js.put("errorCode", 1000);
                            js.put("data", intArrayOf());
                            result.success(js)
                        }
                    }
                );

            }

            if (call.method == "setStop") {
                var PumpDetectioncheck = PumpDetection.setStop();
                result.success(true)
            }

            if (call.method == "getResult") {
                HttpUtilContainer.executor.execute(
                    Runnable {
                        try {
                            val uuid = call.argument<String>("uuid")
                            var PumpDetectiongetResult = PumpDetection.getResult(uuid);
                            val json: String = gson.toJson(PumpDetectiongetResult.data)
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


        var Electronic = ElectronicService.getInstance();
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL_ElectronicService
        ).setMethodCallHandler {
            // This method is invoked on the main thread.
                call, result ->
            if (call.method == "getExv") {
                HttpUtilContainer.executor.execute(
                    Runnable {
                        try {
                            var ElectronicgetExv = Electronic.getExv();
                            val json: String = gson.toJson(ElectronicgetExv.data)
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

            if (call.method == "controlExv") {

                HttpUtilContainer.executor.execute(
                    Runnable {
                        try {
                            val exvSteps = call.argument<Int>("exvSteps")
                            val isMax = call.argument<Boolean>("isMax")
                            var ElectroniccontrolExv = Electronic.controlExv(ExvTypeEnum.getEnumByV8Type(exvSteps),isMax);
                            val json: String = gson.toJson(ElectroniccontrolExv.data)
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


            if (call.method == "reset") {

                HttpUtilContainer.executor.execute(
                    Runnable {
                        try {
                            var ElectroniccontrolExv = Electronic.reset();
                            val json: String = gson.toJson(ElectroniccontrolExv.data)
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

            if (call.method == "gteMaxStep") {


                HttpUtilContainer.executor.execute(
                    Runnable {
                        try {
                            var ElectroniccontrolExv = Electronic.gteMaxStep();
                            val json: String = gson.toJson(ElectroniccontrolExv)
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

            if (call.method == "fallBack") {
//                var ElectroniccontrolExv = Electronic.fallBack();
//                val json: String = gson.toJson(ElectroniccontrolExv)
                result.success(true)
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL_getDeviceFaultHandler
        ).setMethodCallHandler {
            // This method is invoked on the main thread.
                call, result ->
            if (call.method == "getListByNid") {
                val nid: String = call.argument<String>("nid").toString()
                val currentDateTime = LocalDateTime.now()
                val formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd")
                val endtime = currentDateTime.format(formatter)

                val hours48AgoDateTime = currentDateTime.minus(48, ChronoUnit.HOURS)
                val startime = hours48AgoDateTime.format(formatter)

                val pageindex = call.argument<Int>("pageindex")
                HttpUtilContainer.executor.execute(
                    Runnable {
                        try {
                            var back = HttpUtilContainer.getDeviceFaultHandler().getListByNid(
                                "", "", nid,
                                startime, endtime, "", "", "",
                                "", "", "", true, null,
                                pageindex, 10
                            );
                            println("getListByNid:" + back)
                            result.success(back)

                        } catch (e: Exception) {
                            val js = JSONObject()
                            js.put("errorCode", 1000);
                            js.put("data", intArrayOf());
                            result.success(js)
                        }
                    }
                );
            }


            if (call.method == "detail") {
                val nid: String = call.argument<String>("nid").toString()
                val errorCode: String = call.argument<String>("errorCode").toString()
                val id: String = call.argument<String>("id").toString()

                HttpUtilContainer.executor.execute(
                    Runnable {
                        try {
                            var back = HttpUtilContainer.getDeviceFaultHandler().detail(
                                "vrf/vrf_0000CC311178CCM273A23B100288S680/outdoor/129",
                                errorCode, id
                            );
                            println("detail:" + back)
                            result.success(back)
                        } catch (e: Exception) {
                            val js = JSONObject()
                            js.put("errorCode", 1000);
                            js.put("data", intArrayOf());
                            result.success(js)
                        }
                    }
                );
            }

            if (call.method == "getDetailByCode") {
                val errorCode: String = call.argument<String>("errorCode").toString()
                val deviceversion: String = call.argument<String>("deviceversion").toString()

                HttpUtilContainer.executor.execute(
                    Runnable {
                        try {
                            var back = HttpUtilContainer.getFaultManagementHandler()
                                .getDetailByCode(errorCode, deviceversion);
                            println("detail:" + back)
                            result.success(back)
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

        var ProtocolCheck = ProtocolCheckService.getInstance();
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL_ProtocolCheckService
        ).setMethodCallHandler {
            // This method is invoked on the main thread.
                call, result ->
            if (call.method == "check") {
                HttpUtilContainer.executor.execute(
                    Runnable {
                        var back = ProtocolCheck.check();
                        val json: String = gson.toJson(back)
                        result.success(json)
                    }
                );

            }

            if (call.method == "setStop") {
                var setStop = ProtocolCheck.setStop();
                val json: String = gson.toJson(setStop)
                result.success(json)
            }


        }


        getTopologyHandler(
            MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                CHANNEL_getTopologyHandler
            )
        )

        getSystemDataHandlerHandler(
            MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                CHANNEL_getSystemDataHandler
            )
        )


        getProjectHandler(
            MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                CHANNEL_getProjectHandler
            )
        )

        ibutler(MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_ibutler))

        CommunicationDetection(MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "samples.flutter.dev/CommunicationDetection"))
        BackClip(MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "samples.flutter.dev/BackClip"))
        cloundFunctionParamsSetting(MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "samples.flutter.dev/cloundFunctionParamsSetting"))

        topology(MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_topology))
        SprinklerSetting(MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_SprinklerSetting))


        functionParamHandler(
            MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                CHANNEL_functionParamHandler
            )
        )



        tryRunHandler(
            MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                CHANNEL_tryRunHandler
            )
        )


        AntiTamperingServiceHandler(
            MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                CHANNEL_AntiTamperingServiceHandler
            )
        )


        waterpumbBasicHandler(
            flutterEngine.dartExecutor.binaryMessenger,
            MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                CHANNEL_waterpumbBasicHandler
            )
        )


        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL_getDeviceUnlockHandler
        ).setMethodCallHandler {
            // This method is invoked on the main thread.
                call, result ->
            // 定位系统搜索--支持项目编码、项目名称搜索
            if (call.method == "insertOperationLog") {
                val executionResult = call.argument<String>("executionResult") // "成功" "失败"
                val agreementType = call.argument<String>("agreementType")
                val number = call.argument<String>("number") // 匹数
                val phone = call.argument<String>("phone") // 操作人电话(从用户信息获取，不需要校验格式)
                val uid = call.argument<String>("uid")
                val deviceSn = call.argument<String>("deviceSn")
                val operation = call.argument<String>("operation")
                val location = call.argument<String>("location")

                val functionType = call.argument<String?>("functionType")
                val operationDevice = call.argument<String?>("operationDevice")
                val nowSn = call.argument<String?>("nowSn")
                val modelDetail = call.argument<String?>("modelDetail")

                println("operation: ${operation}");

                HttpUtilContainer.executor.execute(
                    Runnable {   // 创建一个 JSON 对象
                        val js = JSONObject()

                        js.put("deviceSn", deviceSn)
                        if (modelDetail != null) js.put("modelDetail", JSONArray(modelDetail))

                        if (functionType == null) js.put("functionType", "electronicUnlock")
                        if (functionType != null) js.put("functionType", functionType)

                        if (operationDevice == null) js.put("operationDevice", "localUnlock")
                        if (operationDevice != null) js.put("operationDevice", operationDevice)

                        js.put("executionResult", executionResult)
                        js.put("agreementType", agreementType)
                        js.put("number", number)
                        js.put("phone", phone)
                        js.put("uid", uid)
                        if (operation != null && operation != "") {
                            try {
                                js.put("operation", JSONObject(operation))
                            } catch (e: Exception) {
                                val op = JSONObject()
                                op.put("op", operation)
                                js.put("operation", op)
                            }
                        }
                        if (nowSn == null) js.put("nowDeviceSn", deviceSn)
                        if (nowSn != null) js.put("nowDeviceSn", nowSn)
                        js.put("location", location)
                        try {
                            var back = MideaAppHandler().insertOperationLog(js);
                            val json: String = gson.toJson(back)
                            result.success(json)
                        } catch (e: Exception) {

                            result.error("0", "insertOperationLog error", {});
                        }
                    }
                );
            }

        }


        var Refrigerant = RefrigerantService.getInstance();
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL_RefrigerantService
        ).setMethodCallHandler { call, result ->
            when (call.method) {

                // 判断是否能使用冷媒充注
                "isInto" -> {
                    HttpUtilContainer.executor.execute {
                        try {
                            val isInto_back = Refrigerant.isInto()
                            val json: String = gson.toJson(isInto_back)
                            result.success(json)
                        } catch (e: Exception) {
                            val js = JSONObject()
                            js.put("errorCode", 1000)
                            js.put("data", intArrayOf())
                            result.success(js)
                        }
                    }
                }

                // 判断当前协议
                "getProtocol" -> {
                    HttpUtilContainer.executor.execute {
                        try {
                            val back = Refrigerant.getProtocol()
                            val json: String = gson.toJson(back)
                            result.success(json)
                        } catch (e: Exception) {
                            val js = JSONObject()
                            js.put("errorCode", 1000)
                            js.put("data", intArrayOf())
                            result.success(js)
                        }
                    }
                }

                // 是否满足进入冷媒模块
                "isTrueCondition" -> {
                    HttpUtilContainer.executor.execute {
                        try {
                            val back = Refrigerant.isTrueCondition()
                            val json: String = gson.toJson(back)
                            result.success(json)
                        } catch (e: Exception) {
                            val js = JSONObject()
                            js.put("errorCode", 1000)
                            js.put("data", intArrayOf())
                            result.success(js)
                        }
                    }
                }

                // 判断机器是否处于充注中/诊断中
                "isFilling" -> {
                    HttpUtilContainer.executor.execute {
                        try {
                            val back = Refrigerant.isFilling()
                            val json: String = gson.toJson(back)
                            result.success(json)
                        } catch (e: Exception) {
                            val js = JSONObject()
                            js.put("errorCode", 1000)
                            js.put("data", intArrayOf())
                            result.success(js)
                        }
                    }
                }

                // 参数查看
                "getParam" -> {
                    HttpUtilContainer.executor.execute {
                        try {
                            val back = Refrigerant.getParam()
                            val json: String = gson.toJson(back)
                            result.success(json)
                        } catch (e: Exception) {
                            val js = JSONObject()
                            js.put("errorCode", 1000)
                            js.put("data", intArrayOf())
                            result.success(js)
                        }
                    }
                }

                // 少冷媒时，判断外机匹数之和>=18hp || 主外机程序主版本大于24
                "lessRefrigerantCondition" -> {
                    HttpUtilContainer.executor.execute {
                        try {
                            val back = Refrigerant.lessRefrigerantCondition()
                            val json: String = gson.toJson(back)
                            result.success(json)
                        } catch (e: Exception) {
                            val js = JSONObject()
                            js.put("errorCode", 1000)
                            js.put("data", intArrayOf())
                            result.success(js)
                        }
                    }
                }

                // 开启冷媒充注
                "openRefrigerant" -> {
                    HttpUtilContainer.executor.execute {
                        try {
                            val back = Refrigerant.openRefrigerant()
                            val json: String = gson.toJson(back)
                            result.success(json)
                        } catch (e: Exception) {
                            val js = JSONObject()
                            js.put("errorCode", 1000)
                            js.put("data", intArrayOf())
                            result.success(js)
                        }
                    }
                }

                // 获取冷媒充注结果
                "refrigerantResult" -> {
                    HttpUtilContainer.executor.execute {
                        try {
                            val back = Refrigerant.refrigerantResult()
                            val json: String = gson.toJson(back)
                            result.success(json)
                        } catch (e: Exception) {
                            val js = JSONObject()
                            js.put("errorCode", 1000)
                            js.put("data", intArrayOf())
                            result.success(js)
                        }
                    }
                }

                // 开启冷媒诊断
                "openCheck" -> {
                    HttpUtilContainer.executor.execute {
                        try {
                            val back = Refrigerant.openCheck()
                            val json: String = gson.toJson(back)
                            result.success(json)
                        } catch (e: Exception) {
                            val js = JSONObject()
                            js.put("errorCode", 1000)
                            js.put("data", intArrayOf())
                            result.success(js)
                        }
                    }
                }

                // 关闭冷媒诊断
                "closeCheck" -> {
                    HttpUtilContainer.executor.execute {
                        try {
                            val back = Refrigerant.closeCheck()
                            val json: String = gson.toJson(back)
                            result.success(json)
                        } catch (e: Exception) {
                            val js = JSONObject()
                            js.put("errorCode", 1000)
                            js.put("data", intArrayOf())
                            result.success(js)
                        }
                    }
                }

                // 查询冷媒诊断结果
                "checkResult" -> {
                    HttpUtilContainer.executor.execute {
                        try {
                            val back = Refrigerant.checkResult()
                            val json: String = gson.toJson(back)
                            result.success(json)
                        } catch (e: Exception) {
                            val js = JSONObject()
                            js.put("errorCode", 1000)
                            js.put("data", intArrayOf())
                            result.success(js)
                        }
                    }
                }

                else -> {
                    result.notImplemented()
                }
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL_McuUtil
        ).setMethodCallHandler {
            // This method is invoked on the main thread.
                call, result ->
            if (call.method == "powerOn") {
//                McuUtil.powerOn();
                McuUtil.resetOn();
                result.success(true)
            }
            if (call.method == "powerOff") {
                McuUtil.powerOff();
                result.success(true)
            }
            if (call.method == "downLoadOn") {
                McuUtil.downLoadOn();
                result.success(true)
            }
            if (call.method == "resetOn") {
                McuUtil.resetOn();
                result.success(true)
            }
        }

        var inithttp = false;
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL_init
        ).setMethodCallHandler {
            // This method is invoked on the main thread.
                call, result ->
            if (call.method == "init") {
                println(CHANNEL_init + "_________________init")
                val intent = Intent("ACTION_BAR_SCANCFG")
                intent.putExtra("EXTRA_SCAN_MODE", 3)
                intent.putExtra("EXTRA_SCAN_AUTOENT", 1)
                sendBroadcast(intent)
                isReceiverSet = true;
                var receiver = object : BroadcastReceiver() {
                    override fun onReceive(context: Context?, intent: Intent?) {
                        // 处理扫描结果
                        val SCAN_BARCODE1 = intent?.getStringExtra("SCAN_BARCODE1")
                        println("SCAN_BARCODE1 receiver:" + SCAN_BARCODE1.toString());
                        MethodChannel(
                            flutterEngine.dartExecutor.binaryMessenger,
                            "scan.data"
                        ).invokeMethod("data", SCAN_BARCODE1.toString())
                    }
                }

                var receiverSCANNER_TRIG = object : BroadcastReceiver() {
                    override fun onReceive(context: Context?, intent: Intent?) {
                        val SCANNER_TRIG = intent?.getStringExtra("nlscan.action.SCANNER_TRIG")
                        println("SCANNER_TRIG " + SCANNER_TRIG.toString());
                    }
                }
                CoroutineScope(Dispatchers.IO).launch {
                    // Background thread task
                    // Register receiver on the main thread
                    launch(Dispatchers.Main) {
                        registerReceiver(receiver, IntentFilter("nlscan.action.SCANNER_RESULT"))
                        registerReceiver(
                            receiverSCANNER_TRIG,
                            IntentFilter("nlscan.action.SCANNER_TRIG")
                        )
                    }
                }

                val token: String = call.argument<String>("token").toString()
                val uid: String = call.argument<String>("uid").toString()

                val sit: Boolean? = call.argument<Boolean>("issit")
                println("sit : ${sit}")
                if (!inithttp) {
                    var env = Environment.SIT;
                    if (!sit!!) {
                        env = Environment.PROD;
                    }
                    HttpUtilContainer.init(
                        env, token, uid
                    );
                    inithttp = true;
                }
            }
            result.success(true)

        }
    }
}

private fun listToJsonArray(list: List<String>): JSONArray {
    val jsonArray = JSONArray()
    for (item in list) {
        jsonArray.put(item)
    }
    return jsonArray
}
