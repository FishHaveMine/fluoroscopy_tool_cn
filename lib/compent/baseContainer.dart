/*
 * @Author: FishHaveMine 751174479@qq.com
 * @Date: 2024-06-08 14:53:16
 * @LastEditors: FishHaveMine 751174479@qq.com
 * @LastEditTime: 2024-06-08 14:54:34
 * @FilePath: /fluoroscopy_tool/lib/compent/baseContainer.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class baseContainer extends StatelessWidget {
  Widget child;
  baseContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(32.w, 0, 32.w, 28.h), child: child);
  }
}
