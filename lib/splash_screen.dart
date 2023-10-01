import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hairgarden/USER/bottombar/Screens/bottombar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'COMMON/common_color.dart';
import 'COMMON/size_config.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'USER/address/Controller/get_address_controller.dart';
import 'USER/enable_location/Screens/enable_location_page.dart';
import 'USER/map_page.dart';
import 'auth/Screens/login_page.dart';

class splash_screen extends StatefulWidget {
  const splash_screen({Key? key}) : super(key: key);

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  // var checkmail;
  String? uid;
  final _get_address=Get.put(get_address_controller());

  getUserID() async {
    await SharedPreferences.getInstance().then((sf)
    {
      setState(() {
        uid=sf.getString("stored_uid");
        print("USER ID ID ${uid.toString()}");
      });
      Timer(
        const Duration(seconds: 3),() async {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.location,
          Permission.storage,
        ].request();
        print('LOcation Status===${statuses[Permission.location]}');
        if(statuses[Permission.location]==PermissionStatus.denied)
        {
          Get.to(const enable_loation_page());
        }
        else
        {
          if(uid!=null)
          {
            Get.to(const BottomBar(pasindx: 0));
          }
          else
          {
            Get.to(login_page(frompage: ""));
          }
        }
      },
      );
    });


  }
  @override
  void initState() {
    super.initState();
    getUserID().then((value) => _get_address.get_address_cont(uid));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor:bg_col,
      body: Column(
        children: [
          const Spacer(flex: 3),
          Align(
            child: Container(
              height: SizeConfig.screenHeight*0.4,
                width: SizeConfig.screenWidth*0.8,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/HG_logo.png")
                )
              ),
            ),
          ),
          Text(
            "Your didi is on the way",
            style: font_style.white_600_16.copyWith(fontSize: 20,color: yellow_col)
          ),
          const Spacer(flex: 3),
          Text(
              "Powered By Hair Garden",
              style: font_style.white_600_16.copyWith(color: yellow_col,fontStyle: FontStyle.italic)
          ),
          const Spacer(),

        ],
      )
    );
  }
}
