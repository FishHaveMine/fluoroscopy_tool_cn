import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class JsonFileService {
  // 将 JSON 对象保存为文件
  static Future<void> saveJsonToFile(
    String fileName,
    dynamic jsonData, {
    String subDirectory = '', // 可选子目录
  }) async {
    try {
      // 1. 获取应用文档目录
      final directory = await getApplicationDocumentsDirectory();

      // 2. 构建文件路径（支持子目录）
      final filePath = subDirectory.isEmpty
          ? '${directory.path}/$fileName'
          : '${directory.path}/$subDirectory/$fileName';

      final file = File(filePath);

      // 3. 如果子目录不存在，则创建
      if (subDirectory.isNotEmpty) {
        final dir = Directory('${directory.path}/$subDirectory');
        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }
      }

      // 4. 将 JSON 对象转换为字符串
      final jsonString = json.encode(jsonData);

      // 5. 写入文件
      await file.writeAsString(jsonString);

      debugPrint('JSON 文件已保存: $filePath');
    } catch (e) {
      debugPrint('保存 JSON 文件时出错: $e');
      rethrow;
    }
  }

  // 从文件读取 JSON
  static Future<dynamic> readJsonFromFile(
    String fileName, {
    String subDirectory = '',
  }) async {
    try {
      // 构建文件路径
      final directory = await getApplicationDocumentsDirectory();
      final filePath = subDirectory.isEmpty
          ? '${directory.path}/$fileName'
          : '${directory.path}/$subDirectory/$fileName';

      final file = File(filePath);

      // 检查文件是否存在
      if (!await file.exists()) {
        debugPrint('文件不存在: $filePath');
        return null;
      }

      // 读取文件内容并解析为 JSON
      final jsonString = await file.readAsString();
      return json.decode(jsonString);
    } catch (e) {
      debugPrint('读取 JSON 文件时出错: $e');
      rethrow;
    }
  }
}
