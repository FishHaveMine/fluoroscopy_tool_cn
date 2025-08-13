import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_echarts/flutter_echarts.dart';
// import 'package:number_display/number_display.dart';

import 'package:webview_flutter/webview_flutter.dart';

import 'liquid_script.dart' show liquidScript;
import 'gl_script.dart' show glScript;
import 'dark_theme_script.dart' show darkThemeScript;

// final display = createDisplay(decimal: 2);

class MyechartsHomePage extends StatefulWidget {
  MyechartsHomePage({Key? key}) : super(key: key);

  @override
  _MyechartsHomePageState createState() => _MyechartsHomePageState();
}

class _MyechartsHomePageState extends State<MyechartsHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool load = false;
  String key = "";
  getData1() async {
    setState(() {
      load = true;
      key = DateTime.now().millisecondsSinceEpoch.toString();
    });
  }

  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition for the WebView
    if (defaultTargetPlatform == TargetPlatform.android) {
      WebView.platform = SurfaceAndroidWebView();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      this.getData1();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Echarts Demon'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              if (load)
                SizedBox(
                  width: 300,
                  height: 250,
                  child: Echarts(
                    key: ValueKey(key),
                    reloadAfterInit: true,
                    captureAllGestures: true,
                    extraScript: '''
                    var base = +new Date(1968, 9, 3);
                    var oneDay = 24 * 3600 * 1000;
                    var date = [];

                    var data = [Math.random() * 300];

                    for (var i = 1; i < 20000; i++) {
                        var now = new Date(base += oneDay);
                        date.push([now.getFullYear(), now.getMonth() + 1, now.getDate()].join('/'));
                        data.push(Math.round((Math.random() - 0.5) * 20 + data[i - 1]));
                    }
                  ''',
                    option: '''
                    {
                      tooltip: {
                          trigger: 'axis',
                          position: function (pt) {
                              return [pt[0], '10%'];
                          }
                      },
                      toolbox: {
                          feature: {
                              dataZoom: {
                                  yAxisIndex: 'none'
                              },
                              restore: {},
                              saveAsImage: {}
                          }
                      },
                      xAxis: {
                          type: 'category',
                          boundaryGap: false,
                          data: date
                      },
                      yAxis: {
                          type: 'value',
                          boundaryGap: [0, '100%']
                      },
                      dataZoom: [{
                          type: 'inside',
                          start: 0,
                          end: 10
                      }, {
                          start: 0,
                          end: 10,
                          handleIcon: 'M10.7,11.9v-1.3H9.3v1.3c-4.9,0.3-8.8,4.4-8.8,9.4c0,5,3.9,9.1,8.8,9.4v1.3h1.3v-1.3c4.9-0.3,8.8-4.4,8.8-9.4C19.5,16.3,15.6,12.2,10.7,11.9z M13.3,24.4H6.7V23h6.6V24.4z M13.3,19.6H6.7v-1.4h6.6V19.6z',
                          handleSize: '80%',
                          handleStyle: {
                              color: '#fff',
                              shadowBlur: 3,
                              shadowColor: 'rgba(0, 0, 0, 0.6)',
                              shadowOffsetX: 2,
                              shadowOffsetY: 2
                          }
                      }],
                      series: [
                          {
                              name: 'data',
                              type: 'line',
                              smooth: true,
                              symbol: 'none',
                              sampling: 'average',
                              itemStyle: {
                                  color: 'rgb(255, 70, 131)'
                              },
                              areaStyle: {
                                  color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                                      offset: 0,
                                      color: 'rgb(255, 158, 68)'
                                  }, {
                                      offset: 1,
                                      color: 'rgb(255, 70, 131)'
                                  }])
                              },
                              data: data
                          }
                      ]
                    }
                  ''',
                  ),
                ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Text('Using extension', style: TextStyle(fontSize: 20)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
