import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hairgardenemployee/EMPLOYEE/emp_bottombar.dart';
import 'package:hairgardenemployee/auth/Screens/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'COMMON/common_color.dart';
import 'COMMON/const.dart';
import 'COMMON/size_config.dart';

class splash_screen extends StatefulWidget {
  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  String? user_id;

  @override
  void initState() {
    super.initState();

    get_userid() async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      user_id = sharedPreferences.getString(stored_uid);
      print("USER ID IS ${sharedPreferences.getString(stored_uid)}");
    }

    get_userid();

    Timer(const Duration(seconds: 3), () {
      user_id.toString() == "" ||
              user_id.toString() == "null" ||
              user_id == null
          ? Get.to(const login_page())
          : Get.to(emp_bottombar(pasindx: 0));
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
        color: newLightColor,
        child: Center(
          child: Container(
            height: SizeConfig.screenHeight * 0.5,
            width: SizeConfig.screenWidth * 0.8,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/HG_logo.png"))),
          ),
        ));
  }
}
