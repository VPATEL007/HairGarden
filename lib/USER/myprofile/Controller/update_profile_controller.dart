
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../../COMMON/comontoast.dart';
import '../../../apiservices.dart';
import '../Model/update_profile_model.dart';

class update_profile_controller extends GetxController{
  var loading = false.obs;
  var response = update_profile_model().obs;

  Future<void>update_profile_cont(user_id, first_name, last_name, mobile, email, gender, profile)async{
    try{
      loading(true);
      final respo = await api_service().update_profile(user_id, first_name, last_name, mobile, email, gender, profile);
      print('Profile Response===${respo}');
      if(respo.status == true){
        response = respo.obs;
        print("this is profile responce ${response}");
        commontoas(respo.message.toString());
      }
      else{
        commontoas(respo.message.toString());

      }
    }
    finally{
      loading(false);
      // print("api is no called");
    }
  }
}