import 'package:easy_stepper/easy_stepper.dart';
import 'package:fluoroscopy_tool/compent/scanPage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../compent/submitbutton.dart';

class snBox extends StatefulWidget {
  bool showSubmit = true;
  Widget? childWidget;
  final ValueChanged<String?>? onSubmitted; // 定义回调函数
  snBox({
    super.key,
    required this.showSubmit,
    this.childWidget,
    this.onSubmitted,
  });

  @override
  State<snBox> createState() => _snBoxState();
}

class _snBoxState extends State<snBox> {
  // 整机条码输入控制器
  TextEditingController _barcodeController = TextEditingController();
  final FocusNode _barcodeFocusNode = FocusNode();
  // 拼接机组单选按钮状态，默认未选中
  bool _isSplicingUnit = false;
  bool _hasFocus = false; // 清空按钮 - 仅在有焦点且文本不为空时显示
  // 拼接台数
  int _splicingCount = 0;
  String snInput = "";

  final MethodChannel methodChannel = const MethodChannel('scan.data');

  initSN() async {
    final prefs = await SharedPreferences.getInstance();
    var querySN = await prefs.getString('querySN');
    if (querySN != null) {
      snInput = querySN;
    } else {
      snInput = "";
    }
    _barcodeController.text = snInput;

    if (!widget.showSubmit) {
      widget.onSubmitted!(snInput);
    }
    setState(() {
      snInput;
    });
  }

  clearQuerySN() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('querySN');
  }

  refreshrQuerySN(sn) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('querySN', sn);
  }

  @override
  void initState() {
    super.initState();
    /** 读取缓存的sn */
    initSN();
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
    try {
      _barcodeController.dispose();
      _barcodeFocusNode.dispose();
    } catch (e) {}
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
    if (!widget.showSubmit) {
      refreshrQuerySN(barcode);
      widget.onSubmitted!(barcode);
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
                    focusNode: _barcodeFocusNode, // 关联焦点节点
                    // 监听焦点变化
                    onTap: () {
                      setState(() {
                        _hasFocus = true;
                      });
                    },
                    onChanged: (value) {
                      // 文本变化时更新状态
                      setState(() {});
                    },
                    // 失去焦点时更新状态
                    onEditingComplete: () {
                      setState(() {
                        _hasFocus = false;
                      });
                    },
                    onSubmitted: (value) {
                      if (!widget.showSubmit) {
                        widget.onSubmitted!(value);
                      }
                      _barcodeFocusNode.unfocus();

                      String barcode = value;
                      bool? isSplicingUnit = _isSplicingUnit;
                      int splicingCount = _splicingCount;
                      if (value != "" && value != null) {
                        _barcodeController.text = processBarcode(
                            barcode, isSplicingUnit, splicingCount);
                      } else {
                        _barcodeController.text = '';
                      }

                      snInput = barcode;
                    },
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(0, 0, 80, 5),
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

                  // 清空按钮 - 仅在有焦点且文本不为空时显示
                  if (_hasFocus && _barcodeController.text.isNotEmpty)
                    Positioned(
                      right: 45,
                      top: 6,
                      child: InkWell(
                        onTap: () {
                          // 清空文本
                          _barcodeController.clear();
                          setState(() {}); // 更新UI
                          clearQuerySN();
                        },
                        child: const Icon(
                          Icons.clear,
                          size: 28,
                          color: Color.fromRGBO(13, 13, 13, 0.5),
                        ),
                      ),
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
        if (widget.childWidget != null) widget.childWidget!,
        if (widget.showSubmit) const SizedBox(height: 16),
        if (widget.showSubmit)
          Center(
            child: SizedBox(
              width: 160.w,
              height: 72.h,
              child: submitButton(
                onClick: () {
                  refreshrQuerySN(_barcodeController.text);
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
