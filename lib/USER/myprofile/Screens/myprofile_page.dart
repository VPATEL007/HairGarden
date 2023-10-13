import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hairgarden/COMMON/common_circular_indicator.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:hairgarden/USER/address/Controller/get_address_controller.dart';
import 'package:hairgarden/USER/support/Screens/support_ticket.dart';
import 'package:hairgarden/auth/Screens/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../COMMON/common_color.dart';
import '../../../COMMON/size_config.dart';
import '../../address/Screens/address_page.dart';
import '../Controller/get_profile_info_controller.dart';
import '../Controller/update_profile_controller.dart';
import 'edit_profile.dart';

class myprofile_page extends StatefulWidget {
  const myprofile_page({Key? key}) : super(key: key);

  @override
  State<myprofile_page> createState() => _myprofile_pageState();
}

class _myprofile_pageState extends State<myprofile_page> {
  List profile_title = [
    "Profile",
    "Adresses",
    // "Coupon",
    "Support",
    // "Language",
  ];

  List profile_svg = [
    "assets/images/profile_profile.svg",
    "assets/images/profile_loc.svg",
    // "assets/images/profile_payment.svg",
    "assets/images/profile_support.svg",
    // "assets/images/profile_lang.svg",
  ];
  final _get_profile_info = Get.put(get_profile_info_controller());
  final _get_address = Get.put(get_address_controller());
  final _update_address = Get.put(update_profile_controller());

  // String? _get_profile_info.userID;

  Future<void> getUserID() async {
    _get_profile_info.loading(true);
    await SharedPreferences.getInstance().then((sf) {
      _get_profile_info.userID(sf.getString("stored_uid"));
      _get_profile_info.get_profile_info_cont(_get_profile_info.userID.value);
    });
  }

  @override
  void initState() {
    getUserID();
    super.initState();
  }

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
    return Scaffold(
      backgroundColor: bg_col,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: InkWell(
            onTap: () async {
              SharedPreferences sf = await SharedPreferences.getInstance();
              sf.clear();
              Get.offAll(
                  login_page(
                    frompage: '',
                  ),
                  transition: Transition.downToUp);
            },
            child: Obx(() => Text(
                  _get_profile_info.userID.value.isEmpty ? "" : "My Profile",
                  style: font_style.green_600_20,
                ))),
      ),
      body: Obx(() {
        return _get_profile_info.userID.value.isEmpty
            ? SizedBox(
                height: SizeConfig.screenHeight,
                width: SizeConfig.screenWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: SizeConfig.screenHeight * 0.3,
                      width: SizeConfig.screenWidth * 0.8,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/HG_logo.png"))),
                    ),
                    Text("PLEASE LOGIN TO CONTINUE",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Lato',
                          color: common_color,
                          fontWeight: FontWeight.w800,
                          // foreground: Paint()..shader = linear_600_16
                        )),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: InkWell(
                        onTap: () {
                          Get.offAll(
                              login_page(
                                frompage: 'skip',
                              ),
                              transition: Transition.downToUp);
                        },
                        child: Container(
                          width: SizeConfig.screenWidth * 0.9,
                          height: SizeConfig.screenHeight * 0.06,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: common_color,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Text("LOGIN / SIGNUP",
                              style: font_style.grad_600_16
                                  .copyWith(color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : _get_profile_info.loading.value
                ? const CommonIndicator()
                : Column(
                    children: [
                      // Stack(
                      //     clipBehavior: Clip.none,
                      //     alignment: Alignment.bottomCenter,
                      //     children: [
                      //       Container(
                      //         width: SizeConfig.screenWidth,
                      //         height: SizeConfig.screenHeight * 0.18,
                      //         decoration: const BoxDecoration(
                      //             image: DecorationImage(
                      //                 image: AssetImage(
                      //                     "assets/images/profile_bg_img.png"),
                      //                 fit: BoxFit.cover)),
                      //       ),
                      //       Positioned(
                      //         top: SizeConfig.screenHeight * 0.08,
                      //         child: Container(
                      //           width: SizeConfig.screenWidth * 0.3,
                      //           height: SizeConfig.screenHeight * 0.18,
                      //           decoration: BoxDecoration(
                      //               border: Border.all(color: Colors.black),
                      //               shape: BoxShape.circle,
                      //               image: DecorationImage(
                      //                   image: (_get_profile_info
                      //                               .response
                      //                               .value
                      //                               .data
                      //                               ?.profile
                      //                               ?.isNotEmpty ??
                      //                           false)
                      //                       ? NetworkImage(_get_profile_info
                      //                               .response
                      //                               .value
                      //                               .data
                      //                               ?.profile ??
                      //                           '')
                      //                       : const AssetImage(
                      //                               "assets/images/person2.jpg")
                      //                           as ImageProvider,
                      //                   fit: BoxFit.cover)),
                      //         ),
                      //       ),
                      //     ]),
                      Container(
                        width: SizeConfig.screenWidth * 0.3,
                        height: SizeConfig.screenHeight * 0.18,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: (_get_profile_info
                                    .response
                                    .value
                                    .data
                                    ?.profile
                                    ?.isNotEmpty ??
                                    false)
                                    ? NetworkImage(_get_profile_info
                                    .response
                                    .value
                                    .data
                                    ?.profile ??
                                    '')
                                    : const AssetImage(
                                    "assets/images/person2.jpg")
                                as ImageProvider,
                                fit: BoxFit.cover)),
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.01,
                      ),
                      Text(
                        _get_profile_info.response.value.data!.firstName
                            .toString(),
                        style: font_style.black_600_14_nounderline,
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.025,
                      ),
                      Center(
                        child: SizedBox(
                          width: SizeConfig.screenWidth * 0.9,
                          child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: profile_svg.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  if (index == 0) {
                                    Get.to(const edit_profile());
                                  } else if (index == 1) {
                                    getUserID().then((value) =>
                                        _get_address.get_address_cont(
                                            _get_profile_info.userID.value));
                                    Get.to(address_page(
                                      page: "address",
                                    ));
                                  }
                                  // else if (index == 2) {
                                  //
                                  //  Get.to(AllCouponPage());
                                  // }
                                  else if (index == 2) {
                                    Get.to(const SupportTicketView());
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: SizeConfig.screenHeight * 0.01,
                                      horizontal:
                                          SizeConfig.screenWidth * 0.015),
                                  width: SizeConfig.screenWidth * 0.9,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: yellow_col),
                                  ),
                                  child: Row(
                                    children: [
                                      index == 2
                                          ? Container(
                                              height: 20,
                                              width: 18,
                                              decoration: const BoxDecoration(
                                                  // color: Colors.black,
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/images/appointment.png"),
                                                      fit: BoxFit.cover)),
                                            )
                                          : SvgPicture.asset(
                                              profile_svg[index].toString(),
                                              fit: BoxFit.scaleDown,
                                            ),
                                      SizedBox(
                                        width: SizeConfig.screenWidth * 0.02,
                                      ),
                                      Text(
                                        profile_title[index].toString(),
                                        style: font_style.yellow_600_14,
                                      ),
                                      const Spacer(),
                                      // Text(
                                      //   index == 4 ? "English" : "",
                                      //   style: font_style.gr27272A_600_12,
                                      // ),
                                      const Icon(
                                        Icons.keyboard_arrow_right_outlined,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: SizeConfig.screenHeight * 0.01,
                              );
                            },
                          ),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                          onTap: () async {
                            SharedPreferences sf =
                                await SharedPreferences.getInstance();
                            sf.clear();
                            Get.offAll(
                                login_page(
                                  frompage: '',
                                ),
                                transition: Transition.downToUp);
                          },
                          child: Text(
                            "Log Out",
                            style: font_style.yellow_600_14_underline
                                .copyWith(fontSize: 18),
                          )),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.03,
                      ),
                    ],
                  );
      }),
    );
  }
}
