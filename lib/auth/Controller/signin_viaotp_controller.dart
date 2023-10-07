import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hairgarden/COMMON/comontoast.dart';
import 'package:hairgarden/USER/common/custom_snakbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../USER/bottombar/Screens/bottombar.dart';
import '../../apiservices.dart';
import '../Model/signin_viaOTP_model.dart';

class signin_viaOTP_controller extends GetxController {
  var loading = false.obs;
  var response = signin_viaOTP_model().obs;

  Future<void> signin_viaOTP_cont(mobile, otp,deviceID) async {
    try {
      loading(true);
      final respo = await api_service().signin_otp(mobile, otp,deviceID);
      log('SIGN UP RESPONSE===${respo.data}');
      if (respo.status == true) {
        response = respo.obs;
        SharedPreferences sf = await SharedPreferences.getInstance();
        sf.setString("isgmail", "true");
        sf.setString("sp_wallet", response.value.data!.wallet.toString());
        sf.setString("stored_uid", response.value.data!.id.toString());
        sf.setString("sp_refercode", response.value.data!.referCode.toString());
        // Get.to(bottombar(pasindx: 0));
      } else {
        response = respo.obs;
        log('SIGN UP RESPONSE===${response.value.message}');
        commontoas(respo.message.toString(),
        );
      }
    } finally {
      loading(false);
    }
  }
}
