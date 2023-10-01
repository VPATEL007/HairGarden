import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hairgarden/COMMON/common_color.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:hairgarden/COMMON/size_config.dart';
import 'package:hairgarden/USER/wallet/screen/credit_card_page.dart';

class PaymentGatewayScreen extends StatefulWidget {
  const PaymentGatewayScreen({Key? key}) : super(key: key);

  @override
  State<PaymentGatewayScreen> createState() => _PaymentGatewayScreenState();
}

class _PaymentGatewayScreenState extends State<PaymentGatewayScreen> {
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
          "Payment Gateway",
          style: font_style.green_600_20,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 124,
                width: SizeConfig.screenWidth*0.40,
                decoration: BoxDecoration(
                    border: Border.all(color: yellow_col, width: 1.0),
                    borderRadius: BorderRadius.circular(4)),
                // padding:  EdgeInsets.symmetric(vertical: 20, horizontal: SizeConfig.screenWidth*0.085),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/paytm.png',width: 50,height: 50),
                    const SizedBox(height: 15),
                    Text(
                      "PAYTM",
                      style: font_style.black_600_16,
                    ),

                  ],
                ),
              ),
              SizedBox(width: SizeConfig.screenWidth*0.060),
              InkWell(
                onTap: () {
                  Get.to(CreditCardPage(title: 'UPI ID'));
                },
                child: Container(
                  height: 124,
                  width: SizeConfig.screenWidth*0.40,
                  decoration: BoxDecoration(
                      border: Border.all(color: yellow_col, width: 1.0),
                      borderRadius: BorderRadius.circular(4)),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/upi.png',width: 50,height: 50),
                      const SizedBox(height: 15),
                      Text(
                        "UPI ID",
                        style: font_style.black_600_16,
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Get.to(CreditCardPage(title: 'Debit Card'));
                },
                child: Container(
                  height: 124,

                  width: SizeConfig.screenWidth*0.40,
                  decoration: BoxDecoration(
                      border: Border.all(color: yellow_col, width: 1.0),
                      borderRadius: BorderRadius.circular(4)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/debit_card.png',width: 50,height: 50),
                      const SizedBox(height: 15),
                      Text(
                        "Debit Card",
                        style: font_style.black_600_16,
                      ),

                    ],
                  ),
                ),
              ),
              SizedBox(width: SizeConfig.screenWidth*0.060),
              InkWell(
                onTap: () {
                  Get.to(CreditCardPage(title: 'Credit Card'));
                },
                child: Container(
                  height: 124,
                  alignment: Alignment.center,
                  width: SizeConfig.screenWidth*0.40,
                  decoration: BoxDecoration(
                      border: Border.all(color: yellow_col, width: 1.0),
                      borderRadius: BorderRadius.circular(4)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/credit_card.png',width: 50,height: 50),
                      const SizedBox(height: 15),
                      Text(
                        "Credit Card",
                        style: font_style.black_600_16,
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
