import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hairgarden/COMMON/common_circular_indicator.dart';
import 'package:hairgarden/COMMON/comontoast.dart';
import 'package:hairgarden/USER/bottombar/Screens/bottombar.dart';
import 'package:hairgarden/auth/Screens/login_page.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../../COMMON/common_color.dart';
import '../../COMMON/no_glow.dart';
import '../../COMMON/size_config.dart';
import '../../USER/address/Controller/get_address_controller.dart';
import '../../USER/book_slot Payment/Controller/get_staffs_controller.dart';
import '../../USER/book_slot Payment/Screens/bookslot_page.dart';
import '../../USER/category/Controller/get_all_cat_products_controller.dart';
import '../../USER/category/Controller/get_cart_controller.dart';
import '../Controller/send_otp_controller.dart';
import '../Controller/signin_send_otp_controller.dart';
import '../Controller/signup_controller.dart';

class signup_page extends StatefulWidget {
  String? frompage;

  signup_page({required this.frompage});

  @override
  State<signup_page> createState() => _signup_pageState();
}

class _signup_pageState extends State<signup_page> {
  bool isotp = false;

  final _formkey = GlobalKey<FormState>();

  TextEditingController sfname = TextEditingController();
  TextEditingController slname = TextEditingController();
  TextEditingController smail = TextEditingController();
  TextEditingController smno = TextEditingController();
  TextEditingController sotp = TextEditingController();
  TextEditingController srefer = TextEditingController();
  var entered_otp;
  final List<String> items = [
    'Male',
    'Female',
    'OTHERS',
  ];
  String? selectedValue2;

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
  final _registrationOtp = Get.put(send_otp_controller());
  var appbarheight = AppBar().preferredSize.height;
  String? _deviceId;
  final _signup = Get.put(signup_controller());

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
  int selectedIndex = 0;
  String selectedGenderValue = '';

  Future<void> getuserid() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    setState(() {
      uid = sf.getString("stored_uid");
      print("USER ID ID ${uid.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    AppBar appbar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          // Image.asset("assets/images/HG_logo_small.png",
          //     color: common_color,
          //     width: SizeConfig.screenWidth * 0.50,
          //     height: 45),
          const Spacer(flex: 3),

          SizedBox(
              height: SizeConfig.screenHeight * 0.015,
              width: SizeConfig.screenWidth * 0.03,
              child:  Image(
                image: const AssetImage("assets/images/star.png"),
                fit: BoxFit.fill,
                color: common_color,
              )),
          const Spacer(),
          // SizedBox(width: SizeConfig.screenWidth * 0.1),
          // widget.frompage == "skip"
          //     ? Container()
          //     : InkWell(
          //         onTap: () {
          //           Get.to(BottomBar(pasindx: 0));
          //         },
          //         child: Row(
          //           children: [
          //             Text(
          //               'Skip',
          //               style: font_style.black_600_16_under
          //                   .copyWith(color: common_color),
          //             ),
          //             const SizedBox(
          //               width: 5,
          //             ),
          //              Icon(
          //               Icons.arrow_forward_ios,
          //               color: common_color,
          //               size: 15,
          //             )
          //           ],
          //         ),
          //       )
        ],
      ),
    );
    return Scaffold(
      backgroundColor: bg_col,
      appBar: appbar,
      body: ScrollConfiguration(
        behavior: NoGlow(),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: SizedBox(
            height: SizeConfig.screenHeight -
                (MediaQuery.of(context).padding.top + kToolbarHeight),
            width: SizeConfig.screenWidth,
            child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomLeft,
                children: [
                  Positioned(
                    top: SizeConfig.screenHeight * 0.8,
                    left: -SizeConfig.screenWidth * 0.6,
                    child: Container(
                      height: SizeConfig.screenHeight * 0.8,
                      width: SizeConfig.screenWidth * 0.8,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: yellow_col, width: 3)),
                    ),
                  ),
                  Column(
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //SIGNUP
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
                                      color: common_color,
                                    ))),

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
                                    border: Border.all(
                                        color: yellow_col, width: 3)),
                              ),
                            ),
                            Positioned(
                              top: -SizeConfig.screenHeight * 0.002,
                              left: SizeConfig.screenWidth * 0.008,
                              child: Container(
                                height: SizeConfig.screenHeight * 0.04,
                                width: SizeConfig.screenWidth * 0.1,
                                color: bg_col,
                              ),
                            ),
                            Container(
                                padding: const EdgeInsets.only(left: 5),
                                color: bg_col,
                                child: Text(
                                  " SIGN UP",
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontFamily: 'Lato',
                                      color: common_color,
                                      fontWeight: FontWeight.w600),
                                )),
                          ])),

                      SizedBox(
                        // height: SizeConfig.screenHeight * 0.7,
                        child: Form(
                          key: _formkey,
                          child: SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //FIRST NAME
                                // Center(
                                //   child: SizedBox(
                                //     width: SizeConfig.screenWidth*0.9,
                                //     child: Text("First Name *",style: font_style.white_600_14,),
                                //   ),
                                // ),
                                SizedBox(
                                  height: SizeConfig.screenHeight * 0.01,
                                ),
                                Center(
                                  child: SizedBox(
                                    width: SizeConfig.screenWidth * 0.9,
                                    child: TextFormField(
                                      controller: sfname,
                                      style: font_style.black_600_16
                                          ,
                                      decoration: InputDecoration(
                                        hintText: "First Name*",
                                        hintStyle: font_style.black_600_16,
                                        enabledBorder: const UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.black)),
                                        focusedBorder: const UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.black)),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: SizeConfig.screenHeight * 0.02,
                                ),

                                //LAST NAME
                                // Center(
                                //   child: SizedBox(
                                //     width: SizeConfig.screenWidth*0.9,
                                //     child: Text("Last Name *",style: font_style.white_600_14,),
                                //   ),
                                // ),
                                SizedBox(
                                  height: SizeConfig.screenHeight * 0.01,
                                ),
                                Center(
                                  child: SizedBox(
                                    width: SizeConfig.screenWidth * 0.9,
                                    child: TextFormField(
                                      controller: slname,
                                      style: font_style.black_600_16,
                                      decoration: InputDecoration(
                                        hintText: "Last Name",
                                        hintStyle: font_style.black_600_16 ,
                                        enabledBorder: const UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.black)),
                                        focusedBorder: const UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.black)),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: SizeConfig.screenHeight * 0.02,
                                ),

                                //E_MAIL
                                // Center(
                                //   child: SizedBox(
                                //     width: SizeConfig.screenWidth*0.9,
                                //     child: Text("E-Mail *",style: font_style.white_600_14,),
                                //   ),
                                // ),
                                SizedBox(
                                    height: SizeConfig.screenHeight * 0.01),
                                Center(
                                  child: SizedBox(
                                    width: SizeConfig.screenWidth * 0.9,
                                    child: TextFormField(
                                      controller: smail,
                                      style: font_style.black_600_16
                                          ,
                                      decoration: InputDecoration(
                                        hintText: "Enter Your E-Mail",
                                        hintStyle: font_style.black_600_16
                                            ,
                                        enabledBorder: const UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.black)),
                                        focusedBorder: const UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.black)),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(
                                    height: SizeConfig.screenHeight * 0.02),

                                //MOBILE NO TXT
                                // Center(
                                //   child: SizedBox(
                                //     width: SizeConfig.screenWidth*0.9,
                                //     child: Text("Enter Your Mobile No. *",style: font_style.white_600_14,),
                                //   ),
                                // ),
                                SizedBox(
                                  height: SizeConfig.screenHeight * 0.01,
                                ),
                                Center(
                                  child: SizedBox(
                                    width: SizeConfig.screenWidth * 0.9,
                                    child: TextFormField(
                                      keyboardType: TextInputType.phone,
                                      controller: smno,
                                      maxLength: 10,
                                      readOnly: isotp == true ? true : false,
                                      style: font_style.black_600_16
                                          ,
                                      decoration: InputDecoration(
                                        hintText: "Enter Your Mobile",
                                        counterText: "",
                                        hintStyle: font_style.black_600_16
                                            ,
                                        enabledBorder: const UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.black)),
                                        focusedBorder: const UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.black)),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.screenHeight * 0.02,
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                //   child: Text(
                                //     'Gender*',
                                //     style: font_style.black_600_16,
                                //     overflow: TextOverflow.ellipsis,
                                //   ),
                                // ),
                                Row(
                                  children: List.generate(
                                      items.length,
                                      (index) => Row(
                                            children: [
                                              Theme(
                                                data: ThemeData(
                                                    unselectedWidgetColor:
                                                    Colors.black),
                                                child: Radio(
                                                  activeColor: Colors.black,
                                                  value: items[index],
                                                  groupValue:
                                                      selectedGenderValue,
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      selectedIndex == index;
                                                      selectedGenderValue =
                                                          value!;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Text(items[index],
                                                  style: font_style.black_600_16
                                                      .copyWith(
                                                          color: Colors.black),
                                                  overflow:
                                                      TextOverflow.ellipsis)
                                            ],
                                          )),
                                ),
                                // SizedBox(
                                //   width: SizeConfig.screenWidth*0.9,
                                //   child: DropdownButtonHideUnderline(
                                //     child: DropdownButton2(
                                //       isExpanded: true,
                                //       hint: Row(
                                //         children:  [
                                //           Expanded(
                                //             child: Text(
                                //               'Gender*',
                                //               style: font_style.black_600_16,
                                //               overflow: TextOverflow.ellipsis,
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //       items: items
                                //           .map((item) => DropdownMenuItem<String>(
                                //         value: item,
                                //         child: Text(item, style: font_style.black_600_16, overflow: TextOverflow.ellipsis,),
                                //       ))
                                //           .toList(),
                                //       value: selectedValue2,
                                //       style: font_style.black_600_16,
                                //       onChanged: (value) {
                                //         setState(() {
                                //           selectedValue2 = value as String;
                                //         });
                                //       },
                                //       buttonStyleData: ButtonStyleData(
                                //         height: 50,
                                //         padding: EdgeInsets.zero,
                                //         width: SizeConfig.screenWidth*0.9,
                                //         decoration: BoxDecoration(
                                //           border: Border(
                                //             bottom: BorderSide(color: yellow_col),
                                //           ),
                                //           color: common_color,
                                //         ),
                                //         elevation: 0,
                                //       ),
                                //       iconStyleData:  IconStyleData(
                                //         icon: const Icon(
                                //           Icons.keyboard_arrow_down,
                                //         ),
                                //         iconSize: 20,
                                //         iconEnabledColor:yellow_col,
                                //         iconDisabledColor: Colors.grey,
                                //       ),
                                //
                                //       dropdownStyleData: DropdownStyleData(
                                //           maxHeight: 200,
                                //           width: SizeConfig.screenWidth*0.9,
                                //           decoration: BoxDecoration(
                                //             gradient: LinearGradient(
                                //                 colors: [
                                //                   common_color,
                                //                   yellow_col,
                                //                 ],
                                //                 begin: Alignment.topCenter,
                                //                 end: Alignment.bottomCenter
                                //             ),
                                //             borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(14),bottomRight: Radius.circular(14)),
                                //             border: Border.all(color: common_color),
                                //
                                //           ),
                                //           elevation: 0,
                                //           scrollbarTheme: ScrollbarThemeData(
                                //             radius: const Radius.circular(40),
                                //             thickness: MaterialStateProperty.all(6),
                                //             thumbVisibility: MaterialStateProperty.all(true),
                                //           )),
                                //
                                //     ),
                                //   ),
                                // ),

                                //REFER CODE
                                // Center(
                                //   child: SizedBox(
                                //     width: SizeConfig.screenWidth*0.9,
                                //     child: Text("Refer Code",style: font_style.white_600_14,),
                                //   ),
                                // ),

                                SizedBox(
                                  height: SizeConfig.screenHeight * 0.002,
                                ),
                                Center(
                                  child: SizedBox(
                                    width: SizeConfig.screenWidth * 0.9,
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      controller: srefer,
                                      style: font_style.black_600_16
                                          ,
                                      decoration: InputDecoration(
                                        hintText: "Refer Code",
                                        hintStyle: font_style.black_600_16
                                            ,
                                        enabledBorder: const UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.black)),
                                        focusedBorder: const UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.black)),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: SizeConfig.screenHeight * 0.005,
                                ),
                                //OTP TXTFORM
                                isotp == false
                                    ? Container()
                                    : Center(
                                        /// otp container:
                                        child: SizedBox(
                                          width: SizeConfig.screenWidth * 0.9,
                                          child: OtpTextField(
                                            numberOfFields: 6,
                                            fillColor: yellow_col,
                                            cursorColor: Colors.white,
                                            autoFocus: true,
                                            borderColor: yellow_col,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            styles: [
                                              font_style.otp_txtstyl.copyWith(color: yellow_col),
                                              font_style.otp_txtstyl.copyWith(color: yellow_col),
                                              font_style.otp_txtstyl.copyWith(color: yellow_col),
                                              font_style.otp_txtstyl.copyWith(color: yellow_col),
                                              font_style.otp_txtstyl.copyWith(color: yellow_col),
                                              font_style.otp_txtstyl.copyWith(color: yellow_col),
                                            ],
                                            enabledBorderColor: Colors.black,
                                            keyboardType: TextInputType.phone,
                                            focusedBorderColor: Colors.black,
                                            //set to true to show as box or false to show as dash
                                            showFieldAsBox: false,
                                            //runs when a code is typed in
                                            onCodeChanged: (String code) {
                                              FocusScope.of(context)
                                                  .nextFocus();
                                              setState(() {
                                                // otp_controller = code.toString() ;
                                              });
                                            },
                                            //runs when every textfield is filled
                                            onSubmit:
                                                (String verificationCode) {
                                              setState(() {
                                                entered_otp = verificationCode;
                                              });
                                            }, // end onSubmit
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      //SIGNUP OTP BUTTON
                      isotp == false
                          ? Center(
                              child: InkWell(
                                onTap: () {
                                  if (sfname.text == "" ||
                                      slname.text == "" ||
                                      smail.text == "" ||
                                      smno.text == "" ||
                                      selectedGenderValue == "") {
                                    commontoas("Please fill required field..");
                                  }
                                  else if(smno.text.length<10)
                                  {
                                    commontoas("Please Enter 10 Digit Mobile Number");
                                  }
                                  else {
                                    _registrationOtp
                                        .send_otp_cont(smno.text, "Singup")
                                        .then((value) {
                                      setState(() {
                                        isotp = true;
                                      });
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                      width: SizeConfig.screenWidth * 0.9,
                                      height: SizeConfig.screenHeight * 0.06,
                                      alignment: Alignment.center,
                                      decoration: kInnerDecoration,
                                      child: Obx(() => _registrationOtp
                                              .loading.value
                                          ? const CommonIndicator(color: Colors.white)
                                          : Text("GET OTP",
                                              style: font_style.grad_600_16
                                                  .copyWith(
                                                      color: Colors.white)))),
                                ),
                              ),
                            )
                          : Center(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    // isotp=false;
                                    if (widget.frompage == "skip") {
                                      _signup.signup_cont(
                                        'skip',
                                        sfname.text,
                                        slname.text,
                                        smail.text,
                                        smno.text,
                                        "123456",
                                        entered_otp,
                                        srefer.text == "" ? "" : srefer.text,
                                        selectedGenderValue.toString(),
                                      );
                                    } else {
                                      _signup.signup_cont(
                                        '',
                                        sfname.text,
                                        slname.text,
                                        smail.text,
                                        smno.text,
                                        "123456",
                                        entered_otp,
                                        srefer.text == "8076306373"
                                            ? ""
                                            : srefer.text,
                                        selectedGenderValue.toString(),
                                      );
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
                                        border: Border.all(color: common_color, width: 1),
                                        borderRadius: BorderRadius.circular(32),
                                    ),
                                    child: Obx(() {
                                      return _signup.loading.value
                                          ? const CommonIndicator(color: Colors.white)
                                          : Text( "SIGN UP",
                                          style: font_style.grad_600_16.copyWith(color: common_color));
                                    }),
                                  ),
                                ),
                              ),
                            ),

                      //ALREADY ACCOUNT
                      Center(
                        child: SizedBox(
                          width: SizeConfig.screenWidth * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an Account? ",
                                style: font_style.black_400_14,
                              ),
                              InkWell(
                                  onTap: () {
                                    if (widget.frompage == "skip") {
                                      Get.to(login_page(
                                        frompage: 'skip',
                                      ),transition: Transition.downToUp );
                                    } else {
                                      Get.to(login_page(
                                        frompage: '',
                                      ),transition: Transition.downToUp );
                                    }
                                  },
                                  child: Text(
                                    "Log In",
                                    style: font_style.black_400_14_under.copyWith(fontWeight: FontWeight.w600),
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
      ),
    );
  }
}
