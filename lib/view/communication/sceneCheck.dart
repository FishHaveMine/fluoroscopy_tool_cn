import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/bottomSelectSheet.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/communication/publicFunction.dart';
import 'package:fluoroscopy_tool/view/local/parameters/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import '../../store/intInput.dart';
import '../afterSalesReplacement/style.dart';
import '../local/parameters/style.dart';
import 'Instructions.dart';
import 'checking.dart';

class sceneCheckPage extends StatefulWidget {
  sceneCheckPage({super.key});

  @override
  State<sceneCheckPage> createState() => _sceneCheckPageState();
}

class _sceneCheckPageState extends State<sceneCheckPage> {
  final communicationController _selfController = Get.find();

  List<String> connectionSettingsType = [
    // 'V4',
    // 'V6',
    'V8',
  ];
  List<String> addressSetType = [
    '内机已有地址',
    '内机未设地址，需要自动分配地址',
  ];
  var limitByKey;
  final _formKey = GlobalKey<FormState>();
  Map needSetParameter = {"protocol": '', "indoorAddress": "0"};
  init() {
    if (_selfController.connectType.value == "0") {
      needSetParameter = {
        "protocol": connectionSettingsType[0],
        "indoorAddress": "0"
      };
    }
    // ignore: unrelated_type_equality_checks
    if (_selfController.connectType.value == "1") {
      needSetParameter = {"protocol": connectionSettingsType[0]};
    }
    // ignore: unrelated_type_equality_checks
    if (_selfController.connectType.value == "2") {
      needSetParameter = {
        "protocol": connectionSettingsType[0],
        "indoorNum": 0,
        "addressSet": addressSetType[0]
      };
    }

    setState(() {
      needSetParameter;
    });
  }

  updataval(key, val) {
    setState(() {
      needSetParameter[key] = val;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
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
          title: Text(
            tr("communication.type${(int.parse(_selfController.connectType.value) + 1).toString()}") +
                tr("communication.title "),
            style: const TextStyle(color: Colors.black),
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
              if (needSetParameter.isNotEmpty)
                Padding(
                    padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 24.h),
                    child: Container(
                      width: 720.w,
                      height: 1280.h - 112 - 57,
                      child: Form(
                        key: _formKey,
                        child: ListView.builder(
                            itemCount: needSetParameter.keys.length,
                            itemBuilder: ((context, index) => Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.fromLTRB(
                                      32.w, 24.h, 32.w, 24.h),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 8),
                                        child: Text(
                                            style: normalTextBlack(),
                                            "${index + 1}.${tr("sceneCheck.needSetParameter.${needSetParameter.keys.toList()[index]}")}"),
                                      ),
                                      if (needSetParameter.keys
                                              .toList()[index] !=
                                          "addressSet")
                                        InkWell(
                                          onTap: () async {
                                            List op = [];
                                            int addresslimit = 64;
                                            String nodekey = needSetParameter
                                                .keys
                                                .toList()[index];
                                            if (nodekey == "protocol") {
                                              for (var element
                                                  in connectionSettingsType) {
                                                op.add({
                                                  'label': element,
                                                  'name': element,
                                                  'value': element
                                                });
                                              }
                                            }
                                            if (nodekey == "indoorAddress" ||
                                                nodekey == "indoorNum") {
                                              for (var i = 0;
                                                  i < addresslimit;
                                                  i++) {
                                                op.add({
                                                  'label': tr(
                                                      '$i${nodekey == "indoorNum" ? "" : "#"}'),
                                                  'name': tr(
                                                      '$i${nodekey == "indoorNum" ? "" : "#"}'),
                                                  'value': i
                                                });
                                              }
                                            }
                                            if (nodekey == "addressSet") {
                                              for (var element
                                                  in addressSetType) {
                                                op.add({
                                                  'label': element,
                                                  'name': element,
                                                  'value': element
                                                });
                                              }
                                            }

                                            Future<sheetBack?> selectedIndex =
                                                await showCustomModalBottomSheet(
                                                    isMultiple: false,
                                                    context,
                                                    [...op],
                                                    // ignore: unrelated_type_equality_checks
                                                    baseValue: [
                                                      needSetParameter[
                                                              needSetParameter
                                                                      .keys
                                                                      .toList()[
                                                                  index]]
                                                          .toString()
                                                    ],
                                                    titleName: nodekey ==
                                                            "indoorNum"
                                                        ? tr("indoorNum")
                                                        : tr(
                                                            'parametersPage.settingLabel2'));
                                            selectedIndex.then((value) => {
                                                  if (value != null &&
                                                      value.baseValue![0] !=
                                                          -1 &&
                                                      needSetParameter[
                                                                  needSetParameter
                                                                          .keys
                                                                          .toList()[
                                                                      index]]
                                                              .toString() !=
                                                          value.baseValue![0]
                                                              .toString())
                                                    {
                                                      updataval(
                                                          needSetParameter.keys
                                                              .toList()[index],
                                                          value.baseValue![0])
                                                    }
                                                });
                                          },
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      16, 10, 16, 10),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        const Color(0xFFf0f0f0),
                                                    width: 1.0),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0, 0, 0),
                                                    child: Text(
                                                      tr('${needSetParameter.keys.toList()[index]}'),
                                                      style: normalText(),
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Row(
                                                    children: [
                                                      Expanded(
                                                          child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 0, 10, 0),
                                                        child: Text(
                                                          '${needSetParameter[needSetParameter.keys.toList()[index]]} ${needSetParameter.keys.toList()[index] == "indoorAddress" ? "#" : ""}',
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.end,
                                                          style: settingTitle(
                                                              context),
                                                        ),
                                                      )),
                                                      const Icon(
                                                        Icons.arrow_forward_ios,
                                                        size: 16,
                                                        color: Color.fromRGBO(
                                                            204, 204, 204, 1),
                                                      )
                                                    ],
                                                  ))
                                                ],
                                              )),
                                        ),
                                      if (needSetParameter.keys
                                              .toList()[index] ==
                                          "protocol")
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 8),
                                          child: Text(
                                                  style: normalText(
                                                      fontcolor: Colors.red),
                                                  "sceneCheck.needSetParameter.protocoltip")
                                              .tr(),
                                        ),
                                      if (needSetParameter.keys
                                              .toList()[index] ==
                                          "addressSet")
                                        Column(
                                          children: [
                                            for (var element in addressSetType)
                                              InkWell(
                                                onTap: () {
                                                  updataval(
                                                      needSetParameter.keys
                                                          .toList()[index],
                                                      element);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 8, 0, 8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      RoundCheckBox(
                                                        key: ValueKey(
                                                            needSetParameter[
                                                                needSetParameter
                                                                        .keys
                                                                        .toList()[
                                                                    index]]),
                                                        isChecked: needSetParameter[
                                                                    needSetParameter
                                                                            .keys
                                                                            .toList()[
                                                                        index]]
                                                                .toString() ==
                                                            element,
                                                        onTap: (selected) {
                                                          if (selected!) {
                                                            updataval(
                                                                needSetParameter
                                                                        .keys
                                                                        .toList()[
                                                                    index],
                                                                element);
                                                          }
                                                        },
                                                        size: 20,
                                                        checkedWidget:
                                                            const Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                          size: 16,
                                                        ),
                                                        checkedColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .secondary,
                                                        border: Border.all(
                                                            // width: 1,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                8, 0, 0, 5),
                                                        child: Text(element,
                                                                style:
                                                                    normalText())
                                                            .tr(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                          ],
                                        )
                                    ],
                                  ),
                                ))),
                      ),
                    )),
              Container(
                height: 57,
                padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                child: Center(
                  child: submitButton(
                    isActive: true,
                    label: tr('Instructionspage.next'),
                    onClick: () async {
                      _selfController.saveNeedSetParameter(needSetParameter);
                      Get.to(() => checkingpage());
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
