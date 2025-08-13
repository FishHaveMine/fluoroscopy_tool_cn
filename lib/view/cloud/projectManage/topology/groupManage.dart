import 'dart:convert';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expandable_tree_menu/expandable_tree_menu.dart';
import 'package:fluoroscopy_tool/compent/bottomSelectSheet.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/cloud/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

class groupManage extends StatefulWidget {
  bool selecting = false;
  groupManage({super.key, this.selecting = false});

  @override
  State<groupManage> createState() => _groupManageState();
}

class _groupManageState extends State<groupManage> {
  List menuItems = [
    'groupManage.action1',
    'groupManage.action2',
  ];

  static const platform = MethodChannel('samples.flutter.dev/topology');
  final cloudProjectController _selectController = Get.find();
  final CustomPopupMenuController _controller = CustomPopupMenuController();
  int groupIdselect = -1;
  List groupIdEnumSelect = [];
  Map groupIdEnumMap = {};

  bool inEditStatus = false;
  _initgroup() async {
    EasyLoading.show(status: 'loading...');
    try {
      var project = _selectController.selectProject.value["project"];
      var invokeMethodback =
          await platform.invokeMethod('getTopologyHandler.treeWithDevice', {
        "projectId": int.parse(project["id"]),
      });
      var josndata = jsonDecode(invokeMethodback);
      if (!josndata["success"]) {
        setState(() {
          groupIdEnumSelect = [];
          groupIdEnumMap = {};
        });
      }
      if (josndata["errorCode"] != null &&
          josndata["errorCode"].toString() == "1001") {
        //登录失效
        tologout();
      }
      groupIdEnumSelect = [];
      groupIdEnumMap = {};
      for (var element in josndata["data"]) {
        groupIdEnumMap[element["id"].toString()] = element;
        if (element["children"].toString() != "{}") {
          for (var children in element["children"]) {
            groupIdEnumMap[children["id"].toString()] = children;
            if (children["children"].toString() != "{}") {
              for (var childrchildren in children["children"]) {
                groupIdEnumMap[childrchildren["id"].toString()] =
                    childrchildren;
              }
            }
          }
        }
      }

      josndata["data"].sort((a, b) {
        if (a['name'] == '未分组') return -1;
        if (b['name'] == '未分组') return 1;
        return 0;
      });
      setState(() {
        groupIdEnumSelect = josndata["data"];
        groupIdEnumMap;
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  Future<void> _refreshData() async {
    _initgroup();
  }

  _showSheet() async {
    String groupName = "";
    Future<bool?> back = await showCustomModalBottomBox(
        context,
        groupNameSetting(onselect: (val) {
          groupName = val;
        }),
        titleName: tr("groupManage.addtitle"),
        determine: "determine",
        next: () {
          print(groupName);
          _addgroup(groupName);
        });
  }

  _showAddChildSheet() async {
    String groupName = "";
    var parend = groupIdEnumMap[groupIdselect.toString()];
    if (parend["level"] > 2) {
      return;
    }
    Future<bool?> back = await showCustomModalBottomBox(
        context,
        groupNameSetting(onselect: (val) {
          groupName = val;
        }),
        titleName: tr("groupManage.addtitle"),
        determine: "determine",
        next: () {
          _addchildgroup(groupName);
        });
  }

  _editgroupSheet() async {
    String groupName = "";
    var parend = groupIdEnumMap[groupIdselect.toString()];

    Future<bool?> back = await showCustomModalBottomBox(
        context,
        groupNameSetting(onselect: (val) {
          groupName = val;
        }),
        titleName: tr("groupManage.editbtn"),
        determine: "determine",
        next: () {
          _editgroup(groupName);
        });
  }

  _editgroup(groupName) async {
    EasyLoading.show(status: 'loading...');
    try {
      var parend = groupIdEnumMap[groupIdselect.toString()];
      print(parend);

      var project = _selectController.selectProject.value["project"];
      var invokeMethodback =
          await platform.invokeMethod('getTopologyHandler.editGroup', {
        "projectId": project["id"],
        "area": int.parse(parend["id"].toString()),
        "id": int.parse(parend["id"].toString()),
        "name": groupName,
      });
      var josndata = jsonDecode(invokeMethodback);
      print("_editgroup： $josndata");
      if (josndata["success"]) {
        _initgroup();
      } else {
        EasyLoading.showError(josndata["errorMsg"]);
      }
      EasyLoading.dismiss();
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
    }
  }

  _delgroup() async {
    EasyLoading.show(status: 'loading...');
    try {
      var parend = groupIdEnumMap[groupIdselect.toString()];
      print("_delgroup ${{
        "deviceList": [int.parse(parend["id"].toString())]
      }}");
      var invokeMethodback =
          await platform.invokeMethod('getTopologyHandler.deletesGroup', {
        "deviceList": [int.parse(parend["id"].toString())]
      });
      var josndata = jsonDecode(invokeMethodback);
      print("_delgroup $josndata");
      if (josndata["success"]) {
        groupIdselect = -1;
        _initgroup();
      } else {
        EasyLoading.showError(josndata["errorMsg"]);
      }
      EasyLoading.dismiss();
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
    }
  }

  _addchildgroup(groupName) async {
    EasyLoading.show(status: 'loading...');
    try {
      var parend = groupIdEnumMap[groupIdselect.toString()];
      print(parend);
      var project = _selectController.selectProject.value["project"];
      var invokeMethodback =
          await platform.invokeMethod('getTopologyHandler.addGroup', {
        "projectId": project["id"],
        parend["level"].toString() == "1" ? "levelTwo" : "levelThree": {
          "parentId": parend["id"],
          "groupName": groupName,
        }
      });
      var josndata = jsonDecode(invokeMethodback);
      print(josndata);
      if (josndata["success"]) {
        _initgroup();
      } else {
        EasyLoading.showError(josndata["errorMsg"]);
      }
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  _addgroup(groupName) async {
    EasyLoading.show(status: 'loading...');
    try {
      var project = _selectController.selectProject.value["project"];
      var invokeMethodback =
          await platform.invokeMethod('getTopologyHandler.addGroup', {
        "projectId": project["id"],
        "levelOne": {"groupName": groupName}
      });
      var josndata = jsonDecode(invokeMethodback);
      print(josndata);
      if (josndata["success"]) {
        _initgroup();
      } else {
        EasyLoading.showError(josndata["errorMsg"]);
      }
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  bool selectlevel3 = false;
  _nodeSelected(c, n) {
    setState(() {
      groupIdselect = int.parse(n.toString()) == groupIdselect
          ? -1
          : int.parse(n.toString());

      var parend = groupIdEnumMap[groupIdselect.toString()];
      selectlevel3 = groupIdselect == -1 ? true : parend["level"] > 2;
    });
  }

  @override
  void initState() {
    super.initState();
    _initgroup();
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
          // ignore: prefer_const_constructors
          title: Text(
            'groupManage.title',
            style: const TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [
            !inEditStatus
                ? Padding(
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
                                        _controller.hideMenu();
                                        setState(() {
                                          inEditStatus = true;
                                        });
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
                  )
                : TextButton(
                    onPressed: () {
                      setState(() {
                        inEditStatus = false;
                      });
                    },
                    child: const Text("groupManage.back").tr()),
          ],
        ),
        body: RefreshIndicator(
            onRefresh: _refreshData, // 设置下拉刷新回调
            child: SingleChildScrollView(
              child: Container(
                  width: 720.w,
                  height: 1280.h - 91,
                  color: const Color.fromRGBO(244, 244, 244, 1),
                  padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
                  child: Column(
                    children: [
                      Expanded(
                          child: SingleChildScrollView(
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(8),
                          child: ExpandableTree(
                            submenuDecoration: const BoxDecoration(
                                border: null, color: Colors.white),
                            childrenDecoration: const BoxDecoration(
                                border: null, color: Colors.white),
                            nodes: [
                              for (var item in groupIdEnumSelect)
                                TreeNode(
                                  item["id"],
                                  subNodes: item["children"].toString() != "{}"
                                      ? [
                                          for (var item in item["children"])
                                            TreeNode(item["id"],
                                                subNodes: item["children"]
                                                            .toString() !=
                                                        "{}"
                                                    ? [
                                                        for (var item
                                                            in item["children"])
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
                              child: SafeText(
                                groupIdEnumMap[nodeValue.toString()]["name"],
                                style: normalText(
                                    fontcolor: nodeValue == groupIdselect
                                        ? const Color.fromRGBO(0, 128, 255, 1)
                                        : Colors.black),
                              ),
                            ),
                            onSelect: (node) => _nodeSelected(context, node),
                          ),
                        ),
                      )),
                      Container(
                        height: 57,
                        color: const Color.fromRGBO(244, 244, 244, 1),
                        margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                        padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 16.h),
                        child: widget.selecting
                            ? Center(
                                child: submitButton(
                                  isActive: groupIdselect != -1,
                                  label: tr('determine'),
                                  onClick: () async {
                                    if (groupIdselect != -1) {
                                      Get.back(result: {
                                        "select": groupIdEnumMap[
                                            groupIdselect.toString()],
                                      });
                                    }
                                  },
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: !inEditStatus
                                    ? [
                                        SizedBox(
                                          width: 300.w,
                                          child: normalButton(
                                            label: tr('groupManage.addbtn1'),
                                            onClick: () async {
                                              _showSheet();
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 300.w,
                                          child: submitButton(
                                            label: tr('groupManage.addbtn2'),
                                            onClick: () async {
                                              if (groupIdselect != -1) {
                                                _showAddChildSheet();
                                              }
                                            },
                                            isActive: groupIdselect != -1 &&
                                                !selectlevel3,
                                          ),
                                        ),
                                      ]
                                    : [
                                        SizedBox(
                                          width: 300.w,
                                          child: normalButton(
                                            label: tr('groupManage.del'),
                                            onClick: () async {
                                              if (groupIdselect != -1) {
                                                _delgroup();
                                              }
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 300.w,
                                          child: submitButton(
                                            label: tr('groupManage.editbtn'),
                                            onClick: () async {
                                              if (groupIdselect != -1) {
                                                _editgroupSheet();
                                              }
                                            },
                                            isActive: groupIdselect != -1,
                                          ),
                                        ),
                                      ]),
                      )
                    ],
                  )),
            )));
  }
}

class groupNameSetting extends StatefulWidget {
  Function onselect;
  groupNameSetting({super.key, required this.onselect});

  @override
  State<groupNameSetting> createState() => _groupNameSettingState();
}

class _groupNameSettingState extends State<groupNameSetting> {
  String order = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(0, 12.h, 0, 12.h),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7), // 背景颜色
                  borderRadius: BorderRadius.circular(8), // 圆角边框
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: tr('input.hintText'),
                    border: InputBorder.none, // 去掉默认的下划线边框
                  ),
                  onChanged: (val) {
                    setState(() {
                      order = val;
                    });
                    widget.onselect(order);
                  },
                ),
              )),
        ],
      ),
    );
  }
}
