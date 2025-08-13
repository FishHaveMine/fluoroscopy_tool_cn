import 'dart:io';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_extend/share_extend.dart';

class logcontent extends StatefulWidget {
  String fileName;
  logcontent({super.key, required this.fileName});

  @override
  State<logcontent> createState() => _logcontentState();
}

class _logcontentState extends State<logcontent> {
  static const platform = MethodChannel('samples.flutter.dev/battery');
  String log = '';
  CustomPopupMenuController _controller = CustomPopupMenuController();
  List<String> menuItems = [
    'menu.deletefile',
    'menu.export',
  ];

  deletefile() async {
    bool content = await platform
        .invokeMethod('deleteLogFile', {'fileName': widget.fileName});
    if (content) {
      EasyLoading.showSuccess(tr('menu.Success'));
    } else {
      EasyLoading.showError(tr('menu.Error'));
    }
  }

  Future<void> copyLogFileToDownload() async {
    EasyLoading.show(status: 'loading...');
    try {
      // Step 2: 读取日志文件内容
      final content = log;

      // Step 3: 请求存储权限
      if (!await Permission.storage.request().isGranted) {
        print("Storage permission denied");
        return;
      }

      // Step 4: 写入到 Download 文件夹
      final downloadPath = '/storage/emulated/0/Download';
      final targetFile = File('$downloadPath//${widget.fileName}');

      await targetFile.writeAsString(content);
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  getlog() async {
    final String content = await platform
        .invokeMethod('readLogFile', {'fileName': widget.fileName});
    setState(() {
      log = content;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(43, 103, 234, 1),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon:
                const Icon(Icons.chevron_left, color: Colors.white, size: 36)),
        title: Text(widget.fileName),
        centerTitle: true,
        actions: [
          CustomPopupMenu(
            horizontalMargin: 20.0,
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
                              if (item == 'menu.deletefile') {
                                deletefile();
                              } else {
                                copyLogFileToDownload();
                                ShareExtend.share(log, 'text');
                              }
                            },
                            child: Container(
                              height: 40,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      // margin:
                                      //     const EdgeInsets.only(left: 10),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Text(
                                        tr(item),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
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
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 16.0),
                text: log,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
