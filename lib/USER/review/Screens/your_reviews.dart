import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:hairgarden/COMMON/comontoast.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../COMMON/common_circular_indicator.dart';
import '../../../COMMON/common_color.dart';
import '../../../COMMON/size_config.dart';
import '../../book_slot Payment/Controller/get_staff_details_controller.dart';
import '../Controller/give_rating_controller.dart';

class your_reviews extends StatefulWidget {
  String? staffid, frompage;

  your_reviews({required this.staffid, required this.frompage});

  @override
  State<your_reviews> createState() => _your_reviewsState();
}

class _your_reviewsState extends State<your_reviews> {
  final _get_staff_details = Get.put(get_staffs_details_controller());
  final _give_rating = Get.put(give_rating_controller());

  double _progressValue = 10.0;

  List ratingname = [
    "Excellent",
    "Good",
    "Average",
    "Not Good",
    "Poor",
  ];

  var uid;
  getuserid() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    setState(() {
      uid = sf.getString("stored_uid");
    });
  }

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

  bool pending_rev = false;
  late double _rating;
  double _initialRating = 0.0;
  bool _isRTLMode = false;
  bool _isVertical = false;
  IconData? _selectedIcon;
  TextEditingController comment = TextEditingController();
  List myrevindx = [];
  List ratingbar = [];
  getmyreview() {
    print(_get_staff_details.myreviewimg);
    print(_get_staff_details.myreviewdesc);
  }

  @override
  void initState() {
    getuserid();
    getmyreview();
    if(_get_staff_details.response.value.status==true)
      {
        int totrating = int.parse(
            _get_staff_details.response.value.ratelist?.excellent ??
                ''.toString()) +
            int.parse(_get_staff_details.response.value.ratelist!.good.toString()) +
            int.parse(
                _get_staff_details.response.value.ratelist!.average.toString()) +
            int.parse(
                _get_staff_details.response.value.ratelist!.notGood.toString()) +
            int.parse(_get_staff_details.response.value.ratelist!.poor.toString());
        ratingbar = <double>[
          (int.parse(_get_staff_details.response.value.ratelist!.excellent
              .toString()) *
              100) /
              totrating,
          (int.parse(_get_staff_details.response.value.ratelist!.good.toString()) *
              100) /
              totrating,
          (int.parse(_get_staff_details.response.value.ratelist!.average
              .toString()) *
              100) /
              totrating,
          (int.parse(_get_staff_details.response.value.ratelist!.notGood
              .toString()) *
              100) /
              totrating,
          (int.parse(_get_staff_details.response.value.ratelist!.poor.toString()) *
              100) /
              totrating,
        ];
      }

    super.initState();
  }

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
            "Your Reviews",
            style: font_style.green_600_20,
          ),
        ),
        body: _get_staff_details.loading.value
            ? const CommonIndicator()
            : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: _get_staff_details.response.value.status == false
                        ? SizedBox(
                          height: SizeConfig.screenHeight*0.9,
                          child: Center(
                              child: Text(
                                "No Reviews Found",
                                style: font_style.black_400_16,
                              ),
                            ),
                        )
                        : Column(
                            children: [
                              //IMAGE
                              Center(
                                child: Container(
                                  height: SizeConfig.screenHeight * 0.12,
                                  width: SizeConfig.screenWidth * 0.3,
                                  decoration: BoxDecoration(
                                      color: yellow_col,
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: AssetImage(_get_staff_details
                                              .response.value.profile
                                              .toString()),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.screenHeight * 0.01,
                              ),
                              Text(
                                _get_staff_details.response.value.name
                                    .toString(),
                                style: font_style.black_600_14,
                              ),
                              SizedBox(
                                height: SizeConfig.screenHeight * 0.02,
                              ),

                              Column(
                                children: [
                                  Text(
                                    "Rating",
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
                                        _get_staff_details
                                            .response.value.average
                                            .toString(),
                                        style: font_style.black_400_20,
                                      ),
                                      Text(
                                        " (${_get_staff_details.response.value.data!.length.toString()})",
                                        style:
                                            font_style.greyA1A1AA_400_12_simple,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: SizeConfig.screenHeight * 0.01,
                                  ),

                                  //EXCELLENT GOOD
                                  Center(
                                    child: SizedBox(
                                        width: SizeConfig.screenWidth * 0.9,
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount: ratingname.length,
                                          itemBuilder: (context, index) {
                                            return SizedBox(
                                              height: SizeConfig.screenHeight *
                                                  0.035,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                      width: SizeConfig
                                                              .screenWidth *
                                                          0.3,
                                                      child: Text(
                                                        index == 0
                                                            ? "${ratingname[0]}(${_get_staff_details.response.value.ratelist!.excellent.toString()})"
                                                            : index == 1
                                                                ? "${ratingname[1]}(${_get_staff_details.response.value.ratelist!.good.toString()})"
                                                                : index == 2
                                                                    ? "${ratingname[2]}(${_get_staff_details.response.value.ratelist!.average.toString()})"
                                                                    : index == 3
                                                                        ? "${ratingname[3]}(${_get_staff_details.response.value.ratelist!.notGood.toString()})"
                                                                        : "${ratingname[4]}(${_get_staff_details.response.value.ratelist!.poor.toString()})",
                                                        style: font_style
                                                            .black_600_14_nounderline,
                                                      )),
                                                  // Spacer(),
                                                  Expanded(
                                                    child: SliderTheme(
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
                                                      child: Slider(
                                                        value: ratingbar[index],
                                                        max: 100,
                                                        min: 0,
                                                        activeColor: yellow_col,
                                                        inactiveColor:
                                                            line_cont_col,
                                                        onChanged:
                                                            (double value) {},
                                                      ),
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
                                ],
                              ),

                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (pending_rev == false) {
                                        pending_rev = true;
                                      } else {
                                        pending_rev = false;
                                      }
                                    });
                                  },
                                  child: Text(
                                    "REVIEWS",
                                    style: font_style.black_600_14_nounderline,
                                  )),
                              SizedBox(
                                height: SizeConfig.screenHeight * 0.025,
                              ),

                              //REVIEWS LISTVIEW
                              // pending_rev==false?
                              widget.frompage == "upcoming"
                                  ? Center(
                                      child: SizedBox(
                                        width: SizeConfig.screenWidth * 0.9,
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          itemCount: _get_staff_details
                                              .response.value.data!.length,
                                          itemBuilder: (context, index) {
                                            return SizedBox(
                                              width:
                                                  SizeConfig.screenWidth * 0.9,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  //IMAGES
                                                  Container(
                                                    height: SizeConfig
                                                            .screenHeight *
                                                        0.05,
                                                    width:
                                                        SizeConfig.screenWidth *
                                                            0.1,
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
                                                      SizedBox(
                                                          width: SizeConfig
                                                                  .screenWidth *
                                                              0.5,
                                                          child: Text(
                                                            "She’ very sensible in doing her work, much appreciated",
                                                            style: font_style
                                                                .black_400_12,
                                                          )),
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    _get_staff_details
                                                        .response
                                                        .value
                                                        .data![index]
                                                        .createdAt
                                                        .toString(),
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
                                  : widget.frompage == "order" &&
                                          _get_staff_details
                                              .myreviewname.isEmpty
                                      ? Center(
                                          child: SizedBox(
                                            width: SizeConfig.screenWidth * 0.9,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "You haven’t Wrote a Review Yet, Kindly Write One",
                                                  style: font_style
                                                      .black_600_14_nounderline,
                                                ),
                                                SizedBox(
                                                  height:
                                                      SizeConfig.screenHeight *
                                                          0.01,
                                                ),
                                                Text(
                                                  "This help us Improve for you",
                                                  style: font_style
                                                      .greyA1A1AA_400_12,
                                                ),
                                                SizedBox(
                                                  height:
                                                      SizeConfig.screenHeight *
                                                          0.02,
                                                ),

                                                //RATING BAR
                                                Center(
                                                  child: RatingBar.builder(
                                                    initialRating:
                                                        _initialRating,
                                                    minRating: 1,
                                                    direction: _isVertical
                                                        ? Axis.vertical
                                                        : Axis.horizontal,
                                                    allowHalfRating: true,
                                                    unratedColor: yellow_col
                                                        .withOpacity(0.5),
                                                    itemCount: 5,
                                                    glow: false,
                                                    itemSize: SizeConfig
                                                            .screenHeight *
                                                        0.028,
                                                    itemPadding:
                                                        const EdgeInsets.symmetric(
                                                            horizontal: 4.0),
                                                    itemBuilder: (context, _) =>
                                                        Icon(
                                                      _selectedIcon ??
                                                          Icons.star,
                                                      color: yellow_col,
                                                    ),
                                                    onRatingUpdate: (rating) {
                                                      setState(() {
                                                        _rating = rating;
                                                      });
                                                      print(_rating);
                                                    },
                                                    updateOnDrag: true,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height:
                                                      SizeConfig.screenHeight *
                                                          0.025,
                                                ),

                                                Text(
                                                  "Write a Comment",
                                                  style: font_style
                                                      .gr27272A_600_14,
                                                ),
                                                SizedBox(
                                                  height:
                                                      SizeConfig.screenHeight *
                                                          0.013,
                                                ),

                                                //REMIND ME LATER
                                                Center(
                                                  child: SizedBox(
                                                    width:
                                                        SizeConfig.screenWidth *
                                                            0.9,
                                                    child: TextFormField(
                                                      controller: comment,
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                      maxLines: 4,
                                                      style: font_style
                                                          .greyA1A1AA_400_16,
                                                      decoration:
                                                          InputDecoration(
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            yellow_col),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            yellow_col),
                                                              ),
                                                              hintText:
                                                                  "What did you like the most?",
                                                              hintStyle: font_style
                                                                  .greyA1A1AA_400_16,
                                                              contentPadding:
                                                                  const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          6,
                                                                      vertical:
                                                                          6)),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height:
                                                      SizeConfig.screenHeight *
                                                          0.02,
                                                ),
                                                //SUBMIT
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: SizeConfig
                                                                  .screenHeight *
                                                              0.012),
                                                      width: SizeConfig
                                                              .screenWidth *
                                                          0.43,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: yellow_col),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Text(
                                                        "Remind me Later",
                                                        style: font_style
                                                            .yellow_600_14,
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        if (comment.text ==
                                                            "") {
                                                          commontoas(
                                                              "Please write your review");
                                                        }
                                                        _give_rating
                                                            .give_rating_cont(
                                                                widget.staffid,
                                                                uid,
                                                                _rating
                                                                    .toString(),
                                                                comment.text);
                                                      },
                                                      child: Obx(() {
                                                        return Container(
                                                          alignment:
                                                              Alignment.center,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      SizeConfig
                                                                              .screenHeight *
                                                                          0.012),
                                                          width: SizeConfig
                                                                  .screenWidth *
                                                              0.43,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: yellow_col,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: _give_rating
                                                                  .loading.value
                                                              ? const CupertinoActivityIndicator(
                                                                  color: Colors
                                                                      .white,
                                                                )
                                                              : Text(
                                                                  "Submit",
                                                                  style: font_style
                                                                      .white_600_14,
                                                                ),
                                                        );
                                                      }),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : Center(
                                          child: SizedBox(
                                            width: SizeConfig.screenWidth * 0.9,
                                            child: ListView.separated(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              itemCount: _get_staff_details
                                                  .myreviewname.length,
                                              itemBuilder: (context, index) {
                                                return SizedBox(
                                                  width:
                                                      SizeConfig.screenWidth *
                                                          0.9,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      //IMAGES
                                                      Container(
                                                        height: SizeConfig
                                                                .screenHeight *
                                                            0.05,
                                                        width: SizeConfig
                                                                .screenWidth *
                                                            0.1,
                                                        decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                    _get_staff_details
                                                                        .myreviewimg[
                                                                            index]
                                                                        .toString()),
                                                                fit: BoxFit
                                                                    .cover)),
                                                      ),
                                                      SizedBox(
                                                        width: SizeConfig
                                                                .screenWidth *
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
                                                                .myreviewname[
                                                                    index]
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
                                                                    .myreviewdesc[
                                                                        index]
                                                                    .toString(),
                                                                style: font_style
                                                                    .black_400_10,
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                              width: SizeConfig
                                                                      .screenWidth *
                                                                  0.5,
                                                              child: Text(
                                                                "She’ very sensible in doing her work, much appreciated",
                                                                style: font_style
                                                                    .black_400_12,
                                                              )),
                                                        ],
                                                      ),
                                                      const Spacer(),
                                                      Text(
                                                        _get_staff_details
                                                            .myreviewdate[index]
                                                            .toString(),
                                                        style: font_style
                                                            .black_400_12,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) {
                                                return Container(
                                                  margin: const EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  height: 1,
                                                  color: line_cont_col,
                                                  width:
                                                      SizeConfig.screenWidth *
                                                          0.9,
                                                );
                                              },
                                            ),
                                          ),
                                        )
                            ],
                          ),
                  ),
      );
    });
  }
}
