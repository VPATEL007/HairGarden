
import 'package:get/get.dart';

import '../../../apiservices.dart';
import '../../home/Screens/home_page.dart';
import '../Model/edit_address_model.dart';

class edit_address_controller extends GetxController{
  var loading = false.obs;
  var response = edit_address_model().obs;

  Future<void>edit_address_cont(id, location, building_name, locality,latitude, longitude,pincode,area)async{
    try{
      loading(true);
      final respo = await api_service().edit_address(id, location, building_name, locality,latitude,longitude,pincode,area);
      if(respo.status == true){
        response = respo.obs;


        logger.i("${response.value.message.toString()}");
      }
      else{
        response = respo.obs;
        logger.e("${response.value.message.toString()}");
      }
    }
    finally{
      loading(false);
    }
  }
}