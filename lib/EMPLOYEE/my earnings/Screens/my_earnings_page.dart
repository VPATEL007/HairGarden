import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hairgardenemployee/COMMON/common_color.dart';
import 'package:hairgardenemployee/COMMON/common_indicator.dart';
import 'package:hairgardenemployee/COMMON/font_style.dart';
import 'package:hairgardenemployee/COMMON/size_config.dart';
import 'package:hairgardenemployee/EMPLOYEE/my%20earnings/Screens/earning_details_page.dart';
import 'package:hairgardenemployee/EMPLOYEE/my%20earnings/controller/my_earning_controller.dart';
import 'package:hairgardenemployee/EMPLOYEE/profile/controller/profile_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../COMMON/const.dart';

class my_earnings_page extends StatefulWidget {
  const my_earnings_page({Key? key}) : super(key: key);

  @override
  State<my_earnings_page> createState() => _my_earnings_pageState();
}

class _my_earnings_pageState extends State<my_earnings_page> {
  final myEarningController = Get.put(MyEarningController());

  getUserEarningData() async {
    myEarningController.isLoading(true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString(stored_uid) ?? '';
    myEarningController.fetchMyEarningDetail(id);
  }

  @override
  void initState() {
    getUserEarningData();
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
        title: Text("My Earnings", style: font_style.darkgray_600_20),
      ),
      body: Obx(() => myEarningController.isLoading()
          ? const Center(
              child: commonindicator(),
            )
          : Column(
              children: [
                SizedBox(
                  height: SizeConfig.screenHeight * 0.04,
                ),
                Center(
                  child: Container(
                    width: SizeConfig.screenWidth * 0.9,
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/images/rupees.svg"),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.02,
                        ),
                        Text(
                          "₹${myEarningController.myEarningModel().totalEarning?.toDouble().toStringAsFixed(2)}",
                          style: font_style.yellow_600_24,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: SizeConfig.screenHeight * 0.04,
                ),

                //RECENT SERVICES
                Center(
                  child: Container(
                    width: SizeConfig.screenWidth * 0.9,
                    child: Text(
                      "Recent Services",
                      style: font_style.greyA1A1AA_600_12
                          .copyWith(fontSize: 16, color: Color(0xff52525B)),
                    ),
                  ),
                ),

                SizedBox(
                  height: SizeConfig.screenHeight * 0.02,
                ),

                //LISTVIEW
                Center(
                  child: Container(
                    width: SizeConfig.screenWidth,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount:
                          myEarningController.myEarningModel().data?.length ??
                              0,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.screenWidth * 0.05),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(earning_details_page(
                                id: myEarningController
                                    .myEarningModel()
                                    .data?[index].id,
                              ));
                            },
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      myEarningController
                                              .myEarningModel()
                                              .data?[index]
                                              .userName ??
                                          '',
                                      style: font_style.black_600_16,
                                    ),
                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.005,
                                    ),
                                    Text(
                                      myEarningController
                                              .myEarningModel()
                                              .data?[index]
                                              .bookingDate ??
                                          '',
                                      style: font_style.greyA1A1AA_400_14,
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    Text(
                                      "₹${double.parse(myEarningController.myEarningModel().data?[index].price ?? ''.toString()).toStringAsFixed(2)}",
                                      style: index == 2
                                          ? font_style.redDC2626_600_16
                                          : index == 5
                                              ? font_style.yelEAB308_600_16
                                              : font_style.green16A34A_600_16,
                                    ),
                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.01,
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: SizeConfig.screenHeight * 0.01),
                  height: 1,
                  width: SizeConfig.screenWidth,
                  color: line_cont_col,
                )
              ],
            )),
    );
  }
}
