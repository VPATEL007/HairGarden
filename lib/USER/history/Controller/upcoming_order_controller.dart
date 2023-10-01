import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hairgarden/COMMON/common_color.dart';

import '../../../COMMON/comontoast.dart';
import '../../../apiservices.dart';
import '../Model/upcoming_order_model.dart';

class upcoming_order_controller extends GetxController {
  var loading = false.obs;
  var response = upcoming_order_model().obs;

  Future<void> upcoming_order_contr(String user_id) async {
    try {
      loading(true);
      final respo = await api_service().upcoming_order(user_id);
      if (respo.status == true) {
        response = respo.obs;
        // Get.snackbar("title", "message");
        // commontoas(respo.message.toString());
      } else {
        response = respo.obs;

        // commontoas(msg: respo.message.toString());
      }
    } finally {
      loading(false);
    }
  }
}
