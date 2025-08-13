import 'package:easy_localization/easy_localization.dart';
import 'package:fluoroscopy_tool/compent/submitbutton.dart';
import 'package:fluoroscopy_tool/store/UpdateManager.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../store/globalData.dart';

class UpdateInProgressPage extends StatefulWidget {
  String msg;
  String url;
  UpdateInProgressPage({super.key, required this.msg, required this.url});

  @override
  State<UpdateInProgressPage> createState() => _UpdateInProgressPageState();
}

class _UpdateInProgressPageState extends State<UpdateInProgressPage> {
  @override
  void initState() {
    super.initState();
    // UpdateManager.downloadAndInstall(file_Url);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _launchURL() async {
    await launch(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: null,
          backgroundColor: const Color(0xFF1CA2FF),
          actions: const [],
          title: const Text('updataTitle').tr(),
        ),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('public/images/login/bg.png'),
                  fit: BoxFit.fill)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(15),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                            color: Colors.black, height: 1.5, fontSize: 16.0),
                        text: widget.msg,
                      ),
                    )),
                const Padding(
                  padding: EdgeInsets.all(15),
                ),
                SizedBox(
                  width: 200,
                  height: 56,
                  child: submitButton(
                      onClick: () {
                        _launchURL();
                      },
                      isActive: true,
                      label: '下载最新版本'),
                )
              ],
            ),
          ),
        ));
  }
}
