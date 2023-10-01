import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hairgarden/COMMON/common_circular_indicator.dart';
import 'package:hairgarden/COMMON/common_color.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:hairgarden/COMMON/size_config.dart';
import 'package:hairgarden/USER/book_slot%20Payment/Controller/get_coupon_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllCouponPage extends StatefulWidget {
  const AllCouponPage({Key? key}) : super(key: key);

  @override
  State<AllCouponPage> createState() => _AllCouponPageState();
}

class _AllCouponPageState extends State<AllCouponPage> {
  TextEditingController coupon = TextEditingController();
  final _get_copupon = Get.put(get_coupon_controller());
  String? uid;
  Future<void> getuserid() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    setState(() {
      uid = sf.getString("stored_uid");
      _get_copupon.getAllCoupen(uid);
    });
  }

  @override
  void initState() {
    print('Enter INI');
    getuserid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: common_color,
              size: 20,
            )),
        title: Text(
          "Coupons for you",
          style: font_style.green_600_20,
        ),
      ),
      body: Obx(() => _get_copupon.loading()?const CommonIndicator():
      (_get_copupon.couponModel().data?.isEmpty??false)?Container(
        height: SizeConfig.screenHeight,
        alignment: Alignment.center,
        width: SizeConfig.screenWidth * 0.9,
        child: const Text("No Coupon Found"),
      ):
      SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: yellow_col, width: 1.0),
                  borderRadius: BorderRadius.circular(4)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: font_style.greyA1A1AA_400_16,
                      controller: coupon,
                      decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: "Enter COUPON here",
                          hintStyle: font_style.greyA1A1AA_400_16,
                          contentPadding: const EdgeInsets.only(left: 6)),
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 32,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.screenHeight * 0.01),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: yellow_col,
                    ),
                    // child: Text("PAY ₹ ${int.parse(_get_cart.response.value.total.toString())+int.parse(selected_tip.toString().substring(1))}",style: font_style.white_600_14,),
                    child: Text(
                      "APPLY",
                      style: font_style.white_600_16,
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.screenWidth * 0.020,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: SizedBox(
                  width: SizeConfig.screenWidth * 0.9,
                  child: Text(
                    "BEST OFFERS FOR YOU",
                    textAlign: TextAlign.center,
                    style: font_style.black_600_16
                        .copyWith(color: const Color(0xff71717A)),
                  ),
                ),
              ),
            ),
            // Container(
            //   decoration: BoxDecoration(
            //       border: Border.all(color: yellow_col, width: 1.0),
            //       borderRadius: BorderRadius.circular(4)),
            //   padding: EdgeInsets.symmetric(
            //       horizontal: SizeConfig.screenWidth * 0.020, vertical: 12),
            //   margin: EdgeInsets.symmetric(
            //       horizontal: SizeConfig.screenWidth * 0.040),
            //   child: Column(
            //     children: [
            //       Row(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           SvgPicture.asset("assets/images/offer_svg.svg"),
            //
            //           SizedBox(width: SizeConfig.screenWidth * 0.020),
            //           Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 "Get 50% Off on 1st Order",
            //                 style: font_style.black_600_16,
            //               ),
            //               const SizedBox(height: 10),
            //               Text(
            //                 "Save upto ₹500 with this code",
            //                 style: font_style.black_600_16.copyWith(
            //                     fontWeight: FontWeight.w400,
            //                     fontSize: 14,
            //                     color: Colors.black),
            //               ),
            //               const SizedBox(height: 10),
            //               Row(
            //                 children: [
            //                   Text(
            //                     "CODE:",
            //                     style: font_style.black_600_16
            //                         .copyWith(color: const Color(0xff18181B)),
            //                   ),
            //                   SizedBox(width: SizeConfig.screenWidth * 0.020),
            //                   Container(
            //                     decoration: BoxDecoration(
            //                         border:
            //                         Border.all(color: yellow_col, width: 2.0),
            //                         borderRadius: BorderRadius.circular(4)),
            //                     padding: EdgeInsets.all(
            //                         SizeConfig.screenWidth * 0.013),
            //                     child: Text(
            //                       "FIRST",
            //                       style: font_style.black_600_16
            //                           .copyWith(color: yellow_col, fontSize: 14),
            //                     ),
            //                   ),
            //                 ],
            //               )
            //             ],
            //           ),
            //           Spacer(),
            //           Icon(Icons.keyboard_arrow_down_rounded, size: 18),
            //           // const Spacer(),
            //           // Container(
            //           //   width: 80,
            //           //   height: 32,
            //           //   alignment: Alignment.center,
            //           //   padding: EdgeInsets.symmetric(
            //           //       vertical: SizeConfig.screenHeight * 0.01),
            //           //   decoration: BoxDecoration(
            //           //     borderRadius:  BorderRadius.circular(8.0),
            //           //     color: yellow_col,
            //           //   ),
            //           //   // child: Text("PAY ₹ ${int.parse(_get_cart.response.value.total.toString())+int.parse(selected_tip.toString().substring(1))}",style: font_style.white_600_14,),
            //           //   child: Text(
            //           //     "APPLY",
            //           //     style: font_style.white_600_16,
            //           //   ),
            //           // ),
            //           // SizedBox(
            //           //   width: SizeConfig.screenWidth * 0.020,
            //           // ),
            //         ],
            //       ),
            //       const Divider(
            //         thickness: 1.0,
            //       ),
            //       Container(
            //         width: SizeConfig.screenWidth,
            //         height: 32,
            //         alignment: Alignment.center,
            //         padding: EdgeInsets.symmetric(
            //             vertical: SizeConfig.screenHeight * 0.01),
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(8.0),
            //           color: yellow_col,
            //         ),
            //         // child: Text("PAY ₹ ${int.parse(_get_cart.response.value.total.toString())+int.parse(selected_tip.toString().substring(1))}",style: font_style.white_600_14,),
            //         child: Text(
            //           "APPLY",
            //           style: font_style.white_600_16,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 10),
            //   child: Center(
            //     child: SizedBox(
            //       width: SizeConfig.screenWidth * 0.9,
            //       child: Text(
            //         "OTHER COUPONS",
            //         textAlign: TextAlign.center,
            //         style: font_style.black_600_16
            //             .copyWith(color: Color(0xff71717A)),
            //       ),
            //     ),
            //   ),
            // ),
            ListView.builder(
              shrinkWrap: true,
                itemCount: _get_copupon.couponModel().data?.length,
                itemBuilder: (context, index) => Container(
              decoration: BoxDecoration(
                  border: Border.all(color: yellow_col, width: 1.0),
                  borderRadius: BorderRadius.circular(4)),
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenWidth * 0.040),
              child: ExpansionTile(
                title: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset("assets/images/offer_svg.svg",color: common_color),

                      SizedBox(width: SizeConfig.screenWidth * 0.020),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${_get_copupon.couponModel().data?[index].description}",
                            style: font_style.black_600_16,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Save upto ₹${_get_copupon.couponModel().data?[index].amount} with this code",
                            style: font_style.black_600_16.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      // Spacer(),
                      // Icon(Icons.keyboard_arrow_down_rounded,size: 18),
                      // const Spacer(),
                      // Container(
                      //   width: 80,
                      //   height: 32,
                      //   alignment: Alignment.center,
                      //   padding: EdgeInsets.symmetric(
                      //       vertical: SizeConfig.screenHeight * 0.01),
                      //   decoration: BoxDecoration(
                      //     borderRadius:  BorderRadius.circular(8.0),
                      //     color: yellow_col,
                      //   ),
                      //   // child: Text("PAY ₹ ${int.parse(_get_cart.response.value.total.toString())+int.parse(selected_tip.toString().substring(1))}",style: font_style.white_600_14,),
                      //   child: Text(
                      //     "APPLY",
                      //     style: font_style.white_600_16,
                      //   ),
                      // ),
                      // SizedBox(
                      //   width: SizeConfig.screenWidth * 0.020,
                      // ),
                    ],
                  ),
                ),
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenWidth * 0.020),
                    // margin:  EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth*0.040),
                    child: Column(
                      children: [
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     SvgPicture.asset("assets/images/offer_svg.svg"),
                        //
                        //     SizedBox(width: SizeConfig.screenWidth*0.020),
                        //     Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Text(
                        //           "Get 50% Off on 1st Order",
                        //           style: font_style.black_600_16,
                        //         ),
                        //         const SizedBox(height: 10),
                        //         Text(
                        //           "Save upto ₹500 with this code",
                        //           style: font_style.black_600_16.copyWith(
                        //               fontWeight: FontWeight.w400,
                        //               fontSize: 14,
                        //               color: Colors.black
                        //           ),
                        //         ),
                        //         const SizedBox(height: 10),
                        //         Row(
                        //           children: [
                        //             Text(
                        //               "CODE:",
                        //               style: font_style.black_600_16.copyWith(
                        //                   color: const Color(0xff18181B)
                        //               ),
                        //             ),
                        //             SizedBox(width: SizeConfig.screenWidth*0.020),
                        //             Container(
                        //               decoration: BoxDecoration(
                        //                   border: Border.all(
                        //                       color: yellow_col,
                        //                       width: 2.0
                        //                   ),
                        //                   borderRadius: BorderRadius.circular(4)
                        //               ),
                        //               padding: EdgeInsets.all(SizeConfig.screenWidth*0.013),
                        //               child: Text(
                        //                 "FIRST",
                        //                 style: font_style.black_600_16.copyWith(
                        //                     color: yellow_col,
                        //                     fontSize: 14
                        //                 ),
                        //               ),
                        //             ),
                        //           ],
                        //         )
                        //       ],
                        //     ),
                        //     Spacer(),
                        //     Icon(Icons.keyboard_arrow_down_rounded,size: 18),
                        //     // const Spacer(),
                        //     // Container(
                        //     //   width: 80,
                        //     //   height: 32,
                        //     //   alignment: Alignment.center,
                        //     //   padding: EdgeInsets.symmetric(
                        //     //       vertical: SizeConfig.screenHeight * 0.01),
                        //     //   decoration: BoxDecoration(
                        //     //     borderRadius:  BorderRadius.circular(8.0),
                        //     //     color: yellow_col,
                        //     //   ),
                        //     //   // child: Text("PAY ₹ ${int.parse(_get_cart.response.value.total.toString())+int.parse(selected_tip.toString().substring(1))}",style: font_style.white_600_14,),
                        //     //   child: Text(
                        //     //     "APPLY",
                        //     //     style: font_style.white_600_16,
                        //     //   ),
                        //     // ),
                        //     // SizedBox(
                        //     //   width: SizeConfig.screenWidth * 0.020,
                        //     // ),
                        //
                        //   ],
                        // ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.screenWidth * 0.090),
                          child: Row(
                            children: [
                              Text(
                                "CODE:",
                                style: font_style.black_600_16
                                    .copyWith(color: const Color(0xff18181B)),
                              ),
                              SizedBox(width: SizeConfig.screenWidth * 0.020),
                              Container(
                                decoration: BoxDecoration(
                                    border:
                                    Border.all(color: yellow_col, width: 2.0),
                                    borderRadius: BorderRadius.circular(4)),
                                padding: EdgeInsets.all(
                                    SizeConfig.screenWidth * 0.013),
                                child: Text(
                                  "${_get_copupon.couponModel().data?[index].coupanCode}",
                                  style: font_style.black_600_16
                                      .copyWith(color: yellow_col, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 1.0,
                        ),
                        Container(
                          width: SizeConfig.screenWidth,
                          height: 32,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.screenHeight * 0.01),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: yellow_col,
                          ),
                          // child: Text("PAY ₹ ${int.parse(_get_cart.response.value.total.toString())+int.parse(selected_tip.toString().substring(1))}",style: font_style.white_600_14,),
                          child: Text(
                            "APPLY",
                            style: font_style.white_600_16,
                          ),
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.020),
                      ],
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      )),
    );
  }
}
