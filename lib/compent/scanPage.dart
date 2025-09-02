import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

class scanPage extends StatefulWidget {
  scanPage({super.key});

  @override
  State<scanPage> createState() => _scanPageState();
}

class _scanPageState extends State<scanPage>
    with SingleTickerProviderStateMixin {
  // 动画控制器
  late AnimationController _controller;
  // 扫描线的位置动画，控制从扫码框顶部移动到底部
  late Animation<double> _scanLinePositionAnimation;

  final MethodChannel methodChannel = const MethodChannel('scan.data');
  static const platform = MethodChannel('samples.flutter.dev/battery');

  @override
  void initState() {
    super.initState();
    // 初始化动画控制器，设置动画时长等
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); // 让动画重复且反向，实现来回移动效果
    // 构建动画，让扫描线的位置在 0 到 1 之间变化（对应扫码框的高度比例）
    _scanLinePositionAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    startScan();
    methodChannel.setMethodCallHandler((call) async {
      if (call.method == 'data') {
        if (call.arguments == "null") {
          return;
        }
        print(call.arguments);
        methodChannel.setMethodCallHandler(null);
        Get.back(result: call.arguments);
      }
    });
  }

  @override
  void dispose() {
    try {
      _controller.dispose(); // 释放动画控制器资源
    } catch (e) {}
    methodChannel.setMethodCallHandler(null);
    super.dispose();
  }

  startScan() async {
    try {
      await platform.invokeMethod('SCANNER_TRIG');
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.chevron_left,
                  color: Colors.white, size: 36)),
          // ignore: prefer_const_constructors
          title: Text(
            '',
            style: const TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: const [],
        ),
        body: Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AdvancedScanAnimation(
                    width: 367.w,
                    height: 350.h,
                    borderColor: const Color.fromRGBO(0, 143, 231, 1), // 边框颜色
                    scanColor: const Color.fromRGBO(0, 143, 231, 1), // 扫描线颜色
                    scanDuration: const Duration(seconds: 3), // 扫描周期
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 32, 0, 0),
                    child: Text(
                      '请扫描设备上二维码信息',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(158, 152, 152, 1)),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      startScan();
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 264.h, 0, 0),
                      child: Image.asset(
                        'public/images/prowaterpumb/light@2x.png',
                        width: 80,
                        color: const Color.fromRGBO(255, 255, 255, 1),
                      ),
                    ),
                  )
                ],
              ),
            )));
  }
}

class AdvancedScanAnimation extends StatefulWidget {
  final double width;
  final double height;
  final Duration scanDuration;
  final Color borderColor;
  final Color scanColor;

  const AdvancedScanAnimation({
    Key? key,
    this.width = 280,
    this.height = 380,
    this.scanDuration = const Duration(seconds: 2),
    this.borderColor = Colors.blue,
    this.scanColor = Colors.blue,
  }) : super(key: key);

  @override
  State<AdvancedScanAnimation> createState() => _AdvancedScanAnimationState();
}

class _AdvancedScanAnimationState extends State<AdvancedScanAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scanPosition;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.scanDuration,
    )..repeat();

    _scanPosition = Tween<double>(
      begin: 0.05, // 起始位置（占总高度的比例）
      end: 0.95, // 结束位置
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 扫描框主体
          CustomPaint(
            size: Size(widget.width, widget.height),
            painter: ScanFramePainter(
              borderColor: widget.borderColor,
              cornerLength: 30,
              cornerWidth: 4,
            ),
          ),

          // 带渐变效果的扫描线
          AnimatedBuilder(
            animation: _scanPosition,
            builder: (context, child) {
              return Positioned(
                top: widget.height * _scanPosition.value,
                left: 0,
                right: 0,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        widget.scanColor.withOpacity(0.3),
                        widget.scanColor,
                        widget.scanColor.withOpacity(0.3),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              );
            },
          ),

          // 顶部和底部的发光效果
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    widget.borderColor.withOpacity(0.2),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.borderColor.withOpacity(0.2),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScanFramePainter extends CustomPainter {
  final Color borderColor;
  final double cornerLength;
  final double cornerWidth;

  const ScanFramePainter({
    required this.borderColor,
    this.cornerLength = 30,
    this.cornerWidth = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = cornerWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // 绘制四角边框
    _drawCorner(canvas, paint, 0, 0, size); // 左上角
    _drawCorner(canvas, paint, size.width, 0, size); // 右上角
    _drawCorner(canvas, paint, 0, size.height, size); // 左下角
    _drawCorner(canvas, paint, size.width, size.height, size); // 右下角

    // 绘制四条边的发光效果
    _drawEdgeGlow(canvas, size);
  }

  void _drawCorner(Canvas canvas, Paint paint, double x, double y, Size size) {
    final isTop = y == 0;
    final isLeft = x == 0;

    // 水平线段
    canvas.drawLine(
      Offset(isLeft ? x : x - cornerLength, y),
      Offset(isLeft ? x + cornerLength : x, y),
      paint,
    );

    // 垂直线段
    canvas.drawLine(
      Offset(x, isTop ? y : y - cornerLength),
      Offset(x, isTop ? y + cornerLength : y),
      paint,
    );
  }

  void _drawEdgeGlow(Canvas canvas, Size size) {
    final glowPaint = Paint()
      ..color = borderColor.withOpacity(0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // 绘制四条边
    // canvas.drawRect(
    //   Rect.fromLTWH(0, 0, size.width, size.height),
    //   glowPaint,
    // );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
