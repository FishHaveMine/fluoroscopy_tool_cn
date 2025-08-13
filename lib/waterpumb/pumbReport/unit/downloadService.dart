import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:external_path/external_path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_extend/share_extend.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DownloadService {
  // 下载文件到系统 Downloads 文件夹
  static Future<void> downloadToDownloads(
      String url, BuildContext context) async {
    // 1. 请求存储权限
    if (Platform.isAndroid) {
      // Android 10+ 特殊处理
      if (await _isAndroid11OrHigher()) {
        final status = await Permission.manageExternalStorage.request();
        if (!status.isGranted) {
          EasyLoading.showInfo('需要文件管理权限才能下载到公共目录');
          return;
        }
      } else {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          EasyLoading.showInfo('需要存储权限才能下载文件');
          return;
        }
      }
    }

    try {
      // 2. 获取 Downloads 目录路径
      final String downloadsDir =
          await ExternalPath.getExternalStoragePublicDirectory(
              ExternalPath.DIRECTORY_DOWNLOADS);
      final directory = downloadsDir;
      final fileName = url.split('/').last.split('?').first; // 提取文件名
      final savePath = '${directory}/$fileName';

      // 3. 开始下载
      final dio = Dio();
      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          final progress = (received / total * 100).toStringAsFixed(0);
          print('下载进度: $progress%');
        },
      );

      // 4. 下载完成提示
      EasyLoading.showSuccess('文件已下载到: $savePath');

      // 5. 刷新媒体库（让文件在相册/文件管理器中可见）
      if (Platform.isAndroid) {
        await _refreshMediaStore(savePath);
      }
    } catch (e) {
      print('下载失败: $e');
      EasyLoading.showError('下载失败，请重试');
    }
  }

  // 检查是否为 Android 11+
  static Future<bool> _isAndroid11OrHigher() async {
    if (Platform.isAndroid) {
      final version = await _getAndroidSdkVersion();
      return version >= 30; // Android 11 对应 SDK 30
    }
    return false;
  }

  // 获取 Android SDK 版本
  static Future<int> _getAndroidSdkVersion() async {
    // 实际实现需要使用 platform channel 调用原生代码
    // 简化示例，实际项目中需通过 MethodChannel 实现
    return 30; // 示例值，实际应通过原生代码获取
  }

  // 刷新媒体库（让文件在相册/文件管理器中可见）
  static Future<void> _refreshMediaStore(String filePath) async {
    // 实际实现需要使用 platform channel 调用原生代码
    // 简化示例，实际项目中需通过 MethodChannel 实现
    print('刷新媒体库: $filePath');
  }
}
