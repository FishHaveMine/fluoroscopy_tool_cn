import 'dart:math';

import 'package:flutter/material.dart';

abstract class BasePainter extends CustomPainter {
  late Animation<double> _xAnimation;
  late Animation<double> _yAnimation;

  set XAnimation(Animation<double> value) {
    _xAnimation = value;
  }

  set YAnimation(Animation<double> value) {
    _yAnimation = value;
  }

  Animation<double> get YAnimation => _yAnimation;

  Animation<double> get XAnimation => _xAnimation;
}

class WavePainter extends BasePainter {
  int waveCount;
  int crestCount;
  double waveHeight;
  List<Color> waveColors;
  double circleWidth;
  Color circleColor;
  Color circleBackgroundColor;
  bool showProgressText;
  TextStyle textStyle;

  WavePainter(
      {this.waveCount = 1,
      this.crestCount = 2,
      required this.waveHeight,
      required this.waveColors,
      this.circleColor = Colors.grey,
      this.circleBackgroundColor = Colors.white,
      this.circleWidth = 5.0,
      this.showProgressText = true,
      this.textStyle = const TextStyle(
        fontSize: 60.0,
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(color: Colors.grey, offset: Offset(5.0, 5.0), blurRadius: 5.0)
        ],
      )});

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;

    if (waveHeight == null) {
      waveHeight = height / 10;
      height = height + waveHeight;
    }

    if (waveColors == null) {
      waveColors = [
        Color.fromARGB(
            100, Colors.blue.red, Colors.blue.green, Colors.blue.blue)
      ];
    }

    Offset center = Offset(width / 2, height / 2);
    double xMove = width * XAnimation.value;
    double yAnimValue = 0.0;
    if (YAnimation != null) {
      yAnimValue = YAnimation.value;
    }
    double yMove = height * (1.0 - yAnimValue);
    Offset waveCenter = Offset(xMove, yMove);

    var paintCircle = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill
      ..strokeWidth = circleWidth
      ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 5.0);

//    canvas.drawCircle(center, min(width, height) / 2, paintCircle);

    List<Path> wavePaths = [];

    for (int index = 0; index < waveCount; index++) {
      num direction = pow(-1.0, index);
      Path path = Path()
        ..moveTo(waveCenter.dx - width, waveCenter.dy)
        ..lineTo(waveCenter.dx - width, center.dy + height / 2)
        ..lineTo(waveCenter.dx + width, center.dy + height / 2)
        ..lineTo(waveCenter.dx + width, waveCenter.dy);

      for (int i = 0; i < 2; i++) {
        for (int j = 0; j < crestCount; j++) {
          num a = pow(-1.0, j);
          path
            ..quadraticBezierTo(
                waveCenter.dx +
                    width * (1 - i - (1 + 2 * j) / (2 * crestCount)),
                waveCenter.dy + waveHeight * a * direction,
                waveCenter.dx +
                    width * (1 - i - (2 + 2 * j) / (2 * crestCount)),
                waveCenter.dy);
        }
      }

      path..close();

      wavePaths.add(path);
    }
    var paint = Paint()
      ..color = circleBackgroundColor
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 5.0);

    canvas.saveLayer(
        Rect.fromCircle(center: center, radius: min(width, height) / 2), paint);

//    canvas.drawCircle(center, min(width, height) / 2, paint);

    paint
//      ..blendMode = BlendMode.srcATop
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 10.0);

    for (int i = 0; i < wavePaths.length; i++) {
      if (waveColors.length >= wavePaths.length) {
        paint.color = waveColors[i];
      } else {
        paint.color = waveColors[0];
      }
      canvas.drawPath(wavePaths[i], paint);
    }
//    paint.blendMode = BlendMode.srcATop;
    if (showProgressText) {
      TextPainter tp = TextPainter(
          text: TextSpan(
              text: '${(yAnimValue * 100.0).toStringAsFixed(0)}%',
              style: textStyle),
          textDirection: TextDirection.rtl)
        ..layout();

      tp.paint(
          canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

abstract class BasePainterFactory {
  BasePainter getPainter();
}

class WavePainterFactory extends BasePainterFactory {
  BasePainter getPainter() {
    return WavePainter(
      waveCount: 2,
      waveColors: [
        const Color.fromRGBO(106, 174, 255, 1),
        const Color.fromRGBO(51, 139, 245, 1),
      ],
      textStyle: TextStyle(
        fontSize: 0.0,
        foreground: Paint()
          ..color = Colors.transparent
          ..style = PaintingStyle.fill
          ..strokeWidth = 2.0
          ..blendMode = BlendMode.difference
          ..colorFilter =
              const ColorFilter.mode(Colors.white, BlendMode.exclusion)
          ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 1.0),
        fontWeight: FontWeight.bold,
      ),
      waveHeight: 10,
    );
  }
}

class ProgressManager extends StatefulWidget {
  int type = 0;
  ProgressManager({required this.type});

  @override
  _ProgressManagerState createState() =>
      _ProgressManagerState().._factory = WavePainterFactory();
}

class _ProgressManagerState extends State<ProgressManager>
    with TickerProviderStateMixin {
  late AnimationController xController;
  late AnimationController yController;
  late Animation<double> xAnimation;
  late Animation<double> yAnimation;
  List<double> _progressList = [];
  double curProgress = 0;
  late BasePainterFactory _factory;

  set painter(BasePainterFactory factory) {
    _factory = factory;
  }

  setProgress(double progress) {
    _progressList.add(progress);
    onProgressChange();
  }

  onProgressChange() {
    if (_progressList.length > 0) {
      if (yController != null && yController.isAnimating) {
        return;
      }
      double nextProgress = _progressList[0];
      _progressList.removeAt(0);
      final double begin = curProgress;
      yController = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 1000));
      yAnimation = Tween(begin: begin, end: nextProgress).animate(yController);
      yAnimation.addListener(_onProgressChange);
      yAnimation.addStatusListener(_onProgressStatusChange);
      yController.forward();
    }
  }

  @override
  void initState() {
    super.initState();
    xController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 4000));
    xAnimation = Tween(begin: 0.0, end: 1.0).animate(xController);
    xAnimation.addListener(_change);
    yController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 5000));
    yAnimation = Tween(begin: 0.0, end: 1.0).animate(yController);
    yAnimation.addListener(_onProgressChange);
    yAnimation.addStatusListener(_onProgressStatusChange);

    doDelay(xController, 0);
    setProgress(widget.type == 1
        ? 0.85
        : widget.type == 2
            ? 0.5
            : 0.2);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 126,
        height: 162,
        child: Stack(
          children: [
            Image.asset(
              'public/images/refrigerant/card.png',
              width: 126,
            ),
            Positioned(
                bottom: -10,
                left: 10,
                child: Container(
                  width: 107,
                  height: 145,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CustomPaint(
                        painter: _factory.getPainter()
                          ..XAnimation = xAnimation
                          ..YAnimation = yAnimation,
                        size: Size(MediaQuery.of(context).size.width, 140.0),
                      )),
                ))
          ],
        ),
      ),
    );
  }

  void _change() {
    setState(() {});
  }

  void _onProgressChange() {
    setState(() {
      curProgress = yAnimation.value;
    });
  }

  void _onProgressStatusChange(status) {
    if (status == AnimationStatus.completed) {
      onProgressChange();
    }
  }

  void doDelay(AnimationController controller, int delay) async {
    Future.delayed(Duration(milliseconds: delay), () {
      controller..repeat();
    });
  }

  @override
  void dispose() {
    xController.dispose();
    yController.dispose();
    xAnimation.removeListener(_change);
    yAnimation.removeListener(_onProgressChange);
    yAnimation.removeStatusListener(_onProgressStatusChange);
    super.dispose();
  }
}
