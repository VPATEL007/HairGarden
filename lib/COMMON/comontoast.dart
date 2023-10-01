import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hairgarden/USER/common/custom_snakbar.dart';
import 'package:get/get.dart';
import 'common_color.dart';

commontoas(String msg){
  Get.rawSnackbar(
      icon: const SizedBox(),
      backgroundColor: yellow_col,
      borderRadius: 12,
      margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 12),
      duration: const Duration(seconds: 2),
      messageText: Text(
      msg,
      style:  const TextStyle(
        fontSize: 18.0,
        color: Colors.white,
      ),
    )
  );
}
