import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hairgarden/COMMON/common_circular_indicator.dart';
import 'package:hairgarden/COMMON/comontoast.dart';
import 'package:hairgarden/USER/bottombar/Screens/bottombar.dart';
import 'package:hairgarden/USER/category/Controller/add_cart_controller.dart';
import 'package:hairgarden/USER/category/Screens/view_details.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:hairgarden/USER/home/Controller/get_testimonials_controller.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:readmore/readmore.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../COMMON/size_config.dart';
import '../../../COMMON/common_color.dart';
import '../../common/common_cart_cont.dart';
import '../Controller/get_all_cat_products_controller.dart';
import '../Controller/get_cart_controller.dart';
import '../Controller/decrease_cart_controller.dart';
import '../Controller/remove_fromcart_controller.dart';
import '../Controller/view_prod_details_controller.dart';

class all_categories extends StatefulWidget {
  String? cateid;

  all_categories({required this.cateid});

  @override
  State<all_categories> createState() => _all_categoriesState();
}

class _all_categoriesState extends State<all_categories> {
  final _view_det = Get.put(view_prod_details_controller());
  final _get_allprod = Get.put(get_all_cat_products_controller());
  final _add_cart = Get.put(add_cart_controller());
  final _decrease_cart = Get.put(decrease_cart_controller());
  final _get_cart = Get.put(get_cart_controller());
  final _remove_from_cart = Get.put(remove_fromcart_controller());

  List catlist = [
    "Packages",
    "Meni & Pedi",
    "Face",
    "Bridal Makeup",
  ];

  List prod_img = [
    "assets/images/product1_img.png",
    "assets/images/product2_img.png",
    "assets/images/product3_img.png",
    "assets/images/product4_img.png",
    "assets/images/product5_img.png",
  ];

  int prod_price = 1149;

  // String? _get_allprod.uid;

  getuserid() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    _get_allprod.uid(sf.getString("stored_uid"));
    print("USER ID ID ${_get_allprod.uid.toString()}");
  }

  // var indexofid;
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
    });
  }

  compareid() {
    setState(() {
      _get_allprod.indexOfId(_get_allprod.getbiyd.indexOf(widget.cateid));
      print("INDEX IS :$_get_allprod.indexOfId");
    });
  }

  int? selecedindx;

  // int? selected_cat;

  @override
  void initState() {
    getuserid();
    _get_allprod.get_all_cat_products_cont();
    _get_allprod.get_all_cat_products_cont().then((value) async {
      _get_allprod
              .response
              .value
              .data![_get_allprod.getbiyd.indexOf(widget.cateid)]
              .serviceCategoryData!
              .isEmpty
          ? null
          : compareid();
      _get_allprod.indexOfId(_get_allprod.getbiyd.indexOf(widget.cateid));
      _get_allprod.selected_cat(int.parse(_get_allprod
          .response
          .value
          .data![_get_allprod.getbiyd.indexOf(widget.cateid)]
          .serviceCategoryData![0]
          .subcatId
          .toString()));
      initPlatformState().then((value) {
        _get_cart.get_cart_cont(
            _get_allprod.uid.toString() == "" || _get_allprod.uid == null
                ? ""
                : _get_allprod.uid.toString(),
            _deviceId.toString());
      });
    });
    if (_get_allprod.getbiyd.isNotEmpty) {
      _get_allprod.selected_cat(int.parse(_get_allprod
          .response
          .value
          .data![_get_allprod.getbiyd.indexOf(widget.cateid)]
          .serviceCategoryData![0]
          .subcatId
          .toString()));
    }

    super.initState();
  }

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final _get_testimonials = Get.put(get_testimonials_controller());
  List<YoutubePlayerController> lYTC = [];

  Map<String, dynamic> cStates = {};

  fillYTlists() {
    for (var element in _get_testimonials.yturl) {
      String _id = YoutubePlayer.convertUrlToId(element)!;
      YoutubePlayerController _ytController = YoutubePlayerController(
        initialVideoId: _id,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          enableCaption: true,
          captionLanguage: 'en',
          disableDragSeek: true,
        ),
      );

      _ytController.addListener(() {
        print('for $_id got isPlaying state ${_ytController.value.isPlaying}');
        if (cStates[_id] != _ytController.value.isPlaying) {
          if (mounted) {
            setState(() {
              cStates[_id] = _ytController.value.isPlaying;
            });
          }
        }
      });

      lYTC.add(_ytController);
    }
  }

  @override
  Widget build(BuildContext context) {
    // int selected_cat=int.parse(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![0].subcatId.toString());

    return WillPopScope(
      onWillPop: () async {
        // _get_testimonials.get_testimonials_cont(_get_allprod.uid);
        // fillYTlists();
        Get.off(const BottomBar(pasindx: 0));
        return false;
      },
      child: Obx(() {
        return Scaffold(
          backgroundColor: bg_col,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            leading: InkWell(
                onTap: () {
                  // fillYTlists();
                  Get.off(const BottomBar(pasindx: 0));
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: common_color,
                  size: 20,
                )),
            title: _get_allprod.loading.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.transparent,
                    ),
                  )
                : InkWell(
                    onTap: () {
                      setState(() {
                        initPlatformState();
                      });
                    },
                    child: Text(
                      _get_allprod
                          .response
                          .value
                          .data![_get_allprod.getbiyd.indexOf(widget.cateid)]
                          .name
                          .toString(),
                      style: font_style.green_600_20,
                    )),
            actions: [_get_cart.loading.value ? Container() : Container()],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(SizeConfig.screenHeight * 0.06),
              child: Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.screenWidth * 0.05,
                    bottom: SizeConfig.screenHeight * 0.015),
                child: _get_allprod.loading.value
                    ? SizedBox(
                        height: SizeConfig.screenHeight * 0.04,
                        width: SizeConfig.screenWidth,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 4,
                          itemBuilder: (context, catindex) {
                            return Shimmer.fromColors(
                              baseColor: common_color.withOpacity(0.5),
                              highlightColor: Colors.white12.withOpacity(0.9),
                              child: Container(
                                width: SizeConfig.screenWidth * 0.18,
                                alignment: Alignment.center,
                                height: SizeConfig.screenHeight * 0.04,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: common_color),
                                    borderRadius: BorderRadius.circular(50)),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              width: SizeConfig.screenWidth * 0.03,
                            );
                          },
                        ),
                      )
                    : _get_allprod.maincat.isEmpty
                        ? SizedBox(
                            height: SizeConfig.screenHeight * 0.04,
                            width: SizeConfig.screenWidth,
                            child: const Center(
                              child: Text("No Subcategory found"),
                            ))
                        : SizedBox(
                            height: SizeConfig.screenHeight * 0.04,
                            width: SizeConfig.screenWidth,
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: _get_allprod
                                  .response
                                  .value
                                  .data![_get_allprod.getbiyd
                                      .indexOf(widget.cateid)]
                                  .serviceCategoryData!
                                  .length,
                              itemBuilder: (context, catindex) {
                                return InkWell(
                                  onTap: () {
                                    // cart.clear();
                                    setState(() {
                                      if (_get_allprod
                                          .response
                                          .value
                                          .data![_get_allprod.getbiyd
                                              .indexOf(widget.cateid)]
                                          .serviceCategoryData![catindex]
                                          .subcateProduct!
                                          .isEmpty) {
                                      } else {
                                        setState(() {
                                          _get_allprod.selected_cat(int.parse(
                                              _get_allprod
                                                  .response
                                                  .value
                                                  .data![_get_allprod.getbiyd
                                                      .indexOf(widget.cateid)]
                                                  .serviceCategoryData![
                                                      catindex]
                                                  .subcatId
                                                  .toString()));
                                        });
                                      }
                                    });
                                    itemScrollController.scrollTo(
                                        index: catindex,
                                        duration:
                                            const Duration(milliseconds: 800),
                                        curve: Curves.easeInOutCubic);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    alignment: Alignment.center,
                                    height: SizeConfig.screenHeight * 0.04,
                                    decoration: BoxDecoration(
                                        color: _get_allprod
                                                    .selected_cat.value ==
                                                int.parse(_get_allprod
                                                    .response
                                                    .value
                                                    .data![_get_allprod.getbiyd
                                                        .indexOf(widget.cateid)]
                                                    .serviceCategoryData![
                                                        catindex]
                                                    .subcatId
                                                    .toString())
                                            ? common_color
                                            : Colors.transparent,
                                        border: Border.all(
                                            color: _get_allprod
                                                    .response
                                                    .value
                                                    .data![_get_allprod.getbiyd.indexOf(widget.cateid)]
                                                    .serviceCategoryData![catindex]
                                                    .subcateProduct!
                                                    .isEmpty
                                                ? Colors.transparent
                                                : common_color),
                                        borderRadius: BorderRadius.circular(50)),
                                    child: Text(
                                      _get_allprod
                                          .response
                                          .value
                                          .data![_get_allprod.getbiyd
                                              .indexOf(widget.cateid)]
                                          .serviceCategoryData![catindex]
                                          .subcatName
                                          .toString(),
                                      style: _get_allprod.selected_cat.value ==
                                                  int.parse(_get_allprod
                                                      .response
                                                      .value
                                                      .data![_get_allprod
                                                          .getbiyd
                                                          .indexOf(
                                                              widget.cateid)]
                                                      .serviceCategoryData![
                                                          catindex]
                                                      .subcatId
                                                      .toString()) &&
                                              _get_allprod
                                                  .response
                                                  .value
                                                  .data![_get_allprod.getbiyd
                                                      .indexOf(widget.cateid)]
                                                  .serviceCategoryData![
                                                      catindex]
                                                  .subcateProduct!
                                                  .isNotEmpty
                                          ? font_style.white_400_14
                                          : _get_allprod
                                                  .response
                                                  .value
                                                  .data![_get_allprod.getbiyd.indexOf(widget.cateid)]
                                                  .serviceCategoryData![catindex]
                                                  .subcateProduct!
                                                  .isEmpty
                                              ? const TextStyle(color: Colors.transparent)
                                              : font_style.black_400_14,
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  width: SizeConfig.screenWidth * 0.03,
                                );
                              },
                            ),
                          ),
              ),
            ),
          ),
          body: _get_allprod.loading.value
              ? const CommonIndicator()
              : _get_allprod
                      .response
                      .value
                      .data![_get_allprod.getbiyd.indexOf(widget.cateid)]
                      .serviceCategoryData!
                      .isEmpty
                  ? const Center(
                      child: Text("No Products found"),
                    )
                  : SizedBox(
                      width: SizeConfig.screenWidth,
                      height: _get_cart.response.value.data?.isEmpty ?? false
                          ? SizeConfig.screenHeight
                          : SizeConfig.screenHeight * 0.8,
                      child: ScrollablePositionedList.separated(
                        addAutomaticKeepAlives: true,
                        shrinkWrap: true,
                        itemCount: _get_allprod
                            .response
                            .value
                            .data![_get_allprod.getbiyd.indexOf(widget.cateid)]
                            .serviceCategoryData!
                            .length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, scrollindex) {
                          return _get_allprod
                                  .response
                                  .value
                                  .data![_get_allprod.getbiyd
                                      .indexOf(widget.cateid)]
                                  .serviceCategoryData![scrollindex]
                                  .subcateProduct!
                                  .isEmpty
                              ? const Center(
                                  child: Text(""),
                                )
                              : Column(
                                  children: [
                                    Container(
                                      height: SizeConfig.screenHeight * 0.175,
                                      width: SizeConfig.screenWidth * 0.9,
                                      margin: const EdgeInsets.only(bottom: 15),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(_get_allprod
                                                .response
                                                .value
                                                .data![_get_allprod.getbiyd
                                                    .indexOf(widget.cateid)]
                                                .serviceCategoryData![
                                                    scrollindex]
                                                .subcateImage
                                                .toString()),
                                          )),
                                    ),
                                    ListView.separated(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: _get_allprod
                                          .response
                                          .value
                                          .data![_get_allprod.getbiyd
                                              .indexOf(widget.cateid)]
                                          .serviceCategoryData![scrollindex]
                                          .subcateProduct!
                                          .length,
                                      itemBuilder: (context, prodindex) {
                                        return Center(
                                          child: Obx(() {
                                            return SizedBox(
                                              width:
                                                  SizeConfig.screenWidth * 0.9,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  //IMAGE
                                                  InkWell(
                                                    onTap: () {
                                                      print(_get_allprod
                                                          .response
                                                          .value
                                                          .data![_get_allprod
                                                              .getbiyd
                                                              .indexOf(widget
                                                                  .cateid)]
                                                          .serviceCategoryData![
                                                              scrollindex]
                                                          .subcateProduct![
                                                              prodindex]
                                                          .id
                                                          .toString());
                                                      print(prodindex + 1);
                                                    },
                                                    child: Container(
                                                      height: SizeConfig
                                                              .screenHeight *
                                                          0.11,
                                                      width: SizeConfig
                                                              .screenWidth *
                                                          0.4,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          image:
                                                              DecorationImage(
                                                                  image:
                                                                      // AssetImage("assets/images/product2_img.png"),
                                                                      NetworkImage(_get_allprod
                                                                          .response
                                                                          .value
                                                                          .data![_get_allprod.getbiyd.indexOf(widget
                                                                              .cateid)]
                                                                          .serviceCategoryData![
                                                                              scrollindex]
                                                                          .subcateProduct![
                                                                              prodindex]
                                                                          .image
                                                                          .toString()),
                                                                  fit: BoxFit
                                                                      .fill)),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        SizeConfig.screenWidth *
                                                            0.02,
                                                  ),

                                                  //DETAILS
                                                  SizedBox(
                                                    width:
                                                        SizeConfig.screenWidth *
                                                            0.48,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          _get_allprod
                                                              .response
                                                              .value
                                                              .data![_get_allprod
                                                                  .getbiyd
                                                                  .indexOf(widget
                                                                      .cateid)]
                                                              .serviceCategoryData![
                                                                  scrollindex]
                                                              .subcateProduct![
                                                                  prodindex]
                                                              .title
                                                              .toString(),
                                                          style: font_style
                                                              .black_500_15,
                                                        ),
                                                        //Rs. DISCOUNT
                                                        SizedBox(
                                                          height: SizeConfig
                                                                  .screenHeight *
                                                              0.005,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "₹${_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].sellPrice.toString()}",
                                                              style: font_style
                                                                  .yell_400_14,
                                                            ),
                                                            SizedBox(
                                                              width: SizeConfig
                                                                      .screenWidth *
                                                                  0.02,
                                                            ),
                                                            Text(
                                                              _get_allprod
                                                                  .response
                                                                  .value
                                                                  .data![_get_allprod
                                                                      .getbiyd
                                                                      .indexOf(
                                                                          widget
                                                                              .cateid)]
                                                                  .serviceCategoryData![
                                                                      scrollindex]
                                                                  .subcateProduct![
                                                                      prodindex]
                                                                  .price
                                                                  .toString(),
                                                              style: font_style
                                                                  .greyA1A1AA_400_14,
                                                            ),
                                                            const Spacer(),
                                                            Text(
                                                              "${_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].percent.toString()}% OFF",
                                                              style: font_style
                                                                  .black_400_14,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: SizeConfig
                                                                  .screenHeight *
                                                              0.01,
                                                        ),
                                                        ReadMoreText(
                                                          _get_allprod
                                                              .response
                                                              .value
                                                              .data![_get_allprod
                                                                  .getbiyd
                                                                  .indexOf(widget
                                                                      .cateid)]
                                                              .serviceCategoryData![
                                                                  scrollindex]
                                                              .subcateProduct![
                                                                  prodindex]
                                                              .description
                                                              .toString(),
                                                          trimLines: 2,
                                                          colorClickableText:
                                                              yellow_col,
                                                          trimMode:
                                                              TrimMode.Line,
                                                          lessStyle: font_style
                                                              .yellow_600_10,
                                                          trimCollapsedText:
                                                              'Show more',
                                                          trimExpandedText:
                                                              ' Show less',
                                                          style: font_style
                                                              .black_400_14,
                                                          moreStyle: font_style
                                                              .yellow_600_10,
                                                        ),
                                                        // Text(,style: font_style.black_400_10,textAlign: TextAlign.justify,),
                                                        // Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum hLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum h",style: font_style.black_400_10,textAlign: TextAlign.justify,),

                                                        SizedBox(
                                                          height: SizeConfig
                                                                  .screenHeight *
                                                              0.01,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            //VIEW DETAILS
                                                            InkWell(
                                                                onTap: () {
                                                                  _view_det.view_prod_details_cont(_get_allprod
                                                                      .response
                                                                      .value
                                                                      .data![_get_allprod
                                                                          .getbiyd
                                                                          .indexOf(widget
                                                                              .cateid)]
                                                                      .serviceCategoryData![
                                                                          scrollindex]
                                                                      .subcateProduct![
                                                                          prodindex]
                                                                      .id
                                                                      .toString());

                                                                  Get.to(
                                                                      const view_details());
                                                                },
                                                                child: Text(
                                                                  "View Details ",
                                                                  style: font_style
                                                                      .green_400_14,
                                                                )),

                                                            selecedindx ==
                                                                    _get_allprod.allproductid.indexOf(_get_allprod
                                                                        .response
                                                                        .value
                                                                        .data![_get_allprod
                                                                            .getbiyd
                                                                            .indexOf(widget
                                                                                .cateid)]
                                                                        .serviceCategoryData![
                                                                            scrollindex]
                                                                        .subcateProduct![
                                                                            prodindex]
                                                                        .id
                                                                        .toString())
                                                                ? Container(
                                                                    width: SizeConfig
                                                                            .screenWidth *
                                                                        0.18,
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            8,
                                                                        horizontal:
                                                                            5),
                                                                    decoration: BoxDecoration(
                                                                        color:
                                                                            yellow_col,
                                                                        borderRadius:
                                                                            BorderRadius.circular(44)),
                                                                    child:
                                                                        const CupertinoActivityIndicator(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  )
                                                                : _get_cart.prodid.contains(_get_allprod
                                                                        .response
                                                                        .value
                                                                        .data![_get_allprod
                                                                            .getbiyd
                                                                            .indexOf(widget
                                                                                .cateid)]
                                                                        .serviceCategoryData![
                                                                            scrollindex]
                                                                        .subcateProduct![
                                                                            prodindex]
                                                                        .id
                                                                        .toString())
                                                                    ?

                                                                    //ADD REMOVE ROW
                                                                    Container(
                                                                        width: SizeConfig.screenWidth *
                                                                            0.18,
                                                                        padding: const EdgeInsets.symmetric(
                                                                            vertical:
                                                                                8,
                                                                            horizontal:
                                                                                5),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                yellow_col,
                                                                            borderRadius:
                                                                                BorderRadius.circular(44)),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceAround,
                                                                          children: [
                                                                            //SUBTRACT
                                                                            Flexible(
                                                                              child: InkWell(
                                                                                  onTap: () {
                                                                                    print(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString());
                                                                                    // print(_deviceId.toString());
                                                                                    setState(() {
                                                                                      selecedindx = _get_allprod.allproductid.indexOf(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString());
                                                                                      // _get_allprod.loadinglist[_get_allprod.allproductid.indexOf(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())] = true;
                                                                                    });
                                                                                    setState(() {
                                                                                      if (_get_cart.response.value.data![_get_cart.prodid.indexOf(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())].qty.toString() == '1') {
                                                                                        _remove_from_cart
                                                                                            .remove_fromcart_cont(
                                                                                                // _get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString(),
                                                                                                _get_allprod.uid.toString() == "" ? "" : _get_allprod.uid.toString(),
                                                                                                _deviceId.toString(),
                                                                                                _get_cart.response.value.data![_get_cart.prodid.indexOf(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())].id.toString())
                                                                                            .then((value) {
                                                                                          setState(() {
                                                                                            selecedindx = null;
                                                                                            if (_get_cart.prodid.length == 1) {
                                                                                              _get_cart.prodid.clear();
                                                                                            }
                                                                                            _get_cart.get_cart_cont(_get_allprod.uid.toString() == "" || _get_allprod.uid == null ? "" : _get_allprod.uid.toString(), _deviceId.toString());

                                                                                            // _get_allprod.loadinglist[_get_allprod.allproductid.indexOf(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())] = false;
                                                                                          });
                                                                                        });
                                                                                      } else {
                                                                                        setState(() {
                                                                                          initPlatformState();
                                                                                          _decrease_cart.decrease_cart_cont(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString(), _get_allprod.uid.toString() == "" || _get_allprod.uid == null ? "" : _get_allprod.uid.toString(), _deviceId.toString(), "${int.parse(_get_cart.response.value.data![_get_cart.prodid.indexOf(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())].qty.toString()) - 1}").then((value) {
                                                                                            setState(() {
                                                                                              selecedindx = null;
                                                                                              _get_cart.get_cart_cont(_get_allprod.uid.toString() == "" || _get_allprod.uid == null ? "" : _get_allprod.uid.toString(), _deviceId.toString());
                                                                                              // _get_allprod.loadinglist[_get_allprod.allproductid.indexOf(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())] = false;
                                                                                            });
                                                                                          });
                                                                                        });
                                                                                      }
                                                                                    });
                                                                                  },
                                                                                  child: const Icon(
                                                                                    Icons.remove,
                                                                                    color: Colors.white,
                                                                                    size: 16,
                                                                                  )),
                                                                            ),

                                                                            //TOTAL
                                                                            Text(
                                                                              _get_cart.response.value.data?[_get_cart.prodid.indexOf(_get_allprod.response.value.data?[_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())].qty.toString() ?? '',
                                                                              style: font_style.white_400_10,
                                                                            ),

                                                                            //ADD
                                                                            Flexible(
                                                                              child: InkWell(
                                                                                  onTap: () {
                                                                                    print(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString());
                                                                                    print("${int.parse(_get_cart.response.value.data![_get_cart.prodid.indexOf(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())].qty.toString()) + 1}");
                                                                                    setState(() {
                                                                                      selecedindx = _get_allprod.allproductid.indexOf(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString());
                                                                                      // _get_allprod.loadinglist[_get_allprod.allproductid.indexOf(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())] = true;
                                                                                    });
                                                                                    initPlatformState();
                                                                                    _decrease_cart.decrease_cart_cont(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString(), _get_allprod.uid.toString() == "" || _get_allprod.uid == null ? "" : _get_allprod.uid.toString(), _deviceId.toString(), "${int.parse(_get_cart.response.value.data![_get_cart.prodid.indexOf(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())].qty.toString()) + 1}").then((value) {
                                                                                      setState(() {
                                                                                        selecedindx = null;
                                                                                        _get_cart.get_cart_cont(_get_allprod.uid.toString() == "" || _get_allprod.uid == null ? "" : _get_allprod.uid.toString(), _deviceId.toString());
                                                                                        // _get_allprod.loadinglist[_get_allprod.allproductid.indexOf(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())] = false;
                                                                                      });
                                                                                    });
                                                                                  },
                                                                                  child: const Icon(
                                                                                    Icons.add,
                                                                                    color: Colors.white,
                                                                                    size: 16,
                                                                                  )),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    :

                                                                    //ADD BUTTON:
                                                                    InkWell(
                                                                        onTap:
                                                                            () {
                                                                          List
                                                                              getcartcatid =
                                                                              [];

                                                                          _get_cart
                                                                              .prodid
                                                                              .forEach((element) {
                                                                            getcartcatid.add(_get_allprod.allproductcatid[_get_allprod.checkprodid.indexOf(element)]);
                                                                          });

                                                                          initPlatformState();
                                                                          log('Vijay====${getcartcatid.contains(widget.cateid.toString())}');
                                                                          log('Vijay TWO====${_get_cart.response.value.status}');
                                                                          setState(() {
                                                                            selecedindx = _get_allprod.allproductid.indexOf(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString());
                                                                            // _get_allprod.loadinglist[_get_allprod.allproductid.indexOf(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())] = true;
                                                                          });
                                                                          _add_cart.add_cart_cont(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString(), "1", _get_allprod.uid.toString() == "" || _get_allprod.uid == null ? "" : _get_allprod.uid.toString(), _deviceId.toString(), "service").then((value) {
                                                                            setState(() {
                                                                              selecedindx = null;
                                                                              _get_cart.get_cart_cont(_get_allprod.uid.toString() == "" || _get_allprod.uid == null ? "" : _get_allprod.uid.toString(), _deviceId.toString());
                                                                            });
                                                                          });
                                                                          // if ((_get_cart.response.value.status == false) ||
                                                                          //     getcartcatid.contains(widget.cateid.toString())) {
                                                                          //   setState(() {
                                                                          //     selecedindx = _get_allprod.allproductid.indexOf(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString());
                                                                          //     // _get_allprod.loadinglist[_get_allprod.allproductid.indexOf(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())] = true;
                                                                          //   });
                                                                          //   _add_cart.add_cart_cont(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString(), "1", _get_allprod.uid.toString() == "" || _get_allprod.uid == null ? "" : _get_allprod.uid.toString(), _deviceId.toString(), "service").then((value) {
                                                                          //     setState(() {
                                                                          //       selecedindx = null;
                                                                          //       _get_cart.get_cart_cont(_get_allprod.uid.toString() == "" || _get_allprod.uid == null ? "" : _get_allprod.uid.toString(), _deviceId.toString());
                                                                          //     });
                                                                          //   });
                                                                          // } else {
                                                                          //   commontoas("You can't add other categories services");
                                                                          // }
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          width:
                                                                              SizeConfig.screenWidth * 0.18,
                                                                          padding:
                                                                              const EdgeInsets.symmetric(vertical: 8),
                                                                          decoration: BoxDecoration(
                                                                              color: yellow_col,
                                                                              borderRadius: BorderRadius.circular(44)),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                "ADD",
                                                                                style: font_style.white_400_10,
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              const Icon(
                                                                                Icons.add,
                                                                                color: Colors.white,
                                                                                size: 15,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          }),
                                        ) /*: null*/;
                                      },
                                      separatorBuilder: (context, prodindex) {
                                        return Container(
                                          height: 1,
                                          width: SizeConfig.screenWidth,
                                          color: line_cont_col,
                                          margin: EdgeInsets.symmetric(
                                              vertical:
                                                  SizeConfig.screenHeight *
                                                      0.01),
                                        );
                                      },
                                    ),
                                  ],
                                );
                        },
                        separatorBuilder: (context, scrollindex) {
                          return Container(
                            height: 1,
                            width: SizeConfig.screenWidth,
                            color: line_cont_col,
                            margin: EdgeInsets.symmetric(
                                vertical: SizeConfig.screenHeight * 0.01),
                          );
                        },
                        itemScrollController: itemScrollController,
                        itemPositionsListener: itemPositionsListener,
                      ),
                    ),
          bottomNavigationBar:

              // _get_cart.loading.value ? commonindicator() :

              Obx(() => _get_cart.loading.value
                  ? CommonIndicator(color: common_color)
                  : (_get_cart.response.value.status ?? false)
                      ? common_cart_cont(
                          uid: _get_allprod.uid.value,
                          deviceId: _deviceId,
                          indexofid: _get_allprod.getbiyd
                              .indexOf(widget.cateid)
                              .toString(),
                          selected_cat: _get_allprod.selected_cat().toString(),
                          pagename: "allcat",
                          getslotid: "",
                          getbookdate: "",
                          getaddressid: "",
                          getstaffid: "",
                          getstafftype: "")
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(),
                          ],
                        )),
        );
      }),
    );
  }
}
