import 'dart:async';
import 'dart:convert';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expandable_tree_menu/expandable_tree_menu.dart';
import 'package:fluoroscopy_tool/compent/bottomSelectSheet.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/cloud/projectManage/topology/groupManage.dart';
import 'package:fluoroscopy_tool/view/cloud/publicFunction.dart';
import 'package:fluoroscopy_tool/view/userinfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import 'indoorDetail.dart';

class topologyIndex extends StatefulWidget {
  topologyIndex({super.key});

  @override
  State<topologyIndex> createState() => _topologyIndexState();
}

class _topologyIndexState extends State<topologyIndex> {
  static const platform = MethodChannel('samples.flutter.dev/topology');
  final userinfoController _promissioncontroller = Get.find();
  final cloudProjectController _selectController = Get.find();
  late Timer _timer;
  List device = [];
  int total = 0;
  bool isSelectStatus = false;
  List deviceSelect = [];

  List menuItems = [
    'topology.menu_type1',
    'topology.menu_type2',
  ];

  Map netModelEnumMap = {
    "all": "all",
  };

  List groupIdEnumSelect = [];
  Map groupIdEnumMap = {
    "-1": "all",
  };

  Map idxDescMap = {
    "-1": "all",
  };

  Map vrfNidmMap = {};

  Map statusEnumMap = {
    "-1": "all",
    "0": "离线",
    "5": "在线",
    "1": "运行",
    "2": "故障",
    "3": "关机",
  };

  String updateKey = "";

  int status = -1;
  int deviceAddress = -1;
  int groupId = -2;
  String vrfNid = "-1";
  int idxDesc = -1;
  int pageIndex = 1;

  ScrollController _scrollController = ScrollController();
  final CustomPopupMenuController _controller = CustomPopupMenuController();

  // 根据 id 获取 children 中所有的 id
  List<int> getChildrenIds(dynamic node, int targetId) {
    List<int> result = [];

    // 检查当前节点是否匹配目标 ID
    if (node is Map<String, dynamic> && node["id"] == targetId) {
      // 如果有 children，提取它们的 ID
      if (node["children"] is List) {
        result.addAll(
          node["children"].map<int>((child) => child["id"] as int).toList(),
        );
      }
    }

    // 递归检查 children
    if (node is Map<String, dynamic> && node["children"] is List) {
      for (var child in node["children"]) {
        result.addAll(getChildrenIds(child, child["id"]));
      }
    }

    return result;
  }

  Future<void> _init({showtip = true}) async {
    if (showtip) EasyLoading.show(status: 'loading...');
    // device = [];
    // deviceSelect = [];
    // setState(() {
    //   deviceSelect;
    // });
    try {
      var project = _selectController.selectProject.value["project"];
      // 从顶层节点开始搜索
      List<int> childrenIds = [groupId];
      // for (var node in groupIdEnumSelect) {
      //   childrenIds.addAll(getChildrenIds(node, groupId));
      // }

      var send = {
        "projectCode": project["code"],
        "projectId": project["id"],
        "vrfNid": vrfNid == "-1" || vrfNid == "all" ? "" : vrfNid,
        "status": status,
        "deviceAddress": idxDesc,
        "groupId": childrenIds,
        "pageIndex": pageIndex,
        "pageSize": project['indoorCount']
      };
      print(
          "getTopologyHandler.projectDevices --------------- $send  -------------------------");
      var invokeMethodback = await platform.invokeMethod(
          'getTopologyHandler.projectDevices', send);

      var josndata = jsonDecode(invokeMethodback);
      print(
          "getTopologyHandler.projectDevices --------------- $josndata  -------------------------");
      if (josndata["errorCode"] != null &&
          josndata["errorCode"].toString() == "1001") {
        //登录失效
        tologout();
      }
      total = josndata["totalCount"];
      if (device.isEmpty) {
        device = josndata["data"];
        setState(() {
          device;
          updateKey = DateTime.now().microsecond.toString();
        });

        try {
          if (_timer.isActive) _timer.cancel();
        } catch (e) {}

        _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
          print("---------更新状态 开始-----------");
          _init(showtip: false);
        });
      } else {
        print("---------更新状态 进入-----------");
        if (josndata["data"].isNotEmpty) {
          if (device[0]["statusName"] != josndata["data"][0].toString()) {
            device = josndata["data"];
            setState(() {
              device;
              updateKey = DateTime.now().microsecond.toString();
            });
          }
        }
      }

      EasyLoading.dismiss();
    } catch (e) {
      print("---------更新状态----------- $e");
      EasyLoading.dismiss();
    }
  }

  bool showgroup = false;
  int groupIdselect = -1;
  _nodeSelected(c, n) {
    setState(() {
      groupIdselect = int.parse(n.toString());
    });
  }

  _initgroup() async {
    try {
      var project = _selectController.selectProject.value["project"];
      var invokeMethodback =
          await platform.invokeMethod('getTopologyHandler.treeWithDevice', {
        "projectId": int.parse(project["id"]),
      });
      var josndata = jsonDecode(invokeMethodback);
      if (josndata["errorCode"] != null &&
          josndata["errorCode"].toString() == "1001") {
        //登录失效
        tologout();
      }
      print(josndata);

      groupIdEnumMap = {
        "-2": "全部",
      };
      josndata["data"].insert(0, {"id": -2, "name": "全部", "children": []});
      for (var element in josndata["data"]) {
        groupIdEnumMap[element["id"].toString()] = element["name"];
        print("-" + element["name"]);
        if (element["children"].toString() != "{}") {
          for (var children in element["children"]) {
            groupIdEnumMap[children["id"].toString()] = children["name"];

            print("- -" + children["name"]);
            if (children["children"].toString() != "{}") {
              for (var childrchildren in children["children"]) {
                print("- - -" + childrchildren["name"]);
                groupIdEnumMap[childrchildren["id"].toString()] =
                    childrchildren["name"];
              }
            }
          }
        }
      }

      setState(() {
        groupIdEnumSelect = josndata["data"];
        groupIdEnumMap;
      });
      print(groupIdEnumSelect);
    } catch (e) {}
  }

  _initidxDescMap() async {
    try {
      var project = _selectController.selectProject.value["project"];
      var invokeMethodback = await platform
          .invokeMethod('getTopologyHandler.projectDeviceAddress', {
        "projectId": project["id"],
        "projectCode": project["code"],
      });

      var josndata = jsonDecode(invokeMethodback);
      if (josndata["errorCode"] != null &&
          josndata["errorCode"].toString() == "1001") {
        //登录失效
        tologout();
      }

      for (var element in josndata["data"]) {
        idxDescMap[element["value"].toString()] = element["desc"];
      }
      setState(() {
        idxDescMap;
      });

      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  _initvrfNidmMap() async {
    try {
      var project = _selectController.selectProject.value["project"];
      var invokeMethodback =
          await platform.invokeMethod('getTopologyHandler.listVrfSelect', {
        "projectId": project["id"],
      });

      var josndata = jsonDecode(invokeMethodback);
      if (josndata["errorCode"] != null &&
          josndata["errorCode"].toString() == "1001") {
        //登录失效
        tologout();
      }
      for (var element in josndata["data"]) {
        vrfNidmMap[element["nid"].toString()] = element["name"];
      }
      setState(() {
        vrfNidmMap;
      });
    } catch (e) {}
  }

  _selectDevice(item) async {
    var key = item["nid"];
    if (isSelectStatus) {
      if (deviceSelect.contains(key)) {
        deviceSelect.remove(key);
      } else {
        deviceSelect.add(key);
      }
      setState(() {
        deviceSelect;
      });
    } else {
      await Get.to(() => indoorDetail(
            nid: key,
          ));
    }
  }

  __selectAllDevice() {
    if (deviceSelect.length == device.length) {
      setState(() {
        deviceSelect = [];
      });
    } else {
      deviceSelect = [];
      for (var item in device) {
        deviceSelect.add(item["nid"]);
      }
      setState(() {
        deviceSelect;
      });
    }
  }

  _onOffControl(onoff) async {
    if (!_promissioncontroller
        .checkCloundPromission("IndoorUnitTopo_SingleFullCtl")) {
      return;
    }

    List allnid = [];
    bool isalll = false;
    if (deviceSelect.isEmpty) {
      bool issend = await divConfirmDialog(context,
          confirmTitle: tr("device.controltDialog.confirmTitle"),
          confirmDescriptionWidget: SingleChildScrollView(
            child: SizedBox(
                width: 560.w,
                height: 140,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SafeText(
                          tr("dndoorunittopo_singlefullctl.alltip", namedArgs: {
                        "onoff": onoff == 0
                            ? tr("dndoorunittopo_singlefullctl.onoff0")
                            : tr("dndoorunittopo_singlefullctl.onoff1")
                      })),
                    ],
                  ),
                )),
          ));
      if (issend) {
        allnid = [];
        for (var item in device) {
          allnid.add(item["nid"]);
        }
        isalll = true;
      } else {
        return;
      }
    } else if (deviceSelect.length == 1) {
      bool issend = await divConfirmDialog(context,
          confirmTitle: tr("device.controltDialog.confirmTitle"),
          confirmDescriptionWidget: SingleChildScrollView(
            child: SizedBox(
                width: 560.w,
                height: 140,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SafeText(
                          tr("dndoorunittopo_singlefullctl.tip", namedArgs: {
                        "onoff": onoff == 0
                            ? tr("dndoorunittopo_singlefullctl.onoff0")
                            : tr("dndoorunittopo_singlefullctl.onoff1")
                      })),
                    ],
                  ),
                )),
          ));
      if (issend) {
        isalll = false;
      } else {
        return;
      }
    }
    EasyLoading.show(status: 'loading...');
    try {
      var project = _selectController.selectProject.value["project"];
      var invokeMethodback =
          await platform.invokeMethod('getTopologyHandler.onOffControl', {
        "projectId": project["id"],
        "nidList": isalll ? allnid : deviceSelect,
        "onOffValue": onoff
      });
      var josndata = jsonDecode(invokeMethodback);

      EasyLoading.dismiss();
      if (josndata["success"]) {
        EasyLoading.showSuccess(tr("topology.onOffControl_success"));
        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            device = [];
            deviceSelect = [];
            pageIndex = 1;
          });
          _init();
        });
      } else {
        EasyLoading.showError(josndata["errorMsg"]);
      }
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  _inop() async {
    _initgroup();
    _initidxDescMap();
    _initvrfNidmMap();
  }

  _associatedExisted() async {
    if (deviceSelect.isEmpty) {
      return;
    }

    var back = await Get.to(() => groupManage(
          selecting: true,
        ));
    if (back != null && back['select'] != null) {
      _addAssociatedExisted(back['select']['id']);
    }
  }

  _addAssociatedExisted(groupId) async {
    List filteredItems =
        device.where((item) => deviceSelect.contains(item['nid'])).toList();
    if (filteredItems.length == deviceSelect.length) {
      List _deviceList = [];
      for (var element in filteredItems) {
        _deviceList.add({
          "deviceName": element["name"],
          "deviceSn": element["sn"],
          "nid": element["nid"],
        });
      }
      EasyLoading.show(status: 'loading...');
      try {
        var project = _selectController.selectProject.value["project"];
        var invokeMethodback = await platform
            .invokeMethod('getTopologyHandler.associatedExisted', {
          "projectId": project["id"],
          "deviceList": _deviceList,
          "groupId": int.parse(groupId.toString())
        });
        var josndata = jsonDecode(invokeMethodback);

        EasyLoading.dismiss();
        if (josndata["success"]) {
          EasyLoading.showSuccess(tr("topology.onOffControl_success"));
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              isSelectStatus = false;
              device = [];
              deviceSelect = [];
              pageIndex = 1;
            });
            _init();
          });
        } else {
          EasyLoading.showError(josndata["errorMsg"]);
        }
      } catch (e) {
        EasyLoading.dismiss();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // 添加滚动监听器
    // _scrollController.addListener(_scrollListener);
    if (_promissioncontroller
        .checkCloundPromission("IndoorUnitTopo_StatusView")) {
      _inop();
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        _init();
      });
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pop(context);
      });
    }
  }

  @override
  void dispose() {
    try {
      _timer.cancel();
    } catch (e) {}
    // 移除滚动监听器
    // _scrollController.dispose();
    super.dispose();
  }

  // 滚动监听器
  void _scrollListener() {
    // 如果滚动到底部并且不在加载状态中，则加载更多数据
    // if (_scrollController.position.pixels ==
    //     _scrollController.position.maxScrollExtent) {
    //   pageIndex++;
    //   _init();
    // }
  }

  Future<void> _refresh() async {
    setState(() {
      isSelectStatus = false;
      device = [];
      deviceSelect = [];
      pageIndex = 1;
    });
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: isSelectStatus
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      deviceSelect = [];
                      isSelectStatus = false;
                    });
                  },
                  child: const Text("topology.isSelectStatus_btn1").tr())
              : IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.chevron_left,
                      color: Colors.black, size: 36)),
          title: isSelectStatus
              ? const Text(
                  'topology.select_title',
                  style: TextStyle(color: Colors.black),
                ).tr(namedArgs: {"val": "${deviceSelect.length}"})
              : const Text(
                  'topology.title',
                  style: TextStyle(color: Colors.black),
                ).tr(),
          centerTitle: true,
          actions: [
            isSelectStatus
                ? TextButton(
                    onPressed: () {
                      __selectAllDevice();
                    },
                    child: Text(tr("topology.isSelectStatus_btn2")))
                : Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: CustomPopupMenu(
                      horizontalMargin: 10.0,
                      verticalMargin: 0.0,
                      arrowColor: Colors.white,
                      menuBuilder: () => ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          color: Colors.white,
                          child: IntrinsicWidth(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: menuItems
                                  .map(
                                    (item) => GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () async {
                                        if (item == "topology.menu_type1") {
                                          _controller.hideMenu();
                                          setState(() {
                                            deviceSelect = [];
                                            isSelectStatus = true;
                                          });
                                        } else {
                                          _controller.hideMenu();
                                          await Get.to(() => groupManage());
                                          _initgroup();
                                        }
                                      },
                                      child: Container(
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                // margin:
                                                //     const EdgeInsets.only(left: 10),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: Text(
                                                  tr(item),
                                                  style: const TextStyle(
                                                    color: Colors.black,
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
                      child: const Icon(
                        Icons.more_horiz,
                        color: Colors.black,
                      ),
                    ),
                  ),
          ],
        ),
        body: Container(
          width: 720.w,
          height: 1280.h,
          color: const Color.fromRGBO(244, 244, 244, 1),
          padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 1, 0, 12),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 42,
                color: Colors.white,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (groupIdEnumSelect.isNotEmpty) {
                          setState(() {
                            showgroup = true;
                            groupIdselect = groupId;
                          });
                        }
                      },
                      child: Container(
                        width: (720.w - 16 * 2) / 3,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                          alignment: AlignmentDirectional.centerEnd,
                          items: [
                            // for (var item in groupIdEnumMap.keys)
                            //   DropdownMenuItem<String>(
                            //     value: item,
                            //     child: Text(
                            //       groupIdEnumMap[item],
                            //       style: normalText(
                            //         lineheight: 1,
                            //       ),
                            //     ).tr(),
                            //   )
                          ],
                          onChanged: (val) {
                            // setState(() {
                            //   groupId = int.parse(val!);
                            //   device = [];
                            //   deviceSelect = [];
                            //   pageIndex = 1;
                            // });
                            // _init();
                          },
                          isExpanded:
                              true, // Ensure the button takes full width of the container
                          hint: Text(
                            groupIdEnumMap[groupId.toString()] == null
                                ? tr("topology.groupId")
                                : tr(groupIdEnumMap[groupId.toString()]),
                            style: normalText(
                              lineheight: 1,
                            ),
                            overflow: TextOverflow
                                .ellipsis, // Add ellipsis if text overflows
                            softWrap: false, // Prevent line breaks
                          ),
                        )),
                      ),
                    ),
                    Container(
                      width: (720.w - 16 * 2) / 3,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                        alignment: AlignmentDirectional.centerEnd,
                        items: [
                          DropdownMenuItem<String>(
                            value: "all",
                            child: Text(
                              "all",
                              style: normalText(),
                            ).tr(),
                          ),
                          for (var item in vrfNidmMap.keys)
                            DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                vrfNidmMap[item],
                                style: normalText(
                                  lineheight: 1,
                                ),
                              ).tr(),
                            )
                        ],
                        onChanged: (val) {
                          setState(() {
                            vrfNid = val!;
                            device = [];
                            deviceSelect = [];
                            pageIndex = 1;
                          });
                          _init();
                        },
                        isExpanded:
                            true, // Ensure the button takes full width of the container
                        hint: Text(
                          vrfNidmMap[vrfNid] == null
                              ? tr("topology.vrfNid")
                              : tr(vrfNidmMap[vrfNid]),
                          style: normalText(
                            lineheight: 1,
                          ),
                          overflow: TextOverflow
                              .ellipsis, // Add ellipsis if text overflows
                          softWrap: false, // Prevent line breaks
                        ),
                      )),
                    ),
                    // Container(
                    //  width: (720.w - 16*2) / 3,
                    //   padding: const EdgeInsets.symmetric(horizontal: 8),
                    //   child: DropdownButtonHideUnderline(
                    //       child: DropdownButton(
                    //     items: [
                    //       for (var item in idxDescMap.keys)
                    //         DropdownMenuItem<String>(
                    //           value: item,
                    //           child: Text(
                    //             idxDescMap[item],
                    //             style: normalText(
                    //               lineheight: 1,
                    //             ),
                    //           ).tr(),
                    //         )
                    //     ],
                    //     onChanged: (val) {
                    //       setState(() {
                    //         idxDesc = int.parse(val!);
                    //       });
                    //       _init();
                    //     },
                    //     isExpanded:
                    //         true, // Ensure the button takes full width of the container
                    //     hint: Text(
                    //       idxDescMap[idxDesc.toString()] == null
                    //           ? tr("topology.idxDesc")
                    //           : tr(idxDescMap[idxDesc.toString()]),
                    //       style: normalText(
                    //         lineheight: 1,
                    //       ),
                    //       overflow: TextOverflow
                    //           .ellipsis, // Add ellipsis if text overflows
                    //       softWrap: false, // Prevent line breaks
                    //     ),
                    //   )),
                    // ),
                    Container(
                      width: (720.w - 16 * 2) / 3,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                        alignment: AlignmentDirectional.centerEnd,
                        items: [
                          for (var item in statusEnumMap.keys)
                            DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                statusEnumMap[item],
                                style: normalText(
                                  lineheight: 1,
                                ),
                              ).tr(),
                            )
                        ],
                        onChanged: (val) {
                          setState(() {
                            status = int.parse(val!);
                            device = [];
                            deviceSelect = [];
                            pageIndex = 1;
                          });
                          _init();
                        },
                        isExpanded:
                            true, // Ensure the button takes full width of the container
                        hint: Text(
                          status == -1
                              ? tr("topology.status")
                              : tr(statusEnumMap[status.toString()]),
                          style: normalText(
                            lineheight: 1,
                          ),
                          overflow: TextOverflow
                              .ellipsis, // Add ellipsis if text overflows
                          softWrap: false, // Prevent line breaks
                        ),
                      )),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: showgroup
                      ? Container(
                          color: Colors.white,
                          key: ValueKey(
                              "groupIdEnumSelect${showgroup}-${groupIdEnumSelect.length}"),
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                          child: SingleChildScrollView(
                            child: ExpandableTree(
                              submenuDecoration: const BoxDecoration(
                                  border: null, color: Colors.white),
                              childrenDecoration: const BoxDecoration(
                                  border: null, color: Colors.white),
                              nodes: [
                                // TreeNode("-1"),
                                for (var item in groupIdEnumSelect)
                                  TreeNode(
                                    item["id"],
                                    subNodes: item["children"].toString() !=
                                            "{}"
                                        ? [
                                            for (var item in item["children"])
                                              TreeNode(item["id"],
                                                  subNodes: item["children"]
                                                              .toString() !=
                                                          "{}"
                                                      ? [
                                                          for (var item in item[
                                                              "children"])
                                                            TreeNode(item["id"])
                                                        ]
                                                      : []),
                                          ]
                                        : [],
                                  ),
                              ],
                              nodeBuilder: (context, nodeValue) => Container(
                                padding: const EdgeInsets.all(8),
                                color: nodeValue == groupIdselect
                                    ? const Color.fromRGBO(0, 128, 255, 0.4)
                                    : Colors.white,
                                child: Text(
                                  groupIdEnumMap[nodeValue.toString()],
                                  style: normalText(
                                      fontcolor: nodeValue == groupIdselect
                                          ? const Color.fromRGBO(0, 128, 255, 1)
                                          : Colors.black),
                                ),
                              ),
                              onSelect: (node) => _nodeSelected(context, node),
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _refresh,
                          child: Column(children: [
                            Expanded(
                                child: ListView.builder(
                                    physics:
                                        AlwaysScrollableScrollPhysics(), // 强制支持滚动
                                    itemCount: device.length,
                                    // controller: _scrollController,
                                    itemBuilder: ((context, index) => Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0),
                                          color: Colors.white,
                                          child: InkWell(
                                            onTap: () {
                                              _selectDevice(device[index]);
                                            },
                                            onLongPress: () {
                                              setState(() {
                                                deviceSelect = [];
                                                isSelectStatus = true;
                                              });
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 8, 0, 8),
                                              decoration: const BoxDecoration(
                                                  border: Border(
                                                bottom: BorderSide(
                                                  color: Color.fromRGBO(
                                                      244, 244, 244, 1),
                                                  width: 10,
                                                ),
                                              )),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    isSelectStatus
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    0,
                                                                    12,
                                                                    8,
                                                                    0),
                                                            child:
                                                                RoundCheckBox(
                                                              isChecked: deviceSelect
                                                                  .contains(device[
                                                                          index]
                                                                      ["nid"]),
                                                              onTap: null,
                                                              size: 16,
                                                              checkedWidget:
                                                                  const Icon(
                                                                Icons.check,
                                                                color: Colors
                                                                    .white,
                                                                size: 14,
                                                              ),
                                                              disabledColor: deviceSelect
                                                                      .contains(
                                                                          device[index]
                                                                              [
                                                                              "nid"])
                                                                  ? Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .secondary
                                                                  : Colors
                                                                      .white,
                                                              checkedColor: deviceSelect
                                                                      .contains(
                                                                          device[index]
                                                                              [
                                                                              "nid"])
                                                                  ? Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .secondary
                                                                  : Colors
                                                                      .white,
                                                              border:
                                                                  Border.all(
                                                                      // width: 1,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .secondary),
                                                            ),
                                                          )
                                                        : Container(),
                                                    Expanded(
                                                        child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        if (device[index]
                                                                    ["name"] !=
                                                                null &&
                                                            device[index]
                                                                        ["name"]
                                                                    .toString() !=
                                                                "{}")
                                                          Text(
                                                            device[index]
                                                                    ["name"] ??
                                                                "--",
                                                            style:
                                                                normalTextBlack(
                                                                    fSize: 18,
                                                                    fw: FontWeight
                                                                        .w600),
                                                          ),
                                                        if (device[index]
                                                                    ["sn"] !=
                                                                null &&
                                                            device[index]["sn"]
                                                                    .toString() !=
                                                                "{}")
                                                          SafeText(
                                                            device[index]
                                                                    ["sn"] ??
                                                                "--",
                                                            needTr: false,
                                                            style:
                                                                normalTextBlack(),
                                                          ),
                                                        Row(
                                                          children: [
                                                            SafeText(
                                                              device[index][
                                                                          "runMode"]
                                                                      [
                                                                      "name"] ??
                                                                  "--",
                                                              style:
                                                                  normalText(),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      8),
                                                              child: SafeText(
                                                                "|",
                                                                style:
                                                                    normalText(),
                                                              ),
                                                            ),
                                                            if (device[index][
                                                                        "tempSetting"] !=
                                                                    null &&
                                                                device[index][
                                                                            "tempSetting"]
                                                                        .toString() !=
                                                                    "{}")
                                                              SafeText(
                                                                tr("topology.show_tempSetting",
                                                                    namedArgs: {
                                                                      "val":
                                                                          "${device[index]["tempSetting"]["value"] ?? "--"}"
                                                                    }),
                                                                style:
                                                                    normalText(),
                                                              )
                                                          ],
                                                        ),
                                                        if (device[index][
                                                                    "idxDesc"] !=
                                                                null &&
                                                            device[index][
                                                                        "idxDesc"]
                                                                    .toString() !=
                                                                "{}")
                                                          SafeText(
                                                            tr("topology.show_idxDesc",
                                                                namedArgs: {
                                                                  "val":
                                                                      "${device[index]["idxDesc"] ?? "--"}"
                                                                }),
                                                            style: normalText(),
                                                          ),
                                                      ],
                                                    )),
                                                    Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  0, 12, 0, 30),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3),
                                                            decoration:
                                                                BoxDecoration(
                                                              border:
                                                                  Border.all(
                                                                color: device[index]
                                                                            [
                                                                            "statusName"] ==
                                                                        "运行"
                                                                    ? const Color(
                                                                        0xFF20AF42)
                                                                    : const Color
                                                                            .fromRGBO(
                                                                        249,
                                                                        83,
                                                                        78,
                                                                        1), // 使用十六进制颜色码定义颜色
                                                                width:
                                                                    0.5, // 边框宽度，单位为逻辑像素
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          2), // 圆角半径，单位为逻辑像素
                                                            ),
                                                            child: Text(
                                                              device[index][
                                                                  "statusName"],
                                                              style: normalText(
                                                                  fontcolor: device[index]
                                                                              [
                                                                              "statusName"] ==
                                                                          "运行"
                                                                      ? const Color(
                                                                          0xFF20AF42)
                                                                      : const Color
                                                                              .fromRGBO(
                                                                          249,
                                                                          83,
                                                                          78,
                                                                          1),
                                                                  lineheight:
                                                                      1),
                                                            ),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          key: ValueKey(
                                                              "$index-$updateKey"),
                                                          onTap: () {
                                                            deviceSelect = [
                                                              device[index]
                                                                  ["nid"]
                                                            ];
                                                            _onOffControl(device[
                                                                            index]
                                                                        [
                                                                        "statusName"] ==
                                                                    "运行"
                                                                ? 0
                                                                : 1);
                                                          },
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          48),
                                                              color: device[index]
                                                                          [
                                                                          "statusName"] ==
                                                                      "运行"
                                                                  ? const Color(
                                                                      0xFF0080FF)
                                                                  : const Color
                                                                          .fromRGBO(
                                                                      169,
                                                                      169,
                                                                      169,
                                                                      1),
                                                            ),
                                                            child: const Icon(
                                                              Icons
                                                                  .power_settings_new,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ))))
                          ]))),
              Container(
                height: 57,
                color: Colors.white,
                margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: showgroup
                      ? [
                          SizedBox(
                            width: 300.w,
                            child: normalButton(
                              label: tr('cancel'),
                              onClick: () async {
                                setState(() {
                                  showgroup = false;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 300.w,
                            child: submitButton(
                              label: tr('determine'),
                              onClick: () async {
                                setState(() {
                                  groupId = groupIdselect;
                                  showgroup = false;

                                  device = [];
                                  deviceSelect = [];
                                  pageIndex = 1;
                                });
                                _init();
                              },
                              isActive: true,
                            ),
                          ),
                        ]
                      : [
                          SizedBox(
                            width: (720.w - 64.w) * 0.2,
                            child: normalButton(
                              label: tr('topology.bottom_btn1'),
                              onClick: () async {
                                _onOffControl(1);
                              },
                            ),
                          ),
                          SizedBox(
                            width: (720.w - 64.w) * 0.2,
                            child: normalButton(
                              label: tr('topology.bottom_btn2'),
                              onClick: () async {
                                _onOffControl(0);
                              },
                            ),
                          ),
                          SizedBox(
                            width: (720.w - 64.w) * 0.5,
                            child: normalButton(
                              fillTextColor: deviceSelect.isNotEmpty
                                  ? const Color(0xFF0080FF)
                                  : const Color.fromARGB(255, 155, 155, 155),
                              label: tr('topology.bottom_btn3'),
                              onClick: () async {
                                if (deviceSelect.isNotEmpty) {
                                  _associatedExisted();
                                }
                              },
                            ),
                          ),
                        ],
                ),
              )
            ],
          ),
        ));
  }
}
