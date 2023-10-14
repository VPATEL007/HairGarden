import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hairgardenemployee/EMPLOYEE/home/model/booking_history_model.dart';
import 'package:hairgardenemployee/EMPLOYEE/profile/model/update_profile_model.dart';
import 'package:hairgardenemployee/auth/model/all_booking_model.dart';
import 'package:hairgardenemployee/auth/model/all_slot_model.dart';
import 'package:hairgardenemployee/auth/model/all_staff_service_model.dart';
import 'package:hairgardenemployee/auth/model/booking_detail_model.dart';
import 'package:hairgardenemployee/auth/model/my_earning_detail_model.dart';
import 'package:hairgardenemployee/auth/model/my_earning_model.dart';
import 'package:hairgardenemployee/auth/model/review_model.dart';
import 'package:hairgardenemployee/auth/model/send_login_otp_model.dart';
import 'package:hairgardenemployee/auth/model/sent_reg_otp_model.dart';
import '../COMMON/const.dart';
import '../auth/model/staff_login_model.dart';
import '../auth/model/staff_signup_model.dart';

class api_services {
  Dio dio = Dio();

  //Staff signup
  Future<staff_signup_model> staff_signup(first_name, last_name, email, mobile,
      password, otp, gender, cate_id, profile,pincode,address) async {
    final user_form = FormData();
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    log('FCM TOKEN===$fcmToken');
    user_form.fields.add(MapEntry("fcmToken", fcmToken??""));
    user_form.fields.add(MapEntry("first_name", first_name));
    user_form.fields.add(MapEntry("last_name", last_name));
    user_form.fields.add(MapEntry("email", email));
    user_form.fields.add(MapEntry("mobile", mobile));
    user_form.fields.add(MapEntry("password", password));
    user_form.fields.add(MapEntry("otp", otp));
    user_form.fields.add(MapEntry("gender", gender));
    user_form.fields.add(MapEntry("cate_id", cate_id));
    user_form.fields.add(MapEntry("profile", profile));
    user_form.fields.add(MapEntry("pincode", pincode));
    user_form.fields.add(MapEntry("address", address));

    final value_user =
        await dio.post("$baseurl/staff-sign-up", data: user_form);
    if (value_user.statusCode == 200) {
      final result_user = staff_signup_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //Send Reg Otp
  Future<send_reg_otp_model> send_reg_otp(mobile) async {
    final user_form = FormData();

    user_form.fields.add(MapEntry("mobile", mobile));
    user_form.fields.add(const MapEntry("type", "register"));

    final value_user = await dio.post("$baseurl/generate-otp", data: user_form);
    if (value_user.statusCode == 200) {
      final result_user = send_reg_otp_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  Future<AllStaffServiceModel> getAllStaffService() async {

    final value_user = await dio.get("$baseurl/servicelisting");
    if (value_user.statusCode == 200) {
      final result_user = AllStaffServiceModel.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  Future<AllBookingModel> fetchAllBooking(String staffId) async {
    final user_form = FormData();

    user_form.fields.add(MapEntry("staff_id", staffId));
    // user_form.fields.add(MapEntry("type", 'Confirmed'));

    final value_user = await dio.post(
      "$baseurl/AllBookingForStaff",
      data: user_form,
      options: Options(
        followRedirects: false,
        // will not throw errors
        validateStatus: (status) => true,
      ),
    );
    if (value_user.statusCode == 200) {
      final result = AllBookingModel.fromJson(value_user.data);
      return result;
    }
    throw "Somthing went wrong";
  }

  Future<StaffProfileDataModel> getStaffProfileData(String staffId) async {
    final user_form = FormData();
    print(staffId);
    user_form.fields.add(MapEntry("user_id", staffId));
    // user_form.fields.add(MapEntry("type", 'Confirmed'));

    final value_user = await dio.post(
      "$baseurl/staff-profile",
      data: user_form,
      options: Options(
        followRedirects: false,
        // will not throw errors
        validateStatus: (status) => true,
      ),
    );
    print('Profile Response===${value_user.data}');
    print('Profile Response===${value_user.statusCode}');
    if (value_user.statusCode == 200 && (value_user.data['status']==true)) {
      final result = StaffProfileDataModel.fromJson(value_user.data);
      return result;
    }
    throw "Somthing went wrong";
  }

  Future<MyEarningDataModel> getMyEarning(String staffId) async {
    final user_form = FormData();

    user_form.fields.add(MapEntry("user_id", staffId));
    // user_form.fields.add(MapEntry("type", 'Confirmed'));

    final value_user = await dio.post(
      "$baseurl/myearning",
      data: user_form,
      options: Options(
        followRedirects: false,
        // will not throw errors
        validateStatus: (status) => true,
      ),
    );
    print(value_user.data);
    if (value_user.statusCode == 200) {
      final result = MyEarningDataModel.fromJson(value_user.data);
      return result;
    }
    throw "Somthing went wrong";
  }

  Future<StaffRatingModel> getAllRatingData(String staffId) async {
    final user_form = FormData();
    log("Staff ID===${staffId}");
    user_form.fields.add(MapEntry("staff_id", staffId));
    // user_form.fields.add(MapEntry("type", 'Confirmed'));

    final value_user = await dio.post(
      "$baseurl/getStaffWiseRatings",
      data: user_form,
      options: Options(
        followRedirects: false,
        // will not throw errors
        validateStatus: (status) => true,
      ),
    );
    if (value_user.statusCode == 200) {
      final result = StaffRatingModel.fromJson(value_user.data);
      return result;
    }
    throw "Somthing went wrong";
  }

  Future<MyEarningDetailDataModel> getMyEarningDetail(String staffId,String id) async {
    final user_form = FormData();

    user_form.fields.add(MapEntry("user_id", staffId));
    user_form.fields.add(MapEntry("id", id));
    // user_form.fields.add(MapEntry("type", 'Confirmed'));

    final value_user = await dio.post(
      "$baseurl/myearningdetail",
      data: user_form,
      options: Options(
        followRedirects: false,
        // will not throw errors
        validateStatus: (status) => true,
      ),
    );
    print(value_user.data);
    if (value_user.statusCode == 200) {
      final result = MyEarningDetailDataModel.fromJson(value_user.data);
      return result;
    }
    throw "Somthing went wrong";
  }

  Future<BookingHistoryModel> fetchBookingHistory(String staffId) async {
    final user_form = FormData();

    user_form.fields.add(MapEntry("staff_id", staffId));

    final value_user = await dio.post(
      "$baseurl/bookingHistory",
      data: user_form,
      options: Options(
        followRedirects: false,
        // will not throw errors
        validateStatus: (status) => true,
      ),
    );
    if (value_user.statusCode == 200) {
      final result = BookingHistoryModel.fromJson(value_user.data);
      return result;
    }
    throw "Somthing went wrong";
  }

  Future<AllSlotDataModel> getAllSLot(String staffId) async {
    final user_form = FormData();

    user_form.fields.add(MapEntry("staff_id", staffId));
    user_form.fields.add(const MapEntry("type", "assign"));

    final value_user = await dio.post(
      "$baseurl/get-time-slots",
      data: user_form,
      options: Options(
        followRedirects: false,
        // will not throw errors
        validateStatus: (status) => true,
      ),
    );
    if (value_user.statusCode == 200) {
      final result = AllSlotDataModel.fromJson(value_user.data);
      return result;
    }
    throw "Somthing went wrong";
  }

  Future<BookingDetailDataModel> fetchBookingDetail(String staffId,String bookingId) async {
    final user_form = FormData();

    user_form.fields.add(MapEntry("user_id", staffId));
    user_form.fields.add(MapEntry("booking_id", bookingId));

    final value_user = await dio.post(
      "$baseurl/bookingsDetails",
      data: user_form,
      options: Options(
        followRedirects: false,
        // will not throw errors
        validateStatus: (status) => true,
      ),
    );
    if (value_user.statusCode == 200) {
      final result = BookingDetailDataModel.fromJson(value_user.data);
      return result;
    }
    throw "Somthing went wrong";
  }

  Future<BookingHistoryModel> fetchUpcomingBookingHistory(
      String staffId) async {
    final user_form = FormData();

    user_form.fields.add(MapEntry("user_id", staffId));

    final value_user = await dio.post(
      "$baseurl/upcomingBookings",
      data: user_form,
      options: Options(
        followRedirects: false,
        // will not throw errors
        validateStatus: (status) => true,
      ),
    );
    if (value_user.statusCode == 200) {
      final result = BookingHistoryModel.fromJson(value_user.data);
      return result;
    }
    throw "Somthing went wrong";
  }

  Future<bool> acceptBooking(String staffId, String bookingId, status) async {
    final formData = FormData();

    formData.fields.add(MapEntry("staff_id", staffId));
    formData.fields.add(MapEntry("status", status));
    formData.fields.add(MapEntry("booking_id", bookingId));

    final value_user =
        await dio.post("$baseurl/acceptrejectBookings", data: formData);
    print(value_user.data);
    if (value_user.statusCode == 200) {
      return true;
    }
    throw "Somthing went wrong";
  }

  //Send login Otp
  Future<send_login_otp_model> send_login_otp(mobile) async {
    final user_form = FormData();

    user_form.fields.add(MapEntry("mobile", mobile));
    user_form.fields.add(const MapEntry("type", "login"));

    final value_user = await dio.post("$baseurl/generate-otp", data: user_form);
    if (value_user.statusCode == 200) {
      final result_user = send_login_otp_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //staff login
  Future<staff_login_model> staff_login(mobile, otp) async {
    final user_form = FormData();String? fcmToken = await FirebaseMessaging.instance.getToken();
    log('FCM TOKEN===$fcmToken');
    user_form.fields.add(MapEntry("fcmToken", fcmToken??""));
    user_form.fields.add(MapEntry("mobile", mobile));
    user_form.fields.add(MapEntry("otp", otp));
    final value_user =
        await dio.post("$baseurl/loginStaffViaOtp", data: user_form);
    if (value_user.statusCode == 200) {
      final result_user = staff_login_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //staff login
  Future<bool> update_profile(
      userId, firstName, lastName, mobile, email, gender,profile,profession) async {
    final user_form = FormData();

    user_form.fields.add(MapEntry("user_id", userId));
    user_form.fields.add(MapEntry("first_name", firstName));
    user_form.fields.add(MapEntry("last_name", lastName));
    user_form.fields.add(MapEntry("mobile", mobile));
    user_form.fields.add(MapEntry("email", email));
    user_form.fields.add(MapEntry("gender", gender));
    user_form.fields.add(MapEntry("profile", profile??""));
    user_form.fields.add(MapEntry("cate_id", profession));

    final value_user =
        await dio.post("$baseurl/update-user-profile", data: user_form);
    print('Response===${value_user.data}');
    if (value_user.statusCode == 200) {
      return true;
    }
    throw "Somthing went wrong";
  }
}
