// ignore: depend_on_referenced_packages
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:get/get.dart';

class TextScaleController extends GetxController {
  RxDouble textScaleFactor = 1.0.obs;

  void settextScaleFactor(val) {
    print('settextScaleFactor: $val');
    textScaleFactor.value = val;

    print('settextScaleFactor: ---  ${textScaleFactor.value}');
    update();
  }

  void increaseTextScaleFactor() {
    textScaleFactor.value += 0.1;
    update();
  }

  void decreaseTextScaleFactor() {
    textScaleFactor.value -= 0.1;
    update();
  }
}
