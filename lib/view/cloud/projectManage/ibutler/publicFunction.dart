import 'dart:convert';
import 'package:get/get.dart';

class activateContractController extends GetxController {
  var card = {}.obs;
  var orderNo = "".obs;
  // 动态设置值的方法
  void init() {
    card.value = {}; // 更新 deviceType
    orderNo.value = ""; // 更新 deviceType
    update(); // 更新状态
  }

// 动态设置值的方法
  void updateOrderNod(newType) {
    orderNo.value = newType; // 更新 deviceType
    update(); // 更新状态
  }

// 动态设置值的方法
  void updateCard(newType) {
    print("newType: $newType");
    card.value = newType; // 更新 deviceType
    update(); // 更新状态
  }
}
