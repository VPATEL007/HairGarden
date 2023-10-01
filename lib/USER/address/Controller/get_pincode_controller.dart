
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hairgarden/apiservices.dart';

import '../Model/get_pincode_model.dart';

class get_pincode_controller extends GetxController{
  var loading =true.obs;
  var response= get_pincodes_model().obs;
  var listofpincode=[].obs;
  Future<void>get_pincode_cont() async {
    try{
      loading(true);
      final resp=await api_service().get_pincodes();

      resp.data?.forEach((element) {
        print('Pincode Response===${element.pinCode}');
      });
      if(resp.status==true){
        response=resp.obs;
        listofpincode=[].obs;
        listofpincode.clear();
        response.value.data!.forEach((element) {
          listofpincode.add(element.pinCode);
        });
      }
    }
    finally{
      loading(false);
    }
  }

  @override
  void onInit() {
    get_pincode_cont();
    super.onInit();
  }
}