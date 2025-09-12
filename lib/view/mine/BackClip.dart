// ignore_for_file: use_build_context_synchronously, unused_element

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalData.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackClip extends StatefulWidget {
  BackClip({super.key});

  @override
  State<BackClip> createState() => _accountState();
}

class _accountState extends State<BackClip> {
  static const _selfplatform = MethodChannel('samples.flutter.dev/BackClip');
  String BackClipIAPVersion = "--";
  String BackClipAPPVersion = "--";
  String BackClipSDKversion = "--";
  String CacheFile = "--";

  init() async {
    EasyLoading.show(status: 'loading...');

    try {
      var historyback =
          await _selfplatform.invokeMethod('getBackClipIAPVersion', {});

      var historydata = jsonDecode(historyback);
      if (historydata["data"] != null) {
        BackClipIAPVersion = historydata["data"];
      }

      var historyback1 =
          await _selfplatform.invokeMethod('getBackClipAPPVersion', {});

      var historydata1 = jsonDecode(historyback1);
      if (historydata1["data"] != null) {
        BackClipAPPVersion = historydata1["data"];
      }

      var getBackClipSDKVersion =
          await _selfplatform.invokeMethod('getBackClipSDKVersion', {});

      var getBackClipSDKVersion1 = jsonDecode(getBackClipSDKVersion);
      if (getBackClipSDKVersion1["data"] != null) {
        BackClipSDKversion = getBackClipSDKVersion1["data"];
      }

      setState(() {
        BackClipIAPVersion;
        BackClipAPPVersion;
        BackClipSDKversion;
      });
      EasyLoading.dismiss();
      if (!historydata['success']) {
        EasyLoading.showError(historydata['errorMsg']);
      }
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
    }
  }

  _upgradeBackClipIAP() async {
    EasyLoading.show(status: 'loading...');
    try {
      var historyback =
          await _selfplatform.invokeMethod('upgradeBackClipIAP', {});
      var historydata = jsonDecode(historyback);
      print("upgradeBackClipIAP ： $historydata");
      EasyLoading.dismiss();
      if (!historydata['success']) {
        EasyLoading.showError(historydata['errorMsg']);
        return;
      } else {
        EasyLoading.showSuccess(tr("upgradesuccess"));
        await Future.delayed(const Duration(seconds: 2), () {
          print('One second has passed.'); // Prints after 1 second.
        });
      }
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
    }
  }

  _loadshowPickerDialog(context) async {
    EasyLoading.show(status: 'loading...');
    try {
      EasyLoading.dismiss();
      showPickerDialog(context, []);
    } catch (e) {
      print(e);

      showPickerDialog(context, []);
      EasyLoading.dismiss();
    }
  }

  showPickerDialog(BuildContext context, options) async {
    List options = [
      'AC90_APP_v1.12.bin',
      'AC90_APP_v1.13.bin',
      'AC90_APP_v1.14.bin',
      'AC90_APP_v1.16.bin',
      'AC90_APP_v1.17.bin'
    ];
    // Show a custom dialog with options
    String? selectedOption = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            tr('upgradelist'),
            style: normalTextBlack(),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: options.map((option) {
                return ListTile(
                  title: Text(option),
                  onTap: () {
                    Navigator.pop(
                        context, option); // Return the selected option
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    // Handle the selected option
    if (selectedOption != null) {
      _upgradeBackClipApp(selectedOption);
    }
  }

  _upgradeBackClipApp(Selected) async {
    EasyLoading.show(status: 'loading...');
    try {
      var historyback = await _selfplatform
          .invokeMethod('upgradeBackClipApp', {"resources": Selected});
      var historydata = jsonDecode(historyback);
      EasyLoading.dismiss();
      if (!historydata['success']) {
        EasyLoading.showError(historydata['errorMsg']);
        return;
      } else {
        EasyLoading.showSuccess(tr("upgradesuccess"));
        await Future.delayed(const Duration(seconds: 2), () {
          print('One second has passed.'); // Prints after 1 second.
        });
        init();
      }
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    EasyLoading.dismiss();
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
            'menu_About',
            style: TextStyle(color: Color.fromARGB(255, 71, 49, 49)),
          ).tr(),
          centerTitle: true,
          actions: const [],
        ),
        body: SizedBox(
            width: 720.w,
            height: 1280.h,
            child: Column(children: [
              Expanded(
                  child: Column(
                children: [
                  itembox(
                    title: 'BackClip.IAPversion',
                    val: BackClipIAPVersion,
                    clickfun: _upgradeBackClipIAP,
                  ),
                  itembox(
                    title: 'BackClip.APPversion',
                    val: BackClipAPPVersion,
                    clickfun: () {
                      _loadshowPickerDialog(context);
                    },
                  ),
                  itembox(
                    title: 'BackClip.SDKversion',
                    val: BackClipSDKversion,
                    clickfun: null,
                  )
                ],
              )),
            ])));
  }
}

class itembox extends StatelessWidget {
  String title;
  String val;
  Function? clickfun;
  String? btntext;
  itembox(
      {super.key,
      required this.title,
      required this.val,
      this.clickfun,
      this.btntext});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(32.w, 24.h, 32.w, 24.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title).tr(),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 400.w,
                      child: Text(
                        val,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            color: Color.fromRGBO(140, 140, 140, 1)),
                      ).tr(),
                    ),
                    if (clickfun != null)
                      TextButton(
                          onPressed: () {
                            clickfun!();
                          },
                          child: Text(btntext ?? tr("upgrade")))
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
