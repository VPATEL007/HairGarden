import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hairgardenemployee/COMMON/common_color.dart';
import 'package:hairgardenemployee/COMMON/size_config.dart';
import 'package:hairgardenemployee/COMMON/font_style.dart';
import 'package:hairgardenemployee/EMPLOYEE/emp_bottombar.dart';
class rescheduling_request_page extends StatefulWidget {
  const rescheduling_request_page({Key? key}) : super(key: key);

  @override
  State<rescheduling_request_page> createState() => _rescheduling_request_pageState();
}

class _rescheduling_request_pageState extends State<rescheduling_request_page> {

  DatePickerController _controllerdate = DatePickerController();
  DateTime _selectedValue = DateTime.now();

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
        title: Text("Rescheduling",style: font_style.green_600_20),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: SizeConfig.screenHeight*0.02,),

            //WHEN WOULD YOU TXT
            Center(
              child: SizedBox(
                  width: SizeConfig.screenWidth*0.9,
                  child: Text("When would you like your service?",style: font_style.Recoleta_black_600_14,)),
            ),
            SizedBox(height: SizeConfig.screenHeight*0.02,),

            //CALENDER
            Center(
              child: SizedBox(
                width: SizeConfig.screenWidth*0.9,
                child: DatePicker(
                  DateTime.now(),
                  width: 60,
                  height: 80,
                  controller: _controllerdate,
                  initialSelectedDate: DateTime.now(),
                  selectionColor: yellow_col.withOpacity(0.7),
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
                  },
                ),
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight*0.025,),

            //WHAT TIME SLOT TXT
            Center(
              child: SizedBox(
                  width: SizeConfig.screenWidth*0.9,
                  child: Text("What time would you like to Book your Slot?",style: font_style.Recoleta_black_600_14,)),
            ),
            SizedBox(height: SizeConfig.screenHeight*0.025,),

            //GRIDVIEW TIMESLOTS
            Center(
              child: SizedBox(
                width: SizeConfig.screenWidth*0.9,
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  childAspectRatio: 3.6,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: SizeConfig.screenWidth*0.05,
                  children: List.generate(6, (index){
                    return Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: common_color,width: 1.5)
                      ),
                      child: Text("12:00-13:00",style: font_style.black_400_12,),
                    );
                  }),
                ),
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight*0.025,),

            //REASON TITLE
            Center(
              child: SizedBox(
                width: SizeConfig.screenWidth*0.9,
                child: Text("Reason*",style: font_style.darkgray_600_14,),
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight*0.01,),

            Center(
              child: SizedBox(
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
                Get.offAll(emp_bottombar(pasindx: 1));
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
