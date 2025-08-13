import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:flutter/material.dart';

class infobox extends StatelessWidget {
  String label;
  String val;
  infobox({super.key, required this.label, required this.val});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: normalText(),
          ).tr(),
        ),
        Expanded(
            child: Text(
          val,
          style: normalTextBlack(),
        ).tr())
      ],
    );
  }
}
