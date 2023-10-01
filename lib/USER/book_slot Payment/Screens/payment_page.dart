import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hairgarden/COMMON/common_circular_indicator.dart';
import 'package:hairgarden/COMMON/comontoast.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:hairgarden/USER/book_slot%20Payment/Screens/all_coupens_page.dart';
import 'package:hairgarden/USER/book_slot%20Payment/Screens/instamojo_screen.dart';
import 'package:hairgarden/USER/book_slot%20Payment/Screens/payment_done_page.dart';
import 'package:hairgarden/USER/common/common_txt_list.dart';
import 'package:instamojo/instamojo.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../COMMON/common_color.dart';
import 'package:dio/dio.dart' as formData;
import '../../myprofile/Controller/get_profile_info_controller.dart';
import '../Controller/book_service_controller.dart';
import '../Controller/get_coupon_controller.dart';
import 'razor_credentials.dart' as razorCredentials;
import '../../../COMMON/common_color.dart';
import '../../../COMMON/size_config.dart';
import '../../category/Controller/get_cart_controller.dart';
import '../../common/common_txtform_yllow.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class payment_page extends StatefulWidget {
  String? getslotid,
      getprice,
      getcatid,
      getbookdate,
      getaddressid,
      getstaffid,
      getstafftype;

  payment_page(
      {this.getslotid,
      this.getprice,
      this.getcatid,
      this.getbookdate,
      this.getaddressid,
      this.getstaffid,
      this.getstafftype});

  @override
  State<payment_page> createState() => _payment_pageState();
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

class _payment_pageState extends State<payment_page> {
  int selected_payment = 0;
  List payment_list = [
    "Credit Card",
    "Debit Card",
    "Pay by Cash",
    "Credit Card",
  ];
  List tips = [
    "20",
    "50",
    "100",
    "250",
  ];
  bool showcoupon = false;
  String selected_tip = "20";
  String? couponDiscountAmount;
  bool isTipSelected = false;

  final _get_cart = Get.put(get_cart_controller());
  final _get_copupon = Get.put(get_coupon_controller());
  final _get_user_prof = Get.put(get_profile_info_controller());

  TextEditingController cno = TextEditingController();
  TextEditingController cholder = TextEditingController();
  TextEditingController cexpiry = TextEditingController();
  TextEditingController ccvv = TextEditingController();
  TextEditingController coupon = TextEditingController();
  int walletValue = -1;
  bool isWallet = false;
  final _razorpay = Razorpay();
  String? _deviceId;

  final _get_profile_info = Get.put(get_profile_info_controller());

  Future<void> initPlatformState() async {
    String? deviceId;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }
    if (!mounted) return;
    setState(() {
      _deviceId = deviceId;
    });
  }

  String? uid;

  Future<void> getuserid() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    setState(() {
      uid = sf.getString("stored_uid");
      print("USER ID ID ${uid.toString()}");
    });
  }

  @override
  void initState() {
    getuserid().then((value) {
      _get_copupon.getAllCoupen(uid);
      _get_cart.getWalletAmount(uid);
      _get_user_prof.get_profile_info_cont(uid);
    });

    initPlatformState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    //   _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    //   _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    // });
    super.initState();
  }

  String? tot, discount, slot;

  // void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //   // Do something when payment succeeds

  //   verifySignature(
  //     signature: response.signature,
  //     paymentId: response.paymentId,
  //     orderId: response.orderId,
  //   );
  //   Get.to(payment_done_page(
  //     discount: discount.toString(),
  //     date: widget.getbookdate.toString(),
  //     tip: '',
  //   ));
  // }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message ?? ''),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.walletName ?? ''),
      ),
    );
  }

  startInstamojo(var amount) async {
    Dio dio = Dio();
    final user_form = formData.FormData.fromMap({
      "allow_repeated_payments": false,
      "amount":amount,
      "buyer_name":
          '${_get_profile_info.response.value.data?.firstName} ${_get_profile_info.response.value.data?.lastName}',
      "purpose": "Appoitment Booking Payment",
      "redirect_url": "http://www.example.com/redirect/",
      "phone": _get_profile_info.response.value.data?.mobile,
      "send_email": true,
      "webhook": "http://www.example.com/webhook/",
      "send_sms": true,
      "email": _get_profile_info.response.value.data?.email
    });
    final response =
        await dio.post("https://www.instamojo.com/api/1.1/payment-requests/",
            data: user_form,
            options: Options(headers: {
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

// create order
  void createOrder() async {
    // String username = razorCredentials.keyId;
    // String password = razorCredentials.keySecret;
    // String basicAuth =
    //     'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    // Map<String, dynamic> body = {
    //   "amount": 100,
    //   "currency": "INR",
    //   "receipt": "rcptid_11"
    // };
    // // var res = await http.post(
    // //   Uri.https(
    // //       "api.razorpay.com", "v1/orders"), //https://api.razorpay.com/v1/orders
    // //   headers: <String, String>{
    // //     "Content-Type": "application/json",
    // //     'authorization': basicAuth,
    // //   },
    // //   body: jsonEncode(body),
    // // );

    // if (res.statusCode == 200) {
    //   openGateway(jsonDecode(res.body)['id']);
    // }
    // print(res.body);
  }

  // openGateway(String orderId) {
  //   var options = {
  //     'key': razorCredentials.keyId,
  //     'amount': 100, //in the smallest currency sub-unit.
  //     'name': 'Hair Garden',
  //     'order_id': orderId, // Generate order_id using Orders API
  //     'description': 'Fine T-Shirt',
  //     'timeout': 60 * 5, // in seconds // 5 minutes
  //     'prefill': {
  //       'contact': '9123456789',
  //       'email': 'mailto:ary@example.com',
  //     }
  //   };
  //   _razorpay.open(options);
  // }

  // verifySignature({
  //   String? signature,
  //   String? paymentId,
  //   String? orderId,
  // }) async {
  //   // Map<String, dynamic> body = {
  //   //   'razorpay_signature': signature,
  //   //   'razorpay_payment_id': paymentId,
  //   //   'razorpay_order_id': orderId,
  //   // };

  //   // var parts = [];
  //   // body.forEach((key, value) {
  //   //   parts.add('${Uri.encodeQueryComponent(key)}='
  //   //       '${Uri.encodeQueryComponent(value)}');
  //   // });
  //   // var formData = parts.join('&');
  //   // var res = await http.post(
  //   //   Uri.https(
  //   //     "10.0.2.2", // my ip address , localhost
  //   //     "razorpay_signature_verify.php",
  //   //   ),
  //   //   headers: {
  //   //     "Content-Type": "application/x-www-form-urlencoded", // urlencoded
  //   //   },
  //   //   body: formData,
  //   // );

  //   // print(res.body);
  //   // if (res.statusCode == 200) {
  //   //   ScaffoldMessenger.of(context).showSnackBar(
  //   //     SnackBar(
  //   //       content: Text(res.body),
  //   //     ),
  //   //   );
  //   // }
  // }

  @override
  void dispose() {
    // _razorpay.clear(); // Removes all listeners

    super.dispose();
  }

  List paymentoption = [
    "Pay through Credit / Debit Card / UPI",
    "Pay After Service"
  ];

  int _oneValue = 0;
  bool iscoupapply = false;

  final _book_service = Get.put(book_service_controller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg_col,
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
          "Payment",
          style: font_style.green_600_20,
        ),

        // bottom: PreferredSize(
        //   preferredSize: Size.fromHeight(SizeConfig.screenHeight*0.055),
        //   child: Padding(
        //     padding:  EdgeInsets.only(left: SizeConfig.screenWidth*0.05),
        //     child: Container(
        //       height: SizeConfig.screenHeight*0.04,
        //       width: SizeConfig.screenWidth,
        //       child: ListView.separated(
        //         shrinkWrap: true,
        //         scrollDirection: Axis.horizontal,
        //         itemCount: payment_list.length,
        //         itemBuilder: (context, index) {
        //           return InkWell(
        //             onTap: (){
        //               setState(() {
        //                 selected_payment=index;
        //               });
        //             },
        //             child: Container(
        //               padding: EdgeInsets.symmetric(horizontal: 10),
        //               alignment: Alignment.center,
        //               height: SizeConfig.screenHeight*0.04,
        //               decoration: BoxDecoration(
        //                   color: selected_payment==index?common_color:Colors.transparent,
        //                   border: Border.all(color: common_color),
        //                   borderRadius: BorderRadius.circular(50)
        //               ),
        //               child: Text(payment_list[index].toString(),style:selected_payment==index?font_style.white_400_14: font_style.black_400_14,),
        //             ),
        //           );
        //         },
        //         separatorBuilder: (context, index) {
        //           return SizedBox(width: SizeConfig.screenWidth*0.03,);
        //         },
        //       ),
        //     ),
        //   ) ,
        // ),
      ),
      body: Obx(() {
        return _get_cart.loading.value ||
                _get_copupon.loading.value ||
                _get_user_prof.loading.value
            ? const CommonIndicator()
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.01,
                    ),
                    //LINE
                    Center(
                        child: Container(
                      height: 1,
                      color: line_cont_col,
                      width: SizeConfig.screenWidth,
                    )),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.020,
                    ),

                    //SUMMARY
                    Center(
                      child: SizedBox(
                        width: SizeConfig.screenWidth * 0.9,
                        child: Text(
                          "Summary",
                          style: font_style.black_600_20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.006,
                    ),
                    //PRODUCT COST
                    Center(
                      child: SizedBox(
                        width: SizeConfig.screenWidth * 0.9,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Service Name",
                              style: font_style.black_400_16,
                            ),
                            const Spacer(),
                            Text(
                              "${_get_cart.response.value.data?[0].title.toString()}",
                              style: font_style.black_500_14,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.006,
                    ),
                    Center(
                      child: SizedBox(
                        width: SizeConfig.screenWidth * 0.9,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Price",
                              style: font_style.black_400_16,
                            ),
                            const Spacer(),
                            Text(
                              "₹ ${double.parse(_get_cart.response.value.total.toString()).toStringAsFixed(2)}",
                              style: font_style.black_500_14,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.006,
                    ),

                    //TIP AMOUNT
                    isTipSelected
                        ? Center(
                            child: SizedBox(
                              width: SizeConfig.screenWidth * 0.9,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Tip Amount",
                                    style: font_style.black_400_16,
                                  ),
                                  const Spacer(),
                                  Text(
                                    '₹ ${double.parse(selected_tip.toString()).toStringAsFixed(2)}',
                                    style: font_style.black_500_14,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.006,
                    ),
                    iscoupapply == true
                        ? Center(
                      child: SizedBox(
                        width: SizeConfig.screenWidth * 0.9,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Discount From Coupon",
                              style: font_style.black_400_16,
                            ),
                            const Spacer(),
                            Text(
                              "- ₹ ${(double.parse(couponDiscountAmount.toString()))}",
                              style: font_style.black_500_14,
                            ),
                          ],
                        ),
                      ),
                    )
                        : Container(),
                    // Center(
                    //     child: Container(
                    //   height: 1,
                    //   color: line_cont_col,
                    //   width: SizeConfig.screenWidth * 0.9,
                    // )),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.017,
                    ),

                    //WALLET DEDUCT


                    //LINE
                    iscoupapply == true
                        ? Center(
                            child: Container(
                            height: 1,
                            color: line_cont_col,
                            width: SizeConfig.screenWidth * 0.9,
                          ))
                        : Container(),
                    iscoupapply == true
                        ? SizedBox(
                            height: SizeConfig.screenHeight * 0.017,
                          )
                        : const SizedBox(
                            height: 0,
                          ),

                    //TOTAL
                    Center(
                      child: SizedBox(
                        width: SizeConfig.screenWidth * 0.9,
                        child: Row(
                          children: [
                            Text(
                              "Total",
                              style: font_style.black_400_16,
                            ),
                            const Spacer(),
                            iscoupapply == true
                                ? isTipSelected == true
                                    ? Text(
                                        "₹ ${int.parse(_get_cart.response.value.total.toString()) - (int.parse(selected_tip)) - int.parse(couponDiscountAmount ?? 0.toString())}",
                                        style:
                                            font_style.black_600_14_nounderline,
                                      )
                                    : Text(
                                        "₹ ${int.parse(_get_cart.response.value.total.toString()) - int.parse(couponDiscountAmount ?? 0.toString())}",
                                        style:
                                            font_style.black_600_14_nounderline,
                                      )
                                : isTipSelected == true
                                    ? Text(
                                        "₹ ${(int.parse(_get_cart.response.value.total.toString()) - (int.parse(selected_tip)) - int.parse(couponDiscountAmount ?? 0.toString())).toDouble().toStringAsFixed(2)}",
                                        style:
                                            font_style.black_600_14_nounderline,
                                      )
                                    : Text(
                                        "₹ ${(int.parse(_get_cart.response.value.total.toString()) - int.parse(couponDiscountAmount ?? 0.toString())).toDouble().toStringAsFixed(2)}",
                                        style:
                                            font_style.black_600_14_nounderline,
                                      ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.025),
                    //LINE
                    Center(
                        child: Container(
                      height: 1,
                      color: line_cont_col,
                      width: SizeConfig.screenWidth,
                    )),
                    SizedBox(height: SizeConfig.screenHeight * 0.025),
                    //CARD NO TEXT
                    // Center(
                    //   child: Container(
                    //     width: SizeConfig.screenWidth*0.9,
                    //     child: Text("Card Number",style: font_style.gr27272A_600_14,),
                    //   ),
                    // ),
                    // SizedBox(height: SizeConfig.screenHeight*0.015,),
                    // Center(child: common_txtform_yllow(hinttxt: "XXXX-XXXX-XXXX",controller: cno),),
                    //
                    // SizedBox(height: SizeConfig.screenHeight*0.015,),
                    // //CARD HOLDER
                    // Center(
                    //   child: Container(
                    //     width: SizeConfig.screenWidth*0.9,
                    //     child: Text("Card Holder",style: font_style.gr27272A_600_14,),
                    //   ),
                    // ),
                    // SizedBox(height: SizeConfig.screenHeight*0.015,),
                    // Center(child: common_txtform_yllow(hinttxt: "XXXXXXXX XXXXX",controller: cholder),),
                    //
                    // SizedBox(height: SizeConfig.screenHeight*0.015,),
                    // Center(
                    //   child: Container(
                    //     width: SizeConfig.screenWidth*0.9,
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         //EXPIRY
                    //         Column(
                    //           children: [
                    //             //EXPIRY DATE
                    //             Center(
                    //               child: Container(
                    //                 width: SizeConfig.screenWidth*0.42,
                    //                 child: Text("Expiry Date",style: font_style.gr27272A_600_14,),
                    //               ),
                    //             ),
                    //             SizedBox(height: SizeConfig.screenHeight*0.015,),
                    //             Container(
                    //               width: SizeConfig.screenWidth*0.42,
                    //               child: TextFormField(
                    //                 // textAlignVertical: TextAlignVertical.center,
                    //                 controller: cexpiry,
                    //                 textAlignVertical: TextAlignVertical.center,
                    //                 style: font_style.greyA1A1AA_400_16,
                    //                 keyboardType: TextInputType.number,
                    //                 inputFormatters: [
                    //                   FilteringTextInputFormatter.digitsOnly,
                    //                   LengthLimitingTextInputFormatter(4),
                    //                   CardMonthInputFormatter(),
                    //                 ],
                    //                 decoration:  InputDecoration(
                    //                   hintStyle: font_style.greyA1A1AA_400_16,
                    //                     hintText: "XX/XX",
                    //                     contentPadding: EdgeInsets.only(left: 6),
                    //                   enabledBorder: OutlineInputBorder(
                    //                     borderRadius: BorderRadius.circular(4),
                    //                     borderSide: BorderSide(color: yellow_col),
                    //                   ),
                    //                   focusedBorder:OutlineInputBorder(
                    //                     borderRadius: BorderRadius.circular(4),
                    //                     borderSide: BorderSide(color: yellow_col),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //
                    //         //CVV
                    //         Column(
                    //           children: [
                    //             //CVV
                    //             Center(
                    //               child: Container(
                    //                 width: SizeConfig.screenWidth*0.42,
                    //                 child: Text("CVV",style: font_style.gr27272A_600_14,),
                    //               ),
                    //             ),
                    //             SizedBox(height: SizeConfig.screenHeight*0.015,),
                    //             Container(
                    //               width: SizeConfig.screenWidth*0.42,
                    //               child: TextFormField(
                    //                 controller: ccvv,
                    //                 // textAlignVertical: TextAlignVertical.center,
                    //                 textAlignVertical: TextAlignVertical.center,
                    //                 style: font_style.greyA1A1AA_400_16,
                    //                 keyboardType: TextInputType.number,
                    //                 inputFormatters: [
                    //                   FilteringTextInputFormatter.digitsOnly,
                    //                   LengthLimitingTextInputFormatter(4),
                    //                   CardMonthInputFormatter(),
                    //                 ],
                    //                 decoration:  InputDecoration(
                    //                   hintStyle: font_style.greyA1A1AA_400_16,
                    //                   hintText: "XXX",
                    //                   contentPadding: EdgeInsets.only(left: 6),
                    //                   enabledBorder: OutlineInputBorder(
                    //                     borderRadius: BorderRadius.circular(4),
                    //                     borderSide: BorderSide(color: yellow_col),
                    //                   ),
                    //                   focusedBorder:OutlineInputBorder(
                    //                     borderRadius: BorderRadius.circular(4),
                    //                     borderSide: BorderSide(color: yellow_col),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: SizeConfig.screenHeight*0.038,),

                    //ADD A TIP TXT
                    Center(
                      child: SizedBox(
                        width: SizeConfig.screenWidth * 0.9,
                        child: Text(
                          "Add a Tip for your professional Hard Work :)",
                          style: font_style.black_600_16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.015,
                    ),

                    //LISTVIEW TIPS
                    Center(
                      child: SizedBox(
                        height: SizeConfig.screenHeight * 0.04,
                        width: SizeConfig.screenWidth * 0.9,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 4,
                          itemBuilder: (context, tipindex) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  isTipSelected =! isTipSelected;
                                  if(isTipSelected)
                                  {
                                    selected_tip = tips[tipindex];
                                  }
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                alignment: Alignment.center,
                                height: SizeConfig.screenHeight * 0.04,
                                decoration: BoxDecoration(
                                    color: (selected_tip == tips[tipindex] &&
                                            isTipSelected == true)
                                        ? common_color
                                        : Colors.transparent,
                                    border: Border.all(color: common_color),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Text(
                                  '₹ ${tips[tipindex].toString()}',
                                  style: (selected_tip == tips[tipindex] &&
                                          isTipSelected == true)
                                      ? font_style.white_400_14
                                      : font_style.black_400_14,
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, tipindex) {
                            return SizedBox(
                              width: SizeConfig.screenWidth * 0.03,
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.036,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: yellow_col, width: 1.0),
                          borderRadius: BorderRadius.circular(4)),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Radio<int>(
                            activeColor: yellow_col,
                            value: 0,
                            groupValue: walletValue,
                            onChanged: (_get_cart.walletAMount.value==0.0)?(int? value){
                              commontoas('Your Wallet Balance is 0');
                            }:(int? value) {
                              setState(() {
                                walletValue = value!;
                                isWallet = true;
                              });
                            },
                          ),
                           Icon(
                            Icons.account_balance_wallet,
                            color: common_color,
                          ),
                          const SizedBox(width: 15),
                          Text(
                            "Wallet Balance",
                            style: font_style.black_600_16,
                          ),
                          const Spacer(),
                          Obx(() => Text(
                                "₹${_get_cart.walletAMount.value.toStringAsFixed(2)}",
                                style: font_style.black_600_16,
                              )),
                          SizedBox(
                            width: SizeConfig.screenWidth * 0.020,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.025,
                    ),
                    (_get_copupon.couponModel().data?.isNotEmpty ??
                            false || iscoupapply == false)
                        ? Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: yellow_col, width: 1.0),
                                borderRadius: BorderRadius.circular(4)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                        "assets/images/offer_svg.svg",color: common_color),
                                    const SizedBox(width: 15),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${_get_copupon.couponModel().data?[0].description}",
                                          style: font_style.black_600_16,
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "CODE:",
                                              style: font_style.black_600_16
                                                  .copyWith(
                                                      color: const Color(
                                                          0xff18181B)),
                                            ),
                                            Text(
                                              "\t\t${_get_copupon.couponModel().data?[0].coupanCode}",
                                              style: font_style.black_600_16
                                                  .copyWith(color: yellow_col),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    const Spacer(),
                                    InkWell(
                                      onTap: () {
                                        _get_copupon.applyCoupon(
                                            uid,
                                            _get_copupon
                                                .couponModel()
                                                .data?[0]
                                                .id);
                                        setState(() {
                                          iscoupapply = true;
                                          couponDiscountAmount = _get_copupon
                                              .couponModel()
                                              .data?[0].amount;
                                        });
                                      },
                                      child: Container(
                                        width: 80,
                                        height: 32,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                SizeConfig.screenHeight * 0.01),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          color: yellow_col,
                                        ),
                                        // child: Text("PAY ₹ ${int.parse(_get_cart.response.value.total.toString())+int.parse(selected_tip.toString().substring(1))}",style: font_style.white_600_14,),
                                        child: Text(
                                          "APPLY",
                                          style: font_style.white_600_16,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: SizeConfig.screenWidth * 0.020,
                                    ),
                                  ],
                                ),
                                const Divider(
                                  thickness: 1.0,
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(const AllCouponPage());
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "View all Coupon",
                                        style: font_style.black_600_16.copyWith(
                                            color: const Color(0xff27272A)),
                                      ),
                                      const SizedBox(width: 5),
                                      const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 13)
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.015,
                    ),
                    //CHOOSE PAYMENT OPTION
                    Center(
                      child: SizedBox(
                        width: SizeConfig.screenWidth * 0.9,
                        child: Text(
                          "Choose your payment method",
                          style: font_style.black_600_16,
                        ),
                      ),
                    ),

                    ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: paymentoption.length,
                      controller: ScrollController(),
                      separatorBuilder: (_, __) => const SizedBox(height: 0),
                      itemBuilder: (context, index) => RadioListTile(
                        activeColor: yellow_col,
                        title: Text(paymentoption[index].toString()),
                        value: index,
                        groupValue: _oneValue,
                        onChanged: (value) {
                          setState(() {
                            _oneValue = value!;
                          });
                        },
                      ),
                    ),

                    SizedBox(
                      height: SizeConfig.screenHeight * 0.015,
                    ),
                    //APPLY COUPON
                    // Center(
                    //   child: Container(
                    //     width: SizeConfig.screenWidth*0.9,
                    //     child: Row(
                    //       children: [
                    //         SvgPicture.asset("assets/images/apply_cupon.svg"),
                    //         SizedBox(width: SizeConfig.screenWidth*0.02,),
                    //         Text("Apply Coupon Code",style: font_style.black_600_16,),
                    //         Spacer(),
                    //         showcoupon==true?
                    //         InkWell(
                    //             onTap: (){
                    //               setState(() {
                    //                 showcoupon=false;
                    //               });
                    //             },
                    //             child: Icon(Icons.keyboard_arrow_up_rounded)):
                    //         InkWell(
                    //             onTap: (){
                    //               setState(() {
                    //                 showcoupon=true;
                    //               });
                    //             },
                    //             child: Icon(Icons.keyboard_arrow_down_outlined))
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    //
                    // SizedBox(height: SizeConfig.screenHeight*0.015,),
                    //
                    // //APPLY TXTFORM
                    // showcoupon==true?
                    // Center(
                    //   child: Container(
                    //     width: SizeConfig.screenWidth*0.9,
                    //     child: Row(
                    //       children: [
                    //         Container(
                    //           padding: EdgeInsets.zero,
                    //           height: SizeConfig.screenHeight*0.05,
                    //           width: SizeConfig.screenWidth*0.6 ,
                    //           child: TextFormField(
                    //             style:  font_style.greyA1A1AA_400_16,
                    //             controller: coupon,
                    //             decoration: InputDecoration(
                    //                 enabledBorder: OutlineInputBorder(
                    //                   borderRadius: BorderRadius.circular(4),
                    //                   borderSide: BorderSide(color: yellow_col),
                    //                 ),
                    //                 focusedBorder:OutlineInputBorder(
                    //                   borderRadius: BorderRadius.circular(4),
                    //                   borderSide: BorderSide(color: yellow_col),
                    //                 ),
                    //                 hintText: "XXXXXXX",
                    //                 hintStyle: font_style.greyA1A1AA_400_16,
                    //                 contentPadding: EdgeInsets.only(left: 6)
                    //             ),
                    //           ),
                    //         ),
                    //         SizedBox(width: SizeConfig.screenWidth*0.03,),
                    //         Expanded(
                    //           child: Container(
                    //             height: SizeConfig.screenHeight*0.05,
                    //             alignment: Alignment.center,
                    //             decoration: BoxDecoration(
                    //               borderRadius:BorderRadius.circular(8),
                    //               color: yellow_col,
                    //             ),
                    //             child: Text("APPLY",style: font_style.white_600_14,),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ):Container(),

                    // _get_copupon.response.value.status == "false"
                    //     ? Container()
                    //     : Center(
                    //   child: SizedBox(
                    //     width: SizeConfig.screenWidth * 0.9,
                    //     child: Row(
                    //       children: [
                    //         Expanded(
                    //           child: Container(
                    //               child: Text(
                    //                 "Use ${_get_copupon.response.value.data!.redeempercent}% Amount from your Wallet",
                    //                 style: font_style.black_500_16,
                    //               )),
                    //         ),
                    //         const SizedBox(
                    //           width: 10,
                    //         ),
                    //         InkWell(
                    //           onTap: () {
                    //             if (iscoupapply == false) {
                    //               setState(() {
                    //                 iscoupapply = true;
                    //               });
                    //             } else {
                    //               setState(() {
                    //                 iscoupapply = false;
                    //               });
                    //             }
                    //           },
                    //           child: iscoupapply == false
                    //               ? Container(
                    //             alignment: Alignment.center,
                    //             height:
                    //             SizeConfig.screenHeight * 0.04,
                    //             width:
                    //             SizeConfig.screenWidth * 0.18,
                    //             decoration: BoxDecoration(
                    //                 borderRadius:
                    //                 BorderRadius.circular(8),
                    //                 color: common_color),
                    //             child: Text(
                    //               "Apply",
                    //               style: font_style.white_500_16,
                    //             ),
                    //           )
                    //               : Container(
                    //             alignment: Alignment.center,
                    //             height:
                    //             SizeConfig.screenHeight * 0.04,
                    //             padding: const EdgeInsets.symmetric(
                    //                 horizontal: 10),
                    //             decoration: BoxDecoration(
                    //                 borderRadius:
                    //                 BorderRadius.circular(8),
                    //                 color: yellow_col),
                    //             child: Row(
                    //               children: [
                    //                 const Icon(
                    //                   Icons.close,
                    //                   color: Colors.white,
                    //                   size: 18,
                    //                 ),
                    //                 const SizedBox(
                    //                   width: 5,
                    //                 ),
                    //                 Text(
                    //                   "REMOVE",
                    //                   style:
                    //                   font_style.white_500_14,
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    SizedBox(
                      height: SizeConfig.screenHeight * 0.036,
                    ),
                  ],
                ),
              );
      }),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Center(
            child: Obx(() {
              return SizedBox(
                width: SizeConfig.screenWidth,
                child: InkWell(
                  onTap: () {
                    var totalPrice;
                    if(iscoupapply == true && isTipSelected == true)
                    {
                      totalPrice = '${int.parse(_get_cart.response.value.total.toString()) - (int.parse(selected_tip)) - int.parse(couponDiscountAmount ?? 0.toString())}';
                    }
                    else if(iscoupapply == true)
                    {
                      totalPrice = '${int.parse(_get_cart.response.value.total.toString()) - int.parse(couponDiscountAmount ?? 0.toString())}';
                    }
                    else if(isTipSelected == true)
                    {
                      totalPrice = '${(int.parse(_get_cart.response.value.total.toString()) - (int.parse(selected_tip)))}';
                    }
                    else
                    {
                      totalPrice= '${int.parse(_get_cart.response.value.total.toString())}';
                    }

                    if (_oneValue == 0) {
                      startInstamojo(double.parse(totalPrice.toString()));
                    } else if (_oneValue == 1) {
                      _book_service.book_service_cont(
                          iscoupapply == false
                              ? ""
                              : couponDiscountAmount.toString(),
                          isTipSelected
                              ? selected_tip
                              : "",
                          uid.toString() == "" || uid == null
                              ? ""
                              : uid.toString(),
                          widget.getcatid.toString(),
                          iscoupapply == false ? "0" : "1",
                          selected_tip,
                          _deviceId.toString(),
                          widget.getslotid.toString(),
                          totalPrice,
                          "DEMO1",
                          "success",
                          widget.getbookdate.toString(),
                          widget.getaddressid,
                          widget.getstaffid == "" || widget.getstaffid == null
                              ? ""
                              : widget.getstaffid.toString(),
                          widget.getstafftype,
                          widget.getbookdate.toString());
                    } else {
                      commontoas("Please select Payment Option");
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.screenHeight * 0.02),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8)),
                      color: yellow_col,
                    ),
                    // child: Text("PAY ₹ ${int.parse(_get_cart.response.value.total.toString())+int.parse(selected_tip.toString().substring(1))}",style: font_style.white_600_14,),
                    child: _book_service.loading.value
                        ? const CupertinoActivityIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "PROCEED TO BOOKING",
                            style: font_style.white_600_16,
                          ),
                  ),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
