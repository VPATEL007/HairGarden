import 'package:get/get.dart';

import '../../../apiservices.dart';
import '../Model/get_address_model.dart';

class get_address_controller extends GetxController{
  var loading = false.obs;
  Rx<get_address_model> response = get_address_model().obs;
  var defaultaddid;
  var addsidlst=[].obs;
  var checklist=[].obs;
  Future<void>get_address_cont(user_id)async{
    try{
      loading(true);
      final respo = await api_service().get_address(user_id);
      if(respo.status == true){
        response = respo.obs;
        checklist=[].obs;
        defaultaddid=null;
        addsidlst=[].obs;
        response.value.data!.forEach((element) {
          addsidlst.add(element.id);
          checklist.add(false);
          if(element.isDefault=="yes"){
            defaultaddid=element.id;
          }
        });
      }
      else{
        response = respo.obs;
      }
    }
    finally{
      loading(false);
    }
  }

  @override
  void onInit() {
    get_address_cont(0);
    super.onInit();
  }
}