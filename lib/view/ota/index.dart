import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/ota/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'deviceSelect.dart';
import 'history.dart';

class otaIndex extends StatefulWidget {
  otaIndex({super.key});

  @override
  State<otaIndex> createState() => _copybasepageState();
}

class _copybasepageState extends State<otaIndex> {
  final otaController _selfController = Get.put(otaController());
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
          title: const Text(
            'ota.title',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [
            TextButton(
                onPressed: () {
                  Get.to(() => otaHistory());
                },
                child: const Text("ota.history.title").tr())
          ],
        ),
        body: Container(
            width: 720.w,
            height: 1280.h,
            color: const Color.fromRGBO(244, 244, 244, 1),
            padding: EdgeInsets.fromLTRB(16, 25, 16, 0.h),
            child: ListView.builder(
              itemCount: 2,
              itemBuilder: ((context, index) => InkWell(
                    onTap: () {
                      if (index == 1) {
                        Get.to(() => deviceSelect());
                      }
                    },
                    child: Container(
                      height: 68,
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0.h),
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.65),
                        gradient: index == 0
                            ? const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: [0.0, 1.0],
                                colors: [
                                  Color.fromRGBO(187, 187, 187, 0.63),
                                  Color(0xFF8B8D92),
                                ],
                                transform:
                                    GradientRotation(251 * 3.1415927 / 180),
                              )
                            : const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.fromRGBO(17, 170, 255, 0.63),
                                  Color(0xFF1962FF),
                                ],
                                stops: [0.0, 1.0],
                                transform:
                                    GradientRotation(251 * 3.1415927 / 180),
                              ),
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                              child: Image.asset(
                                'public/images/ota/ota${index + 1}.png',
                                width: 30.w,
                              ),
                            ),
                            Text(
                              "ota.type${index + 1}",
                              style: normalText(fontcolor: Colors.white),
                            ).tr()
                          ],
                        ),
                      ),
                    ),
                  )),
            )));
  }
}
