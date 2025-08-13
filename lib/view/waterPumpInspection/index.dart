import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import 'package:get/get.dart';

import 'protocol_switch.dart';

class waterPumpPage extends StatefulWidget {
  const waterPumpPage({super.key});
  @override
  State<waterPumpPage> createState() => _waterPumpPageState();
}

class _waterPumpPageState extends State<waterPumpPage> {
  bool isV8 = true;
  int selectedProtocol = 0;
  List<String> V8_protocol = ['V8_protocol1', 'V8_protocol2', 'V8_protocol3'];
  checkIsV8(context) async {
    isV8 = true;
    setState(() {
      isV8;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!isV8) {
        bool bakc = await divConfirmOnlyDialog(context,
            confirmDescriptionWidget: Container(
              width: 560.w,
              height: 100,
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              color: Colors.black, height: 1.5, fontSize: 16.0),
                          text: tr("V8_protocol.tip"),
                        ),
                      )),
                ),
              ),
            ));
        if (bakc) {
          Navigator.pop(context);
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIsV8(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
            icon:
                const Icon(Icons.chevron_left, color: Colors.black, size: 36)),
        title: const Text(
          'waterPump.title',
          style: TextStyle(color: Colors.black),
        ).tr(),
        centerTitle: true,
        actions: [],
      ),
      body: isV8
          ? Padding(
              padding: EdgeInsets.fromLTRB(40.w, 80.h, 40.w, 80.h),
              child: Column(
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        style: const TextStyle(
                            color: Colors.black, height: 1.5, fontSize: 16.0),
                        text: tr('waterPump.tip1'),
                      ),
                      TextSpan(
                        style: const TextStyle(
                            color: Color.fromRGBO(247, 133, 27, 1),
                            height: 1.5,
                            fontSize: 16.0),
                        text: tr('waterPump.tip2'),
                      ),
                      TextSpan(
                        style: const TextStyle(
                            color: Colors.black, height: 1.5, fontSize: 16.0),
                        text: tr('waterPump.tip3'),
                      )
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 64.h, 0, 0),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: V8_protocol.length,
                        itemBuilder: ((context, index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedProtocol = index;
                                });
                              },
                              child: Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0.w, 12.h, 0.w, 12.h),
                                child: Row(
                                  children: [
                                    RoundCheckBox(
                                      isChecked: selectedProtocol == index,
                                      onTap: (selected) {
                                        setState(() {
                                          selectedProtocol = index;
                                        });
                                      },
                                      size: 16,
                                      checkedWidget: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      checkedColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      border: Border.all(
                                          // width: 1,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(16.w, 0, 0, 0),
                                      child: Text(V8_protocol[index]).tr(),
                                    )
                                  ],
                                ),
                              ),
                            ))),
                  ),
                  Container(
                    width: double.infinity,
                    height: 72.h,
                    padding: EdgeInsets.fromLTRB(0, 0.h, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 208.w,
                          height: 72.h,
                          child: submitButton(
                            isActive: false,
                            label: tr('waterPump.noSubmit'),
                            onClick: () async {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        SizedBox(
                          width: 208.w,
                          height: 72.h,
                          child: submitButton(
                            isActive: true,
                            label: tr('waterPump.submit'),
                            onClick: () async {
                              Get.to(() => protocolSwitchPage(
                                    connectionSettings: selectedProtocol == 0
                                        ? 0
                                        : selectedProtocol == 1
                                            ? 2
                                            : 3,
                                  ));
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          : Container(),
    );
  }
}
