import 'package:get/get.dart';
import 'package:hairgardenemployee/api_services/api_services.dart';
import 'package:hairgardenemployee/auth/model/review_model.dart';

class ReviewController extends GetxController
{

  RxBool isLoading = false.obs;
  Rx<StaffRatingModel> allRatingModel = StaffRatingModel().obs;

  Future<void> fetchAllRatingData(String staffId) async {
    try {
      isLoading(true);
      StaffRatingModel respo = await api_services().getAllRatingData(staffId);
      if (respo.status == true) {
        allRatingModel(respo);
        update();
      }
    } finally {
      isLoading(false);
    }
  }
}