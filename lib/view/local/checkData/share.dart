import 'dart:convert';
import 'package:get/get.dart';

class checkDataController extends GetxController {
  var tableSelect = [].obs;
  RxInt showingType = 0.obs; // 0,模式控制   1，锁定控制
  RxInt modeSetting = 99.obs; //  模式设定
  RxInt onOff = 3.obs; //  模式设定

  void setOnOff(val) {
    onOff.value = onOff.value != val ? val : 3;
    if (val == 0) {
      modeSetting.value = 99;
      tempSetting.value = 0;
      fanSetting.value = 9;
    }
    update();
  }

  void setModeSetting(val) {
    modeSetting.value = modeSetting.value != val ? val : 99;
    update();
  }

  RxDouble tempSetting = (0.0).obs; //  温度设定
  void setTempSetting(val) {
    tempSetting.value = val;
    update();
  }

  RxInt fanSetting = 9.obs; //  风档设
  void setFanSetting(val) {
    fanSetting.value = val;
    update();
  }

  RxInt unlockon = 2.obs; // 只响应开机
  void setunlockon(val) {
    unlockon.value = val;
    update();
  }

  RxInt unlockoff = 2.obs; // 只响应关机
  void setunlockoff(val) {
    unlockoff.value = val;
    update();
  }

  RxInt unlockwire = 2.obs; // 线控解锁
  void setunlockwire(val) {
    unlockwire.value = val;
    update();
  }

  RxInt unlockremote = 2.obs; // 遥控解锁
  void setunlockremote(val) {
    unlockremote.value = val;
    update();
  }

  RxInt unlockmode = 2.obs; // 模式解锁
  void setunlockmode(val) {
    unlockmode.value = val;
    update();
  }

  void clearSetting() {
    modeSetting.value = 99;
    tempSetting.value = 0.0;
    fanSetting.value = 9;
    unlockon.value = 2;
    unlockoff.value = 2;
    unlockwire.value = 2;
    unlockremote.value = 2;
    unlockmode.value = 2;
  }

  void setShowingType(val) {
    showingType.value = val;
    update();
  }

  void setSelect(val) {
    tableSelect.value = val;
    update();
  }

  void addSelect(val) {
    if (tableSelect.value.contains(val)) {
      tableSelect.value.remove(val);
    } else {
      tableSelect.value.add(val);
    }
    update();
  }
}
