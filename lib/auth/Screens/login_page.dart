import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hairgarden/COMMON/common_circular_indicator.dart';
import 'package:hairgarden/COMMON/common_color.dart';
import 'package:hairgarden/COMMON/comontoast.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:hairgarden/COMMON/size_config.dart';
import 'package:hairgarden/USER/address/Controller/get_address_controller.dart';
import 'package:hairgarden/USER/bottombar/Screens/bottombar.dart';
import 'package:hairgarden/USER/category/Controller/get_all_cat_products_controller.dart';
import 'package:hairgarden/USER/category/Controller/get_cart_controller.dart';
import 'package:hairgarden/auth/Controller/send_otp_controller.dart';
import 'package:hairgarden/auth/Controller/signin_send_otp_controller.dart';
import 'package:hairgarden/auth/Controller/signin_viaotp_controller.dart';
import 'package:hairgarden/auth/Screens/signup_page.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class login_page extends StatefulWidget {
  String? frompage;

  login_page({required this.frompage});

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  bool isotp = false;
  TextEditingController lfname = TextEditingController();
  TextEditingController llname = TextEditingController();
  TextEditingController lmail = TextEditingController();
  TextEditingController lmno = TextEditingController();
  TextEditingController lotp = TextEditingController();
  var lentered_otp;

  final Gradient _gradient = const RadialGradient(
    colors: [Color(0xffBF8D2C), Color(0xffDBE466), Color(0xffBF8D2C)],
    center: Alignment.center,
  );
  final kInnerDecoration = BoxDecoration(
    border: Border.all(color: common_color, width: 2),
    borderRadius: BorderRadius.circular(32),
  );

  final kGradientBoxDecoration = BoxDecoration(
    color: common_color,
    border: Border.all(color: common_color, width: 0.3),
    borderRadius: BorderRadius.circular(32),
  );
  final _get_allprod = Get.put(get_all_cat_products_controller());
  final _send_otp = Get.put(signin_send_otp_controller());
  final _sgnin_viaotp = Get.put(signin_viaOTP_controller());
  final _get_address = Get.put(get_address_controller());

  final _send_login_otp_obj = Get.put(send_otp_controller());

  String name = "vijay";

  String? _deviceId;
  final _get_cart = Get.put(get_cart_controller());

  Future<void> initPlatformState() async {
    String? deviceId;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }
    if (!mounted) return;
    setState(() {
      _deviceId = deviceId;
    });
  }

  String? uid;

  Future<void> getuserid() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    setState(() {
      uid = sf.getString("stored_uid");
      print("USER ID ID ${uid.toString()}");
    });
  }

  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg_col,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Image.asset("assets/images/HG_logo_small.png",
            //     color: common_color,
            //     width: SizeConfig.screenWidth * 0.50, height: 45),
            // // Text("Hair Garden",style:font_style.grad_600_20),
            // SizedBox(
            //   width: SizeConfig.screenWidth * 0.2,
            // ),
            const Spacer(),
            SizedBox(
                height: SizeConfig.screenHeight * 0.015,
                width: SizeConfig.screenWidth * 0.03,
                child: Image(
                  image: const AssetImage("assets/images/star.png"),
                  color: common_color,
                  fit: BoxFit.fill,
                )),
            const SizedBox(width: 20),
            widget.frompage == "skip"
                ? Container()
                : InkWell(
                    onTap: () {
                      getuserid().then((value) {
                        initPlatformState().then((value) {
                          _get_allprod.get_all_cat_products_cont();
                          _get_address.get_address_cont(uid);
                          _get_cart.get_cart_cont(
                              uid.toString(), _deviceId.toString());
                          Get.to(const BottomBar(pasindx: 0));
                        });
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Skip',
                          style: font_style.white_400_16_under
                              .copyWith(color: common_color),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: common_color,
                          size: 15,
                        )
                      ],
                    ),
                  )
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
                                      "assets/images/lest_star.svg",
                                      color: common_color))),

                          //BIG STAR
                          Positioned(
                              top: -SizeConfig.screenHeight * 0.05,
                              right: -SizeConfig.screenWidth * 0.14,
                              child: SizedBox(
                                  height: SizeConfig.screenHeight * 0.035,
                                  width: SizeConfig.screenWidth * 0.08,
                                  child: SvgPicture.asset(
                                    "assets/images/big_star_svg.svg",
                                    color: common_color,
                                  ))),

                          //CIRCLE
                          Positioned(
                            top: -SizeConfig.screenHeight * 0.04,
                            left: -SizeConfig.screenWidth * 0.1,
                            child: Container(
                              height: SizeConfig.screenHeight * 0.08,
                              width: SizeConfig.screenWidth * 0.16,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: yellow_col, width: 3)),
                            ),
                          ),
                          // Positioned(
                          //   top: -SizeConfig.screenHeight * 0.002,
                          //   left: SizeConfig.screenWidth * 0.008,
                          //   child: Container(
                          //     height: SizeConfig.screenHeight * 0.04,
                          //     width: SizeConfig.screenWidth * 0.1,
                          //     color: Colors.transparent,
                          //   ),
                          // ),
                          Container(
                              color: bg_col,
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                "LOG IN",
                                style: TextStyle(
                                    fontSize: 32,
                                    fontFamily: 'Lato',
                                    color: common_color,
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
                          "Mobile No.*",
                          style: font_style.white_600_14.copyWith(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
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
                          keyboardType: TextInputType.phone,
                          controller: lmno,
                          maxLength: 10,
                          onChanged: (value) {
                            setState(() {
                              isotp = false;
                            });
                          },
                          // readOnly: isotp == true ? true : false,
                          style: font_style.white_400_16
                              .copyWith(color: Colors.black),
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "Enter Your Mobile Number",
                            hintStyle: font_style.white_400_16.copyWith(
                              color: Colors.black,
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: yellow_col)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: yellow_col)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.02),
                    // Center(
                    //   child: SizedBox(
                    //     width: SizeConfig.screenWidth * 0.9,
                    //     child: Text(
                    //       "You’ll receive 6-digit code to verify the number",
                    //       style: font_style.white_600_14.copyWith(color: common_color),
                    //     ),
                    //   ),
                    // ),
                    isotp == false
                        ? SizedBox(
                            height: SizeConfig.screenHeight * 0.03,
                          )
                        : SizedBox(
                            height: SizeConfig.screenHeight * 0.02,
                          ),
                    isotp == false
                        ? Container()
                        : Center(
                            child: SizedBox(
                              width: SizeConfig.screenWidth * 0.9,
                              child: OtpTextField(
                                numberOfFields: 6,
                                fillColor: yellow_col,
                                cursorColor: common_color,
                                autoFocus: true,
                                borderColor: yellow_col,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                styles: [
                                  font_style.otp_txtstyl
                                      .copyWith(color: Colors.black),
                                  font_style.otp_txtstyl
                                      .copyWith(color: Colors.black),
                                  font_style.otp_txtstyl
                                      .copyWith(color: Colors.black),
                                  font_style.otp_txtstyl
                                      .copyWith(color: Colors.black),
                                  font_style.otp_txtstyl
                                      .copyWith(color: Colors.black),
                                  font_style.otp_txtstyl
                                      .copyWith(color: Colors.black),
                                ],
                                enabledBorderColor: Colors.black,
                                keyboardType: TextInputType.phone,
                                focusedBorderColor: Colors.black,

                                //set to true to show as box or false to show as dash
                                showFieldAsBox: false,
                                //runs when a code is typed in
                                onCodeChanged: (String code) {
                                  // FocusScope.of(context).nextFocus();
                                  setState(() {
                                    // otp_controller = code.toString() ;
                                  });
                                },
                                //runs when every textfield is filled
                                onSubmit: (String verificationCode) {
                                  setState(() {
                                    lentered_otp = verificationCode;
                                  });
                                }, // end onSubmit
                              ),
                            ),
                          ),

                    //OTP BTN
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 15),
                      child: Row(
                        children: [
                          GetBuilder<signin_send_otp_controller>(
                              builder: (controller) =>
                                  (_send_otp.timer?.isActive ?? false)
                                      ? Obx(() => Text(
                                            "00:${_send_otp.timerValue.value}",
                                            style: font_style.yellow_400_14
                                                .copyWith(
                                                    fontSize: 16,
                                                    color: Colors.black),
                                          ))
                                      : const SizedBox()),
                          const Spacer(),
                          InkWell(
                              onTap: () {
                                if (isotp) {
                                  _send_login_otp_obj.send_otp_cont(
                                      lmno.text.toString(), "login");
                                  _send_otp.startTimer();
                                } else {
                                  commontoas('Please enter mobile number');
                                }
                              },
                              child: Text(
                                "Resend OTP",
                                style: font_style.yellow_400_14_underline
                                    .copyWith(
                                        fontSize: 16, color: Colors.black),
                              )),
                        ],
                      ),
                    ),
                    isotp == true
                        ? SizedBox(
                            height: SizeConfig.screenHeight * 0.05,
                          )
                        : Container(),
                    //OTP BTN
                    isotp == false
                        ? Center(
                            child: InkWell(
                                onTap: () {
                                  if (lmno.text.isEmpty) {
                                    commontoas(
                                        "Please Enter Your Mobile Number");
                                  } else {
                                    _send_login_otp_obj
                                        .send_otp_cont(
                                            lmno.text.toString(), "login")
                                        .then((value) {
                                      Get.focusScope?.unfocus();
                                      _send_otp.startTimer();
                                      if (_send_otp.checkRegister.value ==
                                          false) {
                                        setState(() {
                                          isotp = false;
                                        });
                                      } else {
                                        setState(() {
                                          isotp = true;
                                        });
                                      }
                                    });
                                    // setState(() {

                                    // _send_otp.signin_send_otp_cont(lmno.text,lfname.text).then((value) {
                                    //   if(_send_otp.checkregister==false){
                                    //     setState(() {
                                    //       isotp=false;
                                    //     });
                                    //   }
                                    //   else{
                                    //     setState(() {
                                    //       isotp=true;
                                    //     });
                                    //   }
                                    //
                                    // });
                                    // });
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                      width: SizeConfig.screenWidth * 0.9,
                                      height: SizeConfig.screenHeight * 0.06,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: common_color,
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                      child: Obx(
                                        () => _send_login_otp_obj.loading.value
                                            ? const CommonIndicator(
                                                color: Colors.white)
                                            : Text("GET OTP",
                                                style: font_style.grad_600_16
                                                    .copyWith(
                                                        color: Colors.white)),
                                      )),
                                )),
                          )
                        : Center(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (widget.frompage == "skip") {
                                    if (lentered_otp.toString() == "" ||
                                        lentered_otp == null) {
                                      commontoas("Please enter OTP");
                                    } else {
                                      _sgnin_viaotp
                                          .signin_viaOTP_cont(lmno.text,
                                              lentered_otp.toString(),_deviceId)
                                          .then((value) {
                                        if (_sgnin_viaotp
                                                    .response.value.message ==
                                                "Invalid OTP." &&
                                            _sgnin_viaotp
                                                    .response.value.status ==
                                                false) {
                                          commontoas("Please enter OTP");
                                        }
                                        else if(_sgnin_viaotp
                                            .response.value.message ==
                                            "Your aren't registred with us.")
                                        {
                                          commontoas("Your aren't registred with us.");
                                          Get.off(signup_page(frompage: ""));
                                        }
                                        else {
                                          getuserid().then((value) {
                                            initPlatformState()
                                                .then((value) async {
                                              String? getseladdindx;
                                              SharedPreferences sf =
                                                  await SharedPreferences
                                                      .getInstance();
                                              setState(() {
                                                getseladdindx = sf.getString(
                                                    "selectedaddressid");
                                              });
                                              _get_allprod
                                                  .get_all_cat_products_cont();
                                              _get_cart
                                                  .get_cart_cont(
                                                      uid.toString() == "" ||
                                                              uid == null
                                                          ? ""
                                                          : uid.toString(),
                                                      _deviceId.toString())
                                                  .then((value) {
                                                Get.to(const BottomBar(
                                                    pasindx: 0));
                                                // if (_get_cart.response.value
                                                //     .data!.isEmpty) {
                                                //
                                                //   Get.to(
                                                //       bottombar(pasindx: 0));
                                                // }
                                                // else {
                                                //
                                                //   getseladdindx==""||getseladdindx==null && _get_address.defaultaddid.toString()==""||_get_address.defaultaddid==null?
                                                //   _get_address.get_address_cont(uid).then((value) => _get_staffs.get_staffs_cont("",_get_cart.response.value.data![0].categoryId)).then((value) =>  Get.to(bookslot_page())):
                                                //   getseladdindx == "" ||
                                                //           getseladdindx ==
                                                //               null
                                                //       ? _get_address
                                                //           .get_address_cont(
                                                //               uid)
                                                //           .then((value) => _get_staffs.get_staffs_cont(
                                                //               "",
                                                //               _get_cart
                                                //                   .response
                                                //                   .value
                                                //                   .data![0]
                                                //                   .categoryId))
                                                //           .then((value) => Get.to(
                                                //               const bookslot_page()))
                                                //       : _get_address
                                                //           .get_address_cont(
                                                //               uid)
                                                //           .then((value) => _get_staffs.get_staffs_cont(
                                                //               getseladdindx,
                                                //               _get_cart
                                                //                   .response
                                                //                   .value
                                                //                   .data![0]
                                                //                   .categoryId))
                                                //           .then((value) =>
                                                //               Get.to(const bookslot_page()));
                                                // }
                                              });
                                            });
                                          });
                                        }
                                      });
                                    }
                                  }
                                  else {
                                    print('1');
                                    if (lentered_otp.toString() == "" ||
                                        lentered_otp == null) {
                                      commontoas("Please enter OTP");
                                    }
                                    else {
                                      print('3');
                                      _sgnin_viaotp
                                          .signin_viaOTP_cont(lmno.text,
                                              lentered_otp.toString(),_deviceId)
                                          .then((_) {
                                        if (_sgnin_viaotp
                                                    .response.value.message ==
                                                "Invalid OTP." &&
                                            _sgnin_viaotp
                                                    .response.value.status ==
                                                false) {
                                          commontoas("Invalid OTP.");
                                        }
                                        else if(_sgnin_viaotp
                                            .response.value.message ==
                                            "Your aren't registred with us.")
                                        {
                                          print('2');
                                          commontoas("Your aren't registred with us.");
                                          Get.off(signup_page(frompage: ""));
                                        }
                                        else {
                                          Get.to(const BottomBar(pasindx: 0));
                                        }
                                      });
                                    }
                                  }
                                });
                              },
                              child: Container(
                                width: SizeConfig.screenWidth * 0.9,
                                height: SizeConfig.screenHeight * 0.06,
                                decoration: kGradientBoxDecoration,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                    width: SizeConfig.screenWidth * 0.9,
                                    height: SizeConfig.screenHeight * 0.06,
                                    alignment: Alignment.center,
                                    decoration: kInnerDecoration,
                                    child: Obx(() {
                                      return _sgnin_viaotp.loading.value ||
                                              _get_cart.loading.value
                                          ? const CommonIndicator(
                                              color: Colors.white)
                                          : Text("LOG IN",
                                              style: font_style.grad_600_16
                                                  .copyWith(
                                                      color: Colors.white));
                                    }),
                                  ),
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
                            Text(
                              "Don’t have an Account? ",
                              style: font_style.white_400_14
                                  .copyWith(color: Colors.black),
                            ),
                            InkWell(
                                onTap: () {
                                  if (widget.frompage == "skip") {
                                    _send_otp.timer?.cancel();
                                    Get.to(signup_page(
                                      frompage: "skip",
                                    ));
                                  } else {
                                    Get.to(signup_page(
                                      frompage: "",
                                    ));
                                  }
                                },
                                child: Text(
                                  "Sign up",
                                  style: font_style.yellow_400_14_underline
                                      .copyWith(color: Colors.black),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ]),
        ),
      ),
    );
  }
}
