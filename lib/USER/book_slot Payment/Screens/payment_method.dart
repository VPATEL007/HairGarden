import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import '../../../COMMON/common_color.dart';

import '../../../COMMON/common_color.dart';
import '../../../COMMON/size_config.dart';
import '../../common/common_txtform_yllow.dart';


class payment_method extends StatefulWidget {
  const payment_method({Key? key}) : super(key: key);

  @override
  State<payment_method> createState() => _payment_methodState();
}
class CardMonthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != newText.length) {
        buffer.write('/');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}

class _payment_methodState extends State<payment_method> {

  int selected_payment=0;
  List payment_list=[
    "Credit Card",
    "Debit Card",
    "Pay by Cash",
    "Credit Card",
  ];
  TextEditingController paymethod_cno=TextEditingController();
  TextEditingController paymethod_cholder=TextEditingController();
  TextEditingController paymethod_cexpiry=TextEditingController();
  TextEditingController paymethod_ccvv=TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg_col,
      appBar:  AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: InkWell(
            onTap: (){
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios,color: common_color,size: 20,)),
        title: Text("Payment",style: font_style.green_600_16,),

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(SizeConfig.screenHeight*0.055),
          child: Padding(
            padding:  EdgeInsets.only(left: SizeConfig.screenWidth*0.05),
            child: Container(
              height: SizeConfig.screenHeight*0.04,
              width: SizeConfig.screenWidth,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: payment_list.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                      setState(() {
                        selected_payment=index;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      height: SizeConfig.screenHeight*0.04,
                      decoration: BoxDecoration(
                          color: selected_payment==index?common_color:Colors.transparent,
                          border: Border.all(color: common_color),
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: Text(payment_list[index].toString(),style:selected_payment==index?font_style.white_400_14: font_style.black_400_14,),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(width: SizeConfig.screenWidth*0.03,);
                },
              ),
            ),
          ) ,
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight*0.035,),

          //CARD NO TEXT
          Center(
            child: Container(
              width: SizeConfig.screenWidth*0.9,
              child: Text("Card Number",style: font_style.gr27272A_600_14,),
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight*0.015,),
          Center(child: common_txtform_yllow(hinttxt: "XXXX-XXXX-XXXX",controller: paymethod_cno),),

          SizedBox(height: SizeConfig.screenHeight*0.015,),

          //CARD HOLDER
          Center(
            child: Container(
              width: SizeConfig.screenWidth*0.9,
              child: Text("Card Holder",style: font_style.gr27272A_600_14,),
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight*0.015,),
          Center(child: common_txtform_yllow(hinttxt: "XXXXXXXX XXXXX",controller: paymethod_cholder),),

          SizedBox(height: SizeConfig.screenHeight*0.015,),
          Center(
            child: Container(
              width: SizeConfig.screenWidth*0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //EXPIRY
                  Column(
                    children: [
                      //EXPIRY DATE
                      Center(
                        child: Container(
                          width: SizeConfig.screenWidth*0.42,
                          child: Text("Expiry Date",style: font_style.gr27272A_600_14,),
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight*0.015,),
                      Container(
                        width: SizeConfig.screenWidth*0.42,
                        child: TextFormField(
                          // textAlignVertical: TextAlignVertical.center,
                          controller: paymethod_cexpiry,
                          textAlignVertical: TextAlignVertical.center,
                          style: font_style.greyA1A1AA_400_16,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                            CardMonthInputFormatter(),
                          ],
                          decoration:  InputDecoration(
                            hintStyle: font_style.greyA1A1AA_400_16,
                            hintText: "XX/XX",
                            contentPadding: EdgeInsets.only(left: 6),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: yellow_col),
                            ),
                            focusedBorder:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: yellow_col),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  //CVV
                  Column(
                    children: [
                      //CVV
                      Center(
                        child: Container(
                          width: SizeConfig.screenWidth*0.42,
                          child: Text("CVV",style: font_style.gr27272A_600_14,),
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight*0.015,),
                      Container(
                        width: SizeConfig.screenWidth*0.42,
                        child: TextFormField(
                          controller: paymethod_ccvv,
                          // textAlignVertical: TextAlignVertical.center,
                          textAlignVertical: TextAlignVertical.center,
                          style: font_style.greyA1A1AA_400_16,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                            CardMonthInputFormatter(),
                          ],
                          decoration:  InputDecoration(
                            hintStyle: font_style.greyA1A1AA_400_16,
                            hintText: "XXX",
                            contentPadding: EdgeInsets.only(left: 6),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: yellow_col),
                            ),
                            focusedBorder:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: yellow_col),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight*0.035,),

          //PAY BUTTON
          Center(
            child: InkWell(
              onTap: (){

              },
              child: Container(
                width: SizeConfig.screenWidth*0.3,
                padding: EdgeInsets.symmetric(vertical: SizeConfig.screenHeight*0.01),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: yellow_col,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add,color: Colors.white,size: SizeConfig.screenHeight*0.02,),
                    Text("ADD CARD",style: font_style.white_600_14,),
                  ],
                ),
              ),
            ),
          )


        ],
      ),

    );
  }
}
