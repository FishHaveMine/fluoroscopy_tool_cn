import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class snInput extends StatefulWidget {
  Function valBack;
  Function? onfocus;
  String? hintText;
  bool isSamll;
  bool lengthLimit = true;
  snInput(
      {super.key,
      required this.valBack,
      this.isSamll = false,
      this.lengthLimit = false,
      this.onfocus,
      this.hintText = ""});

  @override
  State<snInput> createState() => snInputState();
}

class snInputState extends State<snInput> {
  final MethodChannel methodChannel = const MethodChannel('scan.data');
  static const platform = MethodChannel('samples.flutter.dev/battery');

  TextEditingController _controller = TextEditingController();
  String sn = '';

  fun() {
    _focusNode.unfocus();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      _showOverlay();
    } else {
      _hideOverlay();
    }
  }

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

  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
    methodChannel.setMethodCallHandler((call) async {
      if (call.method == 'data') {
        if (call.arguments == "null") {
          return;
        }
        widget.valBack(call.arguments);
        _focusNode.unfocus();
        if (call.arguments.length == 22 && widget.lengthLimit) {
          setState(() {
            sn = call.arguments;
          });
          _controller.text = call.arguments;
        } else {
          setState(() {
            sn = call.arguments;
          });
          _controller.text = call.arguments;
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await platform.invokeMethod('SCANNER_RESULT');
      } on PlatformException catch (e) {}
    });
  }

  remove() async {
    try {
      print("SCAN_BARCODE1 REMOVE_RESULT");
      await platform.invokeMethod('REMOVE_RESULT');
    } on PlatformException catch (e) {}
  }

  @override
  void dispose() {
    remove();
    super.dispose();
    _focusNode.unfocus();
    _focusNode.dispose();
    _hideOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 55, 0),
          child: Container(
              height: widget.isSamll ? 40 : 48,
              child: Center(
                child: TextField(
                  // scribbleEnabled: true,
                  // scrollPadding: const EdgeInsets.all(0.0),

                  focusNode: _focusNode,
                  controller: _controller,
                  onTap: () {
                    if (widget.onfocus != null) widget.onfocus!();
                  },

                  style: TextStyle(
                      color: Colors.black,
                      height: 1,
                      fontSize: widget.isSamll ? 16 : 16),
                  decoration: InputDecoration(
                      contentPadding: widget.isSamll
                          ? const EdgeInsets.fromLTRB(0, 0, 0, 5)
                          : const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 0),
                      border: InputBorder.none,
                      suffixStyle: TextStyle(
                          color: Colors.black,
                          height: 1,
                          fontSize: widget.isSamll ? 16 : 16),
                      labelStyle: TextStyle(
                          color: Colors.black,
                          height: 1,
                          fontSize: widget.isSamll ? 16 : 16),
                      counterStyle: TextStyle(
                          color: Colors.black,
                          height: 1,
                          fontSize: widget.isSamll ? 16 : 16),
                      hintStyle: TextStyle(
                          height: 1,
                          color: const Color.fromRGBO(204, 204, 204, 1),
                          fontSize: widget.isSamll ? 16 : 16),
                      hintText: widget.hintText == ""
                          ? tr("scancode")
                          : widget.hintText),
                  onChanged: (back) {
                    setState(() {
                      sn = back;
                    });
                    widget.valBack(back);
                  },
                ),
              ))),
      if (sn != '')
        Positioned(
          right: 15,
          top: 0,
          child: GestureDetector(
            onTap: () {
              _controller.text = '';
              widget.valBack("");
              setState(() {
                sn = '';
              });
            },
            child: SizedBox(
              height: widget.isSamll ? 44 : 48,
              width: 30,
              child: Center(
                child: Icon(
                  Icons.cancel,
                  size: widget.isSamll ? 20 : 28,
                  color: Color.fromRGBO(153, 153, 153, 1),
                ),
              ),
            ),
          ),
        )
    ]);
  }
}
