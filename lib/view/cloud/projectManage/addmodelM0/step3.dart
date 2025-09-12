import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/snInput.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/cloud/projectManage/addmodelM0/step4.dart';
import 'package:fluoroscopy_tool/view/cloud/projectManage/ibutler/ibutler.dart';
import 'package:fluoroscopy_tool/view/systemCapabilityAnalysis/step2/systemDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import 'publicFunction.dart';

class addmodelM0_step3 extends StatefulWidget {
  addmodelM0_step3({super.key});

  @override
  State<addmodelM0_step3> createState() => _addmodelM0_step3State();
}

class _addmodelM0_step3State extends State<addmodelM0_step3> {
  final MOaddController _selectController = Get.put(MOaddController());
  static const _selfplatform =
      MethodChannel('samples.flutter.dev/getProjectHandler');

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   _selectController.cleanimgaeList();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MOaddController>(
        init: MOaddController(),
        builder: (_) => Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.chevron_left,
                      color: Colors.black, size: 36)),
              title: const Text(
                'MOadd.step3.title',
                style: TextStyle(color: Colors.black),
              ).tr(),
              centerTitle: true,
              actions: [],
            ),
            body: Container(
              width: 720.w,
              height: 1280.h,
              color: const Color.fromRGBO(255, 255, 255, 1),
              padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
              child: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                          itemCount: 5,
                          itemBuilder: ((context, index) => Container(
                                padding: EdgeInsets.fromLTRB(0.w, 12, 0.w, 12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Row(
                                        children: [
                                          if (index != 4)
                                            Text(
                                              '*',
                                              style: normalTextBlack(
                                                  fontcolor: Colors.red),
                                            ).tr(),
                                          Text(
                                            'MOadd.step3.type${index + 1}',
                                            style: normalTextBlack(),
                                          ).tr(),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Row(children: [
                                          Text(
                                            'MOadd.step3.tip${index + 1}',
                                            style: normalText(),
                                          ).tr()
                                        ])),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 12, 0, 0),
                                      child: imgaepick(
                                          url: _.imgaeList
                                              .value['type${index + 1}'],
                                          onselect: (val) {
                                            _selectController
                                                .updateDeviceImgaeList(
                                                    'type${index + 1}', val);
                                          }),
                                    )
                                  ],
                                ),
                              )))),
                  Container(
                    height: 57,
                    padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                    child: Center(
                      child: submitButton(
                        isActive: _.imgaeList.value["type1"] != "" &&
                            _.imgaeList.value["type2"] != "" &&
                            _.imgaeList.value["type3"] != "" &&
                            _.imgaeList.value["type4"] != "",
                        label: tr('MOadd.step2.btn'),
                        onClick: () async {
                          // Get.to(() => addmodelM0_step4());
                          // return;
                          if (_.imgaeList.value["type1"] != "" &&
                              _.imgaeList.value["type2"] != "" &&
                              _.imgaeList.value["type3"] != "" &&
                              _.imgaeList.value["type4"] != "") {
                            Get.to(() => addmodelM0_step4());
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            )));
  }
}

class imgaepick extends StatefulWidget {
  Function onselect;
  String? url;
  imgaepick({super.key, this.url, required this.onselect});

  @override
  State<imgaepick> createState() => _imgaepickState();
}

class _imgaepickState extends State<imgaepick> {
  static const _selfplatform =
      MethodChannel('samples.flutter.dev/getProjectHandler');
  XFile? image;
  _onclick() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      widget.onselect("");
      setState(() {
        image;
      });
    }
    EasyLoading.show(status: 'loading...');
    try {
      var historyback = await _selfplatform.invokeMethod(
          'getAppFluorineMachineEnergyHandler.deviceImportUploadImg', {
        "filePath": image!.path,
      });

      var historydata = jsonDecode(historyback);
      EasyLoading.dismiss();
      if (!historydata['success']) {
        EasyLoading.showError(historydata['errorMsg']);
        return;
      } else {
        widget.onselect(historydata['data']);
      }
    } catch (e) {
      print("deviceImportUploadImg error $e");
      EasyLoading.dismiss();
    }
    setState(() {
      image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: image == null && (widget.url == null || widget.url == "")
            ? InkWell(
                onTap: () {
                  _onclick();
                },
                child: Container(
                  width: 720.w - 32,
                  height: 72,
                  color: const Color.fromRGBO(244, 244, 244, 1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.photo_camera,
                        color: Color.fromRGBO(140, 140, 140, 1),
                      ),
                      Text(
                        "click.select",
                        style: normalText(),
                      ).tr()
                    ],
                  ),
                ),
              )
            : widget.url == null || widget.url == ""
                ? InkWell(
                    onTap: () {
                      _onclick();
                    },
                    child: Image.file(
                      File(image!.path),
                      height: 72,
                    ))
                : InkWell(
                    onTap: () {
                      _onclick();
                    },
                    child: Image.network(
                      widget.url!,
                      height: 72,
                    )));
  }
}
