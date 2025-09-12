import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/protocoldetection/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'welcomePage.dart';

class emptyResultPage extends StatefulWidget {
  emptyResultPage({super.key});

  @override
  State<emptyResultPage> createState() => _emptyResultPageState();
}

class _emptyResultPageState extends State<emptyResultPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.off(() => protocolwelcomePage());
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {
                    Get.off(() => protocolwelcomePage());
                  },
                  icon: const Icon(Icons.chevron_left,
                      color: Colors.black, size: 36)),
              title: const Text(
                'protocoldetection.title',
                style: TextStyle(color: Colors.black),
              ).tr(),
              centerTitle: true,
              actions: [],
            ),
            body: Container(
                width: 720.w,
                height: 1280.h,
                color: const Color.fromRGBO(255, 255, 255, 1),
                padding: EdgeInsets.fromLTRB(40.w, 37.h, 40.w, 37.h),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "protocoldetection.noResult.tip1",
                        style: normalTextBlack(),
                      ).tr(),
                      Image.asset(
                        'public/images/protocoldetection/emptyResult.png',
                        width: 640.w,
                      ),
                      Text(
                        "protocoldetection.noResult.tip2",
                        style: normalTextBlack(),
                      ).tr(),
                      Center(
                        child: SizedBox(
                          width: 208.w,
                          height: 72.h,
                          child: submitButton(
                            isActive: true,
                            onClick: () {
                              Get.off(() => protocolwelcomePage());
                            },
                            label: tr('determine'),
                          ),
                        ),
                      ),
                      // Center(
                      //   child: SizedBox(
                      //     width: 300,
                      //     height: 48,
                      //     child: normalButton(
                      //         label: tr(
                      //           "protocoldetection.noResult.tip3",
                      //         ),
                      //         onClick: () {
                      //           Get.to(() => protocolSearchPage(
                      //                 isnullresult: true,
                      //               ));
                      //         }),
                      //   ),
                      // )
                      InkWell(
                        onTap: () {
                          Get.to(() => protocolSearchPage(
                                isnullresult: true,
                              ));
                        },
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(25, 98, 255, 1),
                                    width: 0.5,
                                  ),
                                )),
                            child: Center(
                                child: Text(
                              "protocoldetection.noResult.tip3",
                              textAlign: TextAlign.center,
                              style: normalText(
                                  fontcolor:
                                      const Color.fromRGBO(25, 98, 255, 1),
                                  fSize: EasyLocalization.of(context)
                                              ?.currentLocale!
                                              .languageCode ==
                                          'zh'
                                      ? 18
                                      : 14),
                            ).tr())),
                      )
                    ],
                  ),
                ))));
  }
}
