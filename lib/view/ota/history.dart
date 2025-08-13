import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/ota/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../cloud/device/style.dart';
import 'publicFunction.dart';

class otaHistory extends StatefulWidget {
  otaHistory({super.key});

  @override
  State<otaHistory> createState() => _copybasepageState();
}

class _copybasepageState extends State<otaHistory> {
  static const _selfplatform =
      MethodChannel('samples.flutter.dev/MbtBasicOtaHandler');
  int pageindex = 1;
  List upgrades = [];

  final otaController _selfController = Get.find();
  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        pageindex = pageindex + 1;
        _loadMore();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _loadMore();
    });
  }

  Future<void> _loadMore() async {
    try {
      var result = await _selfplatform.invokeMethod(
          'getFirmwareUpgradeLos', <String, dynamic>{"pageindex": pageindex});
      var data = jsonDecode(result);
      upgrades.addAll(data["data"]);
      setState(() {
        upgrades;
      });
    } catch (e) {}
  }

  @override
  void dispose() {
    // 移除滚动监听器
    _scrollController.dispose();
    super.dispose();
  }

  String formatTimestamp(int timestamp) {
    if (timestamp == null) {
      return "--";
    }
    // 将时间戳转换为 DateTime 对象
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    // 格式化日期
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
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
            'ota.history.title',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [],
        ),
        body: Container(
          width: 720.w,
          height: 1280.h,
          color: const Color.fromRGBO(244, 244, 244, 1),
          padding: EdgeInsets.fromLTRB(0.w, 24.h, 0.w, 0.h),
          child: ListView.builder(
              controller: _scrollController,
              itemCount: upgrades.length,
              itemBuilder: ((context, index) => InkWell(
                    onTap: () {
                      Get.to(() => otaResult(
                            data: upgrades[index],
                          ));
                    },
                    child: Container(
                      width: 720.w,
                      decoration: cardStyleFull(context),
                      margin: EdgeInsets.fromLTRB(16, 0, 16, 24.h),
                      padding: EdgeInsets.all(26.w),
                      child: Column(
                        children: [
                          for (int i = 1; i < 6; i++)
                            Row(
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    "ota.history.show$i",
                                    style: normalText(),
                                  ).tr(),
                                ),
                                if (i == 1)
                                  Expanded(
                                    child: Text(
                                      formatTimestamp(
                                          upgrades[index]["upgradeTime"]),
                                      style: normalTextBlack(),
                                    ),
                                  ),
                                if (i == 2)
                                  Expanded(
                                    child: Text(
                                      "${upgrades[index]["upgradeNum"] ?? "--"}",
                                      style: normalTextBlack(),
                                    ),
                                  ),
                                if (i == 3)
                                  Expanded(
                                    child: Text(
                                      "${upgrades[index]["deviceType"] ?? "--"}",
                                      style: normalTextBlack(),
                                    ).tr(),
                                  ),
                                if (i == 4)
                                  Expanded(
                                    child: Text(
                                      "${upgrades[index]["firmwareOperationLogList"][0]["upgradeVersion"] ?? "--"}",
                                      style: normalTextBlack(),
                                    ),
                                  ),
                                if (i == 5)
                                  Expanded(
                                    child: Text(
                                      "FirmwareUpgradeStatus_${upgrades[index]["upgradeStatus"]}",
                                      style: normalTextBlack(),
                                    ).tr(),
                                  ),
                              ],
                            ),
                          Row(children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                "ota.list.updata",
                                style: normalText(),
                              ).tr(),
                            ),
                            Expanded(
                              child: Text(
                                "ota.list.updata${upgrades[index]["firmwareOperationLogList"][0]["upgradeTypeEnum"]}",
                                style: normalTextBlack(),
                              ).tr(),
                            ),
                          ])
                        ],
                      ),
                    ),
                  ))),
        ));
  }
}
