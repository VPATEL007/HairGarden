import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hairgarden/COMMON/common_circular_indicator.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:hairgarden/USER/category/Screens/view_details.dart';
import 'package:hairgarden/USER/category/Screens/viewdetails_addons.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../COMMON/common_color.dart';
import '../../../COMMON/size_config.dart';
import '../../common/common_cart_cont.dart';
import '../../common/common_txt_list.dart';
import '../Controller/add_cart_controller.dart';
import '../Controller/get_addons_controller.dart';
import '../Controller/get_cart_controller.dart';
import '../Controller/remove_fromcart_controller.dart';
import '../Controller/view_prod_details_controller.dart';
import '../Controller/viewdetails_addons_controller.dart';

class our_recomendation_page extends StatefulWidget {
  @override
  State<our_recomendation_page> createState() => _our_recomendation_pageState();
}

class _our_recomendation_pageState extends State<our_recomendation_page> {
  final _get_addons = Get.put(get_addons_controller());

  // final _view_det = Get.put(view_prod_details_controller());
  final _view_det = Get.put(viewdetails_addons_controller());
  final _add_cart = Get.put(add_cart_controller());
  final _remove_from_cart = Get.put(remove_fromcart_controller());

  List prod_img = [
    "assets/images/product1_img.png",
    "assets/images/product2_img.png",
    "assets/images/product3_img.png",
    "assets/images/product4_img.png",
    "assets/images/product5_img.png",
  ];
  final _get_cart = Get.put(get_cart_controller());
  String? uid;

  getuserid() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    setState(() {
      uid = sf.getString("stored_uid");
      print("USER ID ID ${uid.toString()}");
    });
  }

  int? selectedaddons;
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

  @override
  void initState() {
    getuserid();
    initPlatformState().then((value) => _get_cart
        .get_cart_cont(
            uid.toString() == "" || uid == null ? "" : uid.toString(),
            _deviceId.toString())
        .then((value) => _get_cart.prodid));
    // _get_addons.get_addons_cont(uid.toString()==""||uid==null?"":uid.toString(), _deviceId.toString());
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
            "Our Popular Add-ons",
            style: font_style.green_600_20,
          ),
          actions: [
            _get_cart.loading.value ? Container() : Container(),
          ],
        ),
        body: Obx(() {
          return _get_addons.loading.value
              ? const CommonIndicator()
              : ListView.separated(
                  padding:
                      EdgeInsets.only(left: SizeConfig.screenWidth * 0.025),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 5),
                          width: SizeConfig.screenWidth * 0.50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: yellow_col),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              //IMAGES
                              Container(
                                height: SizeConfig.screenHeight * 0.13,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: _get_addons.response.value
                                                    .data![index].image
                                                    .toString() !=
                                                ""
                                            ? NetworkImage(_get_addons.response
                                                .value.data![index].image
                                                .toString()) as ImageProvider
                                            : AssetImage(
                                                prod_img[0].toString()),
                                        fit: BoxFit.fill)),
                              ),
                              SizedBox(
                                height: SizeConfig.screenHeight * 0.01,
                              ),

                              SizedBox(
                                  width: SizeConfig.screenWidth * 0.4,
                                  child: Text(
                                    _get_addons
                                        .response.value.data![index].title
                                        .toString(),
                                    style: font_style.black_500_16,
                                  )),
                              SizedBox(
                                height: SizeConfig.screenHeight * 0.005,
                              ),

                              //Rs. DISCOUNT
                              Row(
                                children: [
                                  Text(
                                    "₹${_get_addons.response.value.data![index].sellPrice.toString()}",
                                    style: font_style.yell_400_14,
                                  ),
                                  SizedBox(
                                    width: SizeConfig.screenWidth * 0.02,
                                  ),
                                  Text(
                                    _get_addons
                                        .response.value.data![index].price
                                        .toString(),
                                    style: font_style.greyA1A1AA_400_14,
                                  ),
                                  const Spacer(),
                                  Text(
                                    "${_get_addons.response.value.data![index].percent.toString()}% OFF",
                                    style: font_style.black_400_14,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: SizeConfig.screenHeight * 0.005,
                              ),

                              _get_addons.response.value.data![index]
                                          .description
                                          .toString() ==
                                      ""
                                  ? Container()
                                  : SizedBox(
                                      width: SizeConfig.screenWidth * 0.4,
                                      height: SizeConfig.screenHeight * 0.05,
                                      child: Text(
                                        _get_addons.response.value.data![index]
                                            .description
                                            .toString(),
                                        style: font_style.black_400_14,
                                        textAlign: TextAlign.justify,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                              SizedBox(
                                height: SizeConfig.screenHeight * 0.01,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        _view_det
                                            .viewdetails_addons_cont(_get_addons
                                                .response.value.data![index].id
                                                .toString())
                                            .then((value) => Get.to(
                                                const ViewDetailAddOnView()));
                                      },
                                      child: Text(
                                        "View Details ",
                                        style: font_style.green_400_14,
                                      )),
                                  selectedaddons == index
                                      ? Container(
                                          alignment: Alignment.center,
                                          width: SizeConfig.screenWidth * 0.20,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 5),
                                          decoration: BoxDecoration(
                                              color: yellow_col,
                                              borderRadius:
                                                  BorderRadius.circular(44)),
                                          child:
                                              const CupertinoActivityIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : _get_cart.addonid.contains(_get_addons
                                              .response.value.data![index].id
                                              .toString())
                                          ? InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedaddons = index;
                                                });
                                                print(_get_addons.response.value
                                                    .data![index].id
                                                    .toString());
                                                _remove_from_cart
                                                    .remove_fromcart_cont(
                                                        uid.toString() == "" ||
                                                                uid == null
                                                            ? ""
                                                            : uid.toString(),
                                                        _deviceId.toString(),
                                                        _get_cart
                                                            .response
                                                            .value
                                                            .data![_get_cart
                                                                .addonallid
                                                                .indexOf(_get_addons
                                                                    .response
                                                                    .value
                                                                    .data![
                                                                        index]
                                                                    .id
                                                                    .toString())]
                                                            .id
                                                            .toString())
                                                    .then((value) {
                                                  setState(() {
                                                    selectedaddons = null;
                                                  });
                                                  _get_cart.get_cart_cont(
                                                      uid, _deviceId);
                                                });
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                width: SizeConfig.screenWidth *
                                                    0.20,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 5),
                                                decoration: BoxDecoration(
                                                    color: yellow_col,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            44)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "REMOVE",
                                                      style: font_style
                                                          .white_400_10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          :

                                          //ADD BUTTON
                                          InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedaddons = index;
                                                  _add_cart
                                                      .add_cart_cont(
                                                          _get_addons
                                                              .response
                                                              .value
                                                              .data![index]
                                                              .id
                                                              .toString(),
                                                          "1",
                                                          uid.toString() ==
                                                                      "" ||
                                                                  uid == null
                                                              ? ""
                                                              : uid.toString(),
                                                          _deviceId,
                                                          "addonservice")
                                                      .then((value) {
                                                    selectedaddons = null;
                                                    _get_cart.get_cart_cont(
                                                        uid, _deviceId);
                                                  });
                                                });
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                width: SizeConfig.screenWidth *
                                                    0.18,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 5),
                                                decoration: BoxDecoration(
                                                    color: yellow_col,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            44)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "ADD",
                                                      style: font_style
                                                          .white_400_10,
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
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      width: 7,
                    );
                  },
                  itemCount: _get_addons.response.value.data?.length ?? 0);
        }),
        bottomNavigationBar: _get_cart.response.value.data!.isEmpty ||
                _get_cart.response.value.status == false
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  common_cart_cont(
                      uid: uid,
                      deviceId: _deviceId,
                      indexofid: indexofid.toString(),
                      selected_cat: "",
                      pagename: "recom",
                      getslotid: "",
                      getbookdate: "",
                      getaddressid: "",
                      getstaffid: "",
                      getstafftype: "")
                ],
              ),
      );
    });
  }
}
