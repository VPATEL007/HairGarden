import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../COMMON/comontoast.dart';
import '../../../apiservices.dart';
import '../Model/get_profile_info_model.dart';

class get_profile_info_controller extends GetxController {
  var loading = false.obs;
  var response = get_profile_info_model().obs;
  RxString userID = "".obs;

  Future<void> get_profile_info_cont(user_id) async {
    // try {
    //   loading(true);
    //   final respo =
    //       await api_service().get_profile_info(user_id.toString());
    //   print(respo.data?.profile);
    //   if (respo.status == true) {
    //     response = respo.obs;
    //   } else {
    //     // commontoas(respo.message.toString());
    //
    //   }
    // } finally {
    //   loading(false);
    //   // print("api is no called");
    // }
    loading(true);
    final respo =
    await api_service().get_profile_info(user_id.toString());
    print(respo.data?.profile);
    if (respo.status == true) {
      response = respo.obs;
      loading(false);
    } else {
      loading(false);
      // commontoas(respo.message.toString());

    }
  }
}
