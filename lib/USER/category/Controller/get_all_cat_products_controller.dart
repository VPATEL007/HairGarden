import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hairgarden/USER/category/Model/get_all_cat_products_model.dart';

import '../../../COMMON/common_color.dart';
import '../../../COMMON/comontoast.dart';
import '../../../apiservices.dart';
import '../Model/get_subcat_byid_model.dart';
import 'get_cart_controller.dart';

class get_all_cat_products_controller extends GetxController {
  RxBool loading = false.obs;
  var response = get_all_cat_products_model().obs;
  RxList getbiyd = [].obs;
  RxString uid = "".obs;
  var comparesearchid = [].obs;
  var allsearchtxt = [].obs;
  var catsearchid = [].obs;
  var allproductid = [].obs;
  var allproductcatid = [].obs;
  var maincat = [].obs;
  var maincatname = [].obs;
  RxInt indexOfId = 0.obs;
  RxInt selected_cat = 0.obs;

  RxList checkprodid = [].obs;

  Future<void> get_all_cat_products_cont() async {
    try{
      loading(true);
      final respo = await api_service().get_all_cat_products();
      print('Vijay Length===${respo.data?.length}');
      if(respo.status == true){
        response = respo.obs;
        getbiyd.clear();
        catsearchid.clear();
        allsearchtxt.clear();
        comparesearchid.clear();
        allproductid.clear();
        allproductcatid.clear();
        maincat.clear();
        maincatname.clear();
        checkprodid.clear();

        response.value.data!.forEach((element) {
          element.serviceCategoryData!.forEach((element2) {
            if(element2.subcateProduct!.isNotEmpty){
              maincat.add(element2.subcatId);
              maincatname.add(element2.subcatName);
            }
          });
        });

        response.value.data!.forEach((element) {
          element.serviceCategoryData!.forEach((element1) {
            element1.subcateProduct!.forEach((element2) {
              checkprodid.add(element2.id.toString());
              allproductcatid.add(element2.categoryId.toString());
            });
          });
        });

        response.value.data!.forEach((element) {
          allsearchtxt.add(element.name.toString());
          catsearchid.add(element.name.toString());
          comparesearchid.add(element.name.toString());

          element.serviceCategoryData!.forEach((element1) {
            allsearchtxt.add(element1.subcatName.toString());
            catsearchid.add(element.name.toString());
            element1.subcateProduct!.forEach((element2) {
              allsearchtxt.add(element2.title.toString());
              catsearchid.add(element.name.toString());
            });
          });
        });
        response.value.data!.forEach((element) {
          if(element.serviceCategoryData!.isNotEmpty){
            element.serviceCategoryData!.forEach((element1) {
              if( element1.subcateProduct!.isNotEmpty){
                element1.subcateProduct!.forEach((element2) {
                  allproductid.add(element2.id);
                });
              }
            });
          }
        });

        response.value.data!.forEach((element) {
          getbiyd.add(element.id.toString());
        });
        print('Vijay Final Length===${response().data?.length}');
        loading(false);
      }
      else {
        response = respo.obs;
        commontoas(respo.message.toString());
      }
    }
    finally{
      loading(false);
    }
  }
}
