import 'package:get/get.dart';
import 'package:hairgardenemployee/api_services/api_services.dart';
import 'package:hairgardenemployee/auth/model/my_earning_model.dart';

class MyEarningController extends GetxController
{
  RxBool isLoading = false.obs;
  Rx<MyEarningDataModel> myEarningModel = MyEarningDataModel().obs;

  Future<void> fetchMyEarningDetail(String staffId) async {
    try {
      isLoading(true);
      MyEarningDataModel respo = await api_services().getMyEarning(staffId);
      if (respo.status == true) {
        myEarningModel(respo);
        update();
      }
    } finally {
      isLoading(false);
    }
  }

}