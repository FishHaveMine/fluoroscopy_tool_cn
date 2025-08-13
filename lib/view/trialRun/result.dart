import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalData.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class tryResult extends StatefulWidget {
  bool islocation; //是否本地报告
  String? sn;
  String? nid;
  tryResult({super.key, required this.islocation, this.sn, this.nid});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<tryResult> {
  late WebViewController _controller;

  static const _snplatform = MethodChannel('samples.flutter.dev/tryRunHandler');
  static const platform =
      MethodChannel('samples.flutter.dev/getProjectHandler');
  bool isloadfinish = false;

  late Directory documentsDirectory;

  final deviceInfoController _deviceInfoController = Get.find();

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

  _writeFile(FileName, nfcMock) async {
    print("_writeFile : $nfcMock");
    try {
      documentsDirectory = await getApplicationDocumentsDirectory();
      String path =
          '${documentsDirectory.path}${Platform.pathSeparator}SHARE${Platform.pathSeparator}${FileName}';
      print("path : $path");
      File? file = File(path);
      if (file.existsSync()) {
        file.writeAsString(nfcMock); //写入字符串
      }
      file = null;

      return path;
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();

    _createDir();
    WebView.platform = SurfaceAndroidWebView();
    EasyLoading.show(status: "loading...");

    if (widget.islocation) _loadhtmlstring();
    if (!widget.islocation) _loadcloud();
  }

  _sendemail(email) async {
    try {
      var data;
      if (reportUrl == "") {
        EasyLoading.show(status: "loading...");
        print("uploadTestRunFile htmldata: ${htmldata.runtimeType}");
        var send = {"data": htmldata};

        // String loaclfileName = await _createFile('tryrun.text');
        // _writeFile(loaclfileName, htmldata);

        var snback = await _snplatform.invokeMethod('uploadTestRunFile', send);
        data = jsonDecode(snback);
        print("uploadTestRunFile  data  :  $data");
        EasyLoading.dismiss();

        if (data["errorCode"] != null &&
            data["errorCode"].toString() == "1001") {
          //登录失效
          tologout();
        }
        if (!data['success']) {
          EasyLoading.showError(data['errorMsg']);
          return;
        }
        reportUrl = data['data'];
      }

      print("uploadTestRunFile  testRunReportSendEmail  :  ${{
        "email": email,
        "diviceSn": widget.sn ?? "",
        "reportUrl": reportUrl
      }}");
      var testRunReportSendEmailsnback = await _snplatform.invokeMethod(
          'testRunReportSendEmail', <String, dynamic>{
        "email": email,
        "diviceSn": widget.sn ?? "",
        "reportUrl": reportUrl
      });

      print("uploadTestRunFile  data  :  $data");
      var testRunReportSendEmaildata = jsonDecode(testRunReportSendEmailsnback);
      EasyLoading.dismiss();
      if (!testRunReportSendEmaildata['success']) {
        EasyLoading.showError(testRunReportSendEmaildata['errorMsg']);
      } else {
        EasyLoading.showSuccess(tr("uploadTestRunFile.showSuccess"));
      }
    } catch (e) {
      print("uploadTestRunFile  data  :  $e");
      EasyLoading.dismiss();
    }
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  _showbox() async {
    bool conn = await checkNet(true);
    if (!conn) {
      EasyLoading.dismiss();
      return;
    }
    String email = "";
    // ignore: use_build_context_synchronously
    bool back = await divConfirmDialog(context,
        confirmDescriptionWidget: emailInput(onselect: (val) {
      email = val;
    }), confirmTitle: tr("tryrun.emailconfirmTitle"));
    if (back) {
      if (isValidEmail(email)) {
        _sendemail(email);
      } else {
        EasyLoading.showError(tr("tryrun.emailtip"));
      }
    }
  }

  String reportUrl = "";
  String jpgBase64 = "";
  _loadcloud() async {
    EasyLoading.show(status: tr("trialRun.getreport.loading"));

    try {
      String nid = "";
      if (widget.nid == null) {
        var snJumpModuleback = await platform.invokeMethod(
            'getProfessionalToolsHandler.page',
            {"projectCode": "", "sn": widget.sn, "pageindex": 1});
        var snJumpModule = jsonDecode(snJumpModuleback);
        print("snJumpModuleback: $snJumpModule");

        for (var element in snJumpModule["data"]) {
          if (element["sn"] == widget.sn) {
            nid = element["nid"];
          }
        }
      } else {
        nid = widget.nid!;
      }
      print("getTrailOperationSimpleReport: sysid  $nid");

      var snback = await _snplatform.invokeMethod(
          'getTrailOperationSimpleReport', <String, dynamic>{"sysid": nid});
      var data = jsonDecode(snback);

      print("getTrailOperationSimpleReport: $data");

      for (var element in data["data"].keys) {
        print(
            "getTrailOperationSimpleReport  $element: ${data["data"][element]}");
      }
      if (data["success"]) {
        if (data["data"].toString() == "{}") {
          EasyLoading.dismiss();
          EasyLoading.showSuccess(
              tr("getTrailOperationSimpleReport.showempty"));
          return;
        }
        setState(() {
          htmldata = data["data"]["testJpgUrl"];
          reportUrl = data["data"]["testUrl"];
          jpgBase64 = data["data"]["jpgBase64"];
        });
        print("getTrailOperationSimpleReport: $htmldata");
        EasyLoading.dismiss();
        EasyLoading.showSuccess(
            tr("getTrailOperationSimpleReport.showSuccess"));
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(data["errorMsg"]);
      }
    } on PlatformException catch (e) {
      EasyLoading.dismiss();
    }
  }

  String htmlcontent = "";
  String htmldata = "";
  String innerHTML = "";
  Future<String> _loadhtmlstring() async {
    EasyLoading.show(status: tr("trialRun.getreport.loading"));

    try {
      var snback =
          await _snplatform.invokeMethod('getHtmlResult', <String, dynamic>{});
      var data = jsonDecode(snback);
      print("getHtmlResult: ${jsonEncode(data["data"])}");
      if (data["success"]) {
        setState(() {
          isloadfinish = true;
          htmldata = jsonEncode(data["data"]);
        });
        // _saveText();
        EasyLoading.dismiss();
        EasyLoading.showSuccess(tr("getHtmlResult.showSuccess"));
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(data["errorMsg"]);
      }
    } on PlatformException catch (e) {
      print("getHtmlResult: $e");
      EasyLoading.dismiss();
    }

    const String filePath = 'public/html/testRunReport.html';
    final String content = await rootBundle.loadString(filePath);
    htmlcontent = content.replaceAll("dataparamReplace", htmldata);
    return htmlcontent;
  }

  Future<void> _loadLocalHtml() async {
    if (htmlcontent == "") {
      await _loadhtmlstring();
    }
    final String uri = Uri.dataFromString(htmlcontent,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString();
    _controller.loadUrl(uri);
    // EasyLoading.dismiss();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _deviceInfoController.stopPolling();
    EasyLoading.dismiss();
  }

  Future<void> _captureWebViewScreenshot() async {
    if (widget.islocation) {
      if (_controller != null) {
        // 注入JavaScript来截取网页
        String base64Image = await _controller!.runJavascriptReturningResult('''
( function() {
 return imgdata;
  })();
      ''');
        innerHTML = await _controller!
            .evaluateJavascript('document.documentElement.outerHTML');
        // 处理base64图像数据
        if (base64Image != null && base64Image.isNotEmpty) {
          // 你可以将base64Image转换为图片，并保存或分享
          saveImageFromBase64(base64Image);
        }
      }
    } else {
      saveImageFromBase64(htmldata);
    }
  }

  Future<void> saveImageFromBase64(String base64String) async {
    var httpimage;
    if (base64String.startsWith("https://")) {
      try {
        // Fetch the image as bytes from the URL
        final response = await http.get(Uri.parse(base64String));

        // Check if the request was successful
        if (response.statusCode == 200) {
          // Convert the image bytes into a base64 string
          httpimage = response.bodyBytes;
        } else {
          throw Exception('Failed to load image');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
    final decodedBytes =
        httpimage ?? base64Decode(base64String.replaceAll("\"", ""));
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/screenshot.png');
    await file.writeAsBytes(decodedBytes);
    EasyLoading.showProgress(1, status: '${tr('table.exportIng')} 100%');
    await Future.delayed(const Duration(seconds: 3));
    EasyLoading.dismiss();
    ShareExtend.share(file.path, "file");
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
        title: const Text(
          'trialRun.getreport.title',
          style: TextStyle(color: Colors.black),
        ).tr(),
        centerTitle: true,
        actions: [],
      ),
      body: Container(
        width: 720.w,
        height: 1280.h,
        color: const Color.fromRGBO(244, 244, 244, 1),
        child: Column(
          children: [
            if (widget.islocation)
              Expanded(
                  child: isloadfinish
                      ? SizedBox(
                          width: 720.w,
                          height: 400,
                          child: WebView(
                              javascriptMode: JavascriptMode.unrestricted,
                              onWebViewCreated:
                                  (WebViewController webViewController) {
                                _controller = webViewController;
                                _loadLocalHtml();
                              },
                              onPageFinished: (String url) {
                                // 页面加载完成后的逻辑
                                print("onPageFinished:$url");
                              },
                              onPageStarted: (e) {
                                print("onPageStarted:$e");
                              },
                              onProgress: (e) {
                                print("onProgress:$e");
                              },
                              onWebResourceError: (e) {
                                print("onWebResourceError:$e");
                              }))
                      : Container()),
            if (!widget.islocation)
              Expanded(
                  child: Container(
                child: htmldata == ""
                    ? null
                    : FullScreenImageLocal(
                        imageUrl: htmldata,
                      ),
              )),
            Container(
              width: 720.w,
              height: 2,
              color: const Color.fromRGBO(244, 244, 244, 1),
            ),
            Container(
              height: 57,
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 134,
                    child: normalButton(
                      label: tr('trialRun.getreport.btn1'),
                      onClick: () async {
                        _showbox();
                        // EasyLoading.showInfo(tr("codingtip.Text"));
                      },
                    ),
                  ),
                  SizedBox(
                    width: 134,
                    child: submitButton(
                      isActive: true,
                      label: tr('trialRun.getreport.btn2'),
                      onClick: () async {
                        _captureWebViewScreenshot();
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

class FullScreenImageLocal extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageLocal({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {},
        child: Center(
          child: InteractiveViewer(
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                return Container(
                  width: 200,
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 50,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class emailInput extends StatefulWidget {
  Function onselect;
  emailInput({super.key, required this.onselect});

  @override
  State<emailInput> createState() => _checkOrderState();
}

class _checkOrderState extends State<emailInput> {
  String id = "";
  final _formKey = GlobalKey<FormState>();
  String? _errorText;

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'tryrun.email',
                style: normalTextBlack(),
              ).tr(),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 12.h, 0, 12.h),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(227, 236, 250, 1),
                      borderRadius: BorderRadius.circular(8), // 圆角边框
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: tr('input.hintText'),
                        border: InputBorder.none, // 去掉默认的下划线边框
                        errorText: _errorText, // 动态错误提示
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return tr('tryrun.emailtip');
                        } else if (!isValidEmail(value)) {
                          return tr('tryrun.emailtip');
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          if (val.isEmpty) {
                            _errorText = tr('tryrun.emailtip');
                          } else if (!isValidEmail(val)) {
                            _errorText = tr('tryrun.emailtip');
                          } else {
                            _errorText = null; // 校验通过，无错误提示
                          }
                        });
                        if (_errorText == null) {
                          setState(() {
                            id = val;
                          });
                          widget.onselect(id);
                        }
                      },
                    ),
                  )),
            ],
          )),
    );
  }
}
