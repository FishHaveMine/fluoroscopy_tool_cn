import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../errorAnalysis/errorDetail.dart';

class updataTip extends StatefulWidget {
  updataTip({super.key});

  @override
  State<updataTip> createState() => _updataTipState();
}

class _updataTipState extends State<updataTip> {
  @override
  void initState() {
    super.initState();
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
            'refrigerant.Uupdata',
            style: TextStyle(color: Colors.black),
          ).tr(),
          centerTitle: true,
          actions: [],
        ),
        body: Container(
          width: 720.w,
          height: 1280.h,
          color: const Color.fromRGBO(255, 255, 255, 1),
          padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FullScreenImageLocal(
                              imageUrl: 'public/images/refrigerant/u1.jpg'),
                        ),
                      );
                    },
                    child: Image.asset(
                      'public/images/refrigerant/u1.jpg',
                      width: 720.w,
                    )),
                GestureDetector(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FullScreenImageLocal(
                              imageUrl: 'public/images/refrigerant/u2.jpg'),
                        ),
                      );
                    },
                    child: Image.asset(
                      'public/images/refrigerant/u2.jpg',
                      width: 720.w,
                    )),
              ],
            ),
          ),
        ));
  }
}
