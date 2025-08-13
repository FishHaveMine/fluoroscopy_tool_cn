import 'dart:convert';

import 'package:fluoroscopy_tool/style/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class handerFunction extends StatefulWidget {
  String title;
  int id;
  String code;
  handerFunction(
      {super.key, required this.title, required this.id, required this.code});

  @override
  State<handerFunction> createState() => _handerFunctionState();
}

class _handerFunctionState extends State<handerFunction> {
  static const platform =
      MethodChannel('samples.flutter.dev/getSystemDataHandler');
  var AnalysisResult = {};
  init() async {
    EasyLoading.show(status: 'loading...');
    try {
      var queryAnalysisResult =
          await platform.invokeMethod('queryAnalysisResult', <String, dynamic>{
        'id': widget.id,
        'code': widget.code,
      });

      var data = jsonDecode(queryAnalysisResult);
      if (data["success"]) {
        setState(() {
          AnalysisResult = data["data"];
        });
      }
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    super.initState();
    init();
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
              icon: const Icon(Icons.chevron_left,
                  color: Colors.black, size: 36)),
          title: Text(
            widget.title,
            style: const TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          actions: [],
        ),
        body: Container(
          width: 720.w,
          height: 1280.h,
          color: const Color.fromRGBO(244, 244, 244, 1),
          padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: AnalysisResult.isNotEmpty &&
                      AnalysisResult["result"] != null
                  ? [
                      for (var item in AnalysisResult["result"])
                        Container(
                          width: 720.w,
                          color: Colors.white,
                          child: ExpansionTile(
                            initiallyExpanded: true,
                            title: Text(item["label"]),
                            // trailing: const Icon(Icons.chevron_right),
                            children: [
                              if (item["data"] != null &&
                                  item["data"].runtimeType == List)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    for (var dataitem in item["data"])
                                      Container(
                                        width: 720.w,
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              color: Color(
                                                  0xFFF0F0F0), // 1px border, #F0F0F0 color
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                                        padding: EdgeInsets.fromLTRB(
                                            32.w, 16, 32.w, 16),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Text(
                                              dataitem["description"],
                                              style: normalText(fSize: 14),
                                              textAlign: TextAlign.left,
                                            )),
                                            Text(
                                              dataitem["time"],
                                              style: normalText(fSize: 14),
                                              textAlign: TextAlign.left,
                                            )
                                          ],
                                        ),
                                      )
                                  ],
                                ),
                              if (item["description"] != null &&
                                  item["description"] != "")
                                Container(
                                  width: 720.w,
                                  padding:
                                      EdgeInsets.fromLTRB(32.w, 0, 32.w, 15),
                                  child: Text(
                                    item["description"],
                                    style: normalText(fSize: 14),
                                    textAlign: TextAlign.left,
                                  ),
                                )
                            ],
                          ),
                        )
                    ]
                  : [],
            ),
          ),
        ));
  }
}
