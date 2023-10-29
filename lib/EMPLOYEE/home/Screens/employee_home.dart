import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hairgardenemployee/COMMON/common_indicator.dart';
import 'package:hairgardenemployee/COMMON/const.dart';
import 'package:hairgardenemployee/COMMON/font_style.dart';
import 'package:hairgardenemployee/EMPLOYEE/emp_bottombar.dart';
import 'package:hairgardenemployee/EMPLOYEE/home/controller/home_controller.dart';
import 'package:hairgardenemployee/EMPLOYEE/profile/controller/profile_controller.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../COMMON/common_color.dart';
import '../../../COMMON/size_config.dart';

class employee_home extends StatefulWidget {
  const employee_home({Key? key}) : super(key: key);

  @override
  State<employee_home> createState() => _employee_homeState();
}

class _employee_homeState extends State<employee_home> {
  final homeController = Get.put(HomeController());
  final staffProfileController = Get.put(StaffProfileController());

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    homeController.loading(true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString(stored_uid) ?? '';
    staffProfileController.fetchStaffProfile(id);
    homeController.fetchALlBooking(id);
    homeController.fetchBookingHistory(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: newLightColor,
      body: Obx(() =>
      homeController.loading.value
          ? const commonindicator().paddingOnly(top: 70)
          : SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.screenHeight * 0.03,
              ),
              //HII NAME TXT
              Center(
                child: SizedBox(
                  width: SizeConfig.screenWidth * 0.9,
                  child: Text(
                    "Hi  ${staffProfileController
                        .model()
                        .data
                        ?.firstName ?? ''} ${staffProfileController
                        .model()
                        .data
                        ?.lastName ?? ''}",
                    style: font_style.black_600_28,
                  ),
                ),
              ),

              SizedBox(
                height: SizeConfig.screenHeight * 0.005,
              ),

              //HOW R U TODAY TXT
              Center(
                child: SizedBox(
                  width: SizeConfig.screenWidth * 0.9,
                  child: Text(
                    "How Are You Today",
                    style: font_style.greyA1A1AA_400_16,
                  ),
                ),
              ),

              SizedBox(
                height: SizeConfig.screenHeight * 0.04,
              ),

              //CALENDAR GREEN CONTAINER
              Center(
                child: GestureDetector(
                  onTap: () {
                    Get.offAll(emp_bottombar(pasindx: 1));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenWidth * 0.022,
                        vertical: SizeConfig.screenHeight * 0.015),
                    width: SizeConfig.screenWidth * 0.9,
                    decoration: BoxDecoration(
                      color: common_color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                            "assets/images/emp_home_cal.svg"),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.025,
                        ),
                        Text(
                          "View All Appointment",
                          style: font_style.white_600_14,
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.keyboard_arrow_right,
                          color: Color(0xffD4D4D8),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: SizeConfig.screenHeight * 0.03,
              ),

              //New Orders TXT
              Center(
                child: SizedBox(
                  width: SizeConfig.screenWidth * 0.9,
                  child: Text(
                    "New Orders",
                    style: font_style.black_600_16,
                  ),
                ),
              ),

              SizedBox(
                height: SizeConfig.screenHeight * 0.02,
              ),
              Obx(() =>
              homeController.model.value.data?.isNotEmpty ?? false
                  ? ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount:
                homeController.model.value.data?.length ??
                    0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                        SizeConfig.screenWidth * 0.05),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${homeController
                                  .model()
                                  .data?[index].customer?.firstName
                                  .toString()
                                  .capitalizeFirst} ${homeController
                                  .model()
                                  .data?[index].customer?.lastName
                                  .toString()
                                  .capitalizeFirst}',
                              style: font_style.black_500_16,
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight *
                                  0.005,
                            ),
                            SizedBox(
                              width: SizeConfig.screenWidth * 0.70,
                              child: Text(
                                homeController
                                    .model()
                                    .data?[index]
                                    .customer
                                    ?.address ??
                                    '',
                                style: font_style.black_400_10,
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight *
                                  0.005,
                            ),
                            Text(
                              DateFormat('dd-MM-yyyy').format(homeController
                                  .model()
                                  .data?[index].bookingDate??DateTime.now()),
                              style: font_style.yell_500_12,
                            ),
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                            onTap: () async {
                              SharedPreferences
                              sharedPreferences =
                              await SharedPreferences
                                  .getInstance();

                              String id = sharedPreferences
                                  .getString(stored_uid) ??
                                  '';
                              homeController.acceptBooking(
                                  id,
                                  homeController
                                      .model()
                                      .data?[index]
                                      .bookingId ??
                                      '',
                                  'Confirmed');
                            },
                            child: SvgPicture.asset(
                                "assets/images/emp_accept_home.svg",width: SizeConfig.screenWidth * 0.075)),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.025,
                        ),
                        GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    elevation: 0,
                                    backgroundColor:
                                    Colors.transparent,
                                    content: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: SizeConfig
                                              .screenWidth *
                                              0.03,
                                          vertical: SizeConfig
                                              .screenHeight *
                                              .015),
                                      height: SizeConfig
                                          .screenHeight *
                                          0.13,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius
                                            .circular(12),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text(
                                            "Are you sure ?",
                                            style: font_style
                                                .black_600_18,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              //YES CONT
                                              GestureDetector(
                                                onTap:
                                                    () async {
                                                  Get.back();
                                                  SharedPreferences
                                                  sharedPreferences =
                                                  await SharedPreferences
                                                      .getInstance();

                                                  String id =
                                                      sharedPreferences
                                                          .getString(
                                                          stored_uid) ??
                                                          '';
                                                  homeController.acceptBooking(
                                                      id,
                                                      homeController
                                                          .model()
                                                          .data?[index]
                                                          .bookingId ??
                                                          '',
                                                      'Cancelled');
                                                },
                                                child:
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                      SizeConfig.screenWidth *
                                                          0.1,
                                                      vertical:
                                                      SizeConfig.screenHeight *
                                                          0.01),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          8),
                                                      color: const Color(
                                                          0xff52525B)),
                                                  child: Text(
                                                    "Yes",
                                                    style: font_style
                                                        .white_600_16,
                                                  ),
                                                ),
                                              ),

                                              //NO CONT
                                              GestureDetector(
                                                onTap: () {
                                                  Get.back();
                                                },
                                                child:
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                      SizeConfig.screenWidth *
                                                          0.1,
                                                      vertical:
                                                      SizeConfig.screenHeight *
                                                          0.01),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          8),
                                                      color: Colors
                                                          .transparent,
                                                      border: Border.all(
                                                          color:
                                                          const Color(
                                                              0xff52525B))),
                                                  child:
                                                  const Text(
                                                      "No"),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: SvgPicture.asset(
                                "assets/images/emp_reject_home.svg",width: SizeConfig.screenWidth * 0.075)),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                        vertical:
                        SizeConfig.screenHeight * 0.01),
                    height: 1,
                    width: SizeConfig.screenWidth,
                    color: line_cont_col,
                  );
                },
              )
                  : Container(
                  height: 50,
                  alignment: Alignment.center,
                  width: SizeConfig.screenWidth,
                  child: Text(
                    "You Have No New Order",
                    style: font_style.grey52525B_400_10_noline,
                  ))),

              //LINE
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: SizeConfig.screenHeight * 0.01),
                height: 1,
                width: SizeConfig.screenWidth * 0.9,
                color: line_cont_col,
              ),

              SizedBox(
                height: SizeConfig.screenHeight * 0.02,
              ),

              //History TXT
              Center(
                child: SizedBox(
                  width: SizeConfig.screenWidth * 0.9,
                  child: Text(
                    "History",
                    style: font_style.black_600_16,
                  ),
                ),
              ),

              SizedBox(
                height: SizeConfig.screenHeight * 0.02,
              ),
              Obx(() =>
              homeController
                  .bookingHistoryModel()
                  .data
                  ?.isNotEmpty ??
                  false
                  ? ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: homeController
                    .bookingHistoryModel()
                    .data
                    ?.length ??
                    0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenWidth * 0.05),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${homeController
                                  .bookingHistoryModel()
                                  .data?[index].firstName ??
                                  ''} ${homeController
                                  .bookingHistoryModel()
                                  .data?[index].lastName ?? ''}",
                              style: font_style.black_500_16,
                            ),
                            SizedBox(
                              height:
                              SizeConfig.screenHeight * 0.005,
                            ),
                            SizedBox(
                              width:SizeConfig.screenWidth*0.70,
                              child: Text(
                                homeController
                                    .bookingHistoryModel()
                                    .data?[index]
                                    .location ??
                                    '',
                                style: font_style.black_400_10,
                              ),
                            ),
                            SizedBox(
                              height:
                              SizeConfig.screenHeight * 0.005,
                            ),
                            Text("${homeController
                                .bookingHistoryModel()
                                .data?[index]
                                .bookingDate}",
                              style: font_style.yell_500_12,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Text(
                              "₹${double.parse(homeController
                                  .bookingHistoryModel()
                                  .data?[index].amount.toString() ?? '')
                                  .toStringAsFixed(2)}",
                              style: font_style.green16A34A_600_16,
                            ),
                            SizedBox(
                              height:
                              SizeConfig.screenHeight * 0.01,
                            ),
                            // Text(
                            //   "4 Services",
                            //   style: font_style
                            //       .greyA1A1AA_400_10_noline,
                            // ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                        vertical: SizeConfig.screenHeight * 0.01),
                    height: 1,
                    width: SizeConfig.screenWidth,
                    color: line_cont_col,
                  );
                },
              )
                  : Container(
                  height: 100,
                  alignment: Alignment.center,
                  width: SizeConfig.screenWidth,
                  child: Text(
                    "You Have No Upcoming Order",
                    style: font_style.grey52525B_400_10_noline,
                  ))),

              Container(
                margin: EdgeInsets.symmetric(
                    vertical: SizeConfig.screenHeight * 0.01),
                height: 1,
                width: SizeConfig.screenWidth,
                color: line_cont_col,
              ),

              SizedBox(
                height: SizeConfig.screenHeight * 0.01,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
