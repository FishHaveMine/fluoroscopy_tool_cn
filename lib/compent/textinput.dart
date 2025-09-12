import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class textinput extends StatefulWidget {
  Function(String) onChanged;
  int? maxLines = 3;
  TextAlign textAlign = TextAlign.start;
  String? hintText;
  TextInputType keyboardType = TextInputType.text;
  String? val = "";
  bool isrequired = false;
  bool enabled = true;
  double lineheight = 2;
  Function? validator;
  textinput(
      {super.key,
      required this.onChanged,
      this.maxLines = 3,
      this.lineheight = 2,
      this.val = "",
      this.hintText,
      this.isrequired = false,
      this.enabled = true,
      this.validator,
      this.keyboardType = TextInputType.text,
      this.textAlign = TextAlign.start});

  @override
  State<textinput> createState() => _textinputState();
}

class _textinputState extends State<textinput> {
  OverlayEntry? _overlayEntry;
  void _showOverlay() {
    final overlay = Overlay.of(context);
    if (overlay != null) {
      _overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: 0.0,
          left: 0.0,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                _focusNode.unfocus();
              },
              child: Container(
                color: Colors.black.withOpacity(0.5),
                width: 720.w,
                height: 1280.h,
              ),
            ),
          ),
        ),
      );
      overlay.insert(_overlayEntry!);
    }
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      _showOverlay();
    } else {
      _hideOverlay();
    }
  }

  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.unfocus();
    _focusNode.dispose();
    _hideOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        enabled: widget.enabled, // 设置为 false 禁用 TextFormField
        focusNode: _focusNode,
        keyboardType: widget.keyboardType,
        initialValue: widget.val,
        validator: (value) {
          print("TextFormField validator $value");

          if (widget.isrequired && (value == null || value.isEmpty)) {
            return widget.hintText ?? tr("input.hintText");
          }
          if (widget.validator != null) {
            return widget.validator!(value);
          }
          return null;
        },
        textAlign: widget.textAlign, // 或者使用 TextAlign.end
        style: normalText(lineheight: widget.lineheight), // 设置字体大小为 14
        maxLines: widget.maxLines, // 设置为 null 或大于 1 的数字以支持多行输入
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hintText ?? tr("input.hintText")),
        onChanged: (back) {
          widget.onChanged(back);
        });
  }
}
