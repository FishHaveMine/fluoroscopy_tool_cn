/*
 * @Author: FishHaveMine 751174479@qq.com
 * @Date: 2024-05-27 14:42:22
 * @LastEditors: FishHaveMine 751174479@qq.com
 * @LastEditTime: 2024-06-04 17:59:07
 * @FilePath: /HVAC/fluoroscopy_tool/lib/main.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fluoroscopy_tool/view/afterSalesReplacement/publicFunction.dart';
import 'package:fluoroscopy_tool/view/login.dart';
import 'package:fluoroscopy_tool/view/userinfo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Themes.dart';
import 'config/config.dart';
import 'store/TextScaleController.dart';
import 'store/globalData.dart';
import 'store/http.dart';
import 'view/cloud/projectManage/deviceManage.dart';
import 'view/cloud/projectManage/projectDetail.dart';
import 'view/communication/index.dart';
import 'view/electronicExpansionValve/index.dart';
import 'view/local/publicFunction.dart';
import 'view/orderdevicepage.dart';
import 'view/protocoldetection/welcomePage.dart';
import 'view/refrigerant/index.dart';
import 'view/systemCapabilityAnalysis/index.dart';
import 'view/waterPumpInspection/index.dart';
import 'view/welcome/index.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'config/config_dev.dart' as devConfig;
import 'config/config_prod.dart' as prodConfig;

int startTime = 0;
int endTime = 0;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final deviceInfoPlugin = DeviceInfoPlugin();
  final deviceInfo = await deviceInfoPlugin.deviceInfo;
  final allInfo = deviceInfo.data;

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  //加载本地多语言处理，注意 tr（）内的处理需要转换成全小写

  if (allInfo["product"] == "NLS-MT9055-GL" ||
      kDebugMode ||
      allInfo["product"].toString().contains('NLS-MT')) {
    //设置运行环境
    await AppConfig.loadConfig();
    apiHost = AppConfig.baseUrl; //云端请求的host
    print("baseUrl: $apiHost");
    appCOUNTRY = AppConfig.ct; //判断内销版 还是 外销版

    MideaApi.init();

    Get.put(TextScaleController()); // 全局单例
    //加载云端的多语言
    // String zh_CN = await checkFileExistence("zh_CN");
    runApp(EasyLocalization(
        saveLocale: true,
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('zh', 'CN'),
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        child: const MyApp()));
  } else {
    runApp(const MaterialApp(
      title: 'Welcome ',
      debugShowCheckedModeBanner: false,
      home: orderdevicepage(),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(720, 1280),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => GlobalData()),
            ],
            child: Consumer<GlobalData>(
              builder: (context, darkModeProvider, _) {
                return const MyAppRe();
              },
            ));
        ;
      },
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyAppRe extends StatefulWidget {
  const MyAppRe({super.key});
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyAppRe> with WidgetsBindingObserver {
  static const McuUtilplatform = MethodChannel('samples.flutter.dev/McuUtil');

  final deviceInfoController _deviceInfoController =
      Get.put(deviceInfoController());
  final userinfoController _promissioncontroller =
      Get.put(userinfoController());

  final afterSalesReplacementController _selfController =
      Get.put(afterSalesReplacementController());

  powerOn() async {
    // McuUtilplatform.invokeMethod('powerOn');
  }

  //关闭背夹电源
  powerOff() async {
    McuUtilplatform.invokeMethod('powerOff');
  }

  String _appVersion = 'Unknown';
  String _buildNumber = 'Unknown';

  //读取app的构建版本并缓存，用于和云端的版本做匹配
  Future<void> _fetchAppVersion() async {
    setState(() {
      _appVersion = AppConfig.externalVersion; //云端请求的host
      _buildNumber = AppConfig.internalVersion; //云端请求的host
    });
    externalVersion = _appVersion;
    internalVersion = _buildNumber;
    print(
        "_appVersion: $_appVersion  _buildNumber:$_buildNumber  --- apiHost:$apiHost");

    //判断是非能连接外网，并加载多语言文件
    try {
      bool conn = await checkNet(false);
      if (conn) {
        try {
          // fetchAndSaveJsonData("zh_CN");
          // fetchAndSaveJsonData("en_US");
        } catch (e) {}
      }
    } catch (e) {}
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _fetchAppVersion();
    context.read<GlobalData>().initLogin(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      powerOff();
      FlutterNativeSplash.remove();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    powerOff();
    context.read<GlobalData>().initLogin(context);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    context.read<GlobalData>().initLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    // 获取屏幕宽度
    double screenWidth = MediaQuery.of(context).size.width;
    // 获取屏幕高度
    double screenHeight = MediaQuery.of(context).size.height;

    ThemeData showThem = context.watch<GlobalData>().activeThemeData == 'white'
        ? Themes.white
        : Themes.black;
    Map<String, TextTheme> fontList = {
      'PingFangMedium': TextTheme(
          titleMedium: TextStyle(
              fontFamily: 'PingFangMedium',
              color: context.watch<GlobalData>().activeThemeData == 'white'
                  ? const Color.fromRGBO(20, 21, 23, 1)
                  : Colors.white),
          displayLarge: TextStyle(
              fontFamily: 'PingFangMedium',
              color: context.watch<GlobalData>().activeThemeData == 'white'
                  ? const Color.fromRGBO(20, 21, 23, 1)
                  : Colors.white),
          bodyMedium: TextStyle(
              fontFamily: 'PingFangMedium',
              color: context.watch<GlobalData>().activeThemeData == 'white'
                  ? const Color.fromRGBO(20, 21, 23, 1)
                  : Colors.white)),
      'hongmengsansscmediumziti': TextTheme(
        titleMedium: TextStyle(
            fontFamily: 'hongmengsansscmediumziti',
            color: context.watch<GlobalData>().activeThemeData == 'white'
                ? const Color.fromRGBO(20, 21, 23, 1)
                : Colors.white),
        displayLarge: TextStyle(
            fontFamily: 'hongmengsansscmediumziti',
            color: context.watch<GlobalData>().activeThemeData == 'white'
                ? const Color.fromRGBO(20, 21, 23, 1)
                : Colors.white),
        bodyMedium: TextStyle(
            fontFamily: 'hongmengsansscmediumziti',
            color: context.watch<GlobalData>().activeThemeData == 'white'
                ? const Color.fromRGBO(20, 21, 23, 1)
                : Colors.white),
      ),
    };
    ThemeData activeThem = showThem.copyWith(
      textTheme: fontList[context.watch<GlobalData>().activeFonta],
    );
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      theme: activeThem,
      builder: EasyLoading.init(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) {
        ///根据语言环境来获取 taskTitle
        return tr('helloWorld');
      },
      key: ValueKey(context.locale.toString()),
      home: Obx(() {
        final controller = Get.find<TextScaleController>(); // 获取已有实例
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: controller.textScaleFactor.value,
          ),
          child: context.watch<GlobalData>().isLogin
              ? welcomePage()
              : const loginPage(),
        );
      }),
      getPages: [
        GetPage(
            name: '/home',
            page: () => const ScalableTextApp(child: welcomePage())),
        GetPage(
            name: '/deviceManage',
            page: () => ScalableTextApp(child: deviceManage())),
        GetPage(
            name: '/projectDetail',
            page: () => ScalableTextApp(child: projectDetail())),
        GetPage(
            name: '/login',
            page: () => const ScalableTextApp(child: loginPage())),

        //本地功能
        GetPage(
            name: '/CommunicateDetect',
            page: () => ScalableTextApp(child: communicationTypeSelectPage())),
        GetPage(
            name: '/WaterPumpDetect',
            page: () => const ScalableTextApp(child: waterPumpPage())),
        GetPage(
            name: '/ElecExpansValveDetect',
            page: () => ScalableTextApp(child: electronicExpansionValve())),
        GetPage(
            name: '/ProtocolDetect',
            page: () => ScalableTextApp(child: protocolwelcomePage())),
        GetPage(
            name: '/SystemCapabilityAnalysis',
            page: () =>
                const ScalableTextApp(child: systemCapabilityAnalysisPage())),
        GetPage(
            name: '/RefrigerantDetectCharge',
            page: () => ScalableTextApp(child: refrigerantTable())),
      ],
      onUnknownRoute: (setting) {
        return MaterialPageRoute(builder: (_) => Text(externalVersion));
      },
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}

class ScalableTextApp extends StatelessWidget {
  final Widget child;

  const ScalableTextApp({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<TextScaleController>();
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaleFactor: controller.textScaleFactor.value,
        ),
        child: child,
      );
    });
  }
}
