import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hairgarden/COMMON/common_circular_indicator.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../COMMON/common_color.dart';
import '../../../COMMON/size_config.dart';
import '../Controller/add_cart_controller.dart';
import '../Controller/decrease_cart_controller.dart';
import '../Controller/get_all_cat_products_controller.dart';
import '../Controller/get_cart_controller.dart';
import '../Controller/include_update_cart_controller.dart';
import '../Controller/remove_fromcart_controller.dart';
import '../Controller/view_prod_details_controller.dart';

class view_details extends StatefulWidget {
  const view_details({Key? key}) : super(key: key);

  @override
  State<view_details> createState() => _view_detailsState();
}

class _view_detailsState extends State<view_details> {
  List include_lst = [
    "Classic Meni-Cure",
    "Classic Pedi-Cure",
    "Blowdry",
  ];
  String? uid;

  getuserid() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    setState(() {
      uid = sf.getString("stored_uid");
      print("USER ID ID ${uid.toString()}");
    });
  }

  var indexofid;
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

  final _view_det = Get.put(view_prod_details_controller());
  final _get_allprod = Get.put(get_all_cat_products_controller());
  final _add_cart = Get.put(add_cart_controller());
  final _decrease_cart = Get.put(decrease_cart_controller());
  final _get_cart = Get.put(get_cart_controller());
  final _add_include = Get.put(include_update_cart_controller());

  final _remove_from_cart = Get.put(remove_fromcart_controller());

  List includelst = [];

  includelistfunc(id, service_id, service, price) {
    includelst.add({
      "id": id,
      "service_id": service_id,
      "service": service,
      "price": price
    });
  }

  var getinclude;

  // removehtml(){
  //   final document = parse(_view_det.response.value.data!.whatincludes.toString().replaceAll("<li>", "• "));
  //   final String parsedString = parse(document.body!.text).documentElement!.text;
  //   setState(() {
  //     getinclude=parsedString;
  //   });
  // }

  @override
  void initState() {
    getuserid();
    // removehtml();
    initPlatformState().then((value) {
      // _view_det.view_prod_details_cont();
      print(
          "${uid.toString() == "" || uid == null ? "" : uid.toString()}${_deviceId.toString()}");
      _get_cart
          .get_cart_cont(
              uid.toString() == "" || uid == null ? "" : uid.toString(),
              _deviceId.toString())
          .then((value) {});
    });
    super.initState();
  }

  int? selecedindx;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bg_col,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [_get_cart.loading.value ? Container() : Container()],
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              margin: EdgeInsets.only(left: SizeConfig.screenWidth * 0.04),
              alignment: Alignment.center,
              decoration:
                  const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: Center(
                  child: Icon(Icons.arrow_back_ios_new,
                      color: common_color,
                      size: SizeConfig.screenHeight * 0.015)),
            ),
          ),
        ),
        body: Obx(() {
          return _view_det.loading.value
              ? const CommonIndicator()
              : SingleChildScrollView(
                child: Column(
                    children: [
                      //IMAGE
                      Container(
                        height: SizeConfig.screenHeight * 0.23,
                        width: SizeConfig.screenWidth,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(_view_det
                                    .response.value.data!.image
                                    .toString()),
                                fit: BoxFit.cover)),
                      ),

                      SizedBox(
                        height: SizeConfig.screenHeight * 0.02,
                      ),

                      //PRODUCT DETAIL TXT
                      Center(
                        child: SizedBox(
                          width: SizeConfig.screenWidth * 0.9,
                          child: Text(
                            "Service Detail",
                            style: font_style.black_600_20,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: SizeConfig.screenHeight * 0.02,
                      ),

                      //LINE
                      Center(
                          child: Container(
                        height: 1,
                        color: line_cont_col,
                        width: SizeConfig.screenWidth * 0.9,
                      )),

                      SizedBox(
                        height: SizeConfig.screenHeight * 0.02,
                      ),

                      //PRICE QUANTITY
                      Center(
                        child: SizedBox(
                          width: SizeConfig.screenWidth * 0.9,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _view_det.response.value.data!.title
                                        .toString(),
                                    style: font_style.black_500_18,
                                  ),
                                  SizedBox(
                                    height: SizeConfig.screenHeight * 0.008,
                                  ),
                                  //Rs. DISCOUNT
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        _view_det
                                            .response.value.data!.regularPrice
                                            .toString(),
                                        style: font_style.greyA1A1AA_400_14,
                                      ),
                                      SizedBox(
                                        width: SizeConfig.screenWidth * 0.02,
                                      ),
                                      Text(
                                        "₹${_view_det.response.value.data!.sellPrice.toString()}",
                                        style: font_style.yell_400_14,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              _get_cart.loading.value
                                  ? Container(
                                      width: SizeConfig.screenWidth * 0.18,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 5),
                                      decoration: BoxDecoration(
                                          color: yellow_col,
                                          borderRadius:
                                              BorderRadius.circular(44)),
                                      child: const CupertinoActivityIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : _get_cart.prodid.contains(_view_det
                                          .response.value.data!.id
                                          .toString())
                                      ?

                                      //ADD REMOVE ROW
                                      Container(
                                          width: SizeConfig.screenWidth * 0.18,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 5),
                                          decoration: BoxDecoration(
                                              color: yellow_col,
                                              borderRadius:
                                                  BorderRadius.circular(44)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              //SUBTRACT
                                              Flexible(
                                                child: InkWell(
                                                    onTap: () {
                                                      print(_get_cart.prodid
                                                          .indexOf(_view_det
                                                              .response
                                                              .value
                                                              .data!
                                                              .id
                                                              .toString()));
                                                      if (_get_cart
                                                              .response
                                                              .value
                                                              .data![_get_cart
                                                                  .prodid
                                                                  .indexOf(_view_det
                                                                      .response
                                                                      .value
                                                                      .data!
                                                                      .id
                                                                      .toString())]
                                                              .qty
                                                              .toString() ==
                                                          '1') {
                                                        _remove_from_cart
                                                            .remove_fromcart_cont(
                                                                // _view_det.response.value.data!.id.toString(),
                                                                uid.toString() ==
                                                                            "" ||
                                                                        uid ==
                                                                            null
                                                                    ? ""
                                                                    : uid
                                                                        .toString(),
                                                                _deviceId
                                                                    .toString(),
                                                                _get_cart
                                                                    .response
                                                                    .value
                                                                    .data![_get_cart
                                                                        .prodid
                                                                        .indexOf(_view_det
                                                                            .response
                                                                            .value
                                                                            .data!
                                                                            .id
                                                                            .toString())]
                                                                    .id
                                                                    .toString()
                                                                // "service"
                                                                )
                                                            .then((value) {
                                                          setState(() {
                                                            if (_get_cart.prodid
                                                                    .length ==
                                                                1) {
                                                              _get_cart.prodid
                                                                  .clear();
                                                            }
                                                            _get_cart.get_cart_cont(
                                                                uid.toString() ==
                                                                            "" ||
                                                                        uid ==
                                                                            null
                                                                    ? ""
                                                                    : uid
                                                                        .toString(),
                                                                _deviceId
                                                                    .toString());
                                                          });
                                                        });
                                                      } else {
                                                        initPlatformState();
                                                        _decrease_cart
                                                            .decrease_cart_cont(
                                                                _view_det
                                                                    .response
                                                                    .value
                                                                    .data!
                                                                    .id
                                                                    .toString(),
                                                                uid.toString() ==
                                                                            "" ||
                                                                        uid ==
                                                                            null
                                                                    ? ""
                                                                    : uid
                                                                        .toString(),
                                                                _deviceId
                                                                    .toString(),
                                                                "${int.parse(_get_cart.response.value.data![_get_cart.prodid.indexOf(_view_det.response.value.data!.id.toString())].qty.toString()) - 1}")
                                                            .then((value) {
                                                          setState(() {
                                                            _get_cart.get_cart_cont(
                                                                uid.toString() ==
                                                                            "" ||
                                                                        uid ==
                                                                            null
                                                                    ? ""
                                                                    : uid
                                                                        .toString(),
                                                                _deviceId
                                                                    .toString());
                                                            // _get_allprod.loadinglist[_get_allprod.allproductid.indexOf(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())] = false;
                                                          });
                                                        });
                                                      }
                                                    },
                                                    child: Container(
                                                        child: const Icon(
                                                      Icons.remove,
                                                      color: Colors.white,
                                                      size: 16,
                                                    ))),
                                              ),

                                              //TOTAL
                                              Text(
                                                _get_cart
                                                    .response
                                                    .value
                                                    .data![_get_cart.prodid
                                                        .indexOf(_view_det
                                                            .response
                                                            .value
                                                            .data!
                                                            .id
                                                            .toString())]
                                                    .qty
                                                    .toString(),
                                                style: font_style.white_400_10,
                                              ),

                                              //ADD
                                              Flexible(
                                                child: InkWell(
                                                    onTap: () {
                                                      initPlatformState();
                                                      _decrease_cart
                                                          .decrease_cart_cont(
                                                              _view_det.response
                                                                  .value.data!.id
                                                                  .toString(),
                                                              uid.toString() ==
                                                                          "" ||
                                                                      uid == null
                                                                  ? ""
                                                                  : uid
                                                                      .toString(),
                                                              _deviceId
                                                                  .toString(),
                                                              "${int.parse(_get_cart.response.value.data![_get_cart.prodid.indexOf(_view_det.response.value.data!.id.toString())].qty.toString()) + 1}")
                                                          .then((value) {
                                                        setState(() {
                                                          selecedindx = null;
                                                          _get_cart.get_cart_cont(
                                                              uid.toString() ==
                                                                          "" ||
                                                                      uid == null
                                                                  ? ""
                                                                  : uid
                                                                      .toString(),
                                                              _deviceId
                                                                  .toString());
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
                                          onTap: () {
                                            initPlatformState();
                                            print(_get_cart.prodid);
                                            _add_cart
                                                .add_cart_cont(
                                                    _view_det
                                                        .response.value.data!.id
                                                        .toString(),
                                                    "1",
                                                    uid.toString() == "" ||
                                                            uid == null
                                                        ? ""
                                                        : uid.toString(),
                                                    _deviceId.toString(),
                                                    "service")
                                                .then((value) {
                                              setState(() {
                                                _get_cart.get_cart_cont(
                                                    uid.toString() == "" ||
                                                            uid == null
                                                        ? ""
                                                        : uid.toString(),
                                                    _deviceId.toString());
                                                // _get_allprod.loadinglist[_get_allprod.allproductid.indexOf(_get_allprod.response.value.data![_get_allprod.getbiyd.indexOf(widget.cateid)].serviceCategoryData![scrollindex].subcateProduct![prodindex].id.toString())] = false;
                                              });
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: SizeConfig.screenWidth * 0.18,
                                            padding:
                                                const EdgeInsets.symmetric(vertical: 8),
                                            decoration: BoxDecoration(
                                                color: yellow_col,
                                                borderRadius:
                                                    BorderRadius.circular(44)),
                                            child: Row(
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
                          ),
                        ),
                      ),

                      SizedBox(
                        height: SizeConfig.screenHeight * 0.01,
                      ),

                      //LINE
                      Center(
                          child: Container(
                        height: 1,
                        color: line_cont_col,
                        width: SizeConfig.screenWidth * 0.9,
                      )),

                      SizedBox(
                        height: SizeConfig.screenHeight * 0.02,
                      ),

                      //PRODUCT NAME PRICE
                      _get_cart.prodid.contains(
                              _view_det.response.value.data!.id.toString())
                          ? Center(
                              child: SizedBox(
                                width: SizeConfig.screenWidth * 0.9,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Service Cost",
                                      style: font_style.black_500_14,
                                    ),
                                    Text(
                                      "₹${int.parse(_view_det.response.value.data!.sellPrice.toString()) * int.parse(_get_cart.response.value.data![_get_cart.prodid.indexOf(_view_det.response.value.data!.id.toString())].qty.toString())}",
                                      style: font_style.black_500_14,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(),

                      SizedBox(
                        height: SizeConfig.screenHeight * 0.01,
                      ),

                      //LINE
                      _get_cart.prodid.contains(
                              _view_det.response.value.data!.id.toString())
                          ? Center(
                              child: Container(
                              height: 1,
                              color: line_cont_col,
                              width: SizeConfig.screenWidth * 0.9,
                            ))
                          : Container(),
                      _get_cart.prodid.contains(
                              _view_det.response.value.data!.id.toString())
                          ? SizedBox(
                              height: SizeConfig.screenHeight * 0.02,
                            )
                          : Container(),

                      //DURATION TIME
                      Center(
                        child: SizedBox(
                          width: SizeConfig.screenWidth * 0.9,
                          child: Row(
                            children: [
                              Text(
                                "Duration",
                                style: font_style.black_600_20,
                              ),
                              const Spacer(),
                              SvgPicture.asset("assets/images/duration.svg",color: common_color),
                              SizedBox(width: SizeConfig.screenWidth * 0.01),
                              Text(
                                _view_det.response.value.data!.duration
                                    .toString(),
                                style: font_style.green_600_12,
                              )
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        height: SizeConfig.screenHeight * 0.01,
                      ),
                      _view_det.response.value.data!.whatincludes.toString() !=
                              "null"
                          ? Column(
                              children: [
                                //LINE
                                Center(
                                    child: Container(
                                  height: 1,
                                  color: line_cont_col,
                                  width: SizeConfig.screenWidth * 0.9,
                                )),

                                SizedBox(
                                  height: SizeConfig.screenHeight * 0.02,
                                ),

                                //WHAT IT INCLUDES TXT
                                Center(
                                  child: SizedBox(
                                    width: SizeConfig.screenWidth * 0.9,
                                    child: Text(
                                      "What it includes:",
                                      style: font_style.black_600_20,
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: SizeConfig.screenHeight * 0.01,
                                ),

                                //INCLUDES
                                Center(
                                  child: SizedBox(
                                    width: SizeConfig.screenWidth * 0.86,
                                    child: Text(
                                      _view_det.inlcudetxt.toString(),
                                      style: font_style.black_500_14,
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: SizeConfig.screenHeight * 0.01,
                                ),
                              ],
                            )
                          : Container(),

                      //NOTE: TXT
                      _view_det.response.value.data!.notes.toString() != "null"
                          ? Column(
                              children: [
                                Center(
                                    child: Container(
                                  height: 1,
                                  color: line_cont_col,
                                  width: SizeConfig.screenWidth * 0.9,
                                )),

                                SizedBox(
                                  height: SizeConfig.screenHeight * 0.02,
                                ),
                                Center(
                                  child: InkWell(
                                    onTap: () {
                                      includelst.clear();
                                    },
                                    child: SizedBox(
                                      width: SizeConfig.screenWidth * 0.9,
                                      child: Text(
                                        "Note:",
                                        style: font_style.black_600_20,
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: SizeConfig.screenHeight * 0.01,
                                ),

                                // NOTE
                                Center(
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      width: SizeConfig.screenWidth,
                                      child: Text(
                                        _view_det.response.value.data!.notes
                                            .toString(),
                                        style: font_style.black_500_14,
                                        maxLines: 2,
                                      )),
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
              );
        }),
      ),
    );
  }
}
