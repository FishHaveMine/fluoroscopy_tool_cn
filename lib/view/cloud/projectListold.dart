import 'dart:convert';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/snInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../compent/projectinfo.dart';
import '../../style/index.dart';

import 'package:get/get.dart';

import 'projectCreate/oldProject/step1.dart';
import 'projectManage/projectDetail.dart';
import 'publicFunction.dart';

class projectList extends StatefulWidget {
  const projectList({super.key});

  @override
  State<projectList> createState() => _projectListState();
}

class _projectListState extends State<projectList> {
  bool ishistory = true;
  bool inputfocus = false;
  String search = "";
  List history = [];

  List historyAtlast = [];
  List normaldata = [];
  static const platform =
      MethodChannel('samples.flutter.dev/getProjectHandler');
  CustomPopupMenuController _controller = CustomPopupMenuController();

  final cloudProjectController _selectController =
      Get.put(cloudProjectController());
  List<String> menuItems = [
    'createrproject',
    // '创建常规项目',
  ];
  int pageindex = 1;
  // 加载更多的标志
  bool isLoading = true;
  // 控制器用于监听滚动事件
  ScrollController _scrollController = ScrollController();

  searchProject(val) {
    setState(() {
      pageindex = 1;
      history = [];
      ishistory = val;
      isLoading = true;
    });
    searchSN();
  }

  final GlobalKey<snInputState> _key = GlobalKey<snInputState>();
  getnormal() async {
    try {
      _key.currentState?.fun();
    } catch (e) {}

    try {
      var send = {"history": false, "key": search, "pageIndex": 1};
      var getSearchHistories =
          await platform.invokeMethod('listProjectsWithDevices', send);
      var data = jsonDecode(getSearchHistories);
      if (data["data"]["response"] != null) {
        normaldata.addAll(data["data"]["response"]);
        setState(() {
          normaldata;
        });
      }
    } catch (e) {}
  }

  searchSN() async {
    try {
      _key.currentState?.fun();
    } catch (e) {}

    try {
      var send = {"history": false, "key": search, "pageIndex": 1};

      var getSearchHistories =
          await platform.invokeMethod('listProjectsWithDevices', send);
      var data = jsonDecode(getSearchHistories);

      if (data["data"]["response"] != null) {
        if (data["data"]["response"].isEmpty) {
          EasyLoading.showError(tr("clound.searchEmpty"));
        }
        history.addAll(data["data"]["response"]);
        setState(() {
          history;
          isLoading = false;
        });
        // EasyLoading.dismiss();
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // EasyLoading.dismiss();
    }
  }

  getSearchHistories() async {
    // EasyLoading.show(status: 'loading...');
    try {
      _key.currentState?.fun();
    } catch (e) {}
    try {
      var send = {"history": true, "key": "", "pageIndex": 1};

      var getSearchHistories =
          await platform.invokeMethod('listProjectsWithDevices', send);
      var data = jsonDecode(getSearchHistories);

      if (data["data"]["response"] != null) {
        historyAtlast.addAll(data["data"]["response"]);
        setState(() {
          historyAtlast;
          isLoading = false;
        });
        // EasyLoading.dismiss();
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    super.initState();
    getnormal();
    getSearchHistories();
    // 添加滚动监听器
    // _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // 移除滚动监听器
    _scrollController.dispose();
    super.dispose();
  }

  // 滚动监听器
  void _scrollListener() {
    // 如果滚动到底部并且不在加载状态中，则加载更多数据
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      // setState(() {
      //   isLoading = true;
      // });
      pageindex++;
      // 模拟异步加载数据
      getSearchHistories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 24.h, 0, 0.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Positioned(
                            child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          padding: const EdgeInsets.all(0),
                          height: 44,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(42),
                              color: Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomPopupMenu(
                                horizontalMargin: 10.0,
                                verticalMargin: 0.0,
                                arrowColor: Colors.white,
                                menuBuilder: () => ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(
                                    color: Colors.white,
                                    child: IntrinsicWidth(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: menuItems
                                            .map(
                                              (item) => GestureDetector(
                                                behavior:
                                                    HitTestBehavior.translucent,
                                                onTap: () async {
                                                  _controller.hideMenu();
                                                  EasyLoading.showInfo(
                                                      tr("codingtip.Text"));
                                                  return;
                                                  if (item ==
                                                      "createrproject") {
                                                    Get.to(() =>
                                                        oldProjectCreateStep1());
                                                  }
                                                },
                                                child: Container(
                                                  height: 40,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Container(
                                                          // margin:
                                                          //     const EdgeInsets.only(left: 10),
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 10),
                                                          child: Text(
                                                            tr(item),
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ),
                                pressType: PressType.singleClick,
                                controller: _controller,
                                child: const Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Icon(
                                      Icons.add,
                                      color: Color.fromRGBO(13, 13, 13, 0.5),
                                    )),
                              ),
                              Container(
                                width: 1,
                                height: 48.h,
                                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                color: const Color.fromRGBO(223, 223, 223, 1),
                              ),
                              Expanded(
                                child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: snInput(
                                      key: _key,
                                      hintText: tr("searchhintText"),
                                      isSamll: true,
                                      lengthLimit: false,
                                      onfocus: () {
                                        setState(() {
                                          inputfocus = true;
                                        });
                                      },
                                      valBack: (back) {
                                        if (back == "") {
                                          try {
                                            _key.currentState?.fun();
                                          } catch (e) {}
                                          setState(() {
                                            inputfocus = false;
                                            pageindex = 1;
                                            ishistory = true;
                                            history = [];
                                          });
                                        }
                                        setState(() {
                                          search = back;
                                        });
                                      },
                                    )),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  searchProject(false);
                                },
                                child: Container(
                                  width: 75,
                                  height: 36,
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(49),
                                      color:
                                          const Color.fromRGBO(25, 98, 255, 1)),
                                  child: Center(
                                    child: const Text(
                                      'search',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ).tr(),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                      ],
                    )
                  ],
                )),
          ),
          if (inputfocus && ishistory)
            Container(
              width: 720.w,
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: const Text(
                "searchtip.Text",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ).tr(),
            ),
          Expanded(
              key: ValueKey("inputfocus_$inputfocus"),
              child: isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'public/images/waterPump/loading.gif',
                            width: 200,
                          ),
                          Text(
                            tr("systemCapabilityAnalysisPage.projectSearch.start.tip3"),
                            style: titleText(),
                          ),
                        ],
                      ),
                    )
                  : !inputfocus
                      ? ListView.builder(
                          itemCount: normaldata.length,
                          controller: _scrollController,
                          itemBuilder: ((context, index) {
                            return InkWell(
                                onTap: () {
                                  _selectController
                                      .setSelectProject(normaldata[index]);
                                  Get.to(() => projectDetail());
                                },
                                child: Container(
                                    width: 720.w - 24.w * 2,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white),
                                    margin:
                                        EdgeInsets.fromLTRB(0.w, 0, 0.w, 16),
                                    child: projectinfo(
                                        onClick: () {
                                          _selectController.setSelectProject(
                                              normaldata[index]);
                                          Get.to(() => projectDetail());
                                        },
                                        search: search,
                                        showing: {}
                                          ..addAll(normaldata[index]["project"])
                                          ..addAll(normaldata[index]["vrf"]))));
                          }))
                      : !ishistory
                          ? ListView.builder(
                              itemCount: history.length,
                              controller: _scrollController,
                              itemBuilder: ((context, index) {
                                return InkWell(
                                    onTap: () {
                                      _selectController
                                          .setSelectProject(history[index]);
                                      Get.to(() => projectDetail());
                                    },
                                    child: Container(
                                        width: 720.w - 24.w * 2,
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white),
                                        margin: EdgeInsets.fromLTRB(
                                            0.w, 0, 0.w, 16),
                                        child: projectinfo(
                                            onClick: () {
                                              _selectController
                                                  .setSelectProject(
                                                      history[index]);
                                              Get.to(() => projectDetail());
                                            },
                                            search: search,
                                            showing: {}
                                              ..addAll(
                                                  history[index]["project"])
                                              ..addAll(
                                                  history[index]["vrf"]))));
                              }))
                          : ListView.builder(
                              itemCount: historyAtlast.length,
                              controller: _scrollController,
                              itemBuilder: ((context, index) {
                                return InkWell(
                                    onTap: () {
                                      _selectController.setSelectProject(
                                          historyAtlast[index]);
                                      Get.to(() => projectDetail());
                                    },
                                    child: Container(
                                        width: 720.w - 24.w * 2,
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white),
                                        margin: EdgeInsets.fromLTRB(
                                            0.w, 0, 0.w, 16),
                                        child: projectinfo(
                                            onClick: () {
                                              _selectController
                                                  .setSelectProject(
                                                      historyAtlast[index]);
                                              Get.to(() => projectDetail());
                                            },
                                            search: search,
                                            showing: {}
                                              ..addAll(historyAtlast[index]
                                                  ["project"])
                                              ..addAll(historyAtlast[index]
                                                  ["vrf"]))));
                              }))
              // : Center(
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         Padding(
              //           padding: EdgeInsets.fromLTRB(0, 60.h, 0, 0),
              //           child: Image.asset(
              //             'public/images/cloud/searchEmpty.png',
              //             width: 200,
              //           ),
              //         ),
              //         Text(
              //           tr("clound.searchEmpty"),
              //           style: titleText(),
              //         ),
              //       ],
              //     ),
              //   )
              )
        ],
      ),
    );
  }
}
