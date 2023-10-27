import 'dart:convert';
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hairgardenemployee/COMMON/comman_toast.dart';
import 'package:hairgardenemployee/COMMON/common_color.dart';
import 'package:hairgardenemployee/COMMON/common_indicator.dart';
import 'package:hairgardenemployee/COMMON/common_txtform_yllow.dart';
import 'package:hairgardenemployee/COMMON/const.dart';
import 'package:hairgardenemployee/COMMON/font_style.dart';
import 'package:hairgardenemployee/COMMON/size_config.dart';
import 'package:hairgardenemployee/EMPLOYEE/Your_Reviews/Screens/your_reviews.dart';
import 'package:hairgardenemployee/EMPLOYEE/profile/controller/profile_controller.dart';
import 'package:hairgardenemployee/api_services/api_services.dart';
import 'package:hairgardenemployee/auth/Screens/login_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class myprofile_page extends StatefulWidget {
  const myprofile_page({Key? key}) : super(key: key);

  @override
  State<myprofile_page> createState() => _myprofile_pageState();
}

class _myprofile_pageState extends State<myprofile_page> {
  final List<String> items = [
    'MALE',
    'FEMALE',
    'OTHERS',
  ];
  String selectedGenderValue = 'MALE';
  String profileImage = "";
  final List<String> items4 = [
    'Beautician',
    'Massage Therapist',
    'Make up Artist',
    'Hair Stylist',
    'Pedicurist',
    'Nail Technician',
    'Hair Technician',
  ];
  String? selectedValue3, selectedValue4;

  final staffProfileController = Get.put(StaffProfileController());

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Alert!!"),
          content: const Text("You are awesome!"),
          actions: [
            MaterialButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  TextEditingController pfname = TextEditingController();
  TextEditingController plname = TextEditingController();
  TextEditingController pphno = TextEditingController();
  TextEditingController pemail = TextEditingController();
  TextEditingController address = TextEditingController();

  File? profile_photo;
  String? img64;
  String? _base64String;

  Future<void> profile_image() async {
    XFile? xf = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xf != null) {
      setState(() {
        profile_photo = File(xf.path);
        final bytes = File(xf.path).readAsBytesSync();
        img64 = base64Encode(bytes);
        // print("THIS IS PROFILE PHOTO ${profile_photo}");
        print("THIS IS PROFILE PHOTO ${img64}");
      });
    }
  }

  getUserData() async {
    staffProfileController.isLoading(true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString(stored_uid) ?? '';
    staffProfileController.fetchStaffProfile(id);
    pfname.text = staffProfileController.model().data?.firstName ?? '';
    plname.text = staffProfileController.model().data?.lastName ?? '';
    pphno.text = staffProfileController.model().data?.mobile ?? '';
    pemail.text = staffProfileController.model().data?.email ?? '';
    selectedGenderValue =
        staffProfileController.model().data?.gender?.toUpperCase() ?? '';
    address.text = staffProfileController.model().data?.address ?? "";
  }

  GlobalKey<FormState> profileFormKey = GlobalKey();

  File? file;

  Future<void> _createFileFromString(String? img64) async {
    if((img64?.isNotEmpty??false) || img64!=null)
      {
        Uint8List bytes = base64.decode(img64??"");
        String dir = (await getApplicationDocumentsDirectory()).path;
        file = File(
            "$dir/${DateTime.now().millisecondsSinceEpoch}");
        await file?.writeAsBytes(bytes);
      }

  }

  @override
  void initState() {
    getUserData();
    staffProfileController.allStaffService().then((value) => _createFileFromString(staffProfileController.model().data?.profile??''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    AppBar appBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text("My Account", style: font_style.green_600_20),
      // actions: [
      //   PopupMenuButton<int>(
      //     padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      //     clipBehavior: Clip.none,
      //     itemBuilder: (context) => [
      //       // PopupMenuItem 1
      //       PopupMenuItem(
      //         height: 20,
      //         value: 1,
      //         child: Row(
      //           children: [
      //             const Icon(
      //               Icons.edit,
      //               color: Colors.black,
      //             ),
      //             const SizedBox(
      //               width: 10,
      //             ),
      //             Text(
      //               "Edit Profile",
      //               style: font_style.black_400_14,
      //             )
      //           ],
      //         ),
      //       ),
      //       PopupMenuItem(
      //           height: 20,
      //           enabled: false,
      //           child: Container(
      //             height: 1,
      //             width: SizeConfig.screenWidth * 0.35,
      //             color: line_cont_col,
      //           )),
      //       // PopupMenuItem 2
      //       PopupMenuItem(
      //         height: 20,
      //         value: 2,
      //         child: Row(
      //           children: [
      //             const Icon(
      //               Icons.help,
      //               color: Colors.black,
      //             ),
      //             const SizedBox(
      //               width: 10,
      //             ),
      //             Text(
      //               "Support",
      //               style: font_style.black_400_14,
      //             )
      //           ],
      //         ),
      //       ),
      //     ],
      //     offset: const Offset(0, 40),
      //     color: Colors.white,
      //     icon: const Icon(
      //       Icons.more_vert,
      //       color: Colors.black,
      //     ),
      //     elevation: 0,
      //     onSelected: (value) {
      //       if (value == 1) {
      //       } else if (value == 2) {}
      //     },
      //   ),
      // ],
    );
    double height = appBar.preferredSize.height;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: newLightColor,
      appBar: appBar,
      body: Obx(() => staffProfileController.isLoading()
          ? const Center(
              child: commonindicator(),
            )
          : SingleChildScrollView(
              child: Form(
                key: profileFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.01,
                    ),
                    SizedBox(
                      height: 100,
                      width: SizeConfig.screenWidth,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          GestureDetector(
                            onTap: () {
                              profile_image();
                            },
                            child: Container(
                              width: SizeConfig.screenWidth * 0.3,
                              height: 100,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: file != null
                                          ? FileImage(file!)
                                              : const AssetImage(
                                                      "assets/images/person2.jpg")
                                                  as ImageProvider,
                                      fit: BoxFit.cover)),
                            ),
                          ),
                          Positioned(
                            left: SizeConfig.screenWidth * 0.56,
                            top: 70,
                            child: GestureDetector(
                              onTap: () {
                                profile_image();
                              },
                              child: Container(
                                width: SizeConfig.screenWidth * 0.08,
                                height: SizeConfig.screenHeight * 0.04,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: yellow_col),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.01,
                    ),

                    //NAME
                    Center(
                      child: Text(
                        "${pfname.text.capitalizeFirst} ${plname.text.capitalizeFirst}",
                        style: font_style.darkgray_600_16,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.01,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(const your_reviews());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.star_half,
                            color: Color(0xffF2C94C),
                          ),
                          Text(
                            "${staffProfileController.model().average?.toDouble() ?? 0.0}",
                            style: font_style.black_400_20,
                          ),
                          // Text(
                          //   "(200)",
                          //   style: font_style.greyA1A1AA_400_12,
                          // ),
                          const Icon(
                            Icons.keyboard_arrow_right_outlined,
                            color: Colors.black,
                          )
                        ],
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
                      child: common_txtform_yllow(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter First Name";
                            }
                            return null;
                          },
                          hinttxt: "First Name",
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
                      child: common_txtform_yllow(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Last Name";
                            }
                            return null;
                          },
                          hinttxt: "Last Name",
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
                      child: common_txtform_yllow(
                          readOnly: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Mobile Number";
                            }

                            return null;
                          },
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10)
                          ],
                          hinttxt: "Enter Mobile Number",
                          controller: pphno),
                    ),

                    SizedBox(
                      height: SizeConfig.screenHeight * 0.01,
                    ),
                    Center(
                      child: SizedBox(
                        width: SizeConfig.screenWidth * 0.9,
                        child: Text(
                          "Address",
                          style: font_style.gr27272A_600_14,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.01,
                    ),
                    Center(
                      child: common_txtform_yllow(
                          readOnly: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Address";
                            }

                            return null;
                          },
                          hinttxt: "Enter Address",
                          controller: address),
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
                      child: common_txtform_yllow(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter E-mail id";
                            } else if (!value.isEmail) {
                              return "Please Enter Valid E-mail id";
                            }
                            return null;
                          },
                          hinttxt: "Enter Email id",
                          controller: pemail),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.01,
                    ),

                    //PROFESSION
                    Center(
                      child: SizedBox(
                        width: SizeConfig.screenWidth * 0.9,
                        child: Text(
                          "Profession",
                          style: font_style.gr27272A_600_14,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.01,
                    ),
                    SizedBox(
                      width: SizeConfig.screenWidth * 0.9,
                      child: Obx(() => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                isExpanded: true,
                                hint: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'What is your Profession?*',
                                        style: font_style.greyA1A1AA_400_14,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                items: List.generate(
                                    staffProfileController
                                            .getStaffService()
                                            .data
                                            ?.length ??
                                        0,
                                    (index) => DropdownMenuItem<String>(
                                          value: staffProfileController
                                              .getStaffService()
                                              .data?[index]
                                              .name,
                                          child: Row(
                                            children: [
                                              Obx(() => Checkbox(
                                                  activeColor: yellow_col,
                                                  value: staffProfileController
                                                      .selectedCheckValueList
                                                      .contains(index),
                                                  onChanged: (value) {
                                                    if (staffProfileController
                                                        .selectedCheckValueList
                                                        .contains(index)) {
                                                      staffProfileController
                                                          .selectedCheckValueList
                                                          .remove(
                                                              index); // unselect
                                                    } else {
                                                      if (!staffProfileController
                                                          .selectedProfession
                                                          .contains(
                                                              staffProfileController
                                                                  .getStaffService()
                                                                  .data?[index]
                                                                  .id)) {
                                                        staffProfileController
                                                            .selectedProfession
                                                            .add(staffProfileController
                                                                .getStaffService()
                                                                .data?[index]
                                                                .id);
                                                      }
                                                      staffProfileController
                                                          .selectedCheckValueList
                                                          .add(index);
                                                      print(
                                                          'Length===${staffProfileController.selectedProfession.length}'); // select
                                                    }
                                                  })),
                                              Text(
                                                staffProfileController
                                                        .getStaffService()
                                                        .data?[index]
                                                        .name ??
                                                    '',
                                                style: font_style.black_400_16,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        )),
                                // value: staffProfileController.selectedProfessionValue(),
                                style: font_style.white_400_16,
                                onChanged: (value) {
                                  setState(() {
                                    staffProfileController
                                        .selectedProfessionValue(value!);
                                  });
                                },
                                buttonStyleData: ButtonStyleData(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  width: SizeConfig.screenWidth * 0.9,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: yellow_col),
                                    color:newLightColor,
                                  ),
                                  elevation: 0,
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                  ),
                                  iconSize: 20,
                                  iconEnabledColor: Colors.black,
                                  iconDisabledColor: Colors.grey,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                    maxHeight: 200,
                                    width: SizeConfig.screenWidth * 0.9,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(14),
                                          bottomRight: Radius.circular(14)),
                                      border: Border.all(color: common_color),
                                    ),
                                    elevation: 0),
                              ),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.01,
                    ),

                    //GENDER
                    Center(
                      child: SizedBox(
                        width: SizeConfig.screenWidth * 0.9,
                        child: Text(
                          "Gender",
                          style: font_style.gr27272A_600_14,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: List.generate(
                            items.length,
                            (index) => Row(
                                  children: [
                                    Theme(
                                      data: ThemeData(
                                          unselectedWidgetColor: yellow_col),
                                      child: Radio(
                                        activeColor: yellow_col,
                                        value: items[index],
                                        groupValue: selectedGenderValue,
                                        onChanged: (String? value) {
                                          setState(() {
                                            selectedGenderValue = value!;
                                          });
                                        },
                                      ),
                                    ),
                                    Text(items[index],
                                        style: font_style.white_400_16
                                            .copyWith(color: Colors.black),
                                        overflow: TextOverflow.ellipsis)
                                  ],
                                )),
                      ),
                    ),

                    SizedBox(
                      height: SizeConfig.screenHeight * 0.01,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (profileFormKey.currentState!.validate()) {
                          staffProfileController.isUpdateLoading(true);
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          String? userId =
                              sharedPreferences.getString(stored_uid);
                          api_services()
                              .update_profile(
                                  userId,
                                  pfname.text,
                                  plname.text,
                                  pphno.text,
                                  pemail.text,
                                  selectedValue4 ?? '',
                                  img64,
                                  staffProfileController.selectedProfession
                                      .toString()
                                      .substring(
                                          1,
                                          staffProfileController
                                                  .selectedProfession
                                                  .toString()
                                                  .length -
                                              1))
                              .then((value) {
                            staffProfileController.isUpdateLoading(false);
                            commonToast('Profile Updated Successfully');
                          });
                        }
                      },
                      child: Container(
                        width: SizeConfig.screenWidth * 0.9,
                        height: SizeConfig.screenHeight * 0.06,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: newLightColor,
                          border:
                              Border.all(color: common_color, width: 1),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Obx(
                            () => staffProfileController.isUpdateLoading.value
                                ? const commonindicator()
                                : Text("Update",
                              style: font_style.grad_600_16.copyWith(color: common_color))),
                      ),
                    ).paddingSymmetric(horizontal: 15),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.01,
                    ),
                    Center(
                        child: GestureDetector(
                            onTap: () async {
                              SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              sharedPreferences.clear();
                              Get.offAll(const login_page());
                            },
                            child: Text(
                              "Log Out",
                              style: font_style.yellow_600_14_underline,
                            ))),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.01,
                    ),
                  ],
                ),
              ),
            )),
    );
  }
}
