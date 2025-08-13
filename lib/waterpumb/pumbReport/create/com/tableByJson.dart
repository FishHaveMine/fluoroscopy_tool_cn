import 'package:flutter/material.dart';

import '../public/InstallationInfo.dart';
import '../public/publicObject.dart';

import 'package:get/get.dart';

import 'coolingtable.dart';

// 假设TableConfig类已定义在此处或已导入
class TableConfig {
  final List<String> tableRow;
  final List<List<dynamic>> tableColum;

  TableConfig({
    required this.tableRow,
    required this.tableColum,
  });

  Map<String, dynamic> toJson() {
    return {
      'TableRow': tableRow,
      'TableColum': tableColum,
    };
  }

  // 转换为包含表单值的JSON结构
  Map<String, dynamic> toFormValueJson(InstallController controller) {
    Map<String, dynamic> result = {
      'TableRow': tableRow,
      'TableColum': List<List<dynamic>>.from(tableColum),
    };

    // 遍历每一行
    for (int rowIndex = 0; rowIndex < result['TableColum'].length; rowIndex++) {
      List<dynamic> row = result['TableColum'][rowIndex] as List<dynamic>;

      // 遍历每一列（跳过第一列，第一列是项目名称）
      for (int colIndex = 1; colIndex < row.length; colIndex++) {
        String fieldKey = row[colIndex].toString();

        // 检查是否为表单字段
        if (controller.form.fields.containsKey(fieldKey)) {
          String? fieldValue = controller.form[fieldKey]?.val;
          row[colIndex] = fieldValue ?? '';
        }
      }
    }

    return result;
  }
}

class tableByJson extends StatefulWidget {
  final TableConfig setting; // 修改为TableConfig类型
  tableByJson({super.key, required this.setting});

  @override
  State<tableByJson> createState() => _tableByJsonState();
}

class _tableByJsonState extends State<tableByJson> {
  late List<FocusNode> _focusNodes;
  List all = [];

  init() {
    // 添加数据行 - 使用TableConfig的tableColum属性
    if (widget.setting.tableColum.isNotEmpty) {
      InstallController _ = Get.find();
      widget.setting.tableColum.forEach((rowData) {
        if (rowData is List) {
          print("遍历 $rowData -------- FocusNode");
          for (var fieldKey in rowData) {
            if (_.form.fields.containsKey(fieldKey)) {
              final formItem = _.form[fieldKey];
              if (formItem.type != FormItemType.radio) {
                all.add(fieldKey);
              }
            }
          }
        }
      });
      _focusNodes = List.generate(
        all.length,
        (index) => FocusNode(),
      );
      setState(() {
        _focusNodes;
        all;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // 释放FocusNode和TextEditingController资源
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InstallController>(
        builder: (_) => Container(
              padding: const EdgeInsets.all(8),
              child: Table(
                border: TableBorder.all(
                    color: const Color.fromRGBO(216, 216, 216, 0.2)),
                children: _focusNodes.isNotEmpty ? _buildTableRows(_) : [],
              ),
            ));
  }

  // 构建表格所有行
  List<TableRow> _buildTableRows(InstallController builder) {
    List<TableRow> rows = [];

    // 添加表头行 - 使用TableConfig的tableRow属性
    if (widget.setting.tableRow.isNotEmpty) {
      rows.add(_buildHeaderRow(widget.setting.tableRow));
    }

    // 添加数据行 - 使用TableConfig的tableColum属性
    if (widget.setting.tableColum.isNotEmpty) {
      widget.setting.tableColum.forEach((rowData) {
        if (rowData is List) {
          rows.add(_buildDataRow(rowData, builder));
        }
      });
    }

    return rows;
  }

  // 构建表头行
  TableRow _buildHeaderRow(List<String> headerData) {
    return TableRow(
      children: headerData.map((headerText) {
        return TableCell(
          child: Container(
            color: const Color.fromRGBO(216, 216, 216, 0.2),
            padding: const EdgeInsets.all(8.0),
            child: Text(headerText),
          ),
        );
      }).toList(),
    );
  }

  // 构建数据行
  TableRow _buildDataRow(List<dynamic> rowData, InstallController _) {
    return TableRow(
      children: rowData.map((cellData) {
        return _buildFormCell(cellData.toString(), _);
      }).toList(),
    );
  }

  // 构建表单单元格（其他列）
  TableCell _buildFormCell(String fieldKey, InstallController _) {
    // 检查是否为FormItem字段
    print(
        "_buildFormCell: $fieldKey --------- ${_.form.fields.containsKey(fieldKey)}");
    if (_.form.fields.containsKey(fieldKey)) {
      final formItem = _.form[fieldKey];
      // 如果是单选类型
      if (formItem.type == FormItemType.radio && formItem.op != null) {
        return TableCell(
          child: Column(
            children: [
              ...formItem.op!.map((op) {
                return Row(
                  children: [
                    Radio<String>(
                      activeColor: const Color.fromRGBO(0, 128, 255, 1),
                      focusColor: const Color.fromRGBO(0, 128, 255, 1),
                      value: op.val,
                      groupValue: formItem.val,
                      onChanged: _.ispreview.value
                          ? null
                          : (newValue) {
                              if (formItem.val == newValue) {
                                formItem.val = "";
                              } else {
                                formItem.val = newValue!;
                              }
                              _.update();
                            },
                    ),
                    InkWell(
                      onTap: _.ispreview.value
                          ? null
                          : () {
                              if (formItem.val == op.val) {
                                formItem.val = "";
                              } else {
                                formItem.val = op.val;
                              }
                              _.update();
                            },
                      child: Text(
                        op.val,
                        style: tip,
                      ),
                    ),
                  ],
                );
              }).toList()
            ],
          ),
        );
      }
      // 如果是输入类型
      else {
        return TableCell(
          child: Container(
            height: 100,
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: tableInput(
                item: formItem,
                focusNodes: _focusNodes[all.indexOf(fieldKey)],
                onInputFieldSubmitted: () {
                  if (all.indexOf(fieldKey) < _focusNodes.length - 1) {
                    _focusNodes[all.indexOf(fieldKey) + 1].requestFocus();
                  } else {
                    _focusNodes[all.indexOf(fieldKey)].unfocus();
                  }
                },
                readOnly: _.ispreview.value,
                onValidator: (val) {
                  formItem.val = val ?? "";
                },
              ),
            ),
          ),
        );
      }
    } else {
      return TableCell(
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(fieldKey)),
        ),
      );
    }
  }
}
