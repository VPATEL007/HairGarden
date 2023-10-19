import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:hairgarden/USER/home/Screens/searched_details.dart';
import 'package:hairgarden/USER/home/Screens/youtube_video.dart';
import 'package:hairgarden/auth/Screens/login_page.dart';
import 'package:logger/logger.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../COMMON/common_circular_indicator.dart';
import '../../../COMMON/common_color.dart';
import '../../../COMMON/size_config.dart';
import '../../address/Controller/add_default_address_controller.dart';
import '../../address/Controller/delete_address_controller.dart';
import '../../address/Controller/get_address_controller.dart';
import '../../address/Controller/get_pincode_controller.dart';
import '../../bottombar/Screens/bottombar.dart';
import '../../category/Controller/get_all_cat_products_controller.dart';
import '../../category/Controller/get_cart_controller.dart';
import '../../category/Screens/all_categories.dart';
import '../../common/drawer.dart';
import '../../newmap1.dart';
import '../../notification/Screens/notification_page.dart';
import '../../updatemap.dart';
import '../Controller/get_banner_controller.dart';
import '../Controller/get_testimonials_controller.dart';

var logger = Logger();

class home_page extends StatefulWidget {
  const home_page({Key? key}) : super(key: key);

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  final _get_banner = Get.put(get_banner_controller());
  final _get_allprod = Get.put(get_all_cat_products_controller());
  final _get_testimonials = Get.put(get_testimonials_controller());
  final _get_cart = Get.put(get_cart_controller());
  final _get_address = Get.put(get_address_controller());
  final _add_default_address = Get.put(add_default_address_controller());
  final _del_address = Get.put(delete_address_controller());

  bool isLoading = false;

  String? devtype;

  getplatform() {
    if (Platform.isAndroid) {
      setState(() {
        devtype = "android";
      });
      // Android-specific code
    } else if (Platform.isIOS) {
      devtype = "ios";
      // iOS-specific code
    }
  }

  var uid, wallet, sp_refercode;

  Future<void> getuserid() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    setState(() {
      uid = sf.getString("stored_uid");

      // wallet=sf.getString("sp_wallet");
      sp_refercode = sf.getString("sp_refercode");
    });
  }

  @override
  void initState() {
    _get_banner.get_banner_cont().then((value)
    {
      log("BOTTOM BANNER===${_get_banner.bottombannerimg.length}");
    });

    _get_allprod.get_all_cat_products_cont().then((value) {
      print('Vijay Count Cart====${_get_allprod.response().data?.length}');
    });
    getuserid().then((value) {
      _get_address
          .get_address_cont(
              uid.toString() == "" || uid == null ? "" : uid.toString())
          .then((value) {
        getselectedaddress();
      });
    });
    getplatform();
    initPlatformState();
    _get_cart.get_cart_cont(
        uid.toString() == "" || uid == null ? "" : uid.toString(),
        _deviceId.toString());
    _get_testimonials.get_testimonials_cont(uid.toString()).then((value) {
      _get_testimonials.yturl;
      fillYTLists();
    });
    setState(() {
      books = _get_allprod.allsearchtxt;
    });

    super.initState();
  }

  int _current = 0;
  int _middlecurrent = 0;
  int _offerbannercurrent = 0;
  int _bottombannercurrent = 0;
  final CarouselController _controller = CarouselController();
  final CarouselController _middlecontroller = CarouselController();
  final CarouselController _offercontroller = CarouselController();
  final CarouselController _bottomcontroller = CarouselController();

  List safety_title = [
    "Temperature Record",
    "Temperature Record",
    "Vaccinated Professionals",
    "Vaccinated Professionals",
  ];
  List safety_img = [
    "assets/images/safety_sanitizer_img.png",
    "assets/images/safety_temp_img.png",
    "assets/images/safety_vaccinated_img.png",
    "assets/images/safety_vaccinated2_img.png",
  ];

  var scaffoldKey = GlobalKey<ScaffoldState>();

  late String videoTitle;
  List<YoutubePlayerController> lYTC = [];

  Map<String, dynamic> cStates = {};

  fillYTLists() {
    setState(() {
      isLoading = true;
    });
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
    setState(() {
      isLoading = false;
    });
  }

  String? nouseraddress;

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
      print("deviceId->$_deviceId");
    });
  }

  @override
  void dispose() {
    for (var element in lYTC) {
      element.dispose();
    }
    super.dispose();
  }

  bool isfullscreen = false;
  var selectedadd;
  var getadd;
  double? lat;
  double? long;

  getselectedaddress() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    getuserid();

    setState(() {
      if (_get_address.response.value.data?.isEmpty ?? false) {
        selectedadd = "";
      } else {
        getadd = sf.getString("selectedaddressid");
        if (getadd == "" || getadd == null) {
          sf.setString("selectedaddressid", _get_address.defaultaddid ?? '');
          setState(() {
            selectedadd =
                _get_address.addsidlst.indexOf(_get_address.defaultaddid ?? "");
          });
        } else {
          setState(() {
            selectedadd = _get_address.addsidlst.indexOf(getadd);
          });
        }
      }
    });
    print("SELECTEDADD: ${getadd}");
  }

  TextEditingController searchtxt = TextEditingController();
  List books = [];

  TextEditingController searchcontroller = TextEditingController();
  double? latt;
  double? longg;
  final _get_pincode = Get.put(get_pincode_controller());
  LatLng? center;
  final _text = TextEditingController();

  Future<void> getCurruntLocation() async {
    await Geolocator.getCurrentPosition().then((value) async {
      List<Placemark> locations =
          await placemarkFromCoordinates(value.latitude, value.longitude);
      setState(() {
        _text.text =
            "${locations[0].name}, ${locations[0].locality}, ${locations[0].country}";
        // setpincode=locations[0].postalCode.toString();
        lat = value.latitude;
        long = value.longitude;
        center =
            LatLng(double.parse(lat.toString()), double.parse(long.toString()));
      });
      print(lat);
      print(long);
    });
  }

  TextEditingController buildname = TextEditingController();
  TextEditingController locaname = TextEditingController();
  TextEditingController pincode = TextEditingController();

  String? pincodestr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: drawer(
        uid: uid,
        wallet: wallet,
        sp_refercode: sp_refercode,
      ),

      backgroundColor: bg_col,
      //APPBAR
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        //DRAWER
        leading: InkWell(
            onTap: () {
              scaffoldKey.currentState?.openDrawer();
            },
            child: SvgPicture.asset(
              "assets/images/home_menu.svg",
              fit: BoxFit.scaleDown,
            )),

        //ADDRESS
        title: InkWell(
          onTap: () async {
            _get_cart.prodid.clear();
            fillYTLists();
            getuserid()
                .then((value) => _get_address.get_address_cont(uid));

            if (uid == "" || uid == null) {
              Get.offAll(
                  login_page(
                    frompage: 'skip',
                  ),
                  transition: Transition.downToUp);
            } else {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return Container(
                    decoration: BoxDecoration(
                        color: bg_col,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(18),
                            topRight: Radius.circular(18))),
                    child: StatefulBuilder(
                      builder: (context, seState) {
                        var selcindx = null;
                        return Obx(() {
                          return Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.screenHeight * 0.02,
                                left: SizeConfig.screenWidth * 0.025,
                                right: SizeConfig.screenWidth * 0.025),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                //GREEN COLOR CONT
                                Center(
                                  child: Container(
                                    height: 4,
                                    width: SizeConfig.screenWidth * 0.2,
                                    decoration: BoxDecoration(
                                        color: common_color,
                                        borderRadius:
                                        BorderRadius.circular(2)),
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.screenHeight * 0.015,
                                ),

                                Center(
                                    child: Text(
                                      "SELECT LOCATION",
                                      style: font_style.black_600_20,
                                    )),
                                SizedBox(
                                  height: SizeConfig.screenHeight * 0.03,
                                ),

                                //ADD ADDRESSES ROW
                                InkWell(
                                  onTap: () {
                                    Get.to(newmaps(
                                      pname: "home",
                                    ));
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: common_color,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Add Address",
                                        style: font_style.green_600_15,
                                      ),
                                      const Spacer(),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: common_color,
                                        size: SizeConfig.screenHeight *
                                            0.02,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.screenHeight * 0.01,
                                ),

                                //LINE
                                Container(
                                  height: 1,
                                  width: SizeConfig.screenWidth,
                                  color: line_cont_col,
                                ),
                                SizedBox(
                                  height: SizeConfig.screenHeight * 0.01,
                                ),

                                //SAVED ADDRESS TEXT
                                Text(
                                  "Saved Addresses ",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Lato',
                                    color: common_color,
                                    fontWeight: FontWeight.w500,
                                    // foreground: Paint()..shader = linear_600_16
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.screenHeight * 0.01,
                                ),

                                SizedBox(
                                  height: SizeConfig.screenHeight * 0.01,
                                ),

                                //LISTVIEW ADRESS
                                _get_address.response.value.data!.isEmpty
                                    ? const Center(
                                    child: Padding(
                                      padding:
                                      EdgeInsets.only(bottom: 18.0),
                                      child: Text("No Addresses Found"),
                                    ))
                                    : SizedBox(
                                  height:
                                  SizeConfig.screenHeight * 0.6,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                    const BouncingScrollPhysics(),
                                    itemCount: _get_address.response
                                        .value.data!.length,
                                    itemBuilder: (context, index) {
                                      return Obx(() {
                                        return Slidable(
                                          key: const ValueKey(0),
                                          endActionPane: ActionPane(
                                            motion:
                                            const DrawerMotion(),
                                            children: [
                                              SlidableAction(
                                                onPressed:
                                                    (context) async {
                                                  // var locations = await locationFromAddress(
                                                  //     _get_address
                                                  //         .response
                                                  //         .value
                                                  //         .data![
                                                  //     index]
                                                  //         .location
                                                  //         .toString()
                                                  //         .replaceAll(
                                                  //         "\n",
                                                  //         ""));
                                                  Get.to(
                                                      updateaddress(
                                                        passlat: double.parse(
                                                            _get_address
                                                                .response
                                                                .value
                                                                .data![
                                                            index]
                                                                .latitude
                                                                .toString()),
                                                        passlong: double.parse(
                                                            _get_address
                                                                .response
                                                                .value
                                                                .data![
                                                            index]
                                                                .longitude
                                                                .toString()),

                                                        //     passlat: double.parse(locations.toString().replaceAll("\n", "").substring(locations.toString().replaceAll("\n", "").indexOf("Latitude:")+9,locations.toString().indexOf(",")).trim()),
                                                        // passlong: double.parse(locations.toString().replaceAll("\n", "").toString().substring(locations.toString().replaceAll("\n", "").indexOf("Longitude:")+10,locations.toString().replaceAll("\n", "").indexOf("Ti")).replaceAll(",", "").trim()),
                                                        // addid:_get_address.response.value.data![index].id,
                                                        addid: _get_address
                                                            .response
                                                            .value
                                                            .data![
                                                        index]
                                                            .userId,
                                                        buildname: _get_address
                                                            .response
                                                            .value
                                                            .data![
                                                        index]
                                                            .buildingName,
                                                        locname: _get_address
                                                            .response
                                                            .value
                                                            .data![
                                                        index]
                                                            .locality,
                                                        pagename:
                                                        'common',
                                                      ));

                                                  logger.i(
                                                      "homepage page data : below data");
                                                  logger.i(
                                                      "passLattitude--${double.parse(_get_address.response.value.data![index].latitude.toString())}");
                                                  logger.i(
                                                      "passLattitude--${double.parse(_get_address.response.value.data![index].longitude.toString())}");
                                                  // logger.i("addid--${_get_address.response.value.data![index].id}");
                                                  logger.i(
                                                      "addid--${_get_address.response.value.data![index].userId}");
                                                  logger.i(
                                                      "building name--${_get_address.response.value.data![index].buildingName}");
                                                  logger.i(
                                                      "locality--${_get_address.response.value.data![index].locality}");
                                                },
                                                backgroundColor:
                                                common_color
                                                    .withOpacity(
                                                    0.7),
                                                foregroundColor:
                                                Colors.white,
                                                icon: Icons.edit,
                                                label: 'Edit',
                                              ),
                                              SlidableAction(
                                                onPressed:
                                                    (context) async {
                                                  SharedPreferences
                                                  sf =
                                                  await SharedPreferences
                                                      .getInstance();
                                                  setState(() {
                                                    seState(() {
                                                      selcindx =
                                                          index;
                                                      uid = sf.getString(
                                                          "stored_uid");
                                                      print(
                                                          "USER ID ID ${uid.toString()}");
                                                    });
                                                  });

                                                  if (_get_address
                                                      .response
                                                      .value
                                                      .data![
                                                  index]
                                                      .isDefault ==
                                                      "yes") {
                                                    _del_address
                                                        .delete_address_cont(_get_address
                                                        .response
                                                        .value
                                                        .data![
                                                    index]
                                                        .id)
                                                        .then(
                                                            (value) {
                                                          _get_address
                                                              .get_address_cont(
                                                              uid)
                                                              .then(
                                                                  (value) {
                                                                if (_get_address
                                                                    .response
                                                                    .value
                                                                    .data!
                                                                    .isEmpty) {
                                                                  setState(
                                                                          () {
                                                                        seState(
                                                                                () {
                                                                              sf.setString(
                                                                                  "selectedaddressid",
                                                                                  "");
                                                                              selectedadd =
                                                                              "";
                                                                            });
                                                                      });
                                                                } else {
                                                                  setState(
                                                                          () {
                                                                        seState(
                                                                                () {
                                                                              sf.setString(
                                                                                  "selectedaddressid",
                                                                                  _get_address.response.value.data![0].id.toString());
                                                                              selectedadd =
                                                                                  index;
                                                                              _add_default_address.add_default_address(
                                                                                  uid.toString(),
                                                                                  _get_address.addsidlst[0].toString());
                                                                            });
                                                                      });
                                                                }

                                                                seState(() {
                                                                  selcindx =
                                                                  null;
                                                                });
                                                              });
                                                        });
                                                  } else {
                                                    _del_address
                                                        .delete_address_cont(_get_address
                                                        .response
                                                        .value
                                                        .data![
                                                    index]
                                                        .id)
                                                        .then(
                                                            (value) {
                                                          _get_address
                                                              .get_address_cont(
                                                              uid)
                                                              .then(
                                                                  (value) {
                                                                if (_get_address
                                                                    .response
                                                                    .value
                                                                    .data!
                                                                    .isEmpty) {
                                                                  setState(
                                                                          () {
                                                                        seState(
                                                                                () {
                                                                              sf.setString(
                                                                                  "selectedaddressid",
                                                                                  "");
                                                                              selectedadd =
                                                                              "";
                                                                            });
                                                                      });
                                                                } else {
                                                                  setState(
                                                                          () {
                                                                        seState(
                                                                                () {
                                                                              sf.setString(
                                                                                  "selectedaddressid",
                                                                                  _get_address.response.value.data![0].id.toString());
                                                                              selectedadd =
                                                                                  index;
                                                                            });
                                                                      });
                                                                }

                                                                seState(() {
                                                                  selcindx =
                                                                  null;
                                                                });
                                                              });
                                                        });
                                                  }
                                                },
                                                backgroundColor:
                                                Colors.red
                                                    .withOpacity(
                                                    0.7),
                                                foregroundColor:
                                                Colors.white,
                                                icon: Icons.delete,
                                                label: 'Delete',
                                              ),
                                            ],
                                          ),
                                          child: selcindx ==
                                              index &&
                                              _get_address
                                                  .loading.value
                                              ? const CommonIndicator()
                                              : InkWell(
                                            onTap: () async {
                                              SharedPreferences
                                              sf =
                                              await SharedPreferences
                                                  .getInstance();
                                              setState(() {
                                                seState(() {
                                                  sf.setString(
                                                      "selectedaddressid",
                                                      _get_address
                                                          .response
                                                          .value
                                                          .data![index]
                                                          .id
                                                          .toString());
                                                  selectedadd = index;
                                                  Get.back();
                                                });
                                              });
                                              // Navigator.pop(context);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal:
                                                  10,
                                                  vertical:
                                                  10),
                                              decoration:
                                              BoxDecoration(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    5),
                                                border: Border.all(
                                                    color: selectedadd ==
                                                        index
                                                        ? yellow_col.withOpacity(
                                                        0.8)
                                                        : Colors
                                                        .transparent),
                                                color: selectedadd ==
                                                    index
                                                    ? yellow_col
                                                    .withOpacity(
                                                    0.2)
                                                    : Colors
                                                    .transparent,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  SizedBox(
                                                      width: SizeConfig.screenWidth *
                                                          0.9,
                                                      child:
                                                      Text(
                                                        _get_address
                                                            .response
                                                            .value
                                                            .data![index]
                                                            .location
                                                            .toString(),
                                                        style:
                                                        const TextStyle(
                                                          fontSize:
                                                          15,
                                                          fontFamily:
                                                          'Lato',
                                                          color:
                                                          Colors.black,
                                                          fontWeight:
                                                          FontWeight.w400,
                                                          // foreground: Paint()..shader = linear_600_16
                                                        ),
                                                      )),
                                                  SizedBox(
                                                    height: SizeConfig
                                                        .screenHeight *
                                                        0.01,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      const Text(
                                                        "Building Name: ",
                                                        style:
                                                        TextStyle(
                                                          fontSize:
                                                          13,
                                                          fontFamily:
                                                          'Lato',
                                                          color:
                                                          Colors.black,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          // foreground: Paint()..shader = linear_600_16
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          width:
                                                          SizeConfig.screenWidth * 0.6,
                                                          child: Text(_get_address.response.value.data![index].buildingName.toString(),
                                                              style: const TextStyle(
                                                                fontSize: 13,
                                                                fontFamily: 'Lato',
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w400,
                                                                // foreground: Paint()..shader = linear_600_16
                                                              ))),
                                                    ],
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Text(
                                                        "Locality Name: ",
                                                        style:
                                                        font_style.black_600_12,
                                                      ),
                                                      SizedBox(
                                                          width:
                                                          SizeConfig.screenWidth * 0.6,
                                                          child: Text(_get_address.response.value.data![index].locality.toString(),
                                                              style: const TextStyle(
                                                                fontSize: 13,
                                                                fontFamily: 'Lato',
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w400,
                                                                // foreground: Paint()..shader = linear_600_16
                                                              ))),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                    },
                                    separatorBuilder:
                                        (context, index) {
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: SizeConfig
                                                .screenHeight *
                                                0.01),
                                        height: 1,
                                        width:
                                        SizeConfig.screenWidth,
                                        color: line_cont_col,
                                      );
                                    },
                                  ),
                                ),

                                //NOTE
                                _get_address.response.value.data!.isEmpty
                                    ? Container()
                                    : Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.event_note_rounded,
                                        color: yellow_col,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Note: For Edit/Delete your Address Swipe Left..",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Lato',
                                          color: yellow_col,
                                          fontWeight:
                                          FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                      },
                    ),
                  );
                },
              );
            }
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  height: SizeConfig.screenHeight * 0.025,
                  child: SvgPicture.asset(
                    "assets/images/loca_green.svg",
                    fit: BoxFit.scaleDown,
                    color: common_color,
                  )),
              Container(
                  constraints:
                      BoxConstraints(maxWidth: SizeConfig.screenWidth * 0.5),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: uid == null || uid.toString() == ""
                          ? Text(
                              nouseraddress.toString() == "" ||
                                      nouseraddress == null
                                  ? "Add address"
                                  : nouseraddress.toString(),
                              style: font_style.gr27272A_400_14,
                            )
                          : Text(
                              selectedadd == "" || selectedadd == null
                                  ? "Add Address"
                                  : _get_address.response.value
                                          .data?[selectedadd].location ??
                                      '',
                              style: font_style.gr27272A_400_14,
                            ))
                  // Text(_get_address.response.value.data!.isEmpty?"Add Your Address":_get_address.response.value.data![selectedadd].buildingName.toString(),style: font_style.gr27272A_400_14,))
                  ),
              const Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
              )
            ],
          ),
        ),

        //NOTIFICATION ICON
        actions: [
          InkWell(
            onTap: () {
              if (uid != null) {
                Get.to(const notification_page());
              } else {
                Get.offAll(
                    login_page(
                      frompage: 'skip',
                    ),
                    transition: Transition.downToUp);
              }
            },
            child: Padding(
              padding: EdgeInsets.only(right: SizeConfig.screenWidth * 0.05),
              child: SvgPicture.asset(
                "assets/images/green_noti.svg",
                color: common_color,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        return _get_banner.loading.value ||
                isLoading == true ||
                _get_cart.loading.value ||
                _get_allprod.loading.value ||
                _get_testimonials.loading.value
            ? const Center(
                child: CommonIndicator(),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.01,
                    ),

                    //SEARCH TXTFORM
                    Center(
                      child: SizedBox(
                        width: SizeConfig.screenWidth * 0.9,
                        child: TextFormField(
                          controller: searchtxt,
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.zero,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: common_color),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: common_color),
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              hintText: "Search for a Service....",
                              hintStyle: font_style.gr808080_400_14),
                          onChanged: (String query) {
                            final suggestions =
                                _get_allprod.allsearchtxt.where((element) {
                              final exname = element.toString().toLowerCase();
                              final input = query.toString().toLowerCase();
                              return exname.contains(input);
                            }).toList();
                            setState(() => books = suggestions);
                            if (query.isEmpty) {
                              searchtxt.clear();
                            }
                          },
                        ),
                      ),
                    ),
                    (searchtxt.text.isEmpty)
                        ? Container()
                        : books.isNotEmpty?Center(
                            child: Container(
                              height: books.length >= 4
                                  ? SizeConfig.screenHeight * 0.25
                                  : SizeConfig.screenHeight * 0.15,
                              width: SizeConfig.screenWidth * 0.9,
                              margin: const EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: yellow_col)),
                              child: ListView.separated(
                                  scrollDirection: Axis.vertical,
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => searched_details(
                                                        searchedname: _get_allprod
                                                                .catsearchid[
                                                            _get_allprod
                                                                .allsearchtxt
                                                                .indexOf(books[
                                                                        index]
                                                                    .toString())])));
                                            searchtxt.clear();
                                            _get_allprod
                                                .get_all_cat_products_cont();
                                          },
                                          child: Text(books[index].toString())),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return Container(
                                      height: 1,
                                      color: line_cont_col,
                                    );
                                  },
                                  itemCount: books.length),
                            ),
                          ):Container(
                        alignment: Alignment.center,
                        height: SizeConfig.screenHeight * 0.18,
                        width: SizeConfig.screenWidth,
                        child: const Text("Apologies, no services found")),

                    SizedBox(
                      height: SizeConfig.screenHeight * 0.03,
                    ),

                    //SWIPER TOP BANNER
                    _get_banner.topbannerimg.isEmpty
                        ? Container(
                            alignment: Alignment.center,
                            height: SizeConfig.screenHeight * 0.18,
                            width: SizeConfig.screenWidth,
                            child: const Text("No Banners Found"))
                        : Container(
                            height: SizeConfig.screenHeight * 0.18,
                            width: SizeConfig.screenWidth,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8)),
                            child: CarouselSlider(
                              items: List.generate(
                                  _get_banner.topbannerimg.length, (index) {
                                return InkWell(
                                  onTap: () {
                                    _get_allprod.get_all_cat_products_cont();
                                    _get_cart.get_cart_cont(
                                        uid.toString(), _deviceId.toString());
                                    Get.to(all_categories(
                                        cateid:
                                            _get_banner.topbannercatid[index]));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                            image: NetworkImage(_get_banner
                                                .topbannerimg[index]
                                                .toString()),
                                            fit: BoxFit.cover
                                            // image: AssetImage(swiper_img[index].toString()),fit: BoxFit.cover
                                            )),
                                  ),
                                );
                              }),
                              carouselController: _controller,
                              options: CarouselOptions(
                                  autoPlay: _get_banner.topbannerimg.length>1?true:false,
                                  viewportFraction: 0.9,
                                  enlargeCenterPage: true,
                                  scrollDirection: Axis.horizontal,
                                  reverse: false,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  }),
                            ),
                          ),
                    _get_banner.topbannerimg.length>1?Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          _get_banner.topbannerimg.asMap().entries.map((entry) {
                        return InkWell(
                          onTap: () => _controller.animateToPage(entry.key),
                          child: Container(
                            width: _current == entry.key ? 22 : 7.0,
                            height: 7.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                                borderRadius: _current == entry.key
                                    ? BorderRadius.circular(20)
                                    : BorderRadius.circular(100),
                                color: _current == entry.key
                                    ? common_color
                                    : const Color(0xff999999)),
                          ),
                        );
                      }).toList(),
                    ):SizedBox(),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.014,
                    ),

                    //SERVICE CATEGORY TXT
                    Center(
                      child: InkWell(
                        onTap: () {},
                        child: SizedBox(
                          width: SizeConfig.screenWidth * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // SvgPicture.asset("assets/images/leaf_green.svg",color: newLightColor),
                              // SizedBox(
                              //   width: SizeConfig.screenWidth * 0.02,
                              // ),
                              Text('Service Categories',
                                  style: font_style.grad2_600_16
                                      .copyWith(color: Colors.black)),
                              // SizedBox(
                              //   width: SizeConfig.screenWidth * 0.02,
                              // ),
                              // SvgPicture.asset("assets/images/leaf_yellow.svg",color: common_color),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),

                    //GRIDVIEW
                    Center(
                      child: SizedBox(
                        width: SizeConfig.screenWidth * 0.9,
                        child: GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          childAspectRatio: 0.9,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          children: List.generate(
                              (_get_allprod.response.value.data?.length ?? 0) >=
                                      6
                                  ? 6
                                  : _get_allprod.response.value.data?.length ??
                                      0, (index) {
                            return _get_allprod.response.value.data![index]
                                    .serviceCategoryData!.isEmpty
                                ? const SizedBox(
                                    width: 0,
                                  )
                                : InkWell(
                                    onTap: () {
                                      _get_cart.prodid.clear();
                                      _get_cart
                                          .get_cart_cont(
                                              uid.toString() == "" ||
                                                      uid == null
                                                  ? ""
                                                  : uid.toString(),
                                              _deviceId)
                                          .then((value) {
                                        Get.to(all_categories(
                                            cateid: _get_allprod
                                                .response.value.data![index].id
                                                .toString()));
                                      });
                                      _get_allprod.get_all_cat_products_cont();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          image: DecorationImage(
                                            image: NetworkImage(_get_allprod
                                                .response
                                                .value
                                                .data![index]
                                                .image
                                                .toString()),
                                            // image: AssetImage(swiper_img[index].toString()),
                                            fit: BoxFit.fill,
                                          )),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          //35% OFFF
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 7),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    6),
                                                            topRight:
                                                                Radius.circular(
                                                                    6)),
                                                    color: common_color),
                                                child: Text(
                                                  _get_allprod.response.value
                                                      .data![index].blades
                                                      .toString(),
                                                  style:
                                                      font_style.white_600_12,
                                                ),
                                              )
                                            ],
                                          ),

                                          //TXT GREEN CONT
                                          Container(
                                            height:
                                                SizeConfig.screenHeight * 0.04,
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(6),
                                                    bottomRight:
                                                        Radius.circular(6))),
                                            child: SizedBox(
                                                width: SizeConfig.screenWidth *
                                                    0.25,
                                                child: Text(
                                                  _get_allprod.response.value
                                                      .data![index].name
                                                      .toString(),
                                                  style: font_style.white_500_12
                                                      .copyWith(
                                                          color: Colors.black),
                                                  textAlign: TextAlign.center,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                          }),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.012,
                    ),

                    //SEE ALL CONT
                    Center(
                      child: Container(
                        alignment: Alignment.center,
                        width: SizeConfig.screenWidth * 0.9,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(),
                            InkWell(
                              onTap: () {

                                Get.offAll(const BottomBar(
                                  pasindx: 2,
                                ));
                                // _get_testimonials.get_testimonials_cont(uid.toString()).then((value) {
                                //   _get_testimonials.yturl;
                                // });
                                // _get_banner.get_banner_cont();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: common_color),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "See All",
                                      style: font_style.yell_400_16
                                          .copyWith(color: Colors.white),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container()
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),

                    //GREEN YELLOW CONTAINER  MIDDLE BANNER
                    _get_banner.middlebannerimg.isEmpty
                        ? Container(
                            alignment: Alignment.center,
                            height: SizeConfig.screenHeight * 0.18,
                            width: SizeConfig.screenWidth,
                            child: const Text("No Banners Found"))
                        : Container(
                            height: SizeConfig.screenHeight * 0.18,
                            width: SizeConfig.screenWidth,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8)),
                            child: CarouselSlider(
                              items: List.generate(
                                  _get_banner.middlebannerimg.length,
                                  (midbanindex) {
                                return InkWell(
                                  onTap: () {
                                    Get.to(all_categories(
                                        cateid: _get_banner
                                            .middlebannercatid[midbanindex]));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                            image: NetworkImage(_get_banner
                                                .middlebannerimg[midbanindex]
                                                .toString()),
                                            fit: BoxFit.cover
                                            // image: AssetImage(swiper_img[index].toString()),fit: BoxFit.cover
                                            )),
                                  ),
                                );
                              }),
                              carouselController: _middlecontroller,
                              options: CarouselOptions(
                                  autoPlay: _get_banner.middlebannerimg.length>1?true:false,
                                  viewportFraction: 0.9,
                                  enlargeCenterPage: true,
                                  scrollDirection: Axis.horizontal,
                                  reverse: false,
                                  onPageChanged: (midbanindex, reason) {
                                    setState(() {
                                      _middlecurrent = midbanindex;
                                    });
                                  }),
                            ),
                          ),
                    _get_banner.middlebannerimg.length>1?Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _get_banner.middlebannerimg
                          .asMap()
                          .entries
                          .map((entry) {
                        return InkWell(
                          onTap: () =>
                              _middlecontroller.animateToPage(entry.key),
                          child: Container(
                            width: _middlecurrent == entry.key ? 22 : 7.0,
                            height: 7.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                                borderRadius: _middlecurrent == entry.key
                                    ? BorderRadius.circular(20)
                                    : BorderRadius.circular(100),
                                color: _middlecurrent == entry.key
                                    ? yellow_col
                                    : Colors.grey),
                          ),
                        );
                      }).toList(),
                    ):SizedBox(),

                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),

                    //TESTIMONIALS TXT
                    uid == null
                        ? Container()
                        : Center(
                            child: SizedBox(
                                width: SizeConfig.screenWidth * 0.9,
                                child: Text(
                                  "Testimonials",
                                  style: font_style.black_600_16,
                                )),
                          ),

                    SizedBox(
                      height: SizeConfig.screenHeight * 0.013,
                    ),

                    //TESTIMONIAL VIDEOS LISTVIEW
                    uid == null
                        ? Container()
                        : Obx(() {
                            return _get_testimonials.loading.value
                                ? const CommonIndicator()
                                : Padding(
                                    padding: EdgeInsets.only(
                                        left: SizeConfig.screenWidth * 0.00),
                                    child: SizedBox(
                                      height: SizeConfig.screenHeight * 0.18,
                                      width: SizeConfig.screenWidth,
                                      child: ListView.separated(
                                        padding: EdgeInsets.only(
                                            left: SizeConfig.screenWidth * 0.05,
                                            right:
                                                SizeConfig.screenWidth * 0.05),
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            _get_testimonials.yturl.length,
                                        itemBuilder: (context, index) {
                                          if (lYTC.isNotEmpty) {
                                            YoutubePlayerController
                                                _ytController = lYTC[index];
                                          }

                                          String _id =
                                              YoutubePlayer.convertUrlToId(
                                                  _get_testimonials
                                                      .yturl[index])!;
                                          String curState = 'undefined';
                                          if (cStates[_id] != null) {
                                            curState = cStates[_id]
                                                ? 'playing'
                                                : 'paused';
                                          }
                                          return InkWell(
                                            onTap: () {
                                              _get_testimonials
                                                      .video_controller_y =
                                                  YoutubePlayerController(
                                                initialVideoId:
                                                    _get_testimonials
                                                        .vid_d[index]
                                                        .toString(),
                                                flags: const YoutubePlayerFlags(
                                                    autoPlay: true, loop: true),
                                              );
                                              Get.to(youtube_video(
                                                controller_y: _get_testimonials
                                                    .video_controller_y!,
                                              ));
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              width:
                                                  SizeConfig.screenWidth * 0.6,
                                              height: SizeConfig.screenHeight *
                                                  0.18,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: yellow_col,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          _get_testimonials
                                                              .response
                                                              .value
                                                              .data![index]
                                                              .thumbnail
                                                              .toString()),
                                                      fit: BoxFit.fill)),
                                              child: const Icon(
                                                Icons.play_arrow,
                                                color: Colors.white,
                                                size: 40,
                                              ),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            width:
                                                SizeConfig.screenWidth * 0.04,
                                          );
                                        },
                                      ),
                                    ),
                                  );
                          }),

                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),

                    //OFFERS TXT
                    Center(
                      child: SizedBox(
                          width: SizeConfig.screenWidth * 0.9,
                          child: Text(
                            "Offers",
                            style: font_style.black_600_16,
                          )),
                    ),

                    SizedBox(
                      height: SizeConfig.screenHeight * 0.013,
                    ),

                    //LISTVIEW   OFFER BANNER
                    _get_banner.offerbannerimg.isEmpty
                        ? Container(
                            alignment: Alignment.center,
                            height: SizeConfig.screenHeight * 0.18,
                            width: SizeConfig.screenWidth,
                            child: const Text("No Banners Found"))
                        : Container(
                            height: SizeConfig.screenHeight * 0.18,
                            width: SizeConfig.screenWidth,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8)),
                            child: _get_banner.offerbannerimg.isEmpty
                                ? const Text("No Banners Found")
                                : CarouselSlider(
                                    items: List.generate(
                                        _get_banner.offerbannerimg.length,
                                        (offerbanindex) {
                                      return InkWell(
                                        onTap: () {
                                          Get.to(all_categories(
                                              cateid:
                                                  _get_banner.offermbannercatid[
                                                      offerbanindex]));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      _get_banner
                                                          .offerbannerimg[
                                                              offerbanindex]
                                                          .toString()),
                                                  fit: BoxFit.cover
                                                  // image: AssetImage(swiper_img[index].toString()),fit: BoxFit.cover
                                                  )),
                                        ),
                                      );
                                    }),
                                    carouselController: _offercontroller,
                                    options: CarouselOptions(
                                        autoPlay: _get_banner.offerbannerimg.length>1?true:false,
                                        viewportFraction: 0.9,
                                        enlargeCenterPage: true,
                                        scrollDirection: Axis.horizontal,
                                        reverse: false,
                                        onPageChanged: (offerbanindex, reason) {
                                          setState(() {
                                            _offerbannercurrent = offerbanindex;
                                          });
                                        }),
                                  ),
                          ),
                    _get_banner.offerbannerimg.length>1?Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _get_banner.offerbannerimg
                          .asMap()
                          .entries
                          .map((entry) {
                        return InkWell(
                          onTap: () =>
                              _offercontroller.animateToPage(entry.key),
                          child: Container(
                            width: _offerbannercurrent == entry.key ? 22 : 7.0,
                            height: 7.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                                borderRadius: _offerbannercurrent == entry.key
                                    ? BorderRadius.circular(20)
                                    : BorderRadius.circular(100),
                                color: _offerbannercurrent == entry.key
                                    ? yellow_col
                                    : Colors.grey),
                          ),
                        );
                      }).toList(),
                    ):SizedBox(),
                    // Padding(
                    //   padding:  EdgeInsets.only(left: SizeConfig.screenWidth*0.05),
                    //   child: Container(
                    //     height: SizeConfig.screenHeight*0.15,
                    //     width: SizeConfig.screenWidth,
                    //     child: ListView.separated(
                    //       shrinkWrap: true,
                    //       scrollDirection: Axis.horizontal,
                    //       itemCount: 2,
                    //       itemBuilder: (context, index) {
                    //         return Container(
                    //           height: SizeConfig.screenHeight*0.15,
                    //           width: SizeConfig.screenWidth*0.7,
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(8),
                    //           ),
                    //           child: Row(
                    //             children: [
                    //
                    //               //GREEN CONTAINER
                    //               Stack(
                    //                 children:[
                    //
                    //                   Container(
                    //                     padding: EdgeInsets.only(left: SizeConfig.screenWidth*0.03,top: SizeConfig.screenHeight*0.02,bottom: SizeConfig.screenHeight*0.02),
                    //                     width: SizeConfig.screenWidth*0.4,
                    //                     decoration: BoxDecoration(
                    //                         borderRadius: BorderRadius.only(topLeft: Radius.circular(8),bottomLeft: Radius.circular(8)),
                    //                         color: common_color
                    //                     ),
                    //                     child: Column(
                    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                       crossAxisAlignment: CrossAxisAlignment.start,
                    //                       children: [
                    //                         //SAVE UTP TXT
                    //                         Container(
                    //                             alignment: Alignment.centerLeft,
                    //                             width: SizeConfig.screenWidth*0.35,
                    //                             child: Text("Save upto 25% on 1st Entry",style: font_style.white_500_14,)
                    //                         ),
                    //
                    //                         Spacer(),
                    //                         //CHECK OUT CONT
                    //                         Row(
                    //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                           children: [
                    //                             Container(
                    //                               padding: EdgeInsets.symmetric(horizontal: 6,vertical: 5),
                    //                               decoration: BoxDecoration(
                    //                                   border:Border.all(color: Colors.white),
                    //                                   borderRadius: BorderRadius.circular(20)
                    //                               ),
                    //                               child: Row(
                    //                                 children: [
                    //                                   Text("Check Out",style: font_style.white_500_14,),
                    //                                   Icon(Icons.keyboard_arrow_right_outlined,color: Colors.white,)
                    //                                 ],
                    //                               ),
                    //                             ),
                    //                             Container()
                    //                           ],
                    //                         )
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   Positioned(
                    //                       bottom: SizeConfig.screenHeight*0.01,
                    //                       left: SizeConfig.screenWidth*0.3,
                    //                       child: Container(
                    //                           height: SizeConfig.screenHeight*0.015,
                    //                           width: SizeConfig.screenWidth*0.09,
                    //                           child: SvgPicture.asset("assets/images/lest_star.svg"))
                    //                   ),
                    //                   Positioned(
                    //                     top: SizeConfig.screenHeight*0.03,
                    //                     left: SizeConfig.screenWidth*0.35,
                    //                     child: Container(
                    //                         height: SizeConfig.screenHeight*0.015,
                    //                         width: SizeConfig.screenWidth*0.03,
                    //                         child: Image(image:AssetImage( "assets/images/star.png" ),fit: BoxFit.fill,)),
                    //                   ),
                    //                 ] ,
                    //               ),
                    //               Container(
                    //                 width: SizeConfig.screenWidth*0.3,
                    //                 decoration: BoxDecoration(
                    //                     borderRadius: BorderRadius.only(topRight: Radius.circular(8),bottomRight: Radius.circular(8)),
                    //                     gradient: LinearGradient(
                    //                         colors: [
                    //                           yellow_col,
                    //                           Colors.yellow
                    //                         ],
                    //                         begin: Alignment.topRight,
                    //                         end: Alignment.bottomLeft
                    //                     ),
                    //                     image: DecorationImage(
                    //                         image: AssetImage("assets/images/facialmast_cont_home.png"),
                    //                         fit: BoxFit.cover
                    //                     )
                    //                 ),
                    //               )
                    //             ],
                    //           ),
                    //         );
                    //       },
                    //       separatorBuilder: (context, index) {
                    //         return SizedBox(width: SizeConfig.screenWidth*0.04,);
                    //       },
                    //
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),

                    //Our Safety Standards
                    Center(
                      child: SizedBox(
                          width: SizeConfig.screenWidth * 0.9,
                          child: Row(
                            children: [
                              Text(
                                "Our Safety Standards",
                                style: font_style.black_600_16,
                              ),
                              const Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.screenWidth * 0.04,
                                    vertical: SizeConfig.screenHeight * 0.005),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(19),
                                    color: common_color),
                                child: Row(
                                  children: [
                                    Text(
                                      "HG SAFE",
                                      style: font_style.black_600_12
                                          .copyWith(color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: SizeConfig.screenWidth * 0.015,
                                    ),
                                    SvgPicture.asset(
                                        "assets/images/hg_safe.svg",
                                        color: Colors.white),
                                  ],
                                ),
                              )
                            ],
                          )),
                    ),

                    SizedBox(
                      height: SizeConfig.screenHeight * 0.013,
                    ),

                    //SAFETY LISTVIEW
                    Padding(
                      padding:
                          EdgeInsets.only(left: SizeConfig.screenWidth * 0.05),
                      child: SizedBox(
                        height: SizeConfig.screenHeight * 0.11,
                        width: SizeConfig.screenWidth,
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: safety_img.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: SizeConfig.screenWidth * 0.2,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: common_color)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: SizeConfig.screenHeight * 0.05,
                                    width: SizeConfig.screenWidth * 0.18,
                                    child: Image.asset(safety_img[index],
                                        color: common_color,
                                        fit: BoxFit.contain),
                                  ),
                                  Container(
                                      alignment: Alignment.center,
                                      width: SizeConfig.screenWidth * 0.25,
                                      child: Text(
                                        safety_title[index].toString(),
                                        style: font_style.yell_400_10
                                            .copyWith(color: common_color),
                                        textAlign: TextAlign.center,
                                      )),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              width: SizeConfig.screenWidth * 0.04,
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),

                    //PROFESSIONAL CONT BOTTOM BANNER
                    _get_banner.bottombannerimg.isEmpty
                        ? Container(
                            alignment: Alignment.center,
                            height: SizeConfig.screenHeight * 0.18,
                            width: SizeConfig.screenWidth,
                            child: const Text("No Banners Found"))
                        : Container(
                            height: SizeConfig.screenHeight * 0.18,
                            width: SizeConfig.screenWidth,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8)),
                            child: CarouselSlider(
                              items: List.generate(
                                  _get_banner.bottombannerimg.length,
                                  (botbanindex) {
                                return InkWell(
                                  onTap: () {
                                    Get.to(all_categories(
                                        cateid: _get_banner
                                            .bottombannercatid[botbanindex]));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                            image: NetworkImage(_get_banner
                                                .bottombannerimg[botbanindex]
                                                .toString()),
                                            fit: BoxFit.cover)),
                                  ),
                                );
                              }),
                              carouselController: _bottomcontroller,
                              options: CarouselOptions(
                                  autoPlay: _get_banner.bottombannerimg.length>1?true:false,
                                  viewportFraction: 0.9,
                                  enlargeCenterPage: true,
                                  scrollDirection: Axis.horizontal,
                                  reverse: false,
                                  onPageChanged: (botbanindex, reason) {
                                    setState(() {
                                      _bottombannercurrent = botbanindex;
                                    });
                                  }),
                            ),
                          ),
                    _get_banner.bottombannerimg.length>1?Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _get_banner.bottombannerimg
                          .asMap()
                          .entries
                          .map((entry) {
                        return InkWell(
                          onTap: () =>
                              _bottomcontroller.animateToPage(entry.key),
                          child: Container(
                            width: _bottombannercurrent == entry.key
                                ? Get.width * 0.05
                                : Get.width * 0.02,
                            height: 7.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                                borderRadius:
                                    _bottombannercurrent == entry.key
                                        ? BorderRadius.circular(20)
                                        : BorderRadius.circular(100),
                                color: _bottombannercurrent == entry.key
                                    ? yellow_col
                                    : Colors.grey),
                          ),
                        );
                      }).toList(),
                    ).paddingSymmetric(horizontal: Get.width * 0.05):SizedBox(),

                    // Center(
                    //   child: ClipRRect(
                    //     borderRadius: BorderRadius.circular(8),
                    //     child: Container(
                    //       height: SizeConfig.screenHeight*0.18,
                    //         width: SizeConfig.screenWidth*0.9,
                    //         decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(8),
                    //           color: common_color
                    //         ),
                    //         child: Stack(
                    //           alignment: Alignment.centerRight,
                    //           children:[
                    //             //CIRCLE YELLOW
                    //             Positioned(
                    //               left: SizeConfig.screenWidth*0.5,
                    //               child: Container(
                    //                 height: SizeConfig.screenHeight*0.9,
                    //                 width: SizeConfig.screenWidth*0.6,
                    //                 decoration: BoxDecoration(
                    //                     shape: BoxShape.circle,
                    //                     gradient: RadialGradient(
                    //                         center: Alignment.centerLeft,
                    //                         colors: [
                    //                           Color(0xffBF8D2C),
                    //                           Color(0xffDBE466),
                    //                         ],
                    //                         radius: 1
                    //                     )
                    //                     // color: yellow_col
                    //                 ),
                    //               ),
                    //             ),
                    //
                    //             //PROFEESIONAL IMAGE
                    //             Positioned (
                    //               bottom: -1,
                    //               right:  SizeConfig.screenWidth*0.00,
                    //               child: Container(
                    //                 height: SizeConfig.screenHeight*0.18,
                    //                 width: SizeConfig.screenWidth*0.52,
                    //                 decoration: BoxDecoration(
                    //                     image: DecorationImage(
                    //                         image: AssetImage("assets/images/cartified_trained_img.png"),
                    //                         fit: BoxFit.fill
                    //                     )
                    //                 ),
                    //               ),
                    //             ),
                    //             Positioned(
                    //               left: SizeConfig.screenWidth*0.05,
                    //               child: Column(
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                 children: [
                    //                   Container(
                    //                     height: SizeConfig.screenHeight*0.07,
                    //                     width: SizeConfig.screenWidth*0.14,
                    //                     decoration: BoxDecoration(
                    //                         shape: BoxShape.circle,
                    //                         image: DecorationImage(
                    //                             image: AssetImage("assets/images/bws_logo.png"),
                    //                             fit: BoxFit.cover
                    //                         )
                    //                     ),
                    //
                    //                   ),
                    //                   SizedBox(height: SizeConfig.screenHeight*0.01,),
                    //                   Container(
                    //                       width: SizeConfig.screenWidth*0.3,
                    //                       child: Text("Certified & Trained Professionals",style: font_style.white_600_12,)),
                    //                 ],
                    //               ),
                    //             ),
                    //
                    //           ]
                    //         )
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),
                  ],
                ),
              );
      }),
    );
  }
}

class Indicator extends StatelessWidget {
  final bool isActive;

  Indicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: isActive == true ? 22 : 10,
      decoration: BoxDecoration(
          borderRadius: isActive == true
              ? BorderRadius.circular(5)
              : BorderRadius.circular(30),
          color: isActive == true ? yellow_col : Colors.grey),
    );
  }
}
