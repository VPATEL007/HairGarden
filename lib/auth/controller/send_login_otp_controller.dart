import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hairgardenemployee/COMMON/comman_toast.dart';
import 'package:hairgardenemployee/auth/model/send_login_otp_model.dart';
import 'package:hairgardenemployee/auth/model/sent_reg_otp_model.dart';
import '../../api_services/api_services.dart';

class send_login_otp_controller extends GetxController {
  var loading = false.obs;
  var response = send_login_otp_model().obs;
  var isotp = false.obs;

  Future<void> send_login_otp_cont(mobile) async {
    try {
      loading(true);
      final respo = await api_services().send_login_otp(mobile);
      if (respo.status == true) {
        isotp(true);
        response(respo);
        commonToast(respo.message.toString());
      } else if (respo.message.toString() == "The mobile field is required.") {
        isotp(false);
        commonToast(respo.message.toString());
      }
    } finally {
      loading(false);
    }
  }
}
