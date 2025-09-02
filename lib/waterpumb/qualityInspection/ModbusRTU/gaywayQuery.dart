import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/http.dart';
import 'package:fluoroscopy_tool/waterpumb/pumbReport/create/public/InstallationInfo.dart';
import 'package:fluoroscopy_tool/waterpumb/qualityInspection/ModbusRTU/public/publicObject.dart';
import 'package:fluoroscopy_tool/waterpumb/qualityInspection/ModbusRTU/rtuCheck.dart';
import 'package:fluoroscopy_tool/waterpumb/qualityInspection/deviceGatewayController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../compent/snBox.dart';
import '../../pumbReport/create/public/buildFormItem.dart';

class gaywayRTUCheckPage extends StatefulWidget {
  gaywayRTUCheckPage({super.key});

  @override
  State<gaywayRTUCheckPage> createState() => _gaywayRTUCheckPageState();
}

class _gaywayRTUCheckPageState extends State<gaywayRTUCheckPage> {
  @override
  void initState() {
    super.initState();
    McuUtilplatform.invokeMethod('powerOff');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ischecking = false;
    McuUtilplatform.invokeMethod('powerOn');
    EasyLoading.dismiss();
  }

  final GlobalKey<_HistorySearchPageState> historyKey = GlobalKey();

  static const platform =
      MethodChannel('samples.flutter.dev/waterpumbBasicHandler');

  // 获取当前时间并格式化为 yyyy-mm-dd hh:mm:ss
  String getCurrentFormattedTime() {
    // 获取当前时间
    DateTime now = DateTime.now();
    return formatToTarget(now);
    // 定义格式化模板（yyyy-MM-dd HH:mm:ss）
    // 注意：HH 表示 24小时制，hh 表示 12小时制
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

    // 格式化时间并返回
    return formatter.format(now);
  }

  // 格式化时间为目标格式
  String formatToTarget(DateTime time) {
    // 转换为 UTC 时间并调用原生方法（格式类似 2025-08-20T06:43:09.953Z）
    String isoString = time.toUtc().toIso8601String();

    // 处理原生方法可能产生的微秒（如果需要保留3位毫秒）
    // 例如：原生可能输出 2025-08-20T06:43:09.953456Z，截取前3位毫秒
    if (isoString.contains('.')) {
      final parts = isoString.split('.');
      if (parts.length == 2) {
        // 取毫秒部分前3位 + 'Z'
        final millis = parts[1].substring(0, 3) + 'Z';
        return '${parts[0]}.$millis';
      }
    }

    // 若无毫秒，手动添加 .000Z
    return '$isoString.000Z';
  }

  var _pointValueMap = null;
  _handelresult(val) {
    print(val);
    try {
      var data = jsonDecode(val);
      if (data['data'] != null) {
        setState(() {
          checkingStatus = data['data']['result'] == "fail" ? 4 : 3;
          _pointValueMap = data['data']['pointValueMap'] ?? {};
        });
        _uploadResult(data['data']['result'], starttime);
      }
    } catch (e) {}
  }

  static const McuUtilplatform = MethodChannel('samples.flutter.dev/McuUtil');
  var starttime = '';
  bool ischecking = false;
  _start() async {
    if (ischecking) {
      return;
    }
    try {
      setState(() {
        checkingStatus = 2;
        _pointValueMap = null;
      });
      ischecking = true;

      McuUtilplatform.invokeMethod('powerOn');
      await Future.delayed(const Duration(seconds: 1));

      starttime = getCurrentFormattedTime();
      platform.invokeMethod('checkDevice', <String, dynamic>{
        "debugModel": _gettype(debugModel),
        "baudRate": _baudRate,
        "parity": _parity,
        "stopBit": _stopBit,
        "address": address,
        "readstart": readstart,
        "readlength": readlength
      }).then((value) => {ischecking = false, _handelresult(value)});
    } catch (e) {
      ischecking = false;
      setState(() {
        checkingStatus = 1;
      });
    }
  }

  _gettype(debugModel) {
    String _productModel = '';
    switch (debugModel) {
      case '磁悬浮':
        _productModel = 'magneticLevitationChiller';
        break;
      case '离心机组':
        _productModel = 'centrifugalChiller';
        break;
      case '空压机':
        _productModel = 'airCompressor';
        break;

      case '水冷螺杆':
        _productModel = 'waterCooledChiller';
        break;
      case '风冷螺杆':
        _productModel = 'airCooledChiller';
        break;
      case '涡旋机':
        _productModel = 'scrollChiller';
        break;

      case '自定义':
        _productModel = 'selfSettingCheck';
        break;
      default:
    }
    return _productModel;
  }

  _uploadResult(result, startTime) async {
    var productModelMap = {
      "离心机组": "centrifugalChiller",
      "磁悬浮冷水机组": "magneticLevitationChiller",
      "涡旋机组": "scrollChiller",
      "水冷螺杆机组": "waterCooledChiller",
      "风冷螺杆机组": "airCooledChiller",
      "自定义": "selfSettingCheck",
    };

    EasyLoading.show(status: 'loading...');

    final prefs = await SharedPreferences.getInstance();
    var machineId = await prefs.getString('deviceSn');
    if (deviceSn != null) {
      var getSearchHistories = await MideaApi.uploadWaterSerialPortRecord({
        "endTime": getCurrentFormattedTime(),
        "machineId": machineId,
        "productModel": _gettype(debugModel), // 磁悬浮冷水机组
        "result": result, // true flase ??
        "sn": deviceSn,
        "startTime": startTime
      });
      print(getSearchHistories);
      EasyLoading.dismiss();
      if (getSearchHistories['success']) {
        historyKey.currentState?.inittable();
      } else {
        EasyLoading.showError(getSearchHistories['errorMsg'] ?? "请求接口异常");
      }
    }
  }

  bool isStoping = false;
  _starsetStop() async {
    print('isStoping: $isStoping');
    if (isStoping) {
      print('跳出 _starsetStop');
      return;
    }
    EasyLoading.show(status: 'loading...');
    isStoping = true;
    try {
      print('调用 setStop');
      var back = await platform.invokeMethod('setStop', <String, dynamic>{});

      McuUtilplatform.invokeMethod('powerOff');
      print('back: $back');
      await Future.delayed(const Duration(seconds: 2));
      isStoping = false;

      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  int checkingStatus = 1; // 1 - 未检测 、2 - 检测中、3 - 成功、4 - 失败
  Map checkingStatusMap = {
    1: {"label": '未检测', "color": const Color.fromRGBO(187, 187, 187, 1)},
    2: {"label": '检测中', "color": const Color.fromRGBO(187, 187, 187, 1)},
    3: {"label": '通过', "color": const Color.fromRGBO(79, 202, 103, 1)},
    4: {"label": '失败', "color": const Color.fromRGBO(255, 0, 0, 1)}
  };
  final _formKey = GlobalKey<FormState>();
  String deviceSn = '';
  // 波特率选项
  String _baudRate = '9600';
  final List<selectItem> _baudRateOptions = [
    selectItem(label: '4800', val: '4800'),
    selectItem(label: '9600', val: '9600'),
    selectItem(label: '19200', val: '19200'),
    selectItem(label: '38400', val: '38400'),
  ];
  // 检验位选项
  String _parity = 'None';
  final List<selectItem> _parityOptions = [
    selectItem(label: 'None', val: 'None'),
    selectItem(label: 'Odd', val: 'Odd'),
    selectItem(label: 'Even', val: 'Even'),
  ];
  // 停止位选项
  String _stopBit = '1';
  final List<selectItem> _stopBitOptions = [
    selectItem(label: '1', val: '1'),
    selectItem(label: '2', val: '2')
  ];

  String debugModel = '磁悬浮';
  final List<selectItem> _debugModelOptions = [
    selectItem(label: "离心机", val: "离心机"),
    selectItem(label: "磁悬浮", val: "磁悬浮"),
    selectItem(label: "空压机", val: "空压机"),
    selectItem(label: "水冷螺杆", val: "水冷螺杆"),
    selectItem(label: "风冷螺杆", val: "风冷螺杆"),
    selectItem(label: "涡旋机", val: "涡旋机"),
    selectItem(label: "自定义", val: "自定义")
  ];
  String address = '1';
  String readstart = '3890';
  String readlength = '4';

  setDisableItemByType(type) {
    switch (type) {
      case '磁悬浮':
        readstart = '3890';
        readlength = '4';
        break;
      case '离心机组':
        readstart = '2599';
        readlength = '4';
        break;
      case '空压机':
        readstart = '2575';
        readlength = '4';
        break;

      case '水冷螺杆':
        readstart = '50';
        readlength = '4';
        break;
      case '风冷螺杆':
        readstart = '1287';
        readlength = '4';
        break;
      case '涡旋机':
        readstart = '10263';
        readlength = '4';
        break;
      default:
    }
    setState(() {
      readstart;
      readlength;

      address = "1";
    });
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
            '网关串口出厂检测',
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
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(32.w, 0, 32.w, 16.h),
                      child: snBox(
                          showSubmit: false,
                          onSubmitted: (sn) {
                            print("onSubmitted sn ------   $sn");
                            setState(() {
                              deviceSn = sn ?? "";
                            });
                          }),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 16),
                        child: Column(children: [
                          const ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: Text(
                              '串口设置',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          selectWidget('波特率', _baudRate, _baudRateOptions,
                              (val) {
                            if (val != null) {
                              setState(() {
                                _baudRate = val;
                              });
                            }
                          }),
                          selectWidget('检验位', _parity, _parityOptions, (val) {
                            if (val != null) {
                              setState(() {
                                _parity = val;
                              });
                            }
                          }),
                          selectWidget('停止位', _stopBit, _stopBitOptions, (val) {
                            if (val != null) {
                              setState(() {
                                _stopBit = val;
                              });
                            }
                          }),
                          const ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: Text(
                              '数据配置',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          selectWidget('机型选择', debugModel, _debugModelOptions,
                              (val) {
                            if (val != null) {
                              setState(() {
                                debugModel = val;
                              });
                              setDisableItemByType(val);
                            }
                          }),
                          TextSelectWidget('从站地址', address, debugModel != '自定义',
                              (val) {
                            if (val != null) {
                              print('从站地址: $val');
                              setState(() {
                                address = val;
                              });
                            }
                          }),
                          TextSelectWidget(
                              '起始寄存器地址', readstart, debugModel != '自定义', (val) {
                            if (val != null) {
                              setState(() {
                                readstart = val;
                              });
                            }
                          }),
                          TextSelectWidget(
                              '读取长度', readlength, debugModel != '自定义', (val) {
                            if (val != null) {
                              setState(() {
                                readlength = val;
                              });
                            }
                          }, minValue: 0, maxValue: 4)
                        ])),
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 16),
                        child: SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (checkingStatus == 2)
                                SizedBox(
                                  width: 180.w,
                                  height: 72.h,
                                  child: normalButton(
                                    label: "停止检测",
                                    onClick: () {
                                      _starsetStop();
                                    },
                                  ),
                                ),
                              if (checkingStatus != 2)
                                SizedBox(
                                  width: 180.w,
                                  height: 72.h,
                                  child: submitButton(
                                      label: "开始检测",
                                      onClick: () {
                                        if (deviceSn != "" &&
                                            deviceSn.length == 32 &&
                                            address.isNotEmpty &&
                                            readstart.isNotEmpty &&
                                            readlength.isNotEmpty) _start();
                                      },
                                      isActive: deviceSn != "" &&
                                          deviceSn.length == 32 &&
                                          address.isNotEmpty &&
                                          readstart.isNotEmpty &&
                                          readlength.isNotEmpty),
                                )
                            ],
                          ),
                        )),
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 16),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                '检测结果',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(42, 0, 8, 0),
                                child: Icon(Icons.brightness_1,
                                    size: 12,
                                    color: checkingStatusMap[checkingStatus]
                                        ['color']),
                              ),
                              Text(
                                checkingStatusMap[checkingStatus]['label'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: checkingStatusMap[checkingStatus]
                                        ['color']),
                              )
                            ],
                          ),
                          trailing: checkingStatus != 1
                              ? TextButton(
                                  onPressed: () {
                                    Get.to(() => rtuCheckpage(
                                        checkingStatus: checkingStatus));
                                  },
                                  child: const Text(
                                    '查看报文',
                                    style: TextStyle(
                                        color: Color.fromRGBO(25, 98, 255, 1),
                                        fontWeight: FontWeight.bold),
                                  ))
                              : null,
                        )),
                    const SizedBox(
                      height: 16,
                    ),
                    // 寄存器地址
                    if (_pointValueMap != null &&
                        _pointValueMap.toString() != "{}")
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 16),
                          child: Column(children: [
                            const ListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Text(
                                '寄存器地址',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            ..._pointValueMap!.entries.map((entry) {
                              // entry.key 是寄存器地址（如 "3890"）
                              // entry.value 是对应的值（如 65136.0）
                              return TextSelectWidget(
                                entry.key, // 作为 key 参数（寄存器地址）
                                entry.value.toString(), // 作为 val 参数（转换为字符串显示）
                                true,
                                (val) {
                                  // 处理值变化的回调
                                  print('${entry.key} 新值: $val');
                                },
                              );
                            }).toList(),
                            const SizedBox(
                              height: 16,
                            ),
                          ])),

                    HistorySearchPage(
                      key: historyKey,
                      sn: deviceSn,
                    )
                  ],
                )),
          ),
        ));
  }
}

Future<int?> showBottomSheetDialog(List<selectItem> options, String selected,
    String title, BuildContext context) {
  return showModalBottomSheet<int>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            SizedBox(
              height: 200,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      children: [
                        // Icon(Icons.check_circle,
                        //     color: selected == options[index].label
                        //         ? Colors.blue
                        //         : Colors.grey),
                        // const SizedBox(
                        //   width: 10,
                        // ),
                        Expanded(child: Text(options[index].label ?? "--"))
                      ],
                    ),
                    onTap: () => Navigator.pop(context, index),
                  );
                },
              ),
            ),
            SizedBox(
              width: 620.w,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                child: const Text('取消'),
              ),
            )
          ],
        ),
      );
    },
  );
}

class selectWidget extends StatelessWidget {
  String text;
  String val;
  List<selectItem> op;
  Function onChange;

  // Constructor to initialize the widget with data
  selectWidget(this.text, this.val, this.op, this.onChange);

  _showselect(context, op, val, title) async {
    var _projectName =
        await showBottomSheetDialog(op ?? [], val, title, context);
    print('_projectName: $_projectName');
    try {
      if (_projectName != null) {
        var _set = op![_projectName];
        return _set.val;
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 105.h,
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Color.fromRGBO(223, 223, 223, 1),
              width: 0.5,
            ),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(
                fontSize: 16, color: Color.fromRGBO(102, 102, 102, 1)),
          ),
          Expanded(
            child: InkWell(
                onTap: () async {
                  var _back = await _showselect(context, op, val, text);
                  print("_back: $_back");
                  if (_back != null && _back != "") {
                    onChange(_back);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      val,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(13, 13, 13, 1)),
                    ),
                    const Icon(Icons.expand_more,
                        size: 28, color: Color.fromRGBO(102, 102, 102, 1))
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

class TextSelectWidget extends StatefulWidget {
  final String text;
  final String val;
  final bool disable;
  final Function(String) onChange;
  final num? maxValue; // 最大值，非必填
  final num? minValue; // 最小值，非必填
  final String? maxErrorText; // 自定义最大值错误提示
  final String? minErrorText; // 自定义最小值错误提示

  const TextSelectWidget(
    this.text,
    this.val,
    this.disable,
    this.onChange, {
    this.maxValue,
    this.minValue,
    this.maxErrorText,
    this.minErrorText,
    super.key,
  });

  @override
  State<TextSelectWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextSelectWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.val;
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TextSelectWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.disable && _controller.text != widget.val) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.text = widget.val;
        _errorText = null;
      });
    }
  }

  // 处理焦点变化
  void _onFocusChange() {
    if (!_focusNode.hasFocus && _controller.text.isNotEmpty) {
      _validateAndCorrectValue(_controller.text);
    }
  }

  // 验证并修正输入值
  String? _validateAndCorrectValue(String value) {
    if (value.isEmpty) {
      setState(() => _errorText = null);
      return null;
    }

    final num? numValue = num.tryParse(value);
    if (numValue == null) {
      setState(() => _errorText = "请输入有效的数字");
      return null;
    }

    // 检查最小值
    if (widget.minValue != null && numValue < widget.minValue!) {
      final correctedValue = widget.minValue!.toString();
      setState(() {
        _errorText = widget.minErrorText ?? "不能小于${widget.minValue}";
      });
      // 延迟修正，避免与输入冲突
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.text = correctedValue;
        widget.onChange(correctedValue);
      });
      return correctedValue;
    }

    // 检查最大值
    if (widget.maxValue != null && numValue > widget.maxValue!) {
      final correctedValue = widget.maxValue!.toString();
      setState(() {
        _errorText = widget.maxErrorText ?? "不能大于${widget.maxValue}";
      });
      // 延迟修正，避免与输入冲突
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.text = correctedValue;
        widget.onChange(correctedValue);
      });
      return correctedValue;
    }

    // 输入有效
    setState(() => _errorText = null);
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 105.h,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Color.fromRGBO(223, 223, 223, 1),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.text,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(102, 102, 102, 1),
                ),
              ),
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  readOnly: widget.disable,
                  controller: _controller,
                  textAlign: TextAlign.end,
                  onChanged: (value) {
                    // 实时验证但不自动修正，保持用户输入
                    final num? numValue = num.tryParse(value);
                    String? tempError;

                    if (value.isNotEmpty && numValue == null) {
                      tempError = "请输入有效的数字";
                    } else if (widget.minValue != null &&
                        numValue != null &&
                        numValue < widget.minValue!) {
                      tempError =
                          widget.minErrorText ?? "不能小于${widget.minValue}";
                    } else if (widget.maxValue != null &&
                        numValue != null &&
                        numValue > widget.maxValue!) {
                      tempError =
                          widget.maxErrorText ?? "不能大于${widget.maxValue}";
                    } else {
                      tempError = null;
                      widget.onChange(value);
                    }

                    setState(() => _errorText = tempError);
                  },
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: widget.disable
                        ? const Color.fromRGBO(102, 102, 102, 1)
                        : const Color.fromRGBO(13, 13, 13, 1),
                  ),
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    border: InputBorder.none,
                    suffixStyle:
                        TextStyle(color: Colors.black, height: 1, fontSize: 16),
                    labelStyle:
                        TextStyle(color: Colors.black, height: 1, fontSize: 16),
                    counterStyle:
                        TextStyle(color: Colors.black, height: 1, fontSize: 16),
                    hintStyle: TextStyle(
                      height: 1,
                      color: Color.fromRGBO(204, 204, 204, 1),
                      fontSize: 16,
                    ),
                    hintText: '请输入',
                    errorText: null, // 禁用内置错误提示
                  ),
                ),
              ),
            ],
          ),
        ),
        // 错误提示
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 0),
            child: Text(
              _errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}

class HistorySearchPage extends StatefulWidget {
  String sn;
  HistorySearchPage({super.key, required this.sn});

  @override
  State<HistorySearchPage> createState() => _HistorySearchPageState();
}

class _HistorySearchPageState extends State<HistorySearchPage> {
  final TextEditingController _snController = TextEditingController();
  List<Map<String, String>> _searchResults = [
    {
      "sn": "--",
      "type": "--",
      "result": "--",
      "starttime": "--",
      "endtime": "--"
    },
  ];

  int pageIndex = 0;
  int pageSize = 5;
  int total = 0;
  inittable() {
    print('------------------> inittable');
    pageIndex = 0;
    pageSize = 5;
    _searchResults = [];
    search();
  }

  bool isloading = false;
  Future<void> search() async {
    if (pageIndex * pageSize >= total && total != 0) {
      return;
    }
    isloading = true;
    EasyLoading.show(status: 'loading...');
    try {
      final prefs = await SharedPreferences.getInstance();
      var machineId = await prefs.getString('deviceSn');
      // _searchResults = [];
      var getSearchHistories = await MideaApi.getWaterSerialPortRecordList({
        "machineId": machineId,
        "pageIndex": pageIndex,
        "pageSize": pageSize
      });
      print(getSearchHistories);
      if (getSearchHistories['data'] != null) {
        for (var element in getSearchHistories['data']) {
          _searchResults.add({
            "sn": element["sn"] ?? "--",
            "type": element["productModel"] ?? "--",
            "result": element["result"] ?? "--",
            "starttime": element["startTime"] ?? "--",
            "endtime": element["endTime"] ?? "--",
          });
        }
      }
      total = getSearchHistories['totalCount'];
      setState(() {
        _searchResults;
      });
      EasyLoading.dismiss();
      isloading = false;
    } catch (e) {
      print(e);

      isloading = false;
      pageIndex = 0;
      pageSize = 5;
      EasyLoading.dismiss();
      setState(() {
        _searchResults = [
          {
            "sn": "--",
            "type": "--",
            "result": "--",
            "starttime": "--",
            "endtime": "--"
          },
        ];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    EasyLoading.dismiss();
    super.initState();
    inittable();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        '最近检测记录',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  trailing: TextButton(
                      onPressed: () {
                        inittable();
                      },
                      child: const Text(
                        '刷新',
                        style: TextStyle(
                            color: Color.fromRGBO(25, 98, 255, 1),
                            fontWeight: FontWeight.bold),
                      )),
                )),
            const SizedBox(height: 16),
            // 结果展示表格
            CustomHistoryTable(
              key: ValueKey('_searchResults_${_searchResults.length}'),
              searchResults: _searchResults,
              loadmore: () {
                if (!isloading) {
                  pageIndex = pageIndex + 1;
                  isloading = true;
                  print(
                      '-----------> loadmore.  total:$total.  pageIndex:$pageIndex');
                  search();
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ));
  }
}

class CustomHistoryTable extends StatefulWidget {
  List searchResults;
  Function loadmore;
  CustomHistoryTable(
      {Key? key, required this.searchResults, required this.loadmore})
      : super(key: key);

  @override
  State<CustomHistoryTable> createState() => _CustomHistoryTableState();
}

class _CustomHistoryTableState extends State<CustomHistoryTable> {
  bool _isLoadingMore = false; // 是否正在加载更多
  bool _hasMore = true; // 是否还有更多数据
  late ScrollController _scrollController; // 滚动控制器

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    // 监听滚动事件，触发加载更多
    _scrollController.addListener(_onScroll);
  }

  // 滚动监听：当滚动到列表底部时加载更多
  void _onScroll() {
    // 计算滚动位置：当前滚动距离 + 可视高度 >= 总高度 - 触发加载的阈值（如200px）
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 30) {
      widget.loadmore(); // 触发加载更多
    }
  }

  @override
  void dispose() {
    _scrollController.dispose(); // 销毁控制器，避免内存泄漏
    super.dispose();
  }

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

  var productModelMap = {
    "centrifugalChiller": "离心机组",
    "magneticLevitationChiller": "磁悬浮冷水机组",
    "scrollChiller": "涡旋机组",
    "waterCooledChiller": "水冷螺杆机组",
    "airCooledChiller": "风冷螺杆机组",
    "selfSettingCheck": "自定义",
    "airCompressor": "空压机",
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
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
                  child: tableItemWidget('设备SN'),
                ),
                // 第二列 - 查询结果
                Expanded(
                  flex: 1,
                  child: tableItemWidget('机型'),
                ),
                // 第三列 - 所用设备标识
                Expanded(
                  flex: 1,
                  child: tableItemWidget('查询结果'),
                ),

                Container(
                  width: 150.w,
                  child: tableItemWidget('开始检测时间'),
                ),

                Container(
                  width: 150.w,
                  child: tableItemWidget('停止检测时间'),
                ),
              ],
            ),
          ),

          // 数据行
          // 替换原有的数据行SizedBox
          Expanded(
            // 使用Expanded替代固定高度的SizedBox，让列表自适应父容器高度
            child: ListView.builder(
              controller: _scrollController, // 关联滚动控制器
              itemCount: widget.searchResults.length +
                  (_isLoadingMore ? 1 : 0), // 额外添加加载中项
              itemBuilder: (context, index) {
                // 2. 正常数据项
                final item = widget.searchResults[index];
                return Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: tableItemText(item['sn']),
                    ),
                    Expanded(
                      flex: 1,
                      child:
                          tableItemText(productModelMap[item['type']] ?? "--"),
                    ),
                    Expanded(
                      flex: 1,
                      child: tableItemText(resultMap[item['result']] ?? "--"),
                    ),
                    Container(
                      width: 150.w,
                      child: tableItemText(formatDateTime(item['starttime'])),
                    ),
                    Container(
                      width: 150.w,
                      child: tableItemText(formatDateTime(item['endtime'])),
                    ),
                  ],
                );
              },
            ),
          )
          // 可添加更多数据行...
        ],
      ),
    );
  }
}

class tableItemText extends StatelessWidget {
  String text;

  tableItemText(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
          bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        ),
      ),
    );
  }
}

class tableItemWidget extends StatelessWidget {
  String text;

  tableItemWidget(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        ),
      ),
    );
  }
}
