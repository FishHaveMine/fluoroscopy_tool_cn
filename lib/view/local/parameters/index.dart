/*
 * @Author: FishHaveMine 751174479@qq.com
 * @Date: 2024-06-08 14:35:47
 * @LastEditors: FishHaveMine 751174479@qq.com
 * @LastEditTime: 2024-06-11 14:11:41
 * @FilePath: /fluoroscopy_tool/lib/view/local/parameters/index.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'dart:convert';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/bottomSelectSheet.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/view/afterSalesReplacement/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../publicFunction.dart';
import '../style.dart';
import 'style.dart';

import 'package:get/get.dart';

/// 本地参数设置页面、设置系统的协议、内机数、地址等参数

// ODU(0), 单纯设置设备地址 deviceAddress   设置设备地址方法 setOduDeviceAddress
// IDU(1), 单纯设置设备地址 deviceAddress 设置设备地址方法 setOduDeviceAddress
// SYS(2); 可设置全部  设置设备地址方法 setOduDeviceAddress
class parametersPage extends StatefulWidget {
  bool? iscom = null;
  parametersPage({super.key, this.iscom});

  @override
  State<parametersPage> createState() => _ParametersPageState();
}

class _ParametersPageState extends State<parametersPage> {
  var isusetocom = false;
  static const platform = MethodChannel('samples.flutter.dev/battery');
  CustomPopupMenuController _controller = CustomPopupMenuController();
  List<String> menuItems = [
    'parametersPage.actionsText1',
    'parametersPage.actionsText2',
  ];
  final GlobalKey<_deviceInfoSettingState> _childKey =
      GlobalKey<_deviceInfoSettingState>();
  Future<void> _refresh() async {
    _childKey.currentState?.init();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isusetocom = widget.iscom ?? false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    clearmission();
  }

  handelMenu(type) async {
    try {
      var AddressChangeBack = await platform.invokeMethod(
          type == 'parametersPage.actionsText1'
              ? 'clearIndoorAddress'
              : 'indoorAutoSearchAddress');

      EasyLoading.showSuccess(tr("setparameters.success"));
    } catch (e) {}
    // setmission(30, () async {
    //   var AddressChangeBack = await platform.invokeMethod(
    //       type == 'parametersPage.actionsText1'
    //           ? 'clearIndoorAddress'
    //           : 'indoorAutoSearchAddress');
    // }, () {});
  }

  @override
  Widget build(BuildContext context) {
    // Get height of app bar
    double appBarHeight = AppBar().preferredSize.height;

    // Calculate remaining height for page content
    double contentHeight = MediaQuery.of(context).size.height - appBarHeight;
    return WillPopScope(
        onWillPop: () async {
          Get.offAllNamed('/home'); //
          return false;
        },
        child: Scaffold(
            appBar: !isusetocom
                ? AppBar(
                    backgroundColor: Colors.white,
                    leading: IconButton(
                        onPressed: () {
                          Get.offAllNamed('/home'); //
                        },
                        icon: const Icon(Icons.chevron_left,
                            color: Colors.black, size: 36)),
                    title: const Text(
                      'local.parameters',
                      style: TextStyle(color: Colors.black),
                    ).tr(),
                    centerTitle: true,
                    actions: [
                      CustomPopupMenu(
                        horizontalMargin: 10.0,
                        verticalMargin: 0.0,
                        arrowColor: Colors.white,
                        menuBuilder: () => ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            color: Colors.white,
                            child: IntrinsicWidth(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: menuItems
                                    .map(
                                      (item) => GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () async {
                                          _controller.hideMenu();
                                          bool isSend = await divConfirmDialog(
                                              context,
                                              confirmTitle: tr(
                                                  "device.controltDialog.confirmTitle"),
                                              confirmText: tr("determine"),
                                              confirmDescriptionWidget:
                                                  SizedBox(
                                                width: 560.w,
                                                height: 96.h,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 0, 16),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        tr('device.controltDialog.confirmText',
                                                            namedArgs: {
                                                              'name': tr(item)
                                                            }),
                                                        style: dialogContent(
                                                            context),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ));
                                          if (isSend) {
                                            handelMenu(item);
                                          }
                                        },
                                        child: Container(
                                          height: 40,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Container(
                                                  // margin:
                                                  //     const EdgeInsets.only(left: 10),
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  child: Text(
                                                    tr(item),
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                        pressType: PressType.singleClick,
                        controller: _controller,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 32.w, 10),
                              child: Image.asset(
                                'public/images/parametersPage/Autofindadress.png',
                                width: 36.w,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                : null,
            body: RefreshIndicator(
                onRefresh: _refresh,
                child: SingleChildScrollView(
                    child: Container(
                  color: const Color.fromRGBO(246, 246, 246, 1),
                  height: isusetocom ? 1280.h - 280 : 1280.h - 80,
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.fromLTRB(0, 24.w, 0, 0)),
                      if (!isusetocom) const devceInfoCard(),
                      Expanded(child: deviceInfoSetting(key: _childKey))
                    ],
                  ),
                )))));
  }
}

class devceInfoCard extends StatefulWidget {
  const devceInfoCard({super.key});

  @override
  State<devceInfoCard> createState() => _devceInfoCardState();
}

class _devceInfoCardState extends State<devceInfoCard> {
  static const platform = MethodChannel('samples.flutter.dev/battery');
  final deviceInfoController _deviceInfoController = Get.find();

  @override
  Widget build(BuildContext context) {
    return baseContainer(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: EdgeInsets.all(24.w),
              height: 240.h,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 16.h),
                    child: Text(
                      'parametersPage.devceInfoTitle',
                      style: devceInfoCardTitle(context),
                    ).tr(),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 16.h),
                    child: Row(
                      children: [
                        Text('parametersPage.devceInfolabel1',
                                style: devceInfoCardLabel(context))
                            .tr(),
                        Expanded(
                          child: Text(
                              _deviceInfoController.loacalDevice.value.sn
                                  .toUpperCase(),
                              maxLines: 2,
                              style: devceInfoCardValue(context)),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Row(
                      children: [
                        Text('parametersPage.devceInfolabel2',
                                style: devceInfoCardLabel(context))
                            .tr(),
                        Text(
                                _deviceInfoController.deviceTypeEnum.value == 2
                                    ? 'parametersPage.SYS'
                                    : _deviceInfoController
                                                .deviceTypeEnum.value ==
                                            0
                                        ? 'parametersPage.ODU'
                                        : 'parametersPage.IDU',
                                style: devceInfoCardValue(context))
                            .tr(),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}

class deviceInfoSetting extends StatefulWidget {
  deviceInfoSetting({super.key});

  @override
  State<deviceInfoSetting> createState() => _deviceInfoSettingState();
}

/**
 * 设备地址、网络地址下发都会导致主板重启
 */
class _deviceInfoSettingState extends State<deviceInfoSetting> {
  var Settings;

  static const platform = MethodChannel('samples.flutter.dev/battery');
  final deviceInfoController _deviceInfoController = Get.find();

  List connectionSettingsType = [
    'V8协议-PQ接线',
    'V6协议',
    'V8协议-M1M2接线-内机统一供电',
    'V8协议-M1M2接线-内机独立供电'
  ];
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    // EasyLoading.show(status: 'loading...');
    try {
      var getParametersPageInfo =
          await platform.invokeMethod('getParametersPageInfo');
      if (getParametersPageInfo != null) {
        var data = jsonDecode(getParametersPageInfo);
        setState(() {
          Settings = {
            "connectionSettings": data["data"]["linkSetting"] != null &&
                    connectionSettingsType.contains(data["data"]["linkSetting"])
                ? connectionSettingsType.indexOf(data["data"]["linkSetting"])
                : -1, // V8_PQ，  V6 ，  V8_M1M2_Multi，V8_M1M2_Single
            "deviceAddress":
                data["data"]["deviceAddress"] ?? 0, // 系统和外机 0 - 3   ， 内机 0 - 63
            "networkAddress": data["data"]["networkAddress"] ?? 0, // 0 - 7
            "indoorNum": data["data"]["settingIndoorNum"] ?? "--", // 0 - 63
            "indoorVipAddress": data["data"]["indoorVipAddress"] ?? 0
          };
        }); // 0 - 63
      }
      ;
    } catch (e) {}
    // EasyLoading.dismiss();
  }

  var setting = {};
  AddressChange(String key, int parse) async {
    setState(() {
      setting[key] = parse;
      Settings[key] = parse;
    });
    print("AddressChange : $setting $Settings");
  }

  toSetting() async {
    if (setting.isNotEmpty) {
      EasyLoading.show(status: 'loading...');
      var AddressChangeBack =
          await platform.invokeMethod('setParametersPageInfo', setting);
      var data = jsonDecode(AddressChangeBack);

      if (data["data"]) {
        EasyLoading.dismiss();
        EasyLoading.showSuccess(tr("setparameters.success"));
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(tr("setparameters.error"));
      }
      // setmission(setting["deviceAddress"] != null ? 180 : 30, () async {
      //   var AddressChangeBack =
      //       await platform.invokeMethod('setParametersPageInfo', setting);
      // }, () {
      //   init();
      // });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    clearmission();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey("setting_${Settings['deviceAddress']}"),
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: Settings == null
          ? []
          : [
              baseContainer(
                child: Text(
                  'parametersPage.settingTitle',
                  style: settingTitle(context),
                ).tr(),
              ),
              settingBox(
                label: tr('parametersPage.settingLabel2'),
                onclick: () async {
                  List op = [];
                  int addresslimit = 4;
                  if (_deviceInfoController.deviceTypeEnum.value == 1) {
                    addresslimit = 65;
                  }
                  for (var i = 0; i < addresslimit; i++) {
                    op.add({'label': tr('$i#'), 'name': tr('$i#'), 'value': i});
                  }
                  Future<sheetBack?> selectedIndex =
                      await showCustomModalBottomSheet(
                          isMultiple: false,
                          context,
                          [...op],
                          // ignore: unrelated_type_equality_checks
                          baseValue: [Settings['deviceAddress'].toString()],
                          titleName: tr('parametersPage.settingLabel2'));
                  selectedIndex.then((value) => {
                        if (value != null &&
                            value.baseValue![0] != -1 &&
                            Settings['deviceAddress'].toString() !=
                                value.baseValue![0].toString())
                          {
                            AddressChange(
                                'deviceAddress', int.parse(value.baseValue![0]))
                          }
                      });
                },
                value: '${Settings['deviceAddress']}#',
              ),
              if ((_deviceInfoController.deviceTypeEnum.value == 2 ||
                      _deviceInfoController.deviceTypeEnum.value == 0) &&
                  Settings['deviceAddress'].toString() == "0")
                settingBox(
                  label: tr('parametersPage.settingLabel1'),
                  onclick: () async {
                    List op = [];
                    for (var i = 0; i < 8; i++) {
                      op.add(
                          {'label': tr('$i#'), 'name': tr('$i#'), 'value': i});
                    }
                    Future<sheetBack?> selectedIndex =
                        await showCustomModalBottomSheet(
                            isMultiple: false,
                            context,
                            [...op],
                            // ignore: unrelated_type_equality_checks
                            baseValue: [Settings['networkAddress'].toString()],
                            titleName: tr('parametersPage.settingLabel1'));
                    selectedIndex.then((value) => {
                          if (value != null &&
                              value.baseValue![0] != -1 &&
                              Settings['networkAddress'].toString() !=
                                  value.baseValue![0].toString())
                            {
                              AddressChange('networkAddress',
                                  int.parse(value.baseValue![0]))
                            }
                        });
                  },
                  value: '${Settings['networkAddress']}#',
                ),
              if ((_deviceInfoController.deviceTypeEnum.value == 2 ||
                      _deviceInfoController.deviceTypeEnum.value == 0) &&
                  Settings['deviceAddress'].toString() == "0")
                settingBox(
                  label: tr('parametersPage.settingLabel3'),
                  onclick: () async {
                    List op = [];
                    int addresslimit = 65;

                    for (var i = 1; i < addresslimit; i++) {
                      op.add({'label': tr('$i'), 'name': tr('$i'), 'value': i});
                    }
                    Future<sheetBack?> selectedIndex =
                        await showCustomModalBottomSheet(
                            isMultiple: false,
                            context,
                            [...op],
                            // ignore: unrelated_type_equality_checks
                            baseValue: [Settings['indoorNum'].toString()],
                            titleName: tr('parametersPage.settingLabel3'));
                    selectedIndex.then((value) => {
                          if (value != null &&
                              value.baseValue![0] != -1 &&
                              Settings['indoorNum'].toString() !=
                                  value.baseValue![0].toString())
                            {
                              AddressChange(
                                  'indoorNum', int.parse(value.baseValue![0]))
                            }
                          else
                            {}
                        });
                  },
                  value: Settings['indoorNum'].toString(),
                ),
              if ((_deviceInfoController.deviceTypeEnum.value == 2 ||
                      _deviceInfoController.deviceTypeEnum.value == 0) &&
                  Settings['deviceAddress'].toString() == "0")
                settingBox(
                  label: tr('parametersPage.settingLabel4'),
                  onclick: () async {
                    List op = [];
                    int addresslimit = 64;

                    for (var i = 0; i < addresslimit; i++) {
                      op.add(
                          {'label': tr('$i#'), 'name': tr('$i#'), 'value': i});
                    }
                    Future<sheetBack?> selectedIndex =
                        await showCustomModalBottomSheet(
                            isMultiple: false,
                            context,
                            [...op],
                            // ignore: unrelated_type_equality_checks
                            baseValue: [
                              Settings['indoorVipAddress'].toString()
                            ],
                            titleName: tr('parametersPage.settingLabel4'));
                    selectedIndex.then((value) => {
                          if (value != null &&
                              value.baseValue![0] != -1 &&
                              Settings['indoorVipAddress'].toString() !=
                                  value.baseValue![0].toString())
                            {
                              AddressChange('indoorVipAddress',
                                  int.parse(value.baseValue![0]))
                            }
                        });
                  },
                  value: "${Settings['indoorVipAddress']}#",
                ),
              if ((_deviceInfoController.deviceTypeEnum.value == 2 ||
                      _deviceInfoController.deviceTypeEnum.value == 0) &&
                  Settings['deviceAddress'].toString() == "0")
                settingBox(
                  label: tr('parametersPage.settingLabel5'),
                  onclick: () async {
                    List op = [
                      {'label': tr('V8_PQ'), 'name': tr('V8_PQ'), 'value': 0},
                      {'label': tr('V6_PQ'), 'name': tr('V6_PQ'), 'value': 1},
                      {
                        'label': tr('V8_M1M2_Multi'),
                        'name': tr('V8_M1M2_Multi'),
                        'value': 2
                      },
                      {
                        'label': tr('V8_M1M2_Single'),
                        'name': tr('V8_M1M2_Single'),
                        'value': 3
                      }
                    ];
                    Future<sheetBack?> selectedIndex =
                        await showCustomModalBottomSheet(
                            isMultiple: false,
                            context,
                            [...op],
                            // ignore: unrelated_type_equality_checks
                            baseValue: [
                              // ignore: unrelated_type_equality_checks
                              Settings['connectionSettings'].toString() == -1
                                  ? '0'
                                  : Settings['connectionSettings'].toString()
                            ],
                            titleName: tr('parametersPage.settingLabel5'));
                    selectedIndex.then((value) => {
                          if (value != null &&
                              value.baseValue![0] != -1 &&
                              Settings['connectionSettings'].toString() !=
                                  value.baseValue![0].toString())
                            {
                              AddressChange('connectionSettings',
                                  int.parse(value.baseValue![0]))
                            }
                        });
                  },
                  value: Settings['connectionSettings'].toString() == '-1'
                      ? '--'
                      : connectionSettingsType[
                          int.parse(Settings['connectionSettings'].toString())],
                ),
              Expanded(
                  child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 57,
                      padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                      child: Center(
                        child: submitButton(
                          isActive: setting.isNotEmpty,
                          label: tr('parametersSetting.btn'),
                          onClick: () async {
                            toSetting();
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ))
            ],
    );
  }
}

class settingBox extends StatelessWidget {
  TextStyle? labelstyle;
  double? height;
  String label;
  String value;
  VoidCallback onclick;
  settingBox(
      {super.key,
      this.height,
      this.labelstyle,
      required this.label,
      required this.value,
      required this.onclick});

  @override
  Widget build(BuildContext context) {
    bool isCN =
        EasyLocalization.of(context)?.currentLocale!.languageCode == 'zh';
    return Container(
      width: 720.w,
      height: height ?? 96.h,
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Color.fromRGBO(223, 223, 223, 1),
              width: 0.5,
            ),
          )),
      child: ListTile(
        onTap: () => onclick(),
        title: Text(
          label,
          style: labelstyle ?? titleStyle(Size: isCN ? 16 : 12),
        ),
        trailing: SizedBox(
          width: 400.w,
          height: height ?? 96.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: settingTitle(context),
                ).tr(),
              )),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Color.fromRGBO(204, 204, 204, 1),
              )
            ],
          ),
        ),
      ),
    );
  }
}
