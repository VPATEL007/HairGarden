import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hairgarden/USER/category/Model/add_to_cart_model.dart';

import '../../../COMMON/common_color.dart';
import '../../../COMMON/comontoast.dart';
import '../../../apiservices.dart';


class add_cart_controller extends GetxController{

  var loading = false.obs;
  var hasdata = false.obs;
  var response = add_to_cart_model().obs;

  Future<void> add_cart_cont(service_category_id, qty, user_id, device_id, type) async {

      try{
        loading(true);
        final respo = await api_service().add_cart(service_category_id, qty, user_id, device_id, type);
        print('Response Add Cart To Successfully==${respo.message}');
        if(respo.status == true){
          response = respo.obs;
          commontoas(respo.message.toString());
        }
        else {
          response = respo.obs;
          print(respo);
          commontoas(respo.message.toString());
          hasdata(true);

        }
      }
      finally{
        loading(false);
      }

  }

}