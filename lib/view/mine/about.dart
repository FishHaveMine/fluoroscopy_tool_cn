// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/store/globalData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class about extends StatefulWidget {
  about({super.key});

  @override
  State<about> createState() => _accountState();
}

class _accountState extends State<about> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            'menu_app',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: const [],
        ),
        body: SizedBox(
            width: 720.w,
            height: 1280.h,
            child: Stack(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(32.w, 24.h, 32.w, 24.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('local.version').tr(),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Text(
                          "$externalVersion($internalVersion)${apiHost != "btri-dev.midea.com" && apiHost != "us-test.mideaibp.com" ? "Stable-us" : "Beta-us"}",
                          style: const TextStyle(
                              color: Color.fromRGBO(140, 140, 140, 1)),
                        ).tr(),
                      )
                    ],
                  ),
                ),
              ),
            ])));
  }
}
