
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hairgarden/apiservices.dart';

import '../../../COMMON/comontoast.dart';
import '../../bottombar/Screens/bottombar.dart';
import '../Model/give_rating_model.dart';

class give_rating_controller extends GetxController{

  var loading=false.obs;
  var response=give_rating_model().obs;

  Future<void>give_rating_cont(staff_id, user_id, ratings, remark) async {
    try{
      loading(true);
      final respo=await api_service().give_rating(staff_id, user_id, ratings, remark);
      if(respo.status==true){
        response=respo.obs;
        Get.offAll(BottomBar(pasindx: 1));
        commontoas(respo.message.toString());
      }
      else{
        response=respo.obs;
        commontoas(respo.message.toString());
      }
    }
    finally{
      loading(false);
    }
  }

}