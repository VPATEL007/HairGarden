import 'package:get/get.dart';
import 'package:hairgardenemployee/EMPLOYEE/home/model/booking_history_model.dart';
import 'package:hairgardenemployee/api_services/api_services.dart';
import 'package:hairgardenemployee/auth/model/booking_detail_model.dart';

class AppointmentDetailController extends GetxController {
  RxBool loading = false.obs;
  Rx<BookingDetailDataModel> bookingDetailModel = BookingDetailDataModel().obs;

  Future<void> fetchBookingDetailData(String staffId,String bookingId) async {
    try {
      loading(true);
      BookingDetailDataModel respo =
      await api_services().fetchBookingDetail(staffId,bookingId);
      print('Response===${respo.data}');
      if (respo.status == true) {
        bookingDetailModel(respo);
      }
    } finally {
      loading(false);
    }
  }


}
