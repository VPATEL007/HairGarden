import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hairgarden/COMMON/common_circular_indicator.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:hairgarden/USER/book_slot%20Payment/Screens/bookslot_page.dart';
import 'package:hairgarden/USER/updatemap.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../COMMON/common_color.dart';
import '../../../COMMON/size_config.dart';
import '../../book_slot Payment/Controller/get_staffs_controller.dart';
import '../../category/Controller/get_cart_controller.dart';
import '../../enable_location/Controller/add_address_controller.dart';
import '../../newmap1.dart';
import '../Controller/add_default_address_controller.dart';
import '../Controller/delete_address_controller.dart';
import '../Controller/get_address_controller.dart';

var logger = Logger();

class address_page extends StatefulWidget {
  String? page;

  address_page({required this.page});

  @override
  State<address_page> createState() => _address_pageState();
}

class _address_pageState extends State<address_page> {
  final _get_address = Get.put(get_address_controller());
  final _del_address = Get.put(delete_address_controller());
  final _add_default_address = Get.put(add_default_address_controller());
  final _get_staffs = Get.put(get_staffs_controller());
  final _get_cart = Get.put(get_cart_controller());

  String? uid;
  Future<void> getuserid() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    setState(() {
      uid = sf.getString("stored_uid");
      print("USER ID ID ${uid.toString()}");
    });
  }

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

  final _text = TextEditingController();

  TextEditingController buildname = TextEditingController();
  TextEditingController locaname = TextEditingController();
  final _add_address = Get.put(add_address_controller());
  String? setpincode;

  int _oneValue = 0;
  var selectedadd;
  var getadd;

  getselectedaddress() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    getuserid();

    setState(() {
      if (_get_address.response.value.data!.isEmpty) {
        selectedadd = "";
      } else {
        getadd = sf.getString("selectedaddressid");
        if (getadd == "" || getadd == null) {
          sf.setString("selectedaddressid", _get_address.defaultaddid);
          setState(() {
            selectedadd =
                _get_address.addsidlst.indexOf(_get_address.defaultaddid);
            _oneValue = selectedadd;
          });
        } else {
          setState(() {
            selectedadd = _get_address.addsidlst.indexOf(getadd);
            _oneValue = selectedadd;
          });
        }
      }
    });
    print("SELECTEDADD: ${getadd}");
  }

  @override
  void initState() {
    getselectedaddress();
    getCurruntLocation();
    getuserid().then((value) {

      _get_address
          .get_address_cont(
              uid.toString() == "" || uid == null ? "" : uid.toString())
          .then((value) {
        getselectedaddress();
      });
      setState(() {
        // selectedadd==""||selectedadd==null?
        // _oneValue=_get_address.addsidlst.indexOf(_get_address.defaultaddid):
        // _oneValue=_get_address.addsidlst.indexOf(selectedadd);
      });
    });
    print(_get_address.response.value.data!.length);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        getuserid().then((value) {
          getselectedaddress();
          selectedadd == "" ||
                  selectedadd == null &&
                      _get_address.defaultaddid.toString() == "" ||
                  _get_address.defaultaddid == null
              ? _get_address.get_address_cont(uid).then((value) => _get_staffs.get_staffs_cont("", _get_cart.response.value.data![0].categoryId)).then((value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const bookslot_page())))
              : selectedadd == "" || selectedadd == null
                  ? _get_address
                      .get_address_cont(uid)
                      .then((value) => _get_staffs.get_staffs_cont(
                          _get_address.defaultaddid.toString(),
                          _get_cart.response.value.data![0].categoryId))
                      .then((value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const bookslot_page())))
                  : _get_address
                      .get_address_cont(uid)
                      .then((value) => _get_staffs.get_staffs_cont(
                          selectedadd, _get_cart.response.value.data![0].categoryId))
                      .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => const bookslot_page())));
          if (widget.page == "bookslot") {
            Get.to(const bookslot_page());
          } else {
            Get.back();
          }
        });

        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              getuserid().then((value) {
                getselectedaddress();
                selectedadd == "" ||
                        selectedadd == null &&
                            _get_address.defaultaddid.toString() == "" ||
                        _get_address.defaultaddid == null
                    ? _get_address.get_address_cont(uid).then((value) => _get_staffs.get_staffs_cont("", _get_cart.response.value.data![0].categoryId)).then(
                        (value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const bookslot_page())))
                    : selectedadd == "" || selectedadd == null
                        ? _get_address
                            .get_address_cont(uid)
                            .then((value) => _get_staffs.get_staffs_cont(
                                _get_address.defaultaddid.toString(),
                                _get_cart.response.value.data![0].categoryId))
                            .then((value) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const bookslot_page())))
                        : _get_address
                            .get_address_cont(uid)
                            .then((value) => _get_staffs.get_staffs_cont(selectedadd, _get_cart.response.value.data?[0].categoryId))
                            .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => const bookslot_page())));
                if (widget.page == "bookslot") {
                  Get.to(const bookslot_page());
                } else {
                  Get.back();
                }
              });
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: SizeConfig.screenHeight * 0.023,
            ),
          ),

          title: InkWell(
              onTap: () {
                print(
                    _get_address.addsidlst.indexOf(_get_address.defaultaddid));
              },
              child: Text(
                "Address",
                style: font_style.green_600_20,
              )),

          //ADD NEW
          actions: [
            Padding(
              padding: EdgeInsets.only(right: SizeConfig.screenWidth * 0.04),
              child: InkWell(
                onTap: () {
                  Get.to(newmaps(
                    pname: "address",
                  ));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      color: yellow_col,
                      size: SizeConfig.screenHeight * 0.02,
                    ),
                    Text(
                      "ADD NEW...",
                      style: font_style.yell_500_12,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: Obx(() {
          return _get_address.loading.value
              ? const CommonIndicator()
              : Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.01,
                    ),
                    _get_address.response.value.data?.isEmpty??false
                        ? Center(
                            child: Container(
                                alignment: Alignment.center,
                                height: SizeConfig.screenHeight * 0.8,
                                child: const Text("NO ADDRESS FOUND")),
                          )
                        : Expanded(
                            child: ListView.separated(
                              itemCount:
                                  _get_address.response.value.data?.length??0,
                              controller: ScrollController(),
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) => RadioListTile(
                                activeColor: yellow_col,
                                title: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            width: SizeConfig.screenWidth * 0.6,
                                            child: Text(
                                                "${_get_address.response.value.data![index].location.toString()}, ${_get_address.response.value.data![index].buildingName.toString()}, ${_get_address.response.value.data![index].locality.toString()}")),
                                        _oneValue == index ||
                                                _get_address.response.value
                                                        .data![index].isDefault
                                                        .toString() ==
                                                    "yes"
                                            ? InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _add_default_address
                                                        .add_default_address(
                                                            uid,
                                                            _get_address
                                                                .response
                                                                .value
                                                                .data![index]
                                                                .id
                                                                .toString())
                                                        .then((value) =>
                                                            _get_address
                                                                .get_address_cont(
                                                                    uid));
                                                  });
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        alignment:
                                                            Alignment.center,
                                                        height: SizeConfig
                                                                .screenHeight *
                                                            0.04,
                                                        width: SizeConfig
                                                                .screenWidth *
                                                            0.04,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color:
                                                                    yellow_col),
                                                            shape: BoxShape
                                                                .circle),
                                                        child: _get_address
                                                                    .response
                                                                    .value
                                                                    .data![
                                                                        index]
                                                                    .isDefault
                                                                    .toString() ==
                                                                "no"
                                                            ? null
                                                            : SvgPicture.asset(
                                                                "assets/images/address_check.svg",
                                                                fit: BoxFit
                                                                    .scaleDown,
                                                              )),
                                                    SizedBox(
                                                      width: SizeConfig
                                                              .screenWidth *
                                                          0.013,
                                                    ),
                                                    Text(
                                                      "Set as Default",
                                                      style: font_style
                                                          .black_500_14,
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Container()
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            var locations =
                                                await locationFromAddress(
                                                    _get_address.response.value
                                                        .data![index].location
                                                        .toString()
                                                        .replaceAll("\n", ""));

                                            Get.to(updateaddress(
                                              passlat: double.parse(_get_address
                                                  .response
                                                  .value
                                                  .data![index]
                                                  .latitude
                                                  .toString()),
                                              passlong: double.parse(
                                                  _get_address.response.value
                                                      .data![index].longitude
                                                      .toString()),
                                              //   passlat: double.parse(locations.toString().replaceAll("\n", "").substring(locations.toString().replaceAll("\n", "").indexOf("Latitude:")+9,locations.toString().indexOf(",")).trim()),
                                              // passlong: double.parse(locations.toString().replaceAll("\n", "").toString().substring(locations.toString().replaceAll("\n", "").indexOf("Longitude:")+10,locations.toString().replaceAll("\n", "").indexOf("Ti")).replaceAll(",", "").trim()),
                                              addid: _get_address.response.value
                                                  .data![index].id,
                                              buildname: _get_address
                                                  .response
                                                  .value
                                                  .data![index]
                                                  .buildingName,
                                              locname: _get_address.response
                                                  .value.data![index].locality,
                                              pagename: "",
                                            ));

                                            logger.i(
                                                "address page data : below data");
                                            logger.i(
                                                "passLattitude--${double.parse(_get_address.response.value.data![index].latitude.toString())}");
                                            logger.i(
                                                "passLattitude--${double.parse(_get_address.response.value.data![index].longitude.toString())}");
                                            logger.i(
                                                "passLattitude--${_get_address.response.value.data![index].id}");
                                            logger.i(
                                                "passLattitude--${_get_address.response.value.data![index].buildingName}");
                                            logger.i(
                                                "passLattitude--${_get_address.response.value.data![index].locality}");
                                          },
                                          child: Container(
                                              child: Text(
                                            "Edit",
                                            style: font_style
                                                .yellow_600_14_underline,
                                          )),
                                        ),
                                        SizedBox(
                                          height:
                                              SizeConfig.screenHeight * 0.01,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              if (_get_address.response.value
                                                      .data![index].isDefault ==
                                                  "yes") {
                                                _del_address
                                                    .delete_address_cont(
                                                        _get_address
                                                            .response
                                                            .value
                                                            .data![index]
                                                            .id)
                                                    .then((value) async {
                                                  _get_address
                                                      .get_address_cont(uid)
                                                      .then((value) async {
                                                    SharedPreferences sf =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    if (_get_address.response
                                                        .value.data!.isEmpty) {
                                                      setState(() {
                                                        sf.setString(
                                                            "selectedaddressid",
                                                            "");
                                                      });
                                                    } else {
                                                      setState(() {
                                                        sf.setString(
                                                            "selectedaddressid",
                                                            _get_address
                                                                .response
                                                                .value
                                                                .data![0]
                                                                .id
                                                                .toString());
                                                        _add_default_address
                                                            .add_default_address(
                                                                uid.toString(),
                                                                _get_address
                                                                    .addsidlst[
                                                                        0]
                                                                    .toString());
                                                        _oneValue = 0;
                                                      });
                                                    }
                                                  });
                                                });
                                              } else {
                                                _del_address
                                                    .delete_address_cont(
                                                        _get_address
                                                            .response
                                                            .value
                                                            .data![index]
                                                            .id)
                                                    .then((value) async {
                                                  _get_address
                                                      .get_address_cont(uid)
                                                      .then((value) async {
                                                    SharedPreferences sf =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    if (_get_address.response
                                                        .value.data!.isEmpty) {
                                                      setState(() {
                                                        sf.setString(
                                                            "selectedaddressid",
                                                            "");
                                                      });
                                                    } else {
                                                      setState(() {
                                                        sf.setString(
                                                            "selectedaddressid",
                                                            _get_address
                                                                .response
                                                                .value
                                                                .data![0]
                                                                .id
                                                                .toString());
                                                        _oneValue = 0;
                                                      });
                                                    }
                                                  });
                                                });
                                              }
                                            },
                                            child: SvgPicture.asset(
                                                "assets/images/address_delete.svg")),
                                      ],
                                    ),
                                  ],
                                ),
                                value: index,
                                groupValue: _oneValue,
                                onChanged: (value) async {
                                  SharedPreferences sf =
                                      await SharedPreferences.getInstance();
                                  setState(() {
                                    sf.setString(
                                        "selectedaddressid",
                                        _get_address
                                            .response.value.data![index].id
                                            .toString());
                                  });

                                  setState(() {
                                    _oneValue = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                  ],
                );
        }),
      ),
    );
  }
}
