import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hairgarden/COMMON/comontoast.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:hairgarden/USER/bottombar/Screens/bottombar.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../COMMON/common_circular_indicator.dart';
import '../COMMON/common_color.dart';
import '../COMMON/size_config.dart';
import 'address/Controller/add_default_address_controller.dart';
import 'address/Controller/get_address_controller.dart';
import 'address/Controller/get_pincode_controller.dart';
import 'enable_location/Controller/add_address_controller.dart';
import 'home/Controller/get_testimonials_controller.dart';

var logger = Logger();

class newmaps extends StatefulWidget {
  String? pname;

  newmaps({required this.pname});

  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;

  @override
  State<newmaps> createState() => _newmapsState();
}

class _newmapsState extends State<newmaps> {
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

  TextEditingController buildname = TextEditingController();
  TextEditingController localityName = TextEditingController();
  TextEditingController cityName = TextEditingController();
  TextEditingController pincode = TextEditingController();

  final _get_testimonials = Get.put(get_testimonials_controller());
  final _get_pincode = Get.put(get_pincode_controller());

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String localityGet = '';
  String postalCode = '';

  LatLng? center;

  Future<void> getCurruntLocation() async {
    final LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    await Geolocator.getCurrentPosition().then((value) async {
      List<Placemark> locations =
          await placemarkFromCoordinates(value.latitude, value.longitude);
      print('Locality===${locations[0].locality}');
      print('Area===${locations[0].administrativeArea}');
      print('City===${locations[0].postalCode}');
      setState(() {
        _text.text = locations[0].name.toString() +
            ", " +
            locations[0].locality.toString() +
            ", " +
            locations[0].country.toString();
        // setpincode=locations[0].postalCode.toString();
        lat = value.latitude;
        long = value.longitude;
        localityGet = locations[0].locality ?? '';
        postalCode = locations[0].postalCode ?? '';
        center =
            LatLng(double.parse(lat.toString()), double.parse(long.toString()));
        print('Center===${center}');
      });
      print(lat);
      print(long);
    });
  }

  getuserid() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    setState(() {
      uid = sf.getString("stored_uid");
      print("USER ID ID ${uid.toString()}");
    });
  }

  var selectedadd;

  Future<void> getselectedaddress() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    setState(() {
      selectedadd = sf.getString("selectedaddressid");
      if (selectedadd == "" || selectedadd == null) {
        selectedadd = _get_address.addsidlst.indexOf(_get_address.defaultaddid);
      } else {
        selectedadd = _get_address.addsidlst.indexOf(selectedadd);
      }
    });
  }

  @override
  void initState() {
    getuserid();
    _get_pincode.get_pincode_cont();
    getCurruntLocation();
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
  final _add_default_address = Get.put(add_default_address_controller());

  double? latt;
  double? longg;

  // getUserLocation() async {
  //   List<Placemark> placemarks = await placemarkFromCoordinates(latt!, longg!);
  //   Placemark place = placemarks[0];
  // }

  String? pincodestr;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _get_pincode.loading.value || center == null
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
                                const CommonIndicator();
                              } else {
                                int count = 0;
                                List nu = [];
                                print(selectedPlace!.formattedAddress!.length);
                                for (int i = 0;
                                    i < selectedPlace.formattedAddress!.length;
                                    i++) {
                                  if (selectedPlace
                                              .formattedAddress![i] ==
                                          "0" ||
                                      selectedPlace
                                              .formattedAddress![i] ==
                                          "1" ||
                                      selectedPlace
                                              .formattedAddress![i] ==
                                          "2" ||
                                      selectedPlace
                                              .formattedAddress![i] ==
                                          "3" ||
                                      selectedPlace
                                              .formattedAddress![i] ==
                                          "4" ||
                                      selectedPlace
                                              .formattedAddress![i] ==
                                          "5" ||
                                      selectedPlace
                                              .formattedAddress![i] ==
                                          "6" ||
                                      selectedPlace
                                              .formattedAddress![i] ==
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
                                                    children: [
                                                      TextFormField(
                                                        controller: buildname,
                                                        style: font_style
                                                            .black_400_16,
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Please Enter House / Flat / Kothi Number';
                                                          }
                                                          return null;
                                                        },
                                                        decoration:
                                                            InputDecoration(
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
                                                              "Enter House / Flat / Kothi Number",
                                                          hintStyle: font_style
                                                              .B3B3B3_400_16,
                                                        ),
                                                      ),
                                                      TextFormField(
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Please Enter Tower No / Locality / Road';
                                                          }
                                                          return null;
                                                        },
                                                        controller:
                                                            localityName,
                                                        style: font_style
                                                            .black_400_16,
                                                        decoration:
                                                            InputDecoration(
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
                                                              "Enter Tower No / Locality / Road",
                                                          hintStyle: font_style
                                                              .B3B3B3_400_16,
                                                        ),
                                                      ),
                                                      TextFormField(
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Please Enter Area / City Name ';
                                                          }
                                                          return null;
                                                        },
                                                        controller: cityName,
                                                        style: font_style
                                                            .black_400_16,
                                                        decoration:
                                                            InputDecoration(
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
                                                              "Enter Area / City Name",
                                                          hintStyle: font_style
                                                              .B3B3B3_400_16,
                                                        ),
                                                      ),

                                                      // PINCODE TXTFORM
                                                      TextFormField(
                                                        controller: pincode,
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Please Enter PostalCode ';
                                                          }
                                                          return null;
                                                        },
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
                                                              "Enter Pincode",
                                                          hintStyle: font_style
                                                              .B3B3B3_400_16,
                                                        ),
                                                      )
                                                      // : Container(),
                                                    ],
                                                  ),
                                                ),

                                                //ENTER LOCALITY

                                                SizedBox(
                                                  height:
                                                      SizeConfig.screenHeight *
                                                          0.02,
                                                ),

                                                //CONTINUE BTN

                                                Obx(() {
                                                  return Center(
                                                    child: _add_address
                                                            .loading.value
                                                        ? const CommonIndicator()
                                                        : InkWell(
                                                            onTap: () async {

                                                              if (widget
                                                                      .pname ==
                                                                  "home") {
                                                                if (formKey
                                                                    .currentState!
                                                                    .validate()) {
                                                                  if (_get_pincode
                                                                      .listofpincode
                                                                      .contains(pincodestr.toString() ==
                                                                              ""
                                                                          ? pincode
                                                                              .text
                                                                          : pincodestr
                                                                              .toString())) {
                                                                    if(postalCode.isNotEmpty)
                                                                      {
                                                                        if ((localityGet.toLowerCase().contains(cityName
                                                                            .text
                                                                            .toLowerCase())) &&
                                                                            (postalCode
                                                                                .toLowerCase()
                                                                                .contains(pincode.text.toLowerCase()))) {

                                                                          SharedPreferences
                                                                          sf =
                                                                          await SharedPreferences
                                                                              .getInstance();
                                                                          _add_address
                                                                              .add_address_cont(
                                                                              uid.toString(),
                                                                              selectedPlace!.formattedAddress.toString(),
                                                                              buildname.text,
                                                                              localityName.text,
                                                                              lat.toString(),
                                                                              long.toString(),
                                                                              pincodestr.toString() == "" ? pincode.text : pincodestr.toString())
                                                                              .then((value) => _get_address.get_address_cont(uid).then((value) async {
                                                                            setState(() {
                                                                              sf.setString("selectedaddressid", _get_address.response.value.data![0].id.toString()).then((value) {
                                                                                getselectedaddress();
                                                                                _add_default_address.add_default_address(uid.toString(), _get_address.addsidlst[0].toString());
                                                                                Get.back();
                                                                              });
                                                                            });
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
                                                                        if ((localityGet.toLowerCase().contains(cityName
                                                                            .text
                                                                            .toLowerCase()))) {

                                                                          SharedPreferences
                                                                          sf =
                                                                          await SharedPreferences
                                                                              .getInstance();
                                                                          _add_address
                                                                              .add_address_cont(
                                                                              uid.toString(),
                                                                              selectedPlace!.formattedAddress.toString(),
                                                                              buildname.text,
                                                                              localityName.text,
                                                                              lat.toString(),
                                                                              long.toString(),
                                                                              pincodestr.toString() == "" ? pincode.text : pincodestr.toString())
                                                                              .then((value) => _get_address.get_address_cont(uid).then((value) async {
                                                                            setState(() {
                                                                              sf.setString("selectedaddressid", _get_address.response.value.data![0].id.toString()).then((value) {
                                                                                getselectedaddress();
                                                                                _add_default_address.add_default_address(uid.toString(), _get_address.addsidlst[0].toString());
                                                                                Get.back();
                                                                              });
                                                                            });
                                                                          }));
                                                                        }
                                                                        else
                                                                        {
                                                                          commontoas(
                                                                              "Please Enter Valid Address");
                                                                        }
                                                                      }

                                                                  } else {
                                                                    commontoas(
                                                                        "Services are not available");
                                                                  }
                                                                }
                                                              }
                                                              else if (_get_pincode
                                                                  .listofpincode
                                                                  .contains(pincodestr
                                                                              .toString() ==
                                                                          ""
                                                                      ? pincode
                                                                          .text
                                                                      : pincodestr
                                                                          .toString())) {
                                                                print('2');
                                                                if (widget
                                                                        .pname ==
                                                                    "address") {
                                                                  print('3');
                                                                  // Get.to(address_page());

                                                                  if (buildname
                                                                              .text
                                                                              .toString() ==
                                                                          "" ||
                                                                      localityName
                                                                              .text
                                                                              .toString() ==
                                                                          "") {
                                                                    commontoas(
                                                                        "Enter Valid Address");
                                                                  } else {
                                                                    if (_get_address
                                                                        .response
                                                                        .value
                                                                        .data!
                                                                        .isEmpty) {
                                                                      SharedPreferences
                                                                          sf =
                                                                          await SharedPreferences
                                                                              .getInstance();
                                                                      _add_address
                                                                          .add_address_cont(
                                                                              uid.toString(),
                                                                              selectedPlace!.formattedAddress.toString(),
                                                                              buildname.text,
                                                                              localityName.text,

                                                                              /// latatitude ,  longutude pass by me
                                                                              lat.toString(),
                                                                              long.toString(),
                                                                              pincodestr.toString() == "" ? pincode.text : pincodestr.toString())
                                                                          .then((value) => _get_address.get_address_cont(uid).then((value) async {
                                                                                setState(() {
                                                                                  sf.setString("selectedaddressid", _get_address.response.value.data![0].id.toString()).then((value) {
                                                                                    getselectedaddress();
                                                                                    _add_default_address.add_default_address(uid.toString(), _get_address.addsidlst[0].toString());
                                                                                    Get.back();
                                                                                  });
                                                                                });
                                                                              }));
                                                                      print(
                                                                          "uid${uid.toString()}--adddresss--${selectedPlace.formattedAddress.toString()}--old build-${buildname.text}-old locality-${localityName.text}--old lat-${lat}---old lag--${long}");
                                                                    } else {
                                                                      _add_address
                                                                          .add_address_cont(
                                                                              uid.toString(),
                                                                              selectedPlace!.formattedAddress.toString(),
                                                                              buildname.text,
                                                                              localityName.text,

                                                                              /// latatitude ,  longutude pass by me
                                                                              lat.toString(),
                                                                              long.toString(),
                                                                              pincodestr.toString() == "" ? pincode.text : pincodestr.toString())
                                                                          .then((value) => _get_address.get_address_cont(uid).then((value) async {
                                                                                getselectedaddress();
                                                                                Get.back();
                                                                              }));
                                                                      logger.i(
                                                                          "uid${uid.toString()}--adddresss--${selectedPlace.formattedAddress.toString()}--old build-${buildname.text}-old locality-${localityName.text}--old lat-${lat}---old lag--${long}");
                                                                    }
                                                                  }
                                                                } else {
                                                                  print('4');
                                                                  if (_get_address
                                                                      .response
                                                                      .value
                                                                      .data!
                                                                      .isEmpty) {
                                                                    print('5');
                                                                    SharedPreferences
                                                                        sf =
                                                                        await SharedPreferences
                                                                            .getInstance();
                                                                    _add_address
                                                                        .add_address_cont(
                                                                            uid.toString(),
                                                                            selectedPlace!.formattedAddress.toString(),
                                                                            buildname.text,
                                                                            localityName.text,

                                                                            /// latatitude ,  longutude pass by me
                                                                            lat.toString(),
                                                                            long.toString(),
                                                                            pincodestr.toString() == "" ? pincode.text : pincodestr.toString())
                                                                        .then((value) => _get_address.get_address_cont(uid).then((value) async {
                                                                              _get_testimonials.get_testimonials_cont(uid.toString()).then((value) {
                                                                                setState(() {
                                                                                  sf.setString("selectedaddressid", _get_address.response.value.data![0].id.toString()).then((value) {
                                                                                    _add_default_address.add_default_address(uid.toString(), _get_address.addsidlst[0].toString());
                                                                                    getselectedaddress().then((value) {
                                                                                      _get_testimonials.yturl;
                                                                                      fillYTlists();
                                                                                      print(_get_testimonials.yturl);
                                                                                      Get.to(BottomBar(pasindx: 0));
                                                                                    });
                                                                                  });
                                                                                });
                                                                              });
                                                                            }));
                                                                    logger.i(
                                                                        "uid${uid.toString()}--adddresss--${selectedPlace.formattedAddress.toString()}--old build-${buildname.text}-old locality-${localityName.text}--old lat-${lat}---old lag--${long}");
                                                                  } else {
                                                                    print(
                                                                        '7 Enter');
                                                                    _add_address
                                                                        .add_address_cont(
                                                                            uid.toString(),
                                                                            selectedPlace!.formattedAddress.toString(),
                                                                            buildname.text,
                                                                            localityName.text,

                                                                            /// latatitude ,  longutude pass by me
                                                                            lat.toString(),
                                                                            long.toString(),
                                                                            pincodestr.toString() == "" ? pincode.text : pincodestr.toString())
                                                                        .then((value) => _get_address.get_address_cont(uid).then((value) async {
                                                                              _get_testimonials.get_testimonials_cont(uid.toString()).then((value) {
                                                                                _get_testimonials.yturl;
                                                                                fillYTlists();
                                                                                print(_get_testimonials.yturl);
                                                                              });
                                                                              getselectedaddress().then((value) {
                                                                                _get_address.get_address_cont(uid);
                                                                                Get.to(BottomBar(pasindx: 0));
                                                                              });
                                                                            }));
                                                                  }
                                                                }
                                                              }
                                                              else {
                                                                commontoas(
                                                                    "Services are not available in your area");
                                                                // commontoas(msg: "Services are not available in your City");
                                                              }
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
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
                                                                    BorderRadius
                                                                        .circular(
                                                                            46),
                                                              ),
                                                              child: GradientText(
                                                                  gradientType:
                                                                      GradientType
                                                                          .linear,
                                                                  radius: 1,
                                                                  colors: [
                                                                    const Color(
                                                                        0xffBF8D2C),
                                                                    const Color(
                                                                        0xffDBE466),
                                                                    const Color(
                                                                        0xffBF8D2C)
                                                                  ],
                                                                  "Continue",
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
            )),
    );
  }
}
