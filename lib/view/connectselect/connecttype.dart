import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/view/afterSalesReplacement/connectStep1.dart';
import 'package:fluoroscopy_tool/view/connectselect/bluetoothcheck.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import '../../store/globalData.dart';

class connecttypepage extends StatefulWidget {
  String? title;
  Widget? nextPage;
  List? connectType;
  connecttypepage(
      {super.key,
      this.title = null,
      this.connectType = null,
      this.nextPage = null});

  @override
  State<connecttypepage> createState() => _connecttypepageState();
}

class _connecttypepageState extends State<connecttypepage> {
  final deviceInfoController _deviceInfoController = Get.find();

  List con = ['menu_device', 'menu_bluetooth'];

  static const MSInterfaceplatform =
      MethodChannel('samples.flutter.dev/MSInterface');

  setLocalBluetoothConnect(isBluetoothConnect) async {
    try {
      var _toolUnlock = await MSInterfaceplatform.invokeMethod(
          'isBluetoothConnect',
          <String, dynamic>{"isBluetoothConnect": isBluetoothConnect});
    } on PlatformException catch (_, e) {
      print(" setLocalBluetoothConnect:   $e");
    }
  }

  int selectindex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (appCOUNTRY == "CN") {
        Get.to(() => connectStep1Page(
              title:
                  widget.title ?? tr('afterSalesReplacement.connectTypeTitle'),
              connectType: widget.connectType ??
                  const [
                    'afterSalesReplacement.connectType1',
                    'afterSalesReplacement.connectType3',
                  ],
              nextPage: null,
            ));
      }
    });
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
            'bluetooth.connect',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [],
        ),
        body: Container(
          width: 720.w,
          height: 1280.h,
          color: const Color.fromRGBO(244, 244, 244, 1),
          padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
          child: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                itemCount: con.length,
                itemBuilder: ((context, index) => Container(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectindex = index;
                        });
                      },
                      child: Container(
                        width: 720.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                        ),
                        margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                        padding: const EdgeInsets.all(28),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Row(
                              children: [
                                Image.asset(
                                  'public/images/bluetooth/connect${index + 1}_${index + 1}.png',
                                  width: 200.w,
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(19, 0, 0, 0),
                                  child: Text(
                                    con[index],
                                    style: const TextStyle(
                                        color: Color.fromRGBO(13, 13, 13, 1),
                                        decoration: TextDecoration.none,
                                        // 文字大小
                                        fontSize: 16.0,
                                        // normal 正常，italic 斜体
                                        fontStyle: FontStyle.normal,
                                        // 字体的粗细
                                        fontWeight: FontWeight.w600,
                                        // 文字间的宽度
                                        letterSpacing: 1.0),
                                  ).tr(),
                                )
                              ],
                            )),
                            RoundCheckBox(
                              isChecked: selectindex == index,
                              onTap: null,
                              size: 24,
                              checkedWidget: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 18,
                              ),
                              disabledColor: selectindex != index
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.secondary,
                              checkedColor: selectindex != index
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.secondary,
                              border: Border.all(
                                  // width: 1,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                          ],
                        ),
                      ),
                    ))),
              )),
              Container(
                height: 98.h,
                padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                child: submitButton(
                  isActive: true,
                  fs: 16,
                  label: tr('moadd.step3.btn'),
                  onClick: () async {
                    if (selectindex == 0) {
                      setLocalBluetoothConnect(false);
                      // _deviceInfoController.setIsBluetooth(false);
                      Get.to(() => connectStep1Page(
                            title: widget.title ??
                                tr('afterSalesReplacement.connectTypeTitle'),
                            connectType: widget.connectType ??
                                const [
                                  'afterSalesReplacement.connectType1',
                                  'afterSalesReplacement.connectType3',
                                ],
                            nextPage: null,
                          ));
                    } else {
                      setLocalBluetoothConnect(true);

                      // _deviceInfoController.setIsBluetooth(true);
                      Get.to(() => const FlutterBlueApp());
                    }
                  },
                ),
              )
            ],
          ),
        ));
  }
}
