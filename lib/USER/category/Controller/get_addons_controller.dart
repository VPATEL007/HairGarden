import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hairgarden/COMMON/comontoast.dart';
import 'package:hairgarden/USER/category/Model/get_addons_model.dart';
import '../../../COMMON/common_color.dart';
import '../../../apiservices.dart';


class get_addons_controller extends GetxController{

  var loading = false.obs;
  var response = get_addons_model().obs;

  Future<void> get_addons_cont(user_id, device_id) async {

    try{
      loading(true);
      final respo = await api_service().get_addons(user_id, device_id);
      print('Response ADD ON COUNT ===${respo.message}');
      if(respo.status == true){
        response = respo.obs;
      }
      else {
        response = respo.obs;
        print(response);
        print(respo);
        // commontoas(respo.message.toString());

      }
    }
    finally{
      loading(false);
    }

  }

}