

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../apiservices.dart';
import '../Model/get_all_category_model.dart';

class get_all_category_controller extends GetxController{
  var loading = false.obs;
  var response = get_all_category_model().obs;
  var bannerimg=[].obs;

  Future<void>get_all_category_cont()async{
    try{
      loading(true);
      final respo = await api_service().get_all_category();
      if(respo.status == true){
        response = respo.obs;
        bannerimg=[].obs;
      }
      else{
      }
    }
    finally{
      loading(false);
    }

  }
  @override
  void onInit() {
    super.onInit();
    get_all_category_cont();
  }
}