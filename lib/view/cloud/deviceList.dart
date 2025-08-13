import 'dart:convert';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/deviceListinfo.dart';
import 'package:fluoroscopy_tool/compent/deviceSearchListinfo.dart';
import 'package:fluoroscopy_tool/compent/snInput.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/userinfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'device/ deviceDetail.dart';
import 'publicFunction.dart';

import 'package:get/get.dart';

class deviceList extends StatefulWidget {
  const deviceList({super.key});

  @override
  State<deviceList> createState() => _deviceListState();
}

class _deviceListState extends State<deviceList> {
  final cloudProjectController _selectController = Get.find();

  final userinfoController _promissioncontroller = Get.find();
  bool inputfocus = false;
  String search = "";
  List history = [];
  List searchhistory = [];

  static const plform = MethodChannel('samples.flutter.dev/battery');
  static const platform =
      MethodChannel('samples.flutter.dev/getProjectHandler');
  int pageindex = 1;
  // 加载更多的标志
  bool isLoading = true;
  // 控制器用于监听滚动事件
  ScrollController _scrollController = ScrollController();

  final GlobalKey<snInputState> _key = GlobalKey<snInputState>();
  int total = 999;
  getSearchHistories() async {
    try {
      _key.currentState?.fun();
    } catch (e) {}
    try {
      var send = {"projectCode": "", "sn": search, "pageindex": pageindex};
      var historyback =
          await platform.invokeMethod('getProfessionalToolsHandler.page', send);
      var historydata = jsonDecode(historyback);

      if (historydata["errorCode"] != null &&
          historydata["errorCode"].toString() == "1001") {
        //登录失效
        tologout();
      }
      if (!historydata['success']) {
        EasyLoading.showError(historydata['errorMsg']);
      }
      total = historydata["totalCount"];
      if (historydata["data"].isEmpty) {
        EasyLoading.showError(tr("clound.searchEmptydevice"));
        setState(() {
          inputfocus = false;
          // history = [];
          isLoading = false;
        });
      } else {
        setState(() {
          inputfocus = false;
          history.addAll(historydata["data"]);
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  getSearchHisWithTags() async {
    try {
      _key.currentState?.fun();
    } catch (e) {}
    searchhistory = [];
    try {
      var historyback = await platform
          .invokeMethod('getProfessionalToolsHandler.getSearchHisWithTags', {});
      var historydata = jsonDecode(historyback);
      if (historydata["errorCode"] != null &&
          historydata["errorCode"].toString() == "1001") {
        //登录失效
        tologout();
      }
      print("getSearchHistories:   ${historydata["data"]}");
      if (historydata["data"].isEmpty) {
        // EasyLoading.showError(tr("clound.searchEmptydevice"));
      } else {
        List limitedList = historydata["data"].length > 5
            ? historydata["data"].sublist(0, 5)
            : historydata["data"];
        for (var element in limitedList) {
          var send = {"projectCode": "", "sn": element, "pageindex": 1};
          var historybacklist = await platform.invokeMethod(
              'getProfessionalToolsHandler.page', send);
          var historydatalist = jsonDecode(historybacklist);
          searchhistory.addAll(historydatalist["data"]);
        }
        print(searchhistory);
        setState(() {
          searchhistory;
        });

        print(
            "getProfessionalToolsHandler.getSearchHisWithTags: ${searchhistory[0]}");
      }
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    getSearchHistories();
    getSearchHisWithTags();
    // 添加滚动监听器
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // 移除滚动监听器
    _scrollController.dispose();
    super.dispose();
  }

  // 滚动监听器
  void _scrollListener() {
    // 如果滚动到底部并且不在加载状态中，则加载更多数据
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      // setState(() {
      //   isLoading = true;
      // });
      pageindex++;
      // 模拟异步加载数据
      getSearchHistories();
    }
  }

  openscan() async {
    try {
      await plform.invokeMethod('SCANNER_TRIG');
    } on PlatformException catch (e) {
      print("Failed to SCANNER_TRIG: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 24.h, 0, 0.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Positioned(
                            child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          padding: const EdgeInsets.all(0),
                          height: 44,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(42),
                              color: Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  openscan();
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 10, 0),
                                  child: Image.asset(
                                    'public/images/waterPump/scran.png',
                                    width: 40.w,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    child: snInput(
                                      key: _key,
                                      hintText: tr("getsn"),
                                      isSamll: true,
                                      lengthLimit: false,
                                      onfocus: () {
                                        setState(() {
                                          inputfocus = true;
                                        });
                                      },
                                      valBack: (back) {
                                        setState(() {
                                          search = back;
                                          pageindex = 1;
                                        });
                                        if (back == "") {
                                          setState(() {
                                            isLoading = true;
                                            history = [];
                                            pageindex = 1;
                                          });
                                          getSearchHistories();
                                        }
                                      },
                                    )),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    history = [];
                                    isLoading = true;
                                  });
                                  getSearchHistories();
                                },
                                child: Container(
                                  width: 55,
                                  height: 36,
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(49),
                                      color:
                                          const Color.fromRGBO(25, 98, 255, 1)),
                                  child: Center(
                                    child: const Text(
                                      'search',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ).tr(),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                      ],
                    )
                  ],
                )),
          ),
          if (inputfocus)
            Container(
              width: 720.w,
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: const Text(
                "searchtip.Text",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ).tr(),
            ),
          Expanded(
              child: isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'public/images/waterPump/loading.gif',
                            width: 200,
                          ),
                          Text(
                            tr("systemCapabilityAnalysisPage.projectSearch.start.tip3"),
                            style: titleText(),
                          ),
                        ],
                      ),
                    )
                  : inputfocus
                      ? ListView.builder(
                          key:
                              ValueKey("searchhistory_${searchhistory.length}"),
                          itemCount: searchhistory.length,
                          itemBuilder: ((context, index) {
                            return InkWell(
                                onTap: () {
                                  if (_promissioncontroller
                                      .checkCloundPromission(
                                          "SystemDetailView")) {
                                    _selectController
                                        .setSelectDevice(searchhistory[index]);

                                    Get.to(() => deviceDetail());
                                  }
                                },
                                child: Container(
                                    width: 720.w - 24.w * 2,
                                    padding: const EdgeInsets.all(11),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white),
                                    margin:
                                        EdgeInsets.fromLTRB(0.w, 0, 0.w, 16),
                                    child: deviceListinfo(
                                        search: search,
                                        showing: searchhistory[index])));
                          }))
                      : history.isNotEmpty
                          ? ListView.builder(
                              itemCount: history.length,
                              controller: _scrollController,
                              itemBuilder: ((context, index) {
                                return InkWell(
                                    onTap: () {
                                      if (_promissioncontroller
                                          .checkCloundPromission(
                                              "SystemDetailView")) {
                                        _selectController
                                            .setSelectDevice(history[index]);

                                        Get.to(() => deviceDetail());
                                      }
                                    },
                                    child: Container(
                                        width: 720.w - 24.w * 2,
                                        padding: const EdgeInsets.all(11),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white),
                                        margin: EdgeInsets.fromLTRB(
                                            0.w, 0, 0.w, 16),
                                        child: deviceListinfo(
                                            search: search,
                                            showing: history[index])));
                              }))
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 60.h, 0, 0),
                                    child: Image.asset(
                                      'public/images/cloud/searchEmpty.png',
                                      width: 200,
                                    ),
                                  ),
                                  Text(
                                    tr("clound.searchEmptydevice"),
                                    style: titleText(),
                                  ),
                                ],
                              ),
                            ))
        ],
      ),
    );
  }
}
