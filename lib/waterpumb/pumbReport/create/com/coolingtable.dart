import 'package:flutter/material.dart';

import '../public/InstallationInfo.dart';
import '../public/publicObject.dart';

import 'package:get/get.dart';

class coolingtable extends StatefulWidget {
  const coolingtable({super.key});

  @override
  State<coolingtable> createState() => _coolingtableState();
}

class _coolingtableState extends State<coolingtable> {
  // 用于存储表单数据
  @override
  Widget build(BuildContext context) {
    return GetBuilder<InstallController>(
        builder: (_) => Container(
              padding: const EdgeInsets.all(8),
              child: Table(
                border: TableBorder.all(
                    color: const Color.fromRGBO(216, 216, 216, 0.2)),
                children: [
                  // 表头
                  TableRow(
                    children: [
                      TableCell(
                        child: Container(
                          color: const Color.fromRGBO(216, 216, 216, 0.2),
                          padding: const EdgeInsets.all(8.0),
                          child: const Text('类别'),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          color: const Color.fromRGBO(216, 216, 216, 0.2),
                          padding: const EdgeInsets.all(8.0),
                          child: const Text('形式'),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          color: const Color.fromRGBO(216, 216, 216, 0.2),
                          padding: const EdgeInsets.all(8.0),
                          child: const Text('流量m³/h'),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          color: const Color.fromRGBO(216, 216, 216, 0.2),
                          padding: const EdgeInsets.all(8.0),
                          child: const Text('扬程m'),
                        ),
                      ),
                    ],
                  ),
                  // 冷冻水泵行
                  TableRow(
                    children: [
                      TableCell(
                        child: Container(
                          height: 100,
                          color: const Color.fromRGBO(216, 216, 216, 0.2),
                          padding: const EdgeInsets.all(8.0),
                          child: const Center(
                            child: Text('冷冻水泵'),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Column(
                          children: [
                            ..._.form['chilledWaterPumpForm'].op!.map((op) {
                              return Row(
                                children: [
                                  Radio<String>(
                                    activeColor:
                                        const Color.fromRGBO(0, 128, 255, 1),
                                    focusColor:
                                        const Color.fromRGBO(0, 128, 255, 1),
                                    value: op.val,
                                    groupValue:
                                        _.form['chilledWaterPumpForm'].val,
                                    onChanged: _.ispreview.value
                                        ? null
                                        : (newValue) {
                                            if (_.form['chilledWaterPumpForm']
                                                    .val ==
                                                newValue) {
                                              _.form['chilledWaterPumpForm']
                                                  .val = "";
                                            } else {
                                              _.form['chilledWaterPumpForm']
                                                  .val = newValue!;
                                            }
                                            _.update();
                                          },
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (_.form['chilledWaterPumpForm'].val ==
                                          op.val) {
                                        _.form['chilledWaterPumpForm'].val = "";
                                      } else {
                                        _.form['chilledWaterPumpForm'].val =
                                            op.val;
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
                      ),
                      TableCell(
                        child: Container(
                          height: 100,
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: tableInput(
                            item: _.form['chilledWaterPumpFlow'],
                            readOnly: _.ispreview.value,
                            onValidator: (val) {
                              _.form['chilledWaterPumpFlow'].val = val ?? "";
                            },
                          )),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          height: 100,
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: tableInput(
                            item: _.form['chilledWaterPumpHead'],
                            readOnly: _.ispreview.value,
                            onValidator: (val) {
                              _.form['chilledWaterPumpHead'].val = val ?? "";
                            },
                          )),
                        ),
                      ),
                    ],
                  ),
                  // 冷却水泵行
                  TableRow(
                    children: [
                      TableCell(
                        child: Container(
                          height: 100,
                          color: const Color.fromRGBO(216, 216, 216, 0.2),
                          padding: const EdgeInsets.all(8.0),
                          child: const Center(
                            child: Text('冷却水泵'),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Column(
                          children: [
                            ..._.form['coolingWaterPumpForm'].op!.map((op) {
                              return Row(
                                children: [
                                  Radio<String>(
                                    activeColor:
                                        const Color.fromRGBO(0, 128, 255, 1),
                                    focusColor:
                                        const Color.fromRGBO(0, 128, 255, 1),
                                    value: op.val,
                                    groupValue:
                                        _.form['coolingWaterPumpForm'].val,
                                    onChanged: _.ispreview.value
                                        ? null
                                        : (newValue) {
                                            if (_.form['coolingWaterPumpForm']
                                                    .val ==
                                                newValue) {
                                              _.form['coolingWaterPumpForm']
                                                  .val = "";
                                            } else {
                                              _.form['coolingWaterPumpForm']
                                                  .val = newValue!;
                                            }
                                            _.update();
                                          },
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (_.form['coolingWaterPumpForm'].val ==
                                          op.val) {
                                        _.form['coolingWaterPumpForm'].val = "";
                                      } else {
                                        _.form['coolingWaterPumpForm'].val =
                                            op.val;
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
                      ),
                      TableCell(
                        child: Container(
                          height: 100,
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: tableInput(
                            readOnly: _.ispreview.value,
                            item: _.form['coolingWaterPumpFlow'],
                            onValidator: (val) {
                              _.form['coolingWaterPumpFlow'].val = val ?? "";
                            },
                          )),
                        ),
                      ),
                      TableCell(
                        child: Container(
                            height: 100,
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: tableInput(
                                readOnly: _.ispreview.value,
                                item: _.form['coolingWaterPumpHead'],
                                onValidator: (val) {
                                  _.form['coolingWaterPumpHead'].val =
                                      val ?? "";
                                },
                              ),
                            )),
                      ),
                    ],
                  ),
                  // 冷却塔行
                  TableRow(
                    children: [
                      TableCell(
                        child: Container(
                          height: 100,
                          color: const Color.fromRGBO(216, 216, 216, 0.2),
                          padding: const EdgeInsets.all(8.0),
                          child: const Center(
                            child: Text('冷却塔'),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Column(
                          children: [
                            ..._.form['coolingTowerForm'].op!.map((op) {
                              return Row(
                                children: [
                                  Radio<String>(
                                    activeColor:
                                        const Color.fromRGBO(0, 128, 255, 1),
                                    focusColor:
                                        const Color.fromRGBO(0, 128, 255, 1),
                                    value: op.val,
                                    groupValue: _.form['coolingTowerForm'].val,
                                    onChanged: _.ispreview.value
                                        ? null
                                        : (newValue) {
                                            if (_.form['coolingTowerForm']
                                                    .val ==
                                                newValue) {
                                              _.form['coolingTowerForm'].val =
                                                  "";
                                            } else {
                                              _.form['coolingTowerForm'].val =
                                                  newValue!;
                                            }
                                            _.update();
                                          },
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (_.form['coolingTowerForm'].val ==
                                          op.val) {
                                        _.form['coolingTowerForm'].val = "";
                                      } else {
                                        _.form['coolingTowerForm'].val = op.val;
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
                      ),
                      TableCell(
                        child: Container(
                            height: 100,
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: tableInput(
                                readOnly: _.ispreview.value,
                                item: _.form['coolingTowerFlow'],
                                onValidator: (val) {
                                  _.form['coolingTowerFlow'].val = val ?? "";
                                },
                              ),
                            )),
                      ),
                      TableCell(
                        child: Container(
                          height: 100,
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: tableInput(
                              readOnly: _.ispreview.value,
                              item: _.form['coolingTowerHead'],
                              onValidator: (val) {
                                _.form['coolingTowerHead'].val = val ?? "";
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ));
  }
}

InputDecoration input_decoration(hintText) {
  return InputDecoration(
    hintText: hintText ?? '请输入',
    hintStyle: const TextStyle(color: Colors.grey),
    contentPadding: const EdgeInsets.symmetric(vertical: 6),
    isDense: true,
    border: const UnderlineInputBorder(
      borderSide: BorderSide(color: Color.fromRGBO(238, 238, 238, 1)),
    ),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Color.fromRGBO(238, 238, 238, 1)),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.blue),
    ),
  );
}

TextStyle tableText = const TextStyle(fontSize: 12);

class tableInput extends StatefulWidget {
  FormItem item;
  FocusNode? focusNodes;
  VoidCallback? onInputFieldSubmitted;
  String? hintText;
  bool readOnly = false;
  VoidCallback? onTap;
  Function(String?) onValidator;
  tableInput({
    super.key,
    required this.item,
    this.hintText = null,
    this.readOnly = false,
    this.onTap,
    this.onInputFieldSubmitted,
    this.focusNodes,
    required this.onValidator,
  });

  @override
  State<tableInput> createState() => _tableInputState();
}

class _tableInputState extends State<tableInput> {
  final TextEditingController controller = TextEditingController();
  String? inputval;
  FocusNode? _focusNodes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.item.val != null) {
      controller.text = widget.item.val;
    }
    _focusNodes = widget.focusNodes ?? FocusNode();
    setState(() {
      inputval = widget.item.val;
    });
  }

  @override
  void didUpdateWidget(covariant tableInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 如果 val 被外部改变，需要手动刷新 controller
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.text != widget.item.val) {
        controller.text = widget.item.val;
        setState(() {
          inputval = widget.item.val;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    try {
      if (_focusNodes != null) {
        _focusNodes?.dispose();
      }
    } catch (e) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: widget.readOnly,
      focusNode: _focusNodes,
      onFieldSubmitted: (value) {
        _focusNodes?.unfocus();
        if (widget.onInputFieldSubmitted != null) {
          widget.onInputFieldSubmitted!();
        }
      },
      onTap: widget.onTap,
      keyboardType: widget.item.type == FormItemType.number
          ? TextInputType.number
          : TextInputType.text,
      style: const TextStyle(fontSize: 14, color: Colors.black),
      decoration: InputDecoration(
        hintText: widget.hintText ?? '请输入',
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(vertical: 6),
        isDense: true,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(238, 238, 238, 1)),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(238, 238, 238, 1)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      validator: (value) {
        widget.onValidator(value);
        if (widget.item.required && (value == null || value.trim().isEmpty)) {
          return '请输入${widget.item.label}';
        }
        return null;
      },
      onChanged: (_) => {
        if (inputval != _) widget.onValidator(_),
        setState(() {
          inputval = _;
        })
      },
    );
  }
}
