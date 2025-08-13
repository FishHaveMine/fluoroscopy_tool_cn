// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/globalData.dart';
import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

class account extends StatefulWidget {
  account({super.key});

  @override
  State<account> createState() => _accountState();
}

class _accountState extends State<account> {
  String loaclaccount = '';
  String tenantName = "--";
  String roles = "--";

  static const platform = MethodChannel('samples.flutter.dev/battery');
  getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? name = await prefs.getString('username');
    if (name != null) {
      setState(() {
        loaclaccount = name;
      });
    }

    try {
      var getuserRolelist =
          await platform.invokeMethod('getuserRolelist', <String, dynamic>{});

      var rolelistdata = jsonDecode(getuserRolelist);
      print(rolelistdata);
      List r = rolelistdata["data"]["roles"] ?? [];
      if (rolelistdata["success"]) {
        setState(() {
          tenantName = rolelistdata["data"]["tenantName"];
          roles = r.map((e) => e['roleName']).toList().join("、");
        });
      }
    } catch (e) {
      print(e);
    }
  }

  signout() async {
    tologout();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
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
            'menu_Account',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: const [],
        ),
        body: SizedBox(
            width: 720.w,
            height: 1280.h,
            child: Stack(children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.fromLTRB(32.w, 24.h, 32.w, 24.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Text('menu_Account').tr(),
                              Padding(
                                padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: Text(
                                  loaclaccount,
                                  style: const TextStyle(
                                      color: Color.fromRGBO(140, 140, 140, 1)),
                                ).tr(),
                              )
                            ],
                          ),
                          InkWell(
                            onTap: () async {
                              bool issend = await divConfirmDialog(context,
                                  isSubmitButton: true,
                                  confirmTitle:
                                      tr("account.signout.confirmTitle"),
                                  confirmDescriptionWidget:
                                      SingleChildScrollView(
                                    child: SizedBox(
                                        width: 560.w,
                                        height: 20,
                                        child: Padding(
                                          padding: const EdgeInsets.all(24),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [],
                                          ),
                                        )),
                                  ));
                              if (issend) {
                                await signout();
                                context.read<GlobalData>().userIsLogin(false);
                                Get.offAllNamed('/login'); //
                              }
                            },
                            child: const Text(
                              'menu_Account_changhe',
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 128, 255, 1)),
                            ).tr(),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.fromLTRB(32.w, 24.h, 32.w, 24.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Text('tenantName').tr(),
                              Padding(
                                padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: Text(
                                  tenantName,
                                  style: const TextStyle(
                                      color: Color.fromRGBO(140, 140, 140, 1)),
                                ).tr(),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.fromLTRB(32.w, 24.h, 32.w, 24.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('roles').tr(),
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Text(
                              roles,
                              style: const TextStyle(
                                  color: Color.fromRGBO(140, 140, 140, 1)),
                            ).tr(),
                          ))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                  bottom: 32.h,
                  child: Container(
                    width: 720.w,
                    height: 57,
                    padding: EdgeInsets.fromLTRB(32.w, 0, 32.w, 8.h),
                    child: submitButton(
                      isActive: true,
                      label: tr('account.signout'),
                      onClick: () async {
                        bool issend = await divConfirmDialog(context,
                            isSubmitButton: true,
                            confirmTitle: tr("account.signout.confirmTitle"),
                            confirmDescriptionWidget: SingleChildScrollView(
                              child: SizedBox(
                                  width: 560.w,
                                  height: 20,
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [],
                                    ),
                                  )),
                            ));
                        if (issend) {
                          await signout();
                          context.read<GlobalData>().userIsLogin(false);
                          Get.offAllNamed('/login'); //
                        }
                      },
                    ),
                  ))
            ])));
  }
}
