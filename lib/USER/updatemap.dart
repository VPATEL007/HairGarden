import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:hairgarden/USER/bottombar/Screens/bottombar.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../COMMON/common_circular_indicator.dart';
import '../COMMON/common_color.dart';
import '../COMMON/size_config.dart';
import 'address/Controller/edit_address_controller.dart';
import 'address/Controller/get_address_controller.dart';
import 'enable_location/Controller/add_address_controller.dart';
import 'home/Controller/get_testimonials_controller.dart';

var logger = Logger();

class updateaddress extends StatefulWidget {
  double? passlat, passlong;
  String? addid, buildname, locname, pagename;

  updateaddress(
      {required this.passlat,
      required this.passlong,
      required this.addid,
      required this.buildname,
      required this.locname,
      required this.pagename});

  @override
  State<updateaddress> createState() => _updateaddressState();
}

class _updateaddressState extends State<updateaddress> {
  PickResult? selectedPlace;
  bool _showPlacePickerInContainer = false;
  bool _showGoogleMapInContainer = false;

  bool _mapsInitialized = false;
  String _mapsRenderer = "latest";
  double? lat;
  double? long;
  String? uid;
  bool _isclicked = true;

  final _text = TextEditingController();

  TextEditingController updbuildname = TextEditingController();
  TextEditingController updlocaname = TextEditingController();
  TextEditingController updpincode = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Future<void> getCurruntLocation() async {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    await Geolocator.getCurrentPosition().then((value) async {
      List<Placemark> locations =
          await placemarkFromCoordinates(value.latitude, value.longitude);
      setState(() {
        _text.text = locations[0].name.toString() +
            ", " +
            locations[0].locality.toString() +
            ", " +
            locations[0].country.toString();
        // setpincode=locations[0].postalCode.toString();
        lat = value.latitude;
        long = value.longitude;
        // center = LatLng(double.parse(lat.toString()), double.parse(long.toString()));
      });
      print(lat);
      print(long);
    });
  }

  LatLng? center;
  getuserid() async {
    SharedPreferences sf = await SharedPreferences.getInstance();

    setState(() {
      center = LatLng(double.parse(widget.passlat.toString()),
          (double.parse(widget.passlong.toString())));
      updbuildname.text = widget.buildname!;
      updlocaname.text = widget.locname!;
      uid = sf.getString("stored_uid");
      print("USER ID ID ${uid.toString()}");
    });
  }

  @override
  void initState() {
    getuserid();
    // getCurruntLocation();
    super.initState();
  }

  late String videoTitle;
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

  String? address;

  final _add_address = Get.put(add_address_controller());
  final _get_address = Get.put(get_address_controller());
  final _upd_address = Get.put(edit_address_controller());
  final _get_testimonials = Get.put(get_testimonials_controller());

  double? latt;
  double? longg;

  getUserLocation() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(latt!, longg!);
    Placemark place = placemarks[0];
    print(place.name);
    print(place);
  }

  String? pincodestr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: center == null
          ? CommonIndicator()
          : SafeArea(
              child: Container(
                height: SizeConfig.screenHeight,
                width: SizeConfig.screenWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Container(
                          // height: SizeConfig.screenWidth*0.9,
                          width: SizeConfig.screenWidth,
                          child: PlacePicker(
                            forceAndroidLocationManager: true,
                            apiKey: "AIzaSyCNlG7IWvqOeMtAyIXURo0WiDiPaEtIq5g",
                            hintText: "Find a place ...",
                            searchingText: "Please wait ...",
                            selectText: "Select place",
                            initialPosition: center!,
                            useCurrentLocation: true,
                            selectInitialPosition: true,
                            usePinPointingSearch: true,
                            usePlaceDetailSearch: true,
                            zoomGesturesEnabled: true,
                            zoomControlsEnabled: true,
                            enableMyLocationButton: true,
                            selectedPlaceWidgetBuilder:
                                (_, selectedPlace, state, isSearchBarFocused) {
                              if (state == SearchingState.Searching) {
                                CommonIndicator();
                              } else {
                                int count = 0;
                                List nu = [];
                                print(selectedPlace!.formattedAddress!.length);
                                for (int i = 0;
                                    i < selectedPlace!.formattedAddress!.length;
                                    i++) {
                                  if (selectedPlace!
                                              .formattedAddress![i] ==
                                          "0" ||
                                      selectedPlace!
                                              .formattedAddress![i] ==
                                          "1" ||
                                      selectedPlace!
                                              .formattedAddress![i] ==
                                          "2" ||
                                      selectedPlace!
                                              .formattedAddress![i] ==
                                          "3" ||
                                      selectedPlace!
                                              .formattedAddress![i] ==
                                          "4" ||
                                      selectedPlace!
                                              .formattedAddress![i] ==
                                          "5" ||
                                      selectedPlace!
                                              .formattedAddress![i] ==
                                          "6" ||
                                      selectedPlace!
                                              .formattedAddress![i] ==
                                          "7" ||
                                      selectedPlace!.formattedAddress![i] ==
                                          "8" ||
                                      selectedPlace!.formattedAddress![i] ==
                                          "9") {
                                    count++;
                                    nu.add(selectedPlace!.formattedAddress![i]);
                                  } else {}
                                }
                                List pincodes = [];
                                if (count >= 6) {
                                  for (int i = nu.length - 6;
                                      i < nu.length;
                                      i++) {
                                    pincodes.add(nu[i]);
                                  }
                                }
                                pincodestr = pincodes.join("");

                                print(count);
                                print(nu);
                              }

                              return isSearchBarFocused
                                  ? Container()
                                  : FloatingCard(
                                      color: Colors.transparent,
                                      bottomPosition: 0.0,
                                      leftPosition: 0.0,
                                      rightPosition: 0.0,
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            height:
                                                SizeConfig.screenHeight * 0.01,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            width: SizeConfig.screenWidth,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight:
                                                      Radius.circular(20)),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height:
                                                      SizeConfig.screenHeight *
                                                          0.02,
                                                ),
                                                //LOC YOUR LOC
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                        "assets/images/loca_green.svg"),
                                                    SizedBox(
                                                      width: SizeConfig
                                                              .screenWidth *
                                                          0.01,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        InkWell(
                                                            onTap: () {
                                                              print("Pic");
                                                            },
                                                            child: Text(
                                                              "Your Location",
                                                              style: font_style
                                                                  .green_600_14,
                                                            )),
                                                        SizedBox(
                                                          height: SizeConfig
                                                                  .screenHeight *
                                                              0.01,
                                                        ),
                                                        Container(
                                                            width: SizeConfig
                                                                    .screenWidth *
                                                                0.8,
                                                            // child: Text(address==null?"4486, Zirakpur, 147001...":address.toString(),style: font_style.g27272A_400_14,)),
                                                            child: state ==
                                                                    SearchingState
                                                                        .Searching
                                                                ? CommonIndicator()
                                                                : Text(
                                                                    selectedPlace!
                                                                        .formattedAddress
                                                                        .toString(),
                                                                    style: font_style
                                                                        .g27272A_400_14,
                                                                  )),
                                                      ],
                                                    )
                                                  ],
                                                ),

                                                SizedBox(
                                                  height:
                                                      SizeConfig.screenHeight *
                                                          0.01,
                                                ),

                                                //ENTER BUILDING NAME

                                                TextFormField(
                                                  controller: updbuildname,
                                                  style:
                                                      font_style.black_400_16,
                                                  decoration: InputDecoration(
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: yellow_col),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: yellow_col),
                                                    ),
                                                    hintText:
                                                        "Enter Building Name",
                                                    hintStyle: font_style
                                                        .B3B3B3_400_16,
                                                  ),
                                                ),

                                                //ENTER LOCALITY

                                                TextFormField(
                                                  controller: updlocaname,
                                                  style:
                                                      font_style.black_400_16,
                                                  decoration: InputDecoration(
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: yellow_col),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: yellow_col),
                                                    ),
                                                    hintText: "Enter Locality",
                                                    hintStyle: font_style
                                                        .B3B3B3_400_16,
                                                  ),
                                                ),

                                                // PINCODE TXTFORM
                                                pincodestr.toString() == ""
                                                    ? TextFormField(
                                                        controller: updpincode,
                                                        style: font_style
                                                            .black_400_16,
                                                        maxLength: 6,
                                                        keyboardType:
                                                            TextInputType.phone,
                                                        decoration:
                                                            InputDecoration(
                                                          counterText: "",
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color:
                                                                    yellow_col),
                                                          ),
                                                          focusedBorder:
                                                              UnderlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color:
                                                                    yellow_col),
                                                          ),
                                                          hintText:
                                                              "Enter Picode",
                                                          hintStyle: font_style
                                                              .B3B3B3_400_16,
                                                        ),
                                                      )
                                                    : Container(),
                                                SizedBox(
                                                  height:
                                                      SizeConfig.screenHeight *
                                                          0.02,
                                                ),

                                                //CONTINUE BTN

                                                Obx(() {
                                                  return Center(
                                                    child:
                                                        _upd_address
                                                                .loading.value
                                                            ? CommonIndicator()
                                                            : InkWell(
                                                                onTap: () {
                                                                  print(
                                                                      "PINCODE: $pincodestr");

                                                                  // Get.to(address_page());
                                                                  if (updbuildname
                                                                              .text
                                                                              .toString() ==
                                                                          "" ||
                                                                      updlocaname
                                                                              .text
                                                                              .toString() ==
                                                                          "") {
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                "Enter Valid Address");
                                                                  } else {
                                                                    _upd_address
                                                                        .edit_address_cont(
                                                                            widget
                                                                                .addid,

                                                                            // uid.toString(),
                                                                            selectedPlace!.formattedAddress
                                                                                .toString(),
                                                                            updbuildname
                                                                                .text,
                                                                            updlocaname
                                                                                .text,
                                                                            widget.passlat
                                                                                .toString(),
                                                                            widget.passlong
                                                                                .toString(),
                                                                            pincodestr.toString() == ""
                                                                                ? updpincode.text
                                                                                : pincodestr.toString())
                                                                        .then((value) => _get_address.get_address_cont(uid).then((value) {
                                                                              if (widget.pagename == "common") {
                                                                                _get_testimonials.get_testimonials_cont(uid.toString()).then((value) {
                                                                                  _get_testimonials.yturl;
                                                                                  fillYTlists();
                                                                                  print(_get_testimonials.yturl);
                                                                                });
                                                                                Get.to(BottomBar(pasindx: 0));
                                                                              } else {
                                                                                Get.back();
                                                                              }
                                                                            }));
                                                                    logger.i(
                                                                        "add--${widget.addid}");
                                                                    logger.i(
                                                                        "addresh--${selectedPlace!.formattedAddress.toString()}");
                                                                    logger.i(
                                                                        "update building--${updbuildname.text}");
                                                                    logger.i(
                                                                        " updatelocality--${updlocaname.text}");
                                                                    logger.i(
                                                                        "up latitude--${widget.passlat}");
                                                                    logger.i(
                                                                        "update longgutude--${widget.passlong}");
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              10),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  width: SizeConfig
                                                                          .screenWidth *
                                                                      0.9,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color:
                                                                        common_color,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            46),
                                                                  ),
                                                                  child: GradientText(
                                                                      gradientType:
                                                                          GradientType
                                                                              .linear,
                                                                      radius: 1,
                                                                      colors: [
                                                                        Color(
                                                                            0xffBF8D2C),
                                                                        Color(
                                                                            0xffDBE466),
                                                                        Color(
                                                                            0xffBF8D2C)
                                                                      ],
                                                                      "Update",
                                                                      style: font_style
                                                                          .grad_600_16),
                                                                ),
                                                              ),
                                                  );
                                                }),

                                                SizedBox(
                                                  height:
                                                      SizeConfig.screenHeight *
                                                          0.015,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                            },
                            onTapBack: () {
                              Get.back();
                              setState(() {
                                _showPlacePickerInContainer = false;
                              });
                            },
                          )),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
