import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hairgarden/COMMON/common_circular_indicator.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import '../../../COMMON/common_color.dart';

import '../../../COMMON/common_color.dart';
import '../../../COMMON/size_config.dart';
import '../../book_slot Payment/Controller/get_staff_details_controller.dart';

class professional_details extends StatefulWidget {
  String? name;
  String? profileurl;

  professional_details({required this.name, required this.profileurl});

  @override
  State<professional_details> createState() => _professional_detailsState();
}

class _professional_detailsState extends State<professional_details> {
  final _get_staff_details = Get.put(get_staffs_details_controller());

  double _progressValue = 10.0;

  @override
  void initState() {
    // _get_staff_details.get_staffs_details_cont("20");
    super.initState();
  }

  List ratingbar = <double>[
    30.0,
    30.0,
    30.0,
    30.0,
    30.0,
  ];
  List ratingname = [
    "Excellent",
    "Good",
    "Average",
    "Not Good",
    "Poor",
  ];
  List person_name = [
    "Albert Flores",
    "Darrell Steward",
    "Jacob Jones",
    "Jane Cooper",
    "Jacob Jones",
    "Darrell Steward",
  ];

  List person_photo = [
    "assets/images/product1_img.png",
    "assets/images/product2_img.png",
    "assets/images/product3_img.png",
    "assets/images/product4_img.png",
    "assets/images/product5_img.png",
    "assets/images/product1_img.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: bg_col,
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
            "Professional Details",
            style: font_style.green_600_20,
          ),
        ),
        body: _get_staff_details.loading.value
            ? const CommonIndicator()
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: _get_staff_details.hasnodata == false
                    ? Column(
                        children: [
                          Center(
                            child: Container(
                              height: SizeConfig.screenHeight * 0.12,
                              width: SizeConfig.screenWidth * 0.3,
                              decoration: BoxDecoration(
                                  color: yellow_col,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          widget.profileurl.toString()),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight * 0.01,
                          ),
                          Text(
                            widget.name.toString(),
                            style: font_style.black_600_14,
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight * 0.02,
                          ),
                          _get_staff_details.response.value.status == false
                              ? Container(
                                  width: SizeConfig.screenWidth,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      Text(
                                        "No Reviews Found",
                                        style: font_style.black_400_14,
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  children: [
                                    Text(
                                      "AVG. Rating",
                                      style: font_style.black_400_12,
                                    ),
                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.01,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.star_half,
                                          color: Color(0xffF2C94C),
                                        ),
                                        Text(
                                          _get_staff_details
                                              .response.value.average??'0.0',
                                          style: font_style.black_400_20,
                                        ),
                                        Text(
                                          " (${_get_staff_details.response.value.data?.length??0})",
                                          style: font_style.greyA1A1AA_400_12,
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.01,
                                    ),
                                    //EXCELLENT GOOD

                                    Center(
                                      child: Container(
                                          width: SizeConfig.screenWidth * 0.9,
                                          child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount: ratingname.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                height:
                                                    SizeConfig.screenHeight *
                                                        0.035,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        width: SizeConfig
                                                                .screenWidth *
                                                            0.4,
                                                        child: Text(
                                                          index == 0
                                                              ? "${ratingname[0]}(${_get_staff_details.response.value.ratelist?.excellent??'0'})"
                                                              : index == 1
                                                                  ? "${ratingname[1]}(${_get_staff_details.response.value.ratelist?.good??'0'})"
                                                                  : index == 2
                                                                      ? "${ratingname[2]}(${_get_staff_details.response.value.ratelist?.average??'0'})"
                                                                      : index ==
                                                                              3
                                                                          ? "${ratingname[3]}(${_get_staff_details.response.value.ratelist?.notGood??'0'})"
                                                                          : "${ratingname[4]}(${_get_staff_details.response.value.ratelist?.poor??'0'})",
                                                          style: font_style
                                                              .black_600_14_nounderline,
                                                        )),
                                                    // Spacer(),
                                                    Expanded(
                                                      child: SliderTheme(
                                                        child: Slider(
                                                          value:
                                                              ratingbar[index],
                                                          max: 100,
                                                          min: 0,
                                                          activeColor:
                                                              yellow_col,
                                                          inactiveColor:
                                                              line_cont_col,
                                                          onChanged:
                                                              (double value) {},
                                                        ),
                                                        data: SliderTheme.of(
                                                                context)
                                                            .copyWith(
                                                                trackHeight: 2,
                                                                thumbColor: Colors
                                                                    .transparent,
                                                                thumbShape:
                                                                    const RoundSliderThumbShape(
                                                                        enabledThumbRadius:
                                                                            0.0)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          )),
                                    ),

                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.02,
                                    ),
                                    Text(
                                      "REVIEWS",
                                      style:
                                          font_style.black_600_14_nounderline,
                                    ),
                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.025,
                                    ),

                                    //REVIEWS LISTVIEW
                                    Center(
                                      child: Container(
                                        width: SizeConfig.screenWidth * 0.9,
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          itemCount: _get_staff_details.response
                                                  .value.data?.length ??
                                              0,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              height: SizeConfig.screenHeight *
                                                  0.06,
                                              width:
                                                  SizeConfig.screenWidth * 0.9,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  //IMAGES
                                                  Container(
                                                    height: SizeConfig
                                                            .screenHeight *
                                                        0.07,
                                                    width:
                                                        SizeConfig.screenWidth *
                                                            0.14,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                _get_staff_details
                                                                    .response
                                                                    .value
                                                                    .data![
                                                                        index]
                                                                    .userimage
                                                                    .toString()),
                                                            fit: BoxFit.cover)),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        SizeConfig.screenWidth *
                                                            0.01,
                                                  ),

                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        _get_staff_details
                                                            .response
                                                            .value
                                                            .data![index]
                                                            .username
                                                            .toString(),
                                                        style: font_style
                                                            .black_500_14,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Icon(
                                                            Icons.star_half,
                                                            color: Color(
                                                                0xffF2C94C),
                                                            size: 15,
                                                          ),
                                                          Text(
                                                            _get_staff_details
                                                                .response
                                                                .value
                                                                .data![index]
                                                                .ratings
                                                                .toString(),
                                                            style: font_style
                                                                .black_400_10,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    _get_staff_details
                                                        .response
                                                        .value
                                                        .data![index]
                                                        .createdAt
                                                        .toString()
                                                        .substring(0, 10),
                                                    style:
                                                        font_style.black_400_12,
                                                  ),
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
                                              width:
                                                  SizeConfig.screenWidth * 0.9,
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                )
                        ],
                      )
                    : Container(
                        width: SizeConfig.screenWidth,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            Text(
                              "No Data Found",
                              style: font_style.black_400_12,
                            ),
                          ],
                        ),
                      )),
      );
    });
  }
}
