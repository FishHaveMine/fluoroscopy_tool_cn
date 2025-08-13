import 'package:flutter/material.dart';

import '../public/publicObject.dart';

import 'package:get/get.dart';

import 'coolingtable.dart';

class coolingWatertable extends StatefulWidget {
  const coolingWatertable({super.key});

  @override
  State<coolingWatertable> createState() => _coolingWatertableState();
}

class _coolingWatertableState extends State<coolingWatertable> {
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
                          child: const Text('项目'),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          color: const Color.fromRGBO(216, 216, 216, 0.2),
                          padding: const EdgeInsets.all(8.0),
                          child: const Text('PH值'),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          color: const Color.fromRGBO(216, 216, 216, 0.2),
                          padding: const EdgeInsets.all(8.0),
                          child: const Text('电导率'),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          color: const Color.fromRGBO(216, 216, 216, 0.2),
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: const [
                              Text('*',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 14)),
                              Text('是否清澈')
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // 冷冻水
                  TableRow(
                    children: [
                      TableCell(
                        child: Container(
                          height: 100,
                          color: const Color.fromRGBO(216, 216, 216, 0.2),
                          padding: const EdgeInsets.all(8.0),
                          child: const Center(
                            child: Text('冷冻水'),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          height: 100,
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: tableInput(
                            readOnly: _.ispreview.value,
                            item: _.form['chilledWaterPH'],
                            onValidator: (val) {
                              _.form['chilledWaterPH'].val = val ?? "";
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
                                item: _.form['chilledWaterConductivity'],
                                onValidator: (val) {
                                  _.form['chilledWaterConductivity'].val =
                                      val ?? "";
                                },
                              ),
                            )),
                      ),
                      TableCell(
                        child: Column(
                          children: [
                            ..._.form['isChilledWaterClear'].op!.map((op) {
                              return Row(
                                children: [
                                  Radio<String>(
                                    activeColor:
                                        const Color.fromRGBO(0, 128, 255, 1),
                                    focusColor:
                                        const Color.fromRGBO(0, 128, 255, 1),
                                    value: op.val,
                                    groupValue:
                                        _.form['isChilledWaterClear'].val,
                                    onChanged: _.ispreview.value
                                        ? null
                                        : (newValue) {
                                            if (_.form['isChilledWaterClear']
                                                    .val ==
                                                newValue) {
                                              _.form['isChilledWaterClear']
                                                  .val = "";
                                            } else {
                                              _.form['isChilledWaterClear']
                                                  .val = newValue!;
                                            }
                                            _.update();
                                          },
                                  ),
                                  InkWell(
                                    onTap: _.ispreview.value
                                        ? null
                                        : () {
                                            if (_.form['isChilledWaterClear']
                                                    .val ==
                                                op.val) {
                                              _.form['isChilledWaterClear']
                                                  .val = "";
                                            } else {
                                              _.form['isChilledWaterClear']
                                                  .val = op.val;
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
                    ],
                  ),
                  // 冷却水
                  TableRow(
                    children: [
                      TableCell(
                        child: Container(
                          height: 100,
                          color: const Color.fromRGBO(216, 216, 216, 0.2),
                          padding: const EdgeInsets.all(8.0),
                          child: const Center(
                            child: Text('冷却水'),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          height: 100,
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: tableInput(
                            readOnly: _.ispreview.value,
                            item: _.form['coolingWaterPH'],
                            onValidator: (val) {
                              _.form['coolingWaterPH'].val = val ?? "";
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
                            item: _.form['coolingWaterConductivity'],
                            onValidator: (val) {
                              _.form['coolingWaterConductivity'].val =
                                  val ?? "";
                            },
                          )),
                        ),
                      ),
                      TableCell(
                        child: Column(
                          children: [
                            ..._.form['isCoolingWaterClear'].op!.map((op) {
                              return Row(
                                children: [
                                  Radio<String>(
                                    activeColor:
                                        const Color.fromRGBO(0, 128, 255, 1),
                                    focusColor:
                                        const Color.fromRGBO(0, 128, 255, 1),
                                    value: op.val,
                                    groupValue:
                                        _.form['isCoolingWaterClear'].val,
                                    onChanged: _.ispreview.value
                                        ? null
                                        : (newValue) {
                                            if (_.form['isCoolingWaterClear']
                                                    .val ==
                                                newValue) {
                                              _.form['isCoolingWaterClear']
                                                  .val = "";
                                            } else {
                                              _.form['isCoolingWaterClear']
                                                  .val = newValue!;
                                            }
                                            _.update();
                                          },
                                  ),
                                  InkWell(
                                    onTap: _.ispreview.value
                                        ? null
                                        : () {
                                            if (_.form['isCoolingWaterClear']
                                                    .val ==
                                                op.val) {
                                              _.form['isCoolingWaterClear']
                                                  .val = "";
                                            } else {
                                              _.form['isCoolingWaterClear']
                                                  .val = op.val;
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
                    ],
                  ),
                ],
              ),
            ));
  }
}
