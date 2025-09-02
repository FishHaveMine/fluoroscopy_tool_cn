import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/waterpumb/pumbReport/create/com/SignatureDialog.dart';
import 'package:fluoroscopy_tool/waterpumb/pumbReport/create/com/coolingtable.dart';
import 'package:fluoroscopy_tool/store/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'InstallationInfo.dart';

class buildFormItemLR extends StatefulWidget {
  FormItem item;
  String? hintText;
  FocusNode? focusNodes;
  bool readOnly = false;
  VoidCallback? onTap;
  VoidCallback? onInputFieldSubmitted;
  Function(String?) onValidator;
  buildFormItemLR({
    super.key,
    required this.item,
    this.hintText = null,
    this.readOnly = false,
    this.onTap,
    this.onInputFieldSubmitted,
    this.focusNodes,
    required this.onValidator,
  });

  @override
  State<buildFormItemLR> createState() => _buildFormItemLRState();
}

class _buildFormItemLRState extends State<buildFormItemLR> {
  final TextEditingController controller = TextEditingController();
  String? inputval;
  String? base64Image;

  final int _maxLength = 300;
  int _charCount = 0;

  void _showSignatureDialog(BuildContext context) async {
    final _base64Image = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true, // 允许自定义高度
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const BottomSignatureSheet(),
    );

    if (_base64Image != null) {
      // 新增：调用图片上传
      EasyLoading.show(status: "uploading...");
      try {
        print('图片_base64Image：$_base64Image');
        final imageUrl = await MideaApi.uploadSignatureImage(_base64Image);
        print('图片上传成功，URL：${imageUrl["data"]}');
        EasyLoading.dismiss();
        widget.onValidator(imageUrl["data"]);
        setState(() {
          base64Image = imageUrl["data"];
        });
        // 这里可以将 imageUrl 保存到业务数据中
      } catch (e) {
        EasyLoading.dismiss();
        print('上传失败：$e');
        widget.onValidator(_base64Image);
        setState(() {
          base64Image = _base64Image;
        });
        // 处理错误（如提示用户重试）
      }
    }
  }

  Future<void> _selectDate(BuildContext context, bool isFactoryDate) async {
    if (widget.readOnly) {
      return;
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
      widget.onValidator(DateFormat('yyyy-MM-dd').format(picked));
    }
  }

  FocusNode? _focusNodes;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.item.val != null) {
      controller.text = widget.item.val;
    }
    if (widget.item.type != FormItemType.image) {
      setState(() {
        inputval = widget.item.val;
        _charCount = widget.item.val.length;
      });
    } else {
      setState(() {
        base64Image = widget.item.val;
      });
    }

    if (widget.item.type == FormItemType.input ||
        widget.item.type == FormItemType.number ||
        widget.item.type == FormItemType.textarea) {
      _focusNodes = widget.focusNodes ?? FocusNode();
    }
  }

  @override
  void didUpdateWidget(covariant buildFormItemLR oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 如果 val 被外部改变，需要手动刷新 controller
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.text != widget.item.val) {
        controller.text = widget.item.val;
        setState(() {
          inputval = widget.item.val;
        });
      }
    });
  }

  Widget sig = Container(
      height: 50,
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Color.fromRGBO(223, 223, 223, 1),
              width: 0.5,
            ),
          )),
      child: const Center(
        child: Text("点击签名"),
      ));
  Widget buildSignatureImage(String? input) {
    if (input == null || input.isEmpty) {
      return sig; // 空值时显示默认组件
    }

    // 判断是否为 URL（以 http/https 开头）
    final isUrl = input.startsWith('http://') || input.startsWith('https://');

    try {
      if (isUrl) {
        // 显示网络图片
        return Image.network(
          input,
          height: 80,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return sig; // 加载失败时显示默认组件
          },
        );
      } else {
        // 显示 Base64 图片
        final imageBytes = base64Decode(input);
        return Image.memory(
          imageBytes,
          height: 80,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return sig; // 解码失败时显示默认组件
          },
        );
      }
    } catch (e) {
      print('图片加载失败: $e');
      return sig; // 通用错误处理
    }
  }

  @override
  void dispose() {
    controller.dispose();
    try {
      if (_focusNodes != null) {
        _focusNodes?.dispose();
      }
    } catch (e) {}
    super.dispose();
  }

  _showselect(context) async {
    if (widget.readOnly) {
      return;
    }
    print("显示下拉");
    var _projectName = await showBottomSheetDialog(
        widget.item.op ?? [], widget.item.val, context);
    try {
      if (_projectName != null) {
        var _set = widget.item.op![_projectName];
        widget.onValidator(_set.val);
        controller.text = _set.val;
        setState(() {
          inputval = _set.val;
        });
      }
    } catch (e) {}
  }

  Future<int?> showBottomSheetDialog(
      List<selectItem> options, String selected, BuildContext context) {
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
              const Text(
                '请选择',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                          Icon(Icons.check_circle,
                              color: selected == options[index].label
                                  ? Colors.blue
                                  : Colors.grey),
                          const SizedBox(
                            width: 10,
                          ),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (widget.item.required)
              const Text('*',
                  style: TextStyle(color: Colors.red, fontSize: 14)),
            SizedBox(
                width: 150.w,
                child: Text(
                  widget.item.label,
                  style: const TextStyle(
                      color: Color.fromRGBO(102, 102, 102, 1), fontSize: 14),
                )),
            Expanded(
                child: SizedBox(
              child: Row(
                children: [
                  if (widget.item.type == FormItemType.radio &&
                      widget.item.op != null)
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color.fromRGBO(238, 238, 238, 1), // 边框颜色
                            width: 1.0, // 边框宽度
                            style: BorderStyle.solid, // 边框样式
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...widget.item.op!.map((op) {
                            return Row(
                              children: [
                                Theme(
                                    data: Theme.of(context).copyWith(
                                      unselectedWidgetColor:
                                          const Color.fromRGBO(
                                              191, 191, 191, 1), // 设置未选中颜色
                                    ),
                                    child: Radio<String>(
                                      activeColor:
                                          const Color.fromRGBO(0, 128, 255, 1),
                                      focusColor:
                                          const Color.fromRGBO(0, 128, 255, 1),
                                      value: op.val,
                                      visualDensity:
                                          VisualDensity.compact, // 控制整体尺寸
                                      materialTapTargetSize:
                                          MaterialTapTargetSize
                                              .shrinkWrap, // 缩小点击区域
                                      groupValue: inputval,
                                      onChanged: widget.readOnly
                                          ? null
                                          : (newValue) {
                                              if (inputval == newValue) {
                                                setState(() {
                                                  inputval = "";
                                                });
                                                widget.onValidator("");
                                              } else {
                                                setState(() {
                                                  inputval = newValue;
                                                });
                                                widget.onValidator(newValue);
                                              }
                                            },
                                    )),
                                InkWell(
                                  onTap: widget.readOnly
                                      ? null
                                      : () {
                                          if (inputval == op.val) {
                                            setState(() {
                                              inputval = "";
                                            });
                                            widget.onValidator("");
                                          } else {
                                            setState(() {
                                              inputval = op.val;
                                            });
                                            widget.onValidator(op.val);
                                          }
                                        },
                                  child: Text(op.val),
                                ),
                                const SizedBox(width: 8),
                              ],
                            );
                          }).toList()
                        ],
                      ),
                    ),
                  if (widget.item.type == FormItemType.input ||
                      widget.item.type == FormItemType.number ||
                      widget.item.type == FormItemType.textarea)
                    Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                          controller: controller,
                          focusNode: _focusNodes,
                          onFieldSubmitted: (value) {
                            _focusNodes?.unfocus();
                            if (widget.onInputFieldSubmitted != null) {
                              widget.onInputFieldSubmitted!();
                            }
                          },
                          readOnly: widget.readOnly,
                          maxLength: widget.item.type == FormItemType.textarea
                              ? _maxLength
                              : null,
                          maxLines:
                              widget.item.type == FormItemType.textarea ? 5 : 1,
                          minLines:
                              widget.item.type == FormItemType.textarea ? 3 : 1,
                          onTap: widget.onTap,
                          keyboardType: widget.item.type == FormItemType.number
                              ? TextInputType.number
                              : TextInputType.text,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                          decoration: InputDecoration(
                            hintText: widget.hintText ?? '请输入',
                            hintStyle: const TextStyle(color: Colors.grey),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 6),
                            isDense: true,
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(238, 238, 238, 1)),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(238, 238, 238, 1)),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                          validator: (value) {
                            widget.onValidator(value);
                            if (widget.item.required &&
                                (value == null || value.trim().isEmpty)) {
                              return '请输入${widget.item.label}';
                            }
                            // 手机号校验逻辑
                            if (widget.item.required &&
                                widget.item.label.contains('电话') &&
                                value != null) {
                              // 中国手机号正则表达式，以1开头，第二位可以是3 - 9，后面跟9位数字
                              final phoneRegex = RegExp(r'^1[3-9]\d{9}$');
                              if (!phoneRegex.hasMatch(value)) {
                                return '请输入正确的手机号码';
                              }
                            }
                            return null;
                          },
                          onChanged: (_) => {
                            widget.onValidator(_),
                            setState(() {
                              inputval = _;
                            })
                          },
                        )),
                        if (widget.item.unit != "")
                          SizedBox(
                            width: 45,
                            child: Center(
                              child: Text(
                                widget.item.unit,
                                style: tip,
                              ),
                            ),
                          )
                      ],
                    ),
                  if (widget.item.type == FormItemType.time)
                    InkWell(
                      onTap: () {
                        _selectDate(context, false);
                      },
                      child: Row(
                        children: [
                          Expanded(
                              child: TextFormField(
                            controller: controller,
                            onTap: () {
                              _selectDate(context, false);
                            },
                            readOnly: true,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                            decoration: input_decoration(widget.hintText),
                            validator: (value) {
                              // widget.onValidator(value);
                              if (widget.item.required &&
                                  (value == null || value.trim().isEmpty)) {
                                return '请输入${widget.item.label}';
                              }
                              return null;
                            },
                            onChanged: (_) => setState(() {}),
                          )),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: Color.fromRGBO(187, 187, 187, 1),
                          )
                        ],
                      ),
                    ),
                  if (widget.item.type == FormItemType.image)
                    InkWell(
                      onTap: () {
                        _showSignatureDialog(context);
                      },
                      child: base64Image == null && base64Image != ""
                          ? sig
                          : buildSignatureImage(base64Image!),
                    ),
                  if (widget.item.type == FormItemType.select)
                    Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                          controller: controller,
                          readOnly: true,
                          maxLength: null,
                          maxLines: 1,
                          minLines: 1,
                          onTap: () {
                            _showselect(context);
                          },
                          keyboardType: widget.item.type == FormItemType.number
                              ? TextInputType.number
                              : TextInputType.text,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                          decoration: InputDecoration(
                            hintText: widget.hintText ?? '请输入',
                            hintStyle: const TextStyle(color: Colors.grey),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 6),
                            isDense: true,
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(238, 238, 238, 1)),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(238, 238, 238, 1)),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                          validator: (value) {
                            widget.onValidator(value);
                            if (widget.item.required &&
                                (value == null || value.trim().isEmpty)) {
                              return '请输入${widget.item.label}';
                            }
                            // 手机号校验逻辑
                            if (widget.item.required &&
                                widget.item.label.contains('电话') &&
                                value != null) {
                              // 中国手机号正则表达式，以1开头，第二位可以是3 - 9，后面跟9位数字
                              final phoneRegex = RegExp(r'^1[3-9]\d{9}$');
                              if (!phoneRegex.hasMatch(value)) {
                                return '请输入正确的手机号码';
                              }
                            }
                            return null;
                          },
                          onChanged: (_) => {
                            widget.onValidator(_),
                            setState(() {
                              inputval = _;
                            })
                          },
                        )),
                        if (widget.item.unit != "")
                          SizedBox(
                            width: 45,
                            child: Center(
                              child: Text(
                                widget.item.unit,
                                style: tip,
                              ),
                            ),
                          )
                      ],
                    ),
                ],
              ),
            ))
          ],
        ),
      ],
    );
  }
}

TextStyle tip =
    const TextStyle(color: Color.fromRGBO(102, 102, 102, 1), fontSize: 12);
