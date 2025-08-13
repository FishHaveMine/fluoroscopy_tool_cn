import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';

import 'globalData.dart';

class intInputField extends StatefulWidget {
  String initialValue;
  double minValue = 0;
  List<TextInputFormatter>? inputFormatters;
  double maxValue = 63;
  Function changeback;
  intInputField(
      {super.key,
      required this.initialValue,
      this.minValue = 0,
      this.maxValue = 63,
      this.inputFormatters,
      required this.changeback});

  @override
  State<intInputField> createState() => _intInputFieldState();
}

class _intInputFieldState extends State<intInputField> {
  final TextEditingController _controller = TextEditingController();
  double minValue = 0.0;
  double maxValue = 100.0;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue;
    setState(() {
      minValue = widget.minValue;
      maxValue = widget.maxValue;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        inputFormatters: widget.inputFormatters ?? [],
        textAlign: TextAlign.end,
        controller: _controller,
        keyboardType: TextInputType.number,
        // initialValue: widget.initialValue,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        onSaved: (value) {
          if (value!.isNotEmpty) {
            double number = double.parse(value!);
            if (number < minValue || number > maxValue) {
              _controller.value = TextEditingValue(
                text: number.clamp(minValue, maxValue).toStringAsFixed(0),
                selection: TextSelection.collapsed(
                    offset: number
                        .clamp(minValue, maxValue)
                        .toStringAsFixed(0)
                        .length),
              );
              widget.changeback(
                  number.clamp(minValue, maxValue).toStringAsFixed(0));
            } else {
              widget.changeback(value);
            }
          }
        },
        onChanged: (value) {
          if (value!.isNotEmpty) {
            double number = double.parse(value!);
            if (number < minValue || number > maxValue) {
              _controller.value = TextEditingValue(
                text: number.clamp(minValue, maxValue).toStringAsFixed(0),
                selection: TextSelection.collapsed(
                    offset: number
                        .clamp(minValue, maxValue)
                        .toStringAsFixed(0)
                        .length),
              );
              widget.changeback(
                  number.clamp(minValue, maxValue).toStringAsFixed(0));
            } else {
              widget.changeback(value);
            }
          }
        },
        validator: (v) {
          return validateEmpty(v);
        });
  }
}
