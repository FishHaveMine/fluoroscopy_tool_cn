/*
 * @Author: FishHaveMine 751174479@qq.com
 * @Date: 2023-03-01 16:27:06
 * @LastEditors: FishHaveMine 751174479@qq.com
 * @LastEditTime: 2024-06-04 17:39:01
 * @FilePath: /kong_matser/lib/globalData.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/view/UpdateInProgressPage.dart';
import 'package:fluoroscopy_tool/view/userinfo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:get/get.dart' hide Response;

/**
 * APP升级判断 校验 externalVersion 和 internalVersion
 */
// internalVersion	string	版本号	(例如:2或者3)
// externalVersion	string	版本名称	(例如:1.0.0或者1.0.1)
// file_Url apk文件路径
String externalVersion = '';
String internalVersion = '';
String apiHost = ""; //btri-dev   mibp.midea.com
String file_Url = '';
bool istoupdata = true;
final options = BaseOptions(
  baseUrl: 'https://${apiHost}/api/apps-version-manager/',
  connectTimeout: const Duration(seconds: 30),
  receiveTimeout: const Duration(seconds: 60),
);
final dio = Dio(options);

Future<bool> checkNet(show) async {
  try {
    bool isnetconnecd = true;
    final response = await Dio().get('https://${apiHost}/');
    isnetconnecd = response.statusCode == 200;

    return isnetconnecd;
  } catch (e) {
    print(e);

    return false;
  }
}

class GlobalData with ChangeNotifier, DiagnosticableTreeMixin {
  //是否已经登录
  String activeThemeData = 'white';
  String get GlobalData_activeThemeData => activeThemeData;
  void setGlobalData_FontFamily(value) {
    activeThemeData = value;
    notifyListeners();
  }

  //是否已经登录
  String activeFonta = 'PingFangMedium';
  String get GlobalData_activeFonta => activeFonta;
  void setGlobalData_activeFonta(value) {
    activeFonta = value;
    notifyListeners();
  }

  bool randomBool(double probability) {
    Random random = Random();
    return random.nextDouble() < probability;
  }

  bool _hasLogin = false;
  bool get isLogin => _hasLogin;
  Future<void> initLogin(context) async {
    final prefs = await SharedPreferences.getInstance();

    final userinfoController _controller = Get.put(userinfoController());
    int? timestamp = await prefs.getInt('logintime');

    if (timestamp != null) {
      int nowtimestamp = DateTime.now().millisecondsSinceEpoch;
      // 计算两个时间戳的差值（取绝对值，因为时间戳大小不确定）
      int difference = (nowtimestamp - timestamp).abs();
      // 计算差值对应的天数
      double differenceInDays = difference / (24 * 60 * 60 * 1000);
      // 判断是否超过一天
      if (differenceInDays > 1) {
        // prefs.clear();
        prefs.remove('token');
        _hasLogin = false;
        // _hasLogin = true;
        notifyListeners();
        Get.offAllNamed('/login'); //
      } else {
        _hasLogin = prefs.getString('token') != null;
        var _permissions = prefs.getString('permissions');
        if (_permissions != null) {
          _controller.set_userPromission(jsonDecode(_permissions));
        } else {
          _controller.set_userPromission([]);
        }
        // _hasLogin = true;
        notifyListeners();
      }
    } else {
      prefs.clear();
      _hasLogin = false;
      notifyListeners();
    }
  }

  void userIsLogin(value) {
    _hasLogin = value;
    notifyListeners();
  }
}

String? validateEmpty(value) {
  if (value == null || value.isEmpty) {
    return tr('input.empty');
  }
  return null;
}

void _launchURL(String url) async {
  await launch(url);
}

checkversion(context) async {
  print("checkversion: $externalVersion  -- $internalVersion");
  if (externalVersion == "" || internalVersion == "") {
    return;
  }
  try {
    Response response = await dio.post('/v1/app/use/getLatest', data: {
      "appId": "fluoroscopy_tool",
      "channelId": "4",
    });

    print("checkversion: $response");
    if (response.data['success'] && response.data['data'] != null) {
      file_Url = response.data['data']['fileUrl'];
      String external_Version = response.data['data']['externalVersion'];
      String internal_Version = response.data['data']['internalVersion'];
      String upgrade = response.data['data']['upgrade'].toString();
      print(
          "${int.parse(internal_Version)} > ${int.parse(internalVersion)} : ${external_Version != externalVersion || int.parse(internal_Version) > int.parse(internalVersion)}");
      if (external_Version != externalVersion ||
          int.parse(internal_Version) > int.parse(internalVersion)) {
        //修改判断条件 构建版本大于现在版本则更新
        if (upgrade == "1") {
          /**
             * 强制更新
             */
          _launchURL(file_Url);
          Get.off(() => UpdateInProgressPage(
                msg: response.data['data']["msg"] ?? "",
                url: file_Url,
              ));

          return;
          divConfirmOnlyDialog(context,
              confirmDescriptionWidget: Container(
                width: 560.w,
                height: response.data['data']["msg"] != null &&
                        response.data['data']["msg"] != ""
                    ? 220
                    : 100,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(15),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  color: Colors.black,
                                  height: 1.5,
                                  fontSize: 16.0),
                              text: tr('updataTipAsk'),
                            ),
                          )),
                      if (response.data['data']["msg"] != null &&
                          response.data['data']["msg"] != "")
                        Padding(
                            padding: const EdgeInsets.all(15),
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    color: Colors.black,
                                    height: 1.5,
                                    fontSize: 16.0),
                                text: response.data['data']["msg"],
                              ),
                            ))
                    ],
                  ),
                ),
              )).then((value) => {
                Get.off(() => UpdateInProgressPage(
                      msg: response.data['data']["msg"] ?? "",
                      url: file_Url,
                    ))

                // UpdateManager.downloadAndInstall(file_Url)
              });
        } else {
          if (istoupdata) {
            divConfirmDialog(context,
                confirmTitle: tr("device.controltDialog.confirmTitle"),
                confirmDescriptionWidget: Container(
                  width: 560.w,
                  height: response.data['data']["msg"] != null &&
                          response.data['data']["msg"] != ""
                      ? 220
                      : 100,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(15),
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    color: Colors.black,
                                    height: 1.5,
                                    fontSize: 16.0),
                                text: tr('updataTipAsk', namedArgs: {
                                  "val": "$external_Version($internal_Version)"
                                }),
                              ),
                            )),
                        if (response.data['data']["msg"] != null &&
                            response.data['data']["msg"] != "")
                          Padding(
                              padding: const EdgeInsets.all(15),
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                      color: Colors.black,
                                      height: 1.5,
                                      fontSize: 16.0),
                                  text: response.data['data']["msg"],
                                ),
                              ))
                      ],
                    ),
                  ),
                )).then((value) => {
                  istoupdata = value,
                  if (value)
                    {
                      _launchURL(file_Url)

                      // UpdateManager.downloadAndInstall(file_Url),
                      // Get.off(() => UpdateInProgressPage())
                    }
                });
          }
        }
      }
    }
  } catch (e) {
    print(e);
  }
}

List connectType = [
  'afterSalesReplacement.connectType1',
  'afterSalesReplacement.connectType2',
  'afterSalesReplacement.connectType3',
  'afterSalesReplacement.connectType4',
];

Future<String> fetchAndSaveJsonData(lang) async {
  String url =
      "https://btri-dev.midea.com/api/mibp-basic-account/v1/i18n/kv/pair?source=fluoroscopy_tool&lang=$lang"; // 替换为实际URL
  print(url);
  final response = await dio.get(url);

  if (response.statusCode == 200) {
    // 如果需要可以解析 JSON 数据
    var data = response.data["data"];
    // 获取保存文件的路径
    final directory = await getApplicationDocumentsDirectory();
    final filePath =
        '${directory.path}/${lang.toString().replaceAll("_", "-")}.json';
    final file = File(filePath);
    // 将数据写入文件
    await file.writeAsString(json.encode(data));
    print('数据已保存到: $filePath');
    return '${directory.path}';
  } else {
    print('请求失败，状态码：${response.statusCode}');
    return '';
  }
}

// 异步判断文件是否存在
Future<String> checkFileExistence(lang) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath =
      '${directory.path}/${lang.toString().replaceAll("_", "-")}.json';
  bool fileExists = await File(filePath).exists();
  if (fileExists) {
    return '${directory.path}';
  } else {
    return "";
  }
}
