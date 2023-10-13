import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hairgardenemployee/COMMON/common_color.dart';
import 'package:hairgardenemployee/COMMON/font_style.dart';
import 'package:hairgardenemployee/COMMON/size_config.dart';


class help_page extends StatefulWidget {
  const help_page({Key? key}) : super(key: key);

  @override
  State<help_page> createState() => _help_pageState();
}

class _help_pageState extends State<help_page> {

  DatePickerController _controllerdate = DatePickerController();
  DateTime _selectedValue = DateTime.now();

  List help_txt=[
    "I have other Appointments",
    "I’m having a Off day"
  ];
  int? _onevalue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg_col,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
            onTap: (){
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios_new,color: common_color,)),
        title: Text("Help",style: font_style.green_600_20),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: SizeConfig.screenHeight*0.02,),

            Center(
              child: Container(
                width: SizeConfig.screenWidth*0.9,
                child: ListView.separated(
                  itemCount: 2,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  controller: ScrollController(),
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) => Container(
                    child: Container(
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: yellow_col)
                      ),
                      child: RadioListTile(
                        contentPadding: EdgeInsets.zero,
                        activeColor: yellow_col,
                        title:  Text(help_txt[index],style: font_style.black_400_16,),
                        value: index,
                        groupValue: _onevalue,
                        onChanged: (value) {
                          setState(() {
                            _onevalue = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: SizeConfig.screenHeight*0.03,),

            //REASON TITLE
            Center(
              child: Container(
                width: SizeConfig.screenWidth*0.9,
                child: Text("Reason*",style: font_style.darkgray_600_14,),
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight*0.01,),

            Center(
              child: Container(
                  width: SizeConfig.screenWidth*0.9,
                  child: TextFormField(
                    maxLines: 5,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth*0.02,vertical: SizeConfig.screenHeight*0.01),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: yellow_col)
                        ),
                        focusedBorder:OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: yellow_col)
                        ),
                        hintText: "Reason for your Appointment Rescheduling*",
                        hintStyle: font_style.greyA1A1AA_600_14
                    ),
                  )
              ),
            ),

            SizedBox(height: SizeConfig.screenHeight*0.025,),
            GestureDetector(
              onTap: (){
                // Get.offAll(appointment_details_page());
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: SizeConfig.screenHeight*0.015),
                alignment: Alignment.center,
                width: SizeConfig.screenWidth*0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: yellow_col,
                ),
                child: Text("SUBMIT",style: font_style.white_600_16,),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
