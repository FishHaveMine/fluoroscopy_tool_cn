import 'dart:convert';
import 'dart:ffi';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import './bottomSelectSheet.dart';

/// [ initValue ] 传入的是选项value的列表
/// [ changeCallBack ] 修改父类的对象， [ 返回 ] 类型为List<String>的对应选项value列表
/// [ isMultiple ] 是否多选
/// [ title ] 标题
/// [ optionsList ] 选项列表
/// [ isDisable ] 是否可编辑
///
back() {}

/// 单选多选 传入/传出都统一是 List<String> 数组，
class inputSelect extends StatefulWidget {
  var contentPadding;

  inputSelect(
      {Key? key,
      required this.isMultiple,
      required this.changeCallBack,
      required this.title,
      required this.optionsList,
      required this.initValue,
      this.isDismissible = true,
      this.isRequired = true,
      this.contentPadding = const EdgeInsets.fromLTRB(10, 10, 10, 0),
      this.isNormalStyle = true,
      this.showBorder = false,
      this.textColor = const Color.fromRGBO(102, 102, 102, 1),
      this.borderColor = const Color.fromRGBO(0, 0, 0, 0.06),
      this.isDisable = false,
      this.isNormalStyleTextAlign = TextAlign.end,
      this.onValidator = back})
      : super(key: key);
  VoidCallback onValidator = () {};
  bool isDismissible = true;
  bool isRequired = true;
  bool isNormalStyle = true;
  bool showBorder = false;
  bool isDisable = false;
  Color textColor = const Color.fromRGBO(102, 102, 102, 1);
  Color borderColor = const Color.fromRGBO(0, 0, 0, 0.06);
  TextAlign isNormalStyleTextAlign = TextAlign.end;
  final bool isMultiple;
  final String title;
  final List<dynamic> initValue;
  final List<Map<String, dynamic>> optionsList;
  final ValueChanged<dynamic> changeCallBack;
  @override
  State<inputSelect> createState() => _inputSelectState();
}

class _inputSelectState extends State<inputSelect> {
  TextEditingController myController = TextEditingController();
  List<String> labelList = []; // 显示的label列表
  List<String> valueList = []; // 显示的label列表
  List<String> initValueState = []; // 显示的label列表
  bool isNormalStyle = true;
  bool showBorder = false;
  @override
  void initState() {
    super.initState();
    isNormalStyle = widget.isNormalStyle;
    showBorder = widget.showBorder;

    for (var item in widget.initValue) {
      initValueState.add(item.toString());
    }
    widget.optionsList.forEach((item) => {
          valueList.add(item['label'].toString()),
          if (initValueState.indexOf(item['value'].toString()) != -1)
            {labelList.add(item['label'].toString())}
        });
    myController.text =
        labelList.toString().replaceAll('[', '').replaceAll(']', '');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    myController.dispose();
    super.dispose();
  }

  void updataInitValue(value) {
    initValueState = value;
  }

  void handelBack(value, _options) {
    if (value != null && value.baseValue.length > 0) {
      myController.text = '';
      value?.indexValue!.asMap().forEach((key, value) {
        // [ isMultiple ] 为 true 多选，显示多个标签
        if (widget.isMultiple) {
          myController.text += value != -1 && _options[value!] != null
              ? _options[value!]['label'].toString().tr() + ','
              : '';
        } else {
          // [ isMultiple ] 为 false 单选，显示单个标签
          myController.text = value != -1 && _options[value!] != null
              ? _options[value!]['label'].toString().tr()
              : '';
        }
      });
      updataInitValue(value?.baseValue as List<String>);
      widget.changeCallBack(widget.isMultiple
          ? value?.baseValue as List<String>
          : value?.baseValue![0] != null
              ? value?.baseValue![0]
              : '');
    } else {
      widget.changeCallBack(widget.isMultiple ? '' : []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.always,
      onTap: () async {
        if (!widget.isDisable) {
          List<Map<String, dynamic>> _options = widget.optionsList;
          Future<sheetBack?> selectedIndex = await showCustomModalBottomSheet(
              isMultiple: widget.isMultiple,
              isDismissible: widget.isDismissible,
              context,
              _options,
              baseValue: initValueState,
              titleName: widget.title);
          int choose = 0;
          print(selectedIndex);
          selectedIndex.then((value) => {handelBack(value, _options)});
        }
      },
      readOnly: true,
      controller: myController,
      style: TextStyle(color: widget.textColor, fontSize: 14),
      decoration: isNormalStyle
          ? showBorder
              ? InputDecoration(
                  labelText: tr(widget.title),
                  hintText: tr("input.hintText") + tr(widget.title),
                  labelStyle: getTipContent(context),
                  filled: true,
                  fillColor: Theme.of(context).backgroundColor,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ))
              : InputDecoration(
                  labelText: tr(widget.title),
                  hintText: tr("input.hintText") + tr(widget.title),
                  labelStyle: getTipContent(context),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: widget.borderColor)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: widget.borderColor)),
                  // prefixIcon: Icon(Icons.person)
                )
          : InputDecoration(
              isDense: true,
              contentPadding: widget.contentPadding,
              focusColor: Colors.transparent,
              errorBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(width: 0, color: Color.fromRGBO(0, 0, 0, 0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 1.0),
                borderRadius: BorderRadius.circular(0.0),
              ),
              fillColor: Colors.transparent,
            ),
      textAlign:
          isNormalStyle ? TextAlign.start : widget.isNormalStyleTextAlign,
      validator: (String? value) {
        if (widget.isRequired) {
          if (value == null || value.isEmpty || myController.text == '') {
            widget.onValidator();
            return tr("select.hintText");
          } else {
            return null;
          }
        } else {
          return null;
        }
      },
      onSaved: (value) {},
    );
  }
}

TextStyle getTipContent(context) {
  TextStyle titleStyle = TextStyle(
      // 文字颜色
      color: const Color(0xFF666666),
      // none 不显示装饰线条，underline 字体下方，overline 字体上方，lineThrough穿过文字
      decoration: TextDecoration.none,
      // solid 直线，double 双下划线，dotted 虚线，dashed 点下划线，wavy 波浪线
      decorationStyle: TextDecorationStyle.solid,
      // 装饰线的颜色
      decorationColor: Theme.of(context).colorScheme.secondary,
      // 文字大小
      fontSize: 14.0,
      // normal 正常，italic 斜体
      fontStyle: FontStyle.normal,
      // 字体的粗细
      fontWeight: FontWeight.w400,
      // 文字间的宽度
      letterSpacing: 1.0,
      // 文本行与行的高度，作为字体大小的倍数（取值1~2，如1.2）
      height: 1,
      //对齐文本的水平线:
      //TextBaseline.alphabetic：文本基线是标准的字母基线
      //TextBaseline.ideographic：文字基线是表意字基线；
      //如果字符本身超出了alphabetic 基线，那么ideograhpic基线位置在字符本身的底部。
      textBaseline: TextBaseline.alphabetic);
  return titleStyle;
}
