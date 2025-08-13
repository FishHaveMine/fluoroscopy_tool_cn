/*
 * @Author: FishHaveMine 751174479@qq.com
 * @Date: 2024-06-04 17:59:01
 * @LastEditors: FishHaveMine 751174479@qq.com
 * @LastEditTime: 2024-06-05 09:26:50
 * @FilePath: /fluoroscopy_tool/lib/compent/fontSetting.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:fluoroscopy_tool/store/TextScaleController.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:easy_localization/easy_localization.dart';

import '../store/globalData.dart';
import 'bottomSelectSheet.dart';

import 'package:get/get.dart';

import 'package:get/get.dart';

class fontSetting extends StatefulWidget {
  const fontSetting({super.key});

  @override
  State<fontSetting> createState() => _fontSettingState();
}

class _fontSettingState extends State<fontSetting> {
  Future<void> changeFont(
      context, activeFonta, Set<Null> Function(dynamic val) param2) async {
    // Future<sheetBack?> selectedIndex = await showCustomModalBottomSheet(
    //     isMultiple: false,
    //     context,
    //     [
    //       {
    //         'label': tr('font.PingFangMedium'),
    //         'name': tr('font.PingFangMedium'),
    //         'value': 'PingFangMedium'
    //       },
    //       {'label': tr('font.Test'), 'name': tr('font.Test'), 'value': 'Test'},
    //       {
    //         'label': tr('font.hongmengsansscmediumziti'),
    //         'name': tr('font.hongmengsansscmediumziti'),
    //         'value': 'hongmengsansscmediumziti'
    //       },
    //     ],
    //     // ignore: unrelated_type_equality_checks
    //     baseValue: [activeFonta],
    //     titleName: tr('chooseLangage'));
    // selectedIndex.then((value) => {
    //       if (value != null) {param2(value.baseValue![0])}
    //     });
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    print('textScaleFactor:$textScaleFactor');
    Future<sheetBack?> selectedIndex = await showCustomModalBottomSheet(
        isMultiple: false,
        context,
        [
          {
            'label': tr('self.textScaleFactor1'),
            'name': tr('self.textScaleFactor1'),
            'value': 1.0
          },
          {
            'label': tr('self.textScaleFactor2'),
            'name': tr('self.textScaleFactor2'),
            'value': 1.1
          },
          {
            'label': tr('self.textScaleFactor3'),
            'name': tr('self.textScaleFactor3'),
            'value': 1.2
          },
        ],
        // ignore: unrelated_type_equality_checks
        baseValue: [textScaleFactor.toString()],
        titleName: tr('settextScaleFactor'));
    selectedIndex.then((value) => {
          if (value != null)
            {
              Get.find<TextScaleController>()
                  .settextScaleFactor(double.parse(value.baseValue![0]))
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    String activeFonta = context.watch<GlobalData>().activeFonta;

    setFont(val) {
      context.read<GlobalData>().setGlobalData_activeFonta(val);
    }

    return ListTile(
      onTap: () {
        changeFont(context, activeFonta, (val) => {setFont(val)});
      },
      leading: Image.asset(
        'public/images/icon/icon_Font.png',
        height: 48.w,
      ),
      title: Text('menu_Font').tr(),
      trailing: Image.asset(
        'public/images/icon/rightP.png',
        height: 48.w,
      ),
    );
  }
}
