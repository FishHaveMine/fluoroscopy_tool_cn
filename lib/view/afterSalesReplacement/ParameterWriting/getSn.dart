import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/snInput.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/style/color.dart';
import 'package:fluoroscopy_tool/view/afterSalesReplacement/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import '../style.dart';

class getSnPage extends StatefulWidget {
  VoidCallback nextStep;
  getSnPage({super.key, required this.nextStep});

  @override
  State<getSnPage> createState() => _getSnPageState();
}

class _getSnPageState extends State<getSnPage> {
  String sn = '';
  String parameter = "";
  final MethodChannel methodChannel = const MethodChannel('scan.data');
  static const platform = MethodChannel('samples.flutter.dev/battery');

  static const _selfplatform =
      MethodChannel('samples.flutter.dev/afterSalesReplacement');

  final afterSalesReplacementController _selfController =
      Get.put(afterSalesReplacementController());

  bool needparameter = true;

  bool needsn = true;
  init() {
    // ignore: unrelated_type_equality_checks
    needparameter = _selfController.NewBoardParameterType !=
        'afterSalesReplacement.NewBoardParameter1';
    // ignore: unrelated_type_equality_checks
    needsn = _selfController.NewBoardParameterType !=
        'afterSalesReplacement.NewBoardParameter4';
    setState(() {
      needparameter;
      needsn;
    });
  }

  getParameters() async {
    try {
      widget.nextStep();
    } on PlatformException catch (e) {}
  }

  openscan() async {
    print("openscan");
    try {
      await platform.invokeMethod('SCANNER_TRIG');
    } on PlatformException catch (e) {
      print("Failed to SCANNER_TRIG: '${e.message}'.");
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1280.h - 24.w * 2 - 60 - 90,
      child: Stack(children: [
        Positioned(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 24.h, 0, 0.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'afterSalesReplacement.sn',
                          style: ErrorTip(),
                        ).tr(),
                        Stack(
                          children: [
                            Positioned(
                                child: Container(
                              margin: const EdgeInsets.fromLTRB(0, 9, 0, 0),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(42),
                                  color: snInputColors),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      openscan();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      child: Image.asset(
                                        'public/images/waterPump/scran.png',
                                        width: 40.w,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: snInput(
                                      valBack: (back) {
                                        if (back == "" && sn != "") {
                                          setState(() {
                                            sn = back;
                                          });
                                        }
                                        if (back.length == 22) {
                                          setState(() {
                                            sn = back;
                                          });
                                          _selfController
                                              .setParameterWritingSn(sn);
                                        } else {
                                          if ((sn != "" || !needsn) &&
                                              back.toString().contains("[") &&
                                              back.toString().contains("]")) {
                                            setState(() {
                                              parameter = back;
                                            });

                                            _selfController
                                                .setParameterWritingParameter(
                                                    parameter);

                                            getParameters();
                                          }
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ))
                          ],
                        )
                      ],
                    )),
              ),
            ],
          ),
        ),
        if (sn == '' && needsn)
          Positioned(
              left: 0,
              top: 130,
              child: SizedBox(
                width: 720.w - 32.w * 2,
                height: 540.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0.h, 0, 0.h),
                          child: Image.asset(
                            'public/images/afterSalesReplacement/snTip1.png',
                            width: 360.w,
                          )),
                    )
                  ],
                ),
              )),
        if ((sn != '' || !needsn) && !needparameter)
          Positioned(
              left: 0,
              bottom: 0,
              child: SizedBox(
                width: 660.w,
                height: 540.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 600.w,
                      height: 98.h + 20.h + 24.h,
                      padding: EdgeInsets.fromLTRB(0, 24.h, 0, 20.h),
                      child: submitButton(
                        isActive: true,
                        label:
                            tr('afterSalesReplacement.ParameterWritingStep3'),
                        onClick: () async {
                          widget.nextStep();
                        },
                      ),
                    )
                  ],
                ),
              )),
        if ((sn != '' || !needsn) && needparameter)
          Positioned(
              left: 0,
              bottom: 0,
              child: SizedBox(
                width: 660.w,
                height: 540.h,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 24.h, 0, 0.h),
                          child: Image.asset(
                            'public/images/afterSalesReplacement/snTip.png',
                            width: 360.w,
                          )),
                    ),
                    Container(
                      width: 600.w,
                      height: 98.h + 20.h + 24.h,
                      padding: EdgeInsets.fromLTRB(0, 24.h, 0, 20.h),
                      child: submitButton(
                        isActive: true,
                        label: tr('afterSalesReplacement.getcode'),
                        onClick: () async {
                          openscan();
                        },
                      ),
                    )
                  ],
                ),
              ))
      ]),
    );
  }
}
