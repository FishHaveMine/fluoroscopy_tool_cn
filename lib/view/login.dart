import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:fluoroscopy_tool/compent/bottomSelectSheet.dart';
import 'package:fluoroscopy_tool/store/globalData.dart';
import 'package:fluoroscopy_tool/store/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'package:encrypt/encrypt.dart' as encrypt;

import '../config/config.dart';
import 'userinfo.dart';

import '../config/config_dev.dart' as devConfig;
import '../config/config_prod.dart' as prodConfig;

String loginNeed2HtmlWidget = '';
String loginNeed2HtmlWidgetEN = '';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage>
    with SingleTickerProviderStateMixin {
  final userinfoController _controller = Get.put(userinfoController());

  final _formKey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  RxString username = "".obs;
  // ignore: non_constant_identifier_names
  RxString password = "".obs;
  final TextEditingController _usernamecontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  static var isAgree = false.obs;
  static var savepassword = false.obs;

  static const platform = MethodChannel('samples.flutter.dev/battery');
  bool isObscureText = true;
  bool isnetconnecd = false;
  RxBool iscss = false.obs;

  RxString _externalVersion = "".obs;
  RxString _internalVersion = "".obs;

  String pagekey = "key";
  Future<void> _fetchAppVersion() async {
    await AppConfig.loadConfig();
    apiHost = AppConfig.baseUrl; //云端请求的host
    print("baseUrl: $apiHost");
    appCOUNTRY = AppConfig.ct; //判断内销版 还是 外销版
    //读取app的构建版本并缓存
    externalVersion = AppConfig.externalVersion; //云端请求的host
    internalVersion = AppConfig.internalVersion; //云端请求的host
    print(
        "_appVersion: $externalVersion  _buildNumber:$internalVersion --- --- ---  apiHost:$apiHost");
  }

  static const initplatform = MethodChannel('samples.flutter.dev/init');
  inthttp() async {
    if (externalVersion == "") {
      await _fetchAppVersion();
    }
    _externalVersion.value = externalVersion;
    _internalVersion.value = internalVersion;
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('haveinithttp', true);
    await initplatform.invokeMethod('init', <String, dynamic>{
      "issit": apiHost == "btri-dev.midea.com",
      "apiHost": apiHost,
      "token": "",
      "uid": "",
    });

    String? usernameprefs = await prefs.getString("usernameA");
    String? usernamedprefs = await prefs.getString("usernameB");

    if (usernameprefs != null && usernamedprefs != null) {
      username.value = usernameprefs;
      password.value = usernamedprefs;

      _usernamecontroller.text = usernameprefs;
      _passwordcontroller.text = usernamedprefs;
      setState(() {
        pagekey = usernameprefs + usernamedprefs;
      });
    }
  }

  // 初始化加密库
  final key = encrypt.Key.fromUtf8('32characterslongsecretkey1234'); // 32字符密钥
  final iv = encrypt.IV.fromLength(16); // 16字节的初始化向量

  Future<bool> _checkNet(show) async {
    if (show) {
      EasyLoading.show(status: 'loading...');
    }
    try {
      final response = await Dio().get('https://${apiHost}/');
      print("apiHost: ---- $apiHost");
      isnetconnecd = response.statusCode == 200;

      EasyLoading.dismiss();
      if (!isnetconnecd) {
        EasyLoading.showError(tr("netword.empty"));
      }
      setState(() {
        isnetconnecd;
      });
      return isnetconnecd;
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
      EasyLoading.showError(tr("netword.empty"));
      return false;
    }
  }

  init() async {
    loginNeed2HtmlWidget =
        await rootBundle.loadString('public/html/login_need.html');
    loginNeed2HtmlWidgetEN =
        await rootBundle.loadString('public/html/login_need_en.html');
  }

  @override
  void initState() {
    super.initState();
    EasyLoading.dismiss();
    inthttp();
    init();
    // _checkNet(false);
    checkversion(context);
    username.value = "";
    isAgree.value = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _checkLocationPermission(context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // 位置权限被拒绝，提示用户打开权限设置
      _showPermissionDeniedDialog(context);
    } else {
      _getCurrentLocation();
    }
  }

  void _showPermissionDeniedDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
            'Please grant access to your location to use this feature.'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              // 打开应用设置页面，让用户手动授权位置权限
              Geolocator.openAppSettings();
            },
          ),
        ],
      ),
    );
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('_checkLocationPermission Error getting location: $e');
      // 处理获取位置信息时的异常情况
    }
  }

  tologin(context) async {
    EasyLoading.show(status: 'loading...');
    final prefs = await SharedPreferences.getInstance();
    try {
      var islogin = await platform.invokeMethod('login', <String, dynamic>{
        'username': username.value,
        'passwoed': password.value,
        "issit": apiHost == "btri-dev.midea.com",
        "iscss": iscss.value
      });
      for (var element in islogin['data'].keys) {
        print("islogin  $element : ${islogin['data'][element]}");
      }
      EasyLoading.dismiss();
      if (islogin['success'].toString() == "false") {
        if (islogin['errorMsg'] == null) {
          EasyLoading.showError(tr('loginError'));
        } else {
          EasyLoading.showError(islogin['errorMsg']);
        }
        return false;
      } else {
        _controller.set_userPromission(islogin['permissions']);
        await prefs.setString(
            'permissions', jsonEncode(islogin['permissions']));

        EasyLoading.showSuccess(tr('loginSuccess'));
        int timestamp = DateTime.now().millisecondsSinceEpoch;
        await prefs.setInt('logintime', timestamp);

        await prefs.setString('username', "${username.value}");
        await prefs.setString('usernameA', "${username.value}");
        await prefs.setString(
            'usernameB', "${savepassword.value ? password.value : ""}");

        await prefs.setString('token', islogin['data']['ssoSession']);
        MideaApi.init();
        var getUserMessage = await platform.invokeMethod('getUserMessage');
        var back = jsonDecode(getUserMessage);
        if (back["errorCode"] != 1001) {
          prefs.setString("useinfo", jsonEncode(back["data"]));
        }
        return true;
      }
    } on PlatformException catch (e) {
      print("Failed to SCANNER_TRIG: '${e.message}'.");
      EasyLoading.dismiss();
      return false;
    }
  }

  _toset() async {
    final prefs = await SharedPreferences.getInstance();
    Future<sheetBack?> selectedIndex = await showCustomModalBottomSheet(
        isMultiple: false,
        context,
        [
          {'label': 'self.en', 'name': 'self.en', 'value': 1},
          {'label': 'self.cn', 'name': 'self.cn', 'value': 2},
        ],
        // ignore: unrelated_type_equality_checks
        baseValue: [
          EasyLocalization.of(context)?.currentLocale!.languageCode != 'zh'
              ? '1'
              : '2'
        ],
        titleName: tr('chooseLangage'));
    selectedIndex.then((value) => {
          if (value != null)
            {
              if (value.baseValue![0] == '1')
                {
                  prefs.setString('languageCode', 'en'),
                  EasyLocalization.of(context)?.setLocale(switchLanguage(0))
                }
              else if (value.baseValue![0] == '2')
                {
                  prefs.setString('languageCode', 'zh'),
                  EasyLocalization.of(context)?.setLocale(switchLanguage(1))
                }
            }
        });
  }

  Locale switchLanguage(int index) {
    switch (index) {
      case 0:
        return const Locale('en', 'US');
      case 1:
        return const Locale('zh', 'CN');
    }
    return const Locale('en', 'US');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
        height: 1280.h,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('public/images/login/bg.png'),
                fit: BoxFit.fill)),
        child: Stack(
          children: [
            Container(
              height: 1280.h - 32.h - 50,
              key: ValueKey(pagekey),
              padding: EdgeInsets.fromLTRB(50.w, 0, 50.w, 0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 88.h, 0, 0.h),
                      child: Center(
                        child: Image.asset(
                          'public/images/login/header.png',
                          width: 188.w,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 60.h),
                      child: const Text(
                        'self.loginTitle',
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromRGBO(13, 13, 13, 1),
                            fontWeight: FontWeight.w400),
                      ).tr(),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 28.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // InkWell(
                          //     onTap: () {
                          //       iscss.value = true;
                          //     },
                          //     child: tap(
                          //       name: tr("iscss"),
                          //       isActive: iscss.value,
                          //     )),
                          InkWell(
                            onTap: () {
                              iscss.value = false;
                            },
                            child: tap(
                              name: tr("ismidea"),
                              isActive: !iscss.value,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 80.h),
                        child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 28.h),
                                  padding: EdgeInsets.fromLTRB(
                                      32.w, 24.h, 32.w, 24.h),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(48),
                                      color: Colors.white),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 24.w, 0),
                                        child: Image.asset(
                                          'public/images/login/icon_Account.png',
                                          width: 48.w,
                                        ),
                                      ),
                                      Expanded(
                                          child: TextFormField(
                                              inputFormatters: [
                                            FilteringTextInputFormatter.deny(
                                                RegExp(r'\s')) // 拒绝输入空格
                                          ],
                                              controller:
                                                  _usernamecontroller, // 将控制器分配给 TextFormField
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  // labelText: tr('loginphone'),
                                                  hintText:
                                                      "${tr('self.input')}${tr('username')}"),
                                              onSaved: (back) {
                                                username.value = back!;
                                              },
                                              onChanged: (back) {
                                                username.value = back!;
                                              },
                                              validator: (v) {
                                                return validateEmpty(v);
                                              }))
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      32.w, 24.h, 32.w, 24.h),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(48),
                                      color: Colors.white),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 24.w, 0),
                                        child: Image.asset(
                                          'public/images/login/icon_Account1.png',
                                          width: 48.w,
                                        ),
                                      ),
                                      Expanded(
                                          child: TextFormField(
                                              inputFormatters: [
                                            FilteringTextInputFormatter.deny(
                                                RegExp(r'\s')) // 拒绝输入空格
                                          ],
                                              obscureText:
                                                  isObscureText, // 隐藏密码输入
                                              controller:
                                                  _passwordcontroller, // 将控制器分配给 TextFormField

                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  // labelText: tr('loginphone'),
                                                  hintText:
                                                      "${tr('self.input')}${tr('password')}"),
                                              onSaved: (back) {
                                                password.value = back!;
                                              },
                                              onChanged: (back) {
                                                password.value = back!;
                                              },
                                              validator: (v) {
                                                return validateEmpty(v);
                                              })),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isObscureText = !isObscureText;
                                            });
                                          },
                                          icon: Icon(isObscureText
                                              ? Icons.visibility_off
                                              : Icons.visibility))
                                    ],
                                  ),
                                )
                              ],
                            ))),
                    GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState!.validate() &&
                            isAgree.value) {
                          bool conn = await _checkNet(true);
                          if (!conn) {
                            return;
                          }
                          bool issuccess = await tologin(context);
                          if (issuccess) {
                            // ignore: use_build_context_synchronously
                            context.read<GlobalData>().userIsLogin(true);
                            Get.offAllNamed('/home'); //
                          }
                        }
                      },
                      child: Container(
                        decoration: !(isAgree.value &&
                                password.value.isNotEmpty &&
                                username.value.isNotEmpty)
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(48),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromARGB(255, 118, 118, 118),
                                    Color.fromARGB(255, 140, 140, 140),
                                  ],
                                  stops: [
                                    0.0,
                                    1.0,
                                  ],
                                  transform: GradientRotation(
                                      116 * 3.14 / 180), // 将角度转换为弧度
                                ),
                              )
                            : BoxDecoration(
                                borderRadius: BorderRadius.circular(48),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF1CA2FF),
                                    Color(0xFF0080FF),
                                  ],
                                  stops: [
                                    0.0,
                                    1.0,
                                  ],
                                  transform: GradientRotation(
                                      116 * 3.14 / 180), // 将角度转换为弧度
                                ),
                              ),
                        height: 96.h,
                        child: Center(
                          child: const Text(
                            'self.login',
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontWeight: FontWeight.w400),
                          ).tr(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 48.h, 0, 0),
                      child: InkWell(
                        onTap: () {
                          isAgree.value = !isAgree.value;
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RoundCheckBox(
                              isChecked: isAgree.value,
                              onTap: (selected) {
                                isAgree.value = selected!;
                              },
                              size: 24,
                              checkedWidget: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20,
                              ),
                              checkedColor:
                                  Theme.of(context).colorScheme.secondary,
                              border: Border.all(
                                  // width: 1,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(16.w, 0, 0, 0),
                              child: Text(
                                tr('readAndAgree'),
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(140, 140, 140, 1)),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                var text = await userProtocolPage.show2<String>(
                                    context, 0);
                              },
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(16.w, 0, 0, 0),
                                child: Text(
                                  tr('userAgreement'),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromRGBO(0, 128, 255, 1)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 48.h, 0, 0),
                        child: InkWell(
                            onTap: () {
                              savepassword.value = !savepassword.value;
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RoundCheckBox(
                                  isChecked: savepassword.value,
                                  onTap: (selected) {
                                    savepassword.value = selected!;
                                  },
                                  size: 24,
                                  checkedWidget: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  checkedColor:
                                      Theme.of(context).colorScheme.secondary,
                                  border: Border.all(
                                      // width: 1,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                                const Padding(padding: EdgeInsets.all(5)),
                                InkWell(
                                  onTap: () {
                                    savepassword.value = !savepassword.value;
                                  },
                                  child: SizedBox(
                                    width: 90 + 70,
                                    child: RichText(
                                      //必传文本
                                      text: TextSpan(
                                        text: tr('savepassword'),
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ))),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 32.h,
              child: SizedBox(
                  width: 720.w,
                  child: Tooltip(
                    message: apiHost,
                    waitDuration: Duration(milliseconds: 500),
                    showDuration: Duration(seconds: 2),
                    child: Text(
                      'V${_externalVersion}(${_internalVersion}) ${apiHost != "btri-dev.midea.com" && apiHost != "us-test.mideaibp.com" ? "Stable-eu" : "Beta-eu"} ${tr("local.version")}',
                      style: const TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(140, 140, 140, 1)),
                      textAlign: TextAlign.center,
                    ),
                  )),
            ),
            Positioned(
              top: 45.h,
              right: 10.w,
              child: IconButton(
                icon: const Icon(Icons.language),
                onPressed: () {
                  _toset();
                },
              ),
            )
          ],
        )));
  }
}

class tap extends StatefulWidget {
  String name;
  bool isActive;
  tap({super.key, required this.name, required this.isActive});

  @override
  State<tap> createState() => _tapState();
}

class _tapState extends State<tap> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? languageCode =
        EasyLocalization.of(context)?.currentLocale?.languageCode;
    return Container(
      width: languageCode == "zh" ? widget.name.length * 16 : 250.w,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              widget.name,
              style: TextStyle(
                fontSize: languageCode == "zh" ? 16 : 12,
                fontWeight: FontWeight.w500,
                color: widget.isActive ? const Color(0xFF1962FF) : Colors.black,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: widget.isActive
                  ? const Color(0xFF1962FF)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(2), // Border radius
            ),
            height: 2,
          )
        ],
      ),
    );
  }
}

// ignore: camel_case_types
class userProtocolPage extends StatelessWidget {
  String userPrivateProtocol = tr('userPrivateProtocol');
  final focusNode = FocusNode();
  final controller = TextEditingController();
  int showType;
  static Future<T?> show2<T>(BuildContext context, int showType) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        // 关键
        opaque: false,
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return userProtocolPage(showType: showType);
        },
      ),
    );
  }

  userProtocolPage({super.key, required this.showType});
  @override
  Widget build(BuildContext context) {
    bool isCN =
        EasyLocalization.of(context)?.currentLocale!.languageCode == 'zh';
    // 加个小延迟
    Timer(const Duration(milliseconds: 50), (() {
      focusNode.requestFocus();
    }));
    return Scaffold(
        // 关键
        backgroundColor: Colors.black.withAlpha((255 * 0.4).toInt()),
        body: SizedBox(
          height: 1280.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //撑起上部分
              Expanded(child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  // Get.back();
                },
              )),
              Container(
                padding: const EdgeInsets.all(25),
                width: 720.w,
                height: 720.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  //设置四周圆角 角度
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0)),
                  //设置四周边框
                  border: Border.all(width: 1, color: Colors.transparent),
                ),
                child: Column(
                  children: [
                    Text(tr('userAgreement'),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold))
                        .tr(),
                    SizedBox(
                      width: 720.w,
                      height: 720.h - 50 - 45 - 50 - 20 - 50,
                      child: Scrollbar(
                        child: SizedBox(
                          width: double.infinity,
                          child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.all(10),
                              child: HtmlWidget(isCN
                                  ? loginNeed2HtmlWidget
                                  : loginNeed2HtmlWidgetEN)),
                        ),
                      ),
                    ),
                    Container(
                        width: 720.w,
                        height: 45,
                        margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                        child: Row(
                          textDirection: TextDirection.ltr,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RoundCheckBox(
                              isChecked: _loginPageState.isAgree.value,
                              onTap: (selected) {
                                _loginPageState.isAgree.value = selected!;
                              },
                              size: 20,
                              checkedWidget: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              ),
                              checkedColor:
                                  Theme.of(context).colorScheme.secondary,
                              border: Border.all(
                                  // width: 1,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                            const Padding(padding: EdgeInsets.all(5)),
                            Expanded(
                                child: RichText(
                              //必传文本
                              text: TextSpan(
                                  text: tr('readAndAgree'),
                                  style: const TextStyle(color: Colors.grey),
                                  //手势监听
                                  // recognizer: ,
                                  children: [
                                    TextSpan(
                                      text: tr('userAgreement'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context).focusColor),
                                    )
                                  ]),
                            )),
                          ],
                        )),
                    SizedBox(
                        width: 720.w,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              padding: const EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          child: const Text("self.agree").tr(),
                          onPressed: () async {
                            _loginPageState.isAgree.value = true;
                            Navigator.pop(context);
                          },
                        ))
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
