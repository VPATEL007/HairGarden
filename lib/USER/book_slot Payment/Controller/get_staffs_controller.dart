
import 'package:get/get.dart';
import 'package:hairgarden/USER/common/custom_snakbar.dart';

import '../../../COMMON/comontoast.dart';
import '../../../apiservices.dart';
import '../Model/get_staffs_model.dart';
import 'get_time_slots_controller.dart';

class get_staffs_controller extends GetxController{
  var loading =false.obs;
  var response=get_staffs_model().obs;
  final _get_time_slots=Get.put(get_time_slots_controller());



  Future<void>get_staffs_cont(address_id, service_id)async {
    try {
      loading(true);
      final respo = await api_service().get_staffs(address_id, service_id);
      print('Staff Response===${respo.message}');
      print('Staff Address===${address_id}');
      print('Staff Service===${service_id}');
      if (respo.status == true) {
        response = respo.obs;
      }
      else {
        response = respo.obs;
        commontoas("No Staff found for your selected address");
      }
    }
    finally {
      loading(false);
    }
  }

}