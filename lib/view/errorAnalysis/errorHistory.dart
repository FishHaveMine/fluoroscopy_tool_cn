import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/store/globalData.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'errorDetail.dart';

import 'package:provider/provider.dart';

class errorHistory extends StatefulWidget {
  String? sn;
  String? nid;
  String? deviceversion;
  errorHistory({super.key, this.nid, this.sn, this.deviceversion});

  @override
  State<errorHistory> createState() => _errorHistoryState();
}

class _errorHistoryState extends State<errorHistory> {
  List dataList = [];
  bool isempty = false;
  bool iserror = false;
  int pageindex = 1;
  int totalCount = 0;
  String nid = "";
  var info;
  static const platform = MethodChannel('samples.flutter.dev/battery');

  final deviceInfoController _deviceInfoController = Get.find();
  ScrollController _scrollController = ScrollController();

  static const _Projectplatform =
      MethodChannel('samples.flutter.dev/getProjectHandler');
  static const _selfplatform =
      MethodChannel('samples.flutter.dev/getDeviceFaultHandler');

  String errorMsg = "";
  getconnectbySn() async {
    bool conn = await checkNet(true);
    if (!conn) {
      EasyLoading.dismiss();
      setState(() {
        errorMsg = tr("neterror");
        iserror = true;
      });
      return;
    }
    if (widget.nid == null) {
      EasyLoading.show(status: 'loading...');
      var send = {
        "projectCode": "",
        "sn": widget.sn ?? _deviceInfoController.loacalDevice.value.sn,
        "pageindex": 1
      };

      try {
        print("_errorHistoryState getProfessionalToolsHandler.page");
        var getSearchBySnback = await _Projectplatform.invokeMethod(
            'getProfessionalToolsHandler.page', send);
        var historydata = jsonDecode(getSearchBySnback);
        if (historydata["errorCode"] != null &&
            historydata["errorCode"].toString() == "1001") {
          //登录失效
          tologout();
          return;
        }

        print(
            "_errorHistoryState getProfessionalToolsHandler.page : $historydata");
        EasyLoading.dismiss();
        if (historydata["success"] && historydata["data"].isNotEmpty) {
          for (var element in historydata["data"]) {
            print("nid: ${element["nid"]}");
          }
          info = historydata["data"][0];
          nid = info["nid"];
          gethistory();
        } else {
          setState(() {
            errorMsg = historydata["errorMsg"] == ""
                ? tr("searchdeviceempty")
                : historydata["errorMsg"];
            iserror = true;
          });
        }
        print(
            "_errorHistoryState getProfessionalToolsHandler.page : $historydata");
      } catch (e) {
        print(e);
        EasyLoading.dismiss();
        // EasyLoading.showError("$e");

        setState(() {
          errorMsg = tr("searchdeviceempty");
          iserror = true;
        });
      }
    } else {
      nid = widget.nid!;
      gethistory();
    }
  }

  gethistory() async {
    try {
      print("_errorHistoryState getListByNid: ${{
        "nid": nid,
        "pageindex": pageindex
      }}");

      EasyLoading.show(status: 'loading...');
      var gethistory = await _selfplatform.invokeMethod('getListByNid',
          <String, dynamic>{"nid": nid, "pageindex": pageindex});
      print("_errorHistoryState getListByNid: ${{
        "nid": nid,
        "pageindex": pageindex
      }}");

      EasyLoading.dismiss();
      if (gethistory["errorCode"] != null &&
          gethistory["errorCode"].toString() == "1001") {
        //登录失效
        tologout();
      }
      if (!gethistory["success"]) {
        EasyLoading.showError(tr("network_error"));
        setState(() {
          errorMsg = gethistory["errorMsg"];
          iserror = true;
        });
        // await signout();
        // // ignore: use_build_context_synchronously
        // Provider.of<GlobalData>(context, listen: false).userIsLogin(false);
        // // ignore: use_build_context_synchronously
        // // Navigator.pop(context);
      } else {
        setState(() {
          iserror = false;
          dataList.addAll(gethistory["data"]);
          totalCount = gethistory['totalCount'];
          isempty = dataList.length == 0;
        });
      }
    } catch (e) {
      print(e);

      // EasyLoading.showError("$e");
      setState(() {
        iserror = true;
      });
    }
  }

  init() {}
  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // 滚动到底部，加载更多数据
      pageindex++;
      gethistory();
    }
  }

  checknet() async {
    bool isnetconnecd = false;

    EasyLoading.show(status: 'loading...');
    try {
      final response = await Dio().get('https://${apiHost}/');
      isnetconnecd = response.statusCode == 200;
      EasyLoading.dismiss();
      if (isnetconnecd) {
        getconnectbySn();
        init();
        _scrollController.addListener(_scrollListener);
      } else {
        EasyLoading.showError(
            tr("erroranalysis.tip5_error").replaceAll("2.", ""));
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(
          tr("erroranalysis.tip5_error").replaceAll("2.", ""));
    }
  }

  @override
  void initState() {
    super.initState();
    checknet();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _copyTextToClipboard(String text) {
    if (text != null) {
      Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${tr('projectDetail.deviceManage.copy')}: $text'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 720.w,
        height: 1280.h - 104.h,
        child: iserror
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 220.h, 0, 0.h),
                      child: Image.asset(
                        'public/images/afterSalesReplacement/error.png',
                        width: 215.w,
                      )),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 64.h, 0, 32.h),
                    child: Text(tr('errorAnalysis.getListByNid.error'),
                        style: normalTextBlack(fSize: 18)),
                  ),
                  InkWell(
                    onTap: () {
                      _copyTextToClipboard(errorMsg != ""
                          ? errorMsg
                          : tr('errorAnalysis.getListByNid.errortip'));
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0.h, 0, 32.h),
                      child: Text(
                          errorMsg != ""
                              ? errorMsg
                              : tr('errorAnalysis.getListByNid.errortip'),
                          textAlign: TextAlign.center,
                          style: normalText(fSize: 18)),
                    ),
                  )
                ],
              )
            : isempty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 220.h, 0, 0.h),
                          child: Image.asset(
                            'public/images/afterSalesReplacement/success.png',
                            width: 215.w,
                          )),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 64.h, 0, 64.h),
                        child: Text(
                          errorMsg != ""
                              ? errorMsg
                              : tr('errorAnalysis.getListByNid.isempty'),
                          style: normalTextBlack(fSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    itemCount: dataList.length,
                    controller: _scrollController,
                    itemBuilder: ((context, index) => InkWell(
                          onTap: () {
                            Get.to(() => errorDetailPage(
                                item: dataList[index],
                                deviceversion: widget.deviceversion));
                          },
                          child: Container(
                            width: 720.w,
                            height: 232.h,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(223, 223, 223, 1),
                                    width: 0.5,
                                  ),
                                )),
                            padding:
                                EdgeInsets.fromLTRB(32.w, 42.h, 32.w, 42.h),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 15, 0),
                                          child: Text(
                                              dataList[index]["errorCode"]),
                                        ),
                                        if (dataList[index]["faultName"] != "")
                                          Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color.fromRGBO(
                                                    255, 0, 0, 1),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              dataList[index]["faultName"],
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Color.fromRGBO(
                                                      255, 0, 0, 1)),
                                            ),
                                          )
                                      ],
                                    ),
                                    Text(
                                      dataList[index]["idx"],
                                      style: normalTextS(),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 5, 0),
                                          child: Text("errorAnalysis.faultTime",
                                                  style: normalTextS())
                                              .tr(),
                                        ),
                                        Text(
                                            formatTimestamp(
                                                dataList[index]["startTime"]),
                                            style: normalTextS(
                                                fontcolor: Colors.black))
                                      ],
                                    ),
                                  ],
                                )),
                                const Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
                                    size: 28,
                                    color: Color.fromRGBO(179, 179, 179, 1),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ))));
  }
}
