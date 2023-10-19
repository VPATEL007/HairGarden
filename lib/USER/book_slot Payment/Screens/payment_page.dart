import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as formData;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hairgarden/COMMON/common_circular_indicator.dart';
import 'package:hairgarden/COMMON/comontoast.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:hairgarden/USER/book_slot%20Payment/Screens/all_coupens_page.dart';
import 'package:hairgarden/USER/book_slot%20Payment/Screens/instamojo_screen.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../COMMON/common_color.dart';
import '../../../COMMON/size_config.dart';
import '../../category/Controller/get_cart_controller.dart';
import '../../myprofile/Controller/get_profile_info_controller.dart';
import '../Controller/book_service_controller.dart';
import '../Controller/get_coupon_controller.dart';

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
  bool isPayAfterService = false;
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
    // });
    super.initState();
  }

  String? tot, discount, slot;

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
      "amount": amount,
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
  void createOrder() async {}

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
                      color: Colors.black,
                      width: SizeConfig.screenWidth,
                    )),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.015,
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
                      height: SizeConfig.screenHeight * 0.020,
                    ),
                    //PRODUCT COST
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _get_cart.response.value.data
                          ?.where((element) => element.type == "service")
                          .toList()
                          .length,
                      itemBuilder: (context, index) => Center(
                        child: Column(
                          children: [
                            SizedBox(
                              width: SizeConfig.screenWidth * 0.9,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${_get_cart.response.value.data?[index].title.toString()}",
                                    style: font_style.black_400_16,
                                  ),
                                  const Spacer(),
                                  Text(
                                    "₹ ${double.parse(_get_cart.response.value.data?[index].price.toString() ?? "").toStringAsFixed(2)}",
                                    style: font_style.black_500_14,
                                  ),
                                ],
                              ),
                            ),
                            index ==
                                    ((_get_cart.response.value.data
                                                ?.where((element) =>
                                                    element.type == "service")
                                                .toList()
                                                .length ??
                                            0) -
                                        1)
                                ? const SizedBox()
                                : Center(
                                    child: Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 7),
                                    height: 1.3,
                                    color: line_cont_col,
                                    width: SizeConfig.screenWidth * 0.9,
                                  )),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.010,
                    ),
                    (_get_cart.response.value.data
                                ?.where(
                                    (element) => element.type == "addonservice")
                                .toList()
                                .isNotEmpty ??
                            false)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: Container(
                                height: 1,
                                color: line_cont_col,
                                width: SizeConfig.screenWidth * 0.9,
                              )),
                              SizedBox(
                                height: SizeConfig.screenHeight * 0.010,
                              ),
                              Center(
                                child: SizedBox(
                                  width: SizeConfig.screenWidth * 0.9,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: _get_cart.response.value.data
                                          ?.where((element) =>
                                              element.type == "addonservice")
                                          .toList()
                                          .length,
                                      itemBuilder: (context, indexAT) => Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              indexAT == 0
                                                  ? Text(
                                                      "Add On Service",
                                                      style: font_style
                                                          .black_500_16,
                                                    )
                                                  : SizedBox(),
                                              SizedBox(
                                                height:
                                                    SizeConfig.screenHeight *
                                                        0.010,
                                              ),
                                              Center(
                                                  child: Container(
                                                height: 1,
                                                color: line_cont_col,
                                                width: SizeConfig.screenWidth *
                                                    0.9,
                                              )),
                                              SizedBox(
                                                height:
                                                    SizeConfig.screenHeight *
                                                        0.010,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${_get_cart.response.value.data?.where((element) => element.type == "addonservice").toList()[indexAT].title.toString().capitalizeFirst}",
                                                    style:
                                                        font_style.black_400_16,
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    "₹ ${double.parse(_get_cart.response.value.data?.where((element) => element.type == "addonservice").toList()[indexAT].price ?? "").toStringAsFixed(2)}",
                                                    style:
                                                        font_style.black_500_14,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.screenHeight * 0.010,
                              ),
                              Center(
                                  child: Container(
                                height: 1,
                                color: line_cont_col,
                                width: SizeConfig.screenWidth * 0.9,
                              )),
                              SizedBox(
                                height: SizeConfig.screenHeight * 0.010,
                              ),
                            ],
                          )
                        : const SizedBox(),

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
                      height:
                          isTipSelected ? SizeConfig.screenHeight * 0.009 : 0,
                    ),
                    isTipSelected?Center(
                        child: Container(
                      height: 1,
                      color: line_cont_col,
                      width: SizeConfig.screenWidth * 0.9,
                    )):SizedBox(),
                    SizedBox(
                      height:
                          isTipSelected ? SizeConfig.screenHeight * 0.006 : 0,
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

                    SizedBox(
                      height: iscoupapply == true?SizeConfig.screenHeight * 0.005:0,
                    ),
                    isWallet == true
                        ? Center(
                            child: SizedBox(
                              width: SizeConfig.screenWidth * 0.9,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Wallet Amount",
                                    style: font_style.black_400_16,
                                  ),
                                  const Spacer(),
                                  Text(
                                    (isTipSelected==true)?_get_cart.walletAMount.value >((int.parse(_get_cart
                                        .response.value.total
                                        .toString()))+ (int.parse(selected_tip.toString())))?"-₹${((int.parse(_get_cart
                                        .response.value.total
                                        .toString()))+ (int.parse(selected_tip.toString())))}":
                                    _get_cart.walletAMount.value >
                                            (int.parse(_get_cart
                                                .response.value.total
                                                .toString()))
                                        ? "-₹${(int.parse(_get_cart.response.value.total.toString()))}"
                                        : "-₹${_get_cart.walletAMount.value.toStringAsFixed(2)}":_get_cart.walletAMount.value >
                                        (int.parse(_get_cart
                                            .response.value.total
                                            .toString()))
                                        ? "-₹${(int.parse(_get_cart.response.value.total.toString()))}"
                                        : "-₹${_get_cart.walletAMount.value.toStringAsFixed(2)}",
                                    style: font_style.black_500_14,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: isWallet == true?SizeConfig.screenHeight * 0.017:5,
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

                    //LINE
                    Center(
                        child: Container(
                      height: 1,
                      color: Colors.black,
                      width: SizeConfig.screenWidth,
                    )),
                    SizedBox(height: SizeConfig.screenHeight * 0.025),

                    //TOTAL
                    Center(
                      child: SizedBox(
                        width: SizeConfig.screenWidth * 0.9,
                        child: Row(
                          children: [
                            Text(
                              "Total",
                              style: font_style.black_600_16,
                            ),
                            const Spacer(),
                            iscoupapply == true
                                ? isTipSelected == true
                                    ? isWallet == true
                                        ? Text(
                                            "₹ ${int.parse(_get_cart.response.value.total.toString()) + (int.parse(selected_tip.toString())) - int.parse(couponDiscountAmount ?? 0.toString()) - (_get_cart.walletAMount.value > (int.parse(_get_cart.response.value.total.toString())) ? (int.parse(_get_cart.response.value.total.toString())) : (_get_cart.walletAMount.value))}",
                                            style: font_style
                                                .black_600_14_nounderline,
                                          )
                                        : Text(
                                            "₹ ${int.parse(_get_cart.response.value.total.toString()) + (int.parse(selected_tip.toString())) - int.parse(couponDiscountAmount ?? 0.toString())}",
                                            style: font_style
                                                .black_600_14_nounderline,
                                          )
                                    : isWallet == true
                                        ? Text(
                                            "₹ ${int.parse(_get_cart.response.value.total.toString()) + (int.parse(selected_tip.toString())) - int.parse(couponDiscountAmount ?? 0.toString()) - (_get_cart.walletAMount.value > (int.parse(_get_cart.response.value.total.toString())) ? (int.parse(_get_cart.response.value.total.toString())) : (_get_cart.walletAMount.value))}",
                                            style: font_style
                                                .black_600_14_nounderline,
                                          )
                                        : Text(
                                            "₹ ${int.parse(_get_cart.response.value.total.toString()) - int.parse(couponDiscountAmount ?? 0.toString())}",
                                            style: font_style
                                                .black_600_14_nounderline,
                                          )
                                : isTipSelected == true
                                    ? isWallet == true
                                        ? Text(
                                            "₹ ${int.parse(_get_cart.response.value.total.toString()) + (int.parse(selected_tip.toString())) - (_get_cart.walletAMount.value > ((int.parse(_get_cart.response.value.total.toString())) + (int.parse(selected_tip.toString()))) ? ((int.parse(_get_cart.response.value.total.toString())) + (int.parse(selected_tip.toString()))) : (_get_cart.walletAMount.value))}",
                                            style: font_style
                                                .black_600_14_nounderline,
                                          )
                                        : Text(
                                            "₹ ${int.parse(_get_cart.response.value.total.toString()) + (int.parse(selected_tip.toString()))}",
                                            style: font_style
                                                .black_600_14_nounderline,
                                          )
                                    : isWallet == true
                                        ? Text(
                                            "₹ ${int.parse(_get_cart.response.value.total.toString())   - (_get_cart.walletAMount.value > (int.parse(_get_cart.response.value.total.toString())) ? (int.parse(_get_cart.response.value.total.toString())) : (_get_cart.walletAMount.value))}",
                                            style: font_style
                                                .black_600_14_nounderline,
                                          )
                                        : Text(
                                            "₹ ${(double.parse(_get_cart.response.value.total.toString())).toStringAsFixed(2)}",
                                            style: font_style
                                                .black_600_14_nounderline,
                                          )
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: SizeConfig.screenHeight * 0.025),
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
                                  isTipSelected = !isTipSelected;
                                  if (isTipSelected) {
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
                      height: SizeConfig.screenHeight * 0.025,
                    ),
                    ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: paymentoption.length,
                      controller: ScrollController(),
                      separatorBuilder: (_, __) => const SizedBox(height: 0),
                      itemBuilder: (context, index) => (isWallet == true &&
                              index == 1)
                          ? const SizedBox()
                          : (index == 0 &&
                                  isWallet == true &&
                                  (_get_cart.response.value.total ?? 0) <
                                      _get_cart.walletAMount.value)
                              ? const SizedBox()
                              : RadioListTile(
                                  activeColor: yellow_col,
                                  title: Text(paymentoption[index].toString()),
                                  value: index,
                                  groupValue: _oneValue,
                                  onChanged: (value) {
                                    if (value == 1) {
                                      setState(() {
                                        isPayAfterService = true;
                                      });
                                    } else {
                                      setState(() {
                                        isPayAfterService = false;
                                      });
                                    }
                                    setState(() {
                                      _oneValue = value!;
                                    });
                                  },
                                ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.015,
                    ),
                    isPayAfterService
                        ? const SizedBox()
                        : InkWell(
                            onTap: () {
                              setState(() {
                                isWallet = !isWallet;
                              });
                              if(isWallet)
                              {
                                iscoupapply=false;
                                setState(() {

                                });
                              }

                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: yellow_col, width: 1.0),
                                  borderRadius: BorderRadius.circular(4)),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Icon(
                                          isWallet
                                              ? Icons.radio_button_checked
                                              : Icons.radio_button_off,
                                          color: common_color)
                                      .paddingSymmetric(horizontal: 10),
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
                          ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.025,
                    ),
                    (_get_copupon.couponModel().data?.isNotEmpty ??
                            false || iscoupapply == false)
                        ? isWallet == true
                            ? const SizedBox()
                            : isPayAfterService == true
                                ? const SizedBox()
                                : Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: yellow_col, width: 1.0),
                                        borderRadius: BorderRadius.circular(4)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Column(
                                      children: [
                                        (_get_copupon
                                                        .couponModel()
                                                        .data
                                                        ?.length ??
                                                    0) >
                                                1
                                            ? const SizedBox()
                                            : Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: yellow_col,
                                                        width: 1.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 2),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                        style: font_style
                                                            .greyA1A1AA_400_16
                                                            .copyWith(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                        controller: coupon,
                                                        decoration: InputDecoration(
                                                            enabledBorder:
                                                                InputBorder
                                                                    .none,
                                                            focusedBorder:
                                                                InputBorder
                                                                    .none,
                                                            hintText:
                                                                "Enter Coupon here",
                                                            hintStyle: font_style
                                                                .greyA1A1AA_400_16,
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 6)),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        if (iscoupapply) {
                                                          iscoupapply = false;
                                                          coupon.clear();
                                                          setState(() {});
                                                          commontoas(
                                                              "Coupon Remove Successfully");
                                                        } else {
                                                          _get_copupon.applyCoupon(
                                                              uid,
                                                              coupon.text
                                                                  .toUpperCase());
                                                          setState(() {
                                                            iscoupapply = true;
                                                            couponDiscountAmount =
                                                                _get_copupon
                                                                    .couponModel()
                                                                    .data?[0]
                                                                    .amount;
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        width: 80,
                                                        height: 32,
                                                        alignment:
                                                            Alignment.center,
                                                        padding: EdgeInsets.symmetric(
                                                            vertical: SizeConfig
                                                                    .screenHeight *
                                                                0.01),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          color: yellow_col,
                                                        ),
                                                        // child: Text("PAY ₹ ${int.parse(_get_cart.response.value.total.toString())+int.parse(selected_tip.toString().substring(1))}",style: font_style.white_600_14,),
                                                        child: Text(
                                                          iscoupapply
                                                              ? "REMOVE"
                                                              : "APPLY",
                                                          style: font_style
                                                              .white_600_16,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: SizeConfig
                                                              .screenWidth *
                                                          0.020,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                        SizedBox(height: Get.height * 0.03),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                                "assets/images/offer_svg.svg",
                                                color: common_color),
                                            const SizedBox(width: 15),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${_get_copupon.couponModel().data?[0].description}",
                                                  style:
                                                      font_style.black_600_16,
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "CODE:",
                                                      style: font_style
                                                          .black_600_16
                                                          .copyWith(
                                                              color: const Color(
                                                                  0xff18181B)),
                                                    ),
                                                    Text(
                                                      "\t\t${_get_copupon.couponModel().data?[0].coupanCode}",
                                                      style: font_style
                                                          .black_600_16
                                                          .copyWith(
                                                              color:
                                                                  yellow_col),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            const Spacer(),
                                            InkWell(
                                              onTap: () {
                                                if (iscoupapply) {
                                                  iscoupapply = false;
                                                  setState(() {});
                                                  commontoas(
                                                      "Coupon Remove Successfully");
                                                } else {
                                                  _get_copupon
                                                      .applyCoupon(
                                                          uid,
                                                          _get_copupon
                                                                  .couponModel()
                                                                  .data?[0]
                                                                  .coupanCode
                                                                  ?.toUpperCase() ??
                                                              "")
                                                      .then((_) {
                                                    if (_get_copupon
                                                        .isCouponUsed.value) {
                                                      setState(() {
                                                        iscoupapply = true;
                                                        couponDiscountAmount =
                                                            _get_copupon
                                                                .couponModel()
                                                                .data?[0]
                                                                .amount;
                                                      });
                                                    }
                                                  });
                                                }
                                              },
                                              child: Container(
                                                width: 80,
                                                height: 32,
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: SizeConfig
                                                            .screenHeight *
                                                        0.01),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  color: yellow_col,
                                                ),
                                                // child: Text("PAY ₹ ${int.parse(_get_cart.response.value.total.toString())+int.parse(selected_tip.toString().substring(1))}",style: font_style.white_600_14,),
                                                child: Text(
                                                  iscoupapply
                                                      ? "REMOVE"
                                                      : "APPLY",
                                                  style:
                                                      font_style.white_600_16,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: SizeConfig.screenWidth *
                                                  0.020,
                                            ),
                                          ],
                                        ),
                                        const Divider(
                                          thickness: 1.0,
                                        ),
                                        (_get_copupon
                                                        .couponModel()
                                                        .data
                                                        ?.length ??
                                                    0) >
                                                1
                                            ? InkWell(
                                                onTap: () {
                                                  Get.to(const AllCouponPage());
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "View all Coupon",
                                                      style: font_style
                                                          .black_600_16
                                                          .copyWith(
                                                              color: const Color(
                                                                  0xff27272A)),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    const Icon(
                                                        Icons
                                                            .arrow_forward_ios_rounded,
                                                        size: 13)
                                                  ],
                                                ),
                                              )
                                            : const SizedBox()
                                      ],
                                    ),
                                  )
                        : const SizedBox(),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.015,
                    ),
                    //CHOOSE PAYMENT OPTION


                    SizedBox(
                      height: SizeConfig.screenHeight * 0.015,
                    ),

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
                    print('1');
                    var totalPrice;
                    if (iscoupapply == true &&
                        isTipSelected == true &&
                        isWallet == true) {
                      totalPrice =
                          '${int.parse(_get_cart.response.value.total.toString()) - (int.parse(selected_tip)) - int.parse(couponDiscountAmount ?? 0.toString()) - (_get_cart.walletAMount.value > (int.parse(_get_cart.response.value.total.toString())) ? (int.parse(_get_cart.response.value.total.toString())) : (_get_cart.walletAMount.value))}';
                    } else if (iscoupapply == true) {
                      totalPrice =
                          '${int.parse(_get_cart.response.value.total.toString()) - int.parse(couponDiscountAmount ?? 0.toString())}';
                    } else if (isTipSelected == true) {
                      totalPrice =
                          '${(int.parse(_get_cart.response.value.total.toString()) - (int.parse(selected_tip)))}';
                    } else if (isWallet == true) {
                      totalPrice =
                          '${(int.parse(_get_cart.response.value.total.toString()))}';
                    } else {
                      totalPrice =
                          '${int.parse(_get_cart.response.value.total.toString())}';
                    }

                    if (_oneValue == 0 && isWallet == false) {
                      print('3');
                      startInstamojo(double.parse(totalPrice.toString()));
                    } else if (_oneValue == 1 || isWallet == true) {
                      print('2');
                      print('Total Price===${totalPrice}');
                      _book_service.book_service_cont(
                          iscoupapply == false
                              ? ""
                              : couponDiscountAmount.toString(),
                          isTipSelected ? selected_tip : "",
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
                          "cod",
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
                      _oneValue==0?"PROCEED TO PAY":"PROCEED TO BOOKING",
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
