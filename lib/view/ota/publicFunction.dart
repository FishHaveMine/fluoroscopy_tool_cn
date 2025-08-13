import 'package:get/get.dart';

// "afterSalesRe
class otaController extends GetxController {
  RxList selectID = [].obs;
  RxInt selectType = 0.obs;
  RxString uuid = "".obs;

  void setuuid(val) {
    uuid.value = val;
    update();
  }

  var otafirmware = {}.obs;

  void setOtafirmware(val) {
    otafirmware.value = val;
    update();
  }

  void setSelectType(val) {
    selectType.value = val;
    update();
  }

  void setSelectID(val) {
    selectID.value = val;
    update();
  }

  void clearSelectID() {
    selectID.value = [];
    update();
  }
}
