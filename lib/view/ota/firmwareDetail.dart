import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/store/http.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import 'publicFunction.dart';

class firmwareDetail extends StatefulWidget {
  String byId;
  firmwareDetail({super.key, required this.byId});

  @override
  State<firmwareDetail> createState() => _copybasepageState();
}

class _copybasepageState extends State<firmwareDetail> {
  String selectFirmware = "";
  List firmware = [];
  int select = -1;

  final otaController _selfController = Get.find();
  final deviceInfoController _deviceInfoController = Get.find();
  static const _selfplatform =
      MethodChannel('samples.flutter.dev/MbtBasicOtaHandler');

  var _firmwareDetails = {};
  _init() async {
    try {
      // var firmwareDetails =
      //     await _selfplatform.invokeMethod('firmwareDetails', <String, dynamic>{
      //   "byId": widget.byId.toString(),
      // });
      // var firmwareDetailsdata = jsonDecode(firmwareDetails);
      var firmwareDetailsdata =
          await MideaApi.getChipsGet({"byId": widget.byId.toString()});

      _firmwareDetails = firmwareDetailsdata["data"];

      var listFirmwares = await _selfplatform
          .invokeMethod('firmwarePackages', <String, dynamic>{
        "byId": widget.byId,
      });
      var data = jsonDecode(listFirmwares);
      if (data["errorCode"].toString() == "1001") {
        tologout();
        return;
      }
      if (data["success"] && data["data"] != null) {
        firmware.addAll(
            data["data"].where((item) => item["issueLevel"] == "GA").toList());

        setState(() {
          firmware;
        });
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        bool issend = await divConfirmOnlyDialog(context,
            confirmTitle: "",
            isSubmitButton: true,
            confirmDescriptionWidget: SizedBox(
              width: 560.w,
              height: 210,
              child: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 0.h, 0, 0.h),
                        child: Image.asset(
                          'public/images/ota/error.png',
                          width: 215.w,
                        )),
                    Text(
                      'ota.getFirmwares.error',
                      style: normalText(),
                    ).tr(),
                  ],
                ),
              )),
            ));
        setState(() {
          firmware = [];
        });
      }
    } catch (e) {}
  }

  _selectfirmware() async {
    EasyLoading.show(status: 'loading...');
    try {
      // var firmwareDownloadUrl = await _selfplatform
      //     .invokeMethod('firmwareDownloadUrl', <String, dynamic>{
      //   "byId": firmware[select]["id"].toString(),
      // });
      // var data1 = jsonDecode(firmwareDownloadUrl);

      var data1 = await MideaApi.getChipsDownloadUrl(
          {"byId": firmware[select]["id"].toString()});

      if (data1["data"].isNotEmpty) {
        _selfController.setOtafirmware(data1["data"]);
        Get.back(result: {
          "chips": {
            "address": 0,
            "canDelete": "0",
            "chipType": "6519A-内机",
            "createTime": "2021-12-06T11:33:24",
            "deviceType": "indoor",
            "deviceTypeName": "内机",
            "id": 13,
            "informationContent": null,
            "informationName": null,
            "informationUrl": null,
            "productType": "vrf",
            "productTypeName": "多联机",
            "remark": null,
            "size": 0x80
          },
          "firmwareDetails": _firmwareDetails,
          "firmwareDownloadUrl": data1["data"]
        });
      }
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    super.initState();

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
            'ota.firmwareDetail',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [],
        ),
        body: Container(
            width: 720.w,
            height: 1280.h,
            color: const Color.fromRGBO(255, 255, 255, 1),
            padding: EdgeInsets.fromLTRB(16, 25, 16, 0.h),
            child: Column(
              children: [
                Expanded(
                    child: SizedBox(
                        width: 720.w,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: firmware.length,
                          itemBuilder: ((context, index) => InkWell(
                                onTap: () {
                                  if (select == index) {
                                    setState(() {
                                      select = -1;
                                    });
                                  } else {
                                    setState(() {
                                      select = index;
                                    });
                                  }
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      border: Border(
                                        bottom: BorderSide(
                                          color:
                                              Color.fromRGBO(223, 223, 223, 1),
                                          width: 0.5,
                                        ),
                                      )),
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 10, 0),
                                            child: RoundCheckBox(
                                              isChecked: select == index,
                                              onTap: (val) {
                                                if (select == index) {
                                                  setState(() {
                                                    select = -1;
                                                  });
                                                } else {
                                                  setState(() {
                                                    select = index;
                                                  });
                                                }
                                              },
                                              size: 20,
                                              checkedWidget: const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                              checkedColor: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              border: Border.all(
                                                  // width: 1,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                            ),
                                          ),
                                          Expanded(
                                              child: Text(
                                            tr("ota.firmwareDetail1",
                                                namedArgs: {
                                                  "val":
                                                      "${firmware[index]["canonicalName"]}"
                                                }),
                                            style: normalTextBlack(),
                                          ))
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            30, 0, 0, 0),
                                        child: Row(
                                          children: [
                                            Text(
                                              tr("ota.firmwareDetail2",
                                                  namedArgs: {
                                                    "val":
                                                        "${firmware[index]["version"]}"
                                                  }),
                                              style: normalText(),
                                            ),
                                            const SizedBox(
                                              width: 50,
                                            ),
                                            Text(
                                              // ignore: prefer_interpolation_to_compose_strings
                                              "ota.issueLevel." +
                                                  firmware[index]["issueLevel"],
                                              style: normalTextBlack(),
                                            ).tr()
                                          ],
                                        ),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              30, 0, 0, 0),
                                          child: Row(
                                            children: [
                                              Text(
                                                firmware[index]["createTime"],
                                                style: normalText(),
                                              )
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                              )),
                        ))),
                Container(
                  height: 57,
                  padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                  child: Center(
                    child: submitButton(
                      isActive: select != -1,
                      label: tr('determine'),
                      onClick: () async {
                        _selectfirmware();
                      },
                    ),
                  ),
                )
              ],
            )));
  }
}
