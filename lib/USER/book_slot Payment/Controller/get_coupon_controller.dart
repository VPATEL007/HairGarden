
import 'package:get/get.dart';
import 'package:hairgarden/apiservices.dart';
import '../../../COMMON/comontoast.dart';
import '../Model/get_coupon_model.dart';
import 'package:hairgarden/USER/book_slot%20Payment/Model/coupen_model.dart';

class get_coupon_controller extends GetxController{
  var loading=false.obs;
  var response=get_coupon_model().obs;
  Rx<CouponModel> couponModel = CouponModel().obs;

  Future<void>get_coupon_cont(user_id) async {
    try{
      loading(true);
      final respo=await api_service().get_coupon(user_id);
      if(respo.status==true){
        response=respo.obs;
      }
      else{
        commontoas(respo.message.toString());
      }
    }
    finally{
      loading(false);
    }
  }

  Future<void>getAllCoupen(user_id) async {
    try{
      loading(true);
      final respo =await api_service().getAllCoupon(user_id);
      print('Coupon==${respo.data?.first}');
      if(respo.status==true){
        couponModel=respo.obs;
      }
      else{
        commontoas(respo.message.toString());
      }
    }
    finally{
      loading(false);
    }
  }

  Future<void> applyCoupon(user_id,coupan_id) async {
    try{
      loading(true);

      final respo =await api_service().applyCoupon(user_id,coupan_id);
      if(respo==true){
        commontoas("Coupon Apply Successfully");
      }
      else{
        commontoas("Coupon Already applied");
      }
    }
    finally{
      loading(false);
    }
  }
}