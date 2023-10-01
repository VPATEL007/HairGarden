import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hairgarden/COMMON/common_circular_indicator.dart';
import 'package:hairgarden/COMMON/common_color.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:hairgarden/COMMON/size_config.dart';
import 'package:hairgarden/USER/support/controller/support_controller.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support_chat.dart';
import 'support_page.dart';

class SupportTicketView extends StatefulWidget {
  const SupportTicketView({Key? key}) : super(key: key);

  @override
  State<SupportTicketView> createState() => _SupportTicketViewState();
}

class _SupportTicketViewState extends State<SupportTicketView> {
  final supportController = Get.put(SupportController());
  String? uid;

  Future<void> getuserid() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    setState(() {
      uid = sf.getString("stored_uid");
    });
  }

  @override
  void initState() {
    getuserid().then((value) {
      supportController.getAllTicket(uid);
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
          "Support Tickets",
          style: font_style.green_600_20,
        ),
      ),
      body: Obx(() => supportController.loading()
          ? const CommonIndicator()
          : Stack(
              children: [
                Obx(() => (supportController.ticketModel().data == null)
                    ? Container(
                        height: SizeConfig.screenHeight,
                        alignment: Alignment.center,
                        width: SizeConfig.screenWidth * 0.9,
                        child: const Text("No Ticket Found"),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: supportController.ticketModel().data?.length,
                        itemBuilder: (context, index) => InkWell(
                              onTap: () {

                                Get.to(SupportChatPage(
                                    ticketId: supportController
                                            .ticketModel()
                                            .data?[index]
                                            .id ??
                                        ''));

                                supportController.getSupportChat(
                                    supportController
                                        .ticketModel()
                                        .data?[index]
                                        .id ??
                                        '');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: yellow_col, width: 1.0),
                                    borderRadius: BorderRadius.circular(12.0)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '${supportController.ticketModel().data?[index].subject}',
                                            style: font_style.black_600_16
                                                .copyWith(
                                                    color: const Color(
                                                        0xff52525B))),
                                        const Spacer(),
                                        const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 15),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                            DateFormat('yyyy-MM-dd').format(
                                                supportController
                                                        .ticketModel()
                                                        .data?[index]
                                                        .createdAt ??
                                                    DateTime.now()),
                                            style: font_style.black_600_16
                                                .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    color: const Color(
                                                        0xff52525B))),
                                        const Spacer(),
                                        Container(
                                          width: 90,
                                          height: 28,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                            color: yellow_col,
                                          ),
                                          // child: Text("PAY ₹ ${int.parse(_get_cart.response.value.total.toString())+int.parse(selected_tip.toString().substring(1))}",style: font_style.white_600_14,),
                                          child: Text(
                                            "${supportController.ticketModel().data?[index].status}",
                                            style: font_style.white_600_16
                                                .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ))),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: InkWell(
                      onTap: () {
                        Get.to(const support_page());
                      },
                      child: Container(
                        width: 130,
                        height: 35,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: yellow_col,
                        ),
                        // child: Text("PAY ₹ ${int.parse(_get_cart.response.value.total.toString())+int.parse(selected_tip.toString().substring(1))}",style: font_style.white_600_14,),
                        child: Text(
                          "Add Ticket",
                          style: font_style.white_600_16.copyWith(
                              fontWeight: FontWeight.w400, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )),
    );
  }
}
