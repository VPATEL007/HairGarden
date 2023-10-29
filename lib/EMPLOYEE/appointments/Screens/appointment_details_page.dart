import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hairgardenemployee/COMMON/common_color.dart';
import 'package:hairgardenemployee/COMMON/common_indicator.dart';
import 'package:hairgardenemployee/COMMON/const.dart';
import 'package:hairgardenemployee/COMMON/font_style.dart';
import 'package:hairgardenemployee/COMMON/size_config.dart';
import 'package:hairgardenemployee/EMPLOYEE/appointments/Screens/help_page.dart';
import 'package:hairgardenemployee/EMPLOYEE/appointments/Screens/rescheduling_request.dart';
import 'package:hairgardenemployee/COMMON/common_txt_lst.dart';
import 'package:hairgardenemployee/EMPLOYEE/appointments/controller/appoitment_detail_controller.dart';
import 'package:hairgardenemployee/EMPLOYEE/emp_bottombar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class appointment_details_page extends StatefulWidget {
  final String bookingID;
  final bool isBookingHistory;

  const appointment_details_page({Key? key, required this.bookingID, this.isBookingHistory=false})
      : super(key: key);

  @override
  State<appointment_details_page> createState() =>
      _appointment_details_pageState();
}

class _appointment_details_pageState extends State<appointment_details_page> {
  final appointmentDetailController = Get.put(AppointmentDetailController());

  getData() async {
    appointmentDetailController.loading(true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString(stored_uid) ?? '';
    appointmentDetailController.fetchBookingDetailData(id, widget.bookingID);
  }

  @override
  void initState() {
    getData();
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
        // title: Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text("Booking Detail",style: font_style.red_600_20),
        //     // Text("Status",style: font_style.greyA1A1AA_600_12),
        //   ],
        // ),
      ),
      body: Obx(() => appointmentDetailController.loading.value
          ? const Center(
              child: commonindicator(),
            )
          : (appointmentDetailController
                      .bookingDetailModel()
                      .data
                      ?.isNotEmpty ??
                  false)
              ? SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.01,
                      ),
                      //HELP ROW
                      // Center(
                      //   child: Container(
                      //     width: SizeConfig.screenWidth*0.9,
                      //     child: GestureDetector(
                      //       onTap: (){
                      //         Get.to(help_page());
                      //       },
                      //       child: Row(
                      //         children: [
                      //           Icon(Icons.help,color: Color(0xff323232),),
                      //           SizedBox(width: SizeConfig.screenWidth*0.01,),
                      //           Text("Help",style: font_style.darkgray_600_18),
                      //           Spacer(),
                      //           Icon(Icons.keyboard_arrow_right,color: darkgray_0xff18181B,)
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      // SizedBox(height: SizeConfig.screenHeight*0.02,),

                      //CUSTOMER DETAILS
                      Center(
                        child: SizedBox(
                          width: SizeConfig.screenWidth * 0.9,
                          child: Column(
                            children: [
                              Center(
                                child: SizedBox(
                                    width: SizeConfig.screenWidth * 0.9,
                                    child: Text("Customer Detail",
                                        style: font_style.darkgray_600_18)),
                              ),

                              SizedBox(
                                height: SizeConfig.screenHeight * 0.02,
                              ),

                              //NAME
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Name", style: font_style.yell_400_16),
                                  Text(
                                      "${appointmentDetailController.bookingDetailModel().data?[0].firstName?.capitalizeFirst ?? ''} ${appointmentDetailController.bookingDetailModel().data?[0].lastName?.capitalizeFirst ?? ''}",
                                      style: font_style.darkgray_500_15),
                                ],
                              ),

                              SizedBox(
                                height: SizeConfig.screenHeight * 0.01,
                              ),

                              //DATE
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Date", style: font_style.yell_400_16),
                                  Text(
                                      DateFormat.yMMMMd().format(
                                          appointmentDetailController
                                                  .bookingDetailModel()
                                                  .data?[0]
                                                  .bookingDate ??
                                              DateTime.now()),
                                      style: font_style.darkgray_400_14),
                                ],
                              ),

                              SizedBox(
                                height: SizeConfig.screenHeight * 0.01,
                              ),

                              //ADDRESS
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Address\t\t",
                                      style: font_style.yell_400_16),
                                  SizedBox(
                                    width:SizeConfig.screenWidth*0.70,
                                    child: Text(
                                        "${appointmentDetailController.bookingDetailModel().data?[0].location ?? ''}",
                                        style: font_style.darkgray_400_10),
                                  ),
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
                              border:
                                  Border.all(color: line_cont_col, width: 2),
                              image: const DecorationImage(
                                  image:
                                      AssetImage("assets/images/map_img.png"),
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
                        child: SizedBox(
                          width: SizeConfig.screenWidth * 0.9,
                          child: Column(
                            children: [
                              Center(
                                child: SizedBox(
                                    width: SizeConfig.screenWidth * 0.9,
                                    child: Text("Booking Detail",
                                        style: font_style.darkgray_600_18)),
                              ),

                              SizedBox(
                                height: SizeConfig.screenHeight * 0.02,
                              ),

                              //ID ORDER
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("ID ORDER",
                                      style: font_style.yellow_400_14),
                                  Text(
                                      "${appointmentDetailController.bookingDetailModel().data?[0].orderId}",
                                      style: font_style.darkgray_400_14),
                                ],
                              ),

                              SizedBox(
                                height: SizeConfig.screenHeight * 0.01,
                              ),

                              //SUB TOTAL
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Sub Total",
                                      style: font_style.yellow_400_14),
                                  Text(
                                      "₹ ${appointmentDetailController.bookingDetailModel().data?[0].amount}",
                                      style: font_style.darkgray_600_14),
                                ],
                              ),

                              SizedBox(
                                height: SizeConfig.screenHeight * 0.01,
                              ),

                              //Payment Method
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Payment Method",
                                      style: font_style.yellow_400_14),
                                  Text(
                                      "${appointmentDetailController.bookingDetailModel().data?[0].paymentType}",
                                      style: font_style.darkgray_600_14),
                                ],
                              ),

                              SizedBox(
                                height: SizeConfig.screenHeight * 0.01,
                              ),

                              //Status
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Status",
                                      style: font_style.yellow_400_14),
                                  Text(
                                      appointmentDetailController.bookingDetailModel().data?[0].paymentStatus?.capitalizeFirst??'',
                                      style: font_style.red_600_14.copyWith(
                                        color: appointmentDetailController.bookingDetailModel().data?[0].paymentStatus=='success'?Colors.green:Colors.red
                                      )),
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
                        child: SizedBox(
                          width: SizeConfig.screenWidth * 0.9,
                          child: Column(
                            children: [
                              Center(
                                child: SizedBox(
                                    width: SizeConfig.screenWidth * 0.9,
                                    child: Text("Payment Detail",
                                        style: font_style.darkgray_600_18)),
                              ),

                              SizedBox(
                                height: SizeConfig.screenHeight * 0.02,
                              ),

                              //Sub Total
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Sub Total",
                                      style: font_style.yellow_400_14),
                                  Text(
                                      "₹ ${appointmentDetailController.bookingDetailModel().data?[0].amount}",
                                      style: font_style.darkgray_600_14),
                                ],
                              ),

                              SizedBox(
                                height: SizeConfig.screenHeight * 0.01,
                              ),

                              //Payment Method
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Payment Method",
                                      style: font_style.yellow_400_14),
                                  Text(
                                      "${appointmentDetailController.bookingDetailModel().data?[0].paymentType}",
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
                      // Center(
                      //   child: Container(
                      //     width: SizeConfig.screenWidth * 0.9,
                      //     child: Column(
                      //       children: [
                      //         Center(
                      //           child: Container(
                      //               width: SizeConfig.screenWidth * 0.9,
                      //               child: Text("Service Detail",
                      //                   style: font_style.darkgray_600_18)),
                      //         ),
                      //
                      //         SizedBox(
                      //           height: SizeConfig.screenHeight * 0.02,
                      //         ),
                      //
                      //         //Service Type
                      //         Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Text("Service Type",
                      //                 style: font_style.yellow_400_14),
                      //             Text("Women’s Care",
                      //                 style: font_style.darkgray_600_14),
                      //           ],
                      //         ),
                      //
                      //         SizedBox(
                      //           height: SizeConfig.screenHeight * 0.01,
                      //         ),
                      //
                      //         //Description
                      //         Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Text("Description",
                      //                 style: font_style.yellow_400_14),
                      //             Text("Blow Dry(Long hair):1,\nMeni-Pedi Combo: 1",
                      //                 style: font_style.darkgray_600_14),
                      //           ],
                      //         ),
                      //         SizedBox(
                      //           height: SizeConfig.screenHeight * 0.01,
                      //         ),
                      //
                      //         //Include Services
                      //         Column(
                      //           children: [
                      //             GestureDetector(
                      //               onTap: () {
                      //                 setState(() {
                      //                   if (viewdet == false) {
                      //                     viewdet = true;
                      //                   } else {
                      //                     viewdet = false;
                      //                   }
                      //                 });
                      //               },
                      //               child: Row(
                      //                 mainAxisAlignment: MainAxisAlignment.start,
                      //                 children: [
                      //                   Text("Include Services",
                      //                       style: font_style.yellow_400_14),
                      //                   Spacer(),
                      //                   Text("View Details",
                      //                       style: viewdet == false
                      //                           ? font_style.yellow_600_14_underline
                      //                           : font_style
                      //                               .grey18181B_600_14_underline),
                      //                   Icon(
                      //                     viewdet == false
                      //                         ? Icons.keyboard_arrow_down_outlined
                      //                         : Icons.keyboard_arrow_up,
                      //                     color: viewdet == false
                      //                         ? yellow_col
                      //                         : Colors.black,
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //             viewdet == true
                      //                 ? SizedBox(
                      //                     height: SizeConfig.screenHeight * 0.02,
                      //                   )
                      //                 : SizedBox(
                      //                     height: 0,
                      //                   ),
                      //             viewdet == true
                      //                 ? ListView.separated(
                      //                     itemCount: 3,
                      //                     shrinkWrap: true,
                      //                     scrollDirection: Axis.vertical,
                      //                     itemBuilder: (context, index) {
                      //                       return Row(
                      //                         mainAxisAlignment:
                      //                             MainAxisAlignment.start,
                      //                         children: [
                      //                           Text("• ",
                      //                               style: font_style.black_600_16),
                      //                           Container(
                      //                               width: SizeConfig.screenWidth *
                      //                                   0.6,
                      //                               child: Text(
                      //                                   view_detials[index]
                      //                                       .toString(),
                      //                                   style: font_style
                      //                                       .darkgray_600_14)),
                      //                         ],
                      //                       );
                      //                     },
                      //                     separatorBuilder: (context, index) {
                      //                       return SizedBox(
                      //                         height:
                      //                             SizeConfig.screenHeight * 0.005,
                      //                       );
                      //                     },
                      //                   )
                      //                 : Container(),
                      //           ],
                      //         ),
                      //         // ExpansionTile(
                      //         //     childrenPadding: EdgeInsets.zero,
                      //         //     iconColor: yellow_col,
                      //         //     clipBehavior: Clip.none,
                      //         //     collapsedTextColor: Colors.black,
                      //         //     tilePadding: EdgeInsets.zero,
                      //         //     title:Row(
                      //         //       mainAxisAlignment: MainAxisAlignment.start,
                      //         //       children: [
                      //         //         Text("Include Services",style: font_style.yellow_400_14),
                      //         //         Spacer(),
                      //         //         Text("View Details",style: font_style.yellow_600_14_underline),
                      //         //       ],
                      //         //     ),
                      //         //     children: List.generate(3, (index) {
                      //         //       return Row(
                      //         //         mainAxisAlignment: MainAxisAlignment.end,
                      //         //         children: [
                      //         //           Text("• ",style: font_style.black_600_16),
                      //         //           Text("Include Services",style: font_style.darkgray_600_14),
                      //         //         ],
                      //         //       );
                      //         //     })
                      //         // ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      //
                      // SizedBox(
                      //   height: SizeConfig.screenHeight * 0.01,
                      // ),

                      //RESHEDULE TXT
                      widget.isBookingHistory?const SizedBox():Center(
                        child: SizedBox(
                          width: SizeConfig.screenWidth * 0.9,
                          child: GestureDetector(
                            onTap: () {
                              Get.to(const rescheduling_request_page());
                            },
                            child: Row(
                              children: [
                                Text(
                                  "Reschedule",
                                  style: font_style.red_600_18,
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: darkgray_0xff18181B,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: SizeConfig.screenHeight * 0.01,
                      ),
                    ],
                  ),
                )
              : const SizedBox()),
      bottomNavigationBar: widget.isBookingHistory?const SizedBox():Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding:
                EdgeInsets.symmetric(vertical: SizeConfig.screenHeight * 0.02),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  context: context,
                  builder: (context) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.screenWidth * 0.001),
                      height:
                          WidgetsBinding.instance.window.viewInsets.bottom > 0.0
                              ? SizeConfig.screenHeight
                              : SizeConfig.screenHeight * 0.25,
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.screenHeight * 0.015),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        mainAxisAlignment:
                            WidgetsBinding.instance.window.viewInsets.bottom >
                                    0.0
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.center,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Ask the OTP from the Customer*",
                            style: font_style.black_600_16,
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight * 0.02,
                          ),
                          SizedBox(
                            width: SizeConfig.screenWidth * 0.5,
                            child: OtpTextField(
                              numberOfFields: 4,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              cursorColor: Colors.yellow,
                              showFieldAsBox: false,
                              filled: true,
                              borderColor: Colors.grey,
                              enabledBorderColor: Colors.grey,
                              styles: [
                                font_style.otp_txtstyl2,
                                font_style.otp_txtstyl2,
                                font_style.otp_txtstyl2,
                                font_style.otp_txtstyl2,
                              ],
                              focusedBorderColor: yellow_col,
                              fieldWidth: SizeConfig.screenWidth * 0.1,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(25)),
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.yellow,
                              ),

                              //runs when a code is typed in
                              onCodeChanged: (String code) {
                                //handle validation or checks here if necessary
                              },
                              //runs when every textfield is filled
                              onSubmit: (String verificationCode) {},
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight * 0.025,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.offAll(emp_bottombar(pasindx: 1));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.screenHeight * 0.015),
                              alignment: Alignment.center,
                              width: SizeConfig.screenWidth * 0.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: const Color(0xffC18F2C),
                              ),
                              child: Text(
                                "SUBMIT",
                                style: font_style.white_600_16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.screenHeight * 0.015),
                alignment: Alignment.center,
                width: SizeConfig.screenWidth * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: const Color(0xffC18F2C),
                ),
                child: Text(
                  "COMPLETE ORDER",
                  style: font_style.white_600_16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
