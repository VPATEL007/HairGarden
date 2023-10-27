import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hairgardenemployee/COMMON/comman_toast.dart';
import 'package:hairgardenemployee/auth/controller/send_reg_otp_controller.dart';
import 'package:hairgardenemployee/auth/controller/staff_signup_controller.dart';
import '../../COMMON/common_color.dart';
import '../../COMMON/common_indicator.dart';
import '../../COMMON/no_glow.dart';
import '../../COMMON/size_config.dart';
import 'package:hairgardenemployee/COMMON/font_style.dart';

import 'login_page.dart';

class signup_page extends StatefulWidget {
  const signup_page({Key? key}) : super(key: key);

  @override
  State<signup_page> createState() => _signup_pageState();
}

class _signup_pageState extends State<signup_page> {
  final _staff_signup = Get.put(staff_signup_controller());
  final _send_otp = Get.put(send_reg_otp_controller());

  TextEditingController fullname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController mobile = TextEditingController();
  String otp = "";
  TextEditingController password = TextEditingController();

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
  var appbarheight = AppBar().preferredSize.height;
  final List<String> items = [
    'MALE',
    'FEMALE',
    'OTHERS',
  ];
  String selectedGenderValue = 'MALE';

  String? selectedValue1, selectedValue2;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    _staff_signup.allStaffService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: newLightColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image(
                image: const AssetImage("assets/images/HG_logo_small.png"),
                color: common_color),
            // Text("Hair Garden",style:font_style.grad_600_20),
            SizedBox(
              width: SizeConfig.screenWidth * 0.07,
            ),
            SizedBox(
                height: SizeConfig.screenHeight * 0.015,
                width: SizeConfig.screenWidth * 0.03,
                child: Image(
                  image: const AssetImage("assets/images/star.png"),
                  color: common_color,
                  fit: BoxFit.fill,
                )),
          ],
        ),
      ),
      body: Obx(() => _staff_signup.loading.value
          ? const Center(
              child: commonindicator(),
            )
          : ScrollConfiguration(
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
                          top: SizeConfig.screenHeight * 0.5,
                          left: -SizeConfig.screenWidth * 0.6,
                          child: Container(
                            height: SizeConfig.screenHeight * 0.8,
                            width: SizeConfig.screenWidth * 0.8,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: yellow_col, width: 3)),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            // mainAxisSize: MainAxisSize.min,
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //SIGNUP
                              Center(
                                  child: Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.topLeft,
                                      children: [
                                        // Container(
                                        //     padding: const EdgeInsets.only(left: 5),
                                        //     color: common_color,
                                        //     child: const Text(
                                        //       " ",
                                        //       style: TextStyle(
                                        //           fontSize: 32,
                                        //           fontFamily: 'Lato',
                                        //           color: Colors.white,
                                        //           fontWeight: FontWeight.w600),
                                        //     )),
                                        //LEFT STAR
                                        Positioned(
                                            top: -SizeConfig.screenHeight * 0.00,
                                            left: -SizeConfig.screenWidth * 0.23,
                                            child: SizedBox(
                                                height:
                                                SizeConfig.screenHeight * 0.015,
                                                width:
                                                SizeConfig.screenWidth * 0.09,
                                                child: SvgPicture.asset(
                                                    "assets/images/lest_star.svg",
                                                    color: common_color))),

                                        //BIG STAR
                                        Positioned(
                                            top: -SizeConfig.screenHeight * 0.00,
                                            right: -SizeConfig.screenWidth * 0.14,
                                            child: SizedBox(
                                                height:
                                                SizeConfig.screenHeight * 0.035,
                                                width:
                                                SizeConfig.screenWidth * 0.08,
                                                child: SvgPicture.asset(
                                                    "assets/images/big_star_svg.svg",
                                                    color: common_color))),

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
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        Container(
                                            padding: const EdgeInsets.only(left: 5),
                                            color: newLightColor,
                                            child: Text(
                                              "SIGN UP",
                                              style: TextStyle(
                                                  fontSize: 32,
                                                  fontFamily: 'Lato',
                                                  color: common_color,
                                                  fontWeight: FontWeight.w600),
                                            )),
                                      ])),

                              Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    //FIRST NAME
                                    Center(
                                      child: SizedBox(
                                        width: SizeConfig.screenWidth * 0.9,
                                        child: TextFormField(
                                          controller: fullname,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please Enter First name";
                                            }
                                            return null;
                                          },
                                          style: font_style.white_400_16
                                              .copyWith(color: Colors.black),
                                          decoration: InputDecoration(
                                            hintText: "First Name*",
                                            hintStyle: font_style.white_400_16
                                                .copyWith(color: Colors.black),
                                            enabledBorder:
                                            const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            focusedBorder:
                                            const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.002,
                                    ),

                                    //LAST NAM
                                    Center(
                                      child: SizedBox(
                                        width: SizeConfig.screenWidth * 0.9,
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please Enter Last name";
                                            }
                                            return null;
                                          },
                                          controller: lastname,
                                          style: font_style.white_400_16
                                              .copyWith(color: Colors.black),
                                          decoration: InputDecoration(
                                            hintText: "Last Name*",
                                            hintStyle: font_style.white_400_16
                                                .copyWith(color: Colors.black),
                                            enabledBorder:
                                            const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            focusedBorder:
                                            const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.002,
                                    ),

                                    //E_MAIL
                                    Center(
                                      child: SizedBox(
                                        width: SizeConfig.screenWidth * 0.9,
                                        child: TextFormField(
                                          controller: email,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please Enter E-mail id";
                                            } else if (!value.isEmail) {
                                              return "Please Enter Valid E-mail id";
                                            }
                                            return null;
                                          },
                                          style: font_style.white_400_16
                                              .copyWith(color: Colors.black),
                                          decoration: InputDecoration(
                                            hintText: "E-mail*",
                                            hintStyle: font_style.white_400_16
                                                .copyWith(color: Colors.black),
                                            enabledBorder:
                                            const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            focusedBorder:
                                            const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.002,
                                    ),

                                    //PROFESSION
                                    SizedBox(
                                      width: SizeConfig.screenWidth * 0.9,
                                      child:
                                      Obx(() => DropdownButtonHideUnderline(
                                        child: DropdownButton2(
                                          isExpanded: true,
                                          hint: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'What is your Profession?*',
                                                  style: font_style
                                                      .white_400_16
                                                      .copyWith(
                                                      color: Colors
                                                          .black),
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          items: List.generate(
                                              _staff_signup
                                                  .getStaffService()
                                                  .data
                                                  ?.length ??
                                                  0,
                                                  (index) =>
                                                  DropdownMenuItem<
                                                      String>(
                                                    value: _staff_signup
                                                        .getStaffService()
                                                        .data?[index]
                                                        .name,
                                                    child: Column(
                                                      mainAxisSize:
                                                      MainAxisSize
                                                          .min,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Obx(() => Checkbox(
                                                                visualDensity: VisualDensity.compact,
                                                                activeColor: yellow_col,
                                                                value: _staff_signup.selectedCheckValueList.contains(index),
                                                                onChanged: (value) {
                                                                  if (_staff_signup
                                                                      .selectedCheckValueList
                                                                      .contains(index)) {
                                                                    _staff_signup.selectedCheckValueList.remove(index); // unselect
                                                                  } else {
                                                                    if (!_staff_signup.selectedProfession.contains(_staff_signup.getStaffService().data?[index].id)) {
                                                                      _staff_signup.selectedProfession.add(_staff_signup.getStaffService().data?[index].id);
                                                                    }

                                                                    _staff_signup.selectedCheckValueList.add(index);
                                                                    print('Length===${_staff_signup.selectedProfession.toString().substring(1, _staff_signup.selectedProfession.toString().length - 1)}'); // select
                                                                  }
                                                                })),
                                                            Text(
                                                              _staff_signup
                                                                  .getStaffService()
                                                                  .data?[index]
                                                                  .name ??
                                                                  '',
                                                              style: font_style
                                                                  .white_400_16
                                                                  .copyWith(
                                                                  color: common_color),
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                          height: 1.5,
                                                          width: SizeConfig
                                                              .screenWidth *
                                                              0.9,
                                                          color:
                                                          yellow_col,
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                          value: selectedValue1,
                                          style:
                                          font_style.white_400_16,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedValue1 =
                                              value as String;
                                            });
                                          },
                                          buttonStyleData:
                                          ButtonStyleData(
                                            height: 50,
                                            padding: EdgeInsets.zero,
                                            width:
                                            SizeConfig.screenWidth *
                                                0.9,
                                            decoration:
                                            const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color:
                                                    Colors.black),
                                              ),
                                              color: Colors.transparent,
                                            ),
                                            elevation: 0,
                                          ),
                                          iconStyleData: IconStyleData(
                                            icon: const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.black,
                                            ),
                                            iconSize: 20,
                                            iconEnabledColor:
                                            yellow_col,
                                            iconDisabledColor:
                                            Colors.grey,
                                          ),
                                          dropdownStyleData:
                                          DropdownStyleData(
                                              maxHeight: 250,
                                              width: SizeConfig
                                                  .screenWidth *
                                                  0.9,
                                              decoration:
                                              BoxDecoration(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    14),
                                                border: Border.all(
                                                    color:
                                                    common_color),
                                              ),
                                              elevation: 2,
                                              padding:
                                              const EdgeInsets
                                                  .symmetric(
                                                  vertical: 10),
                                              scrollbarTheme:
                                              ScrollbarThemeData(
                                                radius: const Radius
                                                    .circular(40),
                                                thickness:
                                                MaterialStateProperty
                                                    .all(6),
                                                thumbVisibility:
                                                MaterialStateProperty
                                                    .all(true),
                                              )),
                                        ),
                                      )),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.015,
                                    ),

                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.040,
                                      child: Row(
                                        children: List.generate(
                                            items.length,
                                                (index) => Row(
                                              children: [
                                                Transform.scale(
                                                  scale: 0.7,
                                                  child: Theme(
                                                    data: ThemeData(
                                                        unselectedWidgetColor:
                                                        Colors.black),
                                                    child: Radio(
                                                      activeColor:
                                                      Colors.black,
                                                      value: items[index],
                                                      groupValue:
                                                      selectedGenderValue,
                                                      onChanged:
                                                          (String? value) {
                                                        setState(() {
                                                          selectedGenderValue =
                                                          value!;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Text(items[index],
                                                    style: font_style
                                                        .white_400_16
                                                        .copyWith(
                                                        color: Colors
                                                            .black),
                                                    overflow: TextOverflow
                                                        .ellipsis)
                                              ],
                                            )),
                                      ),
                                    ),
                                    // SizedBox(
                                    //     height: SizeConfig.screenHeight * 0.002),

                                    //MOBILE NO TXT
                                    Center(
                                      child: SizedBox(
                                        width: SizeConfig.screenWidth * 0.9,
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please Enter Mobile Number";
                                            }
                                            return null;
                                          },
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(10)
                                          ],
                                          controller: mobile,
                                          maxLength: 10,
                                          keyboardType: TextInputType.number,
                                          style: font_style.white_400_16
                                              .copyWith(color: Colors.black),
                                          decoration: InputDecoration(
                                            counterText: "",
                                            hintText: "Mobile no.*",
                                            hintStyle: font_style.white_400_16
                                                .copyWith(color: Colors.black),
                                            enabledBorder:
                                            const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            focusedBorder:
                                            const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                        height:
                                        SizeConfig.screenHeight * 0.002),
                                    Center(
                                      child: SizedBox(
                                        width: SizeConfig.screenWidth * 0.9,
                                        child: TextFormField(
                                          controller: address,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please Enter Address";
                                            }
                                            return null;
                                          },
                                          style: font_style.white_400_16
                                              .copyWith(color: Colors.black),
                                          decoration: InputDecoration(
                                            hintText: "Address*",
                                            hintStyle: font_style.white_400_16
                                                .copyWith(color: Colors.black),
                                            enabledBorder:
                                            const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            focusedBorder:
                                            const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.002,
                                    ),
                                    Center(
                                      child: SizedBox(
                                        width: SizeConfig.screenWidth * 0.9,
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please Enter Pincode";
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.phone,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(6)
                                          ],
                                          controller: pincode,
                                          style: font_style.white_400_16
                                              .copyWith(color: Colors.black),
                                          decoration: InputDecoration(
                                            hintText: "Pincode*",
                                            hintStyle: font_style.white_400_16
                                                .copyWith(color: Colors.black),
                                            enabledBorder:
                                            const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            focusedBorder:
                                            const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.005,
                                    ),
                                    //OTP TXTFORM
                                    _send_otp.isotp() == false
                                        ? Container()
                                        : Center(
                                      child: SizedBox(
                                        width:
                                        SizeConfig.screenWidth * 0.9,
                                        child: OtpTextField(
                                          numberOfFields: 6,
                                          fillColor: Colors.black,
                                          cursorColor: Colors.white,
                                          autoFocus: true,
                                          borderColor: Colors.black,
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          styles: [
                                            font_style.otp_txtstyl
                                                .copyWith(
                                                color: Colors.black),
                                            font_style.otp_txtstyl
                                                .copyWith(
                                                color: Colors.black),
                                            font_style.otp_txtstyl
                                                .copyWith(
                                                color: Colors.black),
                                            font_style.otp_txtstyl
                                                .copyWith(
                                                color: Colors.black),
                                            font_style.otp_txtstyl
                                                .copyWith(
                                                color: Colors.black),
                                            font_style.otp_txtstyl
                                                .copyWith(
                                                color: Colors.black),
                                          ],
                                          enabledBorderColor:
                                          Colors.black,
                                          keyboardType:
                                          TextInputType.phone,
                                          focusedBorderColor:
                                          Colors.black,
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
                                              otp = verificationCode;
                                            });
                                          }, // end onSubmit
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.015,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.screenHeight * 0.002,
                              ),
                              //SIGNUP OTP BUTTON
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    if (formKey.currentState!.validate()) {
                                      if (_send_otp.isotp() == false) {
                                        _send_otp.send_reg_otp_cont(
                                            mobile.text.toString());
                                      } else {
                                        if (_staff_signup
                                            .selectedProfession.isNotEmpty) {
                                          _staff_signup
                                              .staff_signup_cont(
                                              fullname.text.toString(),
                                              lastname.text.toString(),
                                              email.text.toString(),
                                              mobile.text.toString(),
                                              "123456",
                                              otp.toString(),
                                              selectedGenderValue
                                                  .toString(),
                                              _staff_signup
                                                  .selectedProfession
                                                  .toString()
                                                  .substring(
                                                  1,
                                                  _staff_signup
                                                      .selectedProfession
                                                      .toString()
                                                      .length -
                                                      1),
                                              "",
                                              pincode.text,
                                              address.text)
                                              .then((value) {
                                            otp = "";
                                          });
                                        } else {
                                          commonToast(
                                              'Please Select Your Profession');
                                        }
                                      }
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
                                        border: Border.all(
                                            color: common_color, width: 1),
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                      child: _send_otp.loading.value ||
                                          _staff_signup.loading.value
                                          ? const commonindicator()
                                          : Text(
                                        _send_otp.isotp()
                                            ? "SIGN UP"
                                            : "GET OTP",
                                        style: font_style.grad_600_16
                                            .copyWith(color: bg_col),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: SizeConfig.screenHeight * 0.03),
                              //ALREADY ACCOUNT
                              Center(
                                child: SizedBox(
                                  width: SizeConfig.screenWidth * 0.9,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Already have an Account? ",
                                        style: font_style.white_400_14
                                            .copyWith(color: Colors.black),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            Get.to(const login_page());
                                          },
                                          child: Text(
                                            "Log In",
                                            style: font_style
                                                .yellow_400_14_underline
                                                .copyWith(color: Colors.black),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: SizeConfig.screenHeight * 0.02),
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
            )),
    );
  }

  @override
  void dispose() {
    fullname.clear();
    lastname.clear();
    email.clear();
    mobile.clear();
    otp = "";
    super.dispose();
  }
}
