import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../selfpublicFunction.dart';
import '../step2/children/showingCheckResult.dart';

class historyListpage extends StatefulWidget {
  var connectedSystem;
  historyListpage({super.key, required this.connectedSystem});

  @override
  State<historyListpage> createState() => _historyListpageState();
}

class _historyListpageState extends State<historyListpage> {
  static const platform =
      MethodChannel('samples.flutter.dev/getSystemDataHandler');
  List history = [];
  int pageIndex = 1;
  bool isLoading = false;
  int totalCount = 0;
  systemAnalysisController _systemController = Get.find();
  init() async {
    if (history.length < totalCount || history.isEmpty) {
      try {
        var getIndoorTopologyData =
            await platform.invokeMethod('queryCheckRecord', <String, dynamic>{
          "pageIndex": pageIndex,
          "sysId": _systemController.selectedSystem.value["sysId"],
          "mode":
              _systemController.analysisType.value == 1 ? "cooling" : "heating"
        });
        var data = jsonDecode(getIndoorTopologyData);
        if (data["success"] && data['data'] != null) {
          setState(() {
            totalCount = data['totalCount'];
            history = [...history, ...data['data']];
          });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  toDetail(el) async {
    print(el);
    try {
      Get.to(() => showingCheckResult(
            id: el["id"],
            showingType: 1,
          ));
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    init();
  }

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
            'systemCapabilityAnalysisPage.systemDetail.action',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [],
        ),
        body: Container(
          width: 720.w,
          height: 1280.h,
          color: const Color.fromRGBO(244, 244, 244, 1),
          padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 22.h),
          child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!isLoading &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  // 滚动到底部，触发加载更多数据的操作
                  setState(() {
                    isLoading = true;
                  });
                  pageIndex++;
                  init();
                }
                return true;
              },
              child: ListView.builder(
                  itemCount: history.length,
                  itemBuilder: ((context, index) {
                    return InkWell(
                      onTap: () {
                        toDetail(history[index]);
                      },
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  history[index]["systemName"],
                                  style: normalTextBlack(
                                      lineheight: 1,
                                      fSize: 16,
                                      fw: FontWeight.w700),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  padding:
                                      const EdgeInsets.fromLTRB(6, 4, 6, 4),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: history[index]["status"] == 0
                                              ? const Color.fromRGBO(
                                                  255, 161, 66, 1)
                                              : const Color.fromRGBO(
                                                  184, 192, 210, 1)),
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.white),
                                  child: Text(
                                    history[index]["status"] == 0
                                        ? "checking"
                                        : "finish",
                                    style: TextStyle(
                                        fontSize: 14,
                                        height: 1,
                                        color: history[index]["status"] == 0
                                            ? const Color.fromRGBO(
                                                255, 161, 66, 1)
                                            : const Color.fromRGBO(
                                                184, 192, 210, 1)),
                                  ).tr(),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  tr("startTime", namedArgs: {
                                    "val": DateFormat('yyyy-MM-dd HH:mm:ss')
                                        .format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                      history[index]["startTime"],
                                    ))
                                  }),
                                  style: normalText(),
                                ),
                                Text(
                                  tr("id", namedArgs: {
                                    "val": history[index]["algoId"],
                                  }),
                                  style: normalText(),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  size: 16,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }))),
        ));
  }
}
