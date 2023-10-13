import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hairgardenemployee/COMMON/comman_toast.dart';
import 'package:hairgardenemployee/auth/model/all_staff_service_model.dart';
import 'package:hairgardenemployee/auth/model/staff_signup_model.dart';
import '../../EMPLOYEE/relaxnow_page.dart';
import '../../api_services/api_services.dart';

class staff_signup_controller extends GetxController {
  var loading = false.obs;
  var response = staff_signup_model().obs;
  Rx<AllStaffServiceModel> getStaffService = AllStaffServiceModel().obs;
  RxList selectedCheckValueList = [].obs;
  RxList selectedProfession = [].obs;

  Future<void> staff_signup_cont(first_name, last_name, email, mobile, password,
      otp, gender, cate_id, profile,pincode,address) async {
    try {
      loading(true);
      final respo = await api_services().staff_signup(first_name, last_name,
          email, mobile, password, otp, gender, cate_id, profile,pincode,address);
      print('Response===${respo.message}');
      if (respo.status == true) {
        response(respo);
        Get.to(relaxnow_page());
      } else if (respo.status == false) {
        print("ERROR");
        commonToast(respo.message.toString());
      } else {
        print("ERROR");
        commonToast(respo.message.toString());
      }
    } finally {
      loading(false);
    }
  }

  Future<void> allStaffService() async {
    try {
      loading(true);
      final respo = await api_services().getAllStaffService();
      if (respo.status == true) {
        getStaffService(respo);
      }
    } finally {
      loading(false);
    }
  }
}
