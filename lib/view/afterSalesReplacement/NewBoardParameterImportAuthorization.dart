import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:get/get.dart';
import 'ParameterWriting/index.dart';
import 'publicFunction.dart';
import 'style.dart';

class NewBoardParameterImportAuthorization extends StatefulWidget {
  NewBoardParameterImportAuthorization({Key? key}) : super(key: key);

  @override
  State<NewBoardParameterImportAuthorization> createState() =>
      _NewBoardParameterImportAuthorizationState();
}

class _NewBoardParameterImportAuthorizationState
    extends State<NewBoardParameterImportAuthorization> {
  final deviceInfoController _deviceInfoController = Get.find();
  bool isSure = true;
  int activeType = -1;
  List NewBoardParameterListstatus = [];

  static const _selfplatform =
      MethodChannel('samples.flutter.dev/RefrigerantService');
  init() async {
    //本地连接设备类型
    // ODU(0)
    // IDU(1)
    // SYS(2)
    if (_deviceInfoController.deviceTypeEnum.value == 1) {
      NewBoardParameterListstatus = [
        "afterSalesReplacement.NewBoardParameter3",
        "afterSalesReplacement.NewBoardParameter4"
      ];
    } else {
      NewBoardParameterListstatus = [
        "afterSalesReplacement.NewBoardParameter1",
        "afterSalesReplacement.NewBoardParameter2",
      ];
    }
    setState(() {
      NewBoardParameterListstatus;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var getProtocol =
          await _selfplatform.invokeMethod('getProtocol', <String, dynamic>{});
      var data = jsonDecode(getProtocol);
      print(
          "getProtocol: ${data["data"]} ${_deviceInfoController.deviceTypeEnum.value}");
      bool isv8 = data["data"].contains("V8");
      if (!isv8) {
        EasyLoading.showError(tr('afterSalesReplacement.confirm'));
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      }
      // bool issend = await divConfirmOnlyDialog(context,
      //     confirmText:
      //         tr('afterSalesReplacement.NewBoardParameterImport.confirmbutton'),
      //     confirmTitle:
      //         tr("afterSalesReplacement.NewBoardParameterImport.confirmTitle"),
      //     isSubmitButton: true, confirmDescriptionWidget: makesurepaga(
      //   onchange: (val) {
      //     setState(() {
      //       isSure = val;
      //     });
      //   },
      // ));
      // if (!issend) {
      //   if (!isSure) {
      //     init();
      //   }
      // }
    });
  }

  final afterSalesReplacementController _selfController =
      Get.put(afterSalesReplacementController());
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
    // Get height of app bar
    double appBarHeight = AppBar().preferredSize.height;

    // Calculate remaining height for page content
    double contentHeight = MediaQuery.of(context).size.height -
        appBarHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
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
          'afterSalesReplacement.NewBoardParameterImportAuthorization',
          style: TextStyle(color: Colors.black),
        ).tr(),
        centerTitle: true,
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 720.w,
              height: contentHeight - 57,
              padding: EdgeInsets.fromLTRB(32.w, 24.w, 32.w, 24.w),
              child: ListView.builder(
                itemCount: NewBoardParameterList.length + 1,
                itemBuilder: (context, index) => index ==
                        NewBoardParameterList.length
                    ? Center(
                        child: Text(
                          'afterSalesReplacement.NewBoardParameterTip',
                          style: ErrorTip(),
                          textAlign: TextAlign.center,
                        ).tr(),
                      )
                    : GestureDetector(
                        onTap: () {
                          if (NewBoardParameterListstatus.contains(
                              NewBoardParameterList[index])) {
                            activeType = activeType == index ? -1 : index;
                            setState(() {
                              activeType;
                            });
                          }
                        },
                        child: Opacity(
                          opacity: NewBoardParameterListstatus.contains(
                                  NewBoardParameterList[index])
                              ? 1
                              : 0.3,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'public/images/afterSalesReplacement/${NewBoardParameterList[index].toString().replaceAll("afterSalesReplacement.", "")}${NewBoardParameterList[index].toString().contains("4") ? '.png' : '.jpg'}',
                                        width: 182.w,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                          child: Text(
                                        tr(NewBoardParameterList[index]),
                                        overflow: TextOverflow.ellipsis,
                                        style: tipStyle(),
                                      )),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: RoundCheckBox(
                                    isChecked: activeType == index,
                                    onTap: NewBoardParameterListstatus.contains(
                                            NewBoardParameterList[index])
                                        ? (selected) {
                                            if (selected == true) {
                                              setState(() {
                                                activeType = index;
                                              });
                                            } else {
                                              setState(() {
                                                activeType = -1;
                                              });
                                            }
                                          }
                                        : null,
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
                                ),
                              ],
                            ),
                          ),
                        )),
              ),
            ),
            SizedBox(
              width: 600.w,
              height: 98.h,
              child: submitButton(
                isActive: activeType != -1,
                label: tr('determine'),
                onClick: () async {
                  if (activeType != -1) {
                    _selfController.setNewBoardParameterType(
                        NewBoardParameterList[activeType]);
                    Get.to(() => ParameterWriting());
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class makesurepaga extends StatefulWidget {
  Function? onchange;
  makesurepaga({super.key, this.onchange});

  @override
  State<makesurepaga> createState() => _makesurepagaState();
}

class _makesurepagaState extends State<makesurepaga> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isSure = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 560.w,
      height: 365,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(
                'afterSalesReplacement.NewBoardParameterImport.confirm1',
                style: titleStyleS(),
              ).tr(),
            ),
            Text(
              'afterSalesReplacement.NewBoardParameterImport.confirm2',
              style: titleStyleS(),
            ).tr(),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 32.h, 0, 32.h),
              child: Image.asset(
                'public/images/afterSalesReplacement/tip.png',
                width: 480.w,
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isSure = !isSure;
                });
                widget.onchange!(isSure);
              },
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RoundCheckBox(
                      isChecked: isSure,
                      onTap: (selected) {
                        setState(() {
                          isSure = selected!;
                        });
                        widget.onchange!(isSure);
                      },
                      size: 20,
                      checkedWidget: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                      checkedColor: Theme.of(context).colorScheme.secondary,
                      border: Border.all(
                          // width: 1,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                      child: const Text(
                              'afterSalesReplacement.NewBoardParameterImport.confirmtip')
                          .tr(),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
