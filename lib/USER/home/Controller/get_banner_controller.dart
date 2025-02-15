import 'dart:developer';

import 'package:get/get.dart';

import '../../../apiservices.dart';
import '../Model/get_banner_model.dart';

class get_banner_controller extends GetxController {
  var loading = false.obs;
  var response = get_banner_model().obs;
  RxList bottombannerimg = [].obs;
  RxList bottombannercatid = [].obs;

  RxList middlebannerimg = [].obs;
  RxList middlebannercatid = [].obs;

  RxList offerbannerimg = [].obs;
  RxList offermbannercatid = [].obs;

  RxList topbannerimg = [].obs;
  RxList topbannercatid = [].obs;
  RxList catbottombannerimg = [].obs;
  RxList catbottombannercatid = [].obs;

  Future<void> get_banner_cont() async {
    try{
      loading(true);
      final respo = await api_service().getbannner();
      if (respo.status == true) {
        response = respo.obs;
        log("RESPONSE LENGTH===${response.value.data?.length}");
        topbannerimg.clear();
        middlebannerimg.clear();
        offerbannerimg.clear();
        bottombannerimg.clear();
        catbottombannerimg.clear();
        response.value.data!.forEach((element) {
          if (element.bannerOn == "top" && element.placement == "Home") {
            log("TOP===${element.id}");
            if(!topbannerimg.contains(element.banner))
              {
                print("ENTER 1");
                loading(false);
                topbannerimg.clear();
                topbannerimg.add(element.banner);
                topbannercatid.add(element.cateId);
              }

          }
          else if (element.bannerOn == "middle" &&
              element.placement == "Home") {
            if(!middlebannerimg.contains(element.banner))
            {
              loading(false);
              middlebannerimg.add(element.banner);
              middlebannercatid.add(element.cateId);
            }

          } else if (element.bannerOn == "Offer" && element.placement == "Home") {
            loading(false);
            offerbannerimg.add(element.banner);
            offermbannercatid.add(element.cateId);
          } else if (element.bannerOn == "bottom" &&
              element.placement == "Home") {
            loading(false);
            bottombannerimg.add(element.banner);
            bottombannercatid.add(element.cateId);
          } else if (element.bannerOn == "bottom" &&
              element.placement == "Category" ||
              element.bannerOn == "Offer" && element.placement == "Category" ||
              element.bannerOn == "middle" && element.placement == "Category" ||
              element.bannerOn == "top" && element.placement == "Category") {
            loading(false);
            catbottombannerimg.add(element.banner);
            catbottombannercatid.add(element.cateId);
          }
        });

      } else {
        loading(false);
      }
    }
    finally{
      loading(false);
    }

  }

}
