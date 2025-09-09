import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/cloud/device/style.dart';
import 'package:fluoroscopy_tool/view/errorAnalysis/errorDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class oldReformImageInfoWebListPage extends StatefulWidget {
  var data;
  oldReformImageInfoWebListPage({super.key, required this.data});

  @override
  State<oldReformImageInfoWebListPage> createState() =>
      _oldReformImageInfoWebListPageState();
}

class _oldReformImageInfoWebListPageState
    extends State<oldReformImageInfoWebListPage> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  var imagemap = {
    "cloudConnectionBoxImg": '旧改云联盒子图片',
    "sprayDeviceInstallImg": '喷淋装置安装图片路径',
    "powerPositionImg": '取电位置图片路径',
    "waterTreatmentDeviceImg": '水质处理装置图片路径',
    "outdoorNamePlateImg": '外机铭牌照片路径',
    "otherImg": '其它图片路径',
  };
  List showing = [];
  _init() {
    showing = [];
    for (var element in imagemap.keys) {
      try {
        if (widget.data[element] != null && widget.data[element] != "") {
          showing
              .add({"title": imagemap[element], "url": widget.data[element]});
        }
      } catch (e) {}
    }
    setState(() {
      showing;
    });
  }

  Future<bool> isImageAccessible(String url) async {
    try {
      final response = await Dio().get(url);
      return response.statusCode == 200;
    } catch (e) {
      print('isImageAccessible $url Error:  $e');
      return false;
    }
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
          title: const Text(
            '安装图片查看',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [],
        ),
        body: Container(
          width: 720.w,
          height: 1280.h,
          color: const Color.fromRGBO(244, 244, 244, 1),
          padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
          child: ListView.builder(
              itemCount: showing.length,
              itemBuilder: ((context, index) => Container(
                    decoration: cardStyleFull(context),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 24.h),
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
                    child: Column(
                      children: [
                        Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(16, 0, 0, 16),
                            child: Text(
                              showing[index]['title'] + ":",
                              style: titleText(),
                            )),
                        GestureDetector(
                            onTap: () async {
                              if (await isImageAccessible(
                                  showing[index]['url'])) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenImage(
                                        imageUrl: showing[index]['url']),
                                  ),
                                );
                              } else {}
                            },
                            child: Image.network(
                              showing[index]['url'],
                              height: 200,
                              errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) {
                                return Container(
                                  width: 200,
                                  height: 200,
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.error,
                                    color: Colors.red,
                                    size: 50,
                                  ),
                                );
                              },
                            ))
                      ],
                    ),
                  ))),
        ));
  }
}
