
import 'package:get/get.dart';

import '../../../apiservices.dart';
import '../Model/includes_update_cart_model.dart';

class include_update_cart_controller extends GetxController{
  var loading = false.obs;
  var response = includes_updatecart_model().obs;

  Future<void>include_update_cart_cont(service_category_id, qty, user_id, device_id,List extra_include)async{
    try{
      loading(true);
      final respo = await api_service().includes_updatecart(service_category_id, qty, user_id, device_id, extra_include);
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