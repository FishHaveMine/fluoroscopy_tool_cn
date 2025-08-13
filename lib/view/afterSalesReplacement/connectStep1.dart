import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'connectStep2.dart';
import 'publicFunction.dart';

class connectStep1Page extends StatefulWidget {
  List? connectType;
  String title;
  Widget? nextPage;
  connectStep1Page(
      {super.key, this.connectType, required this.title, this.nextPage = null});
  @override
  State<connectStep1Page> createState() => _connectStep1PageState();
}

class _connectStep1PageState extends State<connectStep1Page> {
  final deviceInfoController _deviceInfoController = Get.find();
  List connectType = [
    'afterSalesReplacement.connectType1',
    'afterSalesReplacement.connectType2',
    'afterSalesReplacement.connectType3',
    'afterSalesReplacement.connectType4',
  ];
  @override
  void initState() {
    super.initState();

    if (_deviceInfoController.isPolling.value) {
      Get.back();
    }
    if (widget.connectType != null) {
      setState(() {
        connectType = widget.connectType!;
        print(connectType);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  final afterSalesReplacementController _selfController =
      Get.put(afterSalesReplacementController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<afterSalesReplacementController>(
        builder: (_) => Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.chevron_left,
                      color: Colors.black, size: 36)),
              title: const Text(
                'afterSalesReplacement.connectStep1',
                style: TextStyle(color: Colors.black),
              ).tr(),
              centerTitle: true,
              actions: const [],
            ),
            body: Padding(
              padding: EdgeInsets.fromLTRB(0.w, 24.w, 0.w, 24.w),
              child: ListView.builder(
                itemCount: connectType.length,
                itemBuilder: ((context, index) => Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromRGBO(223, 223, 223, 1),
                              width: 0.5,
                            ),
                          )),
                      child: ListTile(
                        onTap: () {
                          _selfController.setConnectType(connectType[index]);
                          Get.to(() => connectStep2Page(
                                title: connectType[index],
                                nextPage: widget.nextPage,
                              ));
                        },
                        title: Text(
                            tr('afterSalesReplacement.connectTypeTitle') +
                                tr(connectType[index])),
                        trailing: Icon(Icons.navigate_next),
                      ),
                    )),
              ),
            )));
  }
}
