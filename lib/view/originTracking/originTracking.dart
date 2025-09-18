import 'dart:convert';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/expandable_widget.dart';
import 'package:fluoroscopy_tool/compent/snInput.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalData.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:fluoroscopy_tool/store/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../compent/infobox.dart';

import 'package:get/get.dart';

class originTrackingPage extends StatefulWidget {
  originTrackingPage({super.key});

  @override
  State<originTrackingPage> createState() => _originTrackingPageState();
}

class _originTrackingPageState extends State<originTrackingPage> {
  String generate64DigitNumber() {
    final random = Random.secure(); // 使用安全随机数生成器
    final buffer = StringBuffer();

    // 确保第一位不为0（避免前导零）
    buffer.write(1); // 生成1-9的数字

    // 生成剩余的63位数字
    for (int i = 0; i < 63; i++) {
      buffer.write(i < 30 ? 1 : random.nextInt(10)); // 生成0-9的数字
    }

    return buffer.toString();
  }

  String sn = '';

  String driverUid = '';

  String centralUid = '';

  var projects = {};
  int pageIndex = 0;
  int pageSize = 10;
  bool isLoading = false;
  bool hasMoreData = true;

  static const platform = MethodChannel('samples.flutter.dev/battery');

  static const _selfplatform =
      MethodChannel('samples.flutter.dev/AntiTamperingServiceHandler');
  openscan() async {
    try {
      await platform.invokeMethod('SCANNER_TRIG');
    } on PlatformException catch (e) {
      print("Failed to SCANNER_TRIG: '${e.message}'.");
    }
  }

  // 加载更多项目
  Future<void> _fetchMoreProjects() async {
    if (!isLoading && hasMoreData) {
      await _fetchProjects();
    }
  }

  // 刷新列表
  Future<void> _refreshProjects() async {
    setState(() {
      pageIndex = 0;
      hasMoreData = true;
    });
    await _fetchProjects();
  }

  // 获取项目列表
  Future<void> _fetchProjects() async {
    bool conn = await checkNet(true);
    if (!conn) {
      EasyLoading.dismiss();
      EasyLoading.showError("请连接网络");
      return;
    }
    if (isLoading) return;

    EasyLoading.show(status: 'loading...');
    setState(() {
      isLoading = true;
      projects = {};
    });

    var _send = {};
    _send = {"masterUid": sn, "centralUid": centralUid, "driverUid": driverUid};

    print("_fetchProjects _send : $_send");

    try {
      final response = await MideaApi.getDeviceReportRecord(_send);

      print("_fetchProjects response : $response");
      if (response['errorCode'] == 200) {
        final data = response['data'];
        print("_fetchProjects response : $data");
        setState(() {
          projects = response['data'];
          hasMoreData = false;
          isLoading = false;
        });
      } else {
        throw Exception('获取项目列表失败}');
      }
      EasyLoading.dismiss();
    } catch (e) {
      print("_fetchProjects response : $e");
      setState(() {
        isLoading = false;
      });
      // 显示错误提示
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('加载数据失败，请重试')));

      EasyLoading.dismiss();
    }
  }

  final deviceInfoController _deviceInfoController = Get.find();
  final ScrollController _scrollController = ScrollController();

  TextEditingController _controller = TextEditingController();
  // 1. 定义GlobalKey
  final GlobalKey<snInputState> _snInputKey = GlobalKey();
  Future<void> _readUUid() async {
    try {
      print(
          "_readUUid  ${double.parse(_deviceInfoController.outdoorEntityList[0]['version'].toString())}");
      if (double.parse(_deviceInfoController.outdoorEntityList[0]['version']
                  .toString()) >=
              28.3 ||
          _deviceInfoController.loacalDevice.value.oduTypeEnum == "OduType_9") {
        EasyLoading.show(status: 'loading...');
        try {
          var unLock = await _selfplatform
              .invokeMethod('getAntiTampering', <String, dynamic>{});
          var uuid = jsonDecode(unLock);
          print("getAntiTampering uuid: ${uuid["data"]["masterUid"]}");
          if (uuid["success"]) {
            sn = uuid["data"]["masterUid"] ?? "";
            centralUid = uuid["data"]["centralUid"] ?? "";
            driverUid = uuid["data"]["driverUid"] ?? "";
            setState(() {
              sn;
            });
            _controller.text = sn; // 调用子组件方法
          } else {
            EasyLoading.showError(unLock["errorMsg"]);
          }
          EasyLoading.dismiss();
        } catch (e) {
          print("--------  _readUUid --------  : $e");
          EasyLoading.dismiss();
        }
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          bool issend = await divConfirmOnlyDialog(context,
              isSubmitButton: true,
              confirmTitle: tr("device.controltDialog.confirmTitle"),
              confirmDescriptionWidget: SingleChildScrollView(
                child: SizedBox(
                    width: 560.w,
                    height: 140,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                              "查询UID失败，当前外机程序版本为v${_deviceInfoController.outdoorEntityList[0]['version']}，低于V28.3，请先将外机程序升级至≥v28.3后再进行询。"),
                        ],
                      ),
                    )),
              ));
        });
      }
    } catch (e) {
      print("_readUUid $e");
    }
  }

  _formatTimestamp(timeStr) {
    try {
      // 1. 解析时间字符串为 DateTime 对象
      DateTime dateTime = DateTime.parse(timeStr); // 自动处理 ISO 格式（含 T）

      // 2. 定义目标格式：yyyy年MM月dd日 HH:mm
      final formatter = DateFormat("yyyy年MM月dd日 HH:mm");

      // 3. 格式化为指定字符串
      return formatter.format(dateTime);
    } catch (e) {
      return "";
    }
  }

  @override
  void initState() {
    super.initState();
    // McuUtilplatform.invokeMethod('powerOn');
    // _scrollController.addListener(_onScroll);
    _readUUid();
    _controller.text = sn;
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    super.dispose();
  }

  // 滚动监听
  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchMoreProjects();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 先计算有效数据的数量
    final validItemCount = [
      "firstCentralUid",
      "firstDriverUid",
      "firstMasterUid"
    ].where((key) => projects[key] != null).length;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Get.offAllNamed('/home');
              },
              icon: const Icon(Icons.chevron_left,
                  color: Colors.black, size: 36)),
          title: const Text(
            'originTracking',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [],
        ),
        body: Container(
          width: 720.w,
          height: 1280.h,
          color: const Color.fromRGBO(244, 244, 244, 1),
          padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
          child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(8, 24.h, 8, 32.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '内部识别码',
                          style: ErrorTip(),
                        ).tr(),
                        Stack(
                          children: [
                            Positioned(
                                child: Container(
                              margin: const EdgeInsets.fromLTRB(0, 9, 0, 0),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(42),
                                  color: Colors.grey[300]),
                              child: Row(
                                children: [
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     openscan();
                                  //   },
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.fromLTRB(
                                  //         10, 0, 10, 0),
                                  //     child: Image.asset(
                                  //       'public/images/waterPump/scran.png',
                                  //       width: 40.w,
                                  //     ),
                                  //   ),
                                  // ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      // scribbleEnabled: true,
                                      // scrollPadding: const EdgeInsets.all(0.0),

                                      controller: _controller,
                                      onTap: () {},
                                      maxLines: 2,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          height: 1,
                                          fontSize: 16),
                                      decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 10),
                                          border: InputBorder.none,
                                          suffixStyle: const TextStyle(
                                              color: Colors.black,
                                              height: 1,
                                              fontSize: 16),
                                          labelStyle: const TextStyle(
                                              color: Colors.black,
                                              height: 1,
                                              fontSize: 16),
                                          counterStyle: const TextStyle(
                                              color: Colors.black,
                                              height: 1,
                                              fontSize: 16),
                                          hintStyle: TextStyle(
                                              height: sn == "" ? 1.5 : 1,
                                              color: const Color.fromRGBO(
                                                  140, 140, 140, 1),
                                              fontSize: 16),
                                          hintText: tr("scancode")),
                                      onChanged: (back) {
                                        setState(() {
                                          sn = back;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  )
                                ],
                              ),
                            )),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: 720.w,
                          height: 35,
                          child: submitButton(
                              isActive: true,
                              onClick: () {
                                if (sn.isEmpty) {
                                  _readUUid();
                                } else {
                                  _fetchProjects();
                                }
                              },
                              label: sn.isEmpty ? "读取" : "查询"),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    )),
              ),
              if (!projects.isEmpty)
                Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: ExpandableWidget(
                      // 折叠状态显示的内容
                      collapsedChild: Container(),

                      // 展开状态显示的内容
                      expandedChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 0.w, vertical: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: InkWell(
                                  onTap: () {
                                    copyTextToClipboard(sn, context);
                                  },
                                  child: _infobox(
                                    label: '主控:',
                                    val: sn ?? "",
                                  ),
                                ),
                              )),
                          Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 0.w, vertical: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: InkWell(
                                  onTap: () {
                                    copyTextToClipboard(sn, context);
                                  },
                                  child: _infobox(
                                    label: '中驱:',
                                    val: centralUid ?? "--",
                                  ),
                                ),
                              )),
                          Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 0.w, vertical: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: InkWell(
                                  onTap: () {
                                    copyTextToClipboard(sn, context);
                                  },
                                  child: _infobox(
                                    label: '模块:',
                                    val: driverUid ?? "--",
                                  ),
                                ),
                              )),
                        ],
                      ),

                      // 触发区域
                      toggleWidget: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '云端设备码识别',
                            style: titleText(),
                          ),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    )),
              if (!projects.isEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      "云端对应关系检索",
                      style: titleText(),
                    ),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                height: 320.h * validItemCount,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(), // 或不设置（默认值）
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    const keylist = [
                      "firstCentralUid",
                      "firstDriverUid",
                      "firstMasterUid"
                    ];
                    final item = projects[keylist[index]];
                    return item == null
                        ? Container()
                        : Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 32.w, vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          copyTextToClipboard(
                                              item['sn'], context);
                                        },
                                        child: _infobox(
                                          label: '设备SN:',
                                          val: item['sn'] ?? "",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                          onTap: () {
                                            copyTextToClipboard(
                                                item['uuid'], context);
                                          },
                                          child: _infobox(
                                            label:
                                                '${keylist[index] == "firstMasterUid" ? '主控' : keylist[index] == "firstCentralUid" ? '中驱' : '模块'}识别码:',
                                            val: item['uuid'] ?? "",
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      _infobox(
                                        label: '创建时间:',
                                        // val: formatTimestamp(item['uptime']),
                                        val: _formatTimestamp(
                                            item['createTime']),
                                      ),
                                    ],
                                  ))
                                ],
                              ),
                            ),
                          );
                  },
                ),
              ),
            ]),
          ),
        ));
  }
}

class _infobox extends StatelessWidget {
  String label;
  String val;
  _infobox({super.key, required this.label, required this.val});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: normalText(),
          ).tr(),
        ),
        Expanded(
            child: Text(
          val,
          style: normalTextBlack(),
        ).tr())
      ],
    );
  }
}
