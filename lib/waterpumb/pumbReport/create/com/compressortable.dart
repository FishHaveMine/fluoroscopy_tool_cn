import 'package:flutter/material.dart';

import '../public/publicObject.dart';

import 'package:get/get.dart';

import 'coolingtable.dart';

class compressortable extends StatefulWidget {
  const compressortable({super.key});

  @override
  State<compressortable> createState() => _compressortableState();
}

class _compressortableState extends State<compressortable> {
  // 用于存储表单数据

  List<String> items = ['compressor1', 'compressor2', 'compressor3'];
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
                          child: Text(
                            'Displace',
                            style: tip,
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          color: const Color.fromRGBO(216, 216, 216, 0.2),
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'AZ',
                            style: tip,
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          color: const Color.fromRGBO(216, 216, 216, 0.2),
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'FX',
                            style: tip,
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          color: const Color.fromRGBO(216, 216, 216, 0.2),
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'FY',
                            style: tip,
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          color: const Color.fromRGBO(216, 216, 216, 0.2),
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'RX',
                            style: tip,
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          color: const Color.fromRGBO(216, 216, 216, 0.2),
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'RY',
                            style: tip,
                          ),
                        ),
                      ),
                    ],
                  ),
                  for (var i = 0; i < items.length; i++) ...[
                    TableRow(
                      children: [
                        TableCell(
                          child: Container(
                            height: 50,
                            color: const Color.fromRGBO(216, 216, 216, 0.2),
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                '${i + 1}#机头',
                                style: tip,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: tableInput(
                              readOnly: _.ispreview.value,
                              item: _.form['compressor${i + 1}AZ'],
                              onValidator: (val) {
                                _.form['compressor${i + 1}AZ'].val = val ?? "";
                              },
                            )),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: tableInput(
                              readOnly: _.ispreview.value,
                              item: _.form['compressor${i + 1}FX'],
                              onValidator: (val) {
                                _.form['compressor${i + 1}FX'].val = val ?? "";
                              },
                            )),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: tableInput(
                              readOnly: _.ispreview.value,
                              item: _.form['compressor${i + 1}FY'],
                              onValidator: (val) {
                                _.form['compressor${i + 1}FY'].val = val ?? "";
                              },
                            )),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: tableInput(
                              readOnly: _.ispreview.value,
                              item: _.form['compressor${i + 1}RX'],
                              onValidator: (val) {
                                _.form['compressor${i + 1}RX'].val = val ?? "";
                              },
                            )),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: tableInput(
                              readOnly: _.ispreview.value,
                              item: _.form['compressor${i + 1}RY'],
                              onValidator: (val) {
                                _.form['compressor${i + 1}RY'].val = val ?? "";
                              },
                            )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ));
  }
}
