import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class tryResultSimple extends StatefulWidget {
  tryResultSimple({super.key});

  @override
  State<tryResultSimple> createState() => _tryResultSimpleState();
}

class _tryResultSimpleState extends State<tryResultSimple> {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildMachineCard() {
    return Container(
        width: 155,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F7F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'public/images/tryResultSimple/device.png',
                width: 40,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '主网关SN：20HP',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 6),
            Container(
                child: Text(
              '序列号：0000000000000000000000000000000000',
              style: TextStyle(color: Colors.black87, fontSize: 13),
            )),
            const SizedBox(height: 6),
            Container(
              child:
                  Text('型号: MDV-560WD2SN1-8V2', style: TextStyle(fontSize: 13)),
            ),
            const SizedBox(height: 6),
            const Text('气温: 35', style: TextStyle(fontSize: 13)),
            const SizedBox(height: 6),
            const Text('静压设置: 40Pa', style: TextStyle(fontSize: 13)),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.chevron_left,
                  color: Colors.black, size: 36)),
          title: const Text(
            '简易版报告',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: const [],
        ),
        body: Container(
          height: 1280.h,
          padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Image.asset(
                      'public/images/tryResultSimple/banner.png',
                      width: 720.w,
                    ),
                  ),
                ),
                Container(
                  width: 720.w,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      // 179deg ≈ from top to bottom with a slight tilt
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF8EE4FE),
                        Color(0xFF9BB2F4),
                      ],
                      stops: [0.12, 1.0], // 对应 CSS 中的 12% 和 100%
                    ),
                  ),
                  child: Column(
                    children: [
                      cardbox(
                        title: "试运转",
                        con: Container(
                          child: Column(
                            children: [
                              Text(
                                "运行结果",
                                style: titleNormal(),
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0, 16.h, 0, 16.h),
                                  child: Image.asset(
                                      'public/images/afterSalesReplacement/success.png',
                                      width: 120.w)),
                              Text(
                                "通过",
                                style: valNormal(),
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0, 30.h, 0, 30.h),
                                  child: const Divider(
                                      height: 1,
                                      color:
                                          Color.fromRGBO(151, 151, 151, 0.6))),
                              Center(
                                child: SizedBox(
                                  width: 720.w / 1.8,
                                  child: Column(
                                    children: [
                                      rowinfo(
                                        label: '运转时间:',
                                        val: '2022-04-15  11:05',
                                      ),
                                      rowinfo(
                                        label: '室外气温:',
                                        val: '35℃',
                                      ),
                                      rowinfo(
                                        label: '室内温度:',
                                        val: '32℃',
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      cardbox(
                        title: "系统配比率",
                        con: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                "131.2%",
                                style: titleNormal(fSize: 22.0),
                              ),
                            ),
                            Text(
                              "配比率=内机总能力/外机总能力*100%",
                              style: valNormal(fSize: 14.0),
                            ),
                            warningtext(
                              text: '外机配比超过130%，系统全开机运行时将被强制低风速运转，如在意请联系收货处理',
                            )
                          ],
                        ),
                      ),
                      cardbox(
                        title: "管线情况",
                        con: Container(
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // ✅ 左侧绿色按钮
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xFF00D2A2), // 自定义绿色
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                ),
                                icon: const Icon(Icons.check,
                                    color: Colors.white, size: 20),
                                label: const Text(
                                  '截止阀开启',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                onPressed: () {},
                              ),

                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(12, 0.h, 12, 0.h),
                                  child: Container(
                                      width: 1,
                                      height: 34,
                                      color: const Color.fromRGBO(
                                          151, 151, 151, 0.6))),

                              // ✅ 右侧边框按钮
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.grey.shade400),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                ),
                                onPressed: () {},
                                child: const Text(
                                  '管线一致性',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      cardbox(
                        title: "制冷系统关键参数",
                        con: Container(
                          child: Column(
                            children: [
                              const SizedBox(height: 30),
                              const ProgressBarItem(
                                label: '低压压力',
                                value: 0.3,
                                color: Colors.blue,
                              ),
                              const SizedBox(height: 30),
                              const ProgressBarItem(
                                label: '高压压力',
                                value: 0.65,
                                color: Colors.cyan,
                              ),
                              const SizedBox(height: 30),
                              const ProgressBarItem(
                                label: '排气过热度',
                                value: 0.35,
                                color: Colors.deepOrange,
                              ),
                              const SizedBox(height: 30),
                              Container(
                                width: double.infinity,
                                child: Text(
                                  '冷媒量',
                                  style: lableNormal(),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const SegmentSelector(
                                labels: ['少', '正常', '多'],
                                colors: [
                                  Colors.orange,
                                  Color(0xFF00C6A9),
                                  Colors.redAccent,
                                ],
                                selectedIndex: 2,
                              ),
                              const SizedBox(height: 30),
                              Container(
                                width: double.infinity,
                                child: Text(
                                  '外机散热',
                                  style: lableNormal(),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const SegmentSelector(
                                labels: ['少', '正常', '多'],
                                colors: [
                                  Colors.orange,
                                  Color(0xFF00C6A9),
                                  Colors.redAccent,
                                ],
                                selectedIndex: 0,
                              )
                            ],
                          ),
                        ),
                      ),
                      cardbox(
                        title: "电参数",
                        con: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                chartsdiv(
                                  max: '460',
                                  text: '360V',
                                  value: '360',
                                ),
                                chartsdiv(
                                  max: '75',
                                  text: '25A',
                                  value: '25',
                                ),
                              ],
                            ),
                            warningtext(
                              text: '检测到电压偏离铭牌值超过10%，请检查供电电压',
                            )
                          ],
                        ),
                      ),
                      cardbox(
                        title: "4G网关",
                        con: Column(
                          children: [
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GatewayStatusCard(
                                  sn: '1234566',
                                  signalStatus: '差',
                                  signalColor: Colors.red,
                                ),
                                GatewayStatusCard(
                                  sn: '1234566',
                                  signalStatus: '好',
                                  signalColor: Colors.blue,
                                ),
                              ],
                            ),
                            warningtext(
                              text:
                                  '检测到4G信号偏差，建议安装中国移动4G信号增强接受放大器，否则可能会影响云集控操作和响应',
                            )
                          ],
                        ),
                      ),
                      cardbox(
                          title: "外机信息",
                          con: Container(
                            width: double.infinity,
                            height: 360,
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  const Text("外机台数：2",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  const Text("系统总能力：32HP",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildMachineCard(),
                                      _buildMachineCard()
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )),
                      cardbox(
                        title: "内机信息",
                        con: Column(
                          children: [
                            chartsdiv1(
                              text1: '内机台数: 20',
                              text2: '总能力: 42HP',
                              value: '80',
                            ),
                            warningtext(
                              text: '检测到系统中连接了旧内机，请注意这些内机不支持单独掉电，否则将引起系统故障',
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class cardbox extends StatelessWidget {
  String title;
  Widget con;
  cardbox({super.key, required this.title, required this.con});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 720.w - 80.w,
          padding: EdgeInsets.fromLTRB(26.w, 45, 26.w, 26.w),
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
          decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 255, 255, 1),
              border: Border.all(
                color: const Color.fromRGBO(255, 255, 255, 1),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20)),
          child: con,
        ),
        Positioned(
          child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  // 153deg ≈ (0.89, -0.45) 向左下倾斜
                  begin: Alignment.topLeft,
                  end: Alignment(0.89, 1), // 斜角方向调整近似153°
                  colors: [
                    Color(0xFF39B3F3),
                    Color(0xFF007CFF),
                  ],
                  stops: [0.0, 0.74], // 对应 0% 到 74%
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(0),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(36.w, 10, 36.w, 10),
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              )),
        )
      ],
    );
  }
}

TextStyle titleNormal({fSize: 16.0, fw: FontWeight.w600}) {
  // ignore: prefer_const_constructors
  TextStyle titleStyle = TextStyle(
      // 文字颜色
      color: const Color.fromRGBO(43, 52, 72, 1),
      // 文字大小
      fontSize: fSize,
      fontStyle: FontStyle.normal,
      fontWeight: fw,
      letterSpacing: 1.0,
      height: 1,
      textBaseline: TextBaseline.alphabetic);
  return titleStyle;
}

TextStyle valNormal({fSize: 16.0, fw: FontWeight.w400}) {
  // ignore: prefer_const_constructors
  TextStyle titleStyle = TextStyle(
      // 文字颜色
      color: const Color.fromRGBO(126, 126, 126, 1),
      // 文字大小
      fontSize: fSize,
      fontStyle: FontStyle.normal,
      fontWeight: fw,
      letterSpacing: 1.0,
      height: 1,
      textBaseline: TextBaseline.alphabetic);
  return titleStyle;
}

TextStyle lableNormal({fSize: 14.0, fw: FontWeight.w600}) {
  // ignore: prefer_const_constructors
  TextStyle titleStyle = TextStyle(
      // 文字颜色
      color: const Color.fromRGBO(89, 89, 89, 1),
      // 文字大小
      fontSize: fSize,
      fontStyle: FontStyle.normal,
      fontWeight: fw,
      letterSpacing: 1.0,
      height: 1,
      textBaseline: TextBaseline.alphabetic);
  return titleStyle;
}

TextStyle warnNormal({fSize: 12.0, fw: FontWeight.w600}) {
  // ignore: prefer_const_constructors
  TextStyle titleStyle = TextStyle(
      // 文字颜色
      color: const Color.fromRGBO(255, 133, 25, 1),
      // 文字大小
      fontSize: fSize,
      fontStyle: FontStyle.normal,
      fontWeight: fw,
      letterSpacing: 1.0,
      height: 1.5,
      textBaseline: TextBaseline.alphabetic);
  return titleStyle;
}

class rowinfo extends StatelessWidget {
  String label;
  String val;
  rowinfo({super.key, required this.label, required this.val});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 16.h, 0, 16.h),
        child: Row(
          children: [
            Text(
              label,
              style: lableNormal(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Text(val, style: valNormal(fSize: 14.0)),
            )
          ],
        ));
  }
}

class warningtext extends StatelessWidget {
  String text;
  warningtext({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              const Icon(
                Icons.info,
                color: Color.fromRGBO(255, 133, 25, 1),
              ),
              const SizedBox(width: 15), // 替代 Padding 更简洁
              Expanded(
                // 关键点：让 Text 可用剩余空间自动换行
                child: Text(
                  text,
                  style: warnNormal(),
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressBarItem extends StatelessWidget {
  final String label;
  final double value; // 0 ~ 1
  final Color color;

  const ProgressBarItem({
    Key? key,
    required this.label,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: lableNormal(),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 6,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            backgroundColor: const Color.fromRGBO(229, 229, 229, 0.6),
          ),
        ),
      ],
    );
  }
}

class SegmentSelector extends StatelessWidget {
  final List<String> labels;
  final List<Color> colors;
  final int selectedIndex;

  const SegmentSelector({
    Key? key,
    required this.labels,
    required this.colors,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double itemWidth = MediaQuery.of(context).size.width / labels.length;

    return Column(
      children: [
        Row(
          children: List.generate(labels.length, (index) {
            BorderRadius radius = BorderRadius.zero;
            if (index == 0) {
              radius = const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              );
            } else if (index == labels.length - 1) {
              radius = const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              );
            }

            return Expanded(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      left: index == 0 ? 0 : 4,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: colors[index],
                      borderRadius: radius,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        labels[index],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Image.asset(
                      'public/images/tryResultSimple/selected.png',
                      width: 36,
                      color: index == selectedIndex
                          ? colors[selectedIndex]
                          : Colors.white,
                    ),
                  )
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class chartsdiv extends StatelessWidget {
  String value;
  String max;
  String text;
  chartsdiv(
      {super.key, required this.value, required this.max, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 147,
      child: Echarts(
        reloadAfterInit: true,
        captureAllGestures: true,
        extraScript: '''
    var value = '4.3';
   var subtext = '';
   var max = 5;
                  ''',
        option: '''{
       title: {
           show: true,
           text: "$text",
           subtext,
           subtextStyle: {
               align: "center",
           },
           left: "${60 - (text.length / 2) * 13}",
           bottom: 20,
           textStyle: {
               color: '#414957',
               fontSize: 16,
               align: 'center',
               fontFamily: '"Microsoft Yahei","微软雅黑"',
           },
       },
       angleAxis: {
           axisLine: {
               show: false
           },
           axisLabel: {
               show: false
           },
           splitLine: {
               show: false
           },
           axisTick: {
               show: false
           },
           min: 0,
           max: 6.666,
           // boundaryGap: ['0', '10'],
           startAngle: 225
       },
       radiusAxis: {
           type: 'category',
           axisLine: {
               show: false
           },
           axisTick: {
               show: false
           },
           axisLabel: {
               show: false
           },
           data: ['a', 'b', 'c'],
           z: 10
       },
       polar: {
           radius: '90%'
       },
       series: [{
               type: 'bar',
               data: [, , value],
               z: 1,
               coordinateSystem: 'polar',
               barMaxWidth: 24.2,
               name: '警告事件',
               roundCap: true,
               color: new echarts.graphic.LinearGradient(
                   0, 0, 1, 0,
                   [{
                           offset: 0,
                           color: '#1962FF',
                       },
                       {
                           offset: 1,
                           color: '#40EDFF',
                       }
                   ]
               ),
               barGap: '-100%',
           },
           {
               type: 'bar',
               data: [, , ],
               z: 2,
               coordinateSystem: 'polar',
               barMaxWidth: 24.2,
               name: '警告事件',
               roundCap: true,
               color: '#f00',
               barGap: '-100%',
           },
           {
               type: 'bar',
               data: [, , max],
               z: 0,
               silent: true,
               coordinateSystem: 'polar',
               barMaxWidth: 24.2,
               name: 'C',
               roundCap: true,
               color: '#F1F3F5',
               barGap: '-100%',
           },{
               type: 'gauge',
               radius: '75%',
               splitNumber: 4,
               max: 5,
               detail: {
                   show: false,
               },
               axisLine: {
                   show: false,
                   // 坐标轴线
                   lineStyle: {
                       // 属性lineStyle控制线条样式
                       color: [
                           [0, "#1962FF"],
                           [1, "#40EDFF"]
                       ],
                       width: 25,
                       opacity: 0 //刻度背景宽度
                   }
               },
               "data": [{
                   "name": "",
                   "value": value,
               }],
               splitLine: {
                   show: false,
                   length: 12, //长刻度节点线长度
                   lineStyle: {
                       width: 2,
                       color: "#c4c6cc"
                   } //刻度节点线
               },
               axisTick: {
                   show: false,
                   lineStyle: {
                       color: "#c4c6cc",
                       width: 2
                   },
                   length: 5,
                   splitNumber: 6
               },
               axisLabel: {
                   show: false,
                   color: '#333',
                   fontSize: 18,
               },
               pointer: {
                   show: true,
                   length: '70%',
                   itemStyle: {
                       color: '#1962FF',
                   }
               },
           },
           {
               type: 'gauge',
               radius: '15%',
               splitNumber: 4,
               max: 5,startAngle: 50,
               endAngle:  130,
               detail: {
                   show: false,
               },
               axisLine: {
                   // 坐标轴线
                   lineStyle: {show: false,
                       // 属性lineStyle控制线条样式
                       color: [
                           [0, "#DE585D"],
                           [1, "#DE585D"]
                       ],
                       width: 25,
                       opacity: 0 //刻度背景宽度
                   }
               },
               "data": [{
                   "name": "",
                   "value": value,
               }],
               splitLine: {
                   length: 8, //长刻度节点线长度
                   lineStyle: {
                       width: 2,
                       color: "#c4c6cc"
                   } //刻度节点线
               },
               axisTick: {
                   show: true,
                   lineStyle: {
                       color: "#c4c6cc",
                       width: 2
                   },
                   length: 5,
                   splitNumber: 6
               },
               axisLabel: {
                   show: false,
                   color: '#333',
                   fontSize: 18,
               },
           }, {
               "type": "pie",
               radius: ['88%', '82%'],
               "hoverAnimation": false,
               startAngle: 225,
               endAngle: 0,
               "data": [{
                       "name": "",
                       "value": value / 5,
                       "label": {
                           show: false
                       },
                       "labelLine": {
                           show: false
                       },
                       itemStyle: {
                           color: 'rgba(0,0,0,0)'
                       }
                   },{
                       "name": "",
                       value: 1.33 - value / 5,
                       "label": {
                           show: false
                       },
                       "labelLine": {
                           show: false
                       },
                       itemStyle: {
                           color: 'rgba(255,255,255,0)'
                       }
                   }
               ]
           },
       ],
       tooltip: {
           show: false
       },

   }
   ''',
      ),
    );
  }
}

class GatewayStatusCard extends StatelessWidget {
  final String sn;
  final String signalStatus; // '好' 或 '差'
  final Color signalColor;

  const GatewayStatusCard({
    super.key,
    required this.sn,
    required this.signalStatus,
    required this.signalColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(right: 0),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(
            'public/images/tryResultSimple/4Gmodel.png',
            width: 35,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '主网关SN：',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                Text(
                  sn,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    text: '4G信号：',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    children: [
                      TextSpan(
                        text: signalStatus,
                        style: TextStyle(
                          color: signalColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class chartsdiv1 extends StatelessWidget {
  String value;
  String text1;
  String text2;
  chartsdiv1(
      {super.key,
      required this.value,
      required this.text1,
      required this.text2});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 180,
      child: Echarts(
        reloadAfterInit: true,
        captureAllGestures: true,
        extraScript: '''
                  ''',
        option: '''{
    backgroundColor: '#fff',
    title: [ {
        text: '$text1',
        left: '85',
        top: '65',
        textAlign: 'center',
        textStyle: {
            fontSize: '16',
            fontWeight: '600',
            color: '#2B3448',
            textAlign: 'center',
        },
    }, {
        text: '$text2',
        left: '85',
        top: '90',
        textAlign: 'center',
        textStyle: {
            fontSize: '16',
            fontWeight: '600',
            color: '#2B3448',
            textAlign: 'center',
        },
    },],
    polar: {
        radius: ['90%', '75%'],
        center: ['50%', '50%'],
    },
    angleAxis: {
        max: 100,
        show: false,
    },
    radiusAxis: {
        type: 'category',
        show: true,
        axisLabel: {
            show: false,
        },
        axisLine: {
            show: false,

        },
        axisTick: {
            show: false
        },
    },
    series: [{
            name: '',
            type: 'bar',
            roundCap: true,
            barWidth: 60,
            showBackground: true,
            backgroundStyle: {
                color: '#93CAFF',
            },
            data: [$value],
            coordinateSystem: 'polar',
            itemStyle: {
                normal: {
                    color: new echarts.graphic.LinearGradient(0, 1, 0, 0, [{
                        offset: 0,
                        color: '#1962FF'
                    }, {
                        offset: 1,
                        color: '#1962FF'
                    }]),
                }
            }
        },

    ]
}
   ''',
      ),
    );
  }
}
