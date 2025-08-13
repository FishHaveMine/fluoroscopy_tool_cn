import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/errorAnalysis/errorHistory.dart';
import 'package:fluoroscopy_tool/view/systemCapabilityAnalysis/step2/systemDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

class cloundErrorList extends StatefulWidget {
  String? sn;
  String? nid;
  String? deviceversion;
  cloundErrorList(
      {super.key, this.nid, required this.sn, required this.deviceversion});

  @override
  State<cloundErrorList> createState() => _copybasepageState();
}

class _copybasepageState extends State<cloundErrorList> {
  @override
  void initState() {
    super.initState();
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
          // ignore: prefer_const_constructors
          title: Text(
            tr('twoday') + tr('smartFaultAnalysis'),
            style: const TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          actions: [],
        ),
        body: errorHistory(
            sn: widget.sn,
            nid: widget.nid,
            deviceversion: widget.deviceversion));
  }
}
