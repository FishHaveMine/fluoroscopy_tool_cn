/*
 * @Author: FishHaveMine 751174479@qq.com
 * @Date: 2024-05-27 14:42:22
 * @LastEditors: FishHaveMine 751174479@qq.com
 * @LastEditTime: 2024-06-04 17:59:07
 * @FilePath: /HVAC/fluoroscopy_tool/lib/main.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fluoroscopy_tool/store/http.dart';

import 'package:fluoroscopy_tool/view/login.dart';
import 'package:fluoroscopy_tool/view/userinfo.dart';
import 'package:fluoroscopy_tool/waterpumb/warterpumbIndex.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Themes.dart';
import 'store/TextScaleController.dart';
import 'store/globalData.dart';
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
import 'waterpumb/index.dart';
import 'waterpumb/productSelect.dart';

int startTime = 0;
int endTime = 0;

class AppConfig {
  static late String baseUrl;

  static late String externalVersion;
  static late String internalVersion;

  static void loadConfig() {
    //  flutter build apk --dart-define=ENV=dev
    //  flutter build apk --dart-define=ENV=prod

    const EXV = String.fromEnvironment('EXV', defaultValue: '');
    const ITV = String.fromEnvironment('ITV', defaultValue: '');

    const env = String.fromEnvironment('ENV', defaultValue: 'dev');
    if (env == 'dev') {
      baseUrl = devConfig.Config.baseUrl;
    } else {
      baseUrl = prodConfig.Config.baseUrl;
    }

    externalVersion = EXV;
    internalVersion = ITV;
    print("loadConfig baseUrl :$baseUrl");
    print("loadConfig externalVersion :$externalVersion");
    print("loadConfig internalVersion :$internalVersion");
  }
}

void main() async {
  //设置运行环境
  AppConfig.loadConfig();
  apiHost = AppConfig.baseUrl;

  externalVersion = AppConfig.externalVersion; //云端请求的host
  internalVersion = AppConfig.internalVersion; //云端请求的host
  MideaApi.init();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  //加载云端的多语言
  String zh_CN = await checkFileExistence("zh_CN");
  await EasyLocalization.ensureInitialized();

  final deviceInfoPlugin = DeviceInfoPlugin();
  final deviceInfo = await deviceInfoPlugin.deviceInfo;
  final allInfo = deviceInfo.data;
  //加载本地多语言处理，注意 tr（）内的处理需要转换成全小写
  if (allInfo["product"] == "NLS-MT9055-GL" ||
      kDebugMode ||
      allInfo["product"].toString().contains('NLS-MT')) {
    Get.put(TextScaleController()); // 全局单例
    //加载云端的多语言
    // String zh_CN = await checkFileExistence("zh_CN");
    runApp(EasyLocalization(
        saveLocale: true,
        supportedLocales: const [
          Locale('zh', 'CN'),
          Locale('en', 'US'),
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('zh', 'CN'),
        child: const MyApp()));
  } else {
    runApp(MaterialApp(
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

  powerOn() async {
    // McuUtilplatform.invokeMethod('powerOn');
  }

  powerOff() async {
    McuUtilplatform.invokeMethod('powerOff');
  }

  String _appVersion = 'Unknown';
  String _buildNumber = 'Unknown';
  Future<void> _fetchAppVersion() async {
    //读取app的构建版本并缓存
    // final packageInfo = await PackageInfo.fromPlatform();
    // setState(() {
    //   _appVersion = packageInfo.version; // 应用版本号
    //   _buildNumber = packageInfo.buildNumber; //可获取构建号
    // });
    // externalVersion = _appVersion;
    // internalVersion = _buildNumber;
    print(
        "_appVersion: $_appVersion  _buildNumber:$_buildNumber apiHost:$apiHost");

    //判断是非能连接外网，并加载多语言文件
    // try {
    //   bool conn = await checkNet(false);
    //   if (conn) {
    //     try {
    //       fetchAndSaveJsonData("zh_CN");
    //       fetchAndSaveJsonData("en_US");
    //     } catch (e) {}
    //   }
    // } catch (e) {}
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
      onGenerateTitle: (context) => tr('helloWorld'),
      key: ValueKey(context.locale.toString()),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: Obx(() {
        final controller = Get.find<TextScaleController>(); // 获取已有实例
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: controller.textScaleFactor.value,
          ),
          child: context.watch<GlobalData>().isLogin
              ? productSelect()
              : const loginPage(),
        );
      }),

      // 简化路由定义，移除重复的 MediaQuery
      getPages: [
        GetPage(
            name: '/productSelect',
            page: () => ScalableTextApp(child: productSelect())),
        GetPage(
            name: '/warterpumbIndex',
            page: () => const ScalableTextApp(child: warterpumbWelcomePage())),
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
    );
  }
}

class AuthMiddleware extends GetMiddleware {
  final bool hasPermission;

  AuthMiddleware({required this.hasPermission});

  final userinfoController _promissioncontroller =
      Get.put(userinfoController());
  @override
  RouteSettings? redirect(String? route) {
    // 检查权限
    if (!_promissioncontroller.checkLocalPromission(route)) {
      // 如果没有权限，跳转到登录页或提示页面
      return const RouteSettings(name: '/login');
    }
    return null; // 允许跳转
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
