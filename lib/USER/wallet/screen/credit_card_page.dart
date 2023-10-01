import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hairgarden/COMMON/common_color.dart';
import 'package:hairgarden/COMMON/size_config.dart';
import 'package:hairgarden/USER/common/common_txtform_yllow.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import '../../book_slot Payment/Screens/payment_page.dart';

class CreditCardPage extends StatefulWidget {
  final String title;
  const CreditCardPage({Key? key, required this.title}) : super(key: key);

  @override
  State<CreditCardPage> createState() => _CreditCardPageState();
}

class _CreditCardPageState extends State<CreditCardPage> {

  TextEditingController paymethod_cno = TextEditingController();
  TextEditingController paymethod_cholder = TextEditingController();
  TextEditingController paymethod_cexpiry = TextEditingController();
  TextEditingController paymethod_ccvv = TextEditingController();
  TextEditingController upiID = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          widget.title,
          style: font_style.green_600_20,
        ),
      ),
      body: SingleChildScrollView(
        child: widget.title=='UPI ID'?Column(
          children: [
            widget.title=='UPI ID'?SizedBox(height: SizeConfig.screenHeight*0.015):const SizedBox(),
            Center(
              child: SizedBox(
                width: SizeConfig.screenWidth*0.9,
                child: Text("UPI ID",style: font_style.gr27272A_600_14,),
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight*0.015,),
            Center(child: common_txtform_yllow(hinttxt: "9824092654@paytm",controller: upiID),),
            SizedBox(height: SizeConfig.screenHeight*0.020),
            Center(
              child: InkWell(
                onTap: (){

                },
                child: Container(
                  height: 40,
                  width: SizeConfig.screenWidth*0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: yellow_col,
                  ),
                  child: Center(child: Text("PAY NOW",style: font_style.white_600_14,)),
                ),
              ),
            )
          ],
        ):Column(
          children: [
            SizedBox(height: SizeConfig.screenHeight*0.035,),

            //CARD NO TEXT
            Center(
              child: SizedBox(
                width: SizeConfig.screenWidth*0.9,
                child: Text("Card Number",style: font_style.gr27272A_600_14,),
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight*0.015,),
            Center(child: common_txtform_yllow(hinttxt: "5482-6730-0012",controller: paymethod_cno),),

            SizedBox(height: SizeConfig.screenHeight*0.015,),

            //CARD HOLDER
            Center(
              child: SizedBox(
                width: SizeConfig.screenWidth*0.9,
                child: Text("Card Holder",style: font_style.gr27272A_600_14,),
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight*0.015,),
            Center(child: common_txtform_yllow(hinttxt: "Ankit Tiwari",controller: paymethod_cholder),),

            SizedBox(height: SizeConfig.screenHeight*0.015,),
            Center(
              child: SizedBox(
                width: SizeConfig.screenWidth*0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //EXPIRY
                    Column(
                      children: [
                        //EXPIRY DATE
                        Center(
                          child: SizedBox(
                            width: SizeConfig.screenWidth*0.42,
                            child: Text("Expiry Date",style: font_style.gr27272A_600_14,),
                          ),
                        ),
                        SizedBox(height: SizeConfig.screenHeight*0.015,),
                        SizedBox(
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
                              hintText: "9/12",
                              contentPadding: const EdgeInsets.only(left: 6),
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
                          child: SizedBox(
                            width: SizeConfig.screenWidth*0.42,
                            child: Text("CVV",style: font_style.gr27272A_600_14,),
                          ),
                        ),
                        SizedBox(height: SizeConfig.screenHeight*0.015,),
                        SizedBox(
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
                              hintText: "752",
                              contentPadding: const EdgeInsets.only(left: 6),
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
            SizedBox(height: SizeConfig.screenHeight*0.30),

            //PAY BUTTON
            Center(
              child: InkWell(
                onTap: (){

                },
                child: Container(
                  height: 40,
                  width: SizeConfig.screenWidth*0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: yellow_col,
                  ),
                  child: Center(child: Text("PAY NOW",style: font_style.white_600_14,)),
                ),
              ),
            )


          ],
        ),
      ),
    );
  }
}
