import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/bottomSelectSheet.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/compent/tapSelector.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/cloud/projectManage/ibutler/addtest.dart';
import 'package:fluoroscopy_tool/view/cloud/projectManage/ibutler/ibutleractive.dart';
import 'package:fluoroscopy_tool/view/cloud/publicFunction.dart';
import 'package:fluoroscopy_tool/view/userinfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import '../../device/style.dart';
import 'card2.dart';
import 'card5.dart';
import 'publicFunction.dart';

class ibutler extends StatefulWidget {
  ibutler({super.key});

  @override
  State<ibutler> createState() => _ibutlerState();
}

class _ibutlerState extends State<ibutler> {
  static const platform = MethodChannel('samples.flutter.dev/ibutler');

  final userinfoController _promissioncontroller = Get.find();
  final activateContractController _childController =
      Get.put(activateContractController());
  final cloudProjectController _selectController = Get.find();
  String card2Select = "all";
  String card2key = "";
  var card2data = {};
  _card2() async {
    print(_selectController.selectProject);
    EasyLoading.show(status: 'loading...');
    try {
      var project = _selectController.selectProject.value["project"];
      var initHistory = await platform.invokeMethod('contractStatus',
          {"projectCode": project["code"], "model": card2Select});

      var indoorHistorydata = jsonDecode(initHistory);
      print("_card2:  $indoorHistorydata");
      setState(() {
        card2data = indoorHistorydata['data'];
        card2key = DateTime.now().millisecondsSinceEpoch.toString();
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  var card3data = {};
  var deviceContractCountDTO = {};
  var deviceTrialAnalysisDTO = {};

  Map deviceRemainDayDTOList = {
    "allDevices": [],
    "v8": [],
    "nonV8": [],
  };
  // ignore: non_constant_identifier_names
  List deviceContractCountDTO_keys = [
    "allDevices",
    "unsignedContract",
    "nonSCard",
    "scard"
  ];

  String card3key = "";
  _card3() async {
    EasyLoading.show(status: 'loading...');
    try {
      var project = _selectController.selectProject.value["project"];
      var initHistory1 = await platform
          .invokeMethod('deviceStatistic', {"projectCode": project["code"]});
      var indoorHistorydata1 = jsonDecode(initHistory1);
      if (indoorHistorydata1['data']["deviceContractCountDTO"] != null) {
        try {
          deviceContractCountDTO =
              indoorHistorydata1['data']["deviceContractCountDTO"][0];
        } catch (e) {}
      }
      if (indoorHistorydata1['data']["deviceTrialAnalysisDTO"] != null) {
        try {
          deviceTrialAnalysisDTO =
              indoorHistorydata1['data']["deviceTrialAnalysisDTO"];
        } catch (e) {}
      }
      print(indoorHistorydata1['data']["deviceRemainDayDTOList"]);
      if (indoorHistorydata1['data']["deviceRemainDayDTOList"] != null) {
        // 从数据中获取 deviceRemainDayDTOList
        List<Map<String, dynamic>> remainDayList =
            List<Map<String, dynamic>>.from(
                indoorHistorydata1['data']['deviceRemainDayDTOList']);
        // 遍历列表并将对应字段的数据插入到目标 Map

        print(remainDayList);
        for (var item in indoorHistorydata1['data']["deviceRemainDayDTOList"]) {
          print(item);
          deviceRemainDayDTOList['allDevices']?.add(item['allDevices'] ?? 0);
          deviceRemainDayDTOList['v8']?.add(item['v8'] ?? 0);
          deviceRemainDayDTOList['nonV8']?.add(item['nonV8'] ?? 0);
        }
      }

      print("deviceRemainDayDTOList: $deviceRemainDayDTOList");
      setState(() {
        card3data = indoorHistorydata1['data'];
        deviceContractCountDTO;
        deviceTrialAnalysisDTO;
        deviceRemainDayDTOList;
        card3key = DateTime.now().millisecondsSinceEpoch.toString();
      });
      EasyLoading.dismiss();
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    super.initState();
    _card2();
    _card3();
  }

  Future<void> _showBottomSheet(context) async {
    _childController.init();
    String projectid = "";
    Future<bool?> back = await showCustomModalBottomBox(
        context,
        checkOrder(onselect: (val) {
          projectid = val;
        }),
        titleName: tr("ibutleractive.title"),
        determine: "Instructionspage.next",
        next: () {
          if (_childController.card.value.isNotEmpty) {
            Get.to(() => ibutleractivePage());
          }
        });
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
            icon:
                const Icon(Icons.chevron_left, color: Colors.black, size: 36)),
        // ignore: prefer_const_constructors
        title: Text(
          'ibutler.title',
          style: const TextStyle(color: Colors.black),
        ).tr(),
        centerTitle: true,
        actions: const [],
      ),
      body: Container(
        width: 720.w,
        height: 1280.h,
        color: const Color.fromRGBO(244, 244, 244, 1),
        padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: cardStyleFull(context),
                    margin: EdgeInsets.fromLTRB(16.w, 12, 16.w, 12),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ibutler.card1.type1',
                              style: normalTextBlack(fSize: 18),
                              overflow: TextOverflow.ellipsis,
                            ).tr(),
                            Expanded(
                              child: Text(
                                '${_selectController.selectProject.value["project"]['name'] ?? "--"}',
                                style: normalTextBlack(fSize: 18),
                                overflow: TextOverflow.ellipsis,
                              ).tr(),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ibutler.card1.type2',
                              style: normalText(fSize: 18),
                              overflow: TextOverflow.ellipsis,
                            ).tr(),
                            Expanded(
                              child: Text(
                                '${_selectController.selectProject.value["project"]['code'] ?? "--"}',
                                style: normalText(fSize: 18),
                                overflow: TextOverflow.ellipsis,
                              ).tr(),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ibutler.card1.type3',
                              style: normalText(fSize: 18),
                              overflow: TextOverflow.ellipsis,
                            ).tr(),
                            Expanded(
                              child: Text(
                                '${_selectController.selectProject.value["project"]['outdoorCount'] ?? "--"}',
                                style: normalText(fSize: 18),
                                overflow: TextOverflow.ellipsis,
                              ).tr(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: cardStyleFull(context),
                    margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'ibutler.card2.title',
                                  style: normalTextBlack(fSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                ).tr(),
                                TooltipOnClick(
                                    msg:
                                        '展示当前项目外机设备合约状态数据\n试用中：外机设备处于试用期时间内\n合约履行中：外机设备处于合约时间内\n未试用：可以添加试用的外机设备，但从未设置过试用时间的外机设备\n已过期：添加试用后过期的设备和绑定合约后过期的设备')
                              ],
                            ),
                            TapSelector(
                              key: ValueKey("card2Select_$card2Select"),
                              Option: const ['all', 'v8', 'nonv8'],
                              onSelectChange: (val) {
                                setState(() {
                                  card2Select = val;
                                });
                                _card2();
                              },
                              selected: card2Select,
                            )
                          ],
                        ),
                        card2(
                            key: ValueKey("card2_$card2key"),
                            title: tr("ibutler.card3.type1"),
                            dataPieChar: [
                              {
                                "key": tr("ibutler.card2.dataPieChar1"),
                                "value": "${card2data["over"] ?? 0}"
                              },
                              {
                                "key": tr("ibutler.card2.dataPieChar2"),
                                "value": "${card2data["inContract"] ?? 0}"
                              },
                              {
                                "key": tr("ibutler.card2.dataPieChar3"),
                                "value": "${card2data["inTrial"] ?? 0}"
                              },
                              {
                                "key": tr("ibutler.card2.dataPieChar4"),
                                "value": "${card2data["notTried"] ?? 0}"
                              }
                            ])
                      ],
                    ),
                  ),
                  Container(
                    decoration: cardStyleFull(context),
                    margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'ibutler.card3.title',
                              style: normalTextBlack(fSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ).tr(),
                            TooltipOnClick(
                                msg:
                                    '展示当前项目设备实时的合约情况，不统计未来或过去的合约\n全部设备：当前项目外机设备总数\n未签合约：没有签合约的设备数\n非S卡：没有购买S卡-12年的设备总数\nS卡-12年：只要购买了S卡的设备总数')
                          ],
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (int i = 0; i < 4; i++)
                                Container(
                                  width: (720.w - 64.w - 32.w) / 4,
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 16, 0, 0),
                                  child: Column(
                                    children: [
                                      Text(
                                          "${deviceContractCountDTO[deviceContractCountDTO_keys[i]] ?? "0"}"),
                                      Text(
                                        tr("ibutler.card3.type${i + 1}"),
                                        style: normalText(),
                                      )
                                    ],
                                  ),
                                )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: cardStyleFull(context),
                    margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'ibutler.card4.title',
                              style: normalTextBlack(fSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ).tr(),
                            TooltipOnClick(msg: tr('ibutler.card4.tip'))
                          ],
                        ),
                        card2(
                            key: ValueKey("card3_$card3key"),
                            title: tr("ibutler.card4.datapiechar"),
                            dataPieChar: [
                              {
                                "key": tr("ibutler.card4.dataPieChar1"),
                                "value":
                                    "${deviceTrialAnalysisDTO["tried"] ?? "0"}"
                              },
                              {
                                "key": tr("ibutler.card4.dataPieChar2"),
                                "value":
                                    "${deviceTrialAnalysisDTO["notTried"] ?? "0"}"
                              },
                            ],
                            ColorList: const [
                              Color.fromRGBO(108, 164, 255, 1),
                              Color.fromRGBO(211, 219, 237, 1)
                            ])
                      ],
                    ),
                  ),
                  Container(
                    decoration: cardStyleFull(context),
                    margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'ibutler.card5.title',
                              style: normalTextBlack(fSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ).tr(),
                            TooltipOnClick(
                                msg: '展示当前项目外机设备剩余使用天数的数据（包含合约履行中和试用中的外机设备)')
                          ],
                        ),
                        SizedBox(
                          height: 200,
                          width: 720.w - 64.w,
                          child: card5(
                            key: ValueKey("card5_$card3key"),
                            data: [
                              {
                                "name": "all",
                                "data": deviceRemainDayDTOList['allDevices']
                              },
                              {
                                "name": "v8",
                                "data": deviceRemainDayDTOList['v8']
                              },
                              {
                                "name": "nonv8",
                                "data": deviceRemainDayDTOList['nonV8']
                              }
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
            Container(
              height: 57,
              padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 300.w,
                    child: normalButton(
                      label: tr('ibutleraddtest.title'),
                      onClick: () async {
                        if (!_promissioncontroller
                            .checkCloundPromission("Charging_Trial")) {
                          return;
                        }
                        Get.to(() => addtest());
                      },
                    ),
                  ),
                  SizedBox(
                    width: 300.w,
                    child: submitButton(
                      isActive: true,
                      label: tr('ibutleractive.title'),
                      onClick: () async {
                        if (!_promissioncontroller
                            .checkCloundPromission("Charging_Contract")) {
                          return;
                        }
                        _showBottomSheet(context);
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TooltipOnClick extends StatefulWidget {
  String msg;
  TooltipOnClick({super.key, required this.msg});
  @override
  _TooltipOnClickState createState() => _TooltipOnClickState();
}

class _TooltipOnClickState extends State<TooltipOnClick> {
  final GlobalKey _toolTipKey = GlobalKey();

  void _onTap() {
    final dynamic tooltip = _toolTipKey.currentState;
    tooltip?.ensureTooltipVisible(); // 手动显示 Tooltip
  }

  _showtip() async {
    bool issend = await divConfirmOnlyDialog(context,
        isSubmitButton: true,
        confirmTitle: tr("ibutleractive.tip1_title"),
        confirmDescriptionWidget: SizedBox(
          width: 560.w,
          height: 140,
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.msg,
                  style: normalText(),
                ).tr(),
              ],
            ),
          )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showtip, // 监听点击事件
      child: const Padding(
        padding: EdgeInsets.fromLTRB(4, 6, 0, 0),
        child: Icon(
          Icons.help,
          size: 20,
          color: Color.fromRGBO(153, 153, 153, 1),
        ),
      ),
    );
  }
}

class checkOrder extends StatefulWidget {
  Function onselect;
  checkOrder({super.key, required this.onselect});

  @override
  State<checkOrder> createState() => _checkOrderState();
}

class _checkOrderState extends State<checkOrder> {
  String order = "";
  List orderList = [];
  String id = "";
  final activateContractController _childController = Get.find();
  static const platform = MethodChannel('samples.flutter.dev/ibutler');
  final cloudProjectController _selectController = Get.find();
  _checkod() async {
    try {
      var project = _selectController.selectProject.value["project"];
      var initHistory = await platform.invokeMethod(
          'getAppChargeHandler.getCssOrder',
          {"projectCode": project["code"].toString(), "orderNo": order});

      var indoorHistorydata = jsonDecode(initHistory);
      print(indoorHistorydata);
      if (!indoorHistorydata['success']) {
        EasyLoading.showError(tr('searchordererror'));
      } else {
        setState(() {
          orderList = indoorHistorydata["data"]["materialInfos"];
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ibutleractive.bottomSheetTip",
            style: normalTextBlack(),
          ).tr(),
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(247, 247, 247, 1), // 背景颜色
                  borderRadius: BorderRadius.circular(8), // 圆角边框
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: tr('input.hintText'),
                    filled: true, // Enables the background color
                    fillColor: const Color.fromRGBO(
                        247, 247, 247, 1), // Background color
                    border: InputBorder.none, // 去掉默认的下划线边框
                  ),
                  onChanged: (val) {
                    setState(() {
                      order = val;
                    });
                  },
                ),
              )),
          Container(
            height: 44,
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 29 - 12),
            child: submitButton(
              label: tr('ibutleractive.bottomSheetBtn'),
              onClick: () async {
                if (order != "") _checkod();
              },
              isActive: order != "",
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: orderList.length,
                  itemBuilder: ((context, index) => InkWell(
                        onTap: () {
                          if (order == "") {
                            return;
                          }
                          setState(() {
                            id = orderList[index]["sortIndex"].toString();
                          });
                          _childController.updateCard(orderList[index]);
                          _childController.updateOrderNod(order);
                          widget.onselect(id);
                        },
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 10, 0),
                                child: RoundCheckBox(
                                  isChecked: id ==
                                      orderList[index]["sortIndex"].toString(),
                                  onTap: null,
                                  size: 16,
                                  checkedWidget: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  disabledColor: id ==
                                          orderList[index]["sortIndex"]
                                              .toString()
                                      ? Theme.of(context).colorScheme.secondary
                                      : Colors.white,
                                  checkedColor:
                                      Theme.of(context).colorScheme.secondary,
                                  border: Border.all(
                                      // width: 1,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                              ),
                              Text(
                                tr("ibutleractive.cardType", namedArgs: {
                                  "val": tr(
                                      "cardType${orderList[index]["cardType"]}")
                                }),
                                style: normalText(),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Text("|", style: normalText()),
                              ),
                              Text(
                                  tr("ibutleractive.buyNum", namedArgs: {
                                    "val":
                                        "${orderList[index]["buyNum"] - orderList[index]["remainingNum"]}"
                                  }),
                                  style: normalText()),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Text("|", style: normalText()),
                              ),
                              Text(
                                  tr("ibutleractive.remainingNum", namedArgs: {
                                    "val": "${orderList[index]["remainingNum"]}"
                                  }),
                                  style: normalText())
                            ],
                          ),
                        ),
                      ))))
        ],
      ),
    );
  }
}
