import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hairgarden/auth/Screens/login_page.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import '../../../COMMON/common_circular_indicator.dart';
import '../../../COMMON/size_config.dart';
import '../../address/Controller/add_default_address_controller.dart';
import '../../address/Controller/delete_address_controller.dart';
import '../../address/Controller/get_address_controller.dart';
import '../../common/common_address_bottom.dart';
import '../../common/common_txt_list.dart';
import 'dart:io';
import '../../../COMMON/common_color.dart';
import '../../common/drawer.dart';
import '../../home/Controller/get_all_category_controller.dart';
import '../../home/Controller/get_banner_controller.dart';
import '../../home/Controller/get_testimonials_controller.dart';
import '../../home/Screens/searched_details.dart';
import '../../myprofile/Controller/get_profile_info_controller.dart';
import '../../newmap1.dart';
import '../../notification/Screens/notification_page.dart';
import '../../updatemap.dart';
import '../Controller/get_all_cat_products_controller.dart';
import '../Controller/get_cart_controller.dart';
import 'all_categories.dart';

class category extends StatefulWidget {
  const category({Key? key}) : super(key: key);

  @override
  State<category> createState() => _categoryState();
}

class _categoryState extends State<category> {
  final _get_banner = Get.put(get_banner_controller());
  int _current = 0;
  final CarouselController _controller = CarouselController();

  final _get_allprod = Get.put(get_all_cat_products_controller());
  final _get_testimonials = Get.put(get_testimonials_controller());
  final _get_prof = Get.put(get_profile_info_controller());
  final _get_address = Get.put(get_address_controller());
  final _del_address = Get.put(delete_address_controller());
  final _add_default_address = Get.put(add_default_address_controller());
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

  getuserid() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    uid = sf.getString("stored_uid");
    sp_refercode = sf.getString("sp_refercode");
    _get_prof.get_profile_info_cont(uid).then(
        (value) => wallet = _get_prof.response.value.data?.wallet.toString());
    setState(() {});
  }

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

  var selectedadd;
  var getadd;

  getselectedaddress() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    getuserid();
    setState(() {
      if (_get_address.response.value.data?.isEmpty ?? false) {
        selectedadd = "";
      } else {
        getadd = sf.getString("selectedaddressid");
        if (getadd == "" || getadd == null) {
          sf.setString("selectedaddressid", _get_address.defaultaddid ?? "");
          setState(() {
            selectedadd =
                _get_address.addsidlst.indexOf(_get_address.defaultaddid);
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

  @override
  void initState() {
    _get_banner.get_banner_cont();
    // _get_allprod.get_all_cat_products_cont();
    getuserid();
    getplatform();
    getselectedaddress();
    initPlatformState();
    _get_testimonials.get_testimonials_cont(uid.toString()).then((value) {
      _get_testimonials.yturl;
    });
    setState(() {
      books = _get_allprod.allsearchtxt as List;
    });
    super.initState();
  }

  List books = [];

  TextEditingController searchtxt = TextEditingController();

  var scaffoldKey1 = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey1,
      backgroundColor: bg_col,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              scaffoldKey1.currentState?.openDrawer();
            },
            child: SvgPicture.asset(
              "assets/images/home_menu.svg",
              fit: BoxFit.scaleDown,
            )),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                height: SizeConfig.screenHeight * 0.025,
                child: SvgPicture.asset("assets/images/loca_green.svg",
                    fit: BoxFit.scaleDown, color: common_color)),
            InkWell(
                onTap: () async {
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
                              var selcindx;
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
                                                              var locations = await locationFromAddress(
                                                                  _get_address
                                                                      .response
                                                                      .value
                                                                      .data![
                                                                          index]
                                                                      .location
                                                                      .toString()
                                                                      .replaceAll(
                                                                          "\n",
                                                                          ""));
                                                              Get.to(
                                                                  updateaddress(
                                                                passlat: double.parse(locations
                                                                    .toString()
                                                                    .replaceAll(
                                                                        "\n",
                                                                        "")
                                                                    .substring(
                                                                        locations.toString().replaceAll("\n", "").indexOf("Latitude:") +
                                                                            9,
                                                                        locations
                                                                            .toString()
                                                                            .indexOf(","))
                                                                    .trim()),
                                                                passlong: double.parse(locations
                                                                    .toString()
                                                                    .replaceAll(
                                                                        "\n",
                                                                        "")
                                                                    .toString()
                                                                    .substring(
                                                                        locations.toString().replaceAll("\n", "").indexOf("Longitude:") +
                                                                            10,
                                                                        locations
                                                                            .toString()
                                                                            .replaceAll("\n",
                                                                                "")
                                                                            .indexOf(
                                                                                "Ti"))
                                                                    .replaceAll(
                                                                        ",", "")
                                                                    .trim()),
                                                                addid: _get_address
                                                                    .response
                                                                    .value
                                                                    .data![
                                                                        index]
                                                                    .id,
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
                                                                    selectedadd =
                                                                        index;
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
                child: Container(
                    constraints:
                        BoxConstraints(maxWidth: SizeConfig.screenWidth * 0.5),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: uid == null || uid.toString() == ""
                            ? Text(
                                "Login to add address",
                                style: font_style.gr27272A_400_14,
                              )
                            : Text(
                                selectedadd == "" || selectedadd == null
                                    ? "Add Address"
                                    : _get_address.response.value
                                        .data![selectedadd].location
                                        .toString(),
                                style: font_style.gr27272A_400_14,
                              ))
                    // Text(_get_address.response.value.data!.isEmpty?"Add Your Address":_get_address.response.value.data![selectedadd].buildingName.toString(),style: font_style.gr27272A_400_14,))
                    )),
            const Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
            )
          ],
        ),

        //NOTIFICATION ICON
        actions: [
          Padding(
            padding: EdgeInsets.only(right: SizeConfig.screenWidth * 0.05),
            child: InkWell(
                onTap: () {
                  Get.to(const notification_page());
                },
                child: SvgPicture.asset("assets/images/green_noti.svg",
                    color: common_color)),
          ),
        ],
      ),
      drawer: drawer(uid: uid, wallet: wallet, sp_refercode: sp_refercode),
      body: Obx(() {
        return _get_allprod.loading.value || _get_banner.loading.value
            ? const Center(
                child: CommonIndicator(),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
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
                              final exname = element.toString();
                              final input = query.toString();
                              return exname.contains(input);
                            }).toList();
                            setState(() => books = suggestions);
                          },
                        ),
                      ),
                    ),
                    searchtxt.text.length == 0
                        ? Container()
                        : Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: books.length >= 4
                                      ? SizeConfig.screenHeight * 0.15
                                      : null,
                                  width: SizeConfig.screenWidth * 0.9,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(8),
                                          bottomRight: Radius.circular(8)),
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
                                                _get_allprod
                                                    .get_all_cat_products_cont();
                                              },
                                              child: Text(
                                                  books[index].toString())),
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
                              ],
                            ),
                          ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.03,
                    ),

                    //CATEGORIES TXT
                    Center(
                      child: SizedBox(
                        width: SizeConfig.screenWidth * 0.9,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // SvgPicture.asset("assets/images/leaf_green.svg",color: newLightColor),
                            // SizedBox(width: SizeConfig.screenWidth*0.02,),
                            Text('Service Categories',
                                style: font_style.grad2_600_16
                                    .copyWith(color: Colors.black)),
                            SizedBox(
                              width: SizeConfig.screenWidth * 0.02,
                            ),
                            // SvgPicture.asset("assets/images/leaf_yellow.svg",color: common_color),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),

                    //GRID VIEW
                    Center(
                      child: SizedBox(
                        width: SizeConfig.screenWidth * 0.9,
                        child: GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          childAspectRatio: 1,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          children: List.generate(
                              _get_allprod.response.value.data?.length ?? 0,
                              (index) {
                            return _get_allprod.response.value.data![index]
                                    .serviceCategoryData!.isEmpty
                                ? const SizedBox(
                                    width: 0,
                                  )
                                : InkWell(
                                    onTap: () {
                                      cart.clear();
                                      totprod.clear();

                                      Get.to(all_categories(
                                        cateid: _get_allprod
                                            .response.value.data![index].id
                                            .toString(),
                                      ));
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
                                                        horizontal: 4),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    6)),
                                                    color: common_color),
                                                child: Text(
                                                  "35% OFF",
                                                  style:
                                                      font_style.white_400_10,
                                                ),
                                              )
                                            ],
                                          ),

                                          //TXT GREEN CONT
                                          Container(
                                            height:
                                                SizeConfig.screenHeight * 0.037,
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
                                                          color: common_color),
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
                      height: SizeConfig.screenHeight * 0.025,
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

                    //PROFESSIONAL CONT

                    _get_banner.catbottombannerimg.isEmpty
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
                                  _get_banner.catbottombannerimg.length,
                                  (index) {
                                return InkWell(
                                  onTap: () {
                                    Get.to(all_categories(
                                        cateid: _get_banner
                                            .catbottombannercatid[index]));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                            image: NetworkImage(_get_banner
                                                .catbottombannerimg![index]
                                                .toString()),
                                            fit: BoxFit.cover
                                            // image: AssetImage(swiper_img[index].toString()),fit: BoxFit.cover
                                            )),
                                  ),
                                );
                              }),
                              carouselController: _controller,
                              options: CarouselOptions(
                                  autoPlay: true,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _get_banner.catbottombannerimg
                          .asMap()
                          .entries
                          .map((entry) {
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
                                    ? yellow_col
                                    : Colors.grey),
                          ),
                        );
                      }).toList(),
                    ),
                    // Center(
                    //   child: ClipRRect(
                    //     borderRadius: BorderRadius.circular(8),
                    //     child: Container(
                    //         height: SizeConfig.screenHeight*0.18,
                    //         width: SizeConfig.screenWidth*0.9,
                    //         decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(8),
                    //             color: common_color
                    //         ),
                    //         child: Stack(
                    //             alignment: Alignment.centerRight,
                    //             children:[
                    //               //CIRCLE YELLOW
                    //               Positioned(
                    //                 left: SizeConfig.screenWidth*0.5,
                    //                 child: Container(
                    //                   height: SizeConfig.screenHeight*0.9,
                    //                   width: SizeConfig.screenWidth*0.6,
                    //                   decoration: BoxDecoration(
                    //                       shape: BoxShape.circle,
                    //                       gradient: RadialGradient(
                    //                           center: Alignment.centerLeft,
                    //                           colors: [
                    //                             Color(0xffBF8D2C),
                    //                             Color(0xffDBE466),
                    //                           ],
                    //                           radius: 1
                    //                       )
                    //                     // color: yellow_col
                    //                   ),
                    //                 ),
                    //               ),
                    //
                    //               //PROFEESIONAL IMAGE
                    //               Positioned (
                    //                 bottom: -1,
                    //                 right:  SizeConfig.screenWidth*0.00,
                    //                 child: Container(
                    //                   height: SizeConfig.screenHeight*0.18,
                    //                   width: SizeConfig.screenWidth*0.52,
                    //                   decoration: BoxDecoration(
                    //                       image: DecorationImage(
                    //                           image: AssetImage("assets/images/cartified_trained_img.png"),
                    //                           fit: BoxFit.fill
                    //                       )
                    //                   ),
                    //                 ),
                    //               ),
                    //               Positioned(
                    //                 left: SizeConfig.screenWidth*0.05,
                    //                 child: Column(
                    //                   mainAxisAlignment: MainAxisAlignment.center,
                    //                   crossAxisAlignment: CrossAxisAlignment.start,
                    //                   children: [
                    //                     Container(
                    //                       height: SizeConfig.screenHeight*0.07,
                    //                       width: SizeConfig.screenWidth*0.14,
                    //                       decoration: BoxDecoration(
                    //                           shape: BoxShape.circle,
                    //                           image: DecorationImage(
                    //                               image: AssetImage("assets/images/bws_logo.png"),
                    //                               fit: BoxFit.cover
                    //                           )
                    //                       ),
                    //
                    //                     ),
                    //                     SizedBox(height: SizeConfig.screenHeight*0.01,),
                    //                     Container(
                    //                         width: SizeConfig.screenWidth*0.3,
                    //                         child: Text("Certified & Trained Professionals",style: font_style.white_600_12,)),
                    //                   ],
                    //                 ),
                    //               ),
                    //
                    //             ]
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
