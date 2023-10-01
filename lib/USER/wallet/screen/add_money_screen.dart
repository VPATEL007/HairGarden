import 'package:dio/dio.dart' as formData;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hairgarden/COMMON/common_color.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:hairgarden/COMMON/size_config.dart';
import 'package:hairgarden/USER/book_slot%20Payment/Screens/instamojo_screen.dart';
import 'package:hairgarden/USER/wallet/controller/wallet_controller.dart';
import 'package:hairgarden/USER/wallet/screen/payment_gateway.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({Key? key}) : super(key: key);

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  TextEditingController amountController = TextEditingController();
  final walletController = Get.put(WalletController());
  String? userID;
  Future<void> getUserId() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    setState(() {
      userID = sf.getString("stored_uid");
    });
    print(userID);
  }

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  startInstamojo(var amount) async {
    formData.Dio dio = formData.Dio();
    final user_form = formData.FormData.fromMap({
      "allow_repeated_payments": false,
      "amount":amount,
      "buyer_name":
      'Test VIjay',
      "purpose": "Appoitment Booking Payment",
      "redirect_url": "http://www.example.com/redirect/",
      "phone": "9537852525",
      "send_email": true,
      "webhook": "http://www.example.com/webhook/",
      "send_sms": true,
      "email": "abc@gmail.com"
    });
    final response =
    await dio.post("https://www.instamojo.com/api/1.1/payment-requests/",
        data: user_form,
        options: formData.Options(headers: {
          "X-Api-Key": "aa85ccf4cf53c2ba2f181a63c857b567",
          "X-Auth-Token": "3ef238de940014b6d9b51e99f1f0d5d3",
        }));
    print('Response===${response.data['payment_request']['longurl']}');
    String url = response.data['payment_request']['longurl'];
    dynamic result = await Navigator.push(context,
        MaterialPageRoute(builder: (ctx) => InAppWebViewScreen(url: url)));
    print('Result===$result');
    // setState(() {
    //   print(result.toString());
    // });
  }


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
          "Add Money",
          style: font_style.green_600_20,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Enter Amount",
                style: font_style.black_600_16.copyWith(fontSize: 16),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: amountController,
                decoration: InputDecoration(
                    isDense: true,
                    hintText: '₹1000',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 13, horizontal: 15),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: yellow_col)),
                    prefixText: '₹',
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: yellow_col))),
              ),
            ),
            const SizedBox(height: 15),

            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 15),
            //   child: Align(
            //     child: Text(
            //       "Recommended*",
            //       style: font_style.black_600_16.copyWith(fontSize: 16),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      amountController.text = 1000.toString();
                    },
                    child: Container(
                      width: 94,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: yellow_col),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        "₹1000",
                        style: font_style.black_600_16
                            .copyWith(fontSize: 16, color: yellow_col),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      amountController.text = 2000.toString();
                    },
                    child: Container(
                      width: 94,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: yellow_col),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        "₹2000",
                        style: font_style.black_600_16
                            .copyWith(fontSize: 16, color: yellow_col),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      amountController.text = 3000.toString();
                    },
                    child: Container(
                      width: 94,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: yellow_col),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        "₹3000",
                        style: font_style.black_600_16
                            .copyWith(fontSize: 16, color: yellow_col),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Align(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: InkWell(
                  onTap: () {
                    // Get.to(const PaymentGatewayScreen());
                    startInstamojo(10);
                  },
                  child: Container(
                    width: 175,
                    height: 40,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.screenHeight * 0.01),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: yellow_col,
                    ),
                    // child: Text("PAY ₹ ${int.parse(_get_cart.response.value.total.toString())+int.parse(selected_tip.toString().substring(1))}",style: font_style.white_600_14,),
                    child: Text(
                      "ADD MONEY",
                      style: font_style.white_600_16,
                    ),
                  ),
                ),
              ),
            ),
            const Divider(thickness: 1),
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Recommended Offers",
                      style: font_style.black_600_16.copyWith(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                    itemCount: walletController.availableCoupon().data?.length,
                    itemBuilder: (context, index) => Card(
                  elevation: 3.0,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Rs. ${walletController.availableCoupon().data?[index].offerAmount} Offer",
                            style: font_style.black_600_16.copyWith(fontSize: 16),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Cashback Rs. ${walletController.availableCoupon().data?[index].offerCashbook}",
                            style: font_style.black_600_16.copyWith(fontSize: 14,color:Colors.grey.withOpacity(0.70)),
                          ),
                        ],
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          walletController.applyAvailableCashback(userID,walletController.availableCoupon().data?[index].offerAmount,walletController.availableCoupon().data?[index].id).then((value)
                          {
                            amountController.text = walletController.availableCoupon().data?[index].offerAmount??'';
                          });
                        },
                        child: Text(
                          "APPLY",
                          style: font_style.black_600_16.copyWith(fontSize: 16,color: yellow_col),
                        ),
                      ),
                    ],
                  ).paddingAll(10),
                ))
              ],
            ).paddingSymmetric(horizontal: 15,vertical: 15),

          ],
        ),
      ),
    );
  }
}
