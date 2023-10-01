import 'package:get/get.dart';
import 'package:html/parser.dart';
import '../../../apiservices.dart';
import '../Model/view_prod_details_model.dart';
import '../Model/viewdetails_addons_model.dart';


class viewdetails_addons_controller extends GetxController{
  var loading = false.obs;
  var response = viewdetails_addons_model().obs;

  Future<void>viewdetails_addons_cont(id)async{
    try{
      loading(true);
      final respo = await api_service().viewdetails_addons(id);
      if(respo.status == true){
        response = respo.obs;
      }
      else{

      }
    }
    finally{
      loading(false);
    }
  }
}