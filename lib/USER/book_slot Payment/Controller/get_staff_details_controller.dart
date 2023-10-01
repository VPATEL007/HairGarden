import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../COMMON/common_color.dart';
import '../../../COMMON/comontoast.dart';
import '../../../apiservices.dart';
import '../Model/get_staff_details_model.dart';
import '../Model/get_staffs_model.dart';

class get_staffs_details_controller extends GetxController {
  var loading = false.obs;
  var response = get_staff_details_model().obs;
  bool hasnodata = false;
  var myreviewimg = [].obs;
  var myreviewname = [].obs;
  var myreviewdesc = [].obs;
  var myreviewdate = [].obs;
  var uid;
  int? totpersonrat;

  Future<void> get_staffs_details_cont(staff_id) async {
    print(staff_id.runtimeType);
    print(staff_id);
    try {
      loading(true);
      final respo = await api_service().get_staff_detail(staff_id);
      if (respo.status == true) {
        response = respo.obs;
        myreviewimg = [].obs;
        myreviewname = [].obs;
        myreviewdesc = [].obs;
        myreviewdate = [].obs;

        myreviewimg.clear();
        myreviewname.clear();
        myreviewdesc.clear();
        myreviewdate.clear();

        SharedPreferences sf = await SharedPreferences.getInstance();
        uid = sf.getString("stored_uid");
        response.value.data!.forEach((element) {
          if (element.userId == uid) {
            myreviewimg.add(element.userimage);
            myreviewname.add(element.username);
            myreviewdesc.add(element.ratings);
            myreviewdate.add(element.createdAt);
          }
        });
        // commontoas(respo.message.toString());
      } else {
        response = respo.obs;
        // commontoas(respo.message.toString());
      }
    } finally {
      loading(false);
    }
  }
}
