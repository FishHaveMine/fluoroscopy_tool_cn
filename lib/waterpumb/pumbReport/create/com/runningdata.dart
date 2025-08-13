import 'package:flutter/material.dart';
import '../public/buildFormItem.dart';
import '../public/configObject.dart';
import '../public/publicObject.dart';
import 'package:get/get.dart';

class runningdata extends StatefulWidget {
  int showing;
  final GlobalKey<FormState> formKey; // <-- 新增参数
  runningdata({
    super.key,
    required this.showing,
    required this.formKey,
  });

  @override
  State<runningdata> createState() => _runningdataState();
}

class _runningdataState extends State<runningdata> {
  // 默认 磁悬浮离心式冷水机组 - 表单数据
  List point = runningdataGroup1.getAllFormKeys();
  init() {
    InstallController _ = Get.find();
    setState(() {
      point = _.getrunningdataGroupFormKeys();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InstallController>(
        builder: (_) => Container(
              padding: const EdgeInsets.all(8),
              child: Form(
                key: widget.formKey, // ⬅️ 使用外部传入的 key
                child: Column(
                  children: [
                    ...point.map((key) {
                      return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              // Text('$key${widget.showing} -- ' +
                              //     _.form['$key${widget.showing}'].val),
                              buildFormItem(
                                key: ValueKey('$key${widget.showing}'),
                                item: _.form['$key${widget.showing}'],
                                readOnly: _.ispreview.value,
                                onValidator: (e) => {
                                  _.form['$key${widget.showing}'].val = e ?? "",
                                  print(_.form['$key${widget.showing}'].val)
                                },
                              )
                            ],
                          ));
                    }).toList(),
                  ],
                ),
              ),
            ));
  }
}
