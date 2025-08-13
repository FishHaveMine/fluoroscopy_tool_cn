import 'package:flutter/services.dart';
import 'package:get/get.dart';

class communicationController extends GetxController {
  RxString connectType = ''.obs;
  void setConnectType(val) {
    connectType.value = val;
    update();
  }

  var needSetParameter = {}.obs;
  void saveNeedSetParameter(val) {
    needSetParameter.value = val;
    update();
  }
}
