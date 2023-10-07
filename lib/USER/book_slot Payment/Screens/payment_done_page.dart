import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/animation/gf_animation.dart';
import 'package:getwidget/types/gf_animation_type.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:intl/intl.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../COMMON/common_circular_indicator.dart';
import '../../../COMMON/common_color.dart';
import '../../../COMMON/size_config.dart';
import '../../bottombar/Screens/bottombar.dart';
import '../../category/Controller/get_all_cat_products_controller.dart';
import '../../category/Controller/get_cart_controller.dart';
import '../../home/Controller/get_banner_controller.dart';
import '../../home/Controller/get_testimonials_controller.dart';
import '../Controller/book_service_controller.dart';

class payment_done_page extends StatefulWidget {
  String discount, date, tip;

  payment_done_page(
      {required this.discount, required this.date, required this.tip});

  @override
  State<payment_done_page> createState() => _payment_done_pageState();
}

class _payment_done_pageState extends State<payment_done_page>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  final _get_testimonials = Get.put(get_testimonials_controller());
  final _get_cart = Get.put(get_cart_controller());
  var uid;

  getuserid() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    setState(() {
      uid = sf.getString("stored_uid");
    });
  }

  String? _deviceId;

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
      print("deviceId->$_deviceId");
    });
  }

  String? formatted, formattertimes;

  @override
  void initState() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yMMMEd');
    final DateFormat formattertime = DateFormat('jm');
    setState(() {
      formatted = formatter.format(now);
      formattertimes = formattertime.format(now);
    });

    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.linear);
    controller.repeat();
    super.initState();
  }

  final _book_service = Get.put(book_service_controller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg_col,
      body: Obx(() {
        return _book_service.loading.value
            ? const CommonIndicator()
            : SafeArea(
                child: SizedBox(
                  height: SizeConfig.screenHeight,
                  width: SizeConfig.screenWidth,
                  child: Column(
                    children: [
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.02,
                      ),

                      GFAnimation(
                          alignment: Alignment.center,
                          height: SizeConfig.screenHeight * 0.12,
                          width: SizeConfig.screenWidth * 0.26,
                          scaleAnimation: animation,
                          controller: controller,
                          type: GFAnimationType.scaleTransition,
                          child: SvgPicture.asset(
                              "assets/images/payment_done.svg",
                              fit: BoxFit.contain,
                              color: common_color)),

                      SizedBox(
                        height: SizeConfig.screenHeight * 0.01,
                      ),
                      Center(
                          child: Text(
                        "Order Placed",
                        style: font_style.green_600_20,
                      )),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.03,
                      ),

                      //IMAGE RABIA ROW
                      // Container(
                      //   padding: EdgeInsets.symmetric(horizontal: 2,vertical: SizeConfig.screenHeight*0.01),
                      //   width: SizeConfig.screenWidth*0.9,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(8),
                      //     border: Border.all(color: line_cont_col)
                      //   ),
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children: [
                      //       //IMAGES
                      //       Container(
                      //         height: SizeConfig.screenHeight*0.07,
                      //         width: SizeConfig.screenWidth*0.14,
                      //         decoration: BoxDecoration(
                      //             shape: BoxShape.circle,
                      //             image: DecorationImage(
                      //                 image: AssetImage("assets/images/rabia_img.png"),
                      //                 fit: BoxFit.cover
                      //             )
                      //         ),
                      //
                      //       ),
                      //       SizedBox(width: SizeConfig.screenWidth*0.02,),
                      //
                      //       Column(
                      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Text("Rabia",style: font_style.black_600_14,),
                      //           Row(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               Icon(Icons.star_half,color: Color(0xffF2C94C),size: 15,),
                      //               Text("4.5",style: font_style.black_400_10,),
                      //             ],
                      //           ),
                      //           Container(
                      //               width: SizeConfig.screenWidth*0.7,
                      //               child: Text("Our Best Recommend will be Assigned to you",style: font_style.greyA1A1AA_400_12,)),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(height: SizeConfig.screenHeight*0.03,),

                      //DATE TIME CONT


                      //PRODUCT COST PRICE

                    Center(
                      child: SizedBox(
                        width: SizeConfig.screenWidth * 0.9,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${_get_cart.response.value.data?[0].title.toString()}",
                              style: font_style.black_400_16,
                            ),
                            const Spacer(),
                            Text(
                              "₹ ${double.parse(_get_cart.response.value.data?[0].price.toString() ?? "").toStringAsFixed(2)}",
                              style: font_style.black_500_14,
                            ),
                          ],
                        ),
                      ),
                    ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.02,
                      ),
                      Center(
                        child: SizedBox(
                          width: SizeConfig.screenWidth * 0.9,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _get_cart.response.value.data
                                  ?.where(
                                      (element) => element.type == "addonservice")
                                  .toList()
                                  .length,
                              itemBuilder: (context, indexAT) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                      child: Container(
                                        height: 1,
                                        color: line_cont_col,
                                        width: SizeConfig.screenWidth * 0.9,
                                      )),
                                  SizedBox(
                                    height: SizeConfig.screenHeight * 0.010,
                                  ),
                                  Text(
                                    "Add On Service",
                                    style: font_style.black_500_16,
                                  ),
                                  SizedBox(
                                    height: SizeConfig.screenHeight * 0.010,
                                  ),
                                  Center(
                                      child: Container(
                                        height: 1,
                                        color: line_cont_col,
                                        width: SizeConfig.screenWidth * 0.9,
                                      )),
                                  SizedBox(
                                    height: SizeConfig.screenHeight * 0.010,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${_get_cart.response.value.data?.where((element) => element.type == "addonservice").toList()[indexAT].title.toString().capitalizeFirst}",
                                        style: font_style.black_400_16,
                                      ),
                                      const Spacer(),
                                      Text(
                                        "₹ ${double.parse(_get_cart.response.value.data?.where((element) => element.type == "addonservice").toList()[indexAT].price ?? "").toStringAsFixed(2)}",
                                        style: font_style.black_500_14,
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.01),
                      // Center(
                      //   child: Container(
                      //     width: SizeConfig.screenWidth*0.9,
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Text("Service Cost",style: font_style.black_500_16,),
                      //         Text("₹${_book_service.totprice}",style: font_style.black_500_16,),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(height: SizeConfig.screenHeight*0.01,),
                      //LINE
                      // Center(
                      //     child: Container(
                      //       height: 1,
                      //       color: line_cont_col,
                      //       width: SizeConfig.screenWidth*0.9,
                      //     )
                      // ),
                      // SizedBox(height: SizeConfig.screenHeight*0.01,),

                      widget.tip.isNotEmpty
                          ? Center(
                              child: SizedBox(
                                width: SizeConfig.screenWidth * 0.9,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Tip Amount",
                                      style: font_style.black_500_16,
                                    ),
                                    const Spacer(),
                                    Text(
                                      "₹ ${widget.tip}",
                                      style: font_style.black_500_16,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(),

                      widget.discount == ""
                          ? Container()
                          : Column(
                              children: [
                                //LINE
                                Center(
                                    child: Container(
                                  height: 1,
                                  color: line_cont_col,
                                  width: SizeConfig.screenWidth * 0.9,
                                )),
                                // SizedBox(height: SizeConfig.screenHeight*0.01,),
                                // //WALLET
                                // Center(
                                //   child: SizedBox(
                                //     width: SizeConfig.screenWidth*0.9,
                                //     child: Row(
                                //       crossAxisAlignment: CrossAxisAlignment.center,
                                //       children: [
                                //         Text("Discount From Coupon ",style: font_style.black_500_16,),
                                //         const Spacer(),
                                //         Text("- ₹ ${widget.discount}",style: font_style.black_500_16,),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),

                      //SEVICE COST PRICE
                      // Center(
                      //   child: Container(
                      //     width: SizeConfig.screenWidth*0.9,
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Text("Service Cost",style: font_style.black_500_14,),
                      //         Text("₹1.50",style: font_style.black_500_14,),
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      // SizedBox(height: SizeConfig.screenHeight*0.01,),
                      //
                      // //LINE
                      // Center(
                      //     child: Container(
                      //       height: 1,
                      //       color: line_cont_col,
                      //       width: SizeConfig.screenWidth*0.9,
                      //     )
                      // ),

                      SizedBox(
                        height: SizeConfig.screenHeight * 0.01,
                      ),

                      //TOTAL PRICE
                      Center(
                        child: SizedBox(
                          width: SizeConfig.screenWidth * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                                style: font_style.gr27272A_600_18,
                              ),
                              Text(
                                "₹${_book_service.totprice}",
                                style: font_style.gr27272A_600_18,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.04,
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.screenHeight * 0.02,
                              horizontal: SizeConfig.screenWidth * 0.02),
                          width: SizeConfig.screenWidth * 0.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: yellow_col),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Date & Time: ",
                                    style: font_style.gr808080_400_16,
                                  ),
                                  // Text("${formatted.toString()}  ${formattertimes.toString()}",style: font_style.gr27272A_600_16  ,),
                                  Text(
                                    "${widget.date}",
                                    style: font_style.gr27272A_600_16,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: SizeConfig.screenHeight * 0.01,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Time Slot: ",
                                    style: font_style.gr808080_400_16,
                                  ),
                                  Text(
                                    _book_service.slot.toString(),
                                    style: font_style.gr27272A_600_16,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        height: SizeConfig.screenHeight * 0.03,
                      ),
                      //YOUR PAYMENT TXT
                      Center(
                        child: SizedBox(
                          width: SizeConfig.screenWidth * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.lock,
                                color: Colors.black,
                                size: SizeConfig.screenHeight * 0.02,
                              ),
                              SizedBox(
                                width: SizeConfig.screenWidth * 0.01,
                              ),
                              Expanded(
                                child: Container(
                                    child: Text(
                                  "Your payment information is safe with us. We use secure Transaction and End-to-End Encyptiom",
                                  style: font_style.greyA1A1AA_400_10_noline
                                      .copyWith(color: Colors.black),
                                  textAlign: TextAlign.justify,
                                )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),

                      InkWell(
                        onTap: () {
                          _get_cart.prodid.clear();
                          Get.to(BottomBar(
                            pasindx: 0,
                          ));
                          getuserid();
                          initPlatformState();
                          _get_testimonials
                              .get_testimonials_cont(uid.toString())
                              .then((value) {
                            _get_testimonials.yturl;
                            print(_get_testimonials.yturl);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.screenHeight * 0.01),
                          width: SizeConfig.screenWidth * 0.5,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: yellow_col,
                          ),
                          child: Text(
                            "CHECK OUT MORE!",
                            style: font_style.white_600_16,
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              );
      }),
    );
  }
}
