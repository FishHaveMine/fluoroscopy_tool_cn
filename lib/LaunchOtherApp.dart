import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';

class LaunchOtherApp {
  static Future<void> launchFluoroscopyToolEn() async {
    const packageName = 'com.fluoroscopytool.en'; // 替换为实际包名

    final intent = AndroidIntent(
      action: 'android.intent.action.MAIN',
      package: packageName,
      category: 'android.intent.category.DEFAULT',
    );

    try {
      await intent.launch();
    } catch (e) {
      print('无法启动 fluoroscopy_tool_en: $e');
    }
  }
}
