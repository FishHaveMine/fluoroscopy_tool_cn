import 'dart:math';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalData.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:fluoroscopy_tool/view/systemCapabilityAnalysis/step2/systemDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'errorHistory.dart';

import 'package:provider/provider.dart';

class errorDetailPage extends StatefulWidget {
  String? deviceversion;
  var item;
  var showDetail;
  errorDetailPage({
    super.key,
    required this.item,
    this.deviceversion,
    this.showDetail,
  });

  @override
  State<errorDetailPage> createState() => _errorDetailPageState();
}

class _errorDetailPageState extends State<errorDetailPage> {
  static const _selfplatform =
      MethodChannel('samples.flutter.dev/getDeviceFaultHandler');
  Map<String, dynamic> data = {};

  final deviceInfoController _deviceInfoController = Get.find();
  final List _datatype = [
    "faultDescription",
    "faultReason",
    "faultProcessWays"
  ];
  List _datatypeshow = ["faultProcessWays"];
  List showingtype = [
    "errorCode",
    "codeName",
    "deviceVersion",
    "deviceTypeName",
  ];

  init() async {
    if (widget.showDetail != null) {
      setState(() {
        data = widget.showDetail;
      });
      return;
    }
    bool conn = await checkNet(true);
    if (!conn) {
      EasyLoading.dismiss();
      return;
    }
    try {
      print("gethistory : ${{
        "errorCode": widget.item["errorCode"],
        "deviceversion": widget.deviceversion ??
            _deviceInfoController.loacalDevice.value.model
      }}");
      var gethistory =
          await _selfplatform.invokeMethod('getDetailByCode', <String, dynamic>{
        "errorCode": widget.item["errorCode"],
        "deviceversion": widget.deviceversion ??
            _deviceInfoController.loacalDevice.value.model
      });
      print("gethistory: ${gethistory}");
      if (gethistory["errorCode"] == 1001) {
        EasyLoading.showError(tr("network_error"));
        // EasyLoading.showError(gethistory["errorMsg"]);
        // await signout();
        // // ignore: use_build_context_synchronously
        // Provider.of<GlobalData>(context, listen: false).userIsLogin(false);
        // // ignore: use_build_context_synchronously
        // Navigator.pop(context);
      } else {
        if (gethistory['errorMsg'] != "") {
          EasyLoading.showError(gethistory['errorMsg']);
        }
        gethistory["data"].forEach((key, value) {
          data[key] = value;
        });
        setState(() {
          data;
        });
      }
    } catch (e) {}
  }

  checknet() async {
    bool isnetconnecd = false;

    EasyLoading.show(status: 'loading...');
    try {
      final response = await Dio().get('https://${apiHost}/');
      isnetconnecd = response.statusCode == 200;
      EasyLoading.dismiss();
      if (isnetconnecd) {
        init();
      } else {
        EasyLoading.showError(tr("netword.error"));
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(tr("netword.error"));
    }
  }

  @override
  void initState() {
    super.initState();
    checknet();
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
            'errorAnalysis.errorDetail',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [],
        ),
        body: Container(
          width: 720.w,
          color: const Color.fromRGBO(244, 244, 244, 1),
          padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
          child: SingleChildScrollView(
              child: Column(
            children: [
              for (var key in showingtype)
                Container(
                  width: 720.w,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Color.fromRGBO(223, 223, 223, 1),
                          width: 0.5,
                        ),
                      )),
                  padding: EdgeInsets.fromLTRB(32.w, 12, 32.w, 12),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          // ignore: prefer_interpolation_to_compose_strings
                          tr("errorAnalysis." + key),
                          style: normalTextBlack(),
                        ),
                        Text(
                          data[key] ?? "--",
                          style: normalText(),
                        ).tr()
                      ]),
                ),
              Container(
                width: 720.w,
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: SingleChildScrollView(
                    child: ExpansionPanelList(
                  expansionCallback: ((panelIndex, isExpanded) => {
                        if (_datatypeshow.contains(_datatype[panelIndex]))
                          {_datatypeshow.remove(_datatype[panelIndex])}
                        else
                          {_datatypeshow.add(_datatype[panelIndex])},
                        setState(() {
                          _datatypeshow;
                        })
                      }),
                  elevation: 0, // 手风琴容器的阴影高度
                  expandedHeaderPadding: const EdgeInsets.all(8), // 展开的标题的内边距
                  dividerColor:
                      const Color.fromRGBO(245, 245, 245, 1), // 分割线的颜色
                  children: _datatype.map<ExpansionPanel>((item) {
                    return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          onTap: () {
                            if (_datatypeshow.contains(item)) {
                              _datatypeshow.remove(item);
                            } else {
                              _datatypeshow.add(item);
                            }
                            setState(() {
                              _datatypeshow;
                            });
                          },
                          title: Text(item).tr(),
                        );
                      },
                      body: Container(
                        width: 720.w,
                        height: 250,
                        padding: EdgeInsets.all(30.w),
                        child: item == "faultProcessWays"
                            ? data[item] == null
                                ? Container()
                                : GestureDetector(
                                    onTap: () async {
                                      print(data[item]);
                                      if (await isImageAccessible(data[item])) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FullScreenImage(
                                                    imageUrl: data[item]),
                                          ),
                                        );
                                      } else {}
                                    },
                                    child: Image.network(
                                      data[item],
                                      height: 200,
                                      errorBuilder: (BuildContext context,
                                          Object error,
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
                            : Text.rich(TextSpan(
                                style: normalText(), text: data[item])),
                      ),
                      isExpanded: _datatypeshow.contains(item),
                    );
                  }).toList(),
                )),
              )
            ],
          )),
        ));
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon:
                const Icon(Icons.chevron_left, color: Colors.white, size: 36)),
        title: Text(
          '',
          style: const TextStyle(color: Colors.black),
        ).tr(),
        centerTitle: true,
        actions: [],
      ),
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: InteractiveViewer(
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

class FullScreenImageLocal extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageLocal({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: InteractiveViewer(
            child: Image.asset(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
