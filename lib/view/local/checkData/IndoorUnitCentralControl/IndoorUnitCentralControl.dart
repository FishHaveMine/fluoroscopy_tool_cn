import 'package:easy_localization/easy_localization.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/compent/tap_handler_page.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/view/local/checkData/share.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:fluoroscopy_tool/view/local/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'conSendding.dart';

getActiveModImage(index) {
  if (index == 99) {
    return 'mode@2x';
  }
  return modeSettingMap[index]!.activeImage;
}

getActiveModeName(index) {
  if (index == 99) {
    return tr('device.checkData.mode');
  }
  return modeSettingMap[index]!.name;
}

getOnOFFModeImage(index) {
  if (index == 3) {
    return 'unlockon@2x';
  }
  return onOffSettingMap[index]!.activeImage;
}

getOnOFFModeName(index) {
  if (index == 3) {
    return tr('device.checkData.onoff');
  }
  return onOffSettingMap[index]!.name;
}

class IndoorUnitCentralControl extends StatefulWidget {
  const IndoorUnitCentralControl({super.key});

  @override
  State<IndoorUnitCentralControl> createState() =>
      _IndoorUnitCentralControlState();
}

class _IndoorUnitCentralControlState extends State<IndoorUnitCentralControl>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int activeIndex = 0;
  final checkDataController _checkDataController =
      Get.put(checkDataController());

  void _handelTabSelection() {
    if (_tabController.indexIsChanging) {
      _Controller.setSelect([]);
      _Controller.setShowingType(_tabController.index);
      _checkDataController.clearSetting();
      refresh();
      setState(() {
        activeIndex = _tabController.index;
      });
    }
  }

  final GlobalKey<_conpageLayoutState> _childKey =
      GlobalKey<_conpageLayoutState>();
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.white));

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handelTabSelection);
  }

  final checkDataController _Controller = Get.put(checkDataController());
  void refresh() {
    _childKey.currentState?.callChildMethod();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handelTabSelection);
    _tabController.dispose();

    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<checkDataController>(
        builder: (_) => WillPopScope(
            onWillPop: () async {
              return true;
            },
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.chevron_left,
                          color: Colors.black, size: 36)),
                  title: const Text(
                    'table.IndoorUnitCentralControl',
                    style: TextStyle(color: Colors.black),
                  ).tr(),
                  centerTitle: true,
                ),
                body: Column(
                  children: [
                    Container(
                        width: 720.w,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(35.w, 0, 35.w, 0),
                          child: Center(
                            child: Container(
                              width: 720.w,
                              decoration: const BoxDecoration(
                                  // color: Color.fromRGBO(230, 230, 230, 1),
                                  // borderRadius: BorderRadius.all(Radius.circular(3)),
                                  ),
                              child: TabBar(
                                indicatorWeight: 4, // 下划线高度
                                indicatorPadding: const EdgeInsets.symmetric(
                                    horizontal: 40), // 下划线左右间距
                                controller: _tabController,
                                indicatorColor: const Color.fromRGBO(
                                    18, 80, 123, 1), // 下划线颜色
                                labelColor:
                                    const Color.fromRGBO(18, 80, 123, 1),
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                                unselectedLabelColor:
                                    const Color.fromRGBO(13, 13, 13, 0.75),
                                unselectedLabelStyle: const TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 16),
                                isScrollable: false,
                                tabs: [
                                  Tab(
                                    child: const Text("device.checkData.menu1")
                                        .tr(),
                                  ),
                                  Tab(
                                    child: const Text("device.checkData.menu2")
                                        .tr(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                    Expanded(child: conpageLayout(key: _childKey)),
                  ],
                ))));
  }
}

class conpageLayout extends StatefulWidget {
  conpageLayout({super.key});

  @override
  State<conpageLayout> createState() => _conpageLayoutState();
}

class _conpageLayoutState extends State<conpageLayout> {
  final checkDataController _checkDataController =
      Get.put(checkDataController());

  void callChildMethod() {
    _childKey.currentState?.initTable();
  }

  final GlobalKey<_LandingPageState> _childKey = GlobalKey<_LandingPageState>();

  static const platform = MethodChannel('samples.flutter.dev/battery');
  @override
  Widget build(BuildContext context) {
    // Get height of app bar
    double appBarHeight = AppBar().preferredSize.height;

    // Calculate remaining height for page content
    double contentHeight = MediaQuery.of(context).size.height - appBarHeight;
    return GetBuilder<checkDataController>(
        builder: (_) => Container(
              color: const Color.fromRGBO(242, 242, 242, 1),
              height: contentHeight - 50,
              child: Column(
                children: [
                  Expanded(
                      child: Container(
                          width: double.infinity,
                          color: Colors.white,
                          child: LandingPage(key: _childKey))),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 25.h, 0, 25.h),
                    child: Container(
                      color: Colors.white,
                      height: 176.h,
                      width: double.infinity,
                      child: const controlPage(),
                    ),
                  ),
                  Container(
                    height: 57,
                    padding: EdgeInsets.fromLTRB(32.w, 0, 32.w, 8.h),
                    child: submitButton(
                      isActive:
                          _checkDataController.tableSelect.value.isNotEmpty,
                      label: tr('device.checkData.submit'),
                      onClick: () async {
                        List<String> item = [];
                        List asyncMethods = [];

                        if (_checkDataController.modeSetting.value != 99) {
                          item.add(getActiveModeName(
                                  _checkDataController.modeSetting.value) +
                              tr('device.checkData.mode'));
                        }
                        if (_checkDataController.onOff.value != 3) {
                          item.add(getOnOFFModeName(
                                  _checkDataController.onOff.value) +
                              '');
                        }
                        if (_checkDataController.tempSetting.value != 0.0) {
                          item.add(
                              '${tr('device.checkData.temp')}:${_checkDataController.tempSetting.value}°C');
                        }
                        if (_checkDataController.fanSetting.value != 9) {
                          item.add(
                              '${tr('device.checkData.fan')}:${_checkDataController.fanSetting.value == 8 ? '自动' : '${_checkDataController.fanSetting.value}档风'}');
                        }
                        if (_checkDataController.unlockon.value == 1) {
                          item.add(tr('device.checkData.unlockon'));
                          asyncMethods.add({
                            'name': 'device.checkData.unlockon',
                            'command': 'unLockOpenOrClose'
                          });
                        }
                        if (_checkDataController.unlockoff.value == 1) {
                          item.add(tr('device.checkData.unlockoff'));
                          if (!asyncMethods.any((element) =>
                              element['command'] == 'unLockOpenOrClose')) {
                            asyncMethods.add({
                              'name': 'device.checkData.unlockoff',
                              'command': 'unLockOpenOrClose'
                            });
                          }
                        }
                        if (_checkDataController.unlockwire.value == 1) {
                          item.add(tr('device.checkData.unlockwire'));
                          asyncMethods.add({
                            'name': 'device.checkData.unlockwire',
                            'command': 'unLockLineControl'
                          });
                        }
                        if (_checkDataController.unlockremote.value == 1) {
                          item.add(tr('device.checkData.unlockremote'));
                          asyncMethods.add({
                            'name': 'device.checkData.unlockremote',
                            'command': 'unLockRemoteControl'
                          });
                        }
                        if (_checkDataController.unlockmode.value == 1) {
                          item.add(tr('device.checkData.unlockmode'));
                          asyncMethods.add({
                            'name': 'device.checkData.unlockmode',
                            'command': 'unlockmode'
                          });
                        }
                        if (item.isEmpty ||
                            _checkDataController.tableSelect.isEmpty) {
                          return;
                        }
                        bool issend = await divConfirmDialog(context,
                            confirmTitle:
                                tr("device.checkDataController.confirmTitle"),
                            confirmDescriptionWidget: SingleChildScrollView(
                              child: SizedBox(
                                  width: 560.w,
                                  height: 130,
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(24),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            tr('device.checkDataController.content',
                                                namedArgs: {
                                                  'name': tr(item.join(',')),
                                                  'device':
                                                      '${_checkDataController.tableSelect.length}',
                                                }),
                                            style: dialogContent(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ));

                        if (issend) {
                          List<int> id = _checkDataController.tableSelect
                              .map((element) => int.parse(
                                  element.toString().replaceAll('#', '')))
                              .toList();
                          List errorCommand = [];
                          Map setting = {
                            'runMode': null,
                            'onOff': null,
                            'fanSpeed': null,
                            'tempValue': null,
                          };
                          bool needSetting = false;
                          if (_checkDataController.modeSetting.value != 99) {
                            needSetting = true;
                            setting['runMode'] =
                                _checkDataController.modeSetting.value;
                          }
                          if (_checkDataController.tempSetting.value != 0.0) {
                            needSetting = true;
                            setting['tempValue'] =
                                _checkDataController.tempSetting.value;
                          }
                          if (_checkDataController.onOff.value != 3) {
                            needSetting = true;
                            setting['onOff'] = _checkDataController.onOff.value;
                          }
                          if (_checkDataController.fanSetting.value != 9) {
                            needSetting = true;
                            setting['fanSpeed'] =
                                _checkDataController.fanSetting.value;
                          }
                          if (needSetting) {
                            try {
                              print('controlSet  ${setting}');
                              var settingback =
                                  await platform.invokeMethod('controlSet', {
                                'addressList': id,
                                'runMode': setting['runMode'],
                                'onOff': setting['onOff'],
                                'fanSpeed': setting['fanSpeed'],
                                'tempValue': setting['tempValue'],
                              });
                            } catch (e) {}
                          }
                          print("unLockLineControl asyncMethods:$asyncMethods");
                          for (var command in asyncMethods) {
                            try {
                              print("unLockLineControl: ${{
                                'command': command['command'],
                                'addressList': id,
                              }}");
                              var unlockwireback = await platform
                                  .invokeMethod('unLockLineControl', {
                                'command': command['command'],
                                'addressList': id,
                              });

                              print("unLockLineControl: $unlockwireback");
                              if (unlockwireback == false) {
                                errorCommand.add(command['name']);
                              }
                            } catch (e) {
                              errorCommand.add(command['name']);
                            }
                          }
                          if (errorCommand.isNotEmpty) {
                            print(errorCommand);

                            EasyLoading.showError(tr('load.error', namedArgs: {
                              'command': tr(errorCommand.join(',')),
                            }));
                          } else {
                            EasyLoading.showSuccess(tr('send.success'));
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            ));
  }
}

class controlPage extends StatefulWidget {
  const controlPage({super.key});

  @override
  State<controlPage> createState() => _controlPageState();
}

class _controlPageState extends State<controlPage> {
  final checkDataController _checkDataController =
      Get.put(checkDataController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<checkDataController>(
        builder: (_) => _checkDataController.showingType.value == 0
            ? Row(
                key: ValueKey(_checkDataController.modeSetting.value),
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  imageButton(
                    img: 'public/images/checkData/mode@2x.png',
                    img_active:
                        'public/images/checkData/${getActiveModImage(_checkDataController.modeSetting.value)}.png',
                    label: getActiveModeName(
                        _checkDataController.modeSetting.value),
                    imageWidth: 64.w,
                    isActive: _checkDataController.modeSetting.value != 99,
                    onClick: () {
                      if (_checkDataController.onOff.value != 0) {
                        modeSetting(context);
                      }
                    },
                  ),
                  imageButton(
                    img: 'public/images/checkData/unlockon@2x.png',
                    img_active:
                        'public/images/checkData/${getOnOFFModeImage(_checkDataController.onOff.value)}.png',
                    label: getOnOFFModeName(_checkDataController.onOff.value),
                    imageWidth: 64.w,
                    isActive: _checkDataController.onOff.value != 3,
                    onClick: () {
                      modeSetting(context, type: 2);
                    },
                  ),
                  imageButton(
                    img: 'public/images/checkData/settemp@2x.png',
                    label: tr('device.checkData.tempSetting'),
                    isActive: _checkDataController.tempSetting.value != 0.0,
                    text_active: _checkDataController.tempSetting.value == 0.0
                        ? null
                        : '${_checkDataController.tempSetting.value}°C',
                    imageWidth: 64.w,
                    onClick: () {
                      if (_checkDataController.onOff.value != 0) {
                        tempSetting(context);
                      }
                    },
                  ),
                  imageButton(
                    img: 'public/images/checkData/fan@2x.png',
                    label: _checkDataController.fanSetting.value != 9
                        ? _checkDataController.fanSetting.value == 8
                            ? tr('device.checkData.fanAuto')
                            : '${_checkDataController.fanSetting.value}${tr('device.checkData.fanSetting')}'
                        : tr('device.checkData.fan'),
                    isActive: _checkDataController.fanSetting.value != 9,
                    imageWidth: 64.w,
                    onClick: () {
                      if (_checkDataController.onOff.value != 0) {
                        fanSetting(context);
                      }
                    },
                  ),
                ],
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    imageButton(
                      img: 'public/images/checkData/unlockon@2x.png',
                      img_active:
                          'public/images/checkData/unlockon_active@2x.png',
                      label: tr('device.checkData.unlockon'),
                      isActive: _checkDataController.unlockon.value == 1,
                      imageWidth: 64.w,
                      itemWidth: 720.w / 5,
                      onClick: () {
                        _checkDataController.setunlockon(
                            _checkDataController.unlockon.value == 1 ? 0 : 1);
                      },
                    ),
                    imageButton(
                      img: 'public/images/checkData/unlockoff@2x.png',
                      img_active:
                          'public/images/checkData/unlockoff_active@2x.png',
                      label: tr('device.checkData.unlockoff'),
                      itemWidth: 720.w / 5,
                      isActive: _checkDataController.unlockoff.value == 1,
                      imageWidth: 64.w,
                      onClick: () {
                        _checkDataController.setunlockoff(
                            _checkDataController.unlockoff.value == 1 ? 0 : 1);
                      },
                    ),
                    imageButton(
                      img: 'public/images/checkData/unlockwire@2x.png',
                      img_active:
                          'public/images/checkData/unlockwire_active@2x.png',
                      label: tr('device.checkData.unlockwire'),
                      itemWidth: 720.w / 5,
                      isActive: _checkDataController.unlockwire.value == 1,
                      imageWidth: 64.w,
                      onClick: () {
                        _checkDataController.setunlockwire(
                            _checkDataController.unlockwire.value == 1 ? 0 : 1);
                      },
                    ),
                    imageButton(
                      img: 'public/images/checkData/unlockremote@2x.png',
                      img_active:
                          'public/images/checkData/unlockremote_active@2x.png',
                      label: tr('device.checkData.unlockremote'),
                      itemWidth: 720.w / 5,
                      isActive: _checkDataController.unlockremote.value == 1,
                      imageWidth: 64.w,
                      onClick: () {
                        _checkDataController.setunlockremote(
                            _checkDataController.unlockremote.value == 1
                                ? 0
                                : 1);
                      },
                    ),
                    imageButton(
                      img: 'public/images/checkData/unlockmode@2x.png',
                      img_active:
                          'public/images/checkData/unlockmode_active@2x.png',
                      label: tr('device.checkData.unlockmode'),
                      itemWidth: 720.w / 5,
                      isActive: _checkDataController.unlockmode.value == 1,
                      imageWidth: 64.w,
                      onClick: () {
                        _checkDataController.setunlockmode(
                            _checkDataController.unlockmode.value == 1 ? 0 : 1);
                      },
                    ),
                  ],
                ),
              ));
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final checkDataController _checkDataController =
      Get.put(checkDataController());

  final deviceInfoController _deviceInfoController = Get.find();

  List<String> selectIDs = [];
  List<String> tableRows = [];
  List<String> tableColumns = [
    'IndoorUnitParameters.onOff',
    'IndoorUnitParameters.mode',
    'IndoorUnitParameters.roomTemp',
    'IndoorUnitParameters.settingTemp',
    'IndoorUnitParameters.fanSpeed'
  ];

  List<List<String>> tableData = [];
  int key = 0;

  initTable() async {
    _checkDataController.setSelect([]);
    if (_checkDataController.showingType.value == 1) {
      tableColumns = [
        'IndoorUnitParameters.lockOpen',
        'IndoorUnitParameters.lockClose',
        'IndoorUnitParameters.lockLineControl',
        'IndoorUnitParameters.lockRemoteControl',
        'IndoorUnitParameters.lockRunMode'
      ];
    } else {
      tableColumns = [
        'IndoorUnitParameters.onOff',
        'IndoorUnitParameters.mode',
        'IndoorUnitParameters.roomTemp',
        'IndoorUnitParameters.settingTemp',
        'IndoorUnitParameters.fanSpeed'
      ];
    }
    tableData = [];
    tableRows = [];
    for (var element in _deviceInfoController.indoorEntityList) {
      List<String> rowitem = [];
      tableRows.add('${element['address']}#');
      for (var key in tableColumns) {
        String tableColumnskey = key.split('.')[1];
        String showingval = '';
        if (element[tableColumnskey].runtimeType == double) {
          showingval = element[tableColumnskey].toStringAsFixed(1);
        } else {
          showingval = element[tableColumnskey].toString() == 'null'
              ? '--'
              : element[tableColumnskey].toString();
        }
        rowitem.add(showingval);
      }
      tableData.add(rowitem);
    }
    key = DateTime.now().millisecondsSinceEpoch;
    selectIDs = [];
    setState(() {
      tableData;
      selectIDs;
      tableRows;
      tableColumns;
      key;
    });

    // EasyLoading.dismiss();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initTable();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: tableData.isNotEmpty
          ? TapHandlerPage(
              key: ValueKey('TapHandlerPage_$key'),
              titleColumn: tableColumns,
              titleRow: tableRows,
              data: tableData,
              onClick: (val) {
                if (selectIDs.contains(val)) {
                  selectIDs.remove(val);
                } else {
                  selectIDs.add(val);
                }
                setState(() {
                  selectIDs;
                });
                _checkDataController.setSelect(selectIDs);
              },
              selectAll: (val) {
                selectIDs = [];
                if (val) {
                  selectIDs = List<String>.from(tableRows);
                }
                setState(() {
                  selectIDs;
                });
                _checkDataController.setSelect(selectIDs);
              },
              selectIDs: selectIDs,
            )
          : Center(
              child: SizedBox(
                width: 320.w,
                height: 320.w,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 30.h, 0, 30.h),
                  child: EmptyWidget(
                    image: null,
                    packageImage: null,
                    title: tr('device.empty'),
                    titleTextStyle: TextStyle(
                      fontSize: EasyLocalization.of(context)
                                  ?.currentLocale!
                                  .languageCode ==
                              'zh'
                          ? 22
                          : 16,
                      color: const Color(0xff9da9c7),
                      fontWeight: FontWeight.w500,
                    ),
                    subtitleTextStyle: TextStyle(
                      fontSize: EasyLocalization.of(context)
                                  ?.currentLocale!
                                  .languageCode ==
                              'zh'
                          ? 14
                          : 12,
                      color: const Color(0xffabb8d6),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
