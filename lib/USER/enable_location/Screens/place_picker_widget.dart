// import 'dart:convert';
// import 'package:mapmyindia_place_widget/mapmyindia_place_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class PlacePickerWidget extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return PlacePickerWidgetState();
//   }
// }
//
// class PlacePickerWidgetState extends State {
//   ReverseGeocodePlace _place = ReverseGeocodePlace();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         brightness: Brightness.dark,
//         title: Text(
//           'Place Picker Widget',
//           style: TextStyle(color: Colors.white),
//         ),
//         elevation: 0.2,
//       ),
//       body: Center(child: Column(children: [
//         SizedBox(height: 20,),
//         Text(_place.formattedAddress == null? 'Address: ':'Address: ${_place.formattedAddress}' ),
//         SizedBox(height: 20,),
//         TextButton(onPressed: openMapmyIndiaPlacePickerWidget ,child:Text("Open Place picker")),
//       ]))
//     );
//   }
//
//
//
// }
