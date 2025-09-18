import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:external_path/external_path.dart';
import 'package:fluoroscopy_tool/compent/EmailInputDialog.dart';
import 'package:fluoroscopy_tool/store/http.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:media_scanner/media_scanner.dart';

import 'package:printing/printing.dart';
import 'dart:ui' as ui; // 引入底层Image并指定别名
import 'package:image/image.dart' as Img;

const _selfplatform = MethodChannel('samples.flutter.dev/BackClip');

const McuUtilplatform = MethodChannel('samples.flutter.dev/McuUtil');

// 读取文件列表并按文件名中的日期排序（最新在前）
Future<List<FileSystemEntity>> getFileList() async {
  final String targetPath =
      '/data/data/com.example.fluoroscopy_tool/files/Database_/dev/ttyS0/';
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
      return filesWithDates.map((entry) => entry.key).take(10).toList();
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
          SizedBox(
            width: double.infinity,
            child: const Text(
              '选择导出数据',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
              width: double.infinity,
              child: const Text(
                '注意:当前仅支持导出最近10次已断开连接的数据文件。',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.red),
              )),
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
                  // subtitle: Text(
                  //   file.path,
                  //   style: const TextStyle(fontSize: 12, color: Colors.grey),
                  //   overflow: TextOverflow.ellipsis,
                  // ),
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

// 获取文件列表中创建时间最新的文件
Future<FileSystemEntity?> getLatestCreatedFile(
    List<FileSystemEntity> fileList) async {
  if (fileList.isEmpty) return null;

  FileSystemEntity latestFile = fileList.first;
  DateTime latestTime = await _getCreationTime(latestFile);

  for (var file in fileList) {
    // 跳过目录，只处理文件
    if (file is Directory) continue;

    DateTime currentTime = await _getCreationTime(file);
    if (currentTime.isAfter(latestTime)) {
      latestTime = currentTime;
      latestFile = file;
    }
  }

  return latestFile;
}

// 获取文件的创建时间
Future<DateTime> _getCreationTime(FileSystemEntity file) async {
  try {
    if (file is File) {
      // 获取文件的详细信息
      FileStat stat = await file.stat();
      return stat.changed; // 返回文件创建/修改时间
    }
  } catch (e) {
    print("获取文件时间失败: $e");
  }
  // 出错时返回一个较早的时间
  return DateTime.fromMillisecondsSinceEpoch(0);
}

// 使用示例
Future<void> usageExample() async {
  List<FileSystemEntity> fileList = await getFileList(); // 假设这是你的文件列表获取方法
  FileSystemEntity? latestFile = await getLatestCreatedFile(fileList);

  if (latestFile != null) {
    print("最新创建的文件: ${latestFile.path}");
    DateTime createTime = await _getCreationTime(latestFile);
    print("创建时间: $createTime");
  } else {
    print("文件列表为空");
  }
}

getLastDBFile(context) async {
  // 显示文件选择弹窗
  List<FileSystemEntity> fileList = await getFileList();
  if (fileList.isNotEmpty) {
    FileSystemEntity? selectedFile = await getLatestCreatedFile(fileList);
    if (selectedFile != null) {
      var filePath = selectedFile.path;
      EmailInputDialog.show(
        context,
        onConfirm: (email) {
          downlown(email, filePath);
        },
      );
    }
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

downlownPDF(email, filePath) async {
  EasyLoading.show(status: 'loading...');
  try {
    final File dbFile = File(filePath);

    // 检查文件是否存在
    if (!await dbFile.exists()) {
      print('文件不存在: $filePath');
      return false;
    }
    var uploadExcelFileback = await MideaApi.uploadExcelFile(dbFile.path);
    if (uploadExcelFileback["errorCode"] == 200) {
      var fileurl = uploadExcelFileback["data"];
      var send = {"email": email, "excelUrl": fileurl};
      var sendEmaileback = await MideaApi.sendEmail(send);
      //继续下一步  --- 发送到邮箱
      EasyLoading.showSuccess(
          tr("menu.export") + tr("unlockhistory.unlocksuccess"));
    } else {
      EasyLoading.showSuccess(
          tr("menu.export") + tr("unlockhistory.unlockerror"));
    }
  } catch (e) {}
}

// Future<File> exportPdf(String html, {bool saveHtml = false}) async {
//   String targetDirectory =
//       '/data/data/com.example.fluoroscopy_tool/files/Database_/dev/ttyS0/';
//   String targetName =
//       'enpal_${(DateTime.now().millisecondsSinceEpoch / 100).toInt()}';

//   final generatedPdfFile = await HtmlToPdf.convertFromHtmlContent(
//     htmlContent: html,
//     printPdfConfiguration: PrintPdfConfiguration(
//       targetDirectory: targetDirectory,
//       targetName: targetName,
//       printSize: PrintSize.A4,
//       printOrientation: PrintOrientation.Portrait,
//     ),
//   );

//   if (saveHtml) {
//     String exportHtml = removeScriptTags(html);

//     File htmlFile = File(targetDirectory + "/${targetName}.html");

//     htmlFile.create();
//     htmlFile.writeAsString(exportHtml);
//   }

//   return generatedPdfFile;
// }

// String removeScriptTags(String html) {
//   // 正则表达式匹配所有<script>标签及其内容（不区分大小写）
//   final scriptRegExp = RegExp(
//     r'<script[^>]*>[\s\S]*?<\/script\s*>',
//     caseSensitive: false,
//     dotAll: true,
//   );

//   // 分步骤清理：先移除换行符干扰，再替换标签
//   return html
//       // .replaceAll(RegExp(r'\n\s*'), '') // 可选：去除换行和缩进干扰
//       .replaceAllMapped(scriptRegExp, (Match m) => '');
// }

// 1. 只在后台线程执行纯数据操作（不涉及任何UI相关逻辑）
Future<String> _generatePdfInBackground(String htmlContent) async {
  try {
    print("enter _generatePdfInBackground: ${htmlContent}");
    // 获取下载目录路径
    final String targetPath =
        await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOADS,
    );

    // 生成唯一文件名
    final String targetFileName =
        'masterexport_${DateTime.now().millisecondsSinceEpoch}';

    // 转换HTML为PDF（纯数据操作，不涉及UI）
    final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
      htmlContent,
      targetPath,
      targetFileName,
    );
    print("Pdf保存路径: ${generatedPdfFile.path}");

    try {
      final String? pngPath = await convertPdfToPng(
        pdfPath: generatedPdfFile.path,
        dpi: 200,
      );
      if (pngPath != null) {
        print("PNG保存路径: $pngPath");
        return pngPath;
      }
    } catch (e) {
      return generatedPdfFile.path;
    }

    // 返回文件路径，不在后台线程执行媒体扫描（可能涉及UI）
    return generatedPdfFile.path;
  } catch (e, stackTrace) {
    debugPrint("PDF生成错误: $e");
    debugPrint("堆栈跟踪: $stackTrace");
    rethrow;
  }
}

// 2. 主线程执行入口（包含UI操作）
Future<String?> exportPdf(String htmlContent) async {
  try {
    // 1. 在后台线程生成PDF
    final String pdfPath = await _generatePdfInBackground(htmlContent);

    // 2. 回到主线程执行媒体扫描（可能涉及UI更新）
    await MediaScanner.loadMedia(path: pdfPath);

    // 3. 主线程可以安全地执行UI操作（如显示提示）
    debugPrint("PDF导出成功: $pdfPath");
    return pdfPath;
  } catch (e) {
    debugPrint("PDF导出失败: $e");
    return null;
  }
}

/// 将PDF文件转换为PNG图片（兼容printing 5.9.3）

Future<String?> convertPdfToPng({
  required String pdfPath,
  int pageNumber = 0,
  double dpi = 200,
}) async {
  try {
    // 检查文件是否存在
    final File pdfFile = File(pdfPath);
    if (!await pdfFile.exists()) {
      throw Exception("PDF文件不存在: $pdfPath");
    }

    // 读取PDF文件内容
    final Uint8List pdfBytes = await pdfFile.readAsBytes();

    // 使用printing 5.9.3渲染PDF页面
    final List<PdfRaster> pages = await Printing.raster(
      pdfBytes,
      dpi: dpi,
    ).toList();

    if (pages.isEmpty) {
      throw Exception("无法渲染PDF页面: 第$pageNumber页");
    }

    // 绘制PDF页面到画布
    final PictureRecorder recorder = PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    int width = 0;
    int height = 0;
    for (final page in pages) {
      // 明确指定为底层ui.Image，避免与widget的Image冲突
      ui.Image image = await page.toImage();
      canvas.drawImage(image, Offset(0, height.toDouble()), Paint());
      width = image.width;
      height += image.height;
      image.dispose(); // 及时释放资源
    }

    // 生成最终图像
    final Picture picture = recorder.endRecording();
    ui.Image finalImage = await picture.toImage(width, height);

    // 获取PNG字节数据
    final ByteData? byteData =
        await finalImage.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw Exception("无法将图像转换为PNG格式");
    }

    // 保存PNG文件
    final String downloadDir =
        await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOADS,
    );
    await Directory(downloadDir).create(recursive: true);

    // 生成唯一文件名
    final String originalName =
        File(pdfPath).uri.pathSegments.last.split('.').first;
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String pngPath = '$downloadDir/${originalName}_page$timestamp.png';
    print("pngPath: $pngPath");
    // 写入文件
    await File(pngPath).writeAsBytes(byteData.buffer.asUint8List());

    // 通知媒体库更新
    await MediaScanner.loadMedia(path: pngPath);

    // 释放资源
    finalImage.dispose();
    picture.dispose();

    return pngPath;
  } catch (e, stackTrace) {
    debugPrint("PDF转PNG失败: $e");
    debugPrint("堆栈跟踪: $stackTrace");
    return null;
  }
}
