import 'dart:convert';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/baseContainer.dart';
import 'package:fluoroscopy_tool/compent/snInput.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/style/index.dart';
import 'package:fluoroscopy_tool/view/systemCapabilityAnalysis/step2/systemDetail.dart';
import 'package:fluoroscopy_tool/waterpumb/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create/index.dart';
import 'package:fluoroscopy_tool/store/http.dart';
import 'unit/downloadService.dart';

class pumbReportIndex extends StatefulWidget {
  pumbReportIndex({super.key});

  @override
  State<pumbReportIndex> createState() => _pumbReportIndexState();
}

class _pumbReportIndexState extends State<pumbReportIndex> {
  static const McuUtilplatform = MethodChannel('samples.flutter.dev/McuUtil');

  static const platform =
      MethodChannel('samples.flutter.dev/waterpumbBasicHandler');
  final waterpumbInfoController _deviceInfoController =
      Get.put(waterpumbInfoController());

  @override
  void initState() {
    super.initState();
    // McuUtilplatform.invokeMethod('powerOn');

    _fetchProjects();
    _scrollController.addListener(_onScroll);
  }

  List<dynamic> projects = [];
  int pageIndex = 0;
  int pageSize = 10;
  bool isLoading = false;
  bool hasMoreData = true;

  String _currentKeyword = '';
  SearchType _currentType = SearchType.sn;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 滚动监听
  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchMoreProjects();
    }
  }

  _search() {
    pageIndex = 0;
    pageSize = 10;
    projects = [];
    hasMoreData = true;
    _fetchProjects();
  }

  // 获取项目列表
  Future<void> _fetchProjects() async {
    if (isLoading || !hasMoreData) return;

    setState(() {
      isLoading = true;
    });

    try {
      var _send = {};
      _send = {"pageIndex": pageIndex, "pageSize": pageSize};
      if (_currentType == SearchType.sn && _currentKeyword != "") {
        _send["sn"] = _currentKeyword;
      }
      if (_currentType == SearchType.projectCode && _currentKeyword != "") {
        _send["projectCode"] = _currentKeyword;
      }

      print("_fetchProjects _send : $_send");
      final response = await MideaApi.waterMachineDebuggingPage(_send);

      print("_fetchProjects response : $response");
      if (response['errorCode'] == 200) {
        final data = response['data'];
        final List<dynamic> newProjects = data ?? [];

        setState(() {
          if (pageIndex == 0) {
            projects = newProjects;
          } else {
            projects.addAll(newProjects);
          }

          // 判断是否还有更多数据
          int loaded = (pageSize * (pageIndex + 1));
          int totalCount = int.parse(response['totalCount'].toString());
          hasMoreData = totalCount > loaded;
          pageIndex++;
          isLoading = false;

          print("hasMoreData: $hasMoreData  ${totalCount} ${loaded}");
        });
      } else {
        throw Exception('获取项目列表失败}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('错误: $e');
      // 显示错误提示
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('加载数据失败，请重试')));
    }
  }

  // 加载更多项目
  Future<void> _fetchMoreProjects() async {
    if (!isLoading && hasMoreData) {
      await _fetchProjects();
    }
  }

  // 刷新列表
  Future<void> _refreshProjects() async {
    setState(() {
      pageIndex = 0;
      hasMoreData = true;
    });
    await _fetchProjects();
  }

  String formatTimestamp(int? timestamp) {
    if (timestamp == null) {
      return "--";
    }
    // 将时间戳转换为 DateTime 对象（注意：时间戳单位可能是毫秒或秒）
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // 使用 DateFormat 格式化日期时间
    final formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(date);
  }

  String search = "";

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
            '冷水机组调试报告',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: const [],
        ),
        body: Container(
            width: 720.w,
            height: 1280.h,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(
                      12, 105, 255, 0.2), // #0C69FF as an opaque color
                  Colors
                      .white, // rgba(28,162,255,0.00) as a Color with transparency
                ],
              ),
            ),
            padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(32.w),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        height: 88.h,
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SearchBarWithType(
                          onSearch: (keyword, type) {
                            setState(() {
                              _currentKeyword = keyword;
                              _currentType = type;
                            });
                            _search();
                          },
                        ),
                      )),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 156.w,
                        height: 88.h,
                        child: submitButton(
                            label: "新建",
                            onClick: () async {
                              String key = "reportCreatePageNeedSn";
                              final prefs =
                                  await SharedPreferences.getInstance();

                              var useinfoString =
                                  await prefs.getString("useinfo");
                              print(useinfoString);
                              final jsonStr = prefs.getString("$key");
                              if (jsonStr != null) {
                                bool issend = await divConfirmDialog(context,
                                    confirmTitle: tr(
                                        "device.controltDialog.confirmTitle"),
                                    confirmDescriptionWidget:
                                        SingleChildScrollView(
                                      child: SizedBox(
                                          width: 560.w,
                                          height: 140,
                                          child: Padding(
                                            padding: const EdgeInsets.all(24),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Text('发现未完成的报告，是否继续完成？')
                                                    .tr(),
                                              ],
                                            ),
                                          )),
                                    ));
                                if (issend) {
                                } else {
                                  await prefs.remove("$key");
                                  await prefs.remove("$key-page");
                                }
                                Get.to(
                                  reportCreatePage(
                                      sn: '$key',
                                      onFinish: () {
                                        print("onFinish");
                                        _refreshProjects();
                                      }),
                                );
                              } else {
                                Get.to(reportCreatePage(
                                    sn: '$key',
                                    onFinish: () {
                                      print("onFinish");
                                      _refreshProjects();
                                    }));
                              }
                            },
                            isActive: true),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshProjects,
                    child: projects.isEmpty
                        ? Center(child: Text('暂无数据'))
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount: projects.length + (hasMoreData ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index < projects.length) {
                                final item = projects[index];
                                return Card(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 32.w, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Text(
                                                    item['projectName']!,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            InkWell(
                                              onTap: () {
                                                DownloadService
                                                    .downloadToDownloads(
                                                        item[
                                                            'reportDownloadUrl'],
                                                        context);
                                              },
                                              child: const Text(
                                                '下载',
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ),
                                            )
                                          ],
                                        ),
                                        const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 8, 0, 8),
                                          child: Divider(
                                              height: 1,
                                              color: Color(0xFFDFDFDF)),
                                        ),
                                        infobox(
                                          label: '设备类型:',
                                          val: item['productModel'] ?? "",
                                        ),
                                        infobox(
                                          label: '项目编码:',
                                          val: item['projectCode'] ?? "",
                                        ),
                                        infobox(
                                          label: '调试员:',
                                          val: item['debugUserName'] ?? "",
                                        ),
                                        infobox(
                                          label: '创建时间:',
                                          val: formatTimestamp(
                                              item['createTime']),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                // 加载更多指示器
                                return Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                    child: hasMoreData
                                        ? CircularProgressIndicator()
                                        : Text('没有更多数据'),
                                  ),
                                );
                              }
                            },
                          ),
                  ),
                )
              ],
            )));
  }
}

TextStyle labelStyle() {
  return const TextStyle(
      color: Color.fromRGBO(153, 153, 153, 1),
      fontSize: 14,
      fontWeight: FontWeight.w400);
}

class infobox extends StatelessWidget {
  String label;
  String val;
  infobox({super.key, required this.label, required this.val});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: normalText(),
          ).tr(),
        ),
        Expanded(
            child: Text(
          val,
          style: normalTextBlack(),
        ).tr())
      ],
    );
  }
}

enum SearchType {
  sn,
  projectCode,
}

class SearchBarWithType extends StatefulWidget {
  final Function(String keyword, SearchType type) onSearch;
  final String? initialKeyword;
  final SearchType? initialType;

  const SearchBarWithType({
    Key? key,
    required this.onSearch,
    this.initialKeyword,
    this.initialType,
  }) : super(key: key);

  @override
  State<SearchBarWithType> createState() => _SearchBarWithTypeState();
}

class _SearchBarWithTypeState extends State<SearchBarWithType> {
  late SearchType _selectedType;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType ?? SearchType.sn;
    if (widget.initialKeyword != null) {
      _controller.text = widget.initialKeyword!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // 获取搜索类型的显示名称
  String _getTypeName(SearchType type) {
    switch (type) {
      case SearchType.sn:
        return 'SN编码';
      case SearchType.projectCode:
        return '项目编码';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // 类型选择下拉按钮
          DropdownButtonHideUnderline(
            child: DropdownButton<SearchType>(
              value: _selectedType,
              items: SearchType.values.map((type) {
                return DropdownMenuItem<SearchType>(
                  value: type,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(_getTypeName(type)),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedType = newValue;
                  });
                }
              },
              icon: const Icon(Icons.arrow_drop_down),
              elevation: 16,
              style: const TextStyle(color: Colors.black87),
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          // 分隔线
          Container(
            width: 1,
            height: 20,
            color: Colors.grey[300],
          ),

          // 搜索输入框
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: '请输入${_getTypeName(_selectedType)}',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                // suffixIcon: _controller.text.isNotEmpty
                //     ? IconButton(
                //         icon: const Icon(Icons.clear),
                //         onPressed: () {
                //           _controller.clear();
                //           _focusNode.unfocus();
                //           widget.onSearch('', _selectedType);
                //         },
                //       )
                //     : Container(
                //         width: 25,
                //       ),
              ),
              onChanged: (value) {
                // 实时搜索（可选）
                // widget.onSearch(value, _selectedType);
              },
              onSubmitted: (value) {
                // 提交搜索
                widget.onSearch(value, _selectedType);
              },
            ),
          ),

          // 搜索按钮
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _focusNode.unfocus();
              widget.onSearch(_controller.text, _selectedType);
            },
          ),
        ],
      ),
    );
  }
}
