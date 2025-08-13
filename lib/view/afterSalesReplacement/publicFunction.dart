import 'package:flutter/services.dart';
import 'package:get/get.dart';

// "afterSalesReplacement.connectType1": "工装连接V8外机主板",
// "afterSalesReplacement.connectType2": "工装连接V8外机模块板",
// "afterSalesReplacement.connectType3": "工装连接V8内机主板",
// "afterSalesReplacement.connectType4": "工装连接V8全热交换器主板",
List connectType = [
  'afterSalesReplacement.connectType1',
  'afterSalesReplacement.connectType2',
  'afterSalesReplacement.connectType3',
  'afterSalesReplacement.connectType4',
];

// "afterSalesReplacement.NewBoardParameter1": "室外机模块板",
// "afterSalesReplacement.NewBoardParameter2": "室外机主板",
// "afterSalesReplacement.NewBoardParameter3": "室内机主板",
// "afterSalesReplacement.NewBoardParameter4": "全热交换器主板",
List NewBoardParameterList = [
  "afterSalesReplacement.NewBoardParameter1",
  "afterSalesReplacement.NewBoardParameter2",
  "afterSalesReplacement.NewBoardParameter3",
  "afterSalesReplacement.NewBoardParameter4",
];

class afterSalesReplacementController extends GetxController {
  RxString connectType = ''.obs;
  RxString parameterWritingSn = ''.obs;
  RxString parameterWritingParameter = ''.obs;
  RxMap needSetParameter = {}.obs;
  RxMap codeParameter = {}.obs;
  void setCodeParameter(val) {
    codeParameter.value = val;
    update();
  }

  RxString NewBoardParameterType = ''.obs;
  void setConnectType(val) {
    connectType.value = val;
    update();
  }

  void setNewBoardParameterType(val) {
    NewBoardParameterType.value = val;
    update();
  }

  void setParameterWritingSn(val) {
    parameterWritingSn.value = val;
    update();
  }

  void setParameterWritingParameter(val) {
    parameterWritingParameter.value = val;
    update();
  }

  void setNeedSetParameter(val) {
    print("needSetParameter save : $val");
    needSetParameter.value = val;
    update();
  }
}

class MinMaxTextInputFormatter extends TextInputFormatter {
  final double min;
  final double max;

  MinMaxTextInputFormatter(this.min, this.max);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final double? value = double.tryParse(newValue.text);
    final double? oldvalue = double.tryParse(oldValue.text);
    if (value == null) {
      return TextEditingValue(
        text: '',
      );
    }
    if (value < min) {
      return TextEditingValue(
        text: oldvalue == null ? min.toString() : oldvalue.toString(),
        selection: TextSelection.collapsed(
            offset: oldvalue == null ? 1 : oldvalue.toString().length),
      );
    } else if (value > max) {
      return TextEditingValue(
        text: max.toString(),
        selection: TextSelection.collapsed(offset: max.toString().length),
      );
    }
    return newValue;
  }
}

class MinMaxTextInputIntFormatter extends TextInputFormatter {
  final int min;
  final int max;

  MinMaxTextInputIntFormatter(this.min, this.max);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int? value = int.tryParse(newValue.text);
    final int? oldvalue = int.tryParse(oldValue.text);
    if (value == null) {
      return TextEditingValue(
          text: newValue.text == '-' ? newValue.text : '',
          selection: TextSelection.collapsed(
              offset: newValue.text == '-' ? newValue.text.length : 0));
    }

    if (value < min) {
      return TextEditingValue(
        text: oldvalue == null ? min.toString() : oldvalue.toString(),
        selection: TextSelection.collapsed(
            offset: oldvalue == null ? 1 : oldvalue.toString().length),
      );
    } else if (value > max) {
      return TextEditingValue(
        text: max.toString(),
        selection: TextSelection.collapsed(offset: max.toString().length),
      );
    }
    return newValue;
  }
}
