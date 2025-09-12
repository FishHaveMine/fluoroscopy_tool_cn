import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/waterPumpInspection/searching.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import 'package:get/get.dart';

import '../local/publicFunction.dart';
import 'protocol_table.dart';

class waterPumpInspectionList extends StatefulWidget {
  const waterPumpInspectionList({super.key});
  @override
  State<waterPumpInspectionList> createState() =>
      _waterPumpInspectionListState();
}

class _waterPumpInspectionListState extends State<waterPumpInspectionList> {
  TextEditingController _controller = TextEditingController();

  static const _selfplatform =
      MethodChannel('samples.flutter.dev/RefrigerantService');
  final deviceInfoController _deviceInfoController = Get.find();
  final MethodChannel methodChannel = const MethodChannel('scan.data');
  static const platform = MethodChannel('samples.flutter.dev/battery');
  String sn = '';
  List pumbList = [];
  List selectList = [];
  bool ishavev6 = true;
  init(context) async {
    var getProtocol =
        await _selfplatform.invokeMethod('getProtocol', <String, dynamic>{});
    var data = jsonDecode(getProtocol);
    bool isv8 = data["data"] == "V8";
    _controller.text = "";
    if (_deviceInfoController.indoorEntityList.value.isNotEmpty) {
      pumbList = _deviceInfoController.indoorEntityList.value;
      selectList = [];
      ishavev6 = pumbList.any((element) =>
          element['isV6'] != null &&
          element['isV8Indoor'].toString() != "true");
      if (ishavev6 || !isv8) {
        bool issend = await divConfirmOnlyDialog(context,
            confirmTitle: "",
            confirmText: tr("signout"),
            confirmDescriptionWidget: SizedBox(
                width: 560.w,
                height: 140,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('waterPump.ishavev6tip').tr(),
                      ],
                    ),
                  ),
                )));
        if (issend) {}
        Get.offAllNamed('/home'); //
      } else {
        setState(() {
          pumbList;
          selectList;
        });
      }
    }
  }

  openscan() async {
    try {
      await platform.invokeMethod('SCANNER_TRIG');
    } on PlatformException catch (e) {
      print("Failed to SCANNER_TRIG: '${e.message}'.");
    }
  }

  ScrollController _scrollController = ScrollController();
  bool _isLoading = false; // 是否正在加载更多数据
  // 模拟加载更多数据的方法
  Future<void> _loadMoreData() async {
    // 模拟异步加载延迟
    // print('模拟异步加载延迟');
    // await Future.delayed(const Duration(seconds: 2));
    // setState(() {
    //   pumbList.addAll(List.generate(
    //       10,
    //       (i) => {
    //             "addRess": i,
    //             "temp": i,
    //             "runnmodel": "1",
    //             "runningstatys": false
    //           })); // 加载10条新数据
    // });
  }

  // 滚动监听回调
  void _onScroll() {
    // if (_scrollController.position.pixels == 0) {
    //   // 滚动到顶部
    //   _loadMore();
    // }
  }

  // 加载更多数据
  void _loadMore() {
    if (!_isLoading) {
      setState(() {
        _isLoading = true; // 设置为true，表示正在加载中
      });
      _loadMoreData();
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      init(context);
      try {
        platform.invokeMethod('SCANNER_RESULT');
      } on PlatformException catch (e) {}
    });
    methodChannel.setMethodCallHandler((call) async {
      if (call.method == 'data') {
        _controller.text = call.arguments;
        setState(() {
          sn = call.arguments;
        });
      }
    });
  }

  remove() async {
    try {
      await platform.invokeMethod('REMOVE_RESULT');
    } on PlatformException catch (e) {}
  }

  selectAll() {
    if (selectList.length != pumbList.length) {
      selectList = [];
      for (var element in pumbList) {
        selectList.add(element['address']);
      }
    } else {
      selectList = [];
    }
    setState(() {
      selectList;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    remove();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Get.offAllNamed('/home'); //
            },
            icon:
                const Icon(Icons.chevron_left, color: Colors.black, size: 36)),
        title: const Text(
          'waterPump.title',
          style: TextStyle(color: Colors.black),
        ).tr(),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                selectAll();
              },
              child: Text(
                "selectAll",
                style: normalText(),
              ).tr())
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(32.w, 24.w, 32.w, 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ClipRRect(
            //     borderRadius: BorderRadius.circular(42),
            //     child: Container(
            //       height: 44,
            //       color: Colors.white,
            //       padding: const EdgeInsets.all(0),
            //       child: Row(
            //         children: [
            //           Expanded(
            //             child: SizedBox(
            //               height: 44,
            //               child: Stack(
            //                 children: [
            //                   Positioned(
            //                     left: 20,
            //                     bottom: 5,
            //                     child: SizedBox(
            //                       width: 200,
            //                       height: 44,
            //                       child: TextField(
            //                         controller: _controller,
            //                         decoration: InputDecoration(
            //                             border: InputBorder.none,
            //                             counterStyle: const TextStyle(
            //                                 color: Colors.black, fontSize: 14),
            //                             hintStyle: const TextStyle(
            //                                 color: Color.fromRGBO(
            //                                     204, 204, 204, 1),
            //                                 fontSize: 14),
            //                             hintText: tr("getsn")),
            //                         onChanged: (back) {
            //                           setState(() {
            //                             sn = back;
            //                           });
            //                         },
            //                       ),
            //                     ),
            //                   ),
            //                   if (sn != '')
            //                     Positioned(
            //                       right: 10,
            //                       top: 11,
            //                       child: GestureDetector(
            //                         onTap: () {
            //                           _controller.text = '';
            //                           setState(() {
            //                             sn = '';
            //                           });
            //                         },
            //                         child: const Icon(
            //                           Icons.cancel,
            //                           color: Color.fromRGBO(153, 153, 153, 1),
            //                         ),
            //                       ),
            //                     )
            //                 ],
            //               ),
            //             ),
            //           ),
            //           GestureDetector(
            //             onTap: () {
            //               openscan();
            //             },
            //             child: Padding(
            //               padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            //               child: Image.asset(
            //                 'public/images/waterPump/scran.png',
            //                 width: 40.w,
            //               ),
            //             ),
            //           ),
            //           Container(
            //             width: 110.w,
            //             height: 44,
            //             margin: const EdgeInsets.all(4),
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(36),
            //               gradient: const LinearGradient(
            //                 begin: Alignment.topLeft,
            //                 end: Alignment.bottomRight,
            //                 colors: [
            //                   Color(0xFF1CA2FF), // #1CA2FF
            //                   Color(0xFF0C69FF), // #0C69FF
            //                 ],
            //                 stops: [0.0, 0.97],
            //               ),
            //             ),
            //             child: const Center(
            //               child: Text(
            //                 '搜索',
            //                 style: TextStyle(color: Colors.white, fontSize: 14),
            //               ),
            //             ),
            //           ),
            //           const Padding(padding: EdgeInsets.fromLTRB(0, 0, 8, 0))
            //         ],
            //       ),
            //     )),
            Expanded(
                child: RefreshIndicator(
                    onRefresh: () async {
                      // 手动下拉刷新触发的方法
                      await _loadMoreData();
                    },
                    child: ListView.builder(
                        controller: _scrollController,
                        itemCount: pumbList.length,
                        itemBuilder: (context, index) => Container(
                              margin: EdgeInsets.fromLTRB(0, 24.h, 0, 0),
                              padding:
                                  EdgeInsets.fromLTRB(16.w, 36.h, 16.w, 36.h),
                              color: Colors.white,
                              width: 720.w,
                              height: 160.h,
                              child: InkWell(
                                onTap: () {
                                  if (!selectList
                                      .contains(pumbList[index]['address'])) {
                                    selectList.add(pumbList[index]['address']);
                                  } else {
                                    selectList
                                        .remove(pumbList[index]['address']);
                                  }
                                  setState(() {
                                    selectList;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 15, 0),
                                      child: Image.asset(
                                        pumbList[index]['indoorType'] != null
                                            ? 'public/images/V8/${pumbList[index]['indoorType']}.png'
                                            : 'public/images/V8/IduType_99.png',
                                        width: 124.w,
                                      ),
                                    ),
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${pumbList[index]['address']}#',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            if (pumbList[index]
                                                        ['runningstatys'] !=
                                                    null &&
                                                pumbList[index]
                                                    ['runningstatys'])
                                              Text('·${tr("running")}',
                                                  style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          6, 184, 0, 1),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            if (pumbList[index]
                                                        ['runningstatys'] !=
                                                    null &&
                                                !pumbList[index]
                                                    ['runningstatys'])
                                              Text('·${tr("close")}',
                                                  style: labelStyle())
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            if (modeMap[pumbList[index]
                                                    ['mode']] !=
                                                null)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 8, 0),
                                                child: runningModelImage(
                                                    pumbList[index]['mode']),
                                              ),
                                            Text('${pumbList[index]['mode']}',
                                                    style: labelStyle())
                                                .tr(),
                                            const Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  8, 0, 8, 0),
                                              child: Text('|'),
                                            ),
                                            Text(
                                                tr("tempShow", namedArgs: {
                                                  "val":
                                                      "${pumbList[index]['roomTemp'] != null ? pumbList[index]['roomTemp'].toStringAsFixed(1) : "--"}"
                                                }),
                                                style: labelStyle())
                                          ],
                                        ),
                                      ],
                                    )),
                                    RoundCheckBox(
                                      isChecked: selectList
                                          .contains(pumbList[index]['address']),
                                      onTap: (selected) {
                                        if (selected == true) {
                                          selectList
                                              .add(pumbList[index]['address']);
                                        } else {
                                          selectList.remove(
                                              pumbList[index]['address']);
                                        }
                                        setState(() {
                                          selectList;
                                        });
                                      },
                                      size: 20,
                                      checkedWidget: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      checkedColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      border: Border.all(
                                          // width: 1,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                    )
                                  ],
                                ),
                              ),
                            )))),
            Container(
              height: 57,
              padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
              child: Center(
                child: submitButton(
                  isActive: selectList.isNotEmpty,
                  label: tr('device.checkData.submit'),
                  onClick: () async {
                    if (selectList.isEmpty) {
                      return;
                    }
                    bool issend = await divConfirmOnlyDialog(context,
                        confirmText: tr("device.waterPumpInspection.confirm"),
                        confirmTitle:
                            tr("device.waterPumpInspection.confirmTitle"),
                        confirmDescriptionWidget: SizedBox(
                            width: 560.w,
                            height: 140,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                            'device.waterPumpInspection.confirmContent')
                                        .tr(),
                                  ],
                                ),
                              ),
                            )));

                    if (issend) {
                      Get.to(() => waterPumpInspectionSearchingPage(
                          indoorAddressList: selectList));
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

TextStyle labelStyle() {
  return const TextStyle(
      color: Color.fromRGBO(153, 153, 153, 1),
      fontSize: 12,
      fontWeight: FontWeight.w600);
}
