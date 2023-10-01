//
// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:latlong2/latlong.dart' as latLng;
// import 'package:get/get_core/src/get_main.dart';
// import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
// import 'package:hairgarden/COMMON/common_circular_indicator.dart';
// import 'package:hairgarden/COMMON/size_config.dart';
// import 'package:hairgarden/COMMON/font_style.dart';
// import 'package:latlong2/latlong.dart';
// // import 'package:mapmyindia_gl/mapmyindia_gl.dart';
// // import 'package:mapmyindia_place_widget/mapmyindia_place_widget.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:simple_gradient_text/simple_gradient_text.dart';
// import '../auth/Screens/login_page.dart';
// import '../COMMON/common_color.dart';
// import 'address/Controller/get_address_controller.dart';
// import 'book_slot Payment/Screens/payment_page.dart';
// import 'enable_location/Controller/add_address_controller.dart';
//
// class map_page extends StatefulWidget {
//   String? pname;
//   static final kInitialPosition = LatLng(-33.8567844, 151.213108);
//    map_page({required this.pname});
//
//   @override
//   State<map_page> createState() => _map_pageState();
// }
//
// class _map_pageState extends State<map_page> {
//
//   bool _isclicked=true;
//
//
//   final _text = TextEditingController();
//
//   TextEditingController buildname=TextEditingController();
//   TextEditingController locaname=TextEditingController();
//   String? setpincode;
//   final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
//
//   late LatLng center;
//   Future<void> getCurruntLocation() async {
//
//     final LocationSettings locationSettings = LocationSettings(
//       accuracy: LocationAccuracy.high,
//       distanceFilter: 100,
//     );
//     await Geolocator.getCurrentPosition().then((value) async {
//       List<Placemark> locations = await placemarkFromCoordinates(value.latitude,value.longitude);
//       setState(() {
//         _text.text=locations[0].name.toString()+", "+locations[0].locality.toString()+", "+locations[0].country.toString();
//         setpincode=locations[0].postalCode.toString();
//         lat = value.latitude;
//         long= value.longitude;
//         center = LatLng(double.parse(lat.toString()), double.parse(long.toString()));
//       });
//       print(lat);
//       print(long);
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getuserid();
//     getCurruntLocation();
//   }
//   PickResult? selectedPlace;
//   bool _showPlacePickerInContainer = false;
//   bool _showGoogleMapInContainer = false;
//
//   bool _mapsInitialized = false;
//   String _mapsRenderer = "latest";
//
//   double? lat;
//   double? long;
//   String? uid;
//   getuserid() async {
//     SharedPreferences sf=await SharedPreferences.getInstance();
//     setState(() {
//       uid=sf.getString("stored_uid");
//       print("USER ID ID ${uid.toString()}");
//     });
//   }
//
//   final _add_address=Get.put(add_address_controller());
//   final _get_address=Get.put(get_address_controller());
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: long==null||lat==null?commonindicator():
//       Obx(
//         () {
//           return
//             SafeArea(
//             child: Container(
//               height: SizeConfig.screenHeight,
//               width: SizeConfig.screenWidth,
//               child: Column(
//                 children: [
//
//                   Container(
//                     height: SizeConfig.screenHeight*0.1,
//                     width: SizeConfig.screenWidth*0.9,
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         InkWell(
//                             onTap: (){
//                               Get.back();
//                             },
//                             child: Icon(Icons.arrow_back_ios_new,color: Colors.black,)
//                         ),
//                         Container(
//                           height: SizeConfig.screenHeight*0.05    ,
//                           width: SizeConfig.screenWidth*0.6,
//                           child: TextFormField(
//                             onTap: () {
//                               // openMapmyIndiaSearchWidget();
//                             },
//                             textAlignVertical: TextAlignVertical.center,
//                             decoration:  InputDecoration(
//                               contentPadding: EdgeInsets.zero,
//                               filled: true,
//                               fillColor: Color(0xffE4E4E7),
//                               hintText: "Search here",
//                               prefixIcon: Icon(Icons.search),
//                               enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(28),
//                                   borderSide: BorderSide(color: Colors.transparent)
//                               ),
//                               focusedBorder:OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(28),
//                                   borderSide: BorderSide(color: Colors.transparent)
//                               ),
//                             ),
//                           ),
//                         ),
//                         Container()
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: Container(
//                       child: Stack(
//                         alignment: Alignment.bottomCenter,
//                         clipBehavior: Clip.none,
//                         children: [
//                           //MAP
//                           InkWell(
//                             onTap: (){
//                               print("sdsds");
//                             },
//                             child: Container(
//                               width: SizeConfig.screenWidth,
//                               child: PlacePicker(
//                                   forceAndroidLocationManager: true,
//                                   apiKey: "AIzaSyDNAAErLgm2_3zKxXHtuHriJCBKkeU5KRo",
//                                   hintText: "Find a place ...",
//                                   searchingText: "Please wait ...",
//                                   selectText: "Select place",
//                                   initialPosition: map_page.kInitialPosition,
//                                   useCurrentLocation: true,
//                                   selectInitialPosition: true,
//                                   usePinPointingSearch: true,
//                                   usePlaceDetailSearch: true,
//                                   zoomGesturesEnabled: true,
//                                   zoomControlsEnabled: true,
//                                   onPlacePicked: (PickResult result) {
//                                     setState(() {
//                                       selectedPlace = result;
//                                       _showPlacePickerInContainer = false;
//                                     });
//                                   },
//                                   onTapBack: () {
//                                     setState(() {
//                                       _showPlacePickerInContainer = false;
//                                     });
//                                   }, )
//
//                             ),
//                           ),
//
//                           //LOCATION LAST CONTAINER
//                           Container(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 InkWell(
//                                   onTap: (){
//                                     // openMapmyIndiaPlacePickerWidget();
//                                   },
//                                   child: Container(
//                                     margin: EdgeInsets.only(right: 10),
//                                     padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: Colors.white,
//                                     ),
//                                     child: Icon(Icons.location_on,color: Colors.black,size: 25,),
//                                   ),
//                                 ),
//                                 SizedBox(height: SizeConfig.screenHeight*0.01,),
//                                 Container(
//                                   padding: EdgeInsets.symmetric(horizontal: 20),
//                                   // height: _isclicked==true?SizeConfig.screenHeight*0.3: SizeConfig.screenHeight*0.19,
//                                   width: SizeConfig.screenWidth,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
//                                   ),
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     children: [
//                                       // InkWell(
//                                       //     onTap: (){
//                                       //       setState(() {
//                                       //         if(_isclicked==false){
//                                       //           _isclicked=true;
//                                       //         }
//                                       //         else{
//                                       //           _isclicked=false;
//                                       //         }
//                                       //       });
//                                       //     },
//                                       //     child: Icon(_isclicked==true?Icons.keyboard_arrow_down_outlined:Icons.keyboard_arrow_up_outlined,color: Colors.black,)
//                                       // ),
//                                       SizedBox(height: SizeConfig.screenHeight*0.02,),
//                                       //LOC YOUR LOC
//                                       Row(
//                                         children: [
//                                           SvgPicture.asset("assets/images/loca_green.svg"),
//                                           SizedBox(width: SizeConfig.screenWidth*0.01,),
//                                           Column(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text("Your Location",style: font_style.green_600_14,),
//                                               SizedBox(height: SizeConfig.screenHeight*0.01,),
//                                               Text(_text.text==null?"4486, Zirakpur, 147001...":_text.text,style: font_style.g27272A_400_14,),
//
//                                             ],
//                                           )
//                                         ],
//                                       ),
//
//                                       _isclicked==true?
//                                       SizedBox(height: SizeConfig.screenHeight*0.01,):Container(),
//
//                                       //ENTER BUILDING NAME
//                                       _isclicked==true?
//                                       TextFormField(
//                                         controller: buildname,
//                                         style: font_style.black_400_16,
//                                         decoration: InputDecoration(
//                                           enabledBorder: UnderlineInputBorder(
//                                             borderSide: BorderSide(color: yellow_col),
//                                           ),
//                                           focusedBorder: UnderlineInputBorder(
//                                             borderSide: BorderSide(color: yellow_col),
//                                           ),
//                                           hintText: "Enter Building Name",
//                                           hintStyle: font_style.B3B3B3_400_16,
//
//                                         ),
//                                       ):Container(),
//
//                                       //ENTER LOCALITY
//                                       _isclicked==true?
//                                       TextFormField(
//                                         controller: locaname,
//                                         style: font_style.black_400_16,
//                                         decoration: InputDecoration(
//                                           enabledBorder: UnderlineInputBorder(
//                                             borderSide: BorderSide(color: yellow_col),
//                                           ),
//                                           focusedBorder: UnderlineInputBorder(
//                                             borderSide: BorderSide(color: yellow_col),
//                                           ),
//                                           hintText: "Enter Locality",
//                                           hintStyle: font_style.B3B3B3_400_16,
//
//                                         ),
//                                       ):Container(),
//
//                                       SizedBox(height: SizeConfig.screenHeight*0.02,),
//
//                                       //CONTINUE BTN
//                                       _add_address.loading.value?commonindicator():
//                                       Center(
//                                         child: InkWell(
//                                           onTap: (){
//                                             if(widget.pname=="Login"){
//                                               Get.to(login_page(frompage: '',));
//                                             }
//                                             else if(widget.pname=="address"){
//                                               // Get.to(address_page());
//
//                                              if(buildname.text.toString()=="" || locaname.text.toString()==""){
//                                                commontoas(msg: "Enter Valid Address");
//                                              }else{
//                                                _add_address.add_address_cont(
//                                                    uid.toString(),
//                                                    _text.text,
//                                                    buildname.text,
//                                                    locaname.text,
//                                                    setpincode.toString()
//                                                ).then((value) =>_get_address.get_address_cont(uid).then((value) => Get.back()) );
//                                              }
//
//                                             }
//
//                                           },
//                                           child: Container(
//                                             padding: EdgeInsets.symmetric(vertical: 10),
//                                             alignment: Alignment.center,
//                                             width: SizeConfig.screenWidth*0.9,
//
//                                             decoration: BoxDecoration(
//                                               color: common_color,
//                                               borderRadius: BorderRadius.circular(46),
//                                             ),
//                                             child: GradientText(
//                                                 gradientType: GradientType.linear,
//                                                 radius: 1,
//                                                 colors: [
//                                                   Color(0xffBF8D2C),
//                                                   Color(0xffDBE466),
//                                                   Color(0xffBF8D2C)
//                                                 ],
//                                                 "Continue",style: font_style.grad_600_16),
//                                           ),
//                                         ),
//                                       ),
//
//                                       SizedBox(height:SizeConfig.screenHeight*0.015,),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           );
//         }
//       ),
//     );
//   }
// }
//
//
