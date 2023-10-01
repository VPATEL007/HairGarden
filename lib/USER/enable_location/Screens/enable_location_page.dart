import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../COMMON/common_color.dart';
import '../../../COMMON/size_config.dart';
import '../../../auth/Screens/login_page.dart';
import '../../address/Controller/get_address_controller.dart';

class enable_loation_page extends StatefulWidget {
  const enable_loation_page({Key? key}) : super(key: key);

  @override
  State<enable_loation_page> createState() => _enable_loation_pageState();
}

class _enable_loation_pageState extends State<enable_loation_page> {
  var appbarheight = AppBar().preferredSize.height;

  final kInnerDecoration = BoxDecoration(
    color: common_color,
    border: Border.all(color: Colors.transparent, width: 0),
    borderRadius: BorderRadius.circular(32),
  );

  double? lat;
  double? long;

  // static LatLng center = LatLng(23.0387, 72.5119);
  Future<void> getCurruntLocation() async {
    final LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    await Geolocator.getCurrentPosition().then((value) async {
      List<Placemark> locations =
          await placemarkFromCoordinates(value.latitude, value.longitude);
      setState(() {
        // _text.text=locations[0].name.toString()+", "+locations[0].locality.toString()+", "+locations[0].country.toString();
        lat = value.latitude;
        long = value.longitude;
        // center = LatLng(double.parse(lat.toString()), double.parse(long.toString()));
      });
      print(lat);
      print(long);
    });
  }

  final kGradientBoxDecoration = BoxDecoration(
    gradient: const LinearGradient(
        colors: [Color(0xffBF8D2C), Color(0xffDBE466), Color(0xffBF8D2C)]),
    border: Border.all(color: Colors.transparent, width: 0.3),
    borderRadius: BorderRadius.circular(32),
  );

  // openMapmyIndiaPlacePickerWidget() async {
  //   ReverseGeocodePlace place;
  //   getCurruntLocation();
  //
  //   try {
  //     place = await openPlacePicker(
  //         PickerOption(
  //           pickerButtonTitle: "Continue",
  //           placeOptions: PlaceOptions(hint: "Search here"),
  //             mapMaxZoom:double.maxFinite,
  //             statingCameraPosition:CameraPosition(
  //                     target: LatLng(lat!,long!),
  //                     zoom: 14.0,
  //                   ),
  //         ),
  //     );
  //   } on PlatformException {
  //     place = ReverseGeocodePlace();
  //   }
  //   print(json.encode(place.toJson()));
  //   // if (!mounted)return ;
  //
  //   print(place.pincode.toString());
  //   // Get.to(bottombar(pasindx: 0));
  //   // setState(() {
  //   //   _place = place;
  //   // });
  // }

  final _get_address = Get.put(get_address_controller());

  String? uid;

  Future<void> getuserid() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    setState(() {
      uid = sf.getString("stored_uid");
      print("USER ID ID ${uid.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    AppBar appbar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Image.asset("assets/images/HG_logo_small.png",
          color: common_color,
          width: SizeConfig.screenWidth * 0.50,
          height: 45),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar,
      body: SizedBox(
        height: SizeConfig.screenHeight - appbarheight,
        child: Column(
          children: [
            SizedBox(
              height: SizeConfig.screenHeight * 0.1,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  // openMapmyIndiaPlacePickerWidget();
                },
                child: Container(
                  height: SizeConfig.screenHeight * 0.28,
                  width: SizeConfig.screenWidth * 0.6,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/enable_loc_ing.png"),
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.cover)),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.02,
            ),
            Center(
                child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topLeft,
                    children: [
                  Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.only(left: 5),
                          color: Colors.white,
                          child: Text(
                            "Enable Location",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Lato',
                                color: common_color,
                                fontWeight: FontWeight.w600),
                          )),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.01,
                      ),
                      Container(
                          width: SizeConfig.screenWidth * 0.75,
                          padding: const EdgeInsets.only(left: 5),
                          color: Colors.white,
                          child: Text(
                            "For Letting us know, How much near are you from US",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Lato',
                              color: common_color,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          )),
                    ],
                  ),

                  Positioned(
                    top: SizeConfig.screenHeight * 0.008,
                    left: SizeConfig.screenWidth * 0.7,
                    child: SizedBox(
                        height: SizeConfig.screenHeight * 0.015,
                        width: SizeConfig.screenWidth * 0.03,
                        child: Image(
                          image: const AssetImage("assets/images/star.png"),
                          color: common_color,
                          fit: BoxFit.fill,
                        )),
                  ),

                  //LEFT STAR
                  Positioned(
                      top: SizeConfig.screenHeight * 0.06,
                      left: SizeConfig.screenWidth * 0.01,
                      child: SizedBox(
                          height: SizeConfig.screenHeight * 0.015,
                          width: SizeConfig.screenWidth * 0.09,
                          child: SvgPicture.asset("assets/images/lest_star.svg",
                              color: common_color))),

                  //BIG STAR
                  Positioned(
                      top: -SizeConfig.screenHeight * 0.01,
                      left: SizeConfig.screenWidth * 0.005,
                      child: SizedBox(
                          height: SizeConfig.screenHeight * 0.035,
                          width: SizeConfig.screenWidth * 0.08,
                          child: SvgPicture.asset(
                              "assets/images/big_star_svg.svg",
                              color: common_color))),
                ])),
            const Spacer(),
            InkWell(
              onTap: () async {
                Map<Permission, PermissionStatus> statuses = await [
                  Permission.location,
                  Permission.storage,
                ].request();
                if (statuses[Permission.location] == PermissionStatus.denied) {
                  openAppSettings();
                } else {
                  Get.to(login_page(
                    frompage: '',
                  ));
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  width: SizeConfig.screenWidth * 0.9,
                  height: SizeConfig.screenHeight * 0.06,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: common_color,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/loc_img.png",
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: SizeConfig.screenWidth * 0.02,
                      ),
                      Text("Enable Location",
                          style: font_style.grad_600_16
                              .copyWith(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.1,
            ),
          ],
        ),
      ),
    );
  }
}
