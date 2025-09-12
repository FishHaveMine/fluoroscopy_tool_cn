import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class submitButton extends StatelessWidget {
  String label;
  bool isActive;
  double? fs;
  VoidCallback onClick;
  submitButton(
      {super.key,
      this.fs,
      required this.label,
      required this.onClick,
      required this.isActive});

  @override
  Widget build(BuildContext context) {
    bool isCN =
        EasyLocalization.of(context)?.currentLocale!.languageCode == 'zh';
    return GestureDetector(
      onTap: () {
        onClick();
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: isActive
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(49),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1CA2FF), Color(0xFF0080FF)],
                  stops: [0.0, 1.0],
                  transform: GradientRotation(115 * (3.1415926 / 180.0)),
                ),
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(49),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 155, 155, 155),
                    Color.fromARGB(255, 173, 173, 174)
                  ],
                  stops: [0.0, 1.0],
                  transform: GradientRotation(115 * (3.1415926 / 180.0)),
                ),
              ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: isCN ? 18 : fs ?? 16,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

class normalButton extends StatelessWidget {
  String label;
  VoidCallback onClick;
  Color? fillColor;
  Color? fillTextColor;
  normalButton({
    super.key,
    this.fillColor,
    this.fillTextColor,
    required this.label,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    bool isCN =
        EasyLocalization.of(context)?.currentLocale!.languageCode == 'zh';
    return GestureDetector(
      onTap: () {
        onClick();
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
              // width: 1,
              color: fillTextColor ?? Theme.of(context).colorScheme.secondary),
          borderRadius: BorderRadius.circular(49),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [fillColor ?? Colors.white, fillColor ?? Colors.white],
            stops: [0.0, 1.0],
            transform: const GradientRotation(115 * (3.1415926 / 180.0)),
          ),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: fillTextColor ?? const Color(0xFF0080FF),
                fontSize: isCN ? 18 : 12,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
