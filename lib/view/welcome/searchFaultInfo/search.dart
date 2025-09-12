import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/snInput.dart';
import 'package:fluoroscopy_tool/store/globalData.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/store/http.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/errorAnalysis/errorDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

class searchFaultInfo extends StatefulWidget {
  searchFaultInfo({super.key});

  @override
  State<searchFaultInfo> createState() => _searchFaultInfoState();
}

class _searchFaultInfoState extends State<searchFaultInfo> {
  int pageindex = 0;
  String search = "";
  List history = [];
  static const platform =
      MethodChannel('samples.flutter.dev/getProjectHandler');

  _searchFaultInfo() async {
    EasyLoading.show(status: 'loading...');
    bool conn = await checkNet(true);
    if (!conn) {
      EasyLoading.dismiss();
      return;
    }
    try {
      var send = {
        "pageSize": 50,
        "pageIndex": 1,
        "errorCode": search,
        "systemType": "vrf"
      };
      var historydata = await MideaApi.faultPagePost(send);

      // var historyback = await platform.invokeMethod(
      //     'getMideaAppHandler.searchFaultInfo', {"keyword": search});
      // var historydata = jsonDecode(historyback);
      EasyLoading.dismiss();
      if (historydata["errorCode"] != null &&
          historydata["errorCode"].toString() == "1001") {
        //登录失效
        tologout();
      }

      if (historydata["data"].isEmpty) {
        // EasyLoading.showError(tr("clound.searchEmptydevice"));
      } else {
        history.addAll(historydata["data"]);

        setState(() {
          history;
        });
      }
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  _getFaultDetail(id, errorCode) async {
    EasyLoading.show(status: 'loading...');
    try {
      // var historyback = await platform
      //     .invokeMethod('getMideaAppHandler.getFaultDetail', {"id": id});
      // var historydata = jsonDecode(historyback);

      var historydata = await MideaApi.faultgetDetail(id.toString());

      print(
          "gethistory:  --------------------------------  errorCode :$errorCode");
      var _getTspDataByKeywordback =
          await MideaApi.getTspDataByKeyword(errorCode.toString());
      String faultProcessWays = "";
      try {
        faultProcessWays =
            _getTspDataByKeywordback["data"][0]["tspSolutionUrl"];
      } catch (e) {}

      print(
          "gethistory:  --------------------------------  faultProcessWays :$faultProcessWays");
      EasyLoading.dismiss();
      if (historydata["errorCode"] != null &&
          historydata["errorCode"].toString() == "1001") {
        //登录失效
        tologout();
      }
      if (historydata["data"].isEmpty) {
        // EasyLoading.showError(tr("clound.searchEmptydevice"));
      } else {
        print(
            "getProfessionalToolsHandler.getSearchHisWithTags: ${historydata["data"]}");

        var showData = {
          "errorCode": historydata["data"]['errorCode'].toString() == "{}"
              ? "--"
              : historydata["data"]['errorCode'],
          "codeName": historydata["data"]['errorName'].toString() == "{}"
              ? "--"
              : historydata["data"]['errorName'],
          "deviceVersion": historydata["data"]['productType'].toString() == "{}"
              ? "--"
              : historydata["data"]['productType'],
          "deviceTypeName": historydata["data"]['deviceType'].toString() == "{}"
              ? "--"
              : historydata["data"]['deviceType'],
          "faultDescription":
              historydata["data"]['faultDesc'].toString() == "{}"
                  ? "--"
                  : historydata["data"]['faultDesc'],
          "faultReason": historydata["data"]['faultReason'].toString() == "{}"
              ? "--"
              : historydata["data"]['faultReason'],
          "faultProcessWays": faultProcessWays,
        };
        Get.to(() => errorDetailPage(item: null, showDetail: showData));
      }
    } catch (e) {
      print("getProfessionalToolsHandler.getSearchHisWithTags: ${e}");
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    super.initState();
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
            'errorclound',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [],
        ),
        body: Container(
          width: 720.w,
          height: 1280.h,
          color: const Color.fromRGBO(244, 244, 244, 1),
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
                                  Expanded(
                                    child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 0, 0, 0),
                                        child: snInput(
                                          hintText: tr('errorcloundhintText'),
                                          isSamll: true,
                                          lengthLimit: false,
                                          onfocus: () {},
                                          valBack: (back) {
                                            if (back == "") {
                                              setState(() {
                                                pageindex = 1;
                                                history = [];
                                              });
                                            }
                                            setState(() {
                                              search = back;
                                            });
                                          },
                                        )),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        pageindex = 1;
                                        history = [];
                                      });
                                      _searchFaultInfo();
                                    },
                                    child: Container(
                                      width: 75,
                                      height: 36,
                                      margin: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(49),
                                          color: const Color.fromRGBO(
                                              25, 98, 255, 1)),
                                      child: Center(
                                        child: const Text(
                                          'search',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
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
              const SizedBox(
                height: 12,
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: history.length,
                      itemBuilder: ((context, index) {
                        return InkWell(
                            onTap: () {
                              _getFaultDetail(history[index]['id'],
                                  history[index]['errorCode']);
                            },
                            child: Stack(
                              children: [
                                Container(
                                    width: 720.w - 24.w * 2,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white),
                                    margin:
                                        EdgeInsets.fromLTRB(0.w, 0, 0.w, 16),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              // Row(
                                              //   children: [
                                              //     Text(
                                              //       tr("errorName"),
                                              //       style: normalTextBlack(
                                              //           fw: FontWeight.w600),
                                              //     ),
                                              //     Expanded(
                                              //         child: SafeText(
                                              //       '${history[index]['codeName']}',
                                              //       style: normalTextBlack(),
                                              //     )),
                                              //   ],
                                              // ),
                                              Row(
                                                children: [
                                                  Text(
                                                    tr("errorCode"),
                                                    style: normalTextBlack(
                                                        fw: FontWeight.w600),
                                                  ),
                                                  Expanded(
                                                      child: SafeText(
                                                    '${history[index]['errorCode']}',
                                                    style: normalTextBlack(),
                                                  ))
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    tr("deviceType"),
                                                    style: normalTextBlack(
                                                        fw: FontWeight.w600),
                                                  ),
                                                  Expanded(
                                                      child: SafeText(
                                                    '${history[index]['deviceTypeName']}',
                                                    style: normalTextBlack(),
                                                  ))
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    tr("productType"),
                                                    style: normalTextBlack(
                                                        fw: FontWeight.w600),
                                                  ),
                                                  Expanded(
                                                      child: SafeText(
                                                    '${history[index]['deviceVersion'] ?? "--"}',
                                                    style: normalTextBlack(),
                                                  ))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 18,
                                        )
                                      ],
                                    )),
                              ],
                            ));
                      })))
            ],
          ),
        ));
  }
}
