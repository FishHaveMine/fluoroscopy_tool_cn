import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/tapContainer.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/protocoldetection/welcomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../local/publicFunction.dart';
import '../waterPumpInspection/search.dart';

class resultTapPage extends StatefulWidget {
  resultTapPage({super.key});

  @override
  State<resultTapPage> createState() => _emptyResultPageState();
}

class _emptyResultPageState extends State<resultTapPage> {
  final deviceInfoController _deviceInfoController = Get.find();
  List data = [];
  List data_type1 = [];
  List data_type2 = [];
  int type1count = 0;

  init() {
    data = [];
    for (int i = 0; i < _deviceInfoController.indoorEntityList.length; i++) {
      data.add(_deviceInfoController.indoorEntityList.value[i]);
    }
    data_type1 = data
        .where((number) =>
            number['iduProtocolTypeEnum'] == null ||
            number['iduProtocolTypeEnum'] == "UN_KNOW")
        .toList();
    data_type2 = data
        .where((number) =>
            number['iduProtocolTypeEnum'] != null &&
            number['iduProtocolTypeEnum'] != "UN_KNOW")
        .toList();

    setState(() {
      data;
      data_type1;
      data_type2;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<bool> _onWillPop() async {
    Get.off(() => protocolwelcomePage()); //
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {
                    Get.off(() => protocolwelcomePage()); //
                  },
                  icon: const Icon(Icons.chevron_left,
                      color: Colors.black, size: 36)),
              title: const Text(
                'protocoldetection.title',
                style: TextStyle(color: Colors.black),
              ).tr(),
              centerTitle: true,
              actions: const [],
            ),
            body: tapContariner(
              activeIndex: 0,
              tap: List.generate(
                  3,
                  (index) => tr("protocoldetection.result.type${index + 1}",
                          namedArgs: {
                            "val": index == 0
                                ? "${data_type1.length}"
                                : index == 1
                                    ? "${data_type2.length}"
                                    : "${data.length}"
                          })),
              child: [
                ListView.builder(
                    itemCount: data_type1.length,
                    itemBuilder: (context, index) => resultBox(
                          item: data_type1[index],
                        )),
                ListView.builder(
                    itemCount: data_type2.length,
                    itemBuilder: (context, index) => resultBox(
                          item: data_type2[index],
                        )),
                ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) => resultBox(
                          item: data[index],
                        )),
              ],
            )));
  }
}

class resultBox extends StatefulWidget {
  var item;
  resultBox({super.key, required this.item});

  @override
  State<resultBox> createState() => _resultBoxState();
}

class _resultBoxState extends State<resultBox> {
  var base;
  @override
  void initState() {
    super.initState();
    base = widget.item;
    if (base["iduProtocolTypeEnum"] == null) {
      base["iduProtocolTypeEnum"] = "UN_KNOW";
    }
    setState(() {
      base;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 182.h,
      margin: EdgeInsets.fromLTRB(32.w, 0, 32.w, 0),
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Color.fromRGBO(223, 223, 223, 1),
              width: 0.5,
            ),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 18.w, 0),
            child: Image.asset(
              base["iduProtocolTypeEnum"] == "UN_KNOW"
                  ? 'public/images/protocoldetection/undifind.jpg'
                  : 'public/images/V8/${base["indoortype"] == null ? "IduType_1" : base["indoortype"]}.png',
              width: 124.w,
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                // 图片加载失败时显示默认图片
                return Image.asset(
                  'public/images/protocoldetection/undifind.jpg',
                  width: 124.w,
                );
              },
            ),
          ),
          Expanded(
              child: SizedBox(
            height: 182.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        if (base["address"] != null)
                          Text(
                            "${base["address"]}#",
                            style: selectText(
                                fontcolor: base["iduProtocolTypeEnum"] !=
                                        "UN_KNOW"
                                    ? Colors.black
                                    : const Color.fromRGBO(255, 133, 25, 1)),
                          ),
                        if (base["onOff"] != null)
                          Text(
                            base["onOff"] == "ON"
                                ? "·${tr("running")}"
                                : "·${tr("close")}",
                            style: selectText(
                                fontcolor: base["onOff"] == "ON"
                                    ? const Color.fromRGBO(6, 184, 0, 1)
                                    : const Color.fromRGBO(153, 153, 153, 1)),
                          ),
                      ],
                    ),
                    if (base["iduProtocolTypeEnum"] != "UN_KNOW")
                      Text(base["iduProtocolTypeEnum"]).tr(),
                  ],
                ),
                SizedBox(
                  height: 33,
                  child: base["onOff"] == "ON" && base["protocol"] != null
                      ? Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                              child: runningModelImage(base['mode']),
                            ),
                            if (base["mode"] != null)
                              Text('${base['mode']}', style: labelStyle()).tr(),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: Text('|'),
                            ),
                            if (base["temp"] != null)
                              Text(
                                  tr('tempShow',
                                      namedArgs: {"val": "${base['temp']}"}),
                                  style: labelStyle())
                          ],
                        )
                      : Container(),
                )
              ],
            ),
          )),
          if (base["protocol"] != null)
            SizedBox(
              width: 80.w,
              height: 182.h,
              child: Center(
                child: Text(
                  base["protocol"] ?? "",
                  style: normalTextBlack(fSize: 16, fw: FontWeight.w600),
                ),
              ),
            )
        ],
      ),
    );
  }
}
