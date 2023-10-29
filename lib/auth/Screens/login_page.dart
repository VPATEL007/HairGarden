import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hairgardenemployee/COMMON/comman_toast.dart';
import 'package:hairgardenemployee/COMMON/common_indicator.dart';
import 'package:hairgardenemployee/auth/Screens/signup_page.dart';
import 'package:hairgardenemployee/auth/controller/send_login_otp_controller.dart';
import 'package:hairgardenemployee/auth/controller/staff_login_controller.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../../COMMON/common_color.dart';
import '../../COMMON/size_config.dart';
import 'package:hairgardenemployee/COMMON/font_style.dart';

class login_page extends StatefulWidget {
  const login_page({Key? key}) : super(key: key);

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  final _staff_login = Get.put(staff_login_controller());
  final _send_otp = Get.put(send_login_otp_controller());

  TextEditingController mobile = TextEditingController();
  var otp;

  // final Gradient _gradient = const RadialGradient(
  //   colors: [
  //     Color(0xffBF8D2C),Color(0xffDBE466), Color(0xffBF8D2C)
  //   ],
  //   center: Alignment.center,
  // );
  final kInnerDecoration = BoxDecoration(
    color: common_color,
    border: Border.all(color: Colors.transparent, width: 0),
    borderRadius: BorderRadius.circular(32),
  );

  final kGradientBoxDecoration = BoxDecoration(
    gradient: const LinearGradient(
        colors: [Color(0xffBF8D2C), Color(0xffDBE466), Color(0xffBF8D2C)]),
    border: Border.all(color: Colors.transparent, width: 0.3),
    borderRadius: BorderRadius.circular(32),
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: newLightColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
               Image(image: AssetImage("assets/images/HG_logo_small.png",),color: common_color),
              // Text("Hair Garden",style:font_style.grad_600_20),
              SizedBox(
                width: SizeConfig.screenWidth * 0.2,
              ),
              SizedBox(
                  height: SizeConfig.screenHeight * 0.015,
                  width: SizeConfig.screenWidth * 0.03,
                  child: const Image(
                    image: AssetImage("assets/images/star.png"),
                    fit: BoxFit.fill,
                  )),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: SizeConfig.screenHeight * 0.8,
            width: SizeConfig.screenWidth,
            child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomLeft,
                children: [
                  //LAST CIRCLE
                  Positioned(
                    top: SizeConfig.screenHeight * 0.45,
                    left: -SizeConfig.screenWidth * 0.3,
                    child: Container(
                      height: SizeConfig.screenHeight * 0.8,
                      width: SizeConfig.screenWidth * 0.8,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: yellow_col, width: 3)),
                    ),
                  ),

                  //UI
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.12,
                      ),
                      //LOGIN
                      Center(
                          child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.topLeft,
                              children: [
                            Container(
                                padding: const EdgeInsets.only(left: 5),
                                color: common_color,
                                child: const Text(
                                  " ",
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontFamily: 'Lato',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                )),
                            //LEFT STAR
                            Positioned(
                                top: -SizeConfig.screenHeight * 0.02,
                                left: -SizeConfig.screenWidth * 0.23,
                                child: SizedBox(
                                    height: SizeConfig.screenHeight * 0.015,
                                    width: SizeConfig.screenWidth * 0.09,
                                    child: SvgPicture.asset(
                                        "assets/images/lest_star.svg",color: common_color))),

                            //BIG STAR
                            Positioned(
                                top: -SizeConfig.screenHeight * 0.05,
                                right: -SizeConfig.screenWidth * 0.14,
                                child: SizedBox(
                                    height: SizeConfig.screenHeight * 0.035,
                                    width: SizeConfig.screenWidth * 0.08,
                                    child: SvgPicture.asset(
                                        "assets/images/big_star_svg.svg",color: common_color))),

                            //CIRCLE
                            Positioned(
                              top: -SizeConfig.screenHeight * 0.04,
                              left: -SizeConfig.screenWidth * 0.1,
                              child: Container(
                                height: SizeConfig.screenHeight * 0.08,
                                width: SizeConfig.screenWidth * 0.16,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: yellow_col, width: 3)),
                              ),
                            ),
                            // Positioned(
                            //   top: -SizeConfig.screenHeight * 0.002,
                            //   left: SizeConfig.screenWidth * 0.008,
                            //   child: Container(
                            //     height: SizeConfig.screenHeight * 0.04,
                            //     width: SizeConfig.screenWidth * 0.1,
                            //     color: Colors.white,
                            //   ),
                            // ),
                            Container(
                                padding: const EdgeInsets.only(left: 5),
                                color: newLightColor,
                                child:  Text(
                                  "LOG IN",
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontFamily: 'Lato',
                                      color:common_color,
                                      fontWeight: FontWeight.w600),
                                )),
                          ])),

                      SizedBox(
                        height: SizeConfig.screenHeight * 0.1,
                      ),

                      //MOBILE NO TXT
                      Center(
                        child: SizedBox(
                          width: SizeConfig.screenWidth * 0.9,
                          child: Text(
                            "Mobile No.",
                            style: font_style.white_600_14.copyWith(color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.01,
                      ),
                      Center(
                        child: SizedBox(
                          width: SizeConfig.screenWidth * 0.9,
                          child: TextFormField(
                            maxLength: 10,
                            style: font_style.white_400_16.copyWith(color: Colors.black),
                            controller: mobile,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: "Enter Your Mobile Number",
                              hintStyle: font_style.white_400_16.copyWith(color: Colors.black),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                      Center(
                        child: SizedBox(
                          width: SizeConfig.screenWidth * 0.9,
                          child: Text(
                            "You’ll receive 6-digit code to verify the number",
                            style: font_style.white_600_14.copyWith(color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                      _send_otp.isotp() == false
                          ? SizedBox(height: SizeConfig.screenHeight * 0.02)
                          :
                          //OTP BTN
                          _send_otp.isotp() == false
                              ? Container()
                              : Center(
                                  child: SizedBox(
                                    width: SizeConfig.screenWidth * 0.9,
                                    child: OtpTextField(
                                      numberOfFields: 6,
                                      fillColor: yellow_col,
                                      cursorColor: Colors.black,
                                      autoFocus: true,
                                      borderColor: Colors.black,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      styles: [
                                        font_style.otp_txtstyl.copyWith(color: Colors.black),
                                        font_style.otp_txtstyl.copyWith(color: Colors.black),
                                        font_style.otp_txtstyl.copyWith(color: Colors.black),
                                        font_style.otp_txtstyl.copyWith(color: Colors.black),
                                        font_style.otp_txtstyl.copyWith(color: Colors.black),
                                        font_style.otp_txtstyl.copyWith(color: Colors.black),
                                      ],
                                      enabledBorderColor: yellow_col,
                                      keyboardType: TextInputType.phone,
                                      focusedBorderColor: yellow_col,
                                      //set to true to show as box or false to show as dash
                                      showFieldAsBox: false,

                                      //runs when a code is typed in
                                      onCodeChanged: (String code) {
                                        FocusScope.of(context).nextFocus();
                                        setState(() {
                                          // otp_controller = code.toString() ;
                                        });
                                      },
                                      //runs when every textfield is filled
                                      onSubmit: (String verificationCode) {
                                        setState(() {
                                          otp = verificationCode;
                                        });
                                      }, // end onSubmit
                                    ),
                                  ),
                                ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 15),
                        child: Row(
                          children: [
                            GetBuilder<staff_login_controller>(
                                builder: (controller) =>
                                    (_staff_login.timer?.isActive ?? false)
                                        ? Obx(() => Text(
                                              "00:${_staff_login.timerValue.value}",
                                              style: font_style.yellow_400_14
                                                  .copyWith(fontSize: 16,color: Colors.black),
                                            ))
                                        : const SizedBox()),
                            const Spacer(),
                            GestureDetector(
                                onTap: () {
                                  if (_send_otp.isotp() == true) {
                                    _staff_login.startTimer();
                                  } else {
                                    commonToast('Please enter mobile number');
                                  }
                                },
                                child: Text(
                                  "Resend OTP",
                                  style: font_style.yellow_400_14_underline
                                      .copyWith(fontSize: 16,color: Colors.black),
                                )),
                          ],
                        ),
                      ),
                      _send_otp.isotp() == true
                          ? SizedBox(
                              height: SizeConfig.screenHeight * 0.05,
                            )
                          : Container(),
                      //OTP BTN
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_send_otp.isotp() == false) {
                                log("MOBILE==${mobile.text}");
                                if(mobile.text.length>=10)
                                  {
                                    _send_otp
                                        .send_login_otp_cont(mobile.text.toString())
                                        .then((value) => _staff_login.startTimer());
                                  }
                                else
                                  {
                                    commonToast('Please Enter 10 Digit Mobile Number');
                                  }
                              } else {
                                _staff_login
                                    .staff_login_cont(
                                        mobile.text, otp.toString());
                                // isotp=false;
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              width: SizeConfig.screenWidth * 0.9,
                              height: SizeConfig.screenHeight * 0.06,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: common_color,
                                border: Border.all(color: common_color, width: 1),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: _send_otp.loading.value ||
                                      _staff_login.loading.value
                                  ? const commonindicator(color: Colors.white)
                                  : Text(_send_otp.isotp() == false
                                  ? "GET OTP"
                                  : "LOG IN",
                                style: font_style.grad_600_16.copyWith(color: bg_col)),
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),
                      Center(
                        child: SizedBox(
                          width: SizeConfig.screenWidth * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    print("SDSD");
                                  },
                                  child: Text(
                                    "Don’t have an Account? ",
                                    style: font_style.white_400_14.copyWith(color: Colors.black),
                                  )),
                              GestureDetector(
                                  onTap: () {
                                    Get.to(const signup_page());
                                  },
                                  child: Text(
                                    "Sign up",
                                    style: font_style.yellow_400_14_underline.copyWith(color: Colors.black),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    _send_otp.isotp = false.obs;
    super.initState();
  }

  @override
  void dispose() {
    mobile.clear();
    otp = "";
    super.dispose();
  }
}
