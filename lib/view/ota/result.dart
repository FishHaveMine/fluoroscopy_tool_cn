import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/cloud/projectManage/ibutler/ibutler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'publicFunction.dart';

class otaResult extends StatefulWidget {
  var data;
  otaResult({super.key, this.data});

  @override
  State<otaResult> createState() => _copybasepageState();
}

class _copybasepageState extends State<otaResult> {
  int status = -1; // 0:成功   1:部分成功   2:失败
  bool showDetail = false;

  var data = {};
  List detail = [];
  static const _selfplatform =
      MethodChannel('samples.flutter.dev/MbtBasicOtaHandler');

  final otaController _selfController = Get.find();

  String formatTimestamp(int timestamp) {
    if (timestamp == null) {
      return "--";
    }
    // 将时间戳转换为 DateTime 对象
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    // 格式化日期
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  _init() async {
    if (widget.data == null) {
      EasyLoading.show(status: 'loading...');
      var result = await _selfplatform.invokeMethod('getUpgradeDetail',
          <String, dynamic>{"uuid": _selfController.uuid.value});
      var resultdata = jsonDecode(result);
      var _re = jsonDecode(resultdata["date"]);
      print("resultdata: $resultdata");
      data = {
        "ota.result.show1": formatTimestamp(resultdata["upgradeTime"]),
        "ota.result.show2": _re[0]["deviceType"].toString(),
        "ota.result.show3": _re.length.toString(),
        "ota.result.show4": "",
        "ota.result.show5": _re[0]["upgradeVersion"].toString(),
        "ota.result.show6": _re[0]["firmwareVersion"].toString(),
      };
      detail.addAll(_re);
      _setStatus(_re);
      setState(() {
        data;
        detail;
      });
      EasyLoading.dismiss();
    } else {
      data = {
        "ota.result.show1": formatTimestamp(widget.data["upgradeTime"]),
        "ota.result.show2": widget.data["deviceType"].toString(),
        "ota.result.show3": widget.data["upgradeNum"].toString(),
        "ota.result.show4":
            tr("FirmwareUpgradeStatus_${widget.data["upgradeStatus"]}"),
        "ota.result.show5": widget.data["firmwareOperationLogList"][0]
                ["upgradeVersion"]
            .toString(),
        "ota.result.show6": widget.data["firmwareOperationLogList"][0]
                ["firmwareVersion"]
            .toString(),
      };
      _setStatus(widget.data["firmwareOperationLogList"]);
      setState(() {
        data;
        detail.addAll(widget.data["firmwareOperationLogList"]);
      });
    }
  }

  _setStatus(val) {
    print("_setStatus: $val");
    if (val.isNotEmpty) {
      status = val.every((element) => element["upgradeStatus"] == 0)
          ? 0
          : val.every((element) => element["upgradeStatus"] == 1)
              ? 2
              : 1;

      setState(() {
        status;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print("data widget: ${widget.data}");
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _init();
    });
  }

  @override
  void dispose() {
    // 移除滚动监听器
    _scrollController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.chevron_left,
                  color: Colors.black, size: 36)),
          title: const Text(
            'ota.history.title1',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [],
        ),
        body: Container(
          width: 720.w,
          height: 1280.h,
          color: const Color.fromRGBO(244, 244, 244, 1),
          padding: EdgeInsets.fromLTRB(0.w, 1, 0.w, 0.h),
          child: status == -1
              ? null
              : Column(
                  children: [
                    Container(
                      width: 720.w,
                      height: 220,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Image.asset(
                              'public/images/ota/${status == 0 ? "success" : status == 1 ? "warning" : "empty"}.png',
                              width: 114,
                            ),
                          ),
                          Text(
                            "ota.result.status${status + 1}",
                            style: titleText(),
                          ).tr()
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    if (!showDetail)
                      Expanded(
                          child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (String key in data.keys)
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color.fromRGBO(223, 223, 223, 1),
                                        width: 0.5,
                                      ),
                                    )),
                                child: InkWell(
                                  onTap: () {
                                    if (key == "ota.result.show4") {
                                      setState(() {
                                        showDetail = !showDetail;
                                      });
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(key).tr(),
                                      if (key != "ota.result.show4")
                                        Expanded(
                                            child: Text(data[key]!,
                                                    textAlign: TextAlign.right)
                                                .tr()),
                                      if (key == "ota.result.show4")
                                        Row(
                                          children: [
                                            Text(
                                              "showDetail",
                                              style: selectText(
                                                  fw: FontWeight.w400,
                                                  lineheight: 1,
                                                  fSize: 14),
                                            ).tr(),
                                            const Icon(Icons.chevron_right)
                                          ],
                                        )
                                    ],
                                  ),
                                ),
                              )
                          ],
                        ),
                      )),
                    if (showDetail)
                      Expanded(
                          child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color.fromRGBO(223, 223, 223, 1),
                                      width: 0.5,
                                    ),
                                  )),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    showDetail = !showDetail;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.chevron_left),
                                    const Text(
                                            "sendDeviceParameter.errorbutton")
                                        .tr(),
                                  ],
                                ),
                              ),
                            ),
                            for (var el in detail)
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color.fromRGBO(223, 223, 223, 1),
                                        width: 0.5,
                                      ),
                                    )),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(el["address"].toString()).tr(),
                                    Row(
                                      children: [
                                        Text(tr("FirmwareUpgradeStatus_${el["upgradeStatus"]}"))
                                            .tr(),
                                        TooltipOnClick(
                                            msg: "${el["operation"] ?? "--"}")
                                      ],
                                    )
                                  ],
                                ),
                              )
                          ],
                        ),
                      ))
                  ],
                ),
        ));
  }
}
