import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hairgarden/COMMON/common_circular_indicator.dart';
import 'package:hairgarden/COMMON/font_style.dart';
import 'package:hairgarden/USER/notification/controller/notification_controller.dart';
import '../../../COMMON/common_color.dart';
import '../../../COMMON/size_config.dart';

class notification_page extends StatefulWidget {
  const notification_page({Key? key}) : super(key: key);

  @override
  State<notification_page> createState() => _notification_pageState();
}

class _notification_pageState extends State<notification_page> {
  final controller = Get.put(NotificationController());

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
          "Notifications",
          style: font_style.green_600_20,
        ),
      ),
      body: Obx(() => controller.loading()
          ?  CommonIndicator(color: common_color)
          : controller.notificationModel().data != null
              ? ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: controller.notificationModel().data?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: SizeConfig.screenHeight * 0.075,
                          width: SizeConfig.screenWidth * 0.2,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: yellow_col)),
                          child: SvgPicture.asset(
                            "assets/images/offer_svg.svg",
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${controller.notificationModel().data?[index].title}",
                                style: font_style.black_600_16,
                              ),
                              Text(
                                "${controller.notificationModel().data?[index].message}",
                                style: font_style.black_400_14,
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      height: 2,
                      color: line_cont_col,
                      width: SizeConfig.screenWidth,
                    );
                  },
                )
              : SizedBox(
                  child: Center(
                    child: Text(
                      "No Notification",
                      style: font_style.black_600_16,
                    ),
                  ),
                )),
    );
  }
}
