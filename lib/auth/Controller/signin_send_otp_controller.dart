
import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hairgarden/COMMON/comontoast.dart';

import '../../apiservices.dart';
import '../Model/signin_send_otp_model.dart';

class signin_send_otp_controller extends GetxController{
  var loading = false.obs;
  var response = signin_send_otp_model().obs;
  RxBool checkRegister=true.obs;
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

  Future<void>signin_send_otp_cont(mobile,name)async{
    try{
      loading(true);
      final respo = await api_service().signin_send_otp(mobile,name);
      if(respo.status == true){
        response = respo.obs;
        checkRegister=true.obs;
        commontoas( respo.message.toString());
      }
      else{
        checkRegister=false.obs;
        commontoas(respo.message.toString());
      }
    }
    finally{
      loading(false);
    }

  }
}