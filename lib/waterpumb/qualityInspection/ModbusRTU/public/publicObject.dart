import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class RTUCheckController extends GetxController {
  RxString baudRate = '9600'.obs;
  RxString baudCheck = 'None'.obs;
  RxString baudStop = '1'.obs;

  RxString debugModel = '磁悬浮冷水机组'.obs;
  RxString address = '0'.obs;
  RxString readstart = '3890'.obs;
  RxString readlength = '4'.obs;
}
