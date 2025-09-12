import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/tapContainer.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'deviceStatus.dart';
import 'errorHistory.dart';
import 'errorHistoryBluetooth.dart';

import 'package:get/get.dart';

class errorAnalysisPage extends StatefulWidget {
  errorAnalysisPage({super.key});

  @override
  State<errorAnalysisPage> createState() => _emptyResultPageState();
}

class _emptyResultPageState extends State<errorAnalysisPage> {
  init() async {
    try {} catch (e) {}
  }

  final deviceInfoController _deviceInfoController = Get.find();
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Get.offAllNamed('/home');
              },
              icon: const Icon(Icons.chevron_left,
                  color: Colors.black, size: 36)),
          title: const Text(
            'errorAnalysis.title',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: const [],
        ),
        body: tapContariner(
          activeIndex: 0,
          tap: List.generate(
              2,
              (index) => tr(
                  _deviceInfoController.isBluetooth.value
                      ? "errorAnalysis.resultbluetooth.type${index + 1}"
                      : "errorAnalysis.result.type${index + 1}",
                  namedArgs: {})),
          child: [
            deviceStatus(),
            _deviceInfoController.isBluetooth.value
                ? errorHistoryBluetooth()
                : errorHistory()
          ],
        ));
  }
}
