import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hairgardenemployee/COMMON/common_color.dart';
import 'package:hairgardenemployee/COMMON/common_indicator.dart';
import 'package:hairgardenemployee/COMMON/size_config.dart';
import 'package:hairgardenemployee/EMPLOYEE/appointments/Screens/help_page.dart';
import 'package:hairgardenemployee/COMMON/font_style.dart';
import 'package:hairgardenemployee/EMPLOYEE/appointments/Screens/rescheduling_request.dart';
import 'package:hairgardenemployee/COMMON/common_txt_lst.dart';
import 'package:hairgardenemployee/EMPLOYEE/my%20earnings/controller/my_earning_detail_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../COMMON/const.dart';

class earning_details_page extends StatefulWidget {
  String? id;

  earning_details_page({required this.id});

  @override
  State<earning_details_page> createState() => _earning_details_pageState();
}

class _earning_details_pageState extends State<earning_details_page> {
  bool view_det = false;

  final myEarningDetailController = Get.put(MyEarningDetailController());

  getUserEarningData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString(stored_uid) ?? '';
    myEarningDetailController.getMyEarningDetail(id, widget.id ?? "");
  }

  @override
  void initState() {
    getUserEarningData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg_col,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: common_color,
            )),
        title: Obx(() => Text(
            myEarningDetailController.myEarningModel().data?.userName ?? '',
            style: font_style.darkgray_600_20)),
      ),
      body: Obx(() => myEarningDetailController.isLoading()
          ? const Center(
              child: commonindicator(),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.03,
                  ),

                  //CUSTOMER DETAILS
                  Center(
                    child: Container(
                      width: SizeConfig.screenWidth * 0.9,
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                                width: SizeConfig.screenWidth * 0.9,
                                child: Text("Customer Detail",
                                    style: font_style.darkgray_600_18)),
                          ),

                          SizedBox(
                            height: SizeConfig.screenHeight * 0.02,
                          ),

                          //NAME
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Name", style: font_style.yell_400_16),
                              Text(
                                  myEarningDetailController
                                          .myEarningModel()
                                          .data
                                          ?.userName ??
                                      '',
                                  style: font_style.darkgray_500_15),
                            ],
                          ),

                          SizedBox(
                            height: SizeConfig.screenHeight * 0.01,
                          ),

                          //DATE
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Date", style: font_style.yell_400_16),
                              Text(
                                  myEarningDetailController
                                          .myEarningModel()
                                          .data
                                          ?.date ??
                                      '',
                                  style: font_style.darkgray_400_14),
                            ],
                          ),

                          SizedBox(
                            height: SizeConfig.screenHeight * 0.01,
                          ),

                          //ADDRESS
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Address", style: font_style.yell_400_16),
                              Text(
                                  myEarningDetailController
                                          .myEarningModel()
                                          .data
                                          ?.date ??
                                      '',
                                  style: font_style.darkgray_400_10),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: SizeConfig.screenHeight * 0.02,
                  ),

                  //MAP
                  Center(
                    child: Container(
                      height: SizeConfig.screenHeight * 0.15,
                      width: SizeConfig.screenWidth * 0.9,
                      decoration: BoxDecoration(
                          border: Border.all(color: line_cont_col, width: 2),
                          image: const DecorationImage(
                              image: AssetImage("assets/images/map_img.png"),
                              fit: BoxFit.cover)),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.02,
                  ),

                  //LINE
                  Container(
                    height: 1,
                    width: SizeConfig.screenWidth,
                    color: line_cont_col,
                  ),

                  SizedBox(
                    height: SizeConfig.screenHeight * 0.01,
                  ),

                  //BOOKING DETAILS
                  Center(
                    child: Container(
                      width: SizeConfig.screenWidth * 0.9,
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                                width: SizeConfig.screenWidth * 0.9,
                                child: Text("Booking Detail",
                                    style: font_style.darkgray_600_18)),
                          ),

                          SizedBox(
                            height: SizeConfig.screenHeight * 0.02,
                          ),

                          //ID ORDER
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("ID ORDER", style: font_style.yellow_400_14),
                              Text(
                                  myEarningDetailController
                                          .myEarningModel()
                                          .data
                                          ?.orderId ??
                                      '',
                                  style: font_style.darkgray_400_14),
                            ],
                          ),

                          SizedBox(
                            height: SizeConfig.screenHeight * 0.01,
                          ),

                          //SUB TOTAL
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Sub Total",
                                  style: font_style.yellow_400_14),
                              Text(
                                  "₹ ${myEarningDetailController.myEarningModel().data?.price.toString()??''}",
                                  style: font_style.darkgray_600_14),
                            ],
                          ),

                          SizedBox(
                            height: SizeConfig.screenHeight * 0.01,
                          ),

                          //Payment Method
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Payment Method",
                                  style: font_style.yellow_400_14),
                              Text(myEarningDetailController.myEarningModel().data?.paymentType ?? '',
                                  style: font_style.darkgray_600_14),
                            ],
                          ),

                          SizedBox(
                            height: SizeConfig.screenHeight * 0.01,
                          ),

                          //Status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Status", style: font_style.yellow_400_14),
                              Text(myEarningDetailController.myEarningModel().data?.paymentStatus?.capitalizeFirst??"",
                                  style: font_style.lightgeen_600_14.copyWith(color: const Color(0xff16A34A))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.02,
                  ),

                  //LINE
                  Container(
                    height: 1,
                    width: SizeConfig.screenWidth,
                    color: line_cont_col,
                  ),

                  SizedBox(
                    height: SizeConfig.screenHeight * 0.01,
                  ),

                  //PAYMENT DETAILS
                  Center(
                    child: Container(
                      width: SizeConfig.screenWidth * 0.9,
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                                width: SizeConfig.screenWidth * 0.9,
                                child: Text("Payment Detail",
                                    style: font_style.darkgray_600_18)),
                          ),

                          SizedBox(
                            height: SizeConfig.screenHeight * 0.02,
                          ),

                          //Sub Total
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Sub Total",
                                  style: font_style.yellow_400_14),
                              Text("₹ ${myEarningDetailController.myEarningModel().data?.price ?? ''.toString()}",
                                  style: font_style.darkgray_600_14),
                            ],
                          ),

                          SizedBox(
                            height: SizeConfig.screenHeight * 0.01,
                          ),

                          //Payment Method
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Payment Method",
                                  style: font_style.yellow_400_14),
                              Text(myEarningDetailController.myEarningModel().data?.paymentType ?? '',
                                  style: font_style.darkgray_600_14),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.02,
                  ),

                  //LINE
                  Container(
                    height: 1,
                    width: SizeConfig.screenWidth,
                    color: line_cont_col,
                  ),

                  SizedBox(
                    height: SizeConfig.screenHeight * 0.01,
                  ),

                  //SERVICE DETAIL
                  Center(
                    child: Container(
                      width: SizeConfig.screenWidth * 0.9,
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                                width: SizeConfig.screenWidth * 0.9,
                                child: Text("Service Detail",
                                    style: font_style.darkgray_600_18)),
                          ),

                          SizedBox(
                            height: SizeConfig.screenHeight * 0.02,
                          ),

                          //Service Type
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Service Type",
                                  style: font_style.yellow_400_14),
                              Text(myEarningDetailController.myEarningModel().data?.serviceCategoryTitle ?? '',
                                  style: font_style.darkgray_600_14),
                            ],
                          ),

                          SizedBox(
                            height: SizeConfig.screenHeight * 0.01,
                          ),

                          //Description
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Description",
                                  style: font_style.yellow_400_14),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(myEarningDetailController.myEarningModel().data?.serviceDescription ?? '',
                                    style: font_style.darkgray_600_14),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight * 0.01,
                          ),

                          //Include Services
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (viewdet == false) {
                                      viewdet = true;
                                    } else {
                                      viewdet = false;
                                    }
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Include Services",
                                        style: font_style.yellow_400_14),
                                    const Spacer(),
                                    Text("View Details",
                                        style: viewdet == false
                                            ? font_style.yellow_600_14_underline
                                            : font_style
                                                .grey18181B_600_14_underline),
                                    Icon(
                                      viewdet == false
                                          ? Icons.keyboard_arrow_down_outlined
                                          : Icons.keyboard_arrow_up,
                                      color: viewdet == false
                                          ? yellow_col
                                          : Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                              viewdet == true
                                  ? SizedBox(
                                      height: SizeConfig.screenHeight * 0.02,
                                    )
                                  : const SizedBox(
                                      height: 0,
                                    ),
                              viewdet == true
                                  ? ListView.separated(
                                      itemCount: 3,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text("• ",
                                                style: font_style.black_600_16),
                                            Container(
                                                width: SizeConfig.screenWidth *
                                                    0.6,
                                                child: Text(
                                                    view_detials[index]
                                                        .toString(),
                                                    style: font_style
                                                        .darkgray_600_14)),
                                          ],
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return SizedBox(
                                          height:
                                              SizeConfig.screenHeight * 0.005,
                                        );
                                      },
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: SizeConfig.screenHeight * 0.01,
                  ),
                ],
              ),
            )),
    );
  }
}
