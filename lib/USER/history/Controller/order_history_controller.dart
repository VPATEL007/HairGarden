
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../COMMON/common_color.dart';
import '../../../COMMON/comontoast.dart';
import '../../../apiservices.dart';
import '../Model/order_history_model.dart';

class order_history_controller extends GetxController{
  var loading = false.obs;
  var response = order_history_model().obs;
  RxString userID = "".obs;

  Future<void>order_history_cont(String user_id)async{
    try{
      loading(true);
      final respo = await api_service().order_history(user_id);
      print('Response History===${respo.message}');
      if(respo.status == true){
        response = respo.obs;
        // Get.snackbar("title", "message");
        // commontoas(respo.message.toString());
      }
      else {
        response = respo.obs;
        // commontoas(respo.message.toString());
      }
    }
    finally{
      loading(false);
    }

  }
}