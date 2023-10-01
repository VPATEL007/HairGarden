import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:hairgarden/auth/Screens/login_page.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../COMMON/common_circular_indicator.dart';
import '../../COMMON/common_color.dart';
import '../../COMMON/size_config.dart';
import '../address/Controller/get_address_controller.dart';
import '../book_slot Payment/Controller/get_staffs_controller.dart';
import '../book_slot Payment/Controller/get_time_slots_controller.dart';
import '../book_slot Payment/Screens/bookslot_page.dart';
import '../book_slot Payment/Screens/payment_page.dart';
import '../category/Controller/add_cart_controller.dart';
import '../category/Controller/decrease_cart_controller.dart';
import '../category/Controller/get_addons_controller.dart';
import '../category/Controller/get_all_cat_products_controller.dart';
import '../category/Controller/get_cart_controller.dart';
import '../category/Controller/remove_fromcart_controller.dart';
import '../category/Controller/view_prod_details_controller.dart';
import '../category/Screens/our_recomendation.dart';

class common_cart_cont extends StatefulWidget {
  String? uid, deviceId, indexofid, selected_cat, pagename;
  String? getslotid, getbookdate, getaddressid, getstaffid, getstafftype;

  common_cart_cont(
      {required this.uid,
      required this.deviceId,
      required this.indexofid,
      required this.selected_cat,
      required this.pagename,
      required this.getslotid,
      required this.getbookdate,
      required this.getaddressid,
      required this.getstaffid,
      required this.getstafftype});

  @override
  State<common_cart_cont> createState() => _common_cart_contState();
}

class _common_cart_contState extends State<common_cart_cont> {
  final _get_addons = Get.put(get_addons_controller());
  final _get_allprod = Get.put(get_all_cat_products_controller());
  final _add_cart = Get.put(add_cart_controller());
  final _decrease_cart = Get.put(decrease_cart_controller());
  final _get_cart = Get.put(get_cart_controller());
  final _remove_from_cart = Get.put(remove_fromcart_controller());

  int? selectedind;
  List getcartcatid = [];
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

  String? uid;

  Future<void> getuserid() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    setState(() {
      uid = sf.getString("stored_uid");
      print("USER ID ID ${uid.toString()}");
    });
  }

  String? getseladdindx;

  getselectedaddress() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    setState(() {
      getseladdindx = sf.getString("selectedaddressid");
    });
  }

  getcatid() {
    getcartcatid.clear();
    _get_cart.prodid.forEach((element) {
      getcartcatid.add(_get_allprod
          .allproductcatid[_get_allprod.checkprodid.indexOf(element)]);
    });
  }

  final _get_staffs = Get.put(get_staffs_controller());
  final _get_time_slots = Get.put(get_time_slots_controller());
  final _get_address = Get.put(get_address_controller());

  @override
  void initState() {
    setState(() {
      selectedind = null;
    });
    getselectedaddress();
    initPlatformState();
    getuserid();
    getcatid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      // height: showdet==true?SizeConfig.screenHeight*0.2:SizeConfig.screenHeight*0.09,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8))),
      width: SizeConfig.screenWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: SizeConfig.screenWidth * 0.04,
              ),
              //GREEN ARROW UP
              InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return StatefulBuilder(builder: (BuildContext context,
                            void Function(void Function()) sState) {
                          return Obx(() {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.screenWidth * 0.05,
                                  vertical: SizeConfig.screenHeight * 0.01),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  //GREY LINE
                                  Center(
                                    child: Container(
                                      height: 5,
                                      color: Colors.grey,
                                      width: SizeConfig.screenWidth * 0.1,
                                    ),
                                  ),

                                  SizedBox(
                                    height: SizeConfig.screenHeight * 0.01,
                                  ),

                                  //CART
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                          "assets/images/cart.svg"),
                                      SizedBox(
                                        width: SizeConfig.screenWidth * 0.02,
                                      ),
                                      Text(
                                        "Cart",
                                        style: font_style.black_600_20,
                                      ),
                                      _get_cart.loading.value
                                          ? Container()
                                          : Container()
                                    ],
                                  ),
                                  SizedBox(
                                    height: SizeConfig.screenHeight * 0.015,
                                  ),

                                  //LINE
                                  Container(
                                    height: 1,
                                    width: SizeConfig.screenWidth,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    height: SizeConfig.screenHeight * 0.015,
                                  ),

                                  SizedBox(
                                    height: (_get_cart.response.value.data
                                                    ?.length ??
                                                0) >=
                                            11
                                        ? SizeConfig.screenHeight * 0.055 * 11
                                        : SizeConfig.screenHeight *
                                            0.055 *
                                            _get_cart
                                                .response.value.data!.length,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          _get_cart.response.value.data!.length,
                                      itemBuilder: (context, bottomindex) {
                                        return Obx(() {
                                          return Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    _get_cart
                                                        .response
                                                        .value
                                                        .data![bottomindex]
                                                        .title
                                                        .toString(),
                                                    style:
                                                        font_style.black_500_16,
                                                  ),
                                                  SizedBox(
                                                    height: SizeConfig
                                                            .screenHeight *
                                                        0.008,
                                                  ),

                                                  //Rs. DISCOUNT
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        _get_cart
                                                            .response
                                                            .value
                                                            .data![bottomindex]
                                                            .finalPrice
                                                            .toString(),
                                                        style: font_style
                                                            .greyA1A1AA_400_14,
                                                      ),
                                                      SizedBox(
                                                        width: SizeConfig
                                                                .screenWidth *
                                                            0.02,
                                                      ),
                                                      // Text("₹${_get_cart.response.value.data![bottomindex].finalPrice.toString()}",style: font_style.yell_400_10,),
                                                      Text(
                                                        "₹${int.parse(_get_cart.response.value.data![bottomindex].price.toString()) * int.parse(_get_cart.response.value.data![bottomindex].qty.toString())}",
                                                        style: font_style
                                                            .yell_400_14,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              selectedind == bottomindex
                                                  ? Container(
                                                      width: SizeConfig
                                                              .screenWidth *
                                                          0.18,
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8,
                                                          horizontal: 5),
                                                      decoration: BoxDecoration(
                                                          color: yellow_col,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      44)),
                                                      child:
                                                          const CupertinoActivityIndicator(
                                                              color:
                                                                  Colors.white,
                                                              radius: 8.2),
                                                    )
                                                  : _get_cart
                                                              .response
                                                              .value
                                                              .data![
                                                                  bottomindex]
                                                              .type
                                                              .toString() ==
                                                          "service"
                                                      ? Container(
                                                          width: SizeConfig
                                                                  .screenWidth *
                                                              0.18,
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 8,
                                                                  horizontal:
                                                                      5),
                                                          decoration: BoxDecoration(
                                                              color: yellow_col,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          44)),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              //SUBTRACT
                                                              Flexible(
                                                                child: InkWell(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        sState(
                                                                            () {
                                                                          if (_get_cart.response.value.data![bottomindex].qty.toString() ==
                                                                              '1') {
                                                                            print('1');
                                                                            sState(() {
                                                                              selectedind = bottomindex;
                                                                            });
                                                                            log('CAT ID====${_get_cart.response.value.data![bottomindex].id}');
                                                                            _remove_from_cart
                                                                                .remove_fromcart_cont(
                                                                                    // _get_cart.response.value.data![bottomindex].serviceCateId.toString(),
                                                                                    widget.uid.toString(),
                                                                                    widget.deviceId.toString(),
                                                                                    _get_cart.response.value.data![bottomindex].id.toString()
                                                                                    // "service"
                                                                                    )
                                                                                .then((value) {
                                                                              sState(() {
                                                                                selectedind = null;
                                                                              });
                                                                              print('2');
                                                                              if (_get_cart.prodid.length == 1) {
                                                                                print('3');
                                                                                Get.back();
                                                                                _get_cart.prodid.clear();
                                                                                _get_cart.get_cart_cont(widget.uid.toString() == "" || widget.uid == null ? "" : widget.uid.toString(), widget.deviceId.toString());
                                                                              }
                                                                             else
                                                                             {
                                                                               print('7');
                                                                               Get.back();
                                                                               _get_cart.get_cart_cont(widget.uid.toString() == "" || widget.uid == null ? "" : widget.uid.toString(), widget.deviceId.toString());
                                                                             }
                                                                            });
                                                                          } else {
                                                                            print('4');
                                                                            print(selectedind);
                                                                            print(bottomindex);
                                                                            sState(() {
                                                                              selectedind = bottomindex;
                                                                            });
                                                                            _decrease_cart.decrease_cart_cont(_get_cart.response.value.data![bottomindex].serviceCateId.toString(), widget.uid, widget.deviceId, "${int.parse(_get_cart.response.value.data![bottomindex].qty.toString()) - 1}").then((value) {
                                                                              sState(() {
                                                                                selectedind = null;
                                                                              });
                                                                              _get_cart.get_cart_cont(widget.uid.toString() == "" || widget.uid == null ? "" : widget.uid.toString(), widget.deviceId.toString());
                                                                            });
                                                                          }
                                                                        });
                                                                      });
                                                                    },
                                                                    child: Container(
                                                                        child: const Icon(
                                                                      Icons
                                                                          .remove,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 16,
                                                                    ))),
                                                              ),

                                                              //TOTAL
                                                              Text(
                                                                _get_cart
                                                                    .response
                                                                    .value
                                                                    .data![
                                                                        bottomindex]
                                                                    .qty
                                                                    .toString(),
                                                                style: font_style
                                                                    .white_400_10,
                                                              ),

                                                              //ADD
                                                              Flexible(
                                                                child: InkWell(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        sState(
                                                                            () {
                                                                          sState(
                                                                              () {
                                                                            selectedind =
                                                                                bottomindex;
                                                                          });
                                                                          _decrease_cart
                                                                              .decrease_cart_cont(_get_cart.response.value.data![bottomindex].serviceCateId.toString(), widget.uid, widget.deviceId, "${int.parse(_get_cart.response.value.data![bottomindex].qty.toString()) + 1}")
                                                                              .then((value) {
                                                                            sState(() {
                                                                              selectedind = null;
                                                                            });
                                                                            _get_cart.get_cart_cont(widget.uid.toString() == "" || widget.uid == null ? "" : widget.uid.toString(),
                                                                                widget.deviceId.toString());
                                                                          });
                                                                        });
                                                                      });
                                                                    },
                                                                    child: Container(
                                                                        child: const Icon(
                                                                      Icons.add,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 16,
                                                                    ))),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : InkWell(
                                                          onTap: () {
                                                            print('1');
                                                            setState(() {
                                                              sState(() {
                                                                sState(() {
                                                                  selectedind =
                                                                      bottomindex;
                                                                });
                                                                print('2');
                                                                _remove_from_cart
                                                                    .remove_fromcart_cont(
                                                                        // _get_cart.response.value.data![bottomindex].serviceCateId.toString(),
                                                                        widget
                                                                            .uid
                                                                            .toString(),
                                                                        widget
                                                                            .deviceId
                                                                            .toString(),
                                                                        _get_cart
                                                                            .response
                                                                            .value
                                                                            .data![
                                                                                bottomindex]
                                                                            .id
                                                                            .toString()
                                                                        // "service"
                                                                        )
                                                                    .then(
                                                                        (value) {
                                                                          print('3');
                                                                  sState(() {
                                                                    selectedind =
                                                                        null;
                                                                  });
                                                                          print('4');
                                                                  if (_get_cart
                                                                          .prodid
                                                                          .length ==
                                                                      1) {
                                                                    print('5');
                                                                    _get_cart
                                                                        .prodid
                                                                        .clear();
                                                                    Get.back();
                                                                    _get_cart.get_cart_cont(
                                                                        widget.uid.toString() == "" || widget.uid == null
                                                                            ? ""
                                                                            : widget.uid
                                                                                .toString(),
                                                                        widget
                                                                            .deviceId
                                                                            .toString());
                                                                  }
                                                                  else
                                                                  {
                                                                    print('6');
                                                                    Get.back();
                                                                    _get_cart.get_cart_cont(
                                                                        widget.uid.toString() == "" ||
                                                                            widget.uid ==
                                                                                null
                                                                            ? ""
                                                                            : widget
                                                                            .uid
                                                                            .toString(),
                                                                        widget
                                                                            .deviceId
                                                                            .toString());
                                                                  }

                                                                });
                                                              });
                                                            });
                                                          },
                                                          child: Container(
                                                            width: SizeConfig
                                                                    .screenWidth *
                                                                0.18,
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical: 8,
                                                                    horizontal:
                                                                        5),
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    yellow_col,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            44)),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                //TOTAL
                                                                Text(
                                                                  "Remove",
                                                                  style: font_style
                                                                      .white_400_10,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                            ],
                                          );
                                        });
                                      },
                                      separatorBuilder: (context, bottomindex) {
                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                            vertical:
                                                SizeConfig.screenHeight * 0.01,
                                          ),
                                          height: 1,
                                          width: SizeConfig.screenWidth,
                                          color: Colors.grey,
                                        );
                                      },
                                    ),
                                  ),

                                  // SizedBox(height: SizeConfig.screenHeight*0.015,),

                                  //LINE
                                  Container(
                                    height: 1,
                                    width: SizeConfig.screenWidth,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    height: SizeConfig.screenHeight * 0.015,
                                  ),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Service Cost",
                                        style: font_style.black_500_14,
                                      ),
                                      Text(
                                        "₹${_get_cart.response.value.total.toString()}",
                                        style: font_style.black_500_14,
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    height: SizeConfig.screenHeight * 0.015,
                                  ),

                                  //LINE
                                  Container(
                                    height: 1,
                                    width: SizeConfig.screenWidth,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    height: SizeConfig.screenHeight * 0.015,
                                  ),

                                  SizedBox(
                                    width: SizeConfig.screenWidth * 0.02,
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Total",
                                            style: font_style.greyA1A1AA_400_18,
                                          ),
                                          Text(
                                            "₹${_get_cart.response.value.total.toString()}",
                                            style: font_style.black_500_16,
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      InkWell(
                                        onTap: () {
                                          if (widget.pagename.toString() ==
                                              "recom") {
                                            print("DSDDSSSD");
                                            // Get.to(bookslot_page());
                                            if (widget.uid.toString() == "" ||
                                                widget.uid == null) {
                                              // commontoas(msg: "Please Login to book now");
                                              Get.offAll(
                                                  login_page(
                                                    frompage: 'skip',
                                                  ),
                                                  transition:
                                                      Transition.downToUp);
                                            } else {
                                              getselectedaddress();
                                              print(
                                                  "SELECTEDIND: $selectedind");
                                              print(
                                                  "SELECTEDIND: ${_get_address.defaultaddid.toString()}");
                                              // getseladdindx==""||getseladdindx==null && _get_address.defaultaddid.toString()==""||_get_address.defaultaddid==null?
                                              // _get_address.get_address_cont(uid).then((value) => _get_staffs.get_staffs_cont("",_get_cart.response.value.data![0].categoryId)).then((value) =>  Navigator.push(context, MaterialPageRoute(builder: (context)=>bookslot_page()))):
                                              getseladdindx == "" || getseladdindx == null
                                                  ? _get_address
                                                      .get_address_cont(uid)
                                                      .then((value) =>
                                                          _get_staffs.get_staffs_cont(
                                                              _get_address.defaultaddid
                                                                  .toString(),
                                                              _get_cart
                                                                  .response
                                                                  .value
                                                                  .data![0]
                                                                  .categoryId))
                                                      .then((value) => Get.to(
                                                          const bookslot_page()))
                                                  : _get_address
                                                      .get_address_cont(uid)
                                                      .then((value) =>
                                                          _get_staffs.get_staffs_cont(
                                                              getseladdindx,
                                                              _get_cart
                                                                  .response
                                                                  .value
                                                                  .data![0]
                                                                  .categoryId))
                                                      .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => const bookslot_page())));
                                            }
                                          } else {
                                            _get_addons
                                                .get_addons_cont(
                                                    uid.toString() == "" ||
                                                            uid == null
                                                        ? ""
                                                        : uid.toString(),
                                                    _deviceId.toString())
                                                .then((value) => Get.to(
                                                    our_recomendation_page()));
                                          }
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: SizeConfig.screenWidth * 0.25,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          decoration: BoxDecoration(
                                              color: yellow_col,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Obx(() {
                                            return _get_addons.loading.value ||
                                                    _get_address
                                                        .loading.value ||
                                                    _get_staffs.loading.value
                                                ? const CupertinoActivityIndicator(
                                                    color: Colors.white,
                                                  )
                                                : Text(
                                                    widget.pagename.toString() ==
                                                                "recom" &&
                                                            _get_cart.addonid
                                                                    .length ==
                                                                0
                                                        ? "SKIP"
                                                        : "BOOK NOW",
                                                    style:
                                                        font_style.white_600_14,
                                                  );
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          });
                        });
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: common_color,
                    child: const Icon(Icons.keyboard_arrow_up,
                        color: Colors.white),
                  )),
              SizedBox(
                width: SizeConfig.screenWidth * 0.025,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total",
                    style: font_style.greyA1A1AA_400_18,
                  ),
                  Text(
                    "₹${_get_cart.response.value.total.toString()}",
                    style: font_style.black_500_16,
                  ),
                ],
              ),

              const Spacer(),
              InkWell(
                onTap: () {
                  getuserid();

                  if (widget.pagename.toString() == "recom") {
                    print("DSDDSSSD");
                    // Get.to(bookslot_page());
                    if (widget.uid.toString() == "" || widget.uid == null) {
                      // commontoas(msg: "Please Login to book now");
                      Get.offAll(
                          login_page(
                            frompage: 'skip',
                          ),
                          transition: Transition.downToUp);
                    } else {
                      getselectedaddress();
                      _get_time_slots.get_time_slots_cont("random", "");
                      print("SELECTEDIND: $getseladdindx");
                      // getseladdindx==""||getseladdindx==null && _get_address.defaultaddid.toString()==""||_get_address.defaultaddid==null?
                      // _get_address.get_address_cont(uid).then((value) => _get_staffs.get_staffs_cont("",_get_cart.response.value.data![0].categoryId)).then((value) =>  Navigator.push(context, MaterialPageRoute(builder: (context)=>bookslot_page()))):
                      getseladdindx == "" || getseladdindx == null
                          ?
                          // _get_address
                          //         .get_address_cont(uid)
                          //         .then((value) =>
                          _get_staffs
                              .get_staffs_cont("",
                                  _get_cart.response.value.data![0].categoryId)
                              .then((value) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const bookslot_page())))
                          : _get_address
                              .get_address_cont(uid)
                              .then((value) => _get_staffs.get_staffs_cont(
                                  getseladdindx,
                                  _get_cart.response.value.data![0].categoryId))
                              .then((value) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const bookslot_page())));
                    }
                  } else {
                    _get_addons
                        .get_addons_cont(
                            uid.toString() == "" || uid == null
                                ? ""
                                : uid.toString(),
                            _deviceId.toString())
                        .then((value) {
                      print('Vijay====${_get_addons.response().data?.length}');
                      if (_get_addons.response().data?.isNotEmpty ?? false) {
                        Get.to(our_recomendation_page());
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const bookslot_page()));
                      }
                    });
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  width: SizeConfig.screenWidth * 0.25,
                  decoration: BoxDecoration(
                      color: yellow_col,
                      borderRadius: BorderRadius.circular(8)),
                  child: Obx(() {
                    return _get_addons.loading.value ||
                            _get_address.loading.value ||
                            _get_staffs.loading.value
                        ? const CupertinoActivityIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            widget.pagename.toString() == "recom" &&
                                    _get_cart.addonid.length == 0
                                ? "SKIP"
                                : "BOOK NOW",
                            style: font_style.white_600_14,
                          );
                  }),
                  // child: Text("BOOK NOW",style: font_style.white_600_14,),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
