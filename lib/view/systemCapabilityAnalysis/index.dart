import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'selfpublicFunction.dart';
import 'step1/analysisTypeSelect.dart';

class systemCapabilityAnalysisPage extends StatefulWidget {
  const systemCapabilityAnalysisPage({super.key});

  @override
  State<systemCapabilityAnalysisPage> createState() =>
      _systemCapabilityAnalysisPageState();
}

class _systemCapabilityAnalysisPageState
    extends State<systemCapabilityAnalysisPage> {
  final systemAnalysisController _systemController =
      Get.put(systemAnalysisController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<systemAnalysisController>(
        builder: (_) => Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {
                    Get.offAllNamed('/home'); //
                  },
                  icon: const Icon(Icons.chevron_left,
                      color: Colors.black, size: 36)),
              title: const Text(
                'systemCapabilityAnalysisPage.title',
                style: TextStyle(color: Colors.black),
              ).tr(),
              centerTitle: true,
              actions: [],
            ),
            body: Container(
                width: 720.w,
                height: 1280.h,
                color: const Color.fromRGBO(244, 244, 244, 1),
                padding: EdgeInsets.fromLTRB(32.w, 24.h, 32.w, 24.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'systemCapabilityAnalysisPage.index.tip1',
                      style: titleText(),
                    ).tr(),
                    Text('systemCapabilityAnalysisPage.index.tip2',
                            style: normalText())
                        .tr(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              _systemController.setAnalysisType(1);
                              Get.to(() => analysisTypeSelect(
                                    title:
                                        'systemCapabilityAnalysisPage.index.RefrigerationCapacityAnalysis',
                                  ));
                            },
                            child: Container(
                                height: 88,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    stops: [0.0, 1.0],
                                    colors: [
                                      Color(0xFF1962FF), // 使用十六进制颜色，FF表示完全不透明
                                      Color.fromRGBO(17, 170, 255,
                                          0.63), // 使用RGBA颜色，这里的0.63是透明度
                                    ],
                                    transform: GradientRotation(
                                        251 * 3.1415927 / 180), // 将角度转换为弧度
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 10, 0),
                                      child: Image.asset(
                                        'public/images/checkData/cooling@2x.png',
                                        width: 26,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Text(
                                      'systemCapabilityAnalysisPage.index.RefrigerationCapacityAnalysis',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ).tr()
                                  ],
                                )),
                          ),
                          InkWell(
                              onTap: () {
                                _systemController.setAnalysisType(2);
                                Get.to(() => analysisTypeSelect(
                                      title:
                                          'systemCapabilityAnalysisPage.index.HeatingCapacityAnalysis',
                                    ));
                              },
                              child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 17, 0, 0),
                                  height: 88,
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      stops: [0.0, 1.0],
                                      colors: [
                                        Color.fromRGBO(255, 130, 20,
                                            1), // 使用RGBA颜色，这里的0.63是透明度
                                        Color.fromRGBO(243, 168, 18,
                                            0.64), // 使用RGBA颜色，这里的0.63是透明度
                                      ],
                                      transform: GradientRotation(
                                          251 * 3.1415927 / 180), // 将角度转换为弧度
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 10, 0),
                                        child: Image.asset(
                                          'public/images/checkData/heating@2x.png',
                                          width: 26,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Text(
                                        'systemCapabilityAnalysisPage.index.HeatingCapacityAnalysis',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ).tr()
                                    ],
                                  ))),
                        ],
                      ),
                    )
                  ],
                ))));
  }
}
