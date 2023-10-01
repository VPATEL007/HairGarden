import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:hairgarden/USER/support/controller/support_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../COMMON/common_color.dart';
import '../../../COMMON/size_config.dart';
import '../../common/common_txtform_yllow.dart';
import 'support_ticket.dart';

class support_page extends StatefulWidget {
  const support_page({Key? key}) : super(key: key);

  @override
  State<support_page> createState() => _support_pageState();
}

class _support_pageState extends State<support_page> {
  TextEditingController sup_subj = TextEditingController();
  TextEditingController sup_desc = TextEditingController();
  TextEditingController attachment = TextEditingController();
  FilePickerResult? result;
  GlobalKey<FormState> supportFormKey = GlobalKey();

  String? selected_file;

  final supportController = Get.put(SupportController());

  void _pickFile() async {
    // opens storage to pick files and the picked file or files
    // are assigned into result and if no file is chosen result is null.
    // you can also toggle "allowMultiple" true or false depending on your need
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    // if no file is picked
    if (result == null) return;

    // we will log the name, size and path of the
    // first picked file (if multiple are selected)
    setState(() {
      selected_file = result.files.first.name;
    });

  }

  File? profile_photo;
  String? img64;

  Future<void> addAttachment() async {
    XFile? xf = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xf != null) {
      setState(() {
        profile_photo = File(xf.path);
        attachment.text = xf.name.split('/').last;
        final bytes = File(xf.path).readAsBytesSync();
        img64 = base64Encode(bytes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: common_color,
            size: 20,
          )),
      title: Text(
        "Support",
        style: font_style.green_600_20,
      ),
    );
    double height = appBar.preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: bg_col,
      appBar: appBar,
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          height: SizeConfig.screenHeight - height - statusBarHeight,
          width: SizeConfig.screenWidth,
          child: Form(
            key: supportFormKey,
            child: Stack(children: [
              Positioned(
                bottom: SizeConfig.screenHeight * 0.1,
                child: SizedBox(
                  width: SizeConfig.screenWidth,
                  child: Center(
                    child: InkWell(
                      onTap: () async {
                        if (supportFormKey.currentState!.validate()) {
                          String? userId;
                          SharedPreferences sf =
                              await SharedPreferences.getInstance();
                          setState(() {
                            userId = sf.getString("stored_uid");
                          });
                          supportController.addTicket(userId ?? '',
                              sup_subj.text, sup_desc.text, img64??"");
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: SizeConfig.screenWidth * 0.35,
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.screenHeight * 0.01),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: yellow_col,
                        ),
                        child: Text(
                          "SUBMIT",
                          style: font_style.white_600_14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.035,
                  ),

                  //Subject TEXT
                  Center(
                    child: SizedBox(
                      width: SizeConfig.screenWidth * 0.9,
                      child: Text(
                        "Subject",
                        style: font_style.gr27272A_600_14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.015,
                  ),
                  Center(
                    child: common_txtform_yllow(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: yellow_col),
                      ),
                      hinttxt: "Enter subject",
                      controller: sup_subj,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Subject';
                        }
                        return null;
                      },
                    ),
                  ),

                  SizedBox(
                    height: SizeConfig.screenHeight * 0.015,
                  ),

                  //DESCRIPTION
                  Center(
                    child: SizedBox(
                      width: SizeConfig.screenWidth * 0.9,
                      child: Text(
                        "Description",
                        style: font_style.gr27272A_600_14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.015,
                  ),
                  Center(
                    child: SizedBox(
                      width: SizeConfig.screenWidth * 0.9,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Description';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.multiline,
                        maxLines: 7,

                        style: font_style.greyA1A1AA_400_16.copyWith(color: Colors.black),
                        controller: sup_desc,
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: yellow_col),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: yellow_col),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: yellow_col),
                            ),
                            hintText: "Enter about file",
                            hintStyle: font_style.greyA1A1AA_400_16,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 6)),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: SizeConfig.screenHeight * 0.015,
                  ),

                  //ATTACHMENT
                  Center(
                    child: SizedBox(
                      width: SizeConfig.screenWidth * 0.9,
                      child: Text(
                        "Attachment",
                        style: font_style.gr27272A_600_14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.015,
                  ),
                  Center(
                    child: SizedBox(
                      width: SizeConfig.screenWidth * 0.9,
                      child: TextFormField(
                        controller: attachment,
                        style: font_style.greyA1A1AA_400_16.copyWith(color: Colors.black),
                        readOnly: true,
                        validator: (value) {
                          if(value!.isEmpty)
                          {
                            return "Please select attachment";
                          }
                          return null;
                        },
                        decoration: InputDecoration(

                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: yellow_col),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: yellow_col),
                            ),
                            suffixIcon: InkWell(
                                onTap: () async {
                                  addAttachment();
                                },
                                child: SvgPicture.asset(
                                  "assets/images/attachment.svg",
                                  fit: BoxFit.scaleDown,
                                )),
                            hintText: selected_file.toString() == "" ||
                                    selected_file == null
                                ? "Attach File"
                                : selected_file.toString(),
                            hintStyle: font_style.greyA1A1AA_400_16,
                            contentPadding: const EdgeInsets.only(left: 6)),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
