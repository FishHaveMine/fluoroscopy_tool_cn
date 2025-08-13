import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/cloud/projectManage/addmodelM0/step4.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../errorAnalysis/errorDetail.dart';
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

  var modifyType3map = [
    {"title": "旧改云联盒子", "des": "完整拍摄包含空调主体及旧改模块安装盒的照片", "required": true},
    {"title": "喷淋装置安装", "des": "完整拍摄包含空调主体及喷淋装置的照片", "required": true},
    {"title": "现场取电位置", "des": "根据供电方式选择拍摄供电插座或接线位置", "required": true},
    {"title": "水质检测数据/水质处理装置", "des": "可选择拍摄水质检测报告照片或完整拍摄水质", "required": true},
    {"title": "外机铭牌照片", "des": "请正对外机铭牌进行拍摄，尽量保证图片高清，文字清晰", "required": true},
    {"title": "其它照片", "des": "上传更多可反映现场照片，不限于散热器局部", "required": false}
  ];

  var modifyType4map = [
    {"title": "旧改云联盒子", "des": "完整拍摄包含空调主体及旧改模块安装盒的照片", "required": true},
    {"title": "现场取电位置", "des": "根据供电方式选择拍摄供电插座或接线位置", "required": true},
    {"title": "外机铭牌照片", "des": "请正对外机铭牌进行拍摄，尽量保证图片高清，文字清晰", "required": true},
    {"title": "其它照片", "des": "上传更多可反映现场照片，不限于散热器局部", "required": false}
  ];

  var modifyType2map = [
    {"title": "旧改云联盒子", "des": "完整拍摄包含空调主体及旧改模块安装盒的照片", "required": true},
    {"title": "现场取电位置", "des": "根据供电方式选择拍摄供电插座或接线位置", "required": true},
    {"title": "外机铭牌照片", "des": "请正对外机铭牌进行拍摄，尽量保证图片高清，文字清晰", "required": true},
    {"title": "其它照片", "des": "上传更多可反映现场照片，不限于散热器局部", "required": false}
  ];

  var modifyType1map = [
    {"title": "旧改云联盒子", "des": "完整拍摄包含空调主体及旧改模块安装盒的照片", "required": true},
    {"title": "喷淋装置安装", "des": "完整拍摄包含空调主体及喷淋装置的照片", "required": true},
    {"title": "现场取电位置", "des": "根据供电方式选择拍摄供电插座或接线位置", "required": true},
    {"title": "水质检测数据/水质处理装置", "des": "可选择拍摄水质检测报告照片或完整拍摄水质", "required": true},
    {"title": "外机铭牌照片", "des": "请正对外机铭牌进行拍摄，尽量保证图片高清，文字清晰", "required": true},
    {"title": "其它照片", "des": "上传更多可反映现场照片，不限于散热器局部", "required": false}
  ];

  var isValid = false;
  checkIsActive(_) {
    var modifyType = _.jsonObject['modifyType'];
    var images = _.imgaeList.value;
    var _isValid = true;
    // 获取当前修改类型对应的配置
    var configMap = {
      'modifyType1': modifyType1map,
      'modifyType2': modifyType2map,
      'modifyType3': modifyType3map,
      'modifyType4': modifyType4map
    }[modifyType];

    if (configMap != null) {
      for (var i = 0; i < configMap.length; i++) {
        if (configMap[i]['required'] == true && images['type${i + 1}'] == "") {
          _isValid = false;
        }
      }
    }

    setState(() {
      isValid = _isValid;
    });
    return _isValid;
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
                  if (_.jsonObject['modifyType'] == "modifyType4")
                    Expanded(
                        child: ListView.builder(
                            itemCount: modifyType4map.length,
                            itemBuilder: ((context, index) => Container(
                                  padding:
                                      EdgeInsets.fromLTRB(0.w, 12, 0.w, 12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Row(
                                          children: [
                                            if (modifyType4map[index]
                                                    ['required'] ==
                                                true)
                                              Text(
                                                '*',
                                                style: normalTextBlack(
                                                    fontcolor: Colors.red),
                                              ).tr(),
                                            Text(
                                              '${modifyType4map[index]['title']}(请补充照片)',
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
                                              '${modifyType4map[index]['des']}',
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
                                              checkIsActive(_);
                                            }),
                                      )
                                    ],
                                  ),
                                )))),
                  if (_.jsonObject['modifyType'] == "modifyType3")
                    Expanded(
                        child: ListView.builder(
                            itemCount: modifyType3map.length,
                            itemBuilder: ((context, index) => Container(
                                  padding:
                                      EdgeInsets.fromLTRB(0.w, 12, 0.w, 12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Row(
                                          children: [
                                            if (modifyType3map[index]
                                                    ['required'] ==
                                                true)
                                              Text(
                                                '*',
                                                style: normalTextBlack(
                                                    fontcolor: Colors.red),
                                              ).tr(),
                                            Text(
                                              '${modifyType3map[index]['title']}(请补充照片)',
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
                                              '${modifyType3map[index]['des']}',
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
                                              checkIsActive(_);
                                            }),
                                      )
                                    ],
                                  ),
                                )))),
                  if (_.jsonObject['modifyType'] == "modifyType2")
                    Expanded(
                        child: ListView.builder(
                            itemCount: modifyType2map.length,
                            itemBuilder: ((context, index) => Container(
                                  padding:
                                      EdgeInsets.fromLTRB(0.w, 12, 0.w, 12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Row(
                                          children: [
                                            if (modifyType2map[index]
                                                    ['required'] ==
                                                true)
                                              Text(
                                                '*',
                                                style: normalTextBlack(
                                                    fontcolor: Colors.red),
                                              ).tr(),
                                            Text(
                                              '${modifyType2map[index]['title']}(请补充照片)',
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
                                              '${modifyType2map[index]['des']}',
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
                                              checkIsActive(_);
                                            }),
                                      )
                                    ],
                                  ),
                                )))),
                  if (_.jsonObject['modifyType'] == "modifyType1")
                    Expanded(
                        child: ListView.builder(
                            itemCount: modifyType1map.length,
                            itemBuilder: ((context, index) => Container(
                                  padding:
                                      EdgeInsets.fromLTRB(0.w, 12, 0.w, 12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Row(
                                          children: [
                                            if (modifyType1map[index]
                                                    ['required'] ==
                                                true)
                                              Text(
                                                '*',
                                                style: normalTextBlack(
                                                    fontcolor: Colors.red),
                                              ).tr(),
                                            Text(
                                              '${modifyType1map[index]['title']}(请补充照片)',
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
                                              '${modifyType1map[index]['des']}',
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
                                              checkIsActive(_);
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
                        isActive: isValid,
                        label: tr('MOadd.step2.btn'),
                        onClick: () async {
                          if (isValid) {
                            Get.to(() => addmodelM0_step4());
                          } else {
                            List<String> missingFields = [];
                            var modifyType = _.jsonObject['modifyType'];
                            var images = _.imgaeList.value;
                            // 获取当前修改类型对应的配置
                            var configMap = {
                              'modifyType1': modifyType1map,
                              'modifyType2': modifyType2map,
                              'modifyType3': modifyType3map,
                              'modifyType4': modifyType4map
                            }[modifyType];

                            if (configMap != null) {
                              for (var i = 0; i < configMap.length; i++) {
                                if (configMap[i]['required'] == true &&
                                    images['type${i + 1}'] == "") {
                                  missingFields
                                      .add(configMap[i]['title'].toString());
                                }
                              }
                            }

                            if (missingFields.isNotEmpty) {
                              EasyLoading.showToast(
                                  "请补充以下照片:\n\n" + missingFields.join("\n"));
                            }
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

  // 显示选择图片来源的对话框
  Future<void> _showImageSourceDialog() async {
    if (widget.url == null || widget.url == "") {
      await selectImage();
    } else {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              '请选择',
              style: TextStyle(color: Colors.black),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: const Text('查看'),
                    onTap: () {
                      Navigator.of(context).pop();
                      if (widget.url != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FullScreenImage(imageUrl: widget.url ?? ''),
                          ),
                        );
                      }
                    },
                  ),
                  const Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: const Text('删除'),
                    onTap: () {
                      widget.onselect('');
                      image = null;
                      Navigator.of(context).pop();
                    },
                  ),
                  const Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: const Text('重新上传'),
                    onTap: () async {
                      Navigator.of(context).pop();
                      await selectImage();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Future<void> selectImage() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '选择图片来源',
            style: TextStyle(color: Colors.black),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text('拍照'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _onclick(ImageSource.camera);
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: const Text('从相册选择'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _onclick(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _onclick(source) async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    image = await picker.pickImage(source: source);
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

      print("deviceImportUploadImg historydata $historydata");
      EasyLoading.dismiss();
      if (!historydata['success']) {
        EasyLoading.showError(historydata['errorMsg']);
        return;
      } else {
        widget.onselect(historydata['data']);
      }
    } catch (e) {
      print("deviceImportUploadImg error $e");
      widget.onselect('');
      image = null;
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
                  _showImageSourceDialog();
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
                      _showImageSourceDialog();
                    },
                    child: Image.file(
                      File(image!.path),
                      height: 72,
                    ))
                : InkWell(
                    onTap: () {
                      _showImageSourceDialog();
                    },
                    child: Image.network(
                      widget.url!,
                      height: 72,
                    )));
  }
}
