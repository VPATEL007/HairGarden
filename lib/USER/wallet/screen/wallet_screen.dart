import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hairgarden/COMMON/common_circular_indicator.dart';
import 'package:hairgarden/COMMON/common_color.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:hairgarden/COMMON/size_config.dart';
import 'package:hairgarden/USER/wallet/controller/wallet_controller.dart';
import 'package:hairgarden/USER/wallet/screen/add_money_screen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hairgarden/COMMON/font_style.dart';

class WallerScreen extends StatefulWidget {
  const WallerScreen({Key? key}) : super(key: key);

  @override
  State<WallerScreen> createState() => _WallerScreenState();
}

class _WallerScreenState extends State<WallerScreen> {
  final walletController = Get.put(WalletController());
  String? uid;

  Future<void> getUserId() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    setState(() {
      uid = sf.getString("stored_uid");
    });
  }

  @override
  void initState() {
    getUserId().then((value) {
      walletController.getWalletHistory(uid);
      walletController.getWalletAmount(uid);
      walletController.getAvailableCouponData();
    });

    super.initState();
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
          "Wallet",
          style: font_style.green_600_20,
        ),
      ),
      body: Obx(() => walletController.loading()
          ? const CommonIndicator()
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: yellow_col, width: 1.0),
                        borderRadius: BorderRadius.circular(4)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
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
                              "₹${walletController.walletAMount().toStringAsFixed(2)}",
                              style: font_style.black_600_16,
                            )),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.020,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: InkWell(
                      onTap: () {
                        Get.to(const AddMoneyScreen());
                      },
                      child: Container(
                        width: 175,
                        height: 40,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.screenHeight * 0.01),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
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
                  const Divider(thickness: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        Text(
                          "Transactions",
                          style: font_style.black_600_16.copyWith(fontSize: 18),
                        ),
                        const SizedBox(height: 25),
                        Obx(() => (walletController
                                    .walletHistoryModel()
                                    .data
                                    ?.isNotEmpty ??
                                false)
                            ? ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                      thickness: 1,
                                      color: Color(0xffE4E4E7),
                                    ),
                                itemCount: walletController
                                        .walletHistoryModel()
                                        .data
                                        ?.length ??
                                    0,
                                shrinkWrap: true,
                                itemBuilder: (context, index) => Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: Get.width * 0.76,
                                              child: Text(
                                                walletController
                                                        .walletHistoryModel()
                                                        .data?[index]
                                                        .remark
                                                        .toString()
                                                        .capitalizeFirst ??
                                                    "",
                                                style: font_style.black_600_16,
                                              ),
                                            ),
                                            (walletController
                                                .walletHistoryModel()
                                                .data?[index]
                                                .amountStatus.toString().isNotEmpty??false)?Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 3),
                                              child: Text(
                                                walletController
                                                        .walletHistoryModel()
                                                        .data?[index]
                                                        .amountStatus ??
                                                    "",
                                                style: font_style.black_600_16
                                                    .copyWith(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400),
                                              ),
                                            ):SizedBox(),
                                            Text(
                                              DateFormat("dd-MM-yyyy").format(walletController.walletHistoryModel().data?[index].date ?? DateTime.now()),
                                              style: font_style.black_600_16
                                                  .copyWith(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: const Color(
                                                          0xff3F3F46)),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Row(
                                          children: [
                                            // Text(
                                            //   "-",
                                            //   style: font_style.black_600_16.copyWith(
                                            //       fontSize: 16,
                                            //       fontWeight: FontWeight.w600,
                                            //       color: const Color(0xff15803D)),
                                            // ),
                                            Text(
                                              "₹${walletController.walletHistoryModel().data?[index].amount}",
                                              style: font_style.black_600_16
                                                  .copyWith(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: const Color(
                                                          0xff15803D)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ))
                            : Container(
                                height: SizeConfig.screenHeight * 0.5,
                                alignment: Alignment.center,
                                width: SizeConfig.screenWidth * 0.9,
                                child: Text(
                                  "No Transactions found! Transation history will appear as you continue using your wallet",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Lato',
                                    color: Color(0xff3F3F46),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ).paddingSymmetric(horizontal: 20),
                              ))
                      ],
                    ),
                  )
                ],
              ),
            )),
    );
  }
}
