
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../COMMON/comontoast.dart';
import '../../../apiservices.dart';
import '../Model/get_subcat_byid_model.dart';

class get_subcat_byid_controller extends GetxController{

  var loading = false.obs;
  var hasdata = false.obs;
  var response = get_subcat_byid_model().obs;
  var bannerimg=[].obs;
  var id=[].obs;

  Future<void>get_subcat_byid_cont(String cate_id)async{
    try{
      id.clear();
      loading(true);
      final respo = await api_service().get_subcat_byid(cate_id);
      if(respo.status == true){
        response = respo.obs;
        respo.data!.forEach((element) {
          if(id.contains(element.id)){

          }else{
            id.add(element.id);
          }
          print(id);
        });
        print("TRUEWEE");
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

  @override
  void onInit() {
    super.onInit();
    get_subcat_byid_cont("0");
  }
}