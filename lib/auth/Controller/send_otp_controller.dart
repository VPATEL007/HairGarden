import 'package:get/get.dart';
import 'package:hairgarden/COMMON/comontoast.dart';

import '../../apiservices.dart';
import '../Model/send_otp_model.dart';

class send_otp_controller extends GetxController {
  var loading = false.obs;
  var response = send_otp_model().obs;

  Future<void> send_otp_cont(mobile, type) async {
    try {
      loading(true);
      final respo = await api_service().send_otp(mobile, type);
      print('OTP REsponse===${respo.message}');
      if (respo.status == true) {
        response = respo.obs;
        commontoas(respo.message.toString());
      } else {
        commontoas( respo.message.toString());
      }
    } finally {
      loading(false);
    }
  }
}
