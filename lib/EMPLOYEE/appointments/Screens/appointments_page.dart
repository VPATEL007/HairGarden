import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hairgardenemployee/COMMON/common_color.dart';
import 'package:hairgardenemployee/COMMON/common_indicator.dart';
import 'package:hairgardenemployee/COMMON/common_txt_lst.dart';
import 'package:hairgardenemployee/COMMON/const.dart';
import 'package:hairgardenemployee/COMMON/font_style.dart';
import 'package:hairgardenemployee/COMMON/size_config.dart';
import 'package:hairgardenemployee/EMPLOYEE/appointments/Screens/appointment_details_page.dart';
import 'package:hairgardenemployee/EMPLOYEE/appointments/controller/appoitment_controller.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class appointments_page extends StatefulWidget {
  const appointments_page({Key? key}) : super(key: key);

  @override
  State<appointments_page> createState() => _appointments_pageState();
}

class _appointments_pageState extends State<appointments_page> {
  DatePickerController _controllerdate = DatePickerController();
  DateTime _selectedValue = DateTime.now();

  final appointmentController = Get.put(AppointmentController());

  List upcoming_sub = [
    "Ongoing",
    "Rejected",
    "Cancelled by user",
    "Rescheduled",
    "Completed",
  ];

  getData() async {
    appointmentController.loading(true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString(stored_uid) ?? '';
    appointmentController.fetchBookingHistoryData(id);
    appointmentController.fetchUpcomingBookingHistoryData(id);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    accept_rej_lst2.addAll(accept_rej_lst);
    return Scaffold(
      backgroundColor: newLightColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: GestureDetector(
            onTap: () {
              if (upcoming_sub.isEmpty) {
                setState(() {
                  upcoming_sub.addAll([
                    "Ongoing",
                    "Rejected",
                    "Cancelled by user",
                    "Rescheduled",
                    "Completed",
                  ]);
                });
              } else {
                setState(() {
                  upcoming_sub.clear();
                });
              }
            },
            child: Text(
              "Appointments",
              style: font_style.black_600_20,
            )),
      ),
      body: Obx(() => appointmentController.loading.value
          ? const Center(
              child: commonindicator(),
            )
          : Column(
              children: [
                //CALENDER
                // Center(
                //   child: SizedBox(
                //     width: SizeConfig.screenWidth * 0.9,
                //     child: DatePicker(
                //       DateTime.now(),
                //       width: 60,
                //       height: 80,
                //       controller: _controllerdate,
                //       initialSelectedDate: DateTime.now(),
                //       selectionColor: yellow_col.withOpacity(0.7),
                //       selectedTextColor: Colors.black,
                //       deactivatedColor: Colors.white,
                //       monthTextStyle: font_style.cal_black_400_12,
                //       dayTextStyle: font_style.cal_black_400_12,
                //       dateTextStyle: font_style.cal_black_400_12,
                //       onDateChange: (date) {
                //         // New date selected
                //         setState(() {
                //           _selectedValue = date;
                //         });
                //       },
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.01,
                ),
                DefaultTabController(
                    length: 2,
                    child: Expanded(
                      child: SizedBox(
                        width: SizeConfig.screenWidth,
                        child: Column(
                          children: [
                            const SizedBox(height: 5),

                            //TITLE
                            Container(
                              height: SizeConfig.screenHeight * 0.055,
                              width: SizeConfig.screenWidth * 0.9,
                              decoration: BoxDecoration(
                                  color: newLightColor,
                                  borderRadius: BorderRadius.circular(60),
                                  border: Border.all(color: yellow_col)),
                              child: TabBar(
                                  padding: const EdgeInsets.only(),
                                  indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          60), // Creates border
                                      color: yellow_col),
                                  labelColor: Colors.white,
                                  indicatorColor: yellow_col,
                                  unselectedLabelColor: yellow_col,
                                  tabs: const [
                                    Tab(
                                      text: 'Upcoming',
                                    ),
                                    Tab(text: 'History'),
                                  ]),
                            ),
                            SizedBox(height: SizeConfig.screenHeight * 0.026),

                            Expanded(
                              child: TabBarView(
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  //UPCOMING HISTORY
                                  Obx(() => appointmentController
                                              .upcomingBookingHistoryModel()
                                              .data !=
                                          null
                                      ? SizedBox(
                                          width: SizeConfig.screenWidth,
                                          child: ListView.separated(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            itemCount: appointmentController
                                                    .upcomingBookingHistoryModel()
                                                    .data
                                                    ?.length ??
                                                0,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        SizeConfig.screenWidth *
                                                            0.05),
                                                child: InkWell(
                                                  onTap: () {
                                                    Get.to(appointment_details_page(
                                                        bookingID:
                                                            appointmentController
                                                                    .upcomingBookingHistoryModel()
                                                                    .data?[
                                                                        index]
                                                                    .bookId ??
                                                                ''));
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "${appointmentController.upcomingBookingHistoryModel().data?[index].firstName?.capitalizeFirst ?? ''} ${appointmentController.upcomingBookingHistoryModel().data?[index].lastName?.capitalizeFirst ?? ''}",
                                                            style: font_style
                                                                .black_500_16,
                                                          ),
                                                          SizedBox(
                                                            height: SizeConfig
                                                                    .screenHeight *
                                                                0.005,
                                                          ),
                                                          SizedBox(
                                                            width: SizeConfig
                                                                    .screenWidth *
                                                                0.73,
                                                            child: Text(
                                                              appointmentController
                                                                      .upcomingBookingHistoryModel()
                                                                      .data?[
                                                                          index]
                                                                      .location ??
                                                                  '',
                                                              style: font_style
                                                                  .black_400_10,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: SizeConfig
                                                                    .screenHeight *
                                                                0.005,
                                                          ),
                                                          Text(
                                                            "${appointmentController.upcomingBookingHistoryModel().data?[index].bookingDate}",
                                                            style: font_style
                                                                .yell_500_12,
                                                          ),
                                                        ],
                                                      ),
                                                      const Spacer(),
                                                      Column(
                                                        children: [
                                                          Text(
                                                            "₹${double.parse(appointmentController.upcomingBookingHistoryModel().data?[index].amount.toString() ?? '').toStringAsFixed(2)}",
                                                            style: font_style
                                                                .green16A34A_600_16,
                                                          ),
                                                          SizedBox(
                                                            height: SizeConfig
                                                                    .screenHeight *
                                                                0.01,
                                                          ),
                                                          Text(
                                                            appointmentController
                                                                    .upcomingBookingHistoryModel()
                                                                    .data?[
                                                                        index]
                                                                    .status ??
                                                                '',
                                                            style: appointmentController
                                                                        .upcomingBookingHistoryModel()
                                                                        .data?[
                                                                            index]
                                                                        .status ==
                                                                    "Ongoing"
                                                                ? font_style
                                                                    .FACC15_400_10_noline
                                                                : upcoming_sub[index] ==
                                                                            "Rejected" ||
                                                                        upcoming_sub[index] ==
                                                                            "Rescheduled"
                                                                    ? font_style
                                                                        .red_400_10_noline
                                                                    : upcoming_sub[index] ==
                                                                            "Cancelled by user"
                                                                        ? font_style
                                                                            .blue2563EB_400_10_noline
                                                                        : font_style
                                                                            .green16A34A_400_10_noline,
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
                                                    vertical: SizeConfig
                                                            .screenHeight *
                                                        0.01),
                                                height: 1,
                                                width: SizeConfig.screenWidth,
                                                color: line_cont_col,
                                              );
                                            },
                                          ),
                                        )
                                      : SizedBox(
                                          width: SizeConfig.screenWidth,
                                          height: SizeConfig.screenHeight,
                                          child: Center(
                                            child: Text(
                                              "You have no Upcoming Order",
                                              style: font_style
                                                  .grey52525B_400_10_noline,
                                            ),
                                          ),
                                        )),

                                  //HISTORY
                                  Obx(() => appointmentController
                                              .bookingHistoryModel()
                                              .data !=
                                          null
                                      ? ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          itemCount: appointmentController
                                                  .bookingHistoryModel()
                                                  .data
                                                  ?.length ??
                                              0,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      SizeConfig.screenWidth *
                                                          0.05),
                                              child: InkWell(
                                                onTap: () {
                                                  Get.to(appointment_details_page(
                                                      bookingID:
                                                      appointmentController
                                                          .bookingHistoryModel()
                                                          .data?[index]
                                                                  .bookId ??
                                                              '',
                                                    isBookingHistory: true,
                                                  ));
                                                },
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "${appointmentController.bookingHistoryModel().data?[index].firstName ?? ''} ${appointmentController.bookingHistoryModel().data?[index].lastName ?? ''}",
                                                          style: font_style
                                                              .black_500_16,
                                                        ),
                                                        SizedBox(
                                                          height: SizeConfig
                                                                  .screenHeight *
                                                              0.005,
                                                        ),
                                                        Text(
                                                          appointmentController
                                                                  .bookingHistoryModel()
                                                                  .data?[index]
                                                                  .location ??
                                                              '',
                                                          style: font_style
                                                              .black_400_10,
                                                        ),
                                                        SizedBox(
                                                          height: SizeConfig
                                                                  .screenHeight *
                                                              0.005,
                                                        ),
                                                        Text(
                                                          "${appointmentController.bookingHistoryModel().data?[index].bookingDate}",
                                                          style: font_style
                                                              .yell_500_12,
                                                        ),
                                                      ],
                                                    ),
                                                    const Spacer(),
                                                    Column(
                                                      children: [
                                                        Text(
                                                          "₹${double.parse(appointmentController.bookingHistoryModel().data?[index].amount.toString() ?? '').toStringAsFixed(2)}",
                                                          style: font_style
                                                              .green16A34A_600_16,
                                                        ),
                                                        SizedBox(
                                                          height: SizeConfig
                                                                  .screenHeight *
                                                              0.01,
                                                        ),
                                                        Text(
                                                          "4 Services",
                                                          style: font_style
                                                              .greyA1A1AA_400_10_noline,
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
                                                  vertical:
                                                      SizeConfig.screenHeight *
                                                          0.01),
                                              height: 1,
                                              width: SizeConfig.screenWidth,
                                              color: line_cont_col,
                                            );
                                          },
                                        )
                                      : Container(
                                          alignment: Alignment.center,
                                          width: SizeConfig.screenWidth,
                                          child: Text(
                                            "You have no History",
                                            style: font_style
                                                .grey52525B_400_10_noline,
                                          ))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
              ],
            )),
    );
  }
}
