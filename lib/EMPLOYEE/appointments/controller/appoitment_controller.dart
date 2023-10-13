import 'package:get/get.dart';
import 'package:hairgardenemployee/EMPLOYEE/home/model/booking_history_model.dart';
import 'package:hairgardenemployee/api_services/api_services.dart';
import 'package:hairgardenemployee/auth/model/all_slot_model.dart';

class AppointmentController extends GetxController {
  RxBool loading = false.obs;
  Rx<BookingHistoryModel> bookingHistoryModel = BookingHistoryModel().obs;
  Rx<AllSlotDataModel> allSlotModel = AllSlotDataModel().obs;
  Rx<BookingHistoryModel> upcomingBookingHistoryModel =
      BookingHistoryModel().obs;

  Future<void> fetchBookingHistoryData(String staffId) async {
    try {
      loading(true);
      BookingHistoryModel respo =
          await api_services().fetchBookingHistory(staffId);
      print('Booking History===${respo.data?.length}');
      if (respo.status == true) {
        bookingHistoryModel = respo.obs;
      }
    } finally {
      loading(false);
    }
  }

  Future<void> allSlotData(String staffId) async {
    try {
      loading(true);
      AllSlotDataModel respo =
      await api_services().getAllSLot(staffId);
      if (respo.status == true) {
        allSlotModel = respo.obs;
      }
    } finally {
      loading(false);
    }
  }

  Future<void> fetchUpcomingBookingHistoryData(String staffId) async {
    try {
      loading(true);
      BookingHistoryModel respo =
          await api_services().fetchUpcomingBookingHistory(staffId);
      if (respo.status == true) {
        upcomingBookingHistoryModel = respo.obs;
      }
    } finally {
      loading(false);
    }
  }
}
