import 'package:get/get.dart';

import '../../../apiservices.dart';
import '../Model/add_default_address_model.dart';

class add_default_address_controller extends GetxController{
  var loading = false.obs;
  var response = add_default_address_model().obs;

  Future<void>add_default_address(user_id, address_id)async{
    try{
      loading(true);
      final respo = await api_service().add_default_address(user_id, address_id);
      if(respo.status == true){
        response = respo.obs;
      }
      else{
        response = respo.obs;
      }
    }
    finally{
      loading(false);
    }
  }
}