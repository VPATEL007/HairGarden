import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hairgarden/USER/category/Model/add_to_cart_model.dart';
import '../../../apiservices.dart';
import '../Model/decrease_cart_model.dart';


class decrease_cart_controller extends GetxController{

  var loading = false.obs;
  // var hasdata = false.obs;
  var response = decrease_cart_model().obs;

  Future<void> decrease_cart_cont(service_category_id, user_id, device_id, qty) async {

    try{
      loading(true);
      final respo = await api_service().decrease_cart(service_category_id, user_id, device_id, qty);
      if(respo.status == true){
        response = respo.obs;
        // commontoas(msg: respo.message.toString());
      }
      else {
        response = respo.obs;
        print(respo);
        // commontoas(msg: respo.message.toString());
        // hasdata(true);

      }
    }
    finally{
      loading(false);
    }

  }

}