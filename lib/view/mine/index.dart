/*
 * @Author: FishHaveMine 751174479@qq.com
 * @Date: 2024-06-01 15:09:13
 * @LastEditors: FishHaveMine 751174479@qq.com
 * @LastEditTime: 2024-06-05 17:16:43
 * @FilePath: /fluoroscopy_tool/lib/view/mine/index.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/bottomSelectSheet.dart';
import 'package:fluoroscopy_tool/compent/fontSetting.dart';
import 'package:fluoroscopy_tool/config/config.dart';
import 'package:fluoroscopy_tool/store/globalData.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/store/http.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:fluoroscopy_tool/view/local/style.dart';
import 'package:fluoroscopy_tool/view/log/list.dart';
import 'package:fluoroscopy_tool/view/mine/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import 'package:get/get.dart';

import '../../style/index.dart';
import 'BackClip.dart';
import 'about.dart';

import 'package:file_picker/file_picker.dart';

import 'fileManage.dart';

import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluoroscopy_tool/config/config_dev.dart' as devConfig;
import 'package:fluoroscopy_tool/config/config_prod.dart' as prodConfig;

class minePgae extends StatefulWidget {
  const minePgae({super.key});

  @override
  State<minePgae> createState() => _minePgaeState();
}

class _minePgaeState extends State<minePgae> {
  // WidgetsToImageController to access widget
  WidgetsToImageController controller = WidgetsToImageController();

  static const platform = MethodChannel('com.example.usb_channel');
  String usbPath = '未开始';
  bool statr = false;

  final deviceInfoController _deviceInfoController = Get.find();
  // to save image bytes of widget
  Uint8List? bytes;
  Future<void> changeLocale(context) async {
    // if (_deviceInfoController.loacalDevice.value.isconnected) {
    //   divConfirmDialog(
    //     context,
    //     isSubmitButton: true,
    //     confirmTitle: tr("switchlange.tip"),
    //   ).then((value) => {
    //         if (value) {_toset()}
    //       });
    // } else {
    //   _toset();
    // }
    _toset();
  }

  _toset() async {
    final prefs = await SharedPreferences.getInstance();
    Future<sheetBack?> selectedIndex = await showCustomModalBottomSheet(
        isMultiple: false,
        context,
        [
          {'label': 'self.en', 'name': 'self.en', 'value': 1},
          {'label': 'self.cn', 'name': 'self.cn', 'value': 2},
        ],
        // ignore: unrelated_type_equality_checks
        baseValue: [
          EasyLocalization.of(context)?.currentLocale!.languageCode != 'zh'
              ? '1'
              : '2'
        ],
        titleName: tr('chooseLangage'));
    selectedIndex.then((value) => {
          if (value != null)
            {
              if (value.baseValue![0] == '1')
                {
                  prefs.setString('languageCode', 'en'),
                  EasyLocalization.of(context)?.setLocale(switchLanguage(0))
                }
              else if (value.baseValue![0] == '2')
                {
                  prefs.setString('languageCode', 'zh'),
                  EasyLocalization.of(context)?.setLocale(switchLanguage(1))
                }
            }
        });
  }

  Locale switchLanguage(int index) {
    switch (index) {
      case 0:
        return const Locale('en', 'US');
      case 1:
        return const Locale('zh', 'CN');
    }
    return const Locale('en', 'US');
  }

  Future<void> startUsbListener() async {
    try {
      setState(() {
        statr = true;
      });
      await platform.invokeMethod('setusdhost');
      Future.delayed(const Duration(seconds: 5));
      await platform.invokeMethod('startUsbListener');
    } on PlatformException catch (e) {
      print("启动监听失败: ${e.message}");
    }
  }

  Future<void> stopUsbListener() async {
    try {
      setState(() {
        statr = false;
      });
      await platform.invokeMethod('stopUsbListener');
    } on PlatformException catch (e) {
      print("停止监听失败: ${e.message}");
    }
  }

  String pathPDF = "";
  Future<File> fromAsset(String asset, String filename) async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  String _apiHost = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _apiHost = apiHost;
    });
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    fromAsset('assets/demo.pdf', 'demo.pdf').then((f) {
      print(f);
      setState(() {
        pathPDF = f.path;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 设置MethodCallHandler监听挂载事件
      platform.setMethodCallHandler((call) async {
        if (call.method == "onUsbMounted") {
          setState(() {
            usbPath = call.arguments ?? '未知路径';
          });
        }
      });
    });
  }

  @override
  void dispose() {
    // 停止监听
    if (statr) stopUsbListener();
    super.dispose();
  }

  String fileContent = '';
  String filefilePath = '';
  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any, // 可选择任何类型文件
      allowMultiple: false, // 是否允许多选
    );

    if (result != null) {
      // 获取文件路径
      final filePath = result.files.single.path!;
      // 读取文件内容
      final file = File(filePath);
      final content = "";

      setState(() {
        fileContent = content;
        filefilePath = filePath;
      });

      // 弹框显示文件内容
      _showContentDialog(content);
    } else {
      print("未选择任何文件");
    }
  }

  // 弹框显示文件内容
  void _showContentDialog(String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("文件内容"),
          content: SingleChildScrollView(
            child: Column(
              children: [Text(filefilePath), Text(content)],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("关闭"),
            ),
          ],
        );
      },
    );
  }

  late Directory documentsDirectory;

  _swicthdatacenter() async {
    String ct = apiHost == prodConfig.Config.baseUrl_eu ? 'US' : 'EU';
    String cttr = apiHost == prodConfig.Config.baseUrl_eu
        ? 'datacenter_us'
        : 'datacenter_eu';
    bool issend = await divConfirmDialog(context,
        isSubmitButton: true,
        confirmTitle: tr("device.controltDialog.confirmTitle"),
        confirmDescriptionWidget: SingleChildScrollView(
          child: Container(
              width: 560.w,
              height: 80,
              padding: EdgeInsets.fromLTRB(24.w, 24.w, 24.w, 0),
              child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                      style: normalTextBlack(),
                      text: tr('datacenter.seitch',
                          namedArgs: {"val": " ${tr(cttr)} "})))),
        ));
    if (issend) {
      await AppConfig.setcountry(ct); // 切换到欧洲
      apiHost = AppConfig.baseUrl; //云端请求的host
      MideaApi.init();
      inthttp();
    }
  }

  static const initplatform = MethodChannel('samples.flutter.dev/init');
  inthttp() async {
    final prefs = await SharedPreferences.getInstance();
    await initplatform.invokeMethod('init', <String, dynamic>{
      "issit":
          apiHost == "btri-dev.midea.com" || apiHost == "us-test.midea.com",
      "apiHost": apiHost,
      "token": prefs.getString('token'),
      "uid": prefs.getString('username'),
    });
    setState(() {
      _apiHost = apiHost;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WidgetsToImage(
        controller: controller,
        child: Container(
          height: 1280.h - 60,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('public/images/mineBg.png'),
                  fit: BoxFit.cover)),
          padding: EdgeInsets.fromLTRB(32.w, 0.h, 32.w, 50.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                  onLongPress: () {
                    Get.to(() => logpage());
                  },
                  child: SizedBox(
                    height: 344.h,
                    child: Center(
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.white),
                          child: Image.asset(
                            'public/images/header.png',
                            height: 188.w,
                          )),
                    ),
                  ),
                ),
                Container(
                  decoration: cardStyle(context),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 24.h),
                  child: Column(
                    children: [
                      const fontSetting(),
                      ListTile(
                        onTap: () {
                          // EasyLoading.showInfo(tr("codingtip.Text"));
                          // return;
                          changeLocale(context);
                        },
                        leading: Image.asset(
                          'public/images/icon/icon_language.png',
                          height: 48.w,
                        ),
                        title: const Text('menu_Language').tr(),
                        trailing: Image.asset(
                          'public/images/icon/rightP.png',
                          height: 48.w,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: cardStyle(context),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 24.h),
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0.h),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () async {
                          Get.to(() => account());
                        },
                        leading: Image.asset(
                          'public/images/icon/icon_Account.png',
                          height: 48.w,
                        ),
                        title: const Text('menu_Account').tr(),
                        trailing: Image.asset(
                          'public/images/icon/rightP.png',
                          height: 48.w,
                        ),
                      ),
                      ListTile(
                        onTap: () async {
                          Get.to(() => BackClip());
                        },
                        leading: Image.asset(
                          'public/images/icon/CommunicationDetection1.png',
                          height: 48.w,
                        ),
                        title: const Text('menu_ota').tr(),
                        trailing: Image.asset(
                          'public/images/icon/rightP.png',
                          height: 48.w,
                        ),
                      ),
                      ListTile(
                        onTap: () async {
                          Get.to(() => about());
                        },
                        leading: Image.asset(
                          'public/images/icon/icon_About.png',
                          height: 48.w,
                        ),
                        title: const Text('menu_app').tr(),
                        trailing: Image.asset(
                          'public/images/icon/rightP.png',
                          height: 48.w,
                        ),
                      ),
                      // TextButton(
                      //   onPressed: () {
                      //     if (!statr) {
                      //       startUsbListener();
                      //     } else {
                      //       stopUsbListener();
                      //     }
                      //   },
                      //   child: Text(usbPath),
                      // ),
                      // TextButton(
                      //   onPressed: () {
                      //     pickFile();
                      //   },
                      //   child: Text("选择文件"),
                      // )
                    ],
                  ),
                ),
                Container(
                  decoration: cardStyle(context),
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0.h),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () async {
                          Get.to(() => FileManage());
                        },
                        leading: Image.asset(
                          'public/images/icon/CommunicationDetection1.png',
                          height: 48.w,
                        ),
                        title: const Text('menu_file').tr(),
                        trailing: Image.asset(
                          'public/images/icon/rightP.png',
                          height: 48.w,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: cardStyle(context),
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0.h),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () async {
                          if (pathPDF.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PDFScreen(path: pathPDF),
                              ),
                            );
                          }
                        },
                        leading: Image.asset(
                          'public/images/icon/CommunicationDetection1.png',
                          height: 48.w,
                        ),
                        title: Text(tr('apphelp')),
                        trailing: Image.asset(
                          'public/images/icon/rightP.png',
                          height: 48.w,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: cardStyle(context),
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0.h),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () async {
                          _swicthdatacenter();
                        },
                        leading: Image.asset(
                          'public/images/icon/AftermarketReplacement.png',
                          height: 48.w,
                        ),
                        title: Text(tr('datacenter')),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  _apiHost == prodConfig.Config.baseUrl_eu
                                      ? "datacenter_eu"
                                      : "datacenter_us",
                                  textAlign: TextAlign.right,
                                ).tr(),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                'public/images/icon/rightP.png',
                                height: 48.w,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class PDFScreen extends StatefulWidget {
  final String? path;

  PDFScreen({Key? key, this.path}) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

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
        title: Text(
          tr('apphelp'),
          style: TextStyle(color: Color.fromARGB(255, 71, 49, 49)),
        ),
        centerTitle: true,
        actions: const [],
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: true,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage!,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation:
                true, // if set to true the link is handled in flutter
            backgroundColor: Colors.black,
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);

              //默认跳转到pdf第几页
              // pdfViewController.setPage(10);
            },
            onLinkHandler: (String? uri) {
              print('goto uri: $uri');
            },
            onPageChanged: (int? page, int? total) {
              print('page change: ${page ?? 0 + 1}/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container()
              : Center(
                  child: Text(errorMessage),
                )
        ],
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          return Container(
            width: 720.w,
            // color: Colors.black,
            padding: EdgeInsets.fromLTRB(32, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: () async {
                    await snapshot.data!.setPage(currentPage! - 1);
                  },
                  child: const Icon(Icons.arrow_back),
                ),
                FloatingActionButton(
                  onPressed: () async {
                    await snapshot.data!.setPage(currentPage! + 1);
                  },
                  child: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
