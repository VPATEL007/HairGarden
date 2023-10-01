
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hairgarden/COMMON/comontoast.dart';

import '../../../apiservices.dart';
import '../Model/remove_fromcart_model.dart';

class remove_fromcart_controller extends GetxController{
  var loading = false.obs;
  var hasdata = false.obs;
  var response = remove_fromcart_model().obs;

  Future<void> remove_fromcart_cont( user_id, device_id,cart_id) async {

    try{
      loading(true);
      final respo = await api_service().remove_fromcart( user_id, device_id,cart_id);
      if(respo.status == true){
        response = respo.obs;
        // commontoas(msg: respo.message.toString());
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