import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../COMMON/common_circular_indicator.dart';
import '../../../COMMON/common_color.dart';
import '../../../COMMON/size_config.dart';
import '../../common/common_profile_txtform.dart';
import '../Controller/get_profile_info_controller.dart';
import '../Controller/update_profile_controller.dart';

class edit_profile extends StatefulWidget {
  const edit_profile({Key? key}) : super(key: key);

  @override
  State<edit_profile> createState() => _edit_profileState();
}

class _edit_profileState extends State<edit_profile> {
  final _get_profile_info = Get.put(get_profile_info_controller());

  TextEditingController pfname = TextEditingController();
  TextEditingController plname = TextEditingController();
  TextEditingController pphno = TextEditingController();
  TextEditingController pemail = TextEditingController();
  final _update_profile = Get.put(update_profile_controller());

  setData() {
    setState(() {
      pfname.text = _get_profile_info.response.value.data!.firstName.toString();
      plname.text = _get_profile_info.response.value.data!.lastName.toString();
      pphno.text = _get_profile_info.response.value.data!.mobile.toString();
      pemail.text = _get_profile_info.response.value.data!.email.toString();
    });
    print("IMAGE===${_get_profile_info.response.value.data?.profile??""}");
  }

  String? guid;
  bool ontapreadonly = false;
  final List<String> items = [
    'Male',
    'Female',
    'OTHERS',
  ];
  String selectedGenderValue = '';
  int selectedIndex = 0;

  getuid() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    setState(() {
      guid = sf.getString("stored_uid");
    });
  }

  File? profile_photo;
  String? img64;
  String? _base64String;

  Future<File> urlToFile(String imageUrl) async {
// generate random number.
    var rng = new Random();
// get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
    String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
// call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get(imageUrl as Uri);
// write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
    print("THIS IS FILE ${file}");
    return file;
  }

  Future<void> profile_image() async {
    XFile? xf = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xf != null) {
      setState(() {
        profile_photo = File(xf.path);
        final bytes = File(xf.path).readAsBytesSync();
        img64 = base64Encode(bytes);
        // print("THIS IS PROFILE PHOTO ${profile_photo}");
        print("THIS IS PROFILE PHOTO ${img64}");
        print("PROFILE PHOTO ${profile_photo}");
      });
    }
  }

  @override
  void initState() {
    getuid();
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double statusheight = MediaQuery.of(context).padding.top;
    AppBar appBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: InkWell(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
          size: SizeConfig.screenHeight * 0.023,
        ),
      ),
      title: InkWell(
          onTap: () {
            urlToFile(
                "data:image/jpeg;base64,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");
          },
          child: Text(
            "Edit Personal Details",
            style: font_style.green_600_20,
          )),
    );
    double appbarh = appBar.preferredSize.height;
    return Scaffold(
      backgroundColor: bg_col,
      appBar: appBar,
      body: Obx(() {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
              height: SizeConfig.screenHeight - statusheight - appbarh,
              width: SizeConfig.screenWidth,
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: SizeConfig.screenHeight * 0.01,
                              child: InkWell(
                                onTap: () {
                                  if (ontapreadonly == false) {
                                  } else {
                                    profile_image();
                                  }
                                },
                                child: Container(
                                  width: SizeConfig.screenWidth * 0.3,
                                  height: SizeConfig.screenHeight * 0.18,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: profile_photo != null
                                              ? FileImage(profile_photo!)
                                              : _get_profile_info.response.value
                                                          .data!.profile
                                                          .toString() !=
                                                      ""
                                                  ? NetworkImage(
                                                      _get_profile_info.response
                                                          .value.data!.profile
                                                          .toString())
                                                  : const AssetImage(
                                                          "assets/images/person2.jpg")
                                                      as ImageProvider,
                                          fit: BoxFit.cover)),
                                ),
                              ),
                            ),
                            ontapreadonly == true
                                ? Positioned(
                                    // right: SizeConfig.screenWidth * 0.10,
                                    // top: SizeConfig.screenHeight * 0.5,

                                    child: InkWell(
                                      onTap: () {
                                        if (ontapreadonly == false) {
                                        } else {
                                          profile_image();
                                        }
                                      },
                                      child: Container(
                                        width: SizeConfig.screenWidth * 0.08,
                                        height: SizeConfig.screenHeight * 0.04,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: yellow_col),
                                        child: const Icon(
                                          Icons.camera_alt,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ]),
                      Padding(
                        padding:  EdgeInsets.only(top: SizeConfig.screenHeight * 0.20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              child: Text(
                              _get_profile_info.response.value.data!.firstName
                                  .toString(),
                              style: font_style.black_600_14_nounderline,
                          ),
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.01,
                            ),

                            //FIRST NAME
                            Center(
                              child: SizedBox(
                                width: SizeConfig.screenWidth * 0.9,
                                child: Text(
                                  "First Name",
                                  style: font_style.gr27272A_600_14,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.01,
                            ),
                            Center(
                              child: comon_pofile_txtform(
                                  isreadonly: ontapreadonly == true ? false : true,
                                  hinttxt: "Andrew",
                                  controller: pfname),
                            ),

                            SizedBox(
                              height: SizeConfig.screenHeight * 0.01,
                            ),
                            //LAST NAME
                            Center(
                              child: SizedBox(
                                width: SizeConfig.screenWidth * 0.9,
                                child: Text(
                                  "Last Name",
                                  style: font_style.gr27272A_600_14,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.01,
                            ),
                            Center(
                              child: comon_pofile_txtform(
                                  isreadonly: ontapreadonly == true ? false : true,
                                  hinttxt: "Andrew",
                                  controller: plname),
                            ),

                            SizedBox(
                              height: SizeConfig.screenHeight * 0.01,
                            ),

                            //PHONE NAME
                            Center(
                              child: SizedBox(
                                width: SizeConfig.screenWidth * 0.9,
                                child: Text(
                                  "Phone Number",
                                  style: font_style.gr27272A_600_14,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.01,
                            ),
                            Center(
                              child: comon_pofile_txtform(
                                  isreadonly: true,
                                  hinttxt: "-XX XXXXXXXXXX",
                                  controller: pphno),
                            ),

                            SizedBox(
                              height: SizeConfig.screenHeight * 0.01,
                            ),

                            //EMAIL
                            Center(
                              child: SizedBox(
                                width: SizeConfig.screenWidth * 0.9,
                                child: Text(
                                  "E-mail",
                                  style: font_style.gr27272A_600_14,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.01,
                            ),
                            Center(
                              child: comon_pofile_txtform(
                                  isreadonly: ontapreadonly == true ? false : true,
                                  hinttxt: "XXXXXX@XXXXX.XXX",
                                  controller: pemail),
                            ),
                            Row(
                              children: List.generate(
                                  items.length,
                                      (index) => Row(
                                    children: [
                                      Theme(
                                        data: ThemeData(
                                            unselectedWidgetColor:
                                            Colors.black),
                                        child: Radio(
                                          activeColor: Colors.black,
                                          value: items[index],
                                          groupValue:
                                          selectedGenderValue,
                                          onChanged: (String? value) {
                                            setState(() {
                                              selectedIndex == index;
                                              selectedGenderValue =
                                              value!;
                                            });
                                          },
                                        ),
                                      ),
                                      Text(items[index],
                                          style: font_style.black_600_16
                                              .copyWith(
                                              color: Colors.black),
                                          overflow:
                                          TextOverflow.ellipsis)
                                    ],
                                  )),
                            )

                          ],
                        ),
                      )

                    ],
                  ),
                  const Spacer(),
                  _update_profile.loading.value
                      ? const CommonIndicator()
                      : InkWell(
                          onTap: () {
                            setState(() {
                              if (ontapreadonly == false) {
                                ontapreadonly = true;
                              } else {
                                ontapreadonly = false;
                                _update_profile
                                    .update_profile_cont(
                                        guid.toString(),
                                        pfname.text,
                                        plname.text,
                                        pphno.text,
                                        pemail.text,
                                        selectedGenderValue.toLowerCase().capitalizeFirst,
                                        img64 == ""
                                            ? _get_profile_info
                                                .response.value.data!.profile
                                                .toString()
                                            : img64)
                                    .then((value) {
                                  _get_profile_info.get_profile_info_cont(guid);
                                });
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.screenHeight * 0.012),
                            width: SizeConfig.screenWidth * 0.35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: yellow_col,
                            ),
                            child: _update_profile.loading.value
                                ? const CupertinoActivityIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    ontapreadonly == false
                                        ? "Edit Profile"
                                        : "Save",
                                    style: font_style.white_600_14,
                                  ),
                          ),
                        ),
                  const Spacer(),
                ],
              )),
        );
      }),
    );
  }
}
