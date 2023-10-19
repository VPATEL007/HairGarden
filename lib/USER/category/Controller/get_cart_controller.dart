import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hairgarden/COMMON/comontoast.dart';

import '../../../apiservices.dart';
import '../Model/get_cart_model.dart';

class get_cart_controller extends GetxController {
  var loading = false.obs;
  var hasdata = false.obs;
  var response = get_cart_model().obs;
  var prodid = [].obs;
  var addonid = [].obs;
  var addonallid = [].obs;
  var prodcatid = [].obs;
  RxDouble walletAMount = 0.0.obs;
  Timer? timer;

  Future<void> get_cart_cont(user_id, device_id) async {
    try{
      loading(true);
      final respo = await api_service().get_cart(user_id??"", device_id);
      print('Response Vijay==${respo?.status}');
      if (respo?.status ?? false) {
        response = respo!.obs;
        prodid = [].obs;
        addonid = [].obs;
        addonallid = [].obs;
        prodcatid = [].obs;
        print('Vijay Daily====${response.value.data}');
        response.value.data!.forEach((element) {
          addonallid.add(element.serviceCateId);
          print('Type====${element.type}');
          if (element.type == "service") {
            prodid.add(element.serviceCateId.toString());
          }
          if (element.type == "addonservice") {
            addonid.add(element.serviceCateId.toString());
          }
        });
        response.value.data!.sort((a, b) => b.type!.compareTo(a.type!));
        print("PROD ID: $prodid");
        loading(false);
        // commontoas(msg: respo.message.toString());
      }
      else {
        response = respo!.obs;
        // loading(false);
        // commontoas(respo?.message.toString()??"");
      }
    }
    finally{
      loading(false);
    }

  }

  //
  // var response1 = get_cart_model().obs;
  Future<void> getWalletAmount(user_id) async {
    try {
      final respo = await api_service().getWalletAmount(user_id);
      walletAMount(respo);
    } finally {}
  }
}
