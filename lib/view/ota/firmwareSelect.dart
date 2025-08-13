// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:fluoroscopy_tool/store/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import 'firmwareDetail.dart';
import 'publicFunction.dart';
import 'uploading.dart';

class firmwareSelect extends StatefulWidget {
  firmwareSelect({super.key});

  @override
  State<firmwareSelect> createState() => _copybasepageState();
}

class _copybasepageState extends State<firmwareSelect> {
  String selectFirmware = "";
  int updataType = 0;

  int status = 0; //0:搜索中   1:搜索结束
  List firmware = [];

  List version = [];
  int pageIndex = 0;
  int totalCount = 999;

  int onhover = -1;
  int onSelect = -1;

  var firmwareDetail_back = {};

  final otaController _selfController = Get.find();
  final deviceInfoController _deviceInfoController = Get.find();
  static const _selfplatform =
      MethodChannel('samples.flutter.dev/MbtBasicOtaHandler');

  _initversion() {
    List setList = [];
    if (_selfController.selectType.value == 0) {
      for (var element in _deviceInfoController.outdoorEntityList.value) {
        if (_selfController.selectID.value.contains(element["address"])) {
          setList.add(element['firmwareVersion'] ?? "--");
        }
      }
    } else {
      for (var element in _deviceInfoController.indoorEntityList.value) {
        if (_selfController.selectID.value.contains(element["address"])) {
          setList.add(element['firmwareVersion'] ?? "--");
        }
      }
    }
    setState(() {
      version = setList.toSet().toList();
    });
  }

  _init() async {
    try {
      pageIndex = pageIndex + 1;
      // var listFirmwares =
      //     await _selfplatform.invokeMethod('listFirmwares', <String, dynamic>{
      //   "pageIndex": pageIndex,
      //   "typePath":
      //       _selfController.selectType.value == 0 ? "vrf/outdoor" : "vrf/indoor"
      // });

      var _send = {
        "query": {
          "pageSize": 20,
          "typePath": _selfController.selectType.value == 0
              ? "vrf/outdoor"
              : "vrf/indoor",
          "type": "FIRMWARE",
          "pageIndex": pageIndex
        }
      };
      final response = await MideaApi.getChipsList(_send);

      var data = response;
      print("listFirmwares : ${_send}");
      print("listFirmwares: $data");
      for (var element in data["data"]) {
        print("listFirmwares -- ${element.runtimeType}  $element");
      }
      // if (data["errorCode"].toString() == "1001") {
      //   tologout();
      //   return;
      // }
      if (data["success"]) {
        totalCount = data["totalCount"];
        firmware.addAll(data["data"]);
        setState(() {
          status = 1;
          firmware;
        });
        if (totalCount == 0) {
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
                    ),
                  )));
        }
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
                  ),
                )));
        setState(() {
          status = 1;
          firmware = [];
        });
      }
    } catch (e) {
      print("listFirmwares: $e");
      setState(() {
        status = 1;
        firmware = [];
      });
    }
  }

  _getfirmware() async {
    try {
      EasyLoading.show(status: 'loading...');
      var analysisPackage =
          await _selfplatform.invokeMethod('analysisPackage', <String, dynamic>{
        "url": firmwareDetail_back["firmwareDownloadUrl"]["downUrl"],
        "address": firmwareDetail_back["chips"]["address"],
        "size": firmwareDetail_back["chips"]["size"]
      });
      print("_getfirmware : ${{
        "url": firmwareDetail_back["firmwareDownloadUrl"]["downUrl"],
        "address": firmwareDetail_back["chips"]["address"],
        "size": firmwareDetail_back["chips"]["size"]
      }}}");
      var data = jsonDecode(analysisPackage);
      print("_getfirmware : ${data}}");
      EasyLoading.dismiss();
      if (data["success"] && data["data"]) {
        var startUpgrade =
            await _selfplatform.invokeMethod('startUpgrade', <String, dynamic>{
          "deviceType": _selfController.selectType.value,
          "addressList": _selfController.selectID.value,
          "upgradeTypeEnum": updataType
        });
        var startUpgradeData = jsonDecode(startUpgrade);
        if (startUpgradeData["success"]) {
          _selfController.setuuid(startUpgradeData["data"]);
          Get.off(() => uploading(updataType: updataType));
        } else {
          EasyLoading.showError(startUpgradeData["errorMsg"]);
        }
      } else {
        EasyLoading.showError(data["errorMsg"]);
      }
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMore();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _init();
      _initversion();
    });
  }

  Future<void> _loadMore() async {
    if (totalCount > firmware.length) {
      EasyLoading.show(status: 'loading...');
      _init();
    }
  }

  String _getextra(val, key) {
    if (val == null || val == "") {
      return "";
    }
    print("firmware:${jsonDecode(val)}");
    return jsonDecode(val)[key] ?? "";
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
            'ota.title',
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
                if (status == 0)
                  Expanded(
                      child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'public/images/waterPump/loading.gif',
                          width: 200,
                        ),
                        Text(
                          tr("ota.list.search"),
                          style: titleText(),
                        ),
                      ],
                    ),
                  )),
                if (status == 1)
                  Expanded(
                      child: SingleChildScrollView(
                    child: SizedBox(
                      width: 720.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ota.list.searchtip1",
                            style: titleText(),
                          ).tr(namedArgs: {
                            "val": version.isNotEmpty ? version.join(",") : "--"
                          }),
                          SizedBox(
                            height: 260,
                            child: ListView.builder(
                                controller: _scrollController,
                                itemCount: firmware.length + 1,
                                itemBuilder: ((context, index) => index == 0
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 250.w,
                                              child: Text(
                                                "ota.list.search1",
                                                style: titleText(),
                                              ).tr(),
                                            ),
                                            SizedBox(
                                              width: 250.w,
                                              child: Text(
                                                "ota.list.search2",
                                                style: titleText(),
                                              ).tr(),
                                            ),
                                            Expanded(
                                                child: Text(
                                              "ota.list.search3",
                                              style: titleText(),
                                            ).tr())
                                          ],
                                        ),
                                      )
                                    : InkWell(
                                        onTapDown: (value) {
                                          // setState(() {
                                          //   onhover = index - 1;
                                          // });
                                        },
                                        onTapUp: (value) {
                                          // setState(() {
                                          //   onhover = -1;
                                          // });
                                        },
                                        onTap: () async {
                                          setState(() {
                                            onhover = -1;
                                          });
                                          var back = await Get.to(() =>
                                              firmwareDetail(
                                                  byId: firmware[index - 1]
                                                          ["id"]
                                                      .toString()));
                                          print(
                                              "listFirmwares back: ${jsonEncode(back)}");
                                          if (back != null) {
                                            setState(() {
                                              onSelect = index - 1;
                                              firmwareDetail_back = back;
                                            });
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: onhover == (index - 1) ||
                                                      onSelect == (index - 1)
                                                  ? const Color.fromRGBO(
                                                      25, 98, 255, 0.1)
                                                  : Colors.white,
                                              border: const Border(
                                                bottom: BorderSide(
                                                  color: Color.fromRGBO(
                                                      223, 223, 223, 1),
                                                  width: 0.5,
                                                ),
                                              )),
                                          padding: const EdgeInsets.all(8),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 250.w,
                                                  child: Text(
                                                    "${firmware[index - 1]["name"]}",
                                                    style: normalTextBlack(),
                                                  ).tr(),
                                                ),
                                                SizedBox(
                                                  width: 250.w,
                                                  child: Text(
                                                    firmware[index - 1]
                                                            ["typePathName"] ??
                                                        "--",
                                                    style: normalText(),
                                                  ).tr(),
                                                ),
                                                Expanded(
                                                    child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      firmware[index - 1][
                                                              "productTypeName"] ??
                                                          "--",
                                                      style: normalText(),
                                                    ).tr(),
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 3, 0, 0),
                                                      child: Icon(
                                                        Icons.chevron_right,
                                                        color: Color.fromRGBO(
                                                            140, 140, 140, 1),
                                                        size: 18,
                                                      ),
                                                    )
                                                  ],
                                                ))
                                              ]),
                                        ),
                                      ))),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                                onSelect == -1
                                    ? tr("ota.list.searchtip3.empty")
                                    : tr("ota.list.searchtip3.notempty",
                                        namedArgs: {
                                            "val1": "",
                                            "val2":
                                                "${firmwareDetail_back["firmwareDownloadUrl"]["packageFileName"] ?? "--"}"
                                          }),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: titleText(fontcolor: Colors.red)),
                          ),
                          Text("ota.list.searchtip2", style: titleText()).tr(),
                          SizedBox(
                            height: 80,
                            child: ListView.builder(
                                itemCount: 2,
                                itemBuilder: ((context, index) => InkWell(
                                      onTap: () {
                                        setState(() {
                                          updataType = index;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              RoundCheckBox(
                                                isChecked: updataType == index,
                                                onTap: (sel) {
                                                  setState(() {
                                                    updataType = index;
                                                  });
                                                },
                                                size: 16,
                                                checkedWidget: const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 14,
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
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 0, 0, 0),
                                                child: Text(
                                                        "ota.list.updata${index + 1}")
                                                    .tr(),
                                              )
                                            ]),
                                      ),
                                    ))),
                          )
                        ],
                      ),
                    ),
                  )),
                if (status == 1)
                  Container(
                    height: 57,
                    padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                    child: Center(
                      child: submitButton(
                        isActive: firmwareDetail_back.isNotEmpty &&
                            firmwareDetail_back["chips"] != null &&
                            firmwareDetail_back["firmwareDownloadUrl"] != null,
                        label: tr('ota.list.btn'),
                        onClick: () async {
                          _getfirmware();
                        },
                      ),
                    ),
                  )
              ],
            )));
  }
}
