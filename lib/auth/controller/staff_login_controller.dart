
import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hairgardenemployee/COMMON/comman_toast.dart';
import 'package:hairgardenemployee/EMPLOYEE/emp_bottombar.dart';
import 'package:hairgardenemployee/auth/model/staff_login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../COMMON/const.dart';
import '../../api_services/api_services.dart';

class staff_login_controller extends GetxController{

  var loading = false.obs;
  var response = staff_login_model().obs;

  Future<void> staff_login_cont(mobile, otp) async {
    try {
      loading(true);
      final respo = await api_services().staff_login(mobile, otp);
      if (respo.status == true) {
        response(respo);
        
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString(stored_uid, respo.data!.id.toString());
        
        Get.to(emp_bottombar(pasindx: 0));
      }

      else if(respo.status == false) {
        print("ERROR");
        commonToast(respo.message.toString());
      }else{
        print("ERROR");
        commonToast(respo.message.toString());
      }
    }
    finally {
      loading(false);
    }
  }
  RxBool isStartTimer=false.obs;
  Timer? timer;
  RxInt timerValue = 30.obs;


  void startTimer()
  {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if(timer.tick<30)
      {
        timerValue.value--;
      }
      else
      {
        timer.cancel();
        timerValue(30);
      }
    });
    update();
  }
}