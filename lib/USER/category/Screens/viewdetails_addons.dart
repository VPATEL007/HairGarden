import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../COMMON/common_circular_indicator.dart';
import '../../../COMMON/common_color.dart';
import '../../../COMMON/size_config.dart';
import '../Controller/add_cart_controller.dart';
import '../Controller/get_cart_controller.dart';
import '../Controller/remove_fromcart_controller.dart';
import '../Controller/viewdetails_addons_controller.dart';

class ViewDetailAddOnView extends StatefulWidget {
  const ViewDetailAddOnView({Key? key}) : super(key: key);

  @override
  State<ViewDetailAddOnView> createState() => _ViewDetailAddOnViewState();
}

class _ViewDetailAddOnViewState extends State<ViewDetailAddOnView> {
  final viewDetailController = Get.put(viewdetails_addons_controller());
  final getCartController = Get.put(get_cart_controller());
  final addCartController = Get.put(add_cart_controller());
  final removeFromCartController = Get.put(remove_fromcart_controller());
  String? uid;

  getUserID() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    setState(() {
      uid = sf.getString("stored_uid");
      print("USER ID ID ${uid.toString()}");
    });
  }

  var indexofid;
  String? _deviceId;
  int? selectedAddOnProduct;

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
    getUserID();
    initPlatformState().then((value) {
      // viewDetailController.view_prod_details_cont();
      print(
          "${uid.toString() == "" || uid == null ? "" : uid.toString()}${_deviceId.toString()}");
      getCartController
          .get_cart_cont(
              uid.toString() == "" || uid == null ? "" : uid.toString(),
              _deviceId.toString())
          .then((value) {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bg_col,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [getCartController.loading.value ? Container() : Container()],
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              margin: EdgeInsets.only(left: SizeConfig.screenWidth * 0.04),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
              child: Center(
                  child: Icon(Icons.arrow_back_ios_new,
                      color: common_color,
                      size: SizeConfig.screenHeight * 0.015)),
            ),
          ),
        ),
        body: Obx(() {
          return viewDetailController.loading.value
              ? const CommonIndicator()
              : Column(
                  children: [
                    //IMAGE
                    Container(
                      height: SizeConfig.screenHeight * 0.23,
                      width: SizeConfig.screenWidth,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(viewDetailController
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
                          style: font_style.black_600_18,
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
                                  viewDetailController.response.value.data!.title
                                      .toString(),
                                  style: font_style.black_500_15,
                                ),
                                SizedBox(
                                  height: SizeConfig.screenHeight * 0.008,
                                ),
                                //Rs. DISCOUNT
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "₹${viewDetailController.response.value.data!.sellPrice.toString()}",
                                      style: font_style.yell_400_14,
                                    ),
                                    SizedBox(
                                      width: SizeConfig.screenWidth * 0.02,
                                    ),
                                    Text(
                                      viewDetailController.response.value.data!.price
                                          .toString(),
                                      style: font_style.greyA1A1AA_400_14,
                                    ),


                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            getCartController.loading.value
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
                                : getCartController.addonid.contains(viewDetailController
                                        .response.value.data!.id
                                        .toString())
                                    ? InkWell(
                                        onTap: () {
                                          print(viewDetailController
                                              .response.value.data!.id
                                              .toString());
                                          removeFromCartController
                                              .remove_fromcart_cont(
                                                  uid.toString() == "" ||
                                                          uid == null
                                                      ? ""
                                                      : uid.toString(),
                                                  _deviceId.toString(),
                                                  getCartController
                                                      .response
                                                      .value
                                                      .data![getCartController
                                                          .addonallid
                                                          .indexOf(viewDetailController
                                                              .response
                                                              .value
                                                              .data!
                                                              .id
                                                              .toString())]
                                                      .id
                                                      .toString())
                                              .then((value) {
                                            getCartController.get_cart_cont(
                                                uid, _deviceId);
                                          });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: SizeConfig.screenWidth * 0.18,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 5),
                                          decoration: BoxDecoration(
                                              color: yellow_col,
                                              borderRadius:
                                                  BorderRadius.circular(44)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "REMOVE",
                                                style: font_style.white_400_10,
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
                                            addCartController
                                                .add_cart_cont(
                                                    viewDetailController
                                                        .response.value.data!.id
                                                        .toString(),
                                                    "1",
                                                    uid.toString() == "" ||
                                                            uid == null
                                                        ? ""
                                                        : uid.toString(),
                                                    _deviceId,
                                                    "addonservice")
                                                .then((value) {
                                              getCartController.get_cart_cont(
                                                  uid, _deviceId);
                                            });
                                          });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: SizeConfig.screenWidth * 0.18,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 5),
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

                    //DURATION TIME
                    viewDetailController.response.value.data!.duration.toString() == ""
                        ? Container()
                        : Column(
                            children: [
                              Center(
                                child: SizedBox(
                                  width: SizeConfig.screenWidth * 0.9,
                                  child: Row(
                                    children: [
                                      Text(
                                        "Duration",
                                        style: font_style.black_500_15,
                                      ),
                                      const Spacer(),
                                      SvgPicture.asset(
                                          "assets/images/duration.svg",
                                          color: common_color,width: SizeConfig.screenWidth * 0.04),
                                      SizedBox(
                                          width: SizeConfig.screenWidth * 0.01),
                                      Text(
                                        viewDetailController.response.value.data!.duration
                                            .toString(),
                                        style: font_style.yell_400_14,
                                      )
                                    ],
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
                            ],
                          ),

                    viewDetailController.response.value.data!.description.toString() == ""
                        ? Container()
                        : Column(
                            children: [
                              Center(
                                child: SizedBox(
                                  width: SizeConfig.screenWidth * 0.9,
                                  child: Text(
                                    "Description",
                                    style: font_style.black_500_15,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.screenHeight * 0.01,
                              ),
                              Center(
                                child: SizedBox(
                                  width: SizeConfig.screenWidth * 0.9,
                                  child: Text(
                                    viewDetailController.response.value.data!.description
                                        .toString(),
                                    style: font_style.black_400_14,
                                  ),
                                ),
                              ),
                            ],
                          )
                  ],
                );
        }),
      ),
    );
  }
}
