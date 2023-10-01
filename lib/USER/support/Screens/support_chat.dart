import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hairgarden/COMMON/common_circular_indicator.dart';
import 'package:hairgarden/COMMON/common_color.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:hairgarden/COMMON/size_config.dart';
import 'package:hairgarden/USER/support/controller/support_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupportChatPage extends StatefulWidget {
  final String ticketId;

  const SupportChatPage({Key? key, required this.ticketId}) : super(key: key);

  @override
  State<SupportChatPage> createState() => _SupportChatPageState();
}

class _SupportChatPageState extends State<SupportChatPage> {
  final supportController = Get.put(SupportController());
  TextEditingController message = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

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
    getuserid();
    // supportController.getSupportChat(widget.ticketId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
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
          "Support",
          style: font_style.green_600_20,
        ),
      ),
      body: Obx(() => supportController.loading()
          ? CommonIndicator()
          : (supportController.supportChatModel.value.data == null)
              ? Container(
                  height: SizeConfig.screenHeight * 0.7,
                  alignment: Alignment.center,
                  width: SizeConfig.screenWidth * 0.9,
                  child: const Text("No Data Found"),
                )
              : Stack(
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(0, 2),
                                            blurRadius: 8.0,
                                            spreadRadius: -5.0,
                                            color:
                                                Colors.black.withOpacity(0.40))
                                      ]),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12 ,vertical: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                          supportController
                                                  .supportChatModel
                                                  .value
                                                  .data
                                                  ?.userdata
                                                  ?.username ??
                                              "",
                                          style: font_style.greyA1A1AA_400_14
                                              .copyWith(
                                                  color:
                                                      const Color(0xff18181B),
                                                  fontSize: 14,
                                                  fontFamily: 'Lato',
                                                  fontWeight: FontWeight.w400,
                                                  decoration:
                                                      TextDecoration.none)),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3),
                                        child: Text(
                                            supportController
                                                    .supportChatModel
                                                    .value
                                                    .data
                                                    ?.userdata
                                                    ?.email ??
                                                "",
                                            style: font_style.greyA1A1AA_400_14
                                                .copyWith(
                                                    color:
                                                        const Color(0xff18181B),
                                                    fontSize: 14,
                                                    fontFamily: 'Lato',
                                                    fontWeight: FontWeight.w400,
                                                    decoration:
                                                        TextDecoration.none)),
                                      ),
                                      Text(
                                          supportController
                                                  .supportChatModel
                                                  .value
                                                  .data
                                                  ?.userdata
                                                  ?.mobile ??
                                              "",
                                          style: font_style.greyA1A1AA_400_14
                                              .copyWith(
                                                  color:
                                                      const Color(0xff18181B),
                                                  fontSize: 14,
                                                  fontFamily: 'Lato',
                                                  fontWeight: FontWeight.w400,
                                                  decoration:
                                                      TextDecoration.none))
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: supportController
                                        .supportChatModel
                                        .value
                                        .data
                                        ?.ticketdata
                                        ?.length,
                                    itemBuilder: (context, index) => Align(
                                          alignment: supportController
                                                      .supportChatModel
                                                      .value
                                                      .data
                                                      ?.ticketdata?[index]
                                                      .by ==
                                                  'User'
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12 ,vertical: 8),
                                            constraints: BoxConstraints(
                                              maxWidth:
                                                  SizeConfig.screenWidth * 0.55,
                                            ),
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      offset:
                                                          const Offset(0, 2),
                                                      blurRadius: 8.0,
                                                      spreadRadius: -5.0,
                                                      color: Colors.black
                                                          .withOpacity(0.40))
                                                ]),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                    supportController
                                                            .supportChatModel
                                                            .value
                                                            .data
                                                            ?.ticketdata?[index]
                                                            .subject ??
                                                        '',
                                                    style: font_style
                                                        .greyA1A1AA_400_14
                                                        .copyWith(
                                                            color: const Color(
                                                                0xff18181B),
                                                            fontSize: 14,
                                                            fontFamily: 'Lato',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            decoration:
                                                                TextDecoration
                                                                    .none)),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 3),
                                                  child: Text(
                                                      supportController
                                                              .supportChatModel
                                                              .value
                                                              .data
                                                              ?.ticketdata?[
                                                                  index]
                                                              .message ??
                                                          '',
                                                      style: font_style
                                                          .greyA1A1AA_400_14
                                                          .copyWith(
                                                              color: const Color(
                                                                  0xff18181B),
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'Lato',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              decoration:
                                                                  TextDecoration
                                                                      .none)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                // const SizedBox(height: 5.0),
                                // Container(
                                //   width: SizeConfig.screenWidth * 0.40,
                                //   decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(12.0),
                                //       color: Colors.white,
                                //       boxShadow: [
                                //         BoxShadow(
                                //             offset: const Offset(0, 2),
                                //             blurRadius: 8.0,
                                //             spreadRadius: -5.0,
                                //             color: Colors.black.withOpacity(0.40))
                                //       ]),
                                //   padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                                //   child: Row(
                                //     children: [
                                //       const Icon(Icons.attach_file),
                                //       const SizedBox(width: 15),
                                //       Text("Filename.pdf",
                                //           style: font_style.greyA1A1AA_400_14.copyWith(
                                //               color: const Color(0xff18181B),
                                //               fontSize: 14,
                                //               fontFamily: 'Lato',
                                //               fontWeight: FontWeight.w600,
                                //               decoration: TextDecoration.none
                                //           )),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        // const SizedBox(height: 10),
                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: Container(
                        //     margin: const EdgeInsets.symmetric(horizontal: 15),
                        //     width: SizeConfig.screenWidth * 0.60,
                        //     padding: const EdgeInsets.all(5.0),
                        //     decoration: BoxDecoration(
                        //       color: Colors.white,
                        //         border: Border.all(
                        //             color: yellow_col,
                        //             width: 1.0
                        //         ),
                        //         borderRadius: BorderRadius.circular(12.0)
                        //     ),
                        //     child: Text("Hi Andrew We have got your problem, Sorry you have to see this issue, We will resolve this issue & get back to you 2-3 days",
                        //         style: font_style.greyA1A1AA_400_14.copyWith(
                        //             color: const Color(0xff18181B),
                        //             fontSize: 14,
                        //             fontFamily: 'Lato',
                        //             fontWeight: FontWeight.w400,
                        //             decoration: TextDecoration.none
                        //         )),
                        //   ),
                        // )
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 0),
                                  blurRadius: 8.0,
                                  spreadRadius: -5.0,
                                  color: Colors.black.withOpacity(0.30))
                            ]),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            const Icon(Icons.attach_file),
                            Expanded(
                              child: Form(
                                key: formKey,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please Type message';
                                    }
                                    return null;
                                  },
                                  controller: message,
                                  decoration: const InputDecoration(
                                      hintText: 'Type your message here...',
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    supportController.addTicketReplay(
                                        uid, message.text, widget.ticketId);
                                  }
                                },
                                child: const Icon(Icons.send))
                          ],
                        ),
                      ),
                    )
                  ],
                )),
    );
  }
}
