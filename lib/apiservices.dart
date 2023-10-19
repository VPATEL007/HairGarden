import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hairgarden/COMMON/comontoast.dart';
import 'package:hairgarden/USER/book_slot%20Payment/Model/book_service_model.dart';
import 'package:hairgarden/USER/book_slot%20Payment/Model/coupen_model.dart';
import 'package:hairgarden/USER/category/Model/get_addons_model.dart';
import 'package:hairgarden/USER/category/Model/get_prod_bysubcat_cat_model.dart';
import 'package:hairgarden/auth/Model/available_coupon.dart';
import 'package:hairgarden/auth/Model/notification_model.dart';
import 'package:hairgarden/auth/Model/support_chat_model.dart';
import 'package:hairgarden/auth/Model/ticket_model.dart';
import 'package:hairgarden/auth/Model/wallet_data_model.dart';

import 'USER/address/Model/add_default_address_model.dart';
import 'USER/address/Model/delete_address_model.dart';
import 'USER/address/Model/edit_address_model.dart';
import 'USER/address/Model/get_address_model.dart';
import 'USER/address/Model/get_pincode_model.dart';
import 'USER/book_slot Payment/Model/get_coupon_model.dart';
import 'USER/book_slot Payment/Model/get_staff_details_model.dart';
import 'USER/book_slot Payment/Model/get_staffs_model.dart';
import 'USER/book_slot Payment/Model/get_time_slots_model.dart';
import 'USER/category/Model/add_to_cart_model.dart';
import 'USER/category/Model/decrease_cart_model.dart';
import 'USER/category/Model/get_all_cat_products_model.dart';
import 'USER/category/Model/get_cart_model.dart';
import 'USER/category/Model/get_subcat_byid_model.dart';
import 'USER/category/Model/includes_update_cart_model.dart';
import 'USER/category/Model/remove_fromcart_model.dart';
import 'USER/category/Model/view_prod_details_model.dart';
import 'USER/category/Model/viewdetails_addons_model.dart';
import 'USER/common/common_txt_list.dart';
import 'USER/enable_location/Model/add_address_model.dart';
import 'USER/history/Model/order_history_model.dart';
import 'USER/history/Model/upcoming_order_model.dart';
import 'USER/home/Model/get_all_category_model.dart';
import 'USER/home/Model/get_banner_model.dart';
import 'USER/home/Model/get_testimonials_model.dart';
import 'USER/myprofile/Model/get_profile_info_model.dart';
import 'USER/myprofile/Model/update_profile_model.dart';
import 'USER/refer_n_earn/Model/get_reward_model.dart';
import 'USER/review/Model/give_rating_model.dart';
import 'auth/Model/send_otp_model.dart';
import 'auth/Model/signin_send_otp_model.dart';
import 'auth/Model/signin_viaOTP_model.dart';
import 'auth/Model/signup_model.dart';

class api_service {
  Dio dio = Dio();

  //GET BANNER
  Future<get_banner_model> getbannner() async {
    final value_user = await dio.get("$baseurl/get-banners");
    if (value_user.statusCode == 200) {
      final result_user = get_banner_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //GET ALL CATEGORY
  Future<get_all_category_model> get_all_category() async {
    final value_user = await dio.get("$baseurl/getAllCategory");
    if (value_user.statusCode == 200) {
      final result_user = get_all_category_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //GET SUBCAT BY ID
  Future<get_subcat_byid_model> get_subcat_byid(cate_id) async {
    final user_form = FormData();
    user_form.fields.add(MapEntry("cate_id", cate_id));
    final value_user =
        await dio.post("$baseurl/getAllSubCateById", data: user_form);
    if (value_user.statusCode == 200) {
      final result_user = get_subcat_byid_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  // Get Notification Data

  Future<NotificationModel> getNotificationData(userId) async {
    final user_form = FormData();
    user_form.fields.add(MapEntry("user_id", userId));
    final value_user =
        await dio.post("$baseurl/incomingNotificationListing", data: user_form);
    if (value_user.statusCode == 200) {
      final result_user = NotificationModel.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //REGISTRATION OTP
  Future<send_otp_model> send_otp(mobile, type) async {
    final user_form = FormData();

    user_form.fields.add(MapEntry("mobile", mobile));
    user_form.fields.add(MapEntry("type", type));
    log("FIELD===${user_form.fields}");
    final value_user = await dio.post("$baseurl/generate-otp", data: user_form);
    if (value_user.statusCode == 200) {
      final result_user = send_otp_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //SIGNUP
  Future<signup_model> signup(first_name, last_name, email, mobile, password,
      otp, refer_code, gender) async {
    final user_form = FormData();
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    user_form.fields.add(MapEntry("fcmToken", fcmToken??""));
    user_form.fields.add(MapEntry("first_name", first_name));
    user_form.fields.add(MapEntry("last_name", last_name));
    user_form.fields.add(MapEntry("email", email));
    user_form.fields.add(MapEntry("mobile", mobile));
    user_form.fields.add(MapEntry("password", password));
    user_form.fields.add(MapEntry("otp", otp));
    user_form.fields.add(MapEntry("refer_code", refer_code));
    user_form.fields.add(MapEntry("gender", gender));
    final value_user = await dio.post("$baseurl/user-sign-up", data: user_form);
    if (value_user.statusCode == 200) {
      final result_user = signup_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //SIGNIN SEND OTP
  Future<signin_send_otp_model> signin_send_otp(mobile, name) async {
    final user_form = FormData();

    user_form.fields.add(MapEntry("mobile", mobile));
    user_form.fields.add(MapEntry("name", name));

    final value_user = await dio.post("$baseurl/loginOtp", data: user_form);
    if (value_user.statusCode == 200) {
      final result_user = signin_send_otp_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //SIGNIN OTP
  Future<signin_viaOTP_model> signin_otp(mobile, otp,deviceID) async {
    final user_form = FormData();
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    log('FCM TOKEN===${fcmToken}');
    user_form.fields.add(MapEntry("fcmToken", fcmToken??""));
    user_form.fields.add(MapEntry("mobile", mobile));
    user_form.fields.add(MapEntry("otp", otp));
    user_form.fields.add(MapEntry("device_key", deviceID));

    final value_user = await dio.post("$baseurl/loginViaOtp", data: user_form);
    log('LOGIN NOT ===${value_user.data}');
    if (value_user.statusCode == 200) {
      final result_user = signin_viaOTP_model.fromJson(value_user.data);
      return result_user;
    }
    else
    {
      commontoas(value_user.data['message']);
    }
    throw "Somthing went wrong";
  }

  //GET PROFILE INFO
  Future<get_profile_info_model> get_profile_info(String user_id) async {
    final user_form = FormData();

    user_form.fields.add(MapEntry("user_id", user_id.toString()));
    final value_user =
        await dio.post("$baseurl/get-user-profile", data: user_form);
    print(value_user);
    if (value_user.statusCode == 200) {
      final result_user = get_profile_info_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //ADD ADDRESS
  Future<add_address_model> add_address(user_id, location, building_name,
      locality, latitude, longitude, pincode,area) async {
    final user_form = FormData();

    user_form.fields.add(MapEntry("user_id", user_id.toString()));
    user_form.fields.add(MapEntry("location", location));
    user_form.fields.add(MapEntry("building_name", building_name));
    user_form.fields.add(MapEntry("locality", locality));
    user_form.fields.add(MapEntry("latitude", latitude));
    user_form.fields.add(MapEntry("longitude", longitude));
    user_form.fields.add(MapEntry("pincode", pincode));
    user_form.fields.add(MapEntry("area", area));
    final value_user = await dio.post("$baseurl/addAddress", data: user_form);
    if (value_user.statusCode == 200) {
      final result_user = add_address_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //GET ADDRESS
  Future<get_address_model> get_address(user_id) async {
    final user_form = FormData();

    user_form.fields.add(MapEntry("user_id", user_id.toString()));
    final value_user = await dio.post("$baseurl/getAddress", data: user_form);
    if (value_user.statusCode == 200) {
      final result_user = get_address_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //DELETE ADDRESS
  Future<delete_address_model> delete_address(address_id) async {
    final user_form = FormData();

    user_form.fields.add(MapEntry("address_id", address_id));
    final value_user =
        await dio.post("$baseurl/deleteAddress", data: user_form);
    if (value_user.statusCode == 200) {
      final result_user = delete_address_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //UPDATE PROFILE
  Future<update_profile_model> update_profile(
      user_id, first_name, last_name, mobile, email, gender, profile) async {
    final user_form = FormData();
    user_form.fields.add(MapEntry("user_id", user_id.toString()));
    user_form.fields.add(MapEntry("first_name", first_name));
    user_form.fields.add(MapEntry("last_name", last_name));
    user_form.fields.add(MapEntry("mobile", mobile));
    user_form.fields.add(MapEntry("email", email));
    user_form.fields.add(MapEntry("gender", gender));
    user_form.fields.add(MapEntry("profile", profile));
    // user_form.files.add(MapEntry('profile', MultipartFile.fromFileSync(profile.path, filename: profile.path.split(Platform.pathSeparator).last)));
    final value_user =
        await dio.post("$baseurl/update-user-profile", data: user_form);
    if (value_user.statusCode == 200) {
      final result_user = update_profile_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //GET TIME SLOTS
  Future<get_time_slots_model> get_time_slots(type, staff_id) async {
    final user_form = FormData();
    user_form.fields.add(MapEntry("type", type));
    user_form.fields.add(MapEntry("staff_id", staff_id));
    final value_user =
        await dio.post("$baseurl/get-time-slots", data: user_form);
    if (value_user.statusCode == 200) {
      final result_user = get_time_slots_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //get_all_cat_products
  Future<get_all_cat_products_model> get_all_cat_products() async {
    final value_user = await dio.get(
      "$baseurl/get-all-services-data",
    );
    log('Service Vijay Response===${value_user.data}');
    if (value_user.statusCode == 200) {
      final result_user = get_all_cat_products_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //GET ALL PROD BY SUB CAT CAT
  Future<get_prod_bysubcat_cat_model> get_prod_bysubcat_cat(
      cate_id, sub_cate_id) async {
    final user_form = FormData();

    user_form.fields.add(MapEntry("cate_id", cate_id));
    user_form.fields.add(MapEntry("sub_cate_id", sub_cate_id));

    final value_user =
        await dio.post("$baseurl/getAllProduct", data: user_form);
    if (value_user.statusCode == 200) {
      final result_user = get_prod_bysubcat_cat_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //GET PROD DETAILS
  Future<view_prod_details_model> view_prod_details(id) async {
    final user_form = FormData();

    user_form.fields.add(MapEntry("id", id));

    final value_user =
        await dio.post("$baseurl/productDetail", data: user_form);
    if (value_user.statusCode == 200) {
      final result_user = view_prod_details_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //VIEW ADDONS DETAILS
  Future<viewdetails_addons_model> viewdetails_addons(id) async {
    final user_form = FormData();

    user_form.fields.add(MapEntry("id", id));

    final value_user =
        await dio.post("$baseurl/getAddOnsViewDetail", data: user_form);
    if (value_user.statusCode == 200) {
      final result_user = viewdetails_addons_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //ADD TO CART
  Future<add_to_cart_model> add_cart(
      service_category_id, qty, user_id, device_id, type) async {
    final user_form = FormData();
    print(service_category_id);
    print(qty);
    print(user_id);
    print(device_id);
    print(type);
    user_form.fields.add(MapEntry("service_category_id", service_category_id));
    user_form.fields.add(MapEntry("qty", qty));
    user_form.fields.add(MapEntry("user_id", user_id));
    user_form.fields.add(MapEntry("device_id", device_id));
    user_form.fields.add(MapEntry("type", type));

    final value_user = await dio.post("$baseurl/add-to-cart", data: user_form);
    if (value_user.statusCode == 200) {
      final result_user = add_to_cart_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //GET CART
  Future<get_cart_model?> get_cart(user_id, device_id) async {
    final user_form = FormData();
    get_cart_model? getcardModel;
    print('VIjay USERID+===${user_id}');
    print('DEVICE ID USERID+===${device_id}');
    user_form.fields.add(MapEntry(
        "user_id", user_id));
    user_form.fields.add(MapEntry("device_id", device_id));

    final value_user = await dio.post(
      "$baseurl/get-cart-data",
      data: user_form,
      options: Options(
        followRedirects: false,
        validateStatus: (status) => true,
      ),
    );
    print('Response GET CART DATA===${value_user.data}');
    if (value_user.statusCode == 200) {
      getcardModel = get_cart_model.fromJson(value_user.data);

    }
    return getcardModel;
    // throw "Somthing went wrong";
  }

  Future<double> getWalletAmount(user_id) async {
    final user_form = FormData();
    double walletAmount = 0.0;
    user_form.fields.add(MapEntry("user_id", user_id));

    final value_user =
        await dio.post("$baseurl/getWalletAmount", data: user_form);
    print('Waller Response ===${value_user.data['data']}');
    if (value_user.statusCode == 200) {
      walletAmount = double.parse(value_user.data['data'].toString());
      return walletAmount;
    }
    throw "Somthing went wrong";
  }

  //INCREASE/DECREASE_CART
  Future<decrease_cart_model> decrease_cart(
      service_category_id, user_id, device_id, qty) async {
    final user_form = FormData();

    user_form.fields.add(MapEntry("service_category_id", service_category_id));
    user_form.fields.add(MapEntry(
        "user_id", user_id.toString() == "" || user_id == null ? "" : user_id));
    user_form.fields.add(MapEntry("device_id", device_id??""));
    user_form.fields.add(MapEntry("qty", qty));

    final value_user =
        await dio.post("$baseurl/decrease-cart-qty", data: user_form);
    if (value_user.statusCode == 200) {
      final result_user = decrease_cart_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //GET_ADDONS
  Future<get_addons_model> get_addons(user_id, device_id) async {
    final user_form = FormData();
    print(user_id);
    print(device_id);
    user_form.fields.add(MapEntry("user_id", user_id));
    user_form.fields.add(MapEntry("device_id", device_id));
    print('Body===${user_form.fields}');
    print('AddOnURL==+${baseurl}/addOnsServiceList');
    final value_user =
        await dio.post("$baseurl/addOnsServiceList", data: user_form);
    if (value_user.statusCode == 200) {
      final result_user = get_addons_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //ADD DEFAULT ADDRESS
  Future<add_default_address_model> add_default_address(
      user_id, address_id) async {
    final user_form = FormData();

    user_form.fields.add(MapEntry("user_id", user_id));
    user_form.fields.add(MapEntry("address_id", address_id));

    final value_user =
        await dio.post("$baseurl/addDefaultAddress", data: user_form);
    if (value_user.statusCode == 200) {
      final result_user = add_default_address_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //EDIT ADDRESS
  Future<edit_address_model> edit_address(id, location, building_name, locality,
      latitude, longitude, pincode,area) async {
    final user_form = FormData();

    user_form.fields.add(MapEntry("user_id", id));
    user_form.fields.add(MapEntry("location", location));
    user_form.fields.add(MapEntry("building_name", building_name));
    user_form.fields.add(MapEntry("locality", locality));
    user_form.fields.add(MapEntry("latitude", latitude));
    user_form.fields.add(MapEntry("longitude", longitude));
    user_form.fields.add(MapEntry("pincode", pincode));
    user_form.fields.add(MapEntry("area", area));
    final value_user = await dio.post("$baseurl/editAddress", data: user_form);
    if (value_user.statusCode == 200) {
      final result_user = edit_address_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //GET TESTIMONIALS
  Future<get_testimonials_model> get_testimonials(user_id) async {
    final user_form = FormData();

    user_form.fields.add(MapEntry("user_id", user_id.toString()));

    final value_user =
        await dio.post("$baseurl/getTestimonials", data: user_form);
    if (value_user.statusCode == 200) {
      final result_user = get_testimonials_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //ADD INCLUDES CART
  Future<includes_updatecart_model> includes_updatecart(
      service_category_id, qty, user_id, device_id, List extra_include) async {
    List ext = [
      {"id": "2", "service_id": "3", "service": "test", "price": "400"}
    ];

    final user_form = FormData();

    user_form.fields.add(MapEntry("service_category_id", service_category_id));
    user_form.fields.add(MapEntry("qty", qty));
    user_form.fields.add(MapEntry("user_id", user_id.toString()));
    user_form.fields.add(MapEntry("device_id", device_id));

    extra_include.forEach((element) {
      var addsd = element.toString().replaceAll('"', "1");
      print("ELEMENT ${addsd}");
      user_form.fields.add(MapEntry("extra_include[]", element));
    });

    // user_form.fields.add(MapEntry("extra_include", "$extra_include"));

    final value_user =
        await dio.post("$baseurl/updateCartValue", data: user_form);
    if (value_user.statusCode == 200) {
      final result_user = includes_updatecart_model.fromJson(value_user.data);

      return result_user;
    }
    throw "Somthing went wrong";
  }

  //REMOVE FROM CART
  Future<remove_fromcart_model> remove_fromcart(
      user_id, device_id, cart_id) async {
    final user_form = FormData();

    // user_form.fields.add(MapEntry("service_category_id", service_category_id));
    user_form.fields.add(MapEntry(
        "user_id", user_id.toString() == "" || user_id == null ? "" : user_id));
    user_form.fields.add(MapEntry("device_id", device_id));
    user_form.fields.add(MapEntry("cart_id", cart_id));
    print(user_form.fields);
    final value_user =
        await dio.post("$baseurl/remove-item-from-cart", data: user_form);
    log('Respon====${value_user.data}');
    if (value_user.statusCode == 200) {
      final result_user = remove_fromcart_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //GET STAFFS
  Future<get_staffs_model> get_staffs(address_id, service_id) async {
    final user_form = FormData();

    user_form.fields.add(MapEntry("address_id", address_id.toString()));
    user_form.fields.add(MapEntry("service_id", service_id));

    final value_user =
        await dio.post("$baseurl/getProfessionals", data: user_form);
    if (value_user.statusCode == 200) {
      final result_user = get_staffs_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //GET STAFFS DETAILS
  Future<get_staff_details_model> get_staff_detail(staff_id) async {
    final user_form = FormData();

    // user_form.fields.add(MapEntry("staff_id", staff_id));
    Map<String, dynamic> map = {"staff_id": staff_id};

    final value_user =
        await dio.post("$baseurl/getStaffWiseRatings", data: map);
    print('Response====${value_user.data['status']}');
    if (value_user.data['status'] == true) {
      final result_user = get_staff_details_model.fromJson(value_user.data);
      return result_user;
    } else {
      final result_user = get_staff_details_model.fromJson(value_user.data);
      return result_user;
    }
    // throw "Somthing went wrong";
  }

  //BOOK SERVICE
  Future<book_service_model> book_service(
      user_id,
      category_id,
      isWalletApplied,
      tipamount,
      device_id,
      slot_id,
      price,
      payment_id,
      payment_status,
      booking_date,
      address_id,
      staff_id,
      staff_type) async {
    final user_form = FormData();

    user_form.fields.add(MapEntry("user_id", user_id));
    user_form.fields.add(MapEntry("category_id", category_id));
    user_form.fields.add(MapEntry("isWalletApplied", isWalletApplied));
    user_form.fields.add(MapEntry("tipamount", tipamount));
    user_form.fields.add(MapEntry("device_id", device_id));
    user_form.fields.add(MapEntry("slot_id", slot_id));
    user_form.fields.add(MapEntry("price", price));
    user_form.fields.add(MapEntry("payment_id", payment_id));
    user_form.fields.add(MapEntry("payment_status", payment_status));
    user_form.fields.add(MapEntry("booking_date", booking_date));
    user_form.fields.add(MapEntry("address_id", address_id));
    user_form.fields.add(MapEntry("staff_id", staff_id));
    user_form.fields.add(MapEntry("staff_type", staff_type));
    print(user_form.fields);
    final value_user = await dio.post("$baseurl/book-service", data: user_form);
    print('Response Booking ===${value_user.data}');
    if (value_user.statusCode == 200) {
      final result_user = book_service_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //ORDER HISTORY
  Future<order_history_model> order_history(
    user_id,
  ) async {
    final user_form = FormData();
    user_form.fields.add(MapEntry("user_id", user_id));
    final value_user =
        await dio.post("$baseurl/completeBooking", data: user_form);
    if (value_user.statusCode == 200) {
      final result_user = order_history_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //UPCOMING ORDER
  Future<upcoming_order_model> upcoming_order(
    user_id,
  ) async {
    final user_form = FormData();
    print('User===$user_id');
    user_form.fields.add(MapEntry("user_id", user_id));
    final value_user =
        await dio.post("$baseurl/upcomingBooking", data: user_form);
    print('Response===${value_user.data}');
    if (value_user.statusCode == 200) {
      final result_user = upcoming_order_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //GET REFER
  Future<get_rewards_model> get_rewards(
    user_id,
  ) async {
    print(user_id);
    final user_form = FormData();
    user_form.fields.add(MapEntry("user_id", user_id));
    final value_user =
        await dio.post("$baseurl/GetReward", data: user_form);
    print('User Response===${value_user.data}');
    if (value_user.statusCode == 200) {
      final result_user = get_rewards_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //GIVE RATING
  Future<give_rating_model> give_rating(
      staff_id, user_id, ratings, remark) async {
    final user_form = FormData();
    user_form.fields.add(MapEntry("staff_id", staff_id));
    user_form.fields.add(MapEntry("user_id", user_id));
    user_form.fields.add(MapEntry("ratings", ratings));
    user_form.fields.add(MapEntry("remark", remark));
    final value_user =
        await dio.post("$baseurl/giveRatingToStaff", data: user_form);
    if (value_user.statusCode == 200) {
      final result_user = give_rating_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  //GET COUPON
  Future<get_coupon_model> get_coupon(user_id) async {
    final user_form = FormData();
    user_form.fields.add(MapEntry("user_id", user_id));
    final value_user =
        await dio.post("$baseurl/getsettingsdata", data: user_form);
    print('Get Coupon Data ===${value_user.data}');
    if (value_user.statusCode == 200) {
      final result_user = get_coupon_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  // Get Ticket

  Future<AllTicketModel> getTicket(user_id) async {
    final user_form = FormData();
    user_form.fields.add(MapEntry("user_id", user_id));
    final value_user =
        await dio.post("$baseurl/ticketListing", data: user_form);
    if (value_user.statusCode == 200) {
      final result_user = AllTicketModel.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  Future<SupportChatModel> getSupportChat(ticketId) async {
    final user_form = FormData();
    user_form.fields.add(MapEntry("ticket_id", ticketId));
    final value_user = await dio.post("$baseurl/ticketReply", data: user_form);
    print('Ticket Response==${value_user.data}');
    if (value_user.statusCode == 200) {
      final result_user = SupportChatModel.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  Future<WalletDataModel> getWalletHistory(userId) async {
    final user_form = FormData();
    user_form.fields.add(MapEntry("user_id", userId));
    log("USER ID++++${userId}");
    final value_user =
        await dio.post("$baseurl/addAmountHistoryListing", data: user_form);
    print('Ticket Response==${value_user.data}');
    if (value_user.statusCode == 200) {
      final result_user = WalletDataModel.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  Future<bool> applyAvailableCashback(userId, amount, id) async {
    final user_form = FormData();
    user_form.fields.add(MapEntry("user_id", userId));
    // user_form.fields.add(MapEntry("amount", amount));
    user_form.fields.add(MapEntry("avilable_coupns_id", id.toString()));
    final value_user =
        await dio.post("$baseurl/addofferamount", data: user_form);
    if (value_user.statusCode == 200) {
      return true;
    }
    throw "Somthing went wrong";
  }

  Future<AllAvailableCoupon> getAvailableCouponData() async {
    final value_user = await dio.get("$baseurl/getAllavialablecoupns");
    print('Ticket Response==${value_user.data}');
    if (value_user.statusCode == 200) {
      final result_user = AllAvailableCoupon.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  Future<bool> addReplayTicket(user_id, ticketId, message) async {
    final user_form = FormData();
    user_form.fields.add(MapEntry("ticket_id", ticketId));
    user_form.fields.add(MapEntry("message", message));
    user_form.fields.add(MapEntry("type", 'User'));
    user_form.fields.add(MapEntry("created_by", user_id));
    final value_user =
        await dio.post("$baseurl/insertTicketReplyData", data: user_form);
    if (value_user.statusCode == 200) {
      return true;
    } else {
      return false;
    }
    throw "Somthing went wrong";
  }

  Future<bool> addTicket(String userId, String subject, String description,
      String? attachment) async {
    final user_form = FormData();
    user_form.fields.add(MapEntry("users", userId));
    user_form.fields.add(MapEntry("subject", subject));
    user_form.fields.add(MapEntry("description", description));
    user_form.fields.add(MapEntry("attachment", attachment??""));
    final value_user =
        await dio.post("$baseurl/insertTicketData", data: user_form);
    if (value_user.statusCode == 200) {
      return true;
    } else {
      return false;
    }
    throw "Somthing went wrong";
  }

  Future<CouponModel> getAllCoupon(user_id) async {
    final user_form = FormData();
    user_form.fields.add(MapEntry("user_id", user_id));
    final value_user =
        await dio.post("$baseurl/getcoupandata", data: user_form);
    if (value_user.statusCode == 200) {
      final result_user = CouponModel.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }

  Future<bool> applyCoupon(user_id, coupan_id) async {
    final user_form = FormData();
    user_form.fields.add(MapEntry("user_id", user_id));
    user_form.fields.add(MapEntry("coupan_code", coupan_id));
    final value_user = await dio.post("$baseurl/applycoupan", data: user_form);
    print('Apply Coupon ===${value_user.data}');
    if (value_user.data['status'] == true) {
      return true;
    }
    else
    {
      return false;
    }
  }

  //GET PINCODES
  Future<get_pincodes_model> get_pincodes() async {
    final user_form = FormData();
    // user_form.fields.add(MapEntry("user_id", user_id));
    final value_user = await dio.get("$baseurl/getallpincodes");
    print('Pincode===${value_user.data}');
    if (value_user.statusCode == 200) {
      final result_user = get_pincodes_model.fromJson(value_user.data);
      return result_user;
    }
    throw "Somthing went wrong";
  }
}
