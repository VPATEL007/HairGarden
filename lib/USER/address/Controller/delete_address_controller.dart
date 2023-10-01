
import 'package:get/get.dart';

import '../../../apiservices.dart';
import '../Model/delete_address_model.dart';
import 'get_address_controller.dart';

class delete_address_controller extends GetxController{
  var loading = false.obs;
  var response = delete_address_model().obs;

  Future<void>delete_address_cont(address_id)async{
    try{
      loading(true);
      final respo = await api_service().delete_address(address_id);
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