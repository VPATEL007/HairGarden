import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../COMMON/common_color.dart';
import '../../../COMMON/comontoast.dart';
import '../../../apiservices.dart';
import '../Model/book_service_model.dart';
import '../Screens/payment_done_page.dart';

class book_service_controller extends GetxController {
  var loading = false.obs;
  var response = book_service_model().obs;
  var totprice;
  var servname = [];
  var servprice = [];
  var slot;
  var bookdate;

  Future<void> book_service_cont(
      discount,
      tip,
      user_id,
      category_id,
      isWalletApplied,
      tipamount,
      device_id,
      slot_id,
      price,
      payment_id,
      payment_status,
      booking_date,
      address_id,
      staff_id,
      staff_type,
      bookingdate) async {
    try {
      loading(true);
      final respo = await api_service().book_service(
          user_id,
          category_id,
          isWalletApplied,
          tipamount,
          device_id,
          slot_id,
          price,
          payment_id,
          payment_status,
          booking_date,
          address_id,
          staff_id,
          staff_type);
      if (respo.status == true) {
        response = respo.obs;
        servname.clear();
        servprice.clear();
        commontoas(respo.message.toString());
        Get.to(
            payment_done_page(discount: discount, date: bookingdate, tip: tip));
        totprice = response.value.price.toString();
        slot = response.value.slotName.toString();
        bookdate = response.value..toString();
        response.value.itemdetails!.forEach((element) {
          servname.add(element.title);
          servprice.add(int.parse(element.price.toString()) *
              int.parse(element.qty.toString()));
        });
        // commontoas(msg: "API CALLED");
      } else {
        response = respo.obs;
        commontoas(respo.message.toString());
      }
    } finally {
      loading(false);
    }
  }
}
