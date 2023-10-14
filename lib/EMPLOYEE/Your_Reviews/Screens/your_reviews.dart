import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hairgardenemployee/COMMON/common_color.dart';
import 'package:hairgardenemployee/COMMON/common_indicator.dart';
import 'package:hairgardenemployee/COMMON/const.dart';
import 'package:hairgardenemployee/COMMON/size_config.dart';
import 'package:hairgardenemployee/COMMON/font_style.dart';
import 'package:hairgardenemployee/EMPLOYEE/Your_Reviews/controller/review_controller.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class your_reviews extends StatefulWidget {
  const your_reviews({Key? key}) : super(key: key);

  @override
  State<your_reviews> createState() => _your_reviewsState();
}

class _your_reviewsState extends State<your_reviews> {
  double _progressValue = 10.0;
  List ratingname = [
    "Excellent",
    "Good",
    "Average",
    "Not Good",
    "Poor",
  ];
  List ratingbar = <double>[
    70.0,
    30.0,
    30.0,
    30.0,
    30.0,
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

  final reviewController = Get.put(ReviewController());

  getUserData() async {
    reviewController.isLoading(true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString(stored_uid) ?? '';
    reviewController.fetchAllRatingData(id);
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg_col,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: common_color,
              size: 20,
            )),
        title: Text(
          "Your Reviews",
          style: font_style.green_600_20,
        ),
      ),
      body: Obx(() =>
      reviewController.isLoading()
          ? const Center(
        child: commonindicator(),
      )
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            //IMAGE
            Center(
              child: Container(
                height: SizeConfig.screenHeight * 0.12,
                width: SizeConfig.screenWidth * 0.3,
                decoration: BoxDecoration(
                    color: yellow_col,
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                        image: AssetImage("assets/images/rabia_img.png"),
                        fit: BoxFit.cover)),
              ),
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.01,
            ),
            Text(
              reviewController
                  .allRatingModel()
                  .name??"",
              style: font_style.black_600_14,
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.02,
            ),
            Text(
              "AVG. Rating",
              style: font_style.black_400_12,
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.star_half,
                  color: Color(0xffF2C94C),
                ),
                Text(
                  double.parse(reviewController
                      .allRatingModel()
                      .average??"0")
                      .toStringAsFixed(2),
                  style: font_style.black_400_20,
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.01,
            ),
            //EXCELLENT GOOD
            Center(
              child: SizedBox(
                  width: SizeConfig.screenWidth * 0.9,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: SizeConfig.screenWidth * 0.3,
                                child: Text(
                                  'Excellent (${reviewController
                                      .allRatingModel()
                                      .ratelist
                                      ?.excellent})',
                                  style:
                                  font_style.black_600_14_nounderline,
                                )),
                            // Spacer(),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                    trackHeight: 2,
                                    thumbColor: Colors.transparent,
                                    thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 0.0)),
                                child: Slider(
                                  value: double.parse(reviewController
                                      .allRatingModel()
                                      .ratelist
                                      ?.excellent ??
                                      '0'),
                                  max: 100,
                                  min: 0,
                                  activeColor: yellow_col,
                                  inactiveColor: line_cont_col,
                                  onChanged: (double value) {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: SizeConfig.screenWidth * 0.3,
                                child: Text(
                                  'Good (${reviewController
                                      .allRatingModel()
                                      .ratelist
                                      ?.good})',
                                  style:
                                  font_style.black_600_14_nounderline,
                                )),
                            // Spacer(),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                    trackHeight: 2,
                                    thumbColor: Colors.transparent,
                                    thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 0.0)),
                                child: Slider(
                                  value: double.parse(reviewController
                                      .allRatingModel()
                                      .ratelist
                                      ?.good ??
                                      '0'),
                                  max: 100,
                                  min: 0,
                                  activeColor: yellow_col,
                                  inactiveColor: line_cont_col,
                                  onChanged: (double value) {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: SizeConfig.screenWidth * 0.3,
                                child: Text(
                                  'Average (${reviewController
                                      .allRatingModel()
                                      .ratelist
                                      ?.average})',
                                  style:
                                  font_style.black_600_14_nounderline,
                                )),
                            // Spacer(),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                    trackHeight: 2,
                                    thumbColor: Colors.transparent,
                                    thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 0.0)),
                                child: Slider(
                                  value: double.parse(reviewController
                                      .allRatingModel()
                                      .ratelist
                                      ?.average ??
                                      '0'),
                                  max: 100,
                                  min: 0,
                                  activeColor: yellow_col,
                                  inactiveColor: line_cont_col,
                                  onChanged: (double value) {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: SizeConfig.screenWidth * 0.3,
                                child: Text(
                                  'Not Good (${reviewController
                                      .allRatingModel()
                                      .ratelist
                                      ?.notGood})',
                                  style:
                                  font_style.black_600_14_nounderline,
                                )),
                            // Spacer(),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                    trackHeight: 2,
                                    thumbColor: Colors.transparent,
                                    thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 0.0)),
                                child: Slider(
                                  value: double.parse(reviewController
                                      .allRatingModel()
                                      .ratelist
                                      ?.notGood ??
                                      '0'),
                                  max: 100,
                                  min: 0,
                                  activeColor: yellow_col,
                                  inactiveColor: line_cont_col,
                                  onChanged: (double value) {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: SizeConfig.screenWidth * 0.3,
                                child: Text(
                                  'Poor (${reviewController
                                      .allRatingModel()
                                      .ratelist
                                      ?.poor})',
                                  style:
                                  font_style.black_600_14_nounderline,
                                )),
                            // Spacer(),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                    trackHeight: 2,
                                    thumbColor: Colors.transparent,
                                    thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 0.0)),
                                child: Slider(
                                  value: double.parse(reviewController
                                      .allRatingModel()
                                      .ratelist
                                      ?.poor ??
                                      '0'),
                                  max: 100,
                                  min: 0,
                                  activeColor: yellow_col,
                                  inactiveColor: line_cont_col,
                                  onChanged: (double value) {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.02,
            ),
            Text(
              "REVIEWS",
              style: font_style.black_600_14_nounderline,
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.025,
            ),

            //REVIEWS LISTVIEW
            Center(
              child: SizedBox(
                width: SizeConfig.screenWidth * 0.9,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount:
                  reviewController
                      .allRatingModel()
                      .data
                      ?.length ?? 0,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: SizeConfig.screenHeight * 0.06,
                      width: SizeConfig.screenWidth * 0.9,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //IMAGES
                          reviewController
                          .allRatingModel()
                          .data?[index].userimage == null
                          ?Container(
                            height: SizeConfig.screenHeight * 0.07,
                            width: SizeConfig.screenWidth * 0.14,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: AssetImage(
                                        person_photo[index].toString()),
                                    fit: BoxFit.cover)),
                          ):Image.network(reviewController
                              .allRatingModel()
                              .data?[index].userimage,height: SizeConfig.screenHeight * 0.07,
                            width: SizeConfig.screenWidth * 0.14,),
                          SizedBox(
                            width: SizeConfig.screenWidth * 0.01,
                          ),

                          Column(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reviewController
                                    .allRatingModel()
                                    .data?[index]
                                    .username ??
                                    '',
                                style: font_style.black_500_14,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.star_half,
                                    color: Color(0xffF2C94C),
                                    size: 15,
                                  ),
                                  Text(
                                    "${double.parse(reviewController
                                        .allRatingModel()
                                        .data?[index].ratings.toString() ??
                                        "")}",
                                    style: font_style.black_400_10,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            DateFormat.yMMMMd().format(reviewController
                                .allRatingModel()
                                .data?[index].createdAt ?? DateTime.now()),
                            style: font_style.black_400_12,
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      height: 1,
                      color: line_cont_col,
                      width: SizeConfig.screenWidth * 0.9,
                    );
                  },
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
