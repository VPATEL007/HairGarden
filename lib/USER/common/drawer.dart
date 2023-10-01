import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:hairgarden/USER/bottombar/Screens/bottombar.dart';
import 'package:hairgarden/USER/support/Screens/support_ticket.dart';
import 'package:hairgarden/USER/wallet/screen/wallet_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../COMMON/common_color.dart';
import '../../COMMON/size_config.dart';
import '../../auth/Screens/login_page.dart';
import '../address/Screens/address_page.dart';
import '../refer_n_earn/Screens/refernearn_page.dart';
import '../support/Screens/support_page.dart';

class drawer extends StatefulWidget {
  String? uid, wallet, sp_refercode;

  drawer({required this.uid, required this.wallet, required this.sp_refercode});

  @override
  State<drawer> createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  List draw_title = [
    "Wallet",
    "Order History",
    "Address",
    // "Coupen",
    "Support",
    "Refer & Earn",
  ];

  List draw_svg = [
    "assets/images/wallet.png",
    "assets/images/order_history.png",
    "assets/images/address.png",
    "assets/images/support.png",
    "assets/images/refer_earn.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: bg_col,
      width: MediaQuery.of(context).size.width * 0.70,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: SizeConfig.screenHeight * 0.010,
            ),
            Row(
              children: [
                SizedBox(
                  width: SizeConfig.screenWidth * 0.03,
                ),
                Image.asset("assets/images/HG_logo_small.png",
                    color: common_color,
                    width: SizeConfig.screenWidth * 0.50, height: 45).paddingSymmetric(vertical: 15),
                // Text("Hair Garden", style: font_style.grad_600_20),
                // const Spacer(),
                // widget.uid != null?Icon(
                //   Icons.account_balance_wallet,
                //   color: Colors.white.withOpacity(0.6),
                // ):const SizedBox(),
                // SizedBox(
                //   width: SizeConfig.screenWidth * 0.02,
                // ),
                // Text(
                //   widget.wallet.toString() == "" || widget.wallet == null
                //       ? ""
                //       : widget.wallet.toString(),
                //   style: font_style.white_400_14,
                // ),
                // SizedBox(
                //   width: SizeConfig.screenWidth * 0.02,
                // ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.05,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenWidth * 0.02),
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: draw_svg.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenWidth * 0.012),
                    child: InkWell(
                      onTap: () {
                        if (index == 0) {
                          if (widget.uid.toString() == "" ||
                              widget.uid == null) {
                            Get.offAll(login_page(
                              frompage: 'skip',
                            ),transition: Transition.downToUp );
                          } else {
                            Get.to(const WallerScreen());
                          }
                        } else if (index == 1) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const BottomBar(pasindx: 1)));
                        } else if (index == 2) {
                          if (widget.uid.toString() == "" ||
                              widget.uid == null) {
                            Get.offAll(login_page(
                              frompage: 'skip',
                            ),transition: Transition.downToUp );
                          } else {
                            Get.to(address_page(
                              page: "address",
                            ));
                          }
                        }

                        // else if (index == 3) {
                        //   if (widget.uid.toString() == "" ||
                        //       widget.uid == null) {
                        //     Get.offAll(login_page(
                        //       frompage: 'skip',
                        //     ));
                        //   } else {
                        //     Get.to(const AllCouponPage());
                        //   }
                        // }
                        // else if (index == 4) {
                        //   if (widget.uid.toString() == "" ||
                        //       widget.uid == null) {
                        //     Get.offAll(login_page(
                        //       frompage: 'skip',
                        //     ));
                        //   } else {
                        //     Get.to(const SupportTicketView());
                        //   }
                        // }
                        else if (index == 4) {
                          if (widget.uid.toString() == "" ||
                              widget.uid == null) {
                            Get.offAll(login_page(
                              frompage: 'skip',
                            ),transition: Transition.downToUp );
                          } else {
                            Get.to(refernearn_page(
                              refercode: widget.sp_refercode,
                            ));
                          }
                        }
                      },
                      child: index == 3
                          ? ListTileTheme(
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              horizontalTitleGap: 0.0,
                              minLeadingWidth: 0,
                              child: ExpansionTile(

                                  tilePadding: EdgeInsets.zero,
                                  childrenPadding: EdgeInsets.zero,
                                  iconColor: Colors.white,
                                  clipBehavior: Clip.antiAlias,
                                  collapsedIconColor: Colors.white,

                                  trailing: const Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.black,
                                  ),
                                  leading: Image.asset(draw_svg[index].toString(),width: 34,height: 34),
                                  title: Text(
                                    draw_title[index].toString(),
                                    style: font_style.grD4D4D8_600_14
                                        .copyWith(color: common_color),
                                  ).paddingSymmetric(horizontal: 10),
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (widget.uid.toString() == "" ||
                                            widget.uid == null) {
                                          Get.offAll(login_page(
                                            frompage: 'skip',
                                          ),transition: Transition.downToUp );
                                        }
                                        else
                                        {
                                          Get.to(const support_page());
                                        }


                                      },
                                      child: Row(
                                        children: [
                                          Image.asset('assets/images/createTicket.png',width: 34,height: 34),
                                          SizedBox(
                                            width:
                                                SizeConfig.screenWidth * 0.02,
                                          ),
                                          Text(
                                            'Create Ticket',
                                            style: font_style.grD4D4D8_600_14
                                                .copyWith(color: common_color),
                                          ),
                                          const Spacer(),
                                          const Icon(
                                            Icons.keyboard_arrow_right,
                                            color: Colors.black,
                                          )
                                        ],
                                      ).paddingSymmetric(vertical: 10),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (widget.uid.toString() == "" ||
                                            widget.uid == null) {
                                          Get.offAll(login_page(
                                            frompage: 'skip',
                                          ),transition: Transition.downToUp );
                                        }
                                        else
                                        {
                                          Get.to(const SupportTicketView());
                                        }

                                      },
                                      child: Row(
                                        children: [
                                          Image.asset('assets/images/myTicket.png',width: 34,height: 34),
                                          SizedBox(
                                            width:
                                                SizeConfig.screenWidth * 0.02,
                                          ),
                                          Text(
                                            "My Ticket",
                                            style: font_style.grD4D4D8_600_14
                                                .copyWith(color: common_color),
                                          ),
                                          const Spacer(),
                                          const Icon(
                                            Icons.keyboard_arrow_right,
                                            color: Colors.black,
                                          )
                                        ],
                                      ),
                                    )
                                  ]),
                            )
                          : Row(
                              children: [
                                Image.asset(draw_svg[index].toString(),width: 34,height: 34),
                                SizedBox(
                                  width: SizeConfig.screenWidth * 0.02,
                                ),
                                Text(
                                  draw_title[index].toString(),
                                  style: font_style.grD4D4D8_600_14
                                      .copyWith(color: common_color),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.black,
                                )
                              ],
                            ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.screenHeight * 0.015),
                    child: Container(
                      color: common_color,
                      height: 1.5,
                    ),
                  );
                },
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenWidth * 0.029),
              child: InkWell(
                onTap: () async {
                  if (widget.uid.toString() == "" || widget.uid == null) {
                    Get.offAll(login_page(
                      frompage: '',
                    ));
                  } else {
                    SharedPreferences sf =
                        await SharedPreferences.getInstance();
                    sf.clear();
                    Get.offAll(login_page(
                      frompage: '',
                    ),transition: Transition.downToUp );
                  }
                },
                child: Container(
                  height: SizeConfig.screenHeight * 0.046,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: common_color),
                  child: Text(
                    widget.uid.toString() == "" || widget.uid == null
                        ? "LOG IN"
                        : "LOG OUT",
                    style: font_style.white_600_14,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.09,
            ),
          ],
        ),
      ),
    );
  }
}
