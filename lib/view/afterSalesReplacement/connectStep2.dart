import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/view/afterSalesReplacement/connectStep3.dart';
import 'package:fluoroscopy_tool/view/afterSalesReplacement/publicFunction.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:get/get.dart';

class connectStep2Page extends StatefulWidget {
  String title;
  Widget? nextPage;
  connectStep2Page({super.key, required this.title, this.nextPage = null});
  @override
  State<connectStep2Page> createState() => _connectStep2PageState();
}

class _connectStep2PageState extends State<connectStep2Page> {
  List indoorconnectType = [
    'afterSalesReplacement.connectType3',
    'afterSalesReplacement.connectType4',
  ];

  final deviceInfoController _deviceInfoController = Get.find();
  final afterSalesReplacementController _selfController =
      Get.put(afterSalesReplacementController());
  @override
  void initState() {
    super.initState();
    if (_deviceInfoController.isPolling.value) {
      Get.back();
    }
    print(_selfController.connectType.value);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  bool isSure = false;

  @override
  Widget build(BuildContext context) {
    bool isCN =
        EasyLocalization.of(context)?.currentLocale!.languageCode == 'zh';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon:
                const Icon(Icons.chevron_left, color: Colors.black, size: 36)),
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black),
        ).tr(),
        centerTitle: true,
        actions: const [],
      ),
      body: Container(
        width: 720.w,
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(32.w, 24.w, 32.w, 24.w),
        child: Stack(
          children: [
            Positioned(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 64.h, 0, 0),
                  child: const Text(
                    'afterSalesReplacement.connectStepTip1',
                    textAlign: TextAlign.left,
                  ).tr(),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 64.h, 0, 64.h),
                  child:
                      const Text('afterSalesReplacement.connectStepTip2').tr(),
                ),
                Center(
                  child: Image.asset(
                    'public/images/afterSalesReplacement/${!indoorconnectType.contains(_selfController.connectType.value) ? "outdoor${isCN ? "" : "_en"}.png" : "indoor${isCN ? "" : "_en"}.png"}',
                    width: 487.w,
                  ),
                )
              ],
            )),
            Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () {
                            setState(() {
                              isSure = !isSure;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 72.h),
                            child: Row(
                              children: [
                                RoundCheckBox(
                                  isChecked: isSure,
                                  onTap: (selected) {
                                    setState(() {
                                      isSure = selected == true;
                                    });
                                  },
                                  size: 20,
                                  checkedWidget: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  checkedColor:
                                      Theme.of(context).colorScheme.secondary,
                                  border: Border.all(
                                      // width: 1,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                  child: Text(
                                          'afterSalesReplacement.connectStepTap')
                                      .tr(),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        width: 600.w,
                        height: 98.h,
                        child: submitButton(
                          isActive: isSure,
                          label: tr('afterSalesReplacement.connectStepButton'),
                          onClick: () async {
                            Get.to(() =>
                                connectStep3Page(nextPage: widget.nextPage));
                          },
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
