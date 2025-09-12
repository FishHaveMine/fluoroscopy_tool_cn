import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/store/globalData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'deviceList.dart';
import 'projectList.dart';

class cloudSwitch extends StatefulWidget {
  const cloudSwitch({super.key});

  @override
  State<cloudSwitch> createState() => _cloudSwitchState();
}

class _cloudSwitchState extends State<cloudSwitch>
    with SingleTickerProviderStateMixin {
  int activeIndex = 0;
  void _handelTabSelection(val) {
    setState(() {
      activeIndex = val;
    });
  }

  bool isnetconnecd = false;
  Future<bool> _checkNet() async {
    try {
      final response = await Dio().get('https://${apiHost}/');
      isnetconnecd = response.statusCode == 200;
      setState(() {
        isnetconnecd;
      });
      if (!isnetconnecd) {
        EasyLoading.showError(tr("netword.empty"));
      }

      return isnetconnecd;
    } catch (e) {
      EasyLoading.showError(tr("netword.empty"));
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _checkNet();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        width: 720.w,
        height: 1280.h,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('public/images/cloud/bg.png'),
                fit: BoxFit.cover)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 66.h, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  tapitem(
                    isactive: activeIndex == 0,
                    tapName: tr("clound.project"),
                    onTap: () {
                      setState(() {
                        activeIndex = 0;
                      });
                    },
                  ),
                  tapitem(
                    isactive: activeIndex == 1,
                    tapName: tr("clound.device"),
                    onTap: () {
                      setState(() {
                        activeIndex = 1;
                      });
                    },
                  )
                ],
              ),
            ),
            Expanded(
                child:
                    activeIndex == 0 ? const projectList() : const deviceList())
          ],
        ),
      ),
    );
  }
}

class tapitem extends StatelessWidget {
  bool isactive;
  String tapName;
  Function onTap;
  tapitem(
      {super.key,
      required this.isactive,
      required this.tapName,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(
            color: isactive
                ? const Color.fromRGBO(255, 255, 255, 1)
                : Colors.transparent,
            width: 4.h,
          ),
        )),
        child: Text(
          tapName,
          style: TextStyle(
            fontSize: isactive ? 32.w : 28.w,
            color: isactive
                ? const Color.fromRGBO(255, 255, 255, 1)
                : const Color.fromRGBO(255, 255, 255, 0.5),
          ),
        ),
      ),
    );
  }
}
