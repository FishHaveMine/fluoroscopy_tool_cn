import 'dart:ffi';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

Future<Future<bool?>> showCustomModalBottomBox(context, childWidget,
    {String titleName = 'selectlist',
    String determine = 'determine',
    Function? next}) async {
  return showModalBottomSheet<bool?>(
    backgroundColor: const Color.fromARGB(0, 107, 107, 107),
    context: context, isScrollControlled: true, // 允许内容高度根据输入法调整
    builder: (BuildContext context) {
      return Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          height: 800.h,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: SizedBox(
                  // height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            Navigator.of(context).pop(false);
                          },
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                tr('cancel'),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                    color: Color.fromRGBO(15, 17, 28, 0.5)),
                              ))),
                      Expanded(
                        child: Center(
                          child: Text(
                            titleName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20.0),
                          ).tr(),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            Navigator.of(context).pop(true);
                            if (next != null) next();
                          },
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                tr(determine),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                    color: Color.fromRGBO(43, 52, 72, 1)),
                              )))
                    ],
                  ),
                ),
              ),
              const Divider(height: 1, color: Color.fromRGBO(0, 0, 0, 0.12)),
              Expanded(child: childWidget)
            ]),
          ));
    },
  );
}

Future<Future<sheetBack?>> showCustomModalBottomSheet(context, List options,
    {String titleName = 'selectlist',
    bool isDismissible = true,
    required List<String> baseValue,
    required bool isMultiple}) async {
  return showModalBottomSheet<sheetBack>(
    backgroundColor: const Color.fromARGB(0, 107, 107, 107),
    isDismissible: isDismissible, isScrollControlled: true, // 允许内容高度根据输入法调整
    context: context,
    builder: (BuildContext context) {
      return bottomSheet(
        isNullable: isDismissible,
        isMultiple: isMultiple,
        options: options,
        titleName: tr(titleName),
        baseValue: baseValue,
      );
    },
  );
}

class bottomSheet extends StatefulWidget {
  const bottomSheet(
      {super.key,
      required this.isNullable,
      required this.isMultiple,
      required this.options,
      required this.titleName,
      required this.baseValue});
  final bool isNullable;
  final bool isMultiple;
  final List options;
  final String titleName;
  final List<String> baseValue;
  @override
  State<bottomSheet> createState() => _bottomSheetState();
}

class _bottomSheetState extends State<bottomSheet> {
  List<String> baseValue = [];
  List<int> indexValue = [];
  var selfoptions = [];
  int initialItem = 0;

  @override
  void initState() {
    super.initState();
    // selfoptions = widget.options;
    for (var i = 0; i < widget.options.length; i++) {
      // selfoptions[i]['value'] = selfoptions[i]['value'].toString();
      bool isActive =
          widget.options[i].isNotEmpty && widget.options[i]['disabled'] != null;
      // selfoptions[i]['disabled'] = isActive ? 1 : 0;
      selfoptions.add({
        'label': widget.options[i]['label'],
        'value': widget.options[i]['value'].toString(),
        'disabled': isActive ? 1 : 0
      });
      if (widget.baseValue.indexOf(widget.options[i]['value'].toString()) !=
          -1) {
        indexValue.add(i);
        initialItem = i;
      }
    }
    setState(() {
      selfoptions;
    });
    baseValue = widget.baseValue;
    if (indexValue.isEmpty && !widget.isMultiple && selfoptions.isNotEmpty) {
      indexValue = [];
      initialItem = 0;
      baseValue = [];
      setState(() {
        indexValue;
        baseValue;
        initialItem;
      });
    }
  }

  void setbaseValue(value, index) {
    if (widget.isMultiple) {
      //多选
      if (baseValue.indexOf(value) == -1) {
        baseValue.add(value);
      } else {
        baseValue.removeAt(baseValue.indexOf(value));
      }

      if (indexValue.indexOf(index) == -1) {
        indexValue.add(index);
      } else {
        indexValue.removeAt(indexValue.indexOf(index));
      }

      if (value == 'all' && baseValue.indexOf(value) != -1) {
        for (var i = 0; i < selfoptions.length; i++) {
          if (baseValue.indexOf(selfoptions[i]['value'].toString()) == -1) {
            baseValue.add(selfoptions[i]['value'].toString());
            indexValue.add(i);
          }
        }
      }
    } else {
      //单选
      if (baseValue.indexOf(value) == -1) {
        baseValue = [value];
        indexValue = [index];
      } else if (widget.isNullable) {
        baseValue = ['-1'];
        indexValue = [-1];
      }
    }
    setState(() {
      baseValue;
      indexValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      height: 320,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: SizedBox(
            // height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Navigator.of(context).pop(widget.isNullable
                          ? sheetBack([], [])
                          : sheetBack(baseValue, indexValue));
                    },
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          tr('cancel'),
                          style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.0,
                              color: Color.fromRGBO(15, 17, 28, 0.5)),
                        ))),
                Expanded(
                  child: Center(
                    child: Text(
                      widget.titleName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 20.0),
                    ).tr(),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Navigator.of(context)
                          .pop(sheetBack(baseValue, indexValue));
                    },
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          tr('determine'),
                          style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.0,
                              color: Color.fromRGBO(43, 52, 72, 1)),
                        )))
              ],
            ),
          ),
        ),

        const Divider(height: 1, color: Color.fromRGBO(0, 0, 0, 0.12)),
        // 单选
        if (!widget.isMultiple)
          Expanded(
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: selfoptions[index]['disabled'] != null &&
                            selfoptions[index]['disabled'] != 0
                        ? null
                        : () {
                            setbaseValue(
                                selfoptions[index]['value'].toString(), index);
                          },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(13, 0, 13, 0),
                      child: ListTile(
                          enabled: selfoptions[index]['disabled'] != null &&
                              selfoptions[index]['disabled'] != 0,
                          horizontalTitleGap: 0,
                          title: Container(
                            child: Text('${selfoptions[index]['label']}',
                                    style: const TextStyle(
                                        color: Color.fromRGBO(13, 13, 13, 1),
                                        decoration: TextDecoration.none,
                                        // 文字大小
                                        fontSize: 14.0,
                                        // normal 正常，italic 斜体
                                        fontStyle: FontStyle.normal,
                                        // 字体的粗细
                                        fontWeight: FontWeight.w400,
                                        // 文字间的宽度
                                        letterSpacing: 1.0))
                                .tr(),
                          ),
                          leading: RoundCheckBox(
                            isChecked: baseValue.contains(
                                selfoptions[index]['value'].toString()),
                            onTap: selfoptions[index]['disabled'] != null &&
                                    selfoptions[index]['disabled'] != 0
                                ? null
                                : (selected) {
                                    setbaseValue(
                                        selfoptions[index]['value'].toString(),
                                        index);
                                  },
                            size: 20,
                            checkedWidget: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            ),
                            checkedColor:
                                Theme.of(context).colorScheme.secondary,
                            border: Border.all(
                                // width: 1,
                                color: selfoptions[index]['disabled'] != null &&
                                        selfoptions[index]['disabled'] != 0
                                    ? Colors.transparent
                                    : Theme.of(context).colorScheme.secondary),
                          )),
                    ));
              },
              itemCount: selfoptions.length,
              separatorBuilder: (BuildContext context, int index) {
                return const Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Divider(
                        height: 1, color: Color.fromRGBO(0, 0, 0, 0.12)));
              },
            ),
          ),
        if (widget.isMultiple)
          Expanded(
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    enabled: selfoptions[index]['disabled'] != null &&
                        selfoptions[index]['disabled'] == 0 &&
                        !baseValue
                            .contains(selfoptions[index]['value'].toString()),
                    onTap: () {
                      setbaseValue(
                          selfoptions[index]['value'].toString(), index);
                    },
                    horizontalTitleGap: 0,
                    title: Text(selfoptions[index]['label'].toString(),
                            style: const TextStyle(
                                color: Color.fromRGBO(13, 13, 13, 1),
                                decoration: TextDecoration.none,
                                // 文字大小
                                fontSize: 14.0,
                                // normal 正常，italic 斜体
                                fontStyle: FontStyle.normal,
                                // 字体的粗细
                                fontWeight: FontWeight.w400,
                                // 文字间的宽度
                                letterSpacing: 1.0))
                        .tr(),
                    leading: RoundCheckBox(
                      isChecked: baseValue
                          .contains(selfoptions[index]['value'].toString()),
                      onTap: selfoptions[index]['disabled'] != null &&
                              selfoptions[index]['disabled'] == 0 &&
                              !baseValue.contains(
                                  selfoptions[index]['value'].toString())
                          ? null
                          : (selected) {
                              setbaseValue(
                                  selfoptions[index]['value'].toString(),
                                  index);
                            },
                      size: 20,
                      checkedWidget: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                      checkedColor: Theme.of(context).colorScheme.secondary,
                      border: Border.all(
                          // width: 1,
                          color: Theme.of(context).colorScheme.secondary),
                    ));
              },
              itemCount: selfoptions.length,
              separatorBuilder: (BuildContext context, int index) {
                return const Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Divider(
                        height: 1, color: Color.fromRGBO(0, 0, 0, 0.12)));
              },
            ),
          ),
      ]),
    );
  }
}

class sheetBack {
  final List<String> _baseValue;
  final List<int> _indexValue;

  sheetBack(this._baseValue, this._indexValue);

  List<String>? get baseValue => _baseValue;
  List<int>? get indexValue => _indexValue;
}
