/*
 * @Author: FishHaveMine 751174479@qq.com
 * @Date: 2024-06-08 14:53:16
 * @LastEditors: FishHaveMine 751174479@qq.com
 * @LastEditTime: 2024-06-08 14:54:34
 * @FilePath: /fluoroscopy_tool/lib/compent/tapContariner.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'dart:ui';

import 'package:fluoroscopy_tool/style/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class tapContariner extends StatefulWidget {
  List tap;
  int activeIndex;
  List<Widget> child;
  Function? activechange;
  tapContariner(
      {super.key,
      this.activechange,
      required this.tap,
      required this.activeIndex,
      required this.child});

  @override
  State<tapContariner> createState() => _tapContarinerState();
}

class _tapContarinerState extends State<tapContariner> {
  late List tap;
  late int activeIndex;
  late List<Widget> childList;
  int showitem = 2;

  @override
  void initState() {
    super.initState();
    setState(() {
      tap = widget.tap;
      activeIndex = widget.activeIndex;
      childList = widget.child;
      showitem = tap.length > 3 ? 3 : tap.length;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            width: 720.w,
            height: 1280.h - 80,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(
                      199, 218, 247, 1), // #0C69FF as an opaque color
                  Colors
                      .white, // rgba(28,162,255,0.00) as a Color with transparency
                ],
              ),
            ),
            padding: EdgeInsets.fromLTRB(0.w, 0, 0.w, 0.h),
            child: Container(
              child: Column(
                children: [
                  Container(
                    width: 720.w,
                    height: 104.h,
                    padding: EdgeInsets.fromLTRB(24.w, 0.h, 24.w, 0),
                    child: Container(
                      child: ListView(
                        scrollDirection: Axis.horizontal, // 设置滚动方向为水平方向
                        children: <Widget>[
                          for (var tapitem in tap)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  activeIndex = tap.indexOf(tapitem);
                                });
                                if (widget.activechange != null) {
                                  widget.activechange!(activeIndex);
                                }
                              },
                              child: SizedBox(
                                  width: (720.w - 24.w * 2) / showitem,
                                  height: 104.h,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                          bottom: 0,
                                          left: 0,
                                          child: Container(
                                            width:
                                                (720.w - 24.w * 2) / showitem,
                                            height: 72.h,
                                            decoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  227, 236, 250, 1),
                                              borderRadius: BorderRadius.only(
                                                topLeft:
                                                    tap.indexOf(tapitem) == 0
                                                        ? const Radius.circular(
                                                            16.0)
                                                        : const Radius.circular(
                                                            0.0),
                                                topRight:
                                                    tap.indexOf(tapitem) ==
                                                            tap.length - 1
                                                        ? const Radius.circular(
                                                            16.0)
                                                        : const Radius.circular(
                                                            0.0),
                                              ),
                                            ),
                                          )),
                                      Positioned(
                                          bottom: 0,
                                          left: 0,
                                          child: Container(
                                            width:
                                                (720.w - 24.w * 2) / showitem,
                                            margin: tap.indexOf(tapitem) ==
                                                    activeIndex
                                                ? EdgeInsets.fromLTRB(
                                                    0, 24.h, 0, 0)
                                                : EdgeInsets.fromLTRB(
                                                    0, 32.h, 0, 0),
                                            height: tap.indexOf(tapitem) ==
                                                    activeIndex
                                                ? 80.h
                                                : 72.h,
                                            decoration: tap.indexOf(tapitem) ==
                                                    activeIndex
                                                ? const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(16.0),
                                                      topRight:
                                                          Radius.circular(16.0),
                                                    ),
                                                    color: Colors.white)
                                                : BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft: tap.indexOf(
                                                                  tapitem) ==
                                                              0
                                                          ? const Radius
                                                              .circular(16.0)
                                                          : const Radius
                                                              .circular(0.0),
                                                      topRight: tap.indexOf(
                                                                  tapitem) ==
                                                              tap.length - 1
                                                          ? const Radius
                                                              .circular(16.0)
                                                          : const Radius
                                                              .circular(0.0),
                                                    ),
                                                    color: const Color.fromRGBO(
                                                        227, 236, 250, 1)),
                                            // 其他内容
                                            child: Center(
                                              child: Text(
                                                tapitem,
                                                textAlign: TextAlign.center,
                                                style: tap.indexOf(tapitem) ==
                                                        activeIndex
                                                    ? selectText()
                                                    : normalTextBlack(
                                                        fSize: 14),
                                              ),
                                            ),
                                          ))
                                    ],
                                  )),
                            )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 100,
                      key: ValueKey("activeIndex_$activeIndex"),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0),
                          ),
                          color: Colors.white),
                      child: childList[activeIndex],
                    ),
                  )
                ],
              ),
            )));
  }
}
