import 'package:get/get.dart';
import 'package:hairgarden/apiservices.dart';
import 'package:hairgarden/auth/Model/available_coupon.dart';
import 'package:hairgarden/auth/Model/wallet_data_model.dart';

class WalletController extends GetxController
{

  RxBool loading=false.obs;
  Rx<WalletDataModel> walletHistoryModel = WalletDataModel().obs;
  Rx<AllAvailableCoupon> availableCoupon = AllAvailableCoupon().obs;
  RxDouble walletAMount = 0.0.obs;
  RxInt selectedIndex = 0.obs;

  Future<void>getWalletHistory(userId) async {

    try{
      loading(true);
      final respo=await api_service().getWalletHistory(userId);
      print('Response==${respo.message}');
      if(respo.status==true){
        walletHistoryModel(respo);
      }
    }
    finally{
      loading(false);
    }
  }

  Future<void> applyAvailableCashback(userId,amount,id) async {

    try{
      loading(true);
      final respo=await api_service().applyAvailableCashback(userId,amount,id);

      if(respo==true){

      }
    }
    finally{
      loading(false);
    }
  }

  Future<void> getAvailableCouponData() async {

    try{
      loading(true);
      final respo=await api_service().getAvailableCouponData();
      print('Response Avialble Coupon ==${respo.message}');
      if(respo.status==true){
        availableCoupon(respo);
      }
    }
    finally{
      loading(false);
    }
  }

  Future<void>getWalletAmount(userId) async {
    try{
      loading(true);
      final respo=await api_service().getWalletAmount(userId);
      print('Wallet Response===${respo}');
      walletAMount(respo);
    }
    finally{
      loading(false);
    }
  }
}