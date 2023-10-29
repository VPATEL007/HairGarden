import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hairgarden/COMMON/comontoast.dart';
import 'package:hairgarden/auth/Screens/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../USER/bottombar/Screens/bottombar.dart';
import '../../apiservices.dart';
import '../Model/signup_model.dart';

class signup_controller extends GetxController{
  var loading = false.obs;
  var response = signup_model().obs;

  Future<void>signup_cont(frompage,first_name, last_name, email, mobile, password, otp,refer_code,gender,device_key)async{
    try{
      loading(true);
      final respo = await api_service().signup(first_name, last_name, email, mobile, password, otp,refer_code,gender,device_key);
      if(respo.status == true){
        response = respo.obs;
        // commontoas(msg: respo.message.toString());
        SharedPreferences sf =await SharedPreferences.getInstance();
        sf.setString("isgmail", "true");
        Get.offAll(login_page(frompage: frompage,));

      }
      else{
        commontoas(respo.message.toString());
      }
    }
    finally{
      loading(false);
    }
  }
}