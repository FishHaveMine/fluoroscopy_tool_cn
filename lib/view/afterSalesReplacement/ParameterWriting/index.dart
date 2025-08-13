import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/view/afterSalesReplacement/ParameterWriting/getSn.dart';
import 'package:fluoroscopy_tool/view/afterSalesReplacement/ParameterWriting/getDeviceParameter.dart';
import 'package:fluoroscopy_tool/view/afterSalesReplacement/ParameterWriting/sendDeviceParameter.dart';
import 'package:fluoroscopy_tool/view/afterSalesReplacement/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../style.dart';
import 'package:flutter_stepindicator/flutter_stepindicator.dart';

class ParameterWriting extends StatefulWidget {
  ParameterWriting({super.key});
  @override
  State<ParameterWriting> createState() => _ParameterWritingState();
}

class _ParameterWritingState extends State<ParameterWriting> {
  final afterSalesReplacementController _selfController =
      Get.put(afterSalesReplacementController());

  int activeStep = 0;
  int page = 0;
  int counter = 3;
  List list = [0, 1, 2];
  List PageMap = [
    'afterSalesReplacement.ParameterWritingStep1',
    'afterSalesReplacement.ParameterWritingStep2',
    'afterSalesReplacement.ParameterWritingStep3'
  ];

  init() {
    // ignore: unrelated_type_equality_checks
    if (_selfController.NewBoardParameterType ==
        'afterSalesReplacement.NewBoardParameter1') {
      setState(() {
        list = [0, 2];
        PageMap = [
          'afterSalesReplacement.ParameterWritingStep1',
          'afterSalesReplacement.ParameterWritingStep3'
        ];
      });
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
  Widget build(BuildContext context) {
    // Get height of app bar
    double appBarHeight = AppBar().preferredSize.height;

    // Calculate remaining height for page content
    double contentHeight = MediaQuery.of(context).size.height - appBarHeight;
    return GetBuilder<afterSalesReplacementController>(
        builder: (_) => Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.chevron_left,
                        color: Colors.black, size: 36)),
                title: Text(
                  tr(_selfController.connectType.value) +
                      tr('afterSalesReplacement.ParameterWriting'),
                  style: const TextStyle(color: Colors.black),
                ),
                centerTitle: true,
                actions: const [],
              ),
              body: Container(
                  width: 720.w,
                  height: contentHeight,
                  padding: EdgeInsets.fromLTRB(0.w, 24.w, 0.w, 0.w),
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      Container(
                        width: double.maxFinite,
                        height: 30,
                        margin: EdgeInsets.fromLTRB(32.w, 0.w, 32.w, 0.w),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: FlutterStepIndicator(
                            height: 28,
                            paddingLine:
                                const EdgeInsets.symmetric(horizontal: 0),
                            positiveColor: const Color.fromRGBO(0, 128, 255, 1),
                            progressColor: const Color.fromRGBO(0, 128, 255, 1),
                            negativeColor: const Color(0xFFD5D5D5),
                            padding: const EdgeInsets.all(4),
                            list: list,
                            division: PageMap.length,
                            onChange: (i) {},
                            page: page,
                            onClickItem: (p0) {
                              if (page > p0) {
                                setState(() {
                                  page = p0;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: 30,
                        padding: EdgeInsets.fromLTRB(32.w, 0.w, 32.w, 0.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (int index = 0; index < PageMap.length; index++)
                              Text(
                                tr(PageMap[index]),
                                style: page >= index ? ActiveTip() : ErrorTip(),
                              ),
                          ],
                        ),
                      ),
                      if (page == 0)
                        Padding(
                            padding: EdgeInsets.fromLTRB(32.w, 0.w, 32.w, 0.w),
                            child: getSnPage(
                              nextStep: () {
                                // ignore: unrelated_type_equality_checks
                                if (_selfController.NewBoardParameterType ==
                                    'afterSalesReplacement.NewBoardParameter1') {
                                  setState(() {
                                    page = 2;
                                  });
                                } else {
                                  setState(() {
                                    page = 1;
                                  });
                                }
                              },
                            )),
                      if (page == 1)
                        getDeviceParameter(
                          preStep: () {
                            setState(() {
                              page = 0;
                            });
                          },
                          nextStep: () {
                            setState(() {
                              page = 2;
                            });
                          },
                        ),
                      if (page == 2) const sendDeviceParameter()
                    ],
                  ))),
            ));
  }
}
