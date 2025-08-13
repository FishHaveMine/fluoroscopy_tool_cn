// ignore_for_file: use_build_context_synchronously

/*
 * @Author: FishHaveMine 751174479@qq.com
 * @Date: 2024-06-06 17:18:53
 * @LastEditors: FishHaveMine 751174479@qq.com
 * @LastEditTime: 2024-06-11 17:52:00
 * @FilePath: /fluoroscopy_tool/lib/view/local/checkData/index.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:external_path/external_path.dart';
import 'package:fluoroscopy_tool/compent/EmailInputDialog.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalData.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/view/local/checkData/IndoorUnitCentralControl/IndoorUnitCentralControl.dart';
import 'package:fluoroscopy_tool/view/local/checkData/class.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:fluoroscopy_tool/view/local/style.dart';
import 'package:fluoroscopy_tool/store/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_table/table_sticky_headers.dart';

// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_extend/share_extend.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';

class checkDataPage extends StatefulWidget {
  checkDataPage({super.key});

  @override
  State<checkDataPage> createState() => _checkDataPageState();
}

class _checkDataPageState extends State<checkDataPage> {
  bool isload = true;
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        isload = false;
      });
    });
    DateTime startTime = DateTime.now(); // 记录开始时间
  }

  final deviceInfoController _deviceInfoController = Get.find();
  @override
  Widget build(BuildContext context) {
    // Get height of app bar
    double appBarHeight = AppBar().preferredSize.height;

    // Calculate remaining height for page content
    double contentHeight = MediaQuery.of(context).size.height - appBarHeight;
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromRGBO(43, 103, 234, 1),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.chevron_left,
                      color: Colors.white, size: 36)),
              title: const Text('local.checkData').tr(),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
                child: Container(
              constraints: BoxConstraints(
                minHeight: contentHeight,
              ),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('public/images/devicePageBg.png'),
                      fit: BoxFit.fill)),
              child: Column(
                children: [
                  deviceVersion(),
                  const deviceInfoPage(),
                  const countODUandIDUPage(),
                  baseContainer(
                      child: const Divider(
                    color: Color.fromRGBO(238, 238, 238, 0.3),
                  )),
                  if (!isload) const tablePage(),
                ],
              ),
            ))));
  }
}

class deviceVersion extends StatefulWidget {
  deviceVersion({super.key});

  @override
  State<deviceVersion> createState() => _deviceVersionState();
}

class _deviceVersionState extends State<deviceVersion> {
  final deviceInfoController _deviceInfoController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(paddingLR, 54.h, paddingLR, 0),
      child: Row(
        key: ValueKey(
            'local.checkData${_deviceInfoController.updateTime.value}'),
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
            child: Image.asset(
              imageTurn(),
              width: 120.w,
            ),
          ),
          Expanded(
              child: Column(
            children: [
              SizedBox(
                height: 53.h,
                child: Row(children: [
                  Expanded(
                    child: Text(
                      _deviceInfoController.loacalDevice.value.machine,
                      style: versionTitle(context),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.fromLTRB(8, 0, 0, 0)),
                  // ignore: prefer_interpolation_to_compose_strings
                  Text(
                      tr('local.version') +
                          _deviceInfoController.loacalDevice.value.version,
                      style: versionValue(context))
                ]),
              ),
              const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 7)),
              Row(children: [
                Text(
                    _deviceInfoController.loacalDevice.value.model +
                        tr('local.model'),
                    style: versionValue(context)),
                const Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: SizedBox(
                    width: 1,
                    height: 11,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                    child: Text(
                        'SN ${_deviceInfoController.loacalDevice.value.sn.toUpperCase()}',
                        style: versionValue(context)))
              ])
            ],
          ))
        ],
      ),
    );
  }
}

class deviceInfoPage extends StatefulWidget {
  const deviceInfoPage({super.key});

  @override
  State<deviceInfoPage> createState() => _deviceInfoPageState();
}

class _deviceInfoPageState extends State<deviceInfoPage> {
  final deviceInfoController _deviceInfoController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(paddingLR, 30, paddingLR, 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(
                height: 48.h,
                child: Center(
                  child: Text(
                          _deviceInfoController.loacalDevice.value.isconnected
                              ? '${_deviceInfoController.loacalDevice.value.totalMatches.toStringAsFixed(1)}HP'
                              : '--',
                          style: versionValueBlock(context))
                      .tr(),
                ),
              ),
              SizedBox(
                height: 33.h,
                child: Center(
                  child: Text('totalMatches',
                          textAlign: TextAlign.center,
                          style: versionValue(context))
                      .tr(),
                ),
              )
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 48.h,
                child: Center(
                  child: Text(
                          _deviceInfoController.loacalDevice.value.isconnected
                              ? '${_deviceInfoController.loacalDevice.value.matchingNumber.toStringAsFixed(1)}%'
                              : '--',
                          style: versionValueBlock(context))
                      .tr(),
                ),
              ),
              SizedBox(
                height: 33.h,
                child: Center(
                  child: Text('matchingNumber',
                          textAlign: TextAlign.center,
                          style: versionValue(context))
                      .tr(),
                ),
              )
            ],
          ),
          Column(
            children: [
              if (_deviceInfoController.loacalDevice.value.isconnected &&
                  modeMap[_deviceInfoController
                          .loacalDevice.value.runningModel] !=
                      null)
                Image.asset(
                  'public/images/icon/${modeMap[_deviceInfoController.loacalDevice.value.runningModel]!['key']}.png',
                  width: 48.w,
                ),
              Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 4.h)),
              SizedBox(
                height: 33.h,
                child: Center(
                  child: Text(
                          '${_deviceInfoController.loacalDevice.value.isconnected && modeMap[_deviceInfoController.loacalDevice.value.runningModel] != null ? modeMap[_deviceInfoController.loacalDevice.value.runningModel]!['name'] : '--'}',
                          textAlign: TextAlign.center,
                          style: versionValue(context))
                      .tr(),
                ),
              )
            ],
          ),
          Column(
            children: [
              Image.asset(
                'public/images/icon/${_deviceInfoController.loacalDevice.value.isconnected ? 'connected' : 'disconnected'}.png',
                width: 48.w,
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 4.h)),
              SizedBox(
                height: 33.h,
                child: Center(
                  child: Text(
                          _deviceInfoController.loacalDevice.value.isconnected
                              ? 'connected'
                              : 'disconnected',
                          textAlign: TextAlign.center,
                          style: versionValue(context))
                      .tr(),
                ),
              )
            ],
          ),
          Column(
            children: [
              Image.asset(
                'public/images/checkData/error.png',
                width: 48.w,
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 4.h)),
              SizedBox(
                height: 33.h,
                child: Center(
                  child: Text(
                          _deviceInfoController.loacalDevice.value.errorCode ==
                                  "0"
                              ? '--'
                              : '${_deviceInfoController.loacalDevice.value.errorCode}',
                          textAlign: TextAlign.center,
                          style: versionValue(context))
                      .tr(),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class countODUandIDUPage extends StatefulWidget {
  const countODUandIDUPage({super.key});

  @override
  State<countODUandIDUPage> createState() => _countODUandIDUPageState();
}

class _countODUandIDUPageState extends State<countODUandIDUPage> {
  final deviceInfoController _deviceInfoController = Get.find();
  @override
  Widget build(BuildContext context) {
    return baseContainer(
        child: Row(
      children: [
        Text(
          '${tr('local.ODU')} ${_deviceInfoController.loacalDevice.value.ODU}  ${tr('local.IDU')} ${_deviceInfoController.loacalDevice.value.IDU}',
          style: versionValue(context),
        ),
      ],
    ));
  }
}

class tablePage extends StatefulWidget {
  const tablePage({super.key});

  @override
  State<tablePage> createState() => _tablePageState();
}

class _tablePageState extends State<tablePage> {
  // WidgetsToImageController to access widget
  WidgetsToImageController controller = WidgetsToImageController();
  // to save image bytes of widget

  static const platform = MethodChannel('samples.flutter.dev/battery');

  final deviceInfoController _deviceInfoController = Get.find();
  Uint8List? bytes;

  final MethodChannel methodChannel =
      const MethodChannel('sample.channel.data');
  Widget tableContainer = Container();
  @override
  void initState() {
    activeType = _deviceInfoController.deviceTypeEnum.value != 1
        ? "System"
        : "IndoorUnitParameters";
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _createDir();
      changActiveType(_deviceInfoController.deviceTypeEnum.value != 1
          ? "System"
          : "IndoorUnitParameters");
    });
    super.initState();
    // methodChannel.setMethodCallHandler((call) async {
    //   if (call.method == 'monitorData') {
    //   } else if (call.method == 'getConnection') {
    //     print('getConnection : ${call.arguments}');
    //     // _deviceInfoController.setIsConnected(call.arguments != null);
    //   }
    // });
  }

  late Directory documentsDirectory;
  /**判断文件夹是否存在，不存在则创建 */
  _createDir() async {
    if (!_deviceInfoController.isCreateSHARE.value) {
      documentsDirectory = await getApplicationDocumentsDirectory();
      String path = '${documentsDirectory.path}${Platform.pathSeparator}SHARE';
      var dir = Directory(path);
      var exist = dir.existsSync();
      _deviceInfoController.set_isCreateSHARE(true);
      if (exist) {
        print('当前文件夹已经存在');
      } else {
        var result = await dir.create();
      }
    } else {
      print('当前文件夹已经存在');
    }
  }

  /**根据文件名创建文件 */
  _createFile(fileName) async {
    try {
      documentsDirectory = await getApplicationDocumentsDirectory();
      String localFlieName = fileName;
      String path =
          '${documentsDirectory.path}${Platform.pathSeparator}SHARE${Platform.pathSeparator}${localFlieName}';

      final parentDir = await getApplicationSupportDirectory();
      File? file = File(path);
      bool exist = file.existsSync();
      if (exist) {
        DateTime now = DateTime.now();
        //获取当前时间的年
        int year = now.year;
        //获取当前时间的月
        int month = now.month;
        //获取当前时间的日
        int day = now.day;
        //获取当前时间的时
        int hour = now.hour;
        //获取当前时间的分
        int minute = now.minute;
        //获取当前时间的秒
        int millisecond = now.millisecond;
        String SendingTime = "$year$month$day$hour$minute$millisecond";
        localFlieName =
            '${localFlieName.split('.')[0]}_$SendingTime.${localFlieName.split('.')[1]}';
        path =
            '${documentsDirectory.path}${Platform.pathSeparator}SHARE${Platform.pathSeparator}${localFlieName}';
      }
      file = await File(path).create(recursive: true);
      return localFlieName;
    } catch (e) {
      print(e);
      return e;
    }
  }

/**写入文件 */
  _writeFile(FileName, nfcMock) async {
    try {
      documentsDirectory = await getApplicationDocumentsDirectory();
      String path =
          '${documentsDirectory.path}${Platform.pathSeparator}SHARE${Platform.pathSeparator}${FileName}';
      File? file = File(path);
      if (file.existsSync()) {
        file.writeAsBytes(nfcMock); //写入字符串
      }
      file = null;

      return path;
    } catch (e) {}
  }

  //将回调拿到的Uint8List格式的图片转换为File格式
  SaveImage(Uint8List imageByte) async {
    String loaclfileName = await _createFile('图片分享.jpg');
    EasyLoading.showProgress(0.3, status: '${tr('table.exportIng')} 30%');
    String path = await _writeFile(loaclfileName, imageByte);
    EasyLoading.showProgress(0.8, status: '${tr('table.exportIng')} 80%');

    File testFile = new File("$path");
    EasyLoading.showProgress(1, status: '${tr('table.exportIng')} 100%');
    await Future.delayed(const Duration(seconds: 1));
    EasyLoading.dismiss();
    ShareExtend.share(testFile.path, "file");
  }

  String activeType = "IndoorUnitParameters";

  CustomPopupMenuController _controller = CustomPopupMenuController();
  List<String> menuItems = [
    '导出当前时刻的运行数据',
    '导出最近一小时的运行数据',
  ];

  List titleColumn = [];
  List titleRow = [];
  List data = [];
  int widthsp = 4;
  changActiveType(val) {
    EasyLoading.show(status: 'loading...');
    activeType = val;
    refreshTable();
    EasyLoading.dismiss();
  }

  refreshTable() async {
    // EasyLoading.show(status: 'loading...');
    try {
      // await platform.invokeMethod('getPolling');
      // await Future.delayed(const Duration(seconds: 1), () {});
      var _base = List.from(localshowType);
      List headerList = _base
          .where((element) => element['key'] == activeType)
          .toList()[0]['children'];
      data = [];
      titleRow = [];

      if (activeType == "System" &&
          _deviceInfoController.outdoorEntityList.value.length == 1) {
        headerList.remove("System.salveSnList");
      }
      print(
          "headerList ${_deviceInfoController.outdoorEntityList.value.length}: $headerList");
      titleColumn = headerList;

      List tablebase = [];
      if (activeType == 'System') {
        tablebase = [_deviceInfoController.systemEntity];
      }
      if (['OutdoorUnit', 'Compressor', 'Sensor', 'ValveBody']
          .contains(activeType)) {
        tablebase = _deviceInfoController.outdoorEntityList;
      }
      if (['IndoorUnitParameters'].contains(activeType)) {
        tablebase = _deviceInfoController.indoorEntityList;
      }
      for (var i = 0; i < tablebase.length; i++) {
        List base = [];
        for (var element in headerList) {
          String elementKey = element.split('.')[1];
          base.add(
              '${tablebase[i][elementKey] ?? '--'} ${typeUnit[element] ?? ''}');
        }
        if (activeType == 'System') {
          titleRow.add('$i#');
        } else {
          titleRow.add("${tablebase[i]['address']}#");
        }
        data.add(base);
      }

      // titleRow = titleRow.length >= 2 ? titleRow.sublist(0, 2) : titleRow;
      setState(() {
        activeType;
        titleRow;
        data;
        titleColumn;
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  ScreenshotController screenshotController = ScreenshotController();
  static const _selfplatform = MethodChannel('samples.flutter.dev/BackClip');
  downlown(email) async {
    EasyLoading.show(status: 'loading...');
    try {
      var historyback =
          await _selfplatform.invokeMethod('getHistoryDataExcel', {});
      var historydata = jsonDecode(historyback);
      print("getHistoryDataExcel historydata： $historydata");
      EasyLoading.dismiss();
      if (historydata['errorCode'] != 200) {
        EasyLoading.showSuccess(
            tr("menu.export") + tr("unlockhistory.unlockerror"));
        //返回的是 file.absolutePath 弹框输入邮箱并发送
        return;
      } else {
        var uploadExcelFileback =
            await MideaApi.uploadExcelFile(historydata["data"]);

        print("getHistoryDataExcel uploadExcelFile： ${uploadExcelFileback}");
        if (uploadExcelFileback["errorCode"] == 200) {
          var fileurl = uploadExcelFileback["data"];
          var send = {"email": email, "excelUrl": fileurl};
          print("getHistoryDataExcel send： $send");
          var sendEmaileback = await MideaApi.sendEmail(send);
          print("getHistoryDataExcel sendEmaileback $sendEmaileback");
          //继续下一步  --- 发送到邮箱
          EasyLoading.showSuccess(
              tr("menu.export") + tr("unlockhistory.unlocksuccess"));
        } else {
          EasyLoading.showSuccess(
              tr("menu.export") + tr("unlockhistory.unlockerror"));
        }

        // await Future.delayed(const Duration(seconds: 2), () {
        //   print('One second has passed.'); // Prints after 1 second.
        // });
      }
    } catch (e) {
      print("getHistoryDataExcel error $e");
      EasyLoading.dismiss();
    }
  }

  Future<void> captureAndSaveTable() async {
    EasyLoading.show(status: 'loading...');
    try {
      // 请求权限
      var status = await Permission.storage.request();
      if (!status.isGranted) return;

      // 生成图片
      final Uint8List? image = await screenshotController.capture();
      if (image == null) return;

      // 获取公共目录路径（如 Downloads）
      final String downloadsDir =
          await ExternalPath.getExternalStoragePublicDirectory(
              ExternalPath.DIRECTORY_DOWNLOADS);
      final String filePath =
          '$downloadsDir/table_${activeType}_${DateTime.now().millisecondsSinceEpoch}.png';

      // 保存文件
      final File imgFile = File(filePath);
      await imgFile.writeAsBytes(image);

      EasyLoading.dismiss();
      EasyLoading.showSuccess('保存成功');
      print('保存成功: $filePath');
    } catch (e) {
      EasyLoading.showError('保存失败:$e');
      EasyLoading.dismiss();
    }
  }

  List<double> rowHeightsList(leng) {
    List<double> out = [];
    for (var i = 0; i < leng; i++) {
      out.add(50.0);
    }
    return out;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    // Get height of app bar
    double appBarHeight = AppBar().preferredSize.height;

    // Calculate remaining height for page content
    double contentHeight = MediaQuery.of(context).size.height -
        appBarHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return baseContainer(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                refreshTable();
              },
              child: Row(
                children: [
                  Image.asset(
                    'public/images/checkData/refresh_outlined.png',
                    width: 36.w,
                  ),
                  const Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
                  Text(
                    'table.refresh',
                    style: versionValue(context),
                  ).tr()
                ],
              ),
            ),
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      Get.to(() => const IndoorUnitCentralControl());
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          'public/images/checkData/controlAll.png',
                          width: 36.w,
                        ),
                        const Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
                        Text(
                          'table.controlAll',
                          style: versionValue(context),
                        ).tr()
                      ],
                    )),
                // GestureDetector(
                //   child: SizedBox(
                //     width: 36.w + 35,
                //     height: 30,
                //     child: Row(
                //       children: [
                //         Image.asset(
                //           'public/images/checkData/controlAll.png',
                //           width: 36.w,
                //         ),
                //         const Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
                //         Text(
                //           'table.controlAll',
                //           style: versionValue(context),
                //         ).tr()
                //       ],
                //     ),
                //   ),
                //   onTap: () {
                //     Get.to(() => const IndoorUnitCentralControl());
                //   },
                // ),
                const Padding(padding: EdgeInsets.fromLTRB(0, 0, 20, 0)),

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
                                    if (item == menuItems[1]) {
                                      if (_deviceInfoController
                                              .loacalDevice.value.model !=
                                          'V8') {
                                        EasyLoading.showError("当前仅支持V8协议");
                                        return;
                                      }
                                      bool ischeckNet = await checkNet(false);
                                      if (ischeckNet) {
                                        EmailInputDialog.show(
                                          context,
                                          onConfirm: (email) {
                                            downlown(email);
                                          },
                                        );
                                      } else {
                                        EasyLoading.showError(
                                            tr("netword.error"));
                                      }
                                    } else {
                                      captureAndSaveTable();
                                    }
                                  },
                                  child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                    child: Column(
                                      children: [
                                        Text(
                                          item,
                                          style: const TextStyle(fontSize: 14),
                                        ).tr(),
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 8, 0, 0),
                                          height: 1,
                                          color: item == menuItems[1]
                                              ? Colors.transparent
                                              : const Color.fromRGBO(
                                                  223, 223, 223, 1),
                                        )
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
                      Image.asset(
                        'public/images/checkData/import_export.png',
                        width: 36.w,
                      ),
                      const Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
                      Text(
                        'table.export',
                        style: versionValue(context),
                      ).tr()
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 28.h),
        ),
        Container(
            height: 72.h,
            decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 255, 255, 0.2),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: showType.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: Container(
                          height: 72.h,
                          width: (720.w - 32.w * 2 - showType.length + 1) /
                              showType.length,
                          decoration: BoxDecoration(
                            color: activeType == showType[index]['key']
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: index == 0
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8.0),
                                  )
                                : showType.length - 1 == index
                                    ? const BorderRadius.only(
                                        topRight: Radius.circular(8.0),
                                        bottomRight: Radius.circular(8.0),
                                      )
                                    : null,
                          ),
                          child: Center(
                              child: Text(
                            tr(showType[index]['name']),
                            style: activeType == showType[index]['key']
                                ? versionValueActive(context)
                                : versionValue(context),
                          )),
                        ),
                        onTap: () {
                          changActiveType(showType[index]['key']);
                        },
                      );
                    },
                    separatorBuilder: (context, index) => Container(
                      width: 1,
                      height: 72.h,
                      color: const Color.fromRGBO(238, 238, 238, 0.3),
                    ),
                  ),
                ),
              ],
            )),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 28.h),
        ),
        Screenshot(
            controller: screenshotController,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: titleColumn.isNotEmpty
                      ? Container(
                          color: Colors.white,
                          height: titleColumn.length * 50 + 80,
                          width: 720.w - 32.w * 2,
                          child: false
                              ? StickyHeadersTable(
                                  key: ValueKey(
                                      'checkDataPage_${_deviceInfoController.updateTime.value}'),
                                  cellDimensions: CellDimensions
                                      .variableColumnWidthAndRowHeight(
                                          columnWidths: List.generate(
                                              titleColumn.length,
                                              (index) =>
                                                  (720.w - 32.w * 2 - 10) /
                                                  widthsp),
                                          rowHeights:
                                              rowHeightsList(titleRow.length),
                                          stickyLegendWidth:
                                              (720.w - 32.w * 2 - 10) / 3,
                                          stickyLegendHeight: 72.h),
                                  columnsLength: titleColumn.length,
                                  rowsLength: titleRow.length,
                                  columnsTitleBuilder: (i) => Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color.fromRGBO(
                                            223, 223, 223, 1), // 边框颜色
                                        width: 0.5, // 边框宽度
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(0.0), // 圆角半径
                                    ),
                                    child: Center(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          titleColumn[i],
                                          textAlign: TextAlign.center,
                                          style: tableLabel(context),
                                        ).tr()
                                      ],
                                    )),
                                  ),
                                  rowsTitleBuilder: (i) => Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color.fromRGBO(
                                            223, 223, 223, 1), // 边框颜色
                                        width: 0.5, // 边框宽度
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(0.0), // 圆角半径
                                    ),
                                    child: Center(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 0),
                                          child: Text(titleRow[i],
                                              textAlign: TextAlign.center,
                                              style: tableLabel(context)),
                                        )
                                      ],
                                    )),
                                  ),
                                  contentCellBuilder: (i, j) => Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color.fromRGBO(
                                            223, 223, 223, 1), // 边框颜色
                                        width: 0.5, // 边框宽度
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(0.0), // 圆角半径
                                    ),
                                    child: GetBuilder<deviceInfoController>(
                                        builder: (_) {
                                      var xindex = j;
                                      var yindex = titleColumn[i]
                                          .toString()
                                          .split('.')[1];
                                      return Center(
                                          key: ValueKey(
                                              'checkDataPage$j $i _ ${_deviceInfoController.updateTime.value}'),
                                          child: handelTabelRow(
                                              '${_deviceInfoController.indoorEntityList[xindex][titleColumn[i].toString().split('.')[1]]}',
                                              yindex));
                                    }),
                                  ),
                                  legendCell: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color.fromRGBO(
                                              223, 223, 223, 1), // 边框颜色
                                          width: 0.5, // 边框宽度
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(0.0), // 圆角半径
                                      ),
                                      child: tableHeaderIndex()),
                                )
                              : StickyHeadersTable(
                                  key: ValueKey(
                                      'checkDataPage_${_deviceInfoController.updateTime.value}'),
                                  cellDimensions: CellDimensions
                                      .variableColumnWidthAndRowHeight(
                                          columnWidths: List.generate(
                                              titleRow.length,
                                              (index) =>
                                                  (720.w - 32.w * 2) /
                                                  (titleRow.length == 1
                                                      ? 2
                                                      : titleRow.length == 2
                                                          ? 3
                                                          : 4)),
                                          rowHeights: rowHeightsList(
                                              titleColumn.length),
                                          stickyLegendWidth:
                                              (720.w - 32.w * 2) /
                                                  (titleRow.length == 1
                                                      ? 2
                                                      : titleRow.length == 2
                                                          ? 3
                                                          : 4),
                                          stickyLegendHeight: 72.h),
                                  columnsLength: titleRow.length,
                                  rowsLength: titleColumn.length,
                                  columnsTitleBuilder: (i) => Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color.fromRGBO(
                                            223, 223, 223, 1), // 边框颜色
                                        width: 0.5, // 边框宽度
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(0.0), // 圆角半径
                                    ),
                                    child: Center(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          titleRow[i],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: tableLabel(context),
                                        ).tr()
                                      ],
                                    )),
                                  ),
                                  rowsTitleBuilder: (i) => Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color.fromRGBO(
                                            223, 223, 223, 1), // 边框颜色
                                        width: 0.5, // 边框宽度
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(0.0), // 圆角半径
                                    ),
                                    child: Center(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 0),
                                            child: SizedBox(
                                              width: (720.w - 32.w * 2) /
                                                      (titleRow.length == 1
                                                          ? 2
                                                          : titleRow.length == 2
                                                              ? 3
                                                              : 4) -
                                                  1,
                                              child: Text(titleColumn[i],
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          tableLabel(context))
                                                  .tr(),
                                            ))
                                      ],
                                    )),
                                  ),
                                  contentCellBuilder: (i, j) => Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color.fromRGBO(
                                            223, 223, 223, 1), // 边框颜色
                                        width: 0.5, // 边框宽度
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(0.0), // 圆角半径
                                    ),
                                    child: GetBuilder<deviceInfoController>(
                                        builder: (_) {
                                      var xindex = i;
                                      var yindex = titleColumn[j]
                                          .toString()
                                          .split('.')[1];
                                      return Center(
                                          key: ValueKey(
                                              'checkDataPage$j $i _ ${_deviceInfoController.updateTime.value}'),
                                          child: [
                                            'OutdoorUnit',
                                            'Compressor',
                                            'Sensor',
                                            'ValveBody',
                                            'IndoorUnitParameters'
                                          ].contains(activeType)
                                              ? handelTabelRow(
                                                  '${activeType == "IndoorUnitParameters" ? _deviceInfoController.indoorEntityList.isEmpty || _deviceInfoController.indoorEntityList[xindex] == null ? "--" : _deviceInfoController.indoorEntityList[xindex][yindex] : _deviceInfoController.outdoorEntityList.isEmpty || _deviceInfoController.outdoorEntityList[xindex] == null ? "--" : _deviceInfoController.outdoorEntityList[xindex][yindex]}',
                                                  yindex)
                                              : handelTabelRow(
                                                  '${_deviceInfoController.systemEntity[yindex]}',
                                                  yindex));
                                    }),
                                  ),
                                  legendCell: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color.fromRGBO(
                                              223, 223, 223, 1), // 边框颜色
                                          width: 0.5, // 边框宽度
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(0.0), // 圆角半径
                                      ),
                                      child: tableHeaderIndex(
                                        width: titleRow.length == 1
                                            ? (720.w - 32.w * 2) / 2
                                            : (720.w - 32.w * 2) /
                                                (titleRow.length == 1
                                                    ? 2
                                                    : titleRow.length == 2
                                                        ? 3
                                                        : 4),
                                        rightText: 'table.parameter',
                                        leftText: 'table.address',
                                      )),
                                ),
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
                                titleTextStyle: const TextStyle(
                                  fontSize: 22,
                                  color: Color(0xff9da9c7),
                                  fontWeight: FontWeight.w500,
                                ),
                                subtitleTextStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xffabb8d6),
                                ),
                              ),
                            ),
                          ),
                        )),
            ))
      ],
    ));
  }
}

TextStyle tableLabel(context) {
  return const TextStyle(
      color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400);
}

TextStyle tableValue(context) {
  return const TextStyle(
      color: Color.fromRGBO(136, 136, 136, 1),
      fontSize: 12,
      fontWeight: FontWeight.w400);
}
