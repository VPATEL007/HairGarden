

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../COMMON/common_color.dart';
import '../../../COMMON/comontoast.dart';
import '../../../apiservices.dart';
import '../Model/get_prod_bysubcat_cat_model.dart';

class get_prod_bysubcat_cat_controller extends GetxController{

  var loading = false.obs;
  var hasdata = false.obs;
  var response = get_prod_bysubcat_cat_model().obs;

  Future<void>get_prod_bysubcat_cat_cont(String cate_id,sub_cate_id)async{
    try{
      loading(true);
      final respo = await api_service().get_prod_bysubcat_cat(cate_id, sub_cate_id);
      if(respo.status == true){
        response = respo.obs;
        // Get.snackbar("title", "message");
      }
      else {
        response = respo.obs;
        print(respo);
        commontoas(respo.message.toString());
        hasdata(true);

      }
    }
    finally{
      loading(false);
    }

  }

}