import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/view/local/checkData/share.dart';
import 'package:fluoroscopy_tool/view/local/publicFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_table/table_sticky_headers.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:get/get.dart';

class TapHandlerPage extends StatefulWidget {
  TapHandlerPage({
    super.key,
    required this.data,
    required this.titleColumn,
    required this.titleRow,
    required this.selectIDs,
    required this.onClick,
    required this.selectAll,
    this.CellBuilder,
  });

  final List<List<String>> data;
  final List<String> titleColumn;
  final List<String> titleRow;
  final List<String> selectIDs;
  final Widget Function(int column, String val)? CellBuilder;
  Function(String) onClick;
  Function(bool) selectAll;

  @override
  _TapHandlerPageState createState() => _TapHandlerPageState();
}

class _TapHandlerPageState extends State<TapHandlerPage> {
  int? selectedRow;
  int? selectedColumn;

  final checkDataController _checkDataController =
      Get.put(checkDataController());

  Color getContentColor(int i, int j) {
    if (i == selectedRow && j == selectedColumn) {
      return const Color.fromRGBO(18, 80, 123, 0.3);
    } else if (i == selectedRow || j == selectedColumn) {
      return const Color.fromRGBO(18, 80, 123, 0.1);
    } else {
      return Colors.transparent;
    }
  }

  void clearState() => setState(() {
        selectedRow = null;
        selectedColumn = null;
      });

  @override
  Widget build(BuildContext context) => StickyHeadersTable(
        columnsLength: widget.titleColumn.length,
        rowsLength: widget.titleRow.length,
        columnsTitleBuilder: (i) => TextButton(
          onPressed: clearState,
          child: Text(
            tr(widget.titleColumn[i]),
            style: tableLabel(context),
          ),
        ),
        rowsTitleBuilder: (i) => TextButton(
          onPressed: () {
            widget.onClick(widget.titleRow[i]);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RoundCheckBox(
                isChecked: widget.selectIDs.contains(widget.titleRow[i]),
                onTap: (selected) {
                  widget.onClick(widget.titleRow[i]);
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
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(widget.titleRow[i], style: tableLabel(context)),
              )
            ],
          ),
        ),
        contentCellBuilder: (i, j) => ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(getContentColor(i, j)),
              elevation: MaterialStateProperty.all(0),
              padding: MaterialStateProperty.all(EdgeInsets.zero)),
          onPressed: () => setState(() {
            selectedColumn = j;
            selectedRow = i;
          }),
          child: tabelRowByKey(
              index: j, Key: widget.titleColumn[i].toString().split('.')[1]),
        ),
        legendCell: TextButton(
          onPressed: () {
            widget.selectAll(
                !(widget.selectIDs.length == widget.titleRow.length));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RoundCheckBox(
                isChecked: widget.selectIDs.length == widget.titleRow.length,
                onTap: (selected) {
                  widget.selectAll(selected!);
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
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child:
                    Text('parametersPage.IDU', style: tableLabel(context)).tr(),
              )
            ],
          ),
        ),
      );
}

TextStyle tableLabel(context) {
  return const TextStyle(
      color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400);
}

TextStyle tableValue() {
  return const TextStyle(
      color: Color.fromRGBO(136, 136, 136, 1),
      fontSize: 12,
      fontWeight: FontWeight.w400);
}

class tabelRowByKey extends StatefulWidget {
  int index;
  String Key;
  tabelRowByKey({super.key, required this.index, required this.Key});

  @override
  State<tabelRowByKey> createState() => _tabelRowByKeyState();
}

class _tabelRowByKeyState extends State<tabelRowByKey> {
  final deviceInfoController _deviceInfoController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<deviceInfoController>(
        builder: (_) => Center(
            key: ValueKey(
                '_tabelRowByKeyState${widget.index} ${widget.Key} _ ${_deviceInfoController.updateTime.value}'),
            child: handelTabelRow(
                '${_deviceInfoController.indoorEntityList.value.isEmpty ? "--" : _deviceInfoController.indoorEntityList[widget.index] != null ? _deviceInfoController.indoorEntityList[widget.index][widget.Key] : "--"}',
                widget.Key)));
  }
}
