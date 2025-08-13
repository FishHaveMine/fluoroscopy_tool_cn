import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
// import 'package:install_plugin/install_plugin.dart';

class UpdateManager {
  static Future<void> downloadAndInstall(String apkUrl) async {
    Dio dio = Dio();
    const platform = MethodChannel('samples.flutter.dev/battery');
    await platform.invokeMethod('disableAutoSleep', <String, dynamic>{});
    try {
      // 获取应用的本地目录路径
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;

      // 构建文件路径
      String savePath = appDocDir.path + "/updata.apk";

      // 下载APK文件
      await dio.download(apkUrl, savePath,
          onReceiveProgress: (received, total) {
        if (total != -1) {
          EasyLoading.showProgress((received / total),
              status: tr('updatadownloading', namedArgs: {
                "val": (received / total * 100).toStringAsFixed(1)
              }));
        }
      });

      await platform.invokeMethod('enableAutoSleep', <String, dynamic>{});
      // 下载完成后，安装APK
      // await InstallPlugin.installApk(savePath,
      //     appId: 'com.example.fluoroscopy_tool');
    } on PlatformException catch (e) {
      print('安装APK时出现错误：$e');
    } catch (e) {
      print('下载APK文件时出现错误：$e');
    }
  }
}
