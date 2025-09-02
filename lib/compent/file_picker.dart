import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/EmailInputDialog.dart';
import 'package:fluoroscopy_tool/store/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';

const _selfplatform = MethodChannel('samples.flutter.dev/BackClip');

const McuUtilplatform = MethodChannel('samples.flutter.dev/McuUtil');

// 读取文件列表并按文件名中的日期排序（最新在前）
Future<List<FileSystemEntity>> getFileList() async {
  final String targetPath =
      '/data/data/com.example.fluoroscopy_tool.dev/files/Database_/dev/ttyS0/';
  final Directory directory = Directory(targetPath);

  // 1. 定义日期格式的正则表达式（匹配多种常见格式）
  final RegExp dateRegex = RegExp(
    r'(\d{4}\d{2}\d{2})|(\d{4}-\d{2}-\d{2})|(\d{2}\d{2}\d{4})|(\d{2}-\d{2}-\d{4})',
    caseSensitive: false,
  );

  // 2. 定义支持的日期格式（与正则表达式匹配的格式对应）
  final List<DateFormat> dateFormats = [
    DateFormat('yyyyMMdd'), // 匹配 20240813
    DateFormat('yyyy-MM-dd'), // 匹配 2024-08-13
    DateFormat('MMddyyyy'), // 匹配 08132024
    DateFormat('MM-dd-yyyy'), // 匹配 08-13-2024
  ];

  try {
    if (await directory.exists()) {
      List<FileSystemEntity> entities = await directory.list().toList();

      // 3. 筛选：.db文件 + 文件名包含日期
      List<File> dbFilesWithDate = entities
          .where((entity) {
            if (entity is File) {
              String fileName = entity.path.split('/').last;
              bool isDBFile = fileName.toLowerCase().endsWith('.db');
              bool hasDate = dateRegex.hasMatch(fileName);
              return isDBFile && hasDate;
            }
            return false;
          })
          .cast<File>()
          .toList();

      // 4. 提取日期并排序
      // 存储文件和对应的日期（用于排序）
      List<MapEntry<File, DateTime?>> filesWithDates = [];

      for (var file in dbFilesWithDate) {
        String fileName = file.path.split('/').last;
        DateTime? fileDate;

        // 从文件名中提取日期字符串
        Match? dateMatch = dateRegex.firstMatch(fileName);
        if (dateMatch != null) {
          String dateStr = dateMatch.group(0)!; // 获取匹配的日期字符串

          // 尝试用多种格式解析日期
          for (var format in dateFormats) {
            try {
              fileDate = format.parse(dateStr);
              break; // 解析成功则跳出循环
            } catch (_) {
              continue; // 解析失败则尝试下一种格式
            }
          }
        }

        filesWithDates.add(MapEntry(file, fileDate));
      }

      // 5. 按日期排序（最新的在前）
      filesWithDates.sort((a, b) {
        // 日期为null的文件排在最后
        if (a.value == null) return 1;
        if (b.value == null) return -1;
        // 降序排序（最新的在前）
        return b.value!.compareTo(a.value!);
      });

      // 提取排序后的文件列表
      return filesWithDates.map((entry) => entry.key).toList();
    } else {
      throw Exception('目标目录不存在');
    }
  } catch (e) {
    print('读取文件列表失败: $e');
    rethrow;
  }
}

// 显示文件选择弹窗的方法
Future<File?> showFilePickerDialog(BuildContext context) async {
  List<FileSystemEntity> fileList = await getFileList();

  // 如果没有文件，显示提示并返回null
  if (fileList.isEmpty) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('提示'),
        content: const Text('目录中没有找到任何文件'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
    return null;
  }

  // 显示底部弹窗让用户选择文件
  return showModalBottomSheet<File?>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    builder: (context) => Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '选择文件',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: fileList.length,
              itemBuilder: (context, index) {
                File file = fileList[index] as File;
                // 获取文件名（从路径中提取）
                String fileName = file.path.split('/').last;

                return ListTile(
                  leading: const Icon(Icons.file_copy),
                  title: Text(
                    fileName,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    file.path,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    // 选择文件后关闭弹窗并返回选中的文件
                    Navigator.pop(context, file);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
        ],
      ),
    ),
  );
}

getDBFile(context) async {
  // 显示文件选择弹窗
  File? selectedFile = await showFilePickerDialog(context);

  if (selectedFile != null) {
    // 处理选中的文件
    var filePath = selectedFile.path;
    EmailInputDialog.show(
      context,
      onConfirm: (email) {
        downlown(email, filePath);
      },
    );
  }
}

downlown(email, filePath) async {
  EasyLoading.show(status: 'loading...');
  try {
    final File dbFile = File(filePath);

    // 检查文件是否存在
    if (!await dbFile.exists()) {
      print('文件不存在: $filePath');
      return false;
    }

    var uploadExcelFileback = await MideaApi.uploadExcelFile(dbFile.path);

    print("getHistoryDataExcel uploadExcelFile： ${uploadExcelFileback}");
    if (uploadExcelFileback["errorCode"] == 200) {
      var fileurl = uploadExcelFileback["data"];
      var sendDBAndSend = {"dbUrl": fileurl};
      print("getHistoryDataExcel getDBAndSend send： $sendDBAndSend");
      var getDBAndSendback = await MideaApi.getDBAndSend(sendDBAndSend);
      print("getHistoryDataExcel getDBAndSendback $getDBAndSendback");

      var send = {"email": email, "excelUrl": getDBAndSendback["data"]};
      print("getHistoryDataExcel sendEmail send： $send");
      var sendEmaileback = await MideaApi.sendEmail(send);
      print("getHistoryDataExcel sendEmaileback $sendEmaileback");
      //继续下一步  --- 发送到邮箱
      EasyLoading.showSuccess(
          tr("menu.export") + tr("unlockhistory.unlocksuccess"));
    } else {
      EasyLoading.showSuccess(
          tr("menu.export") + tr("unlockhistory.unlockerror"));
    }
  } catch (e) {}
}
