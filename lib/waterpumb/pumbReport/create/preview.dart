import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'ReportStep1Page.dart';
import 'ReportStep2Page.dart';
import 'ReportStep3Page.dart';
import 'ReportStep4Page.dart';
import 'public/publicObject.dart';

class reportPreviewPage extends StatefulWidget {
  reportPreviewPage({super.key});
  @override
  State<reportPreviewPage> createState() => _reportPreviewPageState();
}

class _reportPreviewPageState extends State<reportPreviewPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get height of app bar
    double appBarHeight = AppBar().preferredSize.height;

    // Calculate remaining height for page content
    double contentHeight = MediaQuery.of(context).size.height - appBarHeight;
    return FutureBuilder<InstallController>(builder: (context, snapshot) {
      return GetBuilder<InstallController>(
          builder: (_) => Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.chevron_left,
                          color: Colors.black, size: 36)),
                  title: const Text(
                    '冷水机组调试报告',
                    style: TextStyle(color: Colors.black),
                  ),
                  centerTitle: true,
                  actions: [
                    TextButton(
                        onPressed: () {
                          _.ispreview.value = false;
                          Navigator.pop(context);
                        },
                        child: Text("退出预览"))
                  ],
                ),
                body: Container(
                    width: 720.w,
                    color: Colors.white,
                    height: contentHeight,
                    padding: EdgeInsets.fromLTRB(0.w, 24.w, 0.w, 0.w),
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        ReportStep1Page(
                          ispreview: true,
                          next: () {},
                          pre: () {},
                        ),
                        ReportStep2Page(
                          ispreview: true,
                          next: () {},
                          pre: () {},
                        ),
                        ReportStep3Page(
                          ispreview: true,
                          next: () {},
                          pre: () {},
                        ),
                        ReportStep4Page(
                          ispreview: true,
                          next: () {},
                          pre: () {},
                        )
                      ],
                    ))),
              ));
    });
  }
}
