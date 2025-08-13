import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'public/buildFormItem.dart';
import 'public/publicObject.dart';

class ReportStep5Page extends StatefulWidget {
  bool ispreview = false;
  VoidCallback next;
  VoidCallback pre;

  ReportStep5Page(
      {super.key,
      required this.pre,
      required this.next,
      this.ispreview = false});
  @override
  _ReportStep5PageState createState() => _ReportStep5PageState();
}

class _ReportStep5PageState extends State<ReportStep5Page> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InstallController>(
        builder: (_) => Container(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    ..._.step5.map((field) {
                      return buildFormItem(
                        item: field,
                        readOnly: widget.ispreview,
                        onValidator: (e) => {
                          field.val = e ?? "",
                          print(field.label + '--' + field.val),
                        },
                      );
                    }).toList(),
                    const SizedBox(height: 20),
                    if (!widget.ispreview)
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                widget.pre();
                              },
                              child: const Text('上一步'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                bool ispass = _.validateStep(_.step5);
                                if (!ispass) {
                                  // 进入下一步逻辑
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('请输入必填项')));
                                  return;
                                }
                                if (_formKey.currentState!.validate()) {
                                  widget.next();
                                } else {
                                  // 进入下一步逻辑
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('请输入必填项')));
                                }
                              },
                              child: const Text('提交'),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ));
  }
}
