import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/scanPage.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/view/local/checkData/IndoorUnitCentralControl/conSendding.dart';
import 'package:fluoroscopy_tool/view/local/style.dart';
import 'package:fluoroscopy_tool/store/http.dart';
import 'package:fluoroscopy_tool/waterpumb/qualityInspection/deviceGatewayController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class gaywayQueryPage extends StatefulWidget {
  gaywayQueryPage({super.key});

  @override
  State<gaywayQueryPage> createState() => _gaywayQueryPageState();
}

class _gaywayQueryPageState extends State<gaywayQueryPage> {
  var info;

  DeviceGatewayController con = Get.find();
  @override
  void initState() {
    super.initState();
    con.resetToDefaults();
  }

  toSearch(sn) async {
    con.resetToDefaults();
    EasyLoading.show(status: 'loading...');
    try {
      final prefs = await SharedPreferences.getInstance();
      var deviceSn = await prefs.getString('deviceSn');
      if (deviceSn != null) {
        var getSearchHistories = await MideaApi.queryWaterMachineStatus(
            {"deviceSn": "$sn", "deviceId": "$deviceSn"});
        EasyLoading.dismiss();
        if (getSearchHistories['success']) {
          con.updateFromJson(getSearchHistories['data']);
        } else {
          EasyLoading.showError(getSearchHistories['errorMsg'] ?? "请求接口异常");
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeviceGatewayController>(
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
                '网关注册连接状态查询',
                style: TextStyle(color: Colors.black),
              ).tr(),
              centerTitle: true,
              actions: const [],
            ),
            body: Container(
              width: 720.w,
              height: 1280.h,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, // 对应180deg
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Colors.white,
                    Colors.white,
                  ],
                  stops: [0.01, 0.47, 0.98], // 对应百分比位置
                ),
              ),
              padding: EdgeInsets.fromLTRB(0.w, 64.h, 0.w, 64.h),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(32.w, 0, 32.w, 16.h),
                      child: snBox(onSubmitted: (sn) {
                        print("onSubmitted sn ------   $sn");
                        toSearch(sn);
                      }),
                    ),
                    Container(
                      height: 8,
                      color: const Color.fromRGBO(247, 247, 247, 1),
                    ),
                    const GatewayStatusPage(),
                    Container(
                      height: 8,
                      color: const Color.fromRGBO(247, 247, 247, 1),
                    ),
                    const HistorySearchPage(),
                    Container(
                      height: 8,
                      color: const Color.fromRGBO(247, 247, 247, 1),
                    ),
                    const HistorySearchSelfIDPage()
                  ],
                ),
              ),
            )));
  }
}

class snBox extends StatefulWidget {
  final ValueChanged<String?>? onSubmitted; // 定义回调函数
  const snBox({
    super.key,
    this.onSubmitted,
  });

  @override
  State<snBox> createState() => _snBoxState();
}

class _snBoxState extends State<snBox> {
  // 整机条码输入控制器
  TextEditingController _barcodeController = TextEditingController();
  // 拼接机组单选按钮状态，默认未选中
  bool _isSplicingUnit = false;
  // 拼接台数
  int _splicingCount = 0;
  String snInput = "";

  final MethodChannel methodChannel = const MethodChannel('scan.data');

  @override
  void initState() {
    super.initState();
    snInput = "";
    methodChannel.setMethodCallHandler((call) async {
      if (call.method == 'data') {
        if (call.arguments == "null") {
          return;
        }
        print('setMethodCallHandler ---- ' + call.arguments);
        snInput = call.arguments;
        bool? isSplicingUnit = _isSplicingUnit;
        int splicingCount = _splicingCount;

        print(
            '整机条码(${call.arguments.length})：${call.arguments}，拼接机组：$isSplicingUnit，拼接台数：$splicingCount');
        if (call.arguments != "") {
          _barcodeController.text =
              processBarcode(call.arguments, isSplicingUnit, splicingCount);

          print(
              '整机条码：${processBarcode(call.arguments, isSplicingUnit, splicingCount)}');
        }
        // _barcodeController.text = call.arguments;
      }
    });
  }

  @override
  void dispose() {
    methodChannel.setMethodCallHandler(null);
    super.dispose();
  }

  String processBarcode(
      String barcode, bool isSplicingUnit, int splicingCount) {
    // 补齐为32位

    // 处理拼接机组（修改倒数第4位）
    if (isSplicingUnit && barcode.length >= 4) {
      print(' 处理拼接机组（修改倒数第4位）');
      int index = barcode.length - 4;
      String countChar =
          splicingCount.toString().padLeft(1, '0').substring(0, 1);
      barcode = barcode.substring(0, index) +
          countChar +
          barcode.substring(index + 1);
    }

    // 补齐为32位
    if (barcode.length < 32) {
      barcode = barcode.padRight(32, '0');
    }

    return barcode;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Column(
          children: [
            // 单独处理 * 为红色，其余文字为 #666666
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                  child: Center(
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text: '扫描整机条码',
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    RoundCheckBox(
                      isChecked: _isSplicingUnit,
                      onTap: (selected) {
                        setState(() {
                          _isSplicingUnit = !_isSplicingUnit;
                        });
                      },
                      size: 18,
                      checkedWidget: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                      checkedColor: Theme.of(context).colorScheme.secondary,
                      border: Border.all(
                          // width: 1,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isSplicingUnit = !_isSplicingUnit;

                          String barcode = snInput;
                          bool? isSplicingUnit = _isSplicingUnit;
                          int splicingCount = _splicingCount;

                          print(
                              '整机条码：$barcode，拼接机组：$isSplicingUnit，拼接台数：$splicingCount');
                          if (barcode != "") {
                            _barcodeController.text = processBarcode(
                                barcode, isSplicingUnit, splicingCount);
                          }
                        });
                      },
                      child: const Text('拼接机组',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          )),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('拼接台数',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        )),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (_splicingCount > 0) {
                            _splicingCount--;
                          }
                          String barcode = snInput;
                          bool? isSplicingUnit = _isSplicingUnit;
                          int splicingCount = _splicingCount;

                          print(
                              '整机条码：$barcode，拼接机组：$isSplicingUnit，拼接台数：$splicingCount');
                          if (barcode != "") {
                            _barcodeController.text = processBarcode(
                                barcode, isSplicingUnit, splicingCount);
                          }
                        });
                      },
                      child: Container(
                        width: 32,
                        padding: const EdgeInsets.all(8),
                        child: const Center(
                          child: Icon(
                            Icons.remove,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7), // 对应 #F7F7F7
                        borderRadius: BorderRadius.circular(4.8), // 圆角半径4.8px
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Center(
                        child: Text(
                          '$_splicingCount',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (_splicingCount < 9) _splicingCount++;

                          String barcode = snInput;
                          bool? isSplicingUnit = _isSplicingUnit;
                          int splicingCount = _splicingCount;

                          print(
                              '整机条码：$barcode，拼接机组：$isSplicingUnit，拼接台数：$splicingCount');
                          if (barcode != "") {
                            _barcodeController.text = processBarcode(
                                barcode, isSplicingUnit, splicingCount);
                          }
                        });
                      },
                      child: Container(
                        width: 32,
                        padding: const EdgeInsets.all(8),
                        child: const Center(
                          child: Icon(
                            Icons.add,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: Color.fromRGBO(223, 223, 223, 1),
                      width: 0.5,
                    ),
                  )),
              child: Stack(
                children: [
                  TextField(
                    controller: _barcodeController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        suffixStyle: TextStyle(
                            color: Colors.black, height: 1, fontSize: 16),
                        labelStyle: TextStyle(
                            color: Colors.black, height: 1, fontSize: 16),
                        counterStyle: TextStyle(
                            color: Colors.black, height: 1, fontSize: 16),
                        hintStyle: TextStyle(
                            height: 1,
                            color: Color.fromRGBO(204, 204, 204, 1),
                            fontSize: 16),
                        hintText: "请扫码识别"),
                  ),
                  Positioned(
                      right: 0,
                      child: InkWell(
                        onTap: () async {
                          var sn = await Get.to(scanPage());
                          if (sn != null) {
                            EasyLoading.showSuccess('扫描成功');
                            String barcode = sn;
                            bool? isSplicingUnit = _isSplicingUnit;
                            int splicingCount = _splicingCount;
                            if (sn != "" && sn != null) {
                              _barcodeController.text = processBarcode(
                                  barcode, isSplicingUnit, splicingCount);
                            } else {
                              _barcodeController.text = '';
                            }

                            snInput = barcode;
                          } else {
                            EasyLoading.showError('扫描失败');
                          }
                        },
                        child: Image.asset(
                          'public/images/icon/scan@3x.png',
                          width: 36,
                          color: const Color.fromRGBO(13, 13, 13, 0.5),
                        ),
                      ))
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: SizedBox(
            width: 160.w,
            height: 72.h,
            child: submitButton(
              onClick: () {
                widget.onSubmitted!(_barcodeController.text);
              },
              label: '查询',
              isActive: true,
            ),
          ),
        ),
      ],
    ));
  }
}

class GatewayStatusPage extends StatelessWidget {
  const GatewayStatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeviceGatewayController>(
        builder: (_) => Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  child: Column(
                    children: [
                      const ListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          '网关状态查询',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      // 云端注册状态
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        title: Text(
                          '云端注册状态',
                          style: lableListTileText,
                        ),
                        trailing: Text(
                            !_.afterfeath.value
                                ? ''
                                : _.registrationStatus.value
                                    ? "已注册"
                                    : "未注册",
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                      ),
                      const Divider(color: Color(0xFFDFDFDF)), // 分割线
                      // 网关在线状态
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        title: Text(
                          '网关在线状态',
                          style: lableListTileText,
                        ),
                        trailing: Text(
                            !_.afterfeath.value ? '' : _.getGatewayStatus(),
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                      ),
                      const Divider(color: Color(0xFFDFDFDF)),
                      // 设备在线状态
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        title: Text(
                          '设备在线状态',
                          style: lableListTileText,
                        ),
                        trailing: Text(
                            !_.afterfeath.value ? '' : _.getDeviceStatusDesc(),
                            // ignore: prefer_const_constructors
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                      ),
                      const Divider(color: Color(0xFFDFDFDF)),
                      // 水机组配置信息标题
                      const ListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          '水机组配置信息',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 330,
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  child: CustomTableDemo(),
                )
              ],
            ));
  }
}

class CustomTableDemo extends StatelessWidget {
  // 模拟表格数据，实际可从接口/模型取

  final List<Map<String, String>> tableData = const [
    {'label': '机组类型', 'key': 'supplyType', 'value': ''},
    {'label': '机组类型', 'key': 'deviceType', 'value': ''},
    {'label': '机头数量', 'key': 'headNum', 'value': ''},
    {'label': '是否带热回收', 'key': 'isHeatRecovery', 'value': ''},
    {'label': '是否带液位', 'key': 'isLiquid', 'value': ''},
    // {'label': '负荷调节方式', 'key': 'loadRegulationMode', 'value': ''},
    // {'label': '风冷翅片形状', 'key': 'airCooledShape', 'value': ''},
    {'label': '电机传动方式', 'key': 'motorDriveMode', 'value': ''},
  ];

  CustomTableDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeviceGatewayController>(
        builder: (_) => ListView.builder(
              physics: const NeverScrollableScrollPhysics(), // 禁止滚动
              itemCount: tableData.length,
              itemBuilder: (context, index) {
                final item = tableData[index];
                return Container(
                  // 每行边框：底部边框（最后一行可隐藏）
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color.fromRGBO(247, 247, 247, 1),
                        width: 0.5,
                      ),
                      left: BorderSide(
                        color: Color.fromRGBO(247, 247, 247, 1),
                        width: 1,
                      ),
                      right: BorderSide(
                        color: Color.fromRGBO(247, 247, 247, 1),
                        width: 1,
                      ),
                      bottom: BorderSide(
                        color: Color.fromRGBO(247, 247, 247, 1),
                        width: 0.5,
                      ),
                    ),
                  ),
                  // 行内容：左右两列
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 350.w,
                        color: const Color.fromRGBO(247, 247, 247, 1),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        child: Center(
                          child: Text(
                            item['label']!,
                            style: lableListTileText,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Center(
                        child: Text(
                          _.getFormattedDisplayValue(item['key']!),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ))
                    ],
                  ),
                );
              },
            ));
  }
}

TextStyle lableListTileText =
    const TextStyle(color: Color.fromRGBO(102, 102, 102, 1), fontSize: 14);

class HistorySearchPage extends StatefulWidget {
  const HistorySearchPage({super.key});

  @override
  State<HistorySearchPage> createState() => _HistorySearchPageState();
}

class _HistorySearchPageState extends State<HistorySearchPage> {
  final TextEditingController _snController = TextEditingController();
  List<Map<String, String>> _searchResults = [
    {"queryTime": "--", "result": "--", "deviceId": "--"},
  ];

  Future<void> _search() async {
    String sn = _snController.text.trim();
    if (sn.isNotEmpty) {
      EasyLoading.show(status: 'loading...');
      try {
        _searchResults = [];
        var getSearchHistories =
            await MideaApi.getWaterMachineCheckRecordList({"deviceSn": "$sn"});
        EasyLoading.dismiss();
        for (var element in getSearchHistories['data']) {
          _searchResults.add({
            "queryTime": element["queryTime"] ?? "--",
            "result": element["result"] ?? "--",
            "deviceId": element["deviceId"] ?? "--",
          });
        }

        print(_searchResults);
        setState(() {
          _searchResults;
        });
      } catch (e) {
        EasyLoading.dismiss();
        setState(() {
          _searchResults = [
            {"queryTime": "--", "result": "--", "deviceId": "--"},
          ];
        });
      }
    } else {
      setState(() {
        _searchResults = [
          {"queryTime": "--", "result": "--", "deviceId": "--"},
        ];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: Column(
          children: [
            const ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Text(
                '历史记录搜索',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            // 自定义样式的搜索栏区域
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(42.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _snController,
                      decoration: const InputDecoration(
                        hintText: '请输入设备SN',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                    ),
                  ),
                  // 自定义样式的搜索按钮
                  ElevatedButton(
                    onPressed: _search,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1962FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(36.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12.0),
                    ),
                    child: const Text('搜索'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // 结果展示表格
            CustomHistoryTable(
              key: ValueKey('_searchResults_${_searchResults.length}'),
              searchResults: _searchResults,
            ),
            const SizedBox(height: 16),
          ],
        ));
  }
}

class HistorySearchSelfIDPage extends StatefulWidget {
  const HistorySearchSelfIDPage({super.key});

  @override
  State<HistorySearchSelfIDPage> createState() => _HistorySearchSelfIDPage();
}

class _HistorySearchSelfIDPage extends State<HistorySearchSelfIDPage> {
  final TextEditingController _snController = TextEditingController();
  List<Map<String, String>> _searchResults = [
    {"deviceSN": "--", "queryTime": "--", "result": "--", "deviceId": "--"},
  ];

  Future<void> _search() async {
    EasyLoading.show(status: 'loading...');
    try {
      final prefs = await SharedPreferences.getInstance();
      var deviceSn = await prefs.getString('deviceSn');
      _searchResults = [];
      var getSearchHistories = await MideaApi.getWaterMachineCheckRecordList(
          {"deviceId": "$deviceSn"});
      EasyLoading.dismiss();
      for (var element in getSearchHistories['data']) {
        _searchResults.add({
          "deviceSN": element["deviceSN"] ?? "--",
          "queryTime": element["queryTime"] ?? "--",
          "result": element["result"] ?? "--",
          "deviceId": element["deviceId"] ?? "--",
        });
      }

      setState(() {
        _searchResults;
      });
    } catch (e) {
      EasyLoading.dismiss();
      setState(() {
        _searchResults = [
          {
            "deviceSN": "--",
            "queryTime": "--",
            "result": "--",
            "deviceId": "--"
          },
        ];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _search();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: const Text(
                '最近查询结果',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: ElevatedButton(
                onPressed: _search,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1962FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(36.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                ),
                child: const Text('刷新'),
              ),
            ),
            const SizedBox(height: 16),
            // 结果展示表格
            CustomHistorySelfTable(
              key:
                  ValueKey('_HistorySearchSelfIDPage_${_searchResults.length}'),
              searchResults: _searchResults,
            ),

            const SizedBox(height: 16),
          ],
        ));
  }
}

class CustomHistoryTable extends StatelessWidget {
  List searchResults;
  CustomHistoryTable({Key? key, required this.searchResults}) : super(key: key);

  String formatDateTime(String dateString) {
    try {
      // 解析 ISO 8601 格式的日期字符串
      final dateTime = DateTime.parse(dateString);

      // 提取各部分并补零
      final year = dateTime.year.toString();
      final month = dateTime.month.toString().padLeft(2, '0');
      final day = dateTime.day.toString().padLeft(2, '0');
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final second = dateTime.second.toString().padLeft(2, '0');

      // 拼接成 yyyy-mm-dd hh:mm:ss 格式
      return '$year-$month-$day $hour:$minute:$second';
    } catch (e) {
      return '--';
    }
  }

  var resultMap = {
    "fail": "失败",
    "success": "成功",
  };
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1.0),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 表头行
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF7F7F7),
              border: Border(
                bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
              ),
            ),
            child: Row(
              children: [
                // 第一列 - 查询时间
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                      ),
                    ),
                    child: const Text(
                      '查询时间',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // 第二列 - 查询结果
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                      ),
                    ),
                    child: const Text(
                      '查询结果',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // 第三列 - 所用设备标识
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: const Text(
                      '所用设备标识',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 数据行
          SizedBox(
              height: 48 * 3,
              child: ListView.builder(
                itemBuilder: ((context, index) => Row(
                      children: [
                        // 第一列数据
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 8),
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                    color: Color(0xFFEEEEEE), width: 1.0),
                                bottom: BorderSide(
                                    color: Color(0xFFEEEEEE), width: 0),
                              ),
                            ),
                            child: Center(
                              child: Text(formatDateTime(
                                  searchResults[index]['queryTime'])),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 8),
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                    color: Color(0xFFEEEEEE), width: 1.0),
                                bottom: BorderSide(
                                    color: Color(0xFFEEEEEE), width: 0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                  resultMap[searchResults[index]['result']] ??
                                      "--"),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 8),
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                    color: Color(0xFFEEEEEE), width: 1.0),
                                bottom: BorderSide(
                                    color: Color(0xFFEEEEEE), width: 0),
                              ),
                            ),
                            child: Center(
                              child: Text(searchResults[index]['deviceId']),
                            ),
                          ),
                        ),
                      ],
                    )),
                itemCount: this.searchResults.length,
              )),

          // 可添加更多数据行...
        ],
      ),
    );
  }
}

class CustomHistorySelfTable extends StatelessWidget {
  List searchResults;
  CustomHistorySelfTable({Key? key, required this.searchResults})
      : super(key: key);

  String formatDateTime(String dateString) {
    try {
      // 解析 ISO 8601 格式的日期字符串
      final dateTime = DateTime.parse(dateString);

      // 提取各部分并补零
      final year = dateTime.year.toString();
      final month = dateTime.month.toString().padLeft(2, '0');
      final day = dateTime.day.toString().padLeft(2, '0');
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final second = dateTime.second.toString().padLeft(2, '0');

      // 拼接成 yyyy-mm-dd hh:mm:ss 格式
      return '$year-$month-$day $hour:$minute:$second';
    } catch (e) {
      return '--';
    }
  }

  var resultMap = {
    "fail": "失败",
    "success": "成功",
  };
  @override
  Widget build(BuildContext context) {
    double itemheight = 58.0;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1.0),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 表头行
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF7F7F7),
              border: Border(
                bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
              ),
            ),
            child: Row(
              children: [
                // 第一列 - 查询时间
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                      ),
                    ),
                    child: const Text(
                      '设备SN',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // 第二列 - 查询结果
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                      ),
                    ),
                    child: const Text(
                      '查询结果',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // 第三列 - 所用设备标识
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: const Text(
                      '查询时间',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 数据行
          SizedBox(
              height: itemheight * 3,
              child: ListView.builder(
                itemBuilder: ((context, index) => Row(
                      children: [
                        // 第一列数据
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: itemheight,
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 8),
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                    color: Color(0xFFEEEEEE), width: 1.0),
                                bottom: BorderSide(
                                    color: Color(0xFFEEEEEE), width: 0),
                              ),
                            ),
                            child: Center(
                              child: Text(searchResults[index]['deviceSN']),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: itemheight,
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 8),
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                    color: Color(0xFFEEEEEE), width: 1.0),
                                bottom: BorderSide(
                                    color: Color(0xFFEEEEEE), width: 0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                  resultMap[searchResults[index]['result']] ??
                                      "--"),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: itemheight,
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 8),
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                    color: Color(0xFFEEEEEE), width: 1.0),
                                bottom: BorderSide(
                                    color: Color(0xFFEEEEEE), width: 0),
                              ),
                            ),
                            child: Center(
                              child: Text(formatDateTime(
                                  searchResults[index]['queryTime'])),
                            ),
                          ),
                        ),
                      ],
                    )),
                itemCount: this.searchResults.length,
              )),

          // 可添加更多数据行...
        ],
      ),
    );
  }
}
