
import 'dart:developer';

import 'package:get/get.dart';

import '../../../apiservices.dart';
import '../../address/Controller/get_address_controller.dart';
import '../Model/add_address_model.dart';

class add_address_controller extends GetxController{
  var loading = false.obs;
  var response = add_address_model().obs;



  Future<void>add_address_cont(user_id, location, building_name, locality, latitude ,longitude,pincode)async{
    try{
      loading(true);
      final respo = await api_service().add_address(user_id, location, building_name, locality,latitude,longitude,pincode);
      log("ADD ADDRESS COUNT===${respo.status}");
      log("ADD ADDRESS MESSAGE===${respo.message}");
      log("USERID===${user_id}");
      if(respo.status == true){
        response = respo.obs;

      }
      else{
      }
    }
    finally{
      loading(false);
    }

  }
}