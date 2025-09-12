import 'dart:convert';
import 'dart:math';

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

import 'errorDetailBluetooth.dart';

class errorHistoryBluetooth extends StatefulWidget {
  String? sn;
  String? nid;
  String? deviceversion;
  errorHistoryBluetooth({super.key, this.nid, this.sn, this.deviceversion});

  @override
  State<errorHistoryBluetooth> createState() => _errorHistoryBluetoothState();
}

class _errorHistoryBluetoothState extends State<errorHistoryBluetooth> {
  List dataList = [];
  bool isempty = false;
  bool iserror = false;

  static const platform = MethodChannel('samples.flutter.dev/MSInterface');
  init() async {
    EasyLoading.show(status: 'loading...');
    try {
      var _toolUnlock =
          await platform.invokeMethod('getFaultHistory', <String, dynamic>{});

      // String jsonString =
      //     await rootBundle.loadString('assets/getFaultHistory.json');

      var bakc = jsonDecode(_toolUnlock);
      EasyLoading.dismiss();

      if (!bakc['success']) {
        EasyLoading.showError(bakc['errorMsg']);
        return;
      } else {
        setState(() {
          dataList = bakc['data'];
        });
      }
      // private static List<FaultHistoryData> faultHistoryDataList;

      // private Long number;       故障序号
      // private String protocol;   协议类型
      // private Short machineType;
      // private Long timeStamp;    故障时间

      // private Map<Integer, String> outDoorErrorMap; 外机故障代码
      // private Map<Integer, String> inDoorErrorMap;  内机故障代码
      // private List<MachineDataDTO> machineDataDTOList = CollUtil.newArrayList(new MachineDataDTO[0]);

      // -- private Short sign;
      /**
               * 
        0:故障信息；
        1:故障时刻数据； 
        2:故障前30S数据；
        3:模块波形数据；
        4:故障前1min数据；
        5:故障前2min数据；
        ……
        33:故障前30min数据；
       */

      // private SystemFaultDataDTO systemFaultDataDTO = new SystemFaultDataDTO();  系统 展示：ODU_70_0
      // private List<OutDoorFaultDataDTO> outDoorFaultDataDTOList = CollUtil.newArrayList(new OutDoorFaultDataDTO[0]);  外机 展示：odu_71
      // private List<InDoorFaultDataDTO> inDoorFaultDataDTOList = CollUtil.newArrayList(new InDoorFaultDataDTO[0]); 内机 展示：Ordinary_IDU_20_0

    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
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
                          tr('errorAnalysis.getListByNid.isempty'),
                          style: normalTextBlack(fSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: ((context, index) => InkWell(
                          onTap: () {
                            Get.to(() => errorDetailBluetooth(
                                  item: dataList[index],
                                ));
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
                                        Text(
                                          dataList[index]['number'].toString(),
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 0, 25, 0),
                                          child:
                                              errorCode(data: dataList[index]),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              45, 0, 15, 0),
                                          child: Text(
                                                  "erroranalysis.resultbluetooth.detail2",
                                                  style: normalTextS())
                                              .tr(),
                                        ),
                                        Text(dataList[index]["protocol"],
                                            style: normalTextS(
                                                fontcolor: Colors.black))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              45, 0, 5, 0),
                                          child: Text(
                                                  "erroranalysis.resultbluetooth.detail5",
                                                  style: normalTextS())
                                              .tr(),
                                        ),
                                        Text(
                                            dataList[index]["timeStamp"]
                                                .toString(),
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

class errorCode extends StatefulWidget {
  var data;
  errorCode({super.key, required this.data});

  @override
  State<errorCode> createState() => _errorCodeState();
}

class _errorCodeState extends State<errorCode> {
  String resul = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try {
      // 格式化 inDoorErrorMap 和 outDoorErrorMap
      var inDoorErrorMap = widget.data["inDoorErrorMap"];
      inDoorErrorMap.removeWhere((key, value) => value == "0");
      String inDoorErrors = inDoorErrorMap.entries
          .map((e) => e.value.toString() != "0" ? "${e.value}" : "")
          .join(", ");

      var outDoorErrorMap = widget.data["outDoorErrorMap"];
      outDoorErrorMap.removeWhere((key, value) => value == "0");
      String outDoorErrors = outDoorErrorMap.entries
          .map((e) => e.value.toString() != "0" ? "${e.value}" : "")
          .join(", ");

      // 合并输出
      resul = inDoorErrors + (inDoorErrors != "" ? "," : "") + outDoorErrors;
      setState(() {
        resul;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      resul,
      style: const TextStyle(
          fontSize: 17,
          color: Color.fromRGBO(255, 0, 0, 1),
          fontWeight: FontWeight.w500),
    );
  }
}
