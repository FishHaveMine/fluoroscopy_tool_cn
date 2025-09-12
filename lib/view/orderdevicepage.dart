import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class orderdevicepage extends StatefulWidget {
  const orderdevicepage({super.key});

  @override
  State<orderdevicepage> createState() => _orderdevicepageState();
}

class _orderdevicepageState extends State<orderdevicepage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    // FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('public/images/login/bg.png'),
                fit: BoxFit.fill)),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 88, 0, 0),
                child: Center(
                  child: Image.asset(
                    'public/images/login/header.png',
                    width: 188,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 60),
                child: const Text(
                  'self.logintitle',
                  style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(13, 13, 13, 1),
                      fontWeight: FontWeight.w400),
                ).tr(),
              ),
            ],
          ),
        ));
  }
}
