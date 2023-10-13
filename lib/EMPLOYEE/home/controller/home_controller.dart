import 'package:get/get.dart';
import 'package:hairgardenemployee/EMPLOYEE/home/model/booking_history_model.dart';
import 'package:hairgardenemployee/api_services/api_services.dart';
import 'package:hairgardenemployee/auth/model/all_booking_model.dart';

class HomeController extends GetxController {
  RxBool loading = false.obs;
  Rx<AllBookingModel> model = AllBookingModel().obs;
  Rx<BookingHistoryModel> bookingHistoryModel = BookingHistoryModel().obs;

  Future<void> fetchALlBooking(String staffId) async {
    try {
      loading(true);
      AllBookingModel respo = await api_services().fetchAllBooking(staffId);
      if (respo.status == true) {
        model = respo.obs;
        update();
      }
    } finally {
      loading(false);
    }
  }

  Future<void> acceptBooking(
      String staffId, String bookingId, String status) async {
    try {
      loading(true);
      bool response =
          await api_services().acceptBooking(staffId, bookingId, status);
      if (response == true) {
        AllBookingModel data = await api_services().fetchAllBooking(staffId);
        if (data.status == true) {
          model = data.obs;
        }
      }
    } finally {
      loading(false);
    }
  }

  Future<void> fetchBookingHistory(String staffId) async {
    try {
      loading(true);
      BookingHistoryModel response =
          await api_services().fetchBookingHistory(staffId);
      if (response.status == true) {
        bookingHistoryModel = response.obs;
      }
    } finally {
      loading(false);
    }
  }
}
