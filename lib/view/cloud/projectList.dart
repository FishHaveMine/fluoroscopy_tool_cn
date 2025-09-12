import 'dart:convert';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/projectinfo_expend.dart';
import 'package:fluoroscopy_tool/compent/snInput.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/view/userinfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List nearestProjectdata = [];
  static const platform =
      MethodChannel('samples.flutter.dev/getProjectHandler');
  CustomPopupMenuController _controller = CustomPopupMenuController();
  final userinfoController _promissioncontroller = Get.find();
  final cloudProjectController _selectController =
      Get.put(cloudProjectController());
  List<String> menuItems = [
    'createProject',
    // '创建常规项目',
  ];
  int pageindex = 1;
  int pagenormalindex = 1;
  // 加载更多的标志
  bool isLoading = true;
  // 控制器用于监听滚动事件
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollnormalController = ScrollController();

  bool showMore = false;
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
  _echangeData(e) {
    return {
      "project": {
        "id": e["projectId"].runtimeType == String ? e["projectId"] : "--",
        "name":
            e["projectName"].runtimeType == String ? e["projectName"] : "--",
        "code":
            e["projectCode"].runtimeType == String ? e["projectCode"] : "--",
        "systemCount": e["systemNum"].runtimeType == int ? e["systemNum"] : 0,
        "indoorCount": e["indoorNum"].runtimeType == int ? e["indoorNum"] : 0,
        "outdoorCount":
            e["outdoorNum"].runtimeType == int ? e["outdoorNum"] : 0,
        "address": e["location"].runtimeType == String ? e["location"] : "--",
        "projectType":
            e["projectType"] != null ? e["projectType"].toString() : ""
      },
      "vrf": {},
      "alldata": e
    };
  }

  getnormal() async {
    try {
      _key.currentState?.fun();
    } catch (e) {}

    try {
      var send = {
        "history": false,
        "key": search,
        "pageIndex": pagenormalindex
      };
      var getSearchHistories =
          await platform.invokeMethod('getPageProject', send);
      var data = jsonDecode(getSearchHistories);

      print("getnormal: $data");
      if (data["errorCode"] != null && data["errorCode"].toString() == "1001") {
        //登录失效
        tologout();
      }
      if (data["data"] != null) {
        normaldata.addAll(data["data"].map((e) => _echangeData(e)).toList());
        setState(() {
          normaldata;
          isLoading = false;
        });
      }
    } catch (e) {}
  }

  nearestProject() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var send = {
        "latitude": prefs.getString("latitude"),
        "longitude": prefs.getString("longitude"),
        "pageSize": 1,
      };
      print(send);
      var getSearchHistories =
          await platform.invokeMethod('nearestProject', send);
      var data = jsonDecode(getSearchHistories);
      if (data["errorCode"] != null && data["errorCode"].toString() == "1001") {
        //登录失效
        tologout();
      }
      if (data["data"] != null) {
        print("--------- 找到附近的项目 ----------  ${data["data"]}");

        for (var element in data["data"]) {
          var send = {
            "history": false,
            "key": element["projectCode"],
            "pageIndex": 1
          };
          nearestProjectdata.add(element["projectCode"]);
          print("---------查询项目 ---------- ${send}");
          var getSearchHistories =
              await platform.invokeMethod('getPageProject', send);
          var data = jsonDecode(getSearchHistories);
          if (data["data"] != null) {
            print("---------查询项目返回---------- ${data["data"]}");
            normaldata
                .addAll(data["data"].map((e) => _echangeData(e)).toList());
          }
        }
        setState(() {
          nearestProjectdata;
        });

        // EasyLoading.dismiss();
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      // EasyLoading.dismiss();
    }
  }

  searchSN() async {
    try {
      _key.currentState?.fun();
    } catch (e) {}

    try {
      var send = {"history": false, "key": search, "pageIndex": pageindex};

      var getSearchHistories =
          await platform.invokeMethod('getPageProject', send);
      var data = jsonDecode(getSearchHistories);
      if (data["errorCode"] != null && data["errorCode"].toString() == "1001") {
        //登录失效
        tologout();
      }
      if (data["data"] != null) {
        if (data["data"].isEmpty && history.isNotEmpty) {
          // EasyLoading.showError(tr("clound.searchEmpty"));
        }

        history.addAll(data["data"].map((e) => _echangeData(e)).toList());
        setState(() {
          history;
          isLoading = false;
          showMore = search != "";
        });
        // EasyLoading.dismiss();
      }
    } catch (e) {
      print(e);
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
      // var send = {"history": true, "key": "", "pageIndex": pageindex};

      var getSearchHistories =
          await platform.invokeMethod('getSearchHistories');
      var data = jsonDecode(getSearchHistories);
      print("getSearchHistories:   ${data["data"]}  ${data["data"] != null}");
      if (data["data"] != null) {
        // historyAtlast = [];
        // historyAtlast.addAll(data["data"]["response"]);
        List limitedList =
            data["data"].length > 5 ? data["data"].sublist(0, 5) : data["data"];
        print("getSearchHistories:   ${limitedList}");
        for (var element in limitedList) {
          var send = {
            "history": false,
            "key": element,
            "pageIndex": pagenormalindex
          };
          var vakue = await platform.invokeMethod('getPageProject', send);
          _addhistory(vakue);
          // var getSearchHistories =
          //     await platform.invokeMethod('getPageProject', send);
          // var data = jsonDecode(getSearchHistories);
          // if (data["data"][0] != null) {
          //   historyAtlast.add(_echangeData(data["data"][0]));
          // }
        }

        // EasyLoading.dismiss();
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      // EasyLoading.dismiss();
    }
  }

  _addhistory(value) {
    if (value == null) {
      return;
    }
    try {
      var data = jsonDecode(value);
      print(data);
      if (data["data"] != null && data["data"][0] != null) {
        historyAtlast.add(_echangeData(data["data"][0]));
      }
      ;
      setState(() {
        historyAtlast;
        isLoading = false;
      });
    } catch (e) {}
  }

  initFirst() async {
    await nearestProject();
    await getnormal();
  }

  @override
  void initState() {
    super.initState();
    initFirst();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getSearchHistories();
    });

    // 添加滚动监听器
    _scrollController.addListener(_scrollListener);
    _scrollnormalController.addListener(_scrollnormalListener);
  }

  @override
  void dispose() {
    // 移除滚动监听器
    _scrollController.dispose();
    _scrollnormalController.dispose();
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

      // 模拟异步加载数据
      if (search != "") {
        pageindex++;
        searchSN();
      }
    }
  }

  // 滚动监听器
  void _scrollnormalListener() {
    // 如果滚动到底部并且不在加载状态中，则加载更多数据
    if (_scrollnormalController.position.pixels ==
            _scrollnormalController.position.maxScrollExtent &&
        !isLoading) {
      pagenormalindex++;
      getnormal();
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
                                                  // EasyLoading.showInfo(
                                                  //     tr("codingtip.Text"));
                                                  // return;
                                                  if (item == "createProject") {
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
                                          showMore = search != "";
                                        });
                                      },
                                    )),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isLoading = true;
                                    inputfocus = true;
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
                          controller: _scrollnormalController,
                          itemBuilder: ((context, index) {
                            return InkWell(
                                onTap: () {
                                  if (_promissioncontroller
                                      .checkCloundPromission("ProjectView")) {
                                    _selectController
                                        .setSelectProject(normaldata[index]);
                                    Get.to(() => projectDetail());
                                  }
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                        width: 720.w - 24.w * 2,
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white),
                                        margin: EdgeInsets.fromLTRB(
                                            0.w, 0, 0.w, 16),
                                        child: projectinfo_expend(
                                            showMore: showMore,
                                            onClick: () {
                                              if (_promissioncontroller
                                                  .checkCloundPromission(
                                                      "ProjectView")) {
                                                _selectController
                                                    .setSelectProject(
                                                        normaldata[index]);
                                                Get.to(() => projectDetail());
                                              }
                                            },
                                            search: search,
                                            showing: {}
                                              ..addAll(
                                                  normaldata[index]["project"])
                                              ..addAll({
                                                "alldata": normaldata[index]
                                                    ["alldata"]
                                              }))),
                                    if (nearestProjectdata.contains(
                                        normaldata[index]["alldata"]
                                            ["projectCode"]))
                                      Positioned(
                                          right: 0,
                                          top: 16,
                                          child: Container(
                                              // padding: const EdgeInsets.all(8),
                                              // decoration: const BoxDecoration(
                                              //   color: Color(0xFF33D053),
                                              //   borderRadius: BorderRadius.only(
                                              //     topLeft: Radius.circular(100),
                                              //     bottomLeft:
                                              //         Radius.circular(100),
                                              //     topRight: Radius.circular(0),
                                              //     bottomRight: Radius.circular(0),
                                              //   ),
                                              // ),
                                              // child: const Text(
                                              //   "nearproject",
                                              //   style: TextStyle(
                                              //       color: Colors.white),
                                              // ).tr(),
                                              ))
                                  ],
                                ));
                          }))
                      : !ishistory
                          ? ListView.builder(
                              itemCount: history.length,
                              controller: _scrollController,
                              itemBuilder: ((context, index) {
                                return InkWell(
                                    onTap: () {
                                      if (_promissioncontroller
                                          .checkCloundPromission(
                                              "ProjectView")) {
                                        _selectController
                                            .setSelectProject(history[index]);
                                        Get.to(() => projectDetail());
                                      }
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
                                        child: projectinfo_expend(
                                            showMore: showMore,
                                            onClick: () {
                                              if (_promissioncontroller
                                                  .checkCloundPromission(
                                                      "ProjectView")) {
                                                _selectController
                                                    .setSelectProject(
                                                        history[index]);
                                                Get.to(() => projectDetail());
                                              }
                                            },
                                            search: search,
                                            showing: {}
                                              ..addAll(
                                                  history[index]["project"])
                                              ..addAll({
                                                "alldata": history[index]
                                                    ["alldata"]
                                              }))));
                              }))
                          : ListView.builder(
                              key: ValueKey(
                                  "historyAtlast_${historyAtlast.length}"),
                              itemCount: historyAtlast.length,
                              controller: _scrollController,
                              itemBuilder: ((context, index) {
                                return InkWell(
                                    onTap: () {
                                      if (_promissioncontroller
                                          .checkCloundPromission(
                                              "ProjectView")) {
                                        _selectController.setSelectProject(
                                            historyAtlast[index]);
                                        Get.to(() => projectDetail());
                                      }
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
                                        child: projectinfo_expend(
                                            showMore: showMore,
                                            onClick: () {
                                              if (_promissioncontroller
                                                  .checkCloundPromission(
                                                      "ProjectView")) {
                                                _selectController
                                                    .setSelectProject(
                                                        historyAtlast[index]);
                                                Get.to(() => projectDetail());
                                              }
                                            },
                                            search: search,
                                            showing: {}
                                              ..addAll(historyAtlast[index]
                                                  ["project"])
                                              ..addAll({
                                                "alldata": historyAtlast[index]
                                                    ["alldata"]
                                              }))));
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
