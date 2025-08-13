import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class userinfoController extends GetxController {
  RxList<dynamic> promission = [].obs;
  RxList<dynamic> clound_promission = [].obs;
  RxList<dynamic> local_promission = [].obs;
  void set_userPromission(val) {
    // print("开始读取权限 ${promission.isNotEmpty} (${val})");
    promission.value = val ?? [];
    if (promission.isNotEmpty) {
      for (var element in val) {
        for (var subListelement in element["subList"]) {
          try {
            List subList = subListelement["subList"] ?? [];
            List<String> codes = [];
            if (subList.isNotEmpty) {
              for (var subListItem in subList) {
                codes.add(subListItem["identification"]);
                List subListc = subListItem["subList"] ?? [];
                try {
                  if (subListc.isNotEmpty) {
                    for (var subListcItem in subListc) {
                      codes.add(subListcItem["identification"]);
                    }
                  }
                } catch (e) {
                  print("e: $e");
                }
              }
            }
            print("codes: $codes");
            if (subListelement["name"] == "云端管理") {
              clound_promission.value = codes;
            } else {
              local_promission.value = codes;
            }
          } catch (e) {}
        }
      }
    } else {
      local_promission.value = [];
      clound_promission.value = [];
    }
    print(
        "------------------------------------   ------------------------------------");
    print("云端管理：${clound_promission}");
    print("本地管理：${local_promission}");
    update();
  }

  bool checkLocalPromission(promissionkey, {showtoast = true}) {
    if (promission.value.isEmpty || local_promission.value.isEmpty) {
      if (showtoast) EasyLoading.showError(tr("withoutpromission"));
      return false;
    }
    bool isinpromission = local_promission.contains(promissionkey);
    if (!isinpromission) {
      if (showtoast) EasyLoading.showError(tr("withoutpromission"));
    }
    return isinpromission;
  }

  bool checkCloundPromission(promissionkey, {showtoast = true}) {
    if (promission.value.isEmpty || clound_promission.value.isEmpty) {
      if (showtoast) EasyLoading.showError(tr("withoutpromission"));
      return false;
    }
    bool isinpromission = clound_promission.contains(promissionkey);
    if (!isinpromission) {
      if (showtoast) EasyLoading.showError(tr("withoutpromission"));
    }
    return isinpromission;
  }
}

void extractCodes(Map<String, dynamic> node, List<String> codes) {
  // 提取当前节点的 code
  // print("extractCodes:${node['code']}");
  if (node['code'] != null) {
    codes.add(node['code']);
  }

  // 递归遍历 subList
  if (node.containsKey('subList') && node['subList'] is List) {
    for (var subNode in node['subList']) {
      extractCodes(subNode, codes);
    }
  }
}
