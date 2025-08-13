import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/EmailInputDialog.dart';
import 'package:fluoroscopy_tool/view/local/checkData/index.dart';
import 'package:fluoroscopy_tool/store/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'info.dart';

class logpage extends StatefulWidget {
  const logpage({super.key});

  @override
  State<logpage> createState() => _logpageState();
}

class _logpageState extends State<logpage> {
  static const platform = MethodChannel('samples.flutter.dev/battery');
  String log = '';
  String path = '';
  List list = [];

  List sortLogFiles(List filenames) {
    // 创建一个副本进行排序，避免修改原列表
    List sortedFiles = List.from(filenames);

    // 对副本进行排序
    sortedFiles.sort((a, b) {
      // 从文件名中提取日期时间部分
      RegExp regex = RegExp(r'(\d{4})-(\d{2})-(\d{2})-(\d{2})-(\d{2})');

      // 提取a的日期时间
      Match? matchA = regex.firstMatch(a);
      if (matchA == null) return 0;
      int yearA = int.parse(matchA.group(1)!);
      int monthA = int.parse(matchA.group(2)!);
      int dayA = int.parse(matchA.group(3)!);
      int hourA = int.parse(matchA.group(4)!);
      int minuteA = int.parse(matchA.group(5)!);

      // 提取b的日期时间
      Match? matchB = regex.firstMatch(b);
      if (matchB == null) return 0;
      int yearB = int.parse(matchB.group(1)!);
      int monthB = int.parse(matchB.group(2)!);
      int dayB = int.parse(matchB.group(3)!);
      int hourB = int.parse(matchB.group(4)!);
      int minuteB = int.parse(matchB.group(5)!);

      // 按年、月、日、时、分倒序排序
      if (yearA != yearB) return yearB - yearA; // 年份降序
      if (monthA != monthB) return monthB - monthA; // 月份降序
      if (dayA != dayB) return dayB - dayA; // 日期降序
      if (hourA != hourB) return hourB - hourA; // 小时降序
      return minuteB - minuteA; // 分钟降序
    });

    // 返回排序后的列表
    return sortedFiles;
  }

  getlist() async {
    list = await platform.invokeMethod('getLogFiles', <String, dynamic>{});
    try {
      list = sortLogFiles(list);
    } catch (e) {}
    setState(() {
      list;
    });
  }

  getlog() async {
    log = await platform.invokeMethod('readLogFile', <String, dynamic>{});
    setState(() {
      log;
    });
  }

  downlown(email) async {
    EasyLoading.show(status: 'loading...');
    try {
      var uploadExcelFileback = await MideaApi.uploadExcelFile(path);

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
    } catch (e) {
      print("getHistoryDataExcel error $e");
      EasyLoading.dismiss();
    }
  }

  sendEamil(fileName) async {
    path = await copyLogFileToDownload(fileName);
    EmailInputDialog.show(
      context,
      onConfirm: (email) {
        downlown(email);
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlist();
  }

  Future<String> copyLogFileToDownload(fileName) async {
    EasyLoading.show(status: 'loading...');
    try {
      final String content =
          await platform.invokeMethod('readLogFile', {'fileName': fileName});
      // Step 2: 读取日志文件内容
      final _content = content;

      // Step 3: 请求存储权限
      if (!await Permission.storage.request().isGranted) {
        print("Storage permission denied");
        return "";
      }

      // Step 4: 写入到 Download 文件夹
      final downloadPath = '/storage/emulated/0/Download';
      final targetFile = File('$downloadPath//${fileName}');

      await targetFile.writeAsString(_content);
      EasyLoading.dismiss();
      return targetFile.path;
    } catch (e) {
      EasyLoading.dismiss();
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('log'),
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(43, 103, 234, 1),
        ),
        body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return ListTile(
              trailing: Icon(Icons.arrow_right),
              onLongPress: () async {
                sendEamil(list[index]);
              },
              onTap: () async {
                await Get.to(() => logcontent(
                      fileName: list[index],
                    ));
                getlist();
              },
              title: Text('${list[index]}'),
            );
          },
        ));
  }
}
