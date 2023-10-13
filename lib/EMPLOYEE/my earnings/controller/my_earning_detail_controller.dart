import 'package:get/get.dart';
import 'package:hairgardenemployee/api_services/api_services.dart';
import 'package:hairgardenemployee/auth/model/my_earning_detail_model.dart';

class MyEarningDetailController extends GetxController
{
  RxBool isLoading = false.obs;
  Rx<MyEarningDetailDataModel> myEarningModel = MyEarningDetailDataModel().obs;

  Future<void> getMyEarningDetail(String staffId,String id) async {
    try {
      isLoading(true);
      MyEarningDetailDataModel respo = await api_services().getMyEarningDetail(staffId,id);
      if (respo.status == true) {
        myEarningModel(respo);
        update();
      }
    } finally {
      isLoading(false);
    }
  }

}