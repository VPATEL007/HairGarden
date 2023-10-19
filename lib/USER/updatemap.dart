import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:hairgarden/COMMON/comontoast.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:hairgarden/USER/address/Controller/get_pincode_controller.dart';
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
  String? addid, buildname, locname, pagename,pinCode="",area="";

  updateaddress(
      {required this.passlat,
      required this.passlong,
      required this.addid,
      required this.buildname,
      required this.locname,
      required this.pagename,
      this.pinCode,
        this.area
      });

  @override
  State<updateaddress> createState() => _updateaddressState();
}

class _updateaddressState extends State<updateaddress> {
  PickResult? selectedPlace;
  bool _showPlacePickerInContainer = false;
  final bool _showGoogleMapInContainer = false;

  final bool _mapsInitialized = false;
  final String _mapsRenderer = "latest";
  double? lat;
  double? long;
  String? uid;
  final bool _isclicked = true;

  final _text = TextEditingController();

  TextEditingController updbuildname = TextEditingController();
  TextEditingController areaName = TextEditingController();
  TextEditingController updlocaname = TextEditingController();
  TextEditingController updpincode = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  String postalCode  = "";
  final _get_pincode = Get.put(get_pincode_controller());

  Future<void> getCurruntLocation() async {
    final LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    await Geolocator.getCurrentPosition().then((value) async {
      List<Placemark> locations =
          await placemarkFromCoordinates(widget.passlat??0.0, widget.passlong??0.0);
      log("LOCAtiON=====${locations[0].name}");
      log("LOCALITY=====${locations[0].locality}");
      log("COUNTRY=====${locations[0].country}");
      log("AREA=====${locations[0].country}");
      log("COUNTRY=====${locations[0].country}");
      log("PINCODE=====${locations[0].postalCode}");
      log("LAT=====${widget.passlat}");
      log("LONG=====${widget.passlong}");
      setState(() {
        _text.text = "${locations[0].name}, ${locations[0].locality}, ${locations[0].country}";
        // setpincode=locations[0].postalCode.toString();
        lat = value.latitude;
        long = value.longitude;
        postalCode = locations[0].postalCode ?? '';
        // center = LatLng(double.parse(lat.toString()), double.parse(long.toString()));
      });
    });
  }

  LatLng? center;
  getuserid() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    setState(() {
      center = LatLng(double.parse(widget.passlat.toString()),
          (double.parse(widget.passlong.toString())));
      updbuildname.text = widget.buildname??"";
      updlocaname.text = widget.locname??"";
      updpincode.text = widget.pinCode??"";
      areaName.text = widget.area??"";
      uid = sf.getString("stored_uid");
    });
    getCurruntLocation();
    _get_pincode.get_pincode_cont();
  }

  @override
  void initState() {
    getuserid();
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
          ? const CommonIndicator()
          : SafeArea(
              child: SizedBox(
                height: SizeConfig.screenHeight,
                width: SizeConfig.screenWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: SizedBox(

                          width: SizeConfig.screenWidth,
                          child: PlacePicker(
                            forceAndroidLocationManager: true,
                            apiKey: "AIzaSyDKX-OUoO-PE053N5bjifQX9qnVp2jmatk",
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
                                const CommonIndicator();
                              } else {
                                int count = 0;
                                List nu = [];
                                print(selectedPlace!.formattedAddress!.length);
                                for (int i = 0;
                                    i < selectedPlace.formattedAddress!.length;
                                    i++) {
                                  if (selectedPlace.formattedAddress![i] ==
                                          "0" ||
                                      selectedPlace.formattedAddress![i] ==
                                          "1" ||
                                      selectedPlace.formattedAddress![i] ==
                                          "2" ||
                                      selectedPlace.formattedAddress![i] ==
                                          "3" ||
                                      selectedPlace.formattedAddress![i] ==
                                          "4" ||
                                      selectedPlace.formattedAddress![i] ==
                                          "5" ||
                                      selectedPlace.formattedAddress![i] ==
                                          "6" ||
                                      selectedPlace.formattedAddress![i] ==
                                          "7" ||
                                      selectedPlace.formattedAddress![i] ==
                                          "8" ||
                                      selectedPlace.formattedAddress![i] ==
                                          "9") {
                                    count++;
                                    nu.add(selectedPlace.formattedAddress![i]);
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
                                postalCode = pincodes.join("");
                                updpincode.text = pincodes.join("");
                                lat = selectedPlace.geometry?.location.lat;
                                long = selectedPlace.geometry?.location.lng;
                                print("NEW LAT==${lat}");
                                print("NEW LONG==${long}");
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            width: SizeConfig.screenWidth,
                                            decoration: const BoxDecoration(
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
                                                        Text(
                                                          "Your Location",
                                                          style: font_style
                                                              .green_600_14,
                                                        ),
                                                        SizedBox(
                                                          height: SizeConfig
                                                                  .screenHeight *
                                                              0.01,
                                                        ),
                                                        SizedBox(
                                                            width: SizeConfig
                                                                    .screenWidth *
                                                                0.8,
                                                            // child: Text(address==null?"4486, Zirakpur, 147001...":address.toString(),style: font_style.g27272A_400_14,)),
                                                            child: state ==
                                                                    SearchingState
                                                                        .Searching
                                                                ? const CommonIndicator()
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

                                                Form(
                                                  key: formKey,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      TextFormField(
                                                        controller: updbuildname,
                                                        style:
                                                        font_style.black_400_16,
                                                        validator: (value) {
                                                          if(value!.isEmpty)
                                                          {
                                                            return "Please Enter Building Name";
                                                          }
                                                          return null;
                                                        },
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
                                                      TextFormField(
                                                        validator: (value) {
                                                          if(value!.isEmpty)
                                                          {
                                                            return "Please Enter Area Name";
                                                          }
                                                          return null;
                                                        },
                                                        controller: areaName,
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
                                                          "Enter Area Name",
                                                          hintStyle: font_style
                                                              .B3B3B3_400_16,
                                                        ),
                                                      ),

                                                      //ENTER LOCALITY

                                                      TextFormField(
                                                        validator: (value) {
                                                          if(value!.isEmpty)
                                                          {
                                                            return "Please Enter Locality Name";
                                                          }
                                                          return null;
                                                        },
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
                                                      TextFormField(
                                                        validator: (value) {
                                                          if(value!.isEmpty)
                                                          {
                                                            return "Please Enter Pincode";
                                                          }
                                                          return null;
                                                        },
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
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                    // : Container(),
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
                                                            ? const CommonIndicator()
                                                            : InkWell(
                                                                onTap: () {
                                                                  print("FINAL LAT==${lat}");
                                                                  print("FINAL LONG==${long}");
                                                                  if(formKey.currentState!.validate())
                                                                  {
                                                                    if((_get_pincode
                                                                        .listofpincode
                                                                        .contains(updpincode.text.toString())))
                                                                    {
                                                                      if(postalCode
                                                                          .toLowerCase()
                                                                          .contains(updpincode.text.toLowerCase()))
                                                                      {
                                                                        _upd_address
                                                                            .edit_address_cont(
                                                                            widget
                                                                                .addid,
                                                                            selectedPlace!.formattedAddress
                                                                                .toString(),
                                                                            updbuildname
                                                                                .text,
                                                                            updlocaname
                                                                                .text,
                                                                            lat.toString(),
                                                                           long.toString(),
                                                                            pincodestr.toString() == ""
                                                                                ? updpincode.text
                                                                                : pincodestr.toString(),areaName.text)
                                                                            .then((value) => _get_address.get_address_cont(uid).then((value) {
                                                                          if (widget.pagename == "common") {
                                                                            _get_testimonials.get_testimonials_cont(uid.toString()).then((value) {
                                                                              _get_testimonials.yturl;
                                                                              fillYTlists();
                                                                            });
                                                                            Get.to(const BottomBar(pasindx: 0));
                                                                          } else {
                                                                            Get.back();
                                                                          }
                                                                        }));
                                                                      }
                                                                      else
                                                                      {
                                                                        commontoas(
                                                                            "Please Enter Valid Address");
                                                                      }

                                                                    }
                                                                    else
                                                                    {
                                                                      commontoas(
                                                                          "Services are not available");
                                                                    }

                                                                  }


                                                                },
                                                                child:
                                                                    Container(
                                                                  padding: const EdgeInsets
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
                                                                      colors: const [
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
