import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hairgarden/COMMON/common_circular_indicator.dart';
import 'package:hairgarden/COMMON/comontoast.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:hairgarden/USER/review/Screens/your_reviews.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../COMMON/common_color.dart';
import '../../../COMMON/size_config.dart';
import '../../../auth/Screens/login_page.dart';
import '../../book_slot Payment/Controller/get_staff_details_controller.dart';
import '../Controller/order_history_controller.dart';
import '../Controller/upcoming_order_controller.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final getOrderHistory = Get.put(order_history_controller());
  final getUpcomingOrderController = Get.put(upcoming_order_controller());
  final getStaffDetailsController = Get.put(get_staffs_details_controller());

  // String? uid;

  Future<void> getUserId() async {
    getOrderHistory.loading(true);
    getUpcomingOrderController.loading(true);
    SharedPreferences sf = await SharedPreferences.getInstance();
    getOrderHistory.userID(sf.getString("stored_uid") ?? "");
    print('ID==${getOrderHistory.userID}');
    getOrderHistory.order_history_cont(getOrderHistory.userID.value);
    getUpcomingOrderController
        .upcoming_order_contr(getOrderHistory.userID.value);
  }

  @override
  void initState() {
    getUserId();
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
  int selectedValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg_col,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Obx(() => Text(
              getOrderHistory.userID.value.isNotEmpty
                  ? selectedValue == 0
                      ? "Order History"
                      : 'Upcoming Order'
                  : "",
              style: font_style.green_600_20,
            )),
      ),
      body: Obx(() {
        return getOrderHistory.loading.value &&
                getUpcomingOrderController.loading.value
            ? const CommonIndicator()
            : getOrderHistory.userID.value.isNotEmpty
                ? DefaultTabController(
                    length: 2,
                    child: SizedBox(
                      height: SizeConfig.screenHeight,
                      width: SizeConfig.screenWidth,
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          Container(
                            height: SizeConfig.screenHeight * 0.06,
                            width: SizeConfig.screenWidth * 0.9,
                            decoration: BoxDecoration(
                                color: bg_col,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: yellow_col)),
                            child: TabBar(
                                padding: const EdgeInsets.only(),
                                indicator: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        16), // Creates border
                                    color: yellow_col),
                                labelColor: Colors.white,
                                onTap: (value) {
                                  setState(() {
                                    selectedValue = value;
                                  });
                                },
                                // isScrollable: false,
                                indicatorColor: yellow_col,
                                unselectedLabelColor: yellow_col,
                                tabs: const [
                                  Tab(
                                    text: 'Order History',
                                  ),
                                  Tab(text: 'Upcoming Order'),
                                ]),
                          ),
                          SizedBox(height: SizeConfig.screenHeight * 0.026),
                          Expanded(
                            child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                (getOrderHistory.response.value.data?.isEmpty ??
                                        false)
                                    ? Container(
                                        height: SizeConfig.screenHeight,
                                        alignment: Alignment.center,
                                        width: SizeConfig.screenWidth * 0.9,
                                        child: const Text(
                                          "No Order History",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )
                                    : ListView.separated(
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: getOrderHistory
                                                .response.value.data?.length ??
                                            0,
                                        itemBuilder: (context, index) {
                                          // return Column(
                                          //   crossAxisAlignment:
                                          //       CrossAxisAlignment.start,
                                          //   mainAxisSize:
                                          //       MainAxisSize.min,
                                          //   children: [
                                          //     //PRODUCT NAME
                                          //     Center(
                                          //       child: SizedBox(
                                          //           width: SizeConfig
                                          //                   .screenWidth *
                                          //               0.9,
                                          //           child: Text(
                                          //             getOrderHistory
                                          //                 .response
                                          //                 .value
                                          //                 .data![index]
                                          //                 .bookingId
                                          //                 .toString(),
                                          //             style: font_style
                                          //                 .black_600_18,
                                          //           )),
                                          //     ),
                                          //     SizedBox(
                                          //       height: SizeConfig
                                          //               .screenHeight *
                                          //           0.009,
                                          //     ),
                                          //
                                          //     //DATE
                                          //     Center(
                                          //       child: SizedBox(
                                          //           width: SizeConfig
                                          //                   .screenWidth *
                                          //               0.9,
                                          //           child: Row(
                                          //             children: [
                                          //               Text(
                                          //                 "DATE",
                                          //                 style: font_style
                                          //                     .yellow_400_14,
                                          //               ),
                                          //               const Spacer(),
                                          //               Text(
                                          //                 getOrderHistory
                                          //                     .response
                                          //                     .value
                                          //                     .data![
                                          //                         index]
                                          //                     .bookingDate
                                          //                     .toString(),
                                          //                 style: font_style
                                          //                     .black_400_14,
                                          //               ),
                                          //             ],
                                          //           )),
                                          //     ),
                                          //     SizedBox(
                                          //       height: SizeConfig
                                          //               .screenHeight *
                                          //           0.01,
                                          //     ),
                                          //     Center(
                                          //       child: SizedBox(
                                          //           width: SizeConfig
                                          //               .screenWidth *
                                          //               0.9,
                                          //           child: Row(
                                          //             children: [
                                          //               Text(
                                          //                 "Payment Status",
                                          //                 style: font_style
                                          //                     .yellow_400_14,
                                          //               ),
                                          //               const Spacer(),
                                          //               Text(
                                          //                 getOrderHistory
                                          //                     .response
                                          //                     .value
                                          //                     .data![
                                          //                 index]
                                          //                     .paymentStatus
                                          //                     .toString(),
                                          //                 style: font_style
                                          //                     .black_400_14,
                                          //               ),
                                          //             ],
                                          //           )),
                                          //     ),
                                          //     SizedBox(
                                          //       height: SizeConfig
                                          //           .screenHeight *
                                          //           0.01,
                                          //     ),
                                          //
                                          //     //ID ORDER
                                          //     Center(
                                          //       child: SizedBox(
                                          //           width: SizeConfig
                                          //                   .screenWidth *
                                          //               0.9,
                                          //           child: Row(
                                          //             children: [
                                          //               Text(
                                          //                 "ID ORDER",
                                          //                 style: font_style
                                          //                     .yellow_400_14,
                                          //               ),
                                          //               const Spacer(),
                                          //               Text(
                                          //                 getOrderHistory
                                          //                     .response
                                          //                     .value
                                          //                     .data![
                                          //                         index]
                                          //                     .bookingId
                                          //                     .toString(),
                                          //                 style: font_style
                                          //                     .black_400_14,
                                          //               ),
                                          //             ],
                                          //           )),
                                          //     ),
                                          //     SizedBox(
                                          //       height: SizeConfig
                                          //               .screenHeight *
                                          //           0.01,
                                          //     ),
                                          //
                                          //     //SUB TOTAL
                                          //     Center(
                                          //       child: SizedBox(
                                          //           width: SizeConfig
                                          //                   .screenWidth *
                                          //               0.9,
                                          //           child: Row(
                                          //             children: [
                                          //               Text(
                                          //                 "Sub Total",
                                          //                 style: font_style
                                          //                     .yellow_400_14,
                                          //               ),
                                          //               const Spacer(),
                                          //               Text(
                                          //                 "₹ ${getOrderHistory.response.value.data![index].price.toString()}",
                                          //                 style: font_style
                                          //                     .black_400_14,
                                          //               ),
                                          //             ],
                                          //           )),
                                          //     ),
                                          //     SizedBox(
                                          //       height: SizeConfig
                                          //               .screenHeight *
                                          //           0.01,
                                          //     ),
                                          //
                                          //     //ORDER HISTORY PROFESSONAL
                                          //     Center(
                                          //       child: InkWell(
                                          //         onTap: () {
                                          //           getStaffDetailsController
                                          //               .get_staffs_details_cont(
                                          //                   28);
                                          //           Get.to(your_reviews(
                                          //             staffid: "28",
                                          //             frompage: "order",
                                          //           ));
                                          //         },
                                          //         child: SizedBox(
                                          //             width: SizeConfig
                                          //                     .screenWidth *
                                          //                 0.9,
                                          //             child: Row(
                                          //               children: [
                                          //                 Text(
                                          //                   "Professional",
                                          //                   style: font_style
                                          //                       .yellow_400_14,
                                          //                 ),
                                          //                 const Spacer(),
                                          //                 Text(
                                          //                   getOrderHistory
                                          //                       .response
                                          //                       .value
                                          //                       .data![
                                          //                           index]
                                          //                       .staffdata!
                                          //                       .staffName
                                          //                       .toString(),
                                          //                   style: font_style
                                          //                       .black_400_14_under,
                                          //                 ),
                                          //                 const Icon(Icons
                                          //                     .keyboard_arrow_right_outlined)
                                          //               ],
                                          //             )),
                                          //       ),
                                          //     ),
                                          //     SizedBox(
                                          //       height: SizeConfig
                                          //               .screenHeight *
                                          //           0.01,
                                          //     ),
                                          //
                                          //     //PAYMENT METHOD
                                          //     Center(
                                          //       child: SizedBox(
                                          //           width: SizeConfig
                                          //                   .screenWidth *
                                          //               0.9,
                                          //           child: Row(
                                          //             children: [
                                          //               Text(
                                          //                 "Payment Method",
                                          //                 style: font_style
                                          //                     .yellow_400_14,
                                          //               ),
                                          //               const Spacer(),
                                          //               Text(
                                          //                 getOrderHistory
                                          //                     .response
                                          //                     .value
                                          //                     .data![
                                          //                         index]
                                          //                     .paymentType
                                          //                     .toString(),
                                          //                 style: font_style
                                          //                     .black_600_14_nounderline,
                                          //               ),
                                          //             ],
                                          //           )),
                                          //     ),
                                          //     SizedBox(
                                          //       height: SizeConfig
                                          //               .screenHeight *
                                          //           0.01,
                                          //     ),
                                          //
                                          //     //STATUS
                                          //     Center(
                                          //       child: SizedBox(
                                          //           width: SizeConfig
                                          //                   .screenWidth *
                                          //               0.9,
                                          //           child: Row(
                                          //             children: [
                                          //               Text(
                                          //                 "Status",
                                          //                 style: font_style
                                          //                     .yellow_400_14,
                                          //               ),
                                          //               const Spacer(),
                                          //               Text(
                                          //                 getOrderHistory
                                          //                     .response
                                          //                     .value
                                          //                     .data![
                                          //                         index]
                                          //                     .status
                                          //                     .toString(),
                                          //                 style: font_style
                                          //                     .lightgeen_600_14,
                                          //               ),
                                          //             ],
                                          //           )),
                                          //     ),
                                          //     SizedBox(
                                          //       height: SizeConfig
                                          //               .screenHeight *
                                          //           0.01,
                                          //     ),
                                          //   ],
                                          // );
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Get.bottomSheet(Container(
                                                      color: Colors.white,
                                                      constraints:
                                                          BoxConstraints(
                                                              maxHeight:
                                                                  Get.height *
                                                                      0.65,
                                                              minHeight:
                                                                  Get.height *
                                                                      0.35),
                                                      child: Stack(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              SizedBox(
                                                                height: SizeConfig
                                                                        .screenHeight *
                                                                    0.009,
                                                              ),
                                                              Align(
                                                                child:
                                                                    Container(
                                                                  width: 100,
                                                                  height: 6,
                                                                  decoration: BoxDecoration(
                                                                      color: const Color(
                                                                          0xffA1A1AA),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30)),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: SizeConfig
                                                                        .screenHeight *
                                                                    0.009,
                                                              ),
                                                              //SERVICES
                                                              ListView.builder(
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount: getOrderHistory
                                                                      .response
                                                                      .value
                                                                      .data?[
                                                                          index]
                                                                      .itemList
                                                                      ?.length,
                                                                  itemBuilder:
                                                                      (context,
                                                                              indexAt) =>
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                                                            child:
                                                                                SizedBox(
                                                                              width: SizeConfig.screenWidth * 0.9,
                                                                              child: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  Text(
                                                                                    getOrderHistory.response.value.data?[index].itemList?[indexAt].title ?? "",
                                                                                    style: font_style.black_400_16,
                                                                                  ),
                                                                                  const Spacer(),
                                                                                  Text(
                                                                                    "₹ ${double.parse(getOrderHistory.response.value.data?[index].itemList?[indexAt].price ?? "").toStringAsFixed(2)}",
                                                                                    style: font_style.black_500_14,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          )),
                                                              const Divider(
                                                                  thickness: 1,
                                                                  color: Color(
                                                                      0xffE4E4E7)),
                                                              SizedBox(
                                                                height: SizeConfig
                                                                        .screenHeight *
                                                                    0.01,
                                                              ),

                                                              //DATE
                                                              Center(
                                                                child: SizedBox(
                                                                    width: SizeConfig
                                                                            .screenWidth *
                                                                        0.9,
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          "DATE",
                                                                          style:
                                                                              font_style.yell_400_16,
                                                                        ),
                                                                        const Spacer(),
                                                                        Text(
                                                                          getOrderHistory
                                                                              .response
                                                                              .value
                                                                              .data![index]
                                                                              .bookingDate
                                                                              .toString(),
                                                                          style:
                                                                              font_style.black_400_16,
                                                                        ),
                                                                      ],
                                                                    )),
                                                              ),

                                                              SizedBox(
                                                                height: SizeConfig
                                                                        .screenHeight *
                                                                    0.01,
                                                              ),

                                                              //ID ORDER
                                                              Center(
                                                                child: SizedBox(
                                                                    width: SizeConfig
                                                                            .screenWidth *
                                                                        0.9,
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          "ID ORDER",
                                                                          style:
                                                                              font_style.yell_400_16,
                                                                        ),
                                                                        const Spacer(),
                                                                        Text(
                                                                          getOrderHistory
                                                                              .response
                                                                              .value
                                                                              .data![index]
                                                                              .bookingId
                                                                              .toString(),
                                                                          style:
                                                                              font_style.black_400_16,
                                                                        ),
                                                                      ],
                                                                    )),
                                                              ),
                                                              SizedBox(
                                                                height: SizeConfig
                                                                        .screenHeight *
                                                                    0.01,
                                                              ),

                                                              //SUB TOTAL
                                                              Center(
                                                                child: SizedBox(
                                                                    width: SizeConfig
                                                                            .screenWidth *
                                                                        0.9,
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          "Total Amount",
                                                                          style:
                                                                              font_style.yell_400_16,
                                                                        ),
                                                                        const Spacer(),
                                                                        Text(
                                                                          "₹ ${getOrderHistory.response.value.data![index].price.toString()}",
                                                                          style:
                                                                              font_style.black_400_16,
                                                                        ),
                                                                      ],
                                                                    )),
                                                              ),
                                                              SizedBox(
                                                                height: SizeConfig
                                                                        .screenHeight *
                                                                    0.01,
                                                              ),

                                                              //PROFESSONAL
                                                              Center(
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    if (getOrderHistory
                                                                            .response
                                                                            .value
                                                                            .data![index]
                                                                            .staffdata
                                                                            ?.staffId !=
                                                                        null) {
                                                                      getStaffDetailsController
                                                                          .get_staffs_details_cont(getOrderHistory
                                                                              .response
                                                                              .value
                                                                              .data![index]
                                                                              .staffdata!
                                                                              .staffId
                                                                              .toString())
                                                                          .then((value) {
                                                                        Get.to(
                                                                            your_reviews(
                                                                          staffid: getOrderHistory
                                                                              .response
                                                                              .value
                                                                              .data?[index]
                                                                              .staffdata!
                                                                              .staffId
                                                                              .toString(),
                                                                          frompage:
                                                                              "upcoming",
                                                                        ));
                                                                        // if (getStaffDetailsController
                                                                        //     .response
                                                                        //     .value
                                                                        //     .status ==
                                                                        //     false) {
                                                                        //   Fluttertoast
                                                                        //       .showToast(
                                                                        //       msg:
                                                                        //       "No Data Found");
                                                                        // } else {
                                                                        //   Get.to(
                                                                        //       your_reviews(
                                                                        //         staffid: getUpcomingOrderController
                                                                        //             .response
                                                                        //             .value
                                                                        //             .data?[
                                                                        //         index]
                                                                        //             .staffdata!
                                                                        //             .staffId
                                                                        //             .toString(),
                                                                        //         frompage:
                                                                        //         "upcoming",
                                                                        //       ));
                                                                        // }
                                                                      });
                                                                    } else {
                                                                      commontoas(
                                                                          "No Staff Assign Yet");
                                                                    }
                                                                  },
                                                                  child:
                                                                      SizedBox(
                                                                          width: SizeConfig.screenWidth *
                                                                              0.9,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                "Professional",
                                                                                style: font_style.yell_400_16,
                                                                              ),
                                                                              const Spacer(),
                                                                              Text(
                                                                                getOrderHistory.response.value.data![index].staffdata?.staffName.toString() == "" || getOrderHistory.response.value.data![index].staffdata?.staffName == null ? "Waiting for assign" : getOrderHistory.response.value.data![index].staffdata?.staffName.toString()??"",
                                                                                style: font_style.black_400_14_under,
                                                                              ),
                                                                              const Icon(Icons.keyboard_arrow_right_outlined)
                                                                            ],
                                                                          )),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: SizeConfig
                                                                        .screenHeight *
                                                                    0.01,
                                                              ),

                                                              //PAYMENT METHOD
                                                              Center(
                                                                child: SizedBox(
                                                                    width: SizeConfig
                                                                            .screenWidth *
                                                                        0.9,
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          "Payment Method",
                                                                          style:
                                                                              font_style.yell_400_16,
                                                                        ),
                                                                        const Spacer(),
                                                                        Text(
                                                                          getOrderHistory.response.value.data![index].paymentType.toString() == "cod"
                                                                              ? "Pay After Service"
                                                                              : getOrderHistory.response.value.data![index].paymentType.toString(),
                                                                          style:
                                                                              font_style.black_400_16,
                                                                        ),
                                                                      ],
                                                                    )),
                                                              ),
                                                              SizedBox(
                                                                height: SizeConfig
                                                                        .screenHeight *
                                                                    0.01,
                                                              ),

                                                              //STATUS
                                                              Center(
                                                                child: SizedBox(
                                                                    width: SizeConfig
                                                                            .screenWidth *
                                                                        0.9,
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          "Booking Status",
                                                                          style:
                                                                              font_style.yell_400_16,
                                                                        ),
                                                                        const Spacer(),
                                                                        Text(
                                                                          getOrderHistory
                                                                              .response
                                                                              .value
                                                                              .data![index]
                                                                              .status
                                                                              .toString(),
                                                                          style: font_style
                                                                              .blue_600_14
                                                                              .copyWith(color: const Color(0xff22C55E)),
                                                                        ),
                                                                      ],
                                                                    )),
                                                              ),
                                                              SizedBox(
                                                                height: SizeConfig
                                                                        .screenHeight *
                                                                    0.01,
                                                              ),
                                                            ],
                                                          ),
                                                          Positioned(
                                                              left: SizeConfig
                                                                      .screenWidth *
                                                                  0.40,
                                                              top: 50,
                                                              child: Image.asset(
                                                                  getOrderHistory
                                                                              .response
                                                                              .value
                                                                              .data![index]
                                                                              .status ==
                                                                          'Confirmed'
                                                                      ? 'assets/images/success.png'
                                                                      : 'assets/images/cancel.png',
                                                                  width: 100,
                                                                  height: 80))
                                                        ],
                                                      ),
                                                    ));
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                          'assets/images/log.png',
                                                          width: 40,
                                                          height: 40),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                        '${getOrderHistory.response.value.data?[index].itemList?[0].title}',
                                                        style: font_style
                                                            .black_600_18
                                                            .copyWith(
                                                                color:
                                                                    yellow_col),
                                                      ),
                                                      const Spacer(),
                                                      const Icon(
                                                          Icons
                                                              .arrow_forward_ios_rounded,
                                                          size: 15)
                                                    ],
                                                  ),
                                                ),
                                                const Divider(
                                                    thickness: 1.0,
                                                    color: Colors.black),
                                                Column(
                                                  children: [
                                                    Center(
                                                      child: SizedBox(
                                                          width: SizeConfig
                                                                  .screenWidth *
                                                              0.9,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "DATE",
                                                                style: font_style
                                                                    .yell_400_16,
                                                              ),
                                                              const Spacer(),
                                                              Text(
                                                                getOrderHistory
                                                                    .response
                                                                    .value
                                                                    .data![
                                                                        index]
                                                                    .bookingDate
                                                                    .toString(),
                                                                style: font_style
                                                                    .black_400_16,
                                                              ),
                                                            ],
                                                          )),
                                                    ),

                                                    SizedBox(
                                                      height: SizeConfig
                                                              .screenHeight *
                                                          0.01,
                                                    ),

                                                    //ID ORDER
                                                    Center(
                                                      child: SizedBox(
                                                          width: SizeConfig
                                                                  .screenWidth *
                                                              0.9,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "ID ORDER",
                                                                style: font_style
                                                                    .yell_400_16,
                                                              ),
                                                              const Spacer(),
                                                              Text(
                                                                getOrderHistory
                                                                    .response
                                                                    .value
                                                                    .data![
                                                                        index]
                                                                    .bookingId
                                                                    .toString(),
                                                                style: font_style
                                                                    .black_400_16,
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                    SizedBox(
                                                      height: SizeConfig
                                                              .screenHeight *
                                                          0.01,
                                                    ),

                                                    //SUB TOTAL
                                                    Center(
                                                      child: SizedBox(
                                                          width: SizeConfig
                                                                  .screenWidth *
                                                              0.9,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "Total Amount",
                                                                style: font_style
                                                                    .yell_400_16,
                                                              ),
                                                              const Spacer(),
                                                              Text(
                                                                "₹ ${getOrderHistory.response.value.data![index].price.toString()}",
                                                                style: font_style
                                                                    .black_400_16,
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                    SizedBox(
                                                      height: SizeConfig
                                                              .screenHeight *
                                                          0.01,
                                                    ),

                                                    //PAYMENT METHOD
                                                    Center(
                                                      child: SizedBox(
                                                          width: SizeConfig
                                                                  .screenWidth *
                                                              0.9,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "Payment Method",
                                                                style: font_style
                                                                    .yell_400_16,
                                                              ),
                                                              const Spacer(),
                                                              Text(
                                                                getOrderHistory
                                                                            .response
                                                                            .value
                                                                            .data![
                                                                                index]
                                                                            .paymentType
                                                                            .toString() ==
                                                                        "cod"
                                                                    ? "Pay After Service"
                                                                    : getOrderHistory
                                                                        .response
                                                                        .value
                                                                        .data![
                                                                            index]
                                                                        .paymentType
                                                                        .toString(),
                                                                style: font_style
                                                                    .black_400_16,
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                    SizedBox(
                                                      height: SizeConfig
                                                              .screenHeight *
                                                          0.01,
                                                    ),

                                                    //STATUS
                                                    Center(
                                                      child: SizedBox(
                                                          width: SizeConfig
                                                                  .screenWidth *
                                                              0.9,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "Booking Status",
                                                                style: font_style
                                                                    .yell_400_16,
                                                              ),
                                                              const Spacer(),
                                                              Text(
                                                                getOrderHistory
                                                                    .response
                                                                    .value
                                                                    .data![
                                                                        index]
                                                                    .status
                                                                    .toString(),
                                                                style: font_style
                                                                    .blue_600_14
                                                                    .copyWith(
                                                                        color: const Color(
                                                                            0xff22C55E)),
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                    SizedBox(
                                                      height: SizeConfig
                                                              .screenHeight *
                                                          0.01,
                                                    ),
                                                  ],
                                                ),
                                                const Divider(
                                                    thickness: 1.0,
                                                    color: Colors.black),
                                                Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'Write a Review*',
                                                          style: font_style
                                                              .black_400_14
                                                              .copyWith(
                                                              color:
                                                              yellow_col),
                                                        ),
                                                        const SizedBox(height: 7),
                                                        Text(
                                                          'This help us Improve for you',
                                                          style: font_style
                                                              .black_400_12
                                                              .copyWith(
                                                              color:
                                                              const Color(0xffA1A1AA)),
                                                        ),
                                                      ],
                                                    ),
                                                    const Spacer(),
                                                    InkWell(
                                                      onTap:(){
                                                        Get.bottomSheet(Container(
                                                          decoration: const BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                                                          ),
                                                          constraints:
                                                          BoxConstraints(
                                                              maxHeight:
                                                              Get.height *
                                                                  0.50,
                                                              minHeight:
                                                              Get.height *
                                                                  0.35),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(height: SizeConfig
                                                                  .screenHeight *0.05),
                                                              Align(
                                                                child: Text(
                                                                  "Write a Review about the Service*",
                                                                  style: font_style.black_600_14.copyWith(fontWeight: FontWeight.w400,color: yellow_col,decoration: TextDecoration.none,fontSize: 18),
                                                                ),
                                                              ),
                                                              SizedBox(height: SizeConfig
                                                                  .screenHeight *0.10),
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      "Write a Comment",
                                                                      style: font_style.black_600_16.copyWith(fontWeight: FontWeight.w600,color: Colors.black),
                                                                    ),
                                                                    const SizedBox(height: 10),
                                                                    Center(
                                                                      child: SizedBox(
                                                                        width: SizeConfig.screenWidth,
                                                                        child: TextFormField(
                                                                          keyboardType: TextInputType.text,
                                                                          maxLines: 4,
                                                                          // readOnly: isotp == true ? true : false,
                                                                          style: font_style.white_400_16
                                                                              .copyWith(color: Colors.black),
                                                                          decoration: InputDecoration(
                                                                            counterText: "",
                                                                            hintText: "What did you like the most?",
                                                                            hintStyle: font_style.white_400_16.copyWith(
                                                                              color: const Color(0xff999999),
                                                                            ),
                                                                            enabledBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: yellow_col)),
                                                                            focusedBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: yellow_col)),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(height: 10),
                                                                    Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child: Container(
                                                                            width: 80,
                                                                            height: 40,
                                                                            alignment:
                                                                            Alignment.center,
                                                                            padding: EdgeInsets.symmetric(
                                                                                vertical: SizeConfig
                                                                                    .screenHeight *
                                                                                    0.01),
                                                                            decoration:
                                                                            BoxDecoration(
                                                                                borderRadius:
                                                                                BorderRadius
                                                                                    .circular(
                                                                                    8.0),
                                                                                border: Border.all(
                                                                                    color: yellow_col,
                                                                                    width: 1
                                                                                )
                                                                            ),
                                                                            // child: Text("PAY ₹ ${int.parse(_get_cart.response.value.total.toString())+int.parse(selected_tip.toString().substring(1))}",style: font_style.white_600_14,),
                                                                            child: Text("Remind me Later",
                                                                              style: font_style
                                                                                  .white_600_16.copyWith(color: yellow_col),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(width: 15),
                                                                        Expanded(
                                                                          child: Container(
                                                                            width: 80,
                                                                            height: 40,
                                                                            alignment:
                                                                            Alignment.center,
                                                                            padding: EdgeInsets.symmetric(
                                                                                vertical: SizeConfig
                                                                                    .screenHeight *
                                                                                    0.01),
                                                                            decoration:
                                                                            BoxDecoration(
                                                                              borderRadius:
                                                                              BorderRadius
                                                                                  .circular(
                                                                                  8.0),
                                                                              color: yellow_col

                                                                            ),
                                                                            // child: Text("PAY ₹ ${int.parse(_get_cart.response.value.total.toString())+int.parse(selected_tip.toString().substring(1))}",style: font_style.white_600_14,),
                                                                            child: Text("Submit",
                                                                              style: font_style
                                                                                  .white_600_16,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),

                                                            ],
                                                          ),
                                                        ));
                                                      },
                                                      child: Container(
                                                        width: 80,
                                                        height: 32,
                                                        alignment:
                                                        Alignment.center,
                                                        padding: EdgeInsets.symmetric(
                                                            vertical: SizeConfig
                                                                .screenHeight *
                                                                0.01),
                                                        decoration:
                                                        BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              8.0),
                                                          color: yellow_col,
                                                        ),
                                                        // child: Text("PAY ₹ ${int.parse(_get_cart.response.value.total.toString())+int.parse(selected_tip.toString().substring(1))}",style: font_style.white_600_14,),
                                                        child: Text("Review",
                                                          style: font_style
                                                              .white_600_16,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            height: 1,
                                            color: line_cont_col,
                                            width: SizeConfig.screenWidth * 0.9,
                                          );
                                        },
                                      ),
                                (getUpcomingOrderController
                                            .response.value.data?.isEmpty ??
                                        false)
                                    ? Container(
                                        height: SizeConfig.screenHeight,
                                        alignment: Alignment.center,
                                        width: SizeConfig.screenWidth * 0.9,
                                        child: const Text("No Upcoming Orders"),
                                      )
                                    : ListView.separated(
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: getUpcomingOrderController
                                                .response.value.data?.length ??
                                            0,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Get.bottomSheet(
                                                        Container(
                                                          color: Colors.white,
                                                          constraints:
                                                              BoxConstraints(
                                                                  maxHeight: Get
                                                                          .height *
                                                                      0.65,
                                                                  minHeight:
                                                                      Get.height *
                                                                          0.35),
                                                          child:
                                                              SingleChildScrollView(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                SizedBox(
                                                                  height: SizeConfig
                                                                          .screenHeight *
                                                                      0.009,
                                                                ),
                                                                Align(
                                                                  child:
                                                                      Container(
                                                                    width: 100,
                                                                    height: 6,
                                                                    decoration: BoxDecoration(
                                                                        color: const Color(
                                                                            0xffA1A1AA),
                                                                        borderRadius:
                                                                            BorderRadius.circular(30)),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: SizeConfig
                                                                          .screenHeight *
                                                                      0.009,
                                                                ),
                                                                //SERVICES
                                                                // Padding(
                                                                //   padding:
                                                                //       const EdgeInsets
                                                                //               .symmetric(
                                                                //           horizontal:
                                                                //               15),
                                                                //   child: Text(
                                                                //     "Service name",
                                                                //     style: font_style
                                                                //         .black_600_18,
                                                                //   ),
                                                                // ),
                                                                const Divider(
                                                                    thickness:
                                                                        1,
                                                                    color: Color(
                                                                        0xffE4E4E7)),
                                                                SizedBox(
                                                                  height: SizeConfig
                                                                          .screenHeight *
                                                                      0.01,
                                                                ),
                                                                ListView
                                                                    .builder(
                                                                        physics:
                                                                            const NeverScrollableScrollPhysics(),
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemCount: getUpcomingOrderController
                                                                            .response
                                                                            .value
                                                                            .data?[
                                                                                index]
                                                                            .itemList
                                                                            ?.length,
                                                                        itemBuilder: (context,
                                                                                indexAt) =>
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                                                              child: SizedBox(
                                                                                width: SizeConfig.screenWidth * 0.9,
                                                                                child: Row(
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: [
                                                                                    Text(
                                                                                      getUpcomingOrderController.response.value.data?[index].itemList?[indexAt].title ?? "",
                                                                                      style: font_style.black_400_16,
                                                                                    ),
                                                                                    const Spacer(),
                                                                                    Text(
                                                                                      "₹ ${double.parse(getUpcomingOrderController.response.value.data?[index].itemList?[indexAt].price ?? "").toStringAsFixed(2)}",
                                                                                      style: font_style.black_500_14,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            )),
                                                                const Divider(
                                                                    thickness:
                                                                        1,
                                                                    color: Color(
                                                                        0xffE4E4E7)),
                                                                //DATE
                                                                Center(
                                                                  child: SizedBox(
                                                                      width: SizeConfig.screenWidth * 0.9,
                                                                      child: Row(
                                                                        children: [
                                                                          Text(
                                                                            "DATE",
                                                                            style:
                                                                                font_style.yell_400_16,
                                                                          ),
                                                                          const Spacer(),
                                                                          Text(
                                                                            getUpcomingOrderController.response.value.data![index].bookingDate.toString(),
                                                                            style:
                                                                                font_style.black_400_16,
                                                                          ),
                                                                        ],
                                                                      )),
                                                                ),

                                                                SizedBox(
                                                                  height: SizeConfig
                                                                          .screenHeight *
                                                                      0.01,
                                                                ),

                                                                //ID ORDER
                                                                Center(
                                                                  child: SizedBox(
                                                                      width: SizeConfig.screenWidth * 0.9,
                                                                      child: Row(
                                                                        children: [
                                                                          Text(
                                                                            "ID ORDER",
                                                                            style:
                                                                                font_style.yell_400_16,
                                                                          ),
                                                                          const Spacer(),
                                                                          Text(
                                                                            getUpcomingOrderController.response.value.data![index].bookingId.toString(),
                                                                            style:
                                                                                font_style.black_400_16,
                                                                          ),
                                                                        ],
                                                                      )),
                                                                ),
                                                                SizedBox(
                                                                  height: SizeConfig
                                                                          .screenHeight *
                                                                      0.01,
                                                                ),

                                                                //SUB TOTAL
                                                                Center(
                                                                  child: SizedBox(
                                                                      width: SizeConfig.screenWidth * 0.9,
                                                                      child: Row(
                                                                        children: [
                                                                          Text(
                                                                            "Total Amount",
                                                                            style:
                                                                                font_style.yell_400_16,
                                                                          ),
                                                                          const Spacer(),
                                                                          Text(
                                                                            "₹ ${getUpcomingOrderController.response.value.data![index].price.toString()}",
                                                                            style:
                                                                                font_style.black_400_16,
                                                                          ),
                                                                        ],
                                                                      )),
                                                                ),
                                                                SizedBox(
                                                                  height: SizeConfig
                                                                          .screenHeight *
                                                                      0.01,
                                                                ),

                                                                //PROFESSONAL
                                                                Center(
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      if (getUpcomingOrderController
                                                                              .response
                                                                              .value
                                                                              .data![index]
                                                                              .staffdata
                                                                              ?.staffId !=
                                                                          null) {
                                                                        getStaffDetailsController
                                                                            .get_staffs_details_cont(getUpcomingOrderController.response.value.data![index].staffdata!.staffId.toString())
                                                                            .then((value) {
                                                                          Get.to(
                                                                              your_reviews(
                                                                            staffid:
                                                                                getUpcomingOrderController.response.value.data?[index].staffdata!.staffId.toString(),
                                                                            frompage:
                                                                                "upcoming",
                                                                          ));
                                                                          // if (getStaffDetailsController
                                                                          //     .response
                                                                          //     .value
                                                                          //     .status ==
                                                                          //     false) {
                                                                          //   Fluttertoast
                                                                          //       .showToast(
                                                                          //       msg:
                                                                          //       "No Data Found");
                                                                          // } else {
                                                                          //   Get.to(
                                                                          //       your_reviews(
                                                                          //         staffid: getUpcomingOrderController
                                                                          //             .response
                                                                          //             .value
                                                                          //             .data?[
                                                                          //         index]
                                                                          //             .staffdata!
                                                                          //             .staffId
                                                                          //             .toString(),
                                                                          //         frompage:
                                                                          //         "upcoming",
                                                                          //       ));
                                                                          // }
                                                                        });
                                                                      } else {
                                                                        commontoas(
                                                                            "No Staff Assign Yet");
                                                                      }
                                                                    },
                                                                    child: SizedBox(
                                                                        width: SizeConfig.screenWidth * 0.9,
                                                                        child: Row(
                                                                          children: [
                                                                            Text(
                                                                              "Professional",
                                                                              style: font_style.yell_400_16,
                                                                            ),
                                                                            const Spacer(),
                                                                            Text(
                                                                              getUpcomingOrderController.response.value.data![index].staffdata!.staffName.toString() == "" || getUpcomingOrderController.response.value.data![index].staffdata!.staffName == null ? "Waiting for assign" : getUpcomingOrderController.response.value.data![index].staffdata!.staffName.toString(),
                                                                              style: font_style.black_400_14_under,
                                                                            ),
                                                                            const Icon(Icons.keyboard_arrow_right_outlined)
                                                                          ],
                                                                        )),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: SizeConfig
                                                                          .screenHeight *
                                                                      0.01,
                                                                ),

                                                                //PAYMENT METHOD
                                                                Center(
                                                                  child: SizedBox(
                                                                      width: SizeConfig.screenWidth * 0.9,
                                                                      child: Row(
                                                                        children: [
                                                                          Text(
                                                                            "Payment Method",
                                                                            style:
                                                                                font_style.yell_400_16,
                                                                          ),
                                                                          const Spacer(),
                                                                          Text(
                                                                            getUpcomingOrderController.response.value.data![index].paymentType.toString() == "cod"
                                                                                ? "Pay After Service"
                                                                                : getUpcomingOrderController.response.value.data![index].paymentType.toString(),
                                                                            style:
                                                                                font_style.black_400_16,
                                                                          ),
                                                                        ],
                                                                      )),
                                                                ),
                                                                SizedBox(
                                                                  height: SizeConfig
                                                                          .screenHeight *
                                                                      0.01,
                                                                ),

                                                                //STATUS
                                                                Center(
                                                                  child: SizedBox(
                                                                      width: SizeConfig.screenWidth * 0.9,
                                                                      child: Row(
                                                                        children: [
                                                                          Text(
                                                                            "Booking Status",
                                                                            style:
                                                                                font_style.yell_400_16,
                                                                          ),
                                                                          const Spacer(),
                                                                          Text(
                                                                            getUpcomingOrderController.response.value.data![index].status.toString(),
                                                                            style:
                                                                                font_style.blue_600_14.copyWith(color: const Color(0xff22C55E)),
                                                                          ),
                                                                        ],
                                                                      )),
                                                                ),
                                                                SizedBox(
                                                                  height: SizeConfig
                                                                          .screenHeight *
                                                                      0.01,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        isScrollControlled:
                                                            true);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                          'assets/images/log.png',
                                                          width: 40,
                                                          height: 40),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                        getUpcomingOrderController
                                                                .response
                                                                .value
                                                                .data?[index]
                                                                .itemList?[0]
                                                                .title
                                                                .toString()
                                                                .capitalizeFirst ??
                                                            "",
                                                        style: font_style
                                                            .black_600_18
                                                            .copyWith(
                                                                color:
                                                                    yellow_col),
                                                      ),
                                                      const Spacer(),
                                                      const Icon(
                                                          Icons
                                                              .arrow_forward_ios_rounded,
                                                          size: 15)
                                                    ],
                                                  ),
                                                ),
                                                const Divider(
                                                    thickness: 1.0,
                                                    color: Color(0xffE4E4E7)),
                                                Column(
                                                  children: [
                                                    Center(
                                                      child: SizedBox(
                                                          width: SizeConfig
                                                                  .screenWidth *
                                                              0.9,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "DATE",
                                                                style: font_style
                                                                    .yell_400_16,
                                                              ),
                                                              const Spacer(),
                                                              Text(
                                                                getUpcomingOrderController
                                                                    .response
                                                                    .value
                                                                    .data![
                                                                        index]
                                                                    .bookingDate
                                                                    .toString(),
                                                                style: font_style
                                                                    .black_400_16,
                                                              ),
                                                            ],
                                                          )),
                                                    ),

                                                    SizedBox(
                                                      height: SizeConfig
                                                              .screenHeight *
                                                          0.01,
                                                    ),

                                                    //ID ORDER
                                                    Center(
                                                      child: SizedBox(
                                                          width: SizeConfig
                                                                  .screenWidth *
                                                              0.9,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "ID ORDER",
                                                                style: font_style
                                                                    .yell_400_16,
                                                              ),
                                                              const Spacer(),
                                                              Text(
                                                                getUpcomingOrderController
                                                                    .response
                                                                    .value
                                                                    .data![
                                                                        index]
                                                                    .bookingId
                                                                    .toString(),
                                                                style: font_style
                                                                    .black_400_16,
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                    SizedBox(
                                                      height: SizeConfig
                                                              .screenHeight *
                                                          0.01,
                                                    ),

                                                    //SUB TOTAL
                                                    Center(
                                                      child: SizedBox(
                                                          width: SizeConfig
                                                                  .screenWidth *
                                                              0.9,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "Total Amount",
                                                                style: font_style
                                                                    .yell_400_16,
                                                              ),
                                                              const Spacer(),
                                                              Text(
                                                                "₹ ${getUpcomingOrderController.response.value.data![index].price.toString()}",
                                                                style: font_style
                                                                    .black_400_16,
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                    SizedBox(
                                                      height: SizeConfig
                                                              .screenHeight *
                                                          0.01,
                                                    ),

                                                    //PAYMENT METHOD
                                                    Center(
                                                      child: SizedBox(
                                                          width: SizeConfig
                                                                  .screenWidth *
                                                              0.9,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "Payment Method",
                                                                style: font_style
                                                                    .yell_400_16,
                                                              ),
                                                              const Spacer(),
                                                              Text(
                                                                getUpcomingOrderController
                                                                            .response
                                                                            .value
                                                                            .data![
                                                                                index]
                                                                            .paymentType
                                                                            .toString() ==
                                                                        "cod"
                                                                    ? "Pay After Service"
                                                                    : getUpcomingOrderController
                                                                        .response
                                                                        .value
                                                                        .data![
                                                                            index]
                                                                        .paymentType
                                                                        .toString(),
                                                                style: font_style
                                                                    .black_400_16,
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                    SizedBox(
                                                      height: SizeConfig
                                                              .screenHeight *
                                                          0.01,
                                                    ),

                                                    //STATUS
                                                    Center(
                                                      child: SizedBox(
                                                          width: SizeConfig
                                                                  .screenWidth *
                                                              0.9,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "Booking Status",
                                                                style: font_style
                                                                    .yell_400_16,
                                                              ),
                                                              const Spacer(),
                                                              Text(
                                                                getUpcomingOrderController
                                                                    .response
                                                                    .value
                                                                    .data![
                                                                        index]
                                                                    .status
                                                                    .toString(),
                                                                style: font_style
                                                                    .blue_600_14
                                                                    .copyWith(
                                                                        color: const Color(
                                                                            0xff22C55E)),
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                    SizedBox(
                                                      height: SizeConfig
                                                              .screenHeight *
                                                          0.01,
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            height: 1.5,
                                            color: Colors.black,
                                            width: SizeConfig.screenWidth * 0.9,
                                          );
                                        },
                                      )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))
                : SizedBox(
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
                                  image:
                                      AssetImage("assets/images/HG_logo.png"))),
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
                  );
      }),
    );
  }
}
