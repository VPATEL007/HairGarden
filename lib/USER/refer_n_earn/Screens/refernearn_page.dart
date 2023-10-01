import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../COMMON/common_circular_indicator.dart';
import '../../../COMMON/common_color.dart';
import '../../../COMMON/size_config.dart';
import '../Controller/get_reward_controller.dart';
import 'package:flutter_share/flutter_share.dart';

class refernearn_page extends StatefulWidget {
  String? refercode;

  refernearn_page({required this.refercode});

  @override
  State<refernearn_page> createState() => _refernearn_pageState();
}

class _refernearn_pageState extends State<refernearn_page> {
  final _get_rewards = Get.put(get_reward_controller());

  String? uid;

  Future<void> getuserid() async {
    _get_rewards.loading(true);
    SharedPreferences sf = await SharedPreferences.getInstance();
    setState(() {
      uid = sf.getString("stored_uid");
    });
    _get_rewards.get_reward_cont(uid);
  }

  @override
  void initState() {
    getuserid();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    AppBar appbar = AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              )),
          SizedBox(
            width: SizeConfig.screenWidth * 0.01,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: bg_col,
              ),
              child: TabBar(
                  padding: const EdgeInsets.only(),
                  indicator: BoxDecoration(
                      border: Border(bottom: BorderSide(color: yellow_col)),
                      color: Colors.transparent),
                  labelColor: yellow_col,
                  indicatorColor: yellow_col,
                  labelStyle: font_style.yellow_600_16,
                  unselectedLabelColor: const Color(0xffA1A1AA),
                  tabs: const [
                    Tab(
                      text: 'Refer & Earn',
                    ),
                    Tab(text: 'Rewards'),
                  ]),
            ),
          ),
        ],
      ),
    );
    double height = appbar.preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Obx(() => _get_rewards.loading()
        ? const CommonIndicator()
        : DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: bg_col,
              appBar: appbar,
              body: SizedBox(
                height:
                    SizeConfig.screenHeight - height - height - statusBarHeight,
                width: SizeConfig.screenWidth,
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    SizedBox(height: SizeConfig.screenHeight * 0.026),
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          height: SizeConfig.screenHeight -
                              height -
                              height -
                              statusBarHeight,
                          width: SizeConfig.screenWidth,
                          child: TabBarView(
                            physics: const BouncingScrollPhysics(),
                            children: [
                              //REFER EARN
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.screenWidth * 0.05),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Invite & Earn",
                                              style: font_style.black_600_20,
                                            ),
                                            SizedBox(
                                              height: SizeConfig.screenHeight *
                                                  0.015,
                                            ),
                                            Row(
                                              children: [
                                                DottedBorder(
                                                  color: yellow_col,
                                                  strokeWidth: 3,
                                                  radius:
                                                      const Radius.circular(10),
                                                  dashPattern: const [
                                                    10,
                                                    9,
                                                  ],
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 6,
                                                        top: SizeConfig
                                                                .screenHeight *
                                                            0.01,
                                                        bottom: SizeConfig
                                                                .screenHeight *
                                                            0.01),
                                                    height: SizeConfig
                                                            .screenHeight *
                                                        0.075,
                                                    width:
                                                        SizeConfig.screenWidth *
                                                            0.4,
                                                    decoration: BoxDecoration(
                                                        gradient:
                                                            RadialGradient(
                                                                center:
                                                                    Alignment
                                                                        .center,
                                                                colors: [
                                                                  const Color(
                                                                          0xffDBE466)
                                                                      .withOpacity(
                                                                          0.4),
                                                                  const Color(
                                                                          0xffBF8D2C)
                                                                      .withOpacity(
                                                                          0.4),
                                                                ],
                                                                radius: 1.5)),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                            width: SizeConfig
                                                                    .screenWidth *
                                                                0.35,
                                                            child: FittedBox(
                                                                child: Text(
                                                              "Your Referal Code",
                                                              style: font_style
                                                                  .black_600_14_nounderline,
                                                            ))),
                                                        Text(
                                                          widget.refercode
                                                              .toString(),
                                                          style: font_style
                                                              .yellow_600_14,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                DottedBorder(
                                                  color: yellow_col,
                                                  strokeWidth: 3,
                                                  radius:
                                                      const Radius.circular(10),
                                                  dashPattern: const [
                                                    10,
                                                    9,
                                                  ],
                                                  child: InkWell(
                                                    onTap: () {
                                                      Clipboard.setData(
                                                          ClipboardData(
                                                              text: widget
                                                                  .refercode
                                                                  .toString()));
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 10,
                                                          ),
                                                          child: Container(
                                                            height: 20,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.9,
                                                            decoration: const BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            20)),
                                                                color: Colors
                                                                    .black12),
                                                            child: Center(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: const [
                                                                  Icon(
                                                                    Icons
                                                                        .check_circle,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                      "Code Copied"),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                      ));
                                                    },
                                                    child: Container(
                                                      width: SizeConfig
                                                              .screenWidth *
                                                          0.1,
                                                      height: SizeConfig
                                                              .screenHeight *
                                                          0.075,
                                                      decoration: BoxDecoration(
                                                          gradient:
                                                              RadialGradient(
                                                                  center:
                                                                      Alignment
                                                                          .center,
                                                                  colors: [
                                                                    const Color(
                                                                            0xffDBE466)
                                                                        .withOpacity(
                                                                            0.4),
                                                                    const Color(
                                                                            0xffBF8D2C)
                                                                        .withOpacity(
                                                                            0.4),
                                                                  ],
                                                                  radius: 1.5)),
                                                      child: Icon(
                                                        Icons.copy,
                                                        color: yellow_col,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Expanded(
                                          child: Container(
                                            height:
                                                SizeConfig.screenHeight * 0.15,
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/refer_earn_img.png"),
                                                    fit: BoxFit.contain)),
                                          ),
                                        )
                                      ],
                                    ),

                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.02,
                                    ),

                                    //REFER NOW BUTTON
                                    Center(
                                      child: InkWell(
                                        onTap: () async {
                                          await FlutterShare.share(
                                              title: 'Hair Garden',
                                              text:
                                                  "Join Hair Garden using my Reference Code : ${widget.refercode.toString()}",
                                              chooserTitle: 'HIII');
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  SizeConfig.screenWidth * 0.04,
                                              vertical:
                                                  SizeConfig.screenHeight *
                                                      0.013),
                                          decoration: BoxDecoration(
                                              color: yellow_col,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Text(
                                            "REFER NOW",
                                            style: font_style.white_600_14,
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.02,
                                    ),

                                    // ListView.separated(
                                    //   itemCount: 3,
                                    //   shrinkWrap: true,
                                    //   scrollDirection: Axis.vertical,
                                    //   itemBuilder: (context, index) {
                                    //     return Row(
                                    //       children: [
                                    //         Container(
                                    //           height: SizeConfig.screenHeight *
                                    //               0.01,
                                    //           width:
                                    //               SizeConfig.screenWidth * 0.01,
                                    //           decoration: const BoxDecoration(
                                    //               color: Colors.black,
                                    //               shape: BoxShape.circle),
                                    //         ),
                                    //         SizedBox(
                                    //           width:
                                    //               SizeConfig.screenWidth * 0.02,
                                    //         ),
                                    //         SizedBox(
                                    //             width: SizeConfig.screenWidth *
                                    //                 0.85,
                                    //             child: Text(
                                    //               "Earn ₹150 on the first successful of the Referee",
                                    //               style:
                                    //                   font_style.black_400_14,
                                    //             ))
                                    //       ],
                                    //     );
                                    //   },
                                    //   separatorBuilder: (context, index) {
                                    //     return SizedBox(
                                    //       height:
                                    //           SizeConfig.screenHeight * 0.01,
                                    //     );
                                    //   },
                                    // )
                                  ],
                                ),
                              ),

                              //REWARDS
                              Obx(() => _get_rewards.loading.value
                                  ? const CommonIndicator()
                                  : _get_rewards.response.value.data == null
                                      ? Center(
                                          child: SizedBox(
                                            height:
                                                SizeConfig.screenHeight * 0.3,
                                            width: SizeConfig.screenWidth * 0.5,
                                            child: SvgPicture.asset(
                                              "assets/images/rewards_svg.svg",
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                      : ListView.separated(
                                          itemCount: _get_rewards.response.value
                                                  .data?.length ??
                                              0,
                                          shrinkWrap: true,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      SizeConfig.screenWidth *
                                                          0.05),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: SizeConfig
                                                            .screenHeight *
                                                        0.07,
                                                    width:
                                                        SizeConfig.screenWidth *
                                                            0.2,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            image: _get_rewards
                                                                            .response
                                                                            .value
                                                                            .data![
                                                                                index]
                                                                            .profile
                                                                            .toString() ==
                                                                        "" ||
                                                                    _get_rewards
                                                                            .response
                                                                            .value
                                                                            .data![
                                                                                index]
                                                                            .profile
                                                                            .toString() ==
                                                                        "null"
                                                                ? const AssetImage("assets/images/person2.jpg")
                                                                    as ImageProvider
                                                                : NetworkImage(
                                                                    _get_rewards
                                                                        .response
                                                                        .value
                                                                        .data![index]
                                                                        .profile
                                                                        .toString()),
                                                            fit: BoxFit.cover)),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        _get_rewards
                                                            .response
                                                            .value
                                                            .data![index]
                                                            .name
                                                            .toString(),
                                                        style: font_style
                                                            .black_600_14_nounderline,
                                                      ),
                                                      SizedBox(
                                                        height: SizeConfig
                                                                .screenHeight *
                                                            0.007,
                                                      ),
                                                      SizedBox(
                                                        width: SizeConfig
                                                                .screenWidth *
                                                            0.4,
                                                        child: Text(
                                                          _get_rewards
                                                              .response
                                                              .value
                                                              .data![index]
                                                              .remark
                                                              .toString(),
                                                          style: font_style
                                                              .black_300_14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    "₹${_get_rewards.response.value.data![index].amount.toString()} Earned",
                                                    style: font_style
                                                        .lightgeen_700_13,
                                                  )
                                                ],
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
                                              color: const Color(0xffA1A1AA),
                                            );
                                          },
                                        )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));
  }
}
