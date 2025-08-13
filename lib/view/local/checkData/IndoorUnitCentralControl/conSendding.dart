import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/view/local/checkData/share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/**
 * 通用按钮
 */
class imageButton extends StatelessWidget {
  String img;
  String? img_active;
  String? text_active;
  String label;
  double imageWidth;
  double? itemWidth;
  bool isActive;
  Function onClick;
  imageButton(
      {super.key,
      required this.img,
      required this.label,
      required this.onClick,
      this.imageWidth = 0,
      this.itemWidth = null,
      this.img_active = null,
      this.text_active = null,
      this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: const Color.fromRGBO(43, 103, 234, 1), // 设置水波纹颜色
      child: SizedBox(
          height: 176.h,
          width: itemWidth != null ? itemWidth : 720.w / 4, // 设置最大宽度,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isActive && text_active != null
                  ? SizedBox(
                      height: imageWidth == 0 ? 80.w : imageWidth,
                      child: Center(
                        child: Text(text_active!,
                            style: TextStyle(
                                color: isActive
                                    ? const Color.fromRGBO(0, 128, 255, 1)
                                    : const Color.fromRGBO(13, 13, 13, 1),
                                fontSize: 24)),
                      ),
                    )
                  : Opacity(
                      opacity: isActive ? 1.0 : 1.0, // 设置透明度，范围从 0.0 到 1.0
                      child: Image.asset(
                        isActive ? img_active ?? img : img,
                        height: imageWidth == 0 ? 80.w : imageWidth,
                      )),
              ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 720.w / 4, // 设置最大宽度
                  ),
                  child: Padding(
                    padding: imageWidth == 0
                        ? const EdgeInsets.fromLTRB(0, 0, 0, 0)
                        : EdgeInsets.fromLTRB(0, 16.h, 0, 0),
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: isActive
                              ? const Color.fromRGBO(0, 128, 255, 1)
                              : const Color.fromRGBO(13, 13, 13, 1),
                          fontSize: 14),
                    ),
                  ))
            ],
          )),
      onTap: () {
        onClick();
      },
    );
  }
}

/**
 * 模式设定
 */
class modeSettingMapItem {
  String name;
  String normalImage;
  String activeImage;

  modeSettingMapItem({
    required this.name,
    required this.normalImage,
    required this.activeImage,
  });
}

// RunMode_0("RunMode_0", "关机", 0, 7, 0, 7),
// RunMode_1("RunMode_1", "送风", 1, 0, 1, 0),
// RunMode_2("RunMode_2", "制冷", 2, 0, 1, 1),
// RunMode_3("RunMode_3", "制热", 3, 0, 1, 2),
// RunMode_6("RunMode_6", "除湿", 6, 0, 1, 3),
// RunMode_7("RunMode_7", "自动", 1, 7, 1, 4);

Map<int, modeSettingMapItem> modeSettingMap = {
  7: modeSettingMapItem(
    name: tr('device.checkData.modeauto'),
    normalImage: 'auto@2x',
    activeImage: 'auto@2x_active',
  ),
  2: modeSettingMapItem(
    name: tr('device.checkData.modecooling'),
    normalImage: 'cooling@2x',
    activeImage: 'cooling@2x_active',
  ),
  6: modeSettingMapItem(
    name: tr('device.checkData.modedehumidify'),
    normalImage: 'dehumidify@2x',
    activeImage: 'dehumidify@2x_active',
  ),
  3: modeSettingMapItem(
    name: tr('device.checkData.modeheating'),
    normalImage: 'heating@2x',
    activeImage: 'heating@2x_active',
  ),
  1: modeSettingMapItem(
    name: tr('device.checkData.modewind'),
    normalImage: 'wind@2x',
    activeImage: 'wind@2x_active',
  )
};

Map<int, modeSettingMapItem> onOffSettingMap = {
  1: modeSettingMapItem(
    name: tr('device.checkData.on'),
    normalImage: 'unlockon@2x',
    activeImage: 'unlockon_active@2x',
  ),
  0: modeSettingMapItem(
    name: tr('device.checkData.off'),
    normalImage: 'unlockoff@2x',
    activeImage: 'unlockoff_active@2x',
  ),
};

void modeSetting(context, {type = 1}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15.0),
        topRight: Radius.circular(15.0),
      ),
    ),
    builder: (BuildContext context) {
      return modeSettingPage(settingtype: type);
    },
  );
}

class MyButton {
  String name;
  String normalImage;
  String activeImage;
  int settingValue;
  Function onClick;

  MyButton({
    required this.name,
    required this.normalImage,
    required this.activeImage,
    required this.settingValue,
    required this.onClick,
  });
}

class modeSettingPage extends StatefulWidget {
  int settingtype = 1; // 1 温度   2 。开关
  modeSettingPage({super.key, this.settingtype = 1});
  @override
  State<modeSettingPage> createState() => _modeSettingPageState();
}

class _modeSettingPageState extends State<modeSettingPage> {
  final checkDataController _checkDataController =
      Get.put(checkDataController());

  List<MyButton> list = [];
  void intlistWidget() {
    if (widget.settingtype == 1) {
      modeSettingMap.forEach((key, item) => {
            list.add(MyButton(
              name: item.name,
              normalImage: item.normalImage,
              activeImage: item.activeImage,
              settingValue: key,
              onClick: () {
                // 点击事件处理
                _checkDataController.setModeSetting(key);
              },
            ))
          });
    }
    if (widget.settingtype == 2) {
      onOffSettingMap.forEach((key, item) => {
            list.add(MyButton(
              name: item.name,
              normalImage: item.normalImage,
              activeImage: item.activeImage,
              settingValue: key,
              onClick: () {
                // 点击事件处理
                _checkDataController.setOnOff(key);
              },
            ))
          });
    }
    setState(() {
      list;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    intlistWidget();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<checkDataController>(
        builder: (_) => Container(
              height: 248.h,
              key: ValueKey(
                  'modeSetting_${_checkDataController.modeSetting.value}_${_checkDataController.onOff.value}'),
              decoration: BoxDecoration(
                color: Colors.white,
                //设置四周圆角 角度
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0)),
                //设置四周边框
                border: Border.all(width: 1, color: Colors.transparent),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0)),
                child: ListView.builder(
                    itemCount: list.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => SizedBox(
                          width: 720.w / list.length,
                          key: ValueKey(
                              'modeSetting${list[index].activeImage}_${_checkDataController.modeSetting.value}_${_checkDataController.onOff.value}'),
                          child: Center(
                            child: imageButton(
                              img:
                                  'public/images/checkData/${list[index].normalImage}.png',
                              img_active:
                                  'public/images/checkData/${list[index].activeImage}.png',
                              isActive: widget.settingtype == 1
                                  ? _checkDataController.modeSetting.value ==
                                      list[index].settingValue
                                  : _checkDataController.onOff.value ==
                                      list[index].settingValue,
                              label: list[index].name,
                              imageWidth: 64.w,
                              onClick: () {
                                list[index].onClick();
                              },
                            ),
                          ),
                        )),
              ),
            ));
  }
}

void tempSetting(context) {
  final checkDataController _checkDataController =
      Get.put(checkDataController());
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15.0),
        topRight: Radius.circular(15.0),
      ),
    ),
    builder: (BuildContext context) {
      return const tempSettingPage();
    },
  ).then((value) {
    // 在这里可以处理弹框关闭后的逻辑
    if (value == null) {
      _checkDataController.setTempSetting(0.0);
    }
  });
}

class tempSettingPage extends StatefulWidget {
  const tempSettingPage({super.key});

  @override
  State<tempSettingPage> createState() => _tempSettingPageState();
}

class _tempSettingPageState extends State<tempSettingPage> {
  double temp = 26.0;
  final double _step = 0.5; // Define custom step size
  final checkDataController _checkDataController =
      Get.put(checkDataController());
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: 260.h,
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                            onTap: () {
                              if (temp - 0.5 >= 16) {
                                setState(() {
                                  temp = temp - 0.5;
                                });
                              }
                            },
                            child: Image.asset(
                              'public/images/checkData/reduce.png',
                              height: 76.w,
                            )),
                        SizedBox(
                          width: 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                temp.toString(),
                                style: deviceCardTemp(context),
                              ),
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Text(
                                    '°C',
                                    style: deviceCardTempUnit(context),
                                  ))
                            ],
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              if (temp + 0.5 <= 30) {
                                setState(() {
                                  temp = temp + 0.5;
                                });
                              }
                            },
                            child: Image.asset(
                              'public/images/checkData/add.png',
                              height: 76.w,
                            )),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    SliderTheme(
                        data: const SliderThemeData(
                          activeTrackColor:
                              Color.fromRGBO(0, 128, 255, 1), // 已激活部分颜色
                          inactiveTrackColor:
                              Color.fromRGBO(242, 242, 242, 1), // 未激活部分颜色
                          thumbColor: Colors.white, // 滑块颜色

                          thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: 23), // 滑块形状
                          overlayShape: RoundSliderThumbShape(
                              enabledThumbRadius: 0), // 滑块覆盖层形状
                          valueIndicatorShape:
                              PaddleSliderValueIndicatorShape(), // 值指示器形状
                          showValueIndicator:
                              ShowValueIndicator.always, // 是否显示值指示器
                          valueIndicatorTextStyle:
                              TextStyle(color: Colors.white), // 值指示器文本样式
                          trackHeight: 38, // 轨道高度
                          activeTickMarkColor:
                              Color.fromRGBO(0, 128, 255, 1), // 激活部分刻度颜色
                          inactiveTickMarkColor:
                              Color.fromRGBO(242, 242, 242, 1), // 未激活部分刻度颜色
                          tickMarkShape: RoundSliderTickMarkShape(
                              tickMarkRadius: 4), // 刻度形状样式
                        ),
                        child: Slider(
                          min: 16,
                          max: 30,
                          divisions: ((30 - 16) / _step)
                              .toInt(), // Calculate number of divisions

                          value: temp,
                          onChanged: (value) {
                            // 拖动改变进度
                            setState(() {
                              temp = (value / _step).round() *
                                  _step; // Round to the nearest step
                            });
                          },
                        ))
                  ])),
          Expanded(
              child: GestureDetector(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                //设置四周边框
                border: Border.all(
                    width: 1, color: const Color.fromRGBO(223, 223, 223, 1)),
              ),
              child: Center(
                child: Text(
                  'determine',
                  style: compentText(context),
                ).tr(),
              ),
            ),
            onTap: () {
              _checkDataController.setTempSetting(temp);
              Navigator.of(context).pop(true);
            },
          ))
        ],
      ),
    );
  }
}

TextStyle deviceCardTemp(context) {
  TextStyle titleStyle = const TextStyle(
      // 文字颜色
      color: Color.fromRGBO(51, 51, 51, 1),
      // none 不显示装饰线条，underline 字体下方，overline 字体上方，lineThrough穿过文字
      decoration: TextDecoration.none,
      // solid 直线，double 双下划线，dotted 虚线，dashed 点下划线，wavy 波浪线
      decorationStyle: TextDecorationStyle.solid,
      // 装饰线的颜色
      // 文字大小
      fontSize: 36.0,
      // normal 正常，italic 斜体
      fontStyle: FontStyle.normal,
      // 字体的粗细
      fontWeight: FontWeight.w600,
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

TextStyle deviceCardTempUnit(context) {
  TextStyle titleStyle = const TextStyle(
      // 文字颜色
      color: Color.fromRGBO(51, 51, 51, 1),
      // none 不显示装饰线条，underline 字体下方，overline 字体上方，lineThrough穿过文字
      decoration: TextDecoration.none,
      // solid 直线，double 双下划线，dotted 虚线，dashed 点下划线，wavy 波浪线
      decorationStyle: TextDecorationStyle.solid,
      // 装饰线的颜色
      // 文字大小
      fontSize: 16.0,
      // normal 正常，italic 斜体
      fontStyle: FontStyle.normal,
      // 字体的粗细
      fontWeight: FontWeight.w600,
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

TextStyle compentText(context) {
  TextStyle titleStyle = const TextStyle(
      // 文字颜色
      color: Color.fromRGBO(0, 128, 255, 1),
      // none 不显示装饰线条，underline 字体下方，overline 字体上方，lineThrough穿过文字
      decoration: TextDecoration.none,
      // solid 直线，double 双下划线，dotted 虚线，dashed 点下划线，wavy 波浪线
      decorationStyle: TextDecorationStyle.solid,
      // 装饰线的颜色
      // 文字大小
      fontSize: 17.0,
      // normal 正常，italic 斜体
      fontStyle: FontStyle.normal,
      // 字体的粗细
      fontWeight: FontWeight.w600,
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

void fanSetting(context) {
  final checkDataController _checkDataController =
      Get.put(checkDataController());
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15.0),
        topRight: Radius.circular(15.0),
      ),
    ),
    builder: (BuildContext context) {
      return const fanSettingPage();
    },
  ).then((value) {
    // 在这里可以处理弹框关闭后的逻辑
    if (value == null) {
      _checkDataController.setFanSetting(9);
    }
  });
  ;
}

class fanSettingPage extends StatefulWidget {
  const fanSettingPage({super.key});

  @override
  State<fanSettingPage> createState() => _fanSettingPageState();
}

class _fanSettingPageState extends State<fanSettingPage> {
  int fun = 5;
  final checkDataController _checkDataController =
      Get.put(checkDataController());
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 360.h,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 260.h,
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                              onTap: () {
                                if (fun - 1 >= 1) {
                                  setState(() {
                                    fun = fun - 1;
                                  });
                                }
                              },
                              child: Image.asset(
                                'public/images/checkData/reduce.png',
                                height: 76.w,
                              )),
                          SizedBox(
                            width: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  fun == 8
                                      ? tr('device.checkData.fanAuto')
                                      : fun.toString(),
                                  style: deviceCardTemp(context),
                                ),
                                Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Text(
                                      '',
                                      style: deviceCardTempUnit(context),
                                    ))
                              ],
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                if (fun + 1 <= 8) {
                                  setState(() {
                                    fun = fun + 1;
                                  });
                                }
                              },
                              child: Image.asset(
                                'public/images/checkData/add.png',
                                height: 76.w,
                              )),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      SliderTheme(
                          data: const SliderThemeData(
                            activeTrackColor:
                                Color.fromRGBO(0, 128, 255, 1), // 已激活部分颜色
                            inactiveTrackColor:
                                Color.fromRGBO(242, 242, 242, 1), // 未激活部分颜色
                            thumbColor: Colors.white, // 滑块颜色

                            thumbShape: RoundSliderThumbShape(
                                enabledThumbRadius: 23), // 滑块形状
                            overlayShape: RoundSliderThumbShape(
                                enabledThumbRadius: 0), // 滑块覆盖层形状
                            valueIndicatorShape:
                                PaddleSliderValueIndicatorShape(), // 值指示器形状
                            showValueIndicator:
                                ShowValueIndicator.always, // 是否显示值指示器
                            valueIndicatorTextStyle:
                                TextStyle(color: Colors.black), // 值指示器文本样式
                            trackHeight: 38, // 轨道高度
                            activeTickMarkColor:
                                Color.fromRGBO(0, 128, 255, 1), // 激活部分刻度颜色
                            inactiveTickMarkColor:
                                Color.fromRGBO(242, 242, 242, 1), // 未激活部分刻度颜色
                            tickMarkShape: RoundSliderTickMarkShape(
                                tickMarkRadius: 4), // 刻度形状样式
                          ),
                          child: Slider(
                            min: 1,
                            max: 8,
                            value: fun.toDouble(),
                            divisions: 7, // 设置分段数量为6，对应7个整数值
                            onChanged: (value) {
                              // 拖动改变进度
                              setState(() {
                                fun = value.toInt();
                              });
                            },
                          )),
                    ]),
              ),
              Expanded(
                  child: GestureDetector(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    //设置四周边框
                    border: Border.all(
                        width: 1,
                        color: const Color.fromRGBO(223, 223, 223, 1)),
                  ),
                  child: Center(
                    child: Text(
                      'determine',
                      style: compentText(context),
                    ).tr(),
                  ),
                ),
                onTap: () {
                  _checkDataController.setFanSetting(fun);
                  Navigator.of(context).pop(true);
                },
              ))
            ]));
  }
}
