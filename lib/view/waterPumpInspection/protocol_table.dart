import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_table/table_sticky_headers.dart';

class protocolTablePage extends StatefulWidget {
  List reportdata;
  protocolTablePage({super.key, required this.reportdata});
  @override
  State<protocolTablePage> createState() => _protocolTablePageState();
}

class _protocolTablePageState extends State<protocolTablePage> {
  List titleColumn = [
    'waterPump.table.result',
    'waterPump.table.mode',
    'waterPump.table.open',
    'waterPump.table.speed',
    'waterPump.table.feedback'
  ];
  List titleRow = [];
  List data = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() {
    if (widget.reportdata.isNotEmpty) {
      for (var element in widget.reportdata) {
        titleRow.add('${element['address']}#');
        data.add([
          element['result'] != null ? element['result'].toString() : "",
          '${tr(element['mode1'].toString())}-${tr(element['mode2'].toString())}',
          '${tr("waterPump.table.open.${element['open1']}")}-${tr("waterPump.table.open.${element['open2'].toString()}")}',
          '${tr(element['speed1'].toString())}-${tr(element['speed2'].toString())}',
          '${tr("waterPump.table.feedback.${element['feedback1']}")}-${tr("waterPump.table.feedback.${element['feedback2']}")}',
        ]);
      }
      setState(() {
        titleRow;
        data;
      });
    }
  }

  int? selectedRow;
  int? selectedColumn;
  Color getContentColor(int i, int j) {
    if (i == selectedRow && j == selectedColumn) {
      return const Color.fromRGBO(18, 80, 123, 0.3);
    } else if (i == selectedRow || j == selectedColumn) {
      return const Color.fromRGBO(18, 80, 123, 0.1);
    } else {
      return Colors.transparent;
    }
  }

  bool isLandscape = false;

  void _toggleOrientation() {
    if (isLandscape) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }

    setState(() {
      isLandscape = !isLandscape;
    });
  }

  @override
  void dispose() {
    // Reset the orientation to the default when the page is disposed.
    SystemChrome.setPreferredOrientations([]);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  List<double> rowHeightsList(leng) {
    List<double> out = [];
    for (var i = 0; i < leng; i++) {
      out.add(50.0);
    }
    return out;
  }

  Widget handelselfTabelRow(val, key) {
//  'waterPump.table.result',
//  'waterPump.table.mode',
//  'waterPump.table.open',
//  'waterPump.table.speed',
//  'waterPump.table.feedback'
    if (key == 'waterPump.table.result') {
      return Center(
        child: Text(
          val == "" ? "--" : 'waterPump.table.result.$val',
          style: tableSetValue(
              fontcolor: val == '0'
                  ? const Color.fromRGBO(255, 51, 103, 1)
                  : const Color.fromRGBO(136, 136, 136, 1)),
        ).tr(),
      );
    }
    if (key == 'waterPump.table.mode') {
      return Center(
        child: Text(
          val,
          style:
              tableSetValue(fontcolor: const Color.fromRGBO(136, 136, 136, 1)),
        ),
      );
    }

    if (key == 'waterPump.table.open') {
      return Center(
        child: Text(
          '$val',
          style: tableSetValue(),
        ),
      );
    }

    if (key == 'waterPump.table.feedback') {
      return Center(
        child: Text(
          '$val',
          style: tableSetValue(),
        ),
      );
    }
    return Center(
      child: Text(
        val,
        style: tableValue(context),
      ),
    );
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
            icon:
                const Icon(Icons.chevron_left, color: Colors.black, size: 36)),
        title: const Text(
          'waterPump.title',
          style: TextStyle(color: Colors.black),
        ).tr(),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: GestureDetector(
              child: Image.asset(
                'public/images/waterPump/switch.png',
                width: 24,
              ),
              onTap: () {
                _toggleOrientation();
              },
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 24.h, 0, 24.h),
        child: Container(
          color: Colors.white,
          child: StickyHeadersTable(
            key: ValueKey('isLandscape:$isLandscape'),
            cellDimensions: CellDimensions.variableColumnWidthAndRowHeight(
                columnWidths: [80, 120, 80, 80, 200],
                rowHeights: rowHeightsList(titleRow.length),
                stickyLegendWidth: 120,
                stickyLegendHeight: 80),
            columnsLength: titleColumn.length,
            rowsLength: titleRow.length,
            columnsTitleBuilder: (i) => Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromRGBO(223, 223, 223, 1), // 边框颜色
                  width: 0.5, // 边框宽度
                ),
                borderRadius: BorderRadius.circular(0.0), // 圆角半径
              ),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  //   child: Image.asset(
                  //     i == 0
                  //         ? 'public/images/waterPump/greenpin.png'
                  //         : 'public/images/waterPump/pin.png',
                  //     width: 16,
                  //   ),
                  // ),
                  Text(
                    tr(titleColumn[i]),
                    style: tableLabel(context),
                  )
                ],
              )),
            ),
            rowsTitleBuilder: (i) => Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromRGBO(223, 223, 223, 1), // 边框颜色
                  width: 0.5, // 边框宽度
                ),
                borderRadius: BorderRadius.circular(0.0), // 圆角半径
              ),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Text(titleRow[i], style: tableLabel(context)),
                  )
                ],
              )),
            ),
            contentCellBuilder: (i, j) => Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromRGBO(223, 223, 223, 1), // 边框颜色
                  width: 0.5, // 边框宽度
                ),
                borderRadius: BorderRadius.circular(0.0), // 圆角半径
              ),
              child: handelselfTabelRow(data[j][i], titleColumn[i]),
            ),
            legendCell: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromRGBO(223, 223, 223, 1), // 边框颜色
                    width: 0.5, // 边框宽度
                  ),
                  borderRadius: BorderRadius.circular(0.0), // 圆角半径
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 21, 0, 0),
                        child: Text('IndoorUnitParameters.address',
                                style: tableLabel(context))
                            .tr(),
                      )
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}

TextStyle tableLabel(context) {
  return const TextStyle(
      color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400);
}

TextStyle tableValue(context) {
  return const TextStyle(
      color: Color.fromRGBO(136, 136, 136, 1),
      fontSize: 12,
      fontWeight: FontWeight.w400);
}

TextStyle tableSetValue(
    {double fSize = 12,
    Color fontcolor = const Color.fromRGBO(136, 136, 136, 1)}) {
  return TextStyle(
      color: fontcolor, fontSize: fSize, fontWeight: FontWeight.w400);
}
