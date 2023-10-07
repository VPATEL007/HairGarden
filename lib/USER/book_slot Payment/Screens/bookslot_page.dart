import 'dart:convert';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hairgarden/COMMON/common_circular_indicator.dart';
import 'package:hairgarden/COMMON/comontoast.dart';
import 'package:hairgarden/USER/address/Screens/address_page.dart';
import 'package:hairgarden/USER/book_slot%20Payment/Screens/payment_page.dart';
import 'package:hairgarden/USER/category/Screens/all_categories.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../../../COMMON/common_color.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:intl/intl.dart';
import '../../../COMMON/size_config.dart';
import '../../address/Controller/get_address_controller.dart';
import '../../category/Controller/decrease_cart_controller.dart';
import '../../category/Controller/get_cart_controller.dart';
import '../../category/Controller/remove_fromcart_controller.dart';
import '../../common/common_cart_cont.dart';
import '../../common/common_txt_list.dart';
import '../../enable_location/Controller/add_address_controller.dart';
import '../../map_page.dart';
import '../../professional_details/Screens/professional_details.dart';
import '../Controller/get_staff_details_controller.dart';
import '../Controller/get_staffs_controller.dart';
import '../Controller/get_time_slots_controller.dart';

class bookslot_page extends StatefulWidget {
  const bookslot_page({Key? key}) : super(key: key);

  @override
  State<bookslot_page> createState() => _bookslot_pageState();
}

class _bookslot_pageState extends State<bookslot_page> {
  DatePickerController _controllerdate = DatePickerController();
  int selected_prof = 0;
  String? staffid, staffname;
  DateTime _selectedValue = DateTime.now();

  final _get_time_slots = Get.put(get_time_slots_controller());
  final _get_address = Get.put(get_address_controller());
  final _get_staffs = Get.put(get_staffs_controller());
  final _get_staff_details = Get.put(get_staffs_details_controller());
  final _get_cart = Get.put(get_cart_controller());

  String? getseladdindx;

  getselectedaddress() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    setState(() {
      getseladdindx = sf.getString("selectedaddressid");
    });
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
    });
  }

  String? uid;

  Future<void> getuserid() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    setState(() {
      uid = sf.getString("stored_uid");
      print("USER ID ID ${uid.toString()}");
    });
  }

  int selectedtimeslot = 0;
  String? times;

  convert24hr(String time) {
    switch (time) {
      case '1':
        setState(() {
          times = "13";
        });
        break;
      case "2":
        setState(() {
          times = "14";
        });

        break;
      case '3':
        setState(() {
          times = "15";
        });
        break;
      case "4":
        setState(() {
          times = "16";
        });
        break;
      case '5':
        setState(() {
          times = "17";
        });
        break;
      case "6":
        setState(() {
          times = "18";
        });
        break;
      case '7':
        setState(() {
          times = "19";
        });
        break;
      case "8":
        setState(() {
          times = "20";
        });
        break;
      case '9':
        setState(() {
          times = "21";
        });
        break;
      case "10":
        setState(() {
          times = "22";
        });
        break;
      case '11':
        setState(() {
          times = "23";
        });
        break;
    }
    return times;
  }

  final _decrease_cart = Get.put(decrease_cart_controller());
  final _remove_from_cart = Get.put(remove_fromcart_controller());
  int? selectedind;

  @override
  void initState() {
    setState(() {
      staffid = "";
      staffname = "random";
    });
    _get_time_slots.get_time_slots_cont("random", "").then((value) {
      gettimeslotfromcurrtime();
    });
    getuserid().then((value) {
      initPlatformState().then((value) {
        print(
            "${uid.toString() == "" || uid == null ? "" : uid.toString()}${_deviceId.toString()}");
        _get_cart.get_cart_cont(
            uid.toString() == "" || uid == null ? "" : uid.toString(),
            _deviceId.toString());
      });
      getselectedaddress();
      _get_address.get_address_cont(uid).then((value) => _get_staffs
              .get_staffs_cont(
                  getseladdindx != "" || getseladdindx != null
                      ? getseladdindx
                      : _get_address.defaultaddid.toString() == null
                          ? ""
                          : _get_address.defaultaddid.toString(),
                  _get_cart.response.value.data![0].categoryId)
              .then((value) {
            _get_time_slots.get_time_slots_cont("random", "").then((value) {
              gettimeslotfromcurrtime();
            });
          }));
    });

    initPlatformState();
    super.initState();
  }

  Future<void> getCurruntLocation() async {
    final LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    await Geolocator.getCurrentPosition().then((value) async {
      List<Placemark> locations =
          await placemarkFromCoordinates(value.latitude, value.longitude);
      setState(() {
        lat = value.latitude;
        long = value.longitude;
      });
      print(lat);
      print(long);
    });
  }

  double? lat;
  double? long;
  TextEditingController buildname = TextEditingController();
  TextEditingController locaname = TextEditingController();
  final _add_address = Get.put(add_address_controller());

  List finaltime = [];
  List finaltimeendd = [];
  List finalalltime = [];

  gettimeslotfromcurrtime() {
    print(_get_time_slots.timstoreampm);
    print(_get_time_slots.timstoreend);
    finaltime.clear();
    finaltimeendd.clear();
    finalalltime.clear();
    _get_time_slots.timstoreampm.forEach((element) {
      if (element.contains("PM")) {
        if (element.toString().substring(0, 2).contains("12")) {
          finaltime.add(
              "${element.toString().substring(0, 2).replaceAll(":", "").trim()}:${element.toString().substring(element.toString().indexOf(":")).replaceAll(":", "").replaceAll("AM", "").replaceAll("PM", "").trim()}");
        } else {
          setState(() {
            finaltime.add(
                "${convert24hr(element.toString().substring(0, 2).replaceAll(":", "").trim())}:${element.toString().substring(element.toString().indexOf(":")).replaceAll(":", "").replaceAll("AM", "").replaceAll("PM", "").trim()}");
          });
        }
      } else {
        finaltime.add(
            "${element.toString().substring(0, 2).replaceAll(":", "").trim()}:${element.toString().substring(element.toString().indexOf(":")).replaceAll(":", "").replaceAll("AM", "").replaceAll("PM", "").trim()}");
      }
    });
    _get_time_slots.timstoreend.forEach((element) {
      if (element.contains("PM")) {
        if (element.toString().substring(0, 2).contains("12")) {
          finaltimeendd.add(
              "${element.toString().substring(0, 2).replaceAll(":", "").trim()}:${element.toString().substring(element.toString().indexOf(":")).replaceAll(":", "").replaceAll("AM", "").replaceAll("PM", "").trim()}");
        } else {
          setState(() {
            finaltimeendd.add(
                "${convert24hr(element.toString().substring(0, 2).replaceAll(":", "").trim())}:${element.toString().substring(element.toString().indexOf(":")).replaceAll(":", "").replaceAll("AM", "").replaceAll("PM", "").trim()}");
          });
        }
      } else {
        finaltimeendd.add(
            "${element.toString().substring(0, 2).replaceAll(":", "").trim()}:${element.toString().substring(element.toString().indexOf(":")).replaceAll(":", "").replaceAll("AM", "").replaceAll("PM", "").trim()}");
      }
    });
    for (int i = 0; i < finaltimeendd.length; i++) {
      DateFormat dateFormat = DateFormat.Hm();
      DateTime now = DateTime.now();
      DateTime open = dateFormat.parse(finaltime[i]);
      open = DateTime(now.year, now.month, now.day, open.hour, open.minute);
      DateTime close = dateFormat.parse(finaltimeendd[i]);
      close = DateTime(now.year, now.month, now.day, close.hour, close.minute);

      DateTime check = dateFormat.parse(DateFormat('HH:mm').format(now));
      check = DateTime(now.year, now.month, now.day, check.hour, check.minute);

      if (_selectedValue.toString().substring(0, 10) ==
          DateTime.now().toString().substring(0, 10)) {
        if (check.isAfter(close)) {
          // do something
        } else if (check.add(const Duration(hours: 1)).isBefore(open)) {
          finalalltime.add(_get_time_slots.alltime[i]);
          print("No");
        }
      } else {
        finalalltime.add(_get_time_slots.alltime[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print("CATID: ${_get_cart.response.value.data![0].categoryId}");
        Get.to(all_categories(
            cateid: _get_cart.response.value.data![0].categoryId));
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: bg_col,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          leading: InkWell(
              onTap: () {
                _get_cart.get_cart_cont(
                    uid.toString() == "" || uid == null ? "" : uid.toString(),
                    _deviceId.toString());
                print(_get_cart.response.value.data![0].categoryId);
                Get.to(all_categories(
                    cateid: _get_cart.response.value.data![0].categoryId));
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: common_color,
                size: 20,
              )),
          title: InkWell(
              onTap: () {
                List tim = [];
                tim.clear();
                getselectedaddress();
                print(getseladdindx);
                print(_get_address.addsidlst.indexOf(getseladdindx));
              },
              child: Text(
                "Book Slot",
                style: font_style.green_600_20,
              )),
          actions: [
            _get_cart.loading.value ? Container() : Container(),
          ],
        ),
        body: Obx(() {
          return _get_address.loading.value || _get_staffs.loading.value
              ? const CommonIndicator()
              : Stack(alignment: Alignment.bottomCenter, children: [
                  SizedBox(
                    height: SizeConfig.screenHeight,
                    width: SizeConfig.screenWidth,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //WHICH TXT
                          Center(
                            child: SizedBox(
                                width: SizeConfig.screenWidth * 0.9,
                                child: Text(
                                  "Which Professional would you prefer?",
                                  style: font_style.Recoleta_black_600_14,
                                )),
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight * 0.02,
                          ),

                          // LIST VIEW

                          _get_staffs.response.value.status == false ||
                                  _get_staffs.response.value.message ==
                                      "The address id field is required." ||
                                  _get_staffs.response.value.data!.isEmpty ||
                                  _get_address.response.value.data!.isEmpty &&
                                      _get_address.response.value.status ==
                                          false
                              ? InkWell(
                                  onTap: () {
                                    _get_time_slots
                                        .get_time_slots_cont("random", "")
                                        .then((value) {
                                      gettimeslotfromcurrtime();
                                    });
                                  },
                                  child: SizedBox(
                                    height: SizeConfig.screenHeight * 0.23,
                                    width: SizeConfig.screenWidth * 0.9,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height:
                                              SizeConfig.screenHeight * 0.23,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6, horizontal: 5),
                                          width: SizeConfig.screenWidth * 0.3,
                                          decoration: BoxDecoration(
                                            color: newLightColor,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border:
                                                Border.all(color: yellow_col),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                height:
                                                    SizeConfig.screenHeight *
                                                        0.093,
                                                width: SizeConfig.screenWidth *
                                                    0.3,
                                                decoration: BoxDecoration(
                                                  color: yellow_col,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: SvgPicture.asset(
                                                  "assets/images/random.svg",
                                                  fit: BoxFit.scaleDown,
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    SizeConfig.screenHeight *
                                                        0.01,
                                              ),
                                              Text("Random",
                                                  style:
                                                      font_style.green_600_14),

                                              SizedBox(
                                                height:
                                                    SizeConfig.screenHeight *
                                                        0.01,
                                              ),
                                              // Spacer(),
                                              Text(
                                                "We’ll Assign the best Professional",
                                                style: font_style
                                                    .grey52525B_400_12,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(
                                      left: SizeConfig.screenWidth * 0.05),
                                  child: SizedBox(
                                    height: SizeConfig.screenHeight * 0.20,
                                    width: SizeConfig.screenWidth,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      clipBehavior: Clip.none,
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _get_staffs
                                              .response.value.data!.length +
                                          1,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              selected_prof = index;
                                              staffid = index == 0
                                                  ? ""
                                                  : _get_staffs.response.value
                                                      .data![index - 1].id
                                                      .toString();
                                              staffname = index == 0
                                                  ? "random"
                                                  : "assign";
                                              _get_time_slots
                                                  .get_time_slots_cont(
                                                      index == 0
                                                          ? "random"
                                                          : "assign",
                                                      index == 0
                                                          ? ""
                                                          : _get_staffs
                                                              .response
                                                              .value
                                                              .data![index - 1]
                                                              .id
                                                              .toString())
                                                  .then((value) {
                                                gettimeslotfromcurrtime();
                                              });
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6, horizontal: 5),
                                            // height: SizeConfig.screenHeight*0.23,
                                            width: SizeConfig.screenWidth * 0.3,
                                            decoration: BoxDecoration(
                                              color: selected_prof == index
                                                  ? newLightColor
                                                  : null,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: selected_prof == index
                                                      ? yellow_col
                                                      : Colors.grey
                                                          .withOpacity(0.2)),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  height:
                                                      SizeConfig.screenHeight *
                                                          0.088,
                                                  width:
                                                      SizeConfig.screenWidth *
                                                          0.18,
                                                  decoration: BoxDecoration(
                                                      color: index == 0
                                                          ? yellow_col
                                                          : null,
                                                      shape: BoxShape.circle,
                                                      image: index == 0
                                                          ? null
                                                          : DecorationImage(
                                                              image: NetworkImage(
                                                                  _get_staffs
                                                                      .response
                                                                      .value
                                                                      .data![
                                                                          index -
                                                                              1]
                                                                      .profile
                                                                      .toString()),
                                                              fit: BoxFit
                                                                  .cover)),
                                                  child: index == 0
                                                      ? SvgPicture.asset(
                                                          "assets/images/random.svg",
                                                          fit: BoxFit.scaleDown,
                                                        )
                                                      : null,
                                                ),
                                                SizedBox(
                                                  height:
                                                      SizeConfig.screenHeight *
                                                          0.01,
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      _get_staff_details
                                                          .get_staffs_details_cont(
                                                              int.parse(_get_staffs
                                                                  .response
                                                                  .value
                                                                  .data![
                                                                      index - 1]
                                                                  .id
                                                                  .toString()));
                                                      Get.to(
                                                          professional_details(
                                                        name: _get_staffs
                                                            .response
                                                            .value
                                                            .data![index - 1]
                                                            .firstName
                                                            .toString(),
                                                        profileurl: _get_staffs
                                                            .response
                                                            .value
                                                            .data![index - 1]
                                                            .profile
                                                            .toString(),
                                                      ));
                                                    },
                                                    child: Text(
                                                      index == 0
                                                          ? "Random"
                                                          : _get_staffs
                                                              .response
                                                              .value
                                                              .data![index - 1]
                                                              .firstName
                                                              .toString(),
                                                      style: index == 0
                                                          ? font_style
                                                              .green_600_14
                                                          : font_style
                                                              .black_600_14,
                                                    )),
                                                index == 0
                                                    ? Container()
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.star_half,
                                                            color: yellow_col,
                                                            size: 17,
                                                          ),
                                                          Text(
                                                            _get_staffs
                                                                .response
                                                                .value
                                                                .data![
                                                                    index - 1]
                                                                .avgRating
                                                                .toString(),
                                                            style: font_style
                                                                .black_400_10,
                                                          ),
                                                        ],
                                                      ),
                                                SizedBox(
                                                  height:
                                                      SizeConfig.screenHeight *
                                                          0.01,
                                                ),
                                                // Spacer(),
                                                Text(
                                                  index == 0
                                                      ? "We’ll Assign the best Professional"
                                                      : "Our Recommend",
                                                  style: font_style
                                                      .grey52525B_400_12,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return SizedBox(
                                          width: SizeConfig.screenWidth * 0.02,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                          SizedBox(
                            height: SizeConfig.screenHeight * 0.02,
                          ),

                          //WHEN WOULD YOU TXT
                          Center(
                            child: SizedBox(
                                width: SizeConfig.screenWidth * 0.9,
                                child: Text(
                                  "When would you like your service?",
                                  style: font_style.Recoleta_black_600_14,
                                )),
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight * 0.02,
                          ),

                          //CALENDER
                          Center(
                            child: SizedBox(
                              width: SizeConfig.screenWidth * 0.9,
                              child: DatePicker(
                                DateTime.now(),
                                width: 60,
                                height: 80,
                                controller: _controllerdate,
                                initialSelectedDate: DateTime.now(),
                                selectionColor: newLightColor,
                                selectedTextColor: Colors.black,
                                deactivatedColor: Colors.white,
                                monthTextStyle: font_style.cal_black_400_12,
                                dayTextStyle: font_style.cal_black_400_12,
                                dateTextStyle: font_style.cal_black_400_12,
                                onDateChange: (date) {
                                  // New date selected
                                  setState(() {
                                    _selectedValue = date;
                                  });
                                  _get_time_slots
                                      .get_time_slots_cont(
                                          staffname == "random"
                                              ? "random"
                                              : "assign",
                                          staffname == "random" ? "" : staffid)
                                      .then((value) {
                                    gettimeslotfromcurrtime();
                                  });
                                  print(_selectedValue);
                                  print(DateTime.now());
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight * 0.025,
                          ),

                          //WHAT TIME SLOT TXT
                          Center(
                            child: SizedBox(
                                width: SizeConfig.screenWidth * 0.9,
                                child: Text(
                                  "What time would you like to Book your Slot?",
                                  style: font_style.Recoleta_black_600_14,
                                )),
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight * 0.025,
                          ),

                          //GRIDVIEW TIMESLOTS
                          _get_time_slots.loading.value
                              ? const CommonIndicator()
                              : finalalltime.isEmpty || finalalltime.isEmpty
                                  ? Center(
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: SizeConfig.screenWidth * 0.9,
                                        child:
                                            const Text("NO TIME SLOTS FOUND"),
                                      ),
                                    )
                                  : Center(
                                      child: SizedBox(
                                        width: SizeConfig.screenWidth * 0.95,
                                        child: GridView.count(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          crossAxisCount: 3,
                                          childAspectRatio: 3.6,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing:
                                              SizeConfig.screenWidth * 0.015,
                                          children: List.generate(
                                              finalalltime.length, (index) {
                                            return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedtimeslot = index;
                                                });
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: selectedtimeslot ==
                                                            index
                                                        ? yellow_col
                                                        : Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    border: Border.all(
                                                        color: common_color)),
                                                child: Text(
                                                  finalalltime[index]
                                                      .toString(),
                                                  style: selectedtimeslot ==
                                                          index
                                                      ? font_style
                                                          .timeslot_white_400_10
                                                      : font_style
                                                          .timeslot_black_400_10,
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

                          //ADD CHANGE ADDRESS
                          _get_address.response.value.data!.isEmpty ||
                                  _get_address.response.value.status == false
                              ? Center(
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(address_page(
                                        page: "bookslot",
                                      ));
                                      // Get.to(map_page(pname: "address"));
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: SizeConfig.screenWidth * 0.9,
                                      child: Text(
                                        "Add Address +",
                                        style:
                                            font_style.green_600_14_underline,
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: SizedBox(
                                    width: SizeConfig.screenWidth * 0.9,
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                            "assets/images/loca_green.svg",
                                            color: common_color),
                                        SizedBox(
                                          width: SizeConfig.screenWidth * 0.01,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Your Location",
                                              style: font_style.green_600_14,
                                            ),
                                            SizedBox(
                                              height: SizeConfig.screenHeight *
                                                  0.01,
                                            ),
                                            getseladdindx == null ||
                                                    getseladdindx == ""
                                                ? SizedBox(
                                                    width:
                                                        SizeConfig.screenWidth *
                                                            0.5,
                                                    child: Text(
                                                      "${_get_address.response.value.data![_get_address.addsidlst.indexOf(_get_address.defaultaddid)].buildingName.toString()}, ${_get_address.response.value.data![_get_address.addsidlst.indexOf(_get_address.defaultaddid)].locality.toString()}, ${_get_address.response.value.data![_get_address.addsidlst.indexOf(_get_address.defaultaddid)].location.toString()}",
                                                      style: font_style
                                                          .g27272A_400_14,
                                                    ))
                                                : SizedBox(
                                                    width:
                                                        SizeConfig.screenWidth *
                                                            0.5,
                                                    child: Text(
                                                      "${_get_address.response.value.data![_get_address.addsidlst.indexOf(getseladdindx)].buildingName.toString()}, ${_get_address.response.value.data![_get_address.addsidlst.indexOf(getseladdindx)].locality.toString()}, ${_get_address.response.value.data![_get_address.addsidlst.indexOf(getseladdindx)].location.toString()}",
                                                      style: font_style
                                                          .g27272A_400_14,
                                                    )),
                                          ],
                                        ),
                                        const Spacer(),
                                        InkWell(
                                            onTap: () {
                                              // getuserid().then((value) => _get_address.get_address_cont(uid)).then((value) => Get.to(address_page()));
                                              Get.to(address_page(
                                                page: "bookslot",
                                              ));
                                            },
                                            child: Text("Change Location",
                                                style: font_style
                                                    .green_600_14_underline)),
                                      ],
                                    ),
                                  ),
                                ),
                          SizedBox(height: SizeConfig.screenHeight * 0.02),
                        ],
                      ),
                    ),
                  ),
                ]);
        }),
        bottomNavigationBar:
            _get_cart.response.value.data!.isEmpty ||
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        // height: showdet==true?SizeConfig.screenHeight*0.2:SizeConfig.screenHeight*0.09,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8))),
                        width: SizeConfig.screenWidth,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: SizeConfig.screenWidth * 0.04,
                                ),
                                //GREEN ARROW UP
                                InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return StatefulBuilder(builder:
                                              (BuildContext context,
                                                  void Function(void Function())
                                                      sState) {
                                            return Obx(() {
                                              return Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        SizeConfig.screenWidth *
                                                            0.05,
                                                    vertical: SizeConfig
                                                            .screenHeight *
                                                        0.01),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    //GREY LINE
                                                    Center(
                                                      child: Container(
                                                        height: 5,
                                                        color: Colors.grey,
                                                        width: SizeConfig
                                                                .screenWidth *
                                                            0.1,
                                                      ),
                                                    ),

                                                    SizedBox(
                                                      height: SizeConfig
                                                              .screenHeight *
                                                          0.01,
                                                    ),

                                                    //CART
                                                    Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                            "assets/images/cart.svg"),
                                                        SizedBox(
                                                          width: SizeConfig
                                                                  .screenWidth *
                                                              0.02,
                                                        ),
                                                        Text(
                                                          "Cart",
                                                          style: font_style
                                                              .black_600_16,
                                                        ),
                                                        _get_cart.loading.value
                                                            ? Container()
                                                            : Container()
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: SizeConfig
                                                              .screenHeight *
                                                          0.015,
                                                    ),

                                                    //LINE
                                                    Container(
                                                      height: 1,
                                                      width: SizeConfig
                                                          .screenWidth,
                                                      color: Colors.grey,
                                                    ),
                                                    SizedBox(
                                                      height: SizeConfig
                                                              .screenHeight *
                                                          0.015,
                                                    ),

                                                    SizedBox(
                                                      height: _get_cart
                                                                  .response
                                                                  .value
                                                                  .data!
                                                                  .length >=
                                                              11
                                                          ? SizeConfig
                                                                  .screenHeight *
                                                              0.055 *
                                                              11
                                                          : SizeConfig
                                                                  .screenHeight *
                                                              0.055 *
                                                              _get_cart
                                                                  .response
                                                                  .value
                                                                  .data!
                                                                  .length,
                                                      child: ListView.separated(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const BouncingScrollPhysics(),
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemCount: _get_cart
                                                            .response
                                                            .value
                                                            .data!
                                                            .length,
                                                        itemBuilder: (context,
                                                            bottomindex) {
                                                          return Obx(() {
                                                            return Container(
                                                              // height: SizeConfig.screenHeight*0.04,
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        _get_cart
                                                                            .response
                                                                            .value
                                                                            .data![bottomindex]
                                                                            .title
                                                                            .toString(),
                                                                        style: font_style
                                                                            .black_500_12,
                                                                      ),
                                                                      SizedBox(
                                                                        height: SizeConfig.screenHeight *
                                                                            0.008,
                                                                      ),

                                                                      //Rs. DISCOUNT
                                                                      Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            "${_get_cart.response.value.data![bottomindex].finalPrice.toString()}",
                                                                            style:
                                                                                font_style.greyA1A1AA_400_10,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                SizeConfig.screenWidth * 0.02,
                                                                          ),
                                                                          // Text("₹${_get_cart.response.value.data![bottomindex].finalPrice.toString()}",style: font_style.yell_400_10,),
                                                                          Text(
                                                                            "₹${int.parse(_get_cart.response.value.data![bottomindex].price.toString()) * int.parse(_get_cart.response.value.data![bottomindex].qty.toString())}",
                                                                            style:
                                                                                font_style.yell_400_10,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const Spacer(),
                                                                  selectedind ==
                                                                          bottomindex
                                                                      ? Container(
                                                                          width:
                                                                              SizeConfig.screenWidth * 0.18,
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              vertical: 8,
                                                                              horizontal: 5),
                                                                          decoration: BoxDecoration(
                                                                              color: yellow_col,
                                                                              borderRadius: BorderRadius.circular(44)),
                                                                          child: const CupertinoActivityIndicator(
                                                                              color: Colors.white,
                                                                              radius: 8.2),
                                                                        )
                                                                      : _get_cart.response.value.data![bottomindex].type.toString() ==
                                                                              "service"
                                                                          ? Container(
                                                                              width: SizeConfig.screenWidth * 0.18,
                                                                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                                                                              decoration: BoxDecoration(color: yellow_col, borderRadius: BorderRadius.circular(44)),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                children: [
                                                                                  //SUBTRACT
                                                                                  Flexible(
                                                                                    child: InkWell(
                                                                                        onTap: () {
                                                                                          setState(() {
                                                                                            sState(() {
                                                                                              if (_get_cart.response.value.data![bottomindex].qty.toString() == '1') {
                                                                                                sState(() {
                                                                                                  selectedind = bottomindex;
                                                                                                });

                                                                                                _remove_from_cart
                                                                                                    .remove_fromcart_cont(
                                                                                                        // _get_cart.response.value.data![bottomindex].serviceCateId.toString(),
                                                                                                        uid.toString(),
                                                                                                        _deviceId.toString(),
                                                                                                        _get_cart.response.value.data![bottomindex].id.toString()
                                                                                                        // "service"
                                                                                                        )
                                                                                                    .then((value) {
                                                                                                  sState(() {
                                                                                                    selectedind = null;
                                                                                                  });
                                                                                                  if (_get_cart.prodid.length == 1) {
                                                                                                    _get_cart.prodid.clear();
                                                                                                    Get.back();
                                                                                                    _get_cart.get_cart_cont(uid.toString() == "" || uid == null ? "" : uid.toString(), _deviceId.toString());
                                                                                                  }
                                                                                                  _get_cart.get_cart_cont(uid.toString() == "" || uid == null ? "" : uid.toString(), _deviceId.toString());
                                                                                                });
                                                                                              } else {
                                                                                                print(selectedind);
                                                                                                print(bottomindex);
                                                                                                sState(() {
                                                                                                  selectedind = bottomindex;
                                                                                                });
                                                                                                _decrease_cart.decrease_cart_cont(_get_cart.response.value.data![bottomindex].serviceCateId.toString(), uid, _deviceId, "${int.parse(_get_cart.response.value.data![bottomindex].qty.toString()) - 1}").then((value) {
                                                                                                  sState(() {
                                                                                                    selectedind = null;
                                                                                                  });
                                                                                                  _get_cart.get_cart_cont(uid.toString() == "" || uid == null ? "" : uid.toString(), _deviceId.toString());
                                                                                                });
                                                                                              }
                                                                                            });
                                                                                          });
                                                                                        },
                                                                                        child: Container(
                                                                                            child: const Icon(
                                                                                          Icons.remove,
                                                                                          color: Colors.white,
                                                                                          size: 16,
                                                                                        ))),
                                                                                  ),

                                                                                  //TOTAL
                                                                                  Text(
                                                                                    _get_cart.response.value.data![bottomindex].qty.toString(),
                                                                                    style: font_style.white_400_10,
                                                                                  ),

                                                                                  //ADD
                                                                                  Flexible(
                                                                                    child: InkWell(
                                                                                        onTap: () {
                                                                                          setState(() {
                                                                                            sState(() {
                                                                                              sState(() {
                                                                                                selectedind = bottomindex;
                                                                                              });
                                                                                              _decrease_cart.decrease_cart_cont(_get_cart.response.value.data![bottomindex].serviceCateId.toString(), uid, _deviceId, "${int.parse(_get_cart.response.value.data![bottomindex].qty.toString()) + 1}").then((value) {
                                                                                                sState(() {
                                                                                                  selectedind = null;
                                                                                                });
                                                                                                _get_cart.get_cart_cont(uid.toString() == "" || uid == null ? "" : uid.toString(), _deviceId.toString());
                                                                                              });
                                                                                            });
                                                                                          });
                                                                                        },
                                                                                        child: Container(
                                                                                            child: const Icon(
                                                                                          Icons.add,
                                                                                          color: Colors.white,
                                                                                          size: 16,
                                                                                        ))),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            )
                                                                          : InkWell(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  sState(() {
                                                                                    sState(() {
                                                                                      selectedind = bottomindex;
                                                                                    });
                                                                                    _remove_from_cart
                                                                                        .remove_fromcart_cont(
                                                                                            // _get_cart.response.value.data![bottomindex].serviceCateId.toString(),
                                                                                            uid.toString(),
                                                                                            _deviceId.toString(),
                                                                                            _get_cart.response.value.data![bottomindex].id.toString()
                                                                                            // "service"
                                                                                            )
                                                                                        .then((value) {
                                                                                      sState(() {
                                                                                        selectedind = null;
                                                                                      });
                                                                                      if (_get_cart.prodid.length == 1) {
                                                                                        _get_cart.prodid.clear();
                                                                                        Get.back();
                                                                                        _get_cart.get_cart_cont(uid.toString() == "" || uid == null ? "" : uid.toString(), _deviceId.toString());
                                                                                      }
                                                                                      _get_cart.get_cart_cont(uid.toString() == "" || uid == null ? "" : uid.toString(), _deviceId.toString());
                                                                                    });
                                                                                  });
                                                                                });
                                                                              },
                                                                              child: Container(
                                                                                width: SizeConfig.screenWidth * 0.18,
                                                                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                                                                                decoration: BoxDecoration(color: yellow_col, borderRadius: BorderRadius.circular(44)),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                  children: [
                                                                                    //TOTAL
                                                                                    Text(
                                                                                      "Remove",
                                                                                      style: font_style.white_400_10,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                ],
                                                              ),
                                                            );
                                                          });
                                                        },
                                                        separatorBuilder:
                                                            (context,
                                                                bottomindex) {
                                                          return Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                              vertical: SizeConfig
                                                                      .screenHeight *
                                                                  0.01,
                                                            ),
                                                            height: 1,
                                                            width: SizeConfig
                                                                .screenWidth,
                                                            color: Colors.grey,
                                                          );
                                                        },
                                                      ),
                                                    ),

                                                    // SizedBox(height: SizeConfig.screenHeight*0.015,),

                                                    //LINE
                                                    Container(
                                                      height: 1,
                                                      width: SizeConfig
                                                          .screenWidth,
                                                      color: Colors.grey,
                                                    ),
                                                    SizedBox(
                                                      height: SizeConfig
                                                              .screenHeight *
                                                          0.015,
                                                    ),

                                                    // Row(
                                                    //   mainAxisAlignment:
                                                    //       MainAxisAlignment
                                                    //           .spaceBetween,
                                                    //   children: [
                                                    //     Text(
                                                    //       "Service Cost",
                                                    //       style: font_style
                                                    //           .black_500_12,
                                                    //     ),
                                                    //     Text(
                                                    //       _get_cart.response
                                                    //           .value.total
                                                    //           .toString(),
                                                    //       style: font_style
                                                    //           .black_400_12,
                                                    //     ),
                                                    //   ],
                                                    // ),
                                                    // SizedBox(
                                                    //   height: SizeConfig
                                                    //           .screenHeight *
                                                    //       0.015,
                                                    // ),

                                                    //LINE
                                                    Container(
                                                      height: 1,
                                                      width: SizeConfig
                                                          .screenWidth,
                                                      color: Colors.grey,
                                                    ),
                                                    SizedBox(
                                                      height: SizeConfig
                                                              .screenHeight *
                                                          0.015,
                                                    ),

                                                    SizedBox(
                                                      width: SizeConfig
                                                              .screenWidth *
                                                          0.02,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Total",
                                                              style: font_style
                                                                  .greyA1A1AA_400_14_simple,
                                                            ),
                                                            Text(
                                                              "₹${_get_cart.response.value.total.toString()}",
                                                              style: font_style
                                                                  .black_500_14,
                                                            ),
                                                          ],
                                                        ),
                                                        const Spacer(),
                                                        InkWell(
                                                          onTap: () {
                                                            getselectedaddress();
                                                            ;
                                                            if (_get_address
                                                                .response
                                                                .value
                                                                .data!
                                                                .isEmpty) {
                                                              commontoas(
                                                                  "Please Select Your Address");
                                                            } else if (finalalltime
                                                                .isEmpty) {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          "Select Time SLot");
                                                            } else {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          payment_page(
                                                                            getslotid:
                                                                                _get_time_slots.alltimeid[_get_time_slots.alltime.indexOf(finalalltime[selectedtimeslot])].toString(),
                                                                            getbookdate:
                                                                                _selectedValue.toString().substring(0, 11),
                                                                            getaddressid: getseladdindx == null || getseladdindx == ""
                                                                                ? _get_address.response.value.data![_get_address.addsidlst.indexOf(_get_address.defaultaddid)].id.toString()
                                                                                : _get_address.response.value.data![_get_address.addsidlst.indexOf(getseladdindx)].id.toString(),
                                                                            getstaffid:
                                                                                staffid,
                                                                            getstafftype:
                                                                                staffname,
                                                                            getprice:
                                                                                _get_cart.response.value.total.toString(),
                                                                            getcatid:
                                                                                _get_cart.response.value.data![0].categoryId,
                                                                          )));
                                                            }
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            width: SizeConfig
                                                                    .screenWidth *
                                                                0.25,
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        10),
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    yellow_col,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                            child: Text(
                                                              "BOOK NOW",
                                                              style: font_style
                                                                  .white_600_14,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                          });
                                        },
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: common_color,
                                      child: Icon(Icons.keyboard_arrow_up,
                                          color: Colors.white),
                                    )),
                                SizedBox(
                                  width: SizeConfig.screenWidth * 0.025,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Total",
                                      style:
                                          font_style.greyA1A1AA_400_14_simple,
                                    ),
                                    Text(
                                      "₹${_get_cart.response.value.total.toString()}",
                                      style: font_style.black_500_14,
                                    ),
                                  ],
                                ),

                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    getselectedaddress();

                                    if (_get_address
                                        .response.value.data!.isEmpty) {
                                      commontoas("Please Select Your Address");
                                    } else if (finalalltime.isEmpty) {
                                      commontoas("Select Time SLot");
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  payment_page(
                                                    getslotid: _get_time_slots
                                                        .alltimeid[_get_time_slots
                                                            .alltime
                                                            .indexOf(finalalltime[
                                                                selectedtimeslot])]
                                                        .toString(),
                                                    getbookdate: _selectedValue
                                                        .toString()
                                                        .substring(0, 11),
                                                    getaddressid: getseladdindx ==
                                                                null ||
                                                            getseladdindx == ""
                                                        ? _get_address
                                                            .response
                                                            .value
                                                            .data![_get_address
                                                                .addsidlst
                                                                .indexOf(
                                                                    _get_address
                                                                        .defaultaddid)]
                                                            .id
                                                            .toString()
                                                        : _get_address
                                                            .response
                                                            .value
                                                            .data![_get_address
                                                                .addsidlst
                                                                .indexOf(
                                                                    getseladdindx)]
                                                            .id
                                                            .toString(),
                                                    getstaffid: staffid,
                                                    getstafftype: staffname,
                                                    getprice: _get_cart
                                                        .response.value.total
                                                        .toString(),
                                                    getcatid: _get_cart
                                                        .response
                                                        .value
                                                        .data![0]
                                                        .categoryId,
                                                  )));
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    width: SizeConfig.screenWidth * 0.25,
                                    decoration: BoxDecoration(
                                        color: yellow_col,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Text(
                                      "BOOK NOW",
                                      style: font_style.white_600_14,
                                    ),
                                    // child: Text("BOOK NOW",style: font_style.white_600_14,),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
