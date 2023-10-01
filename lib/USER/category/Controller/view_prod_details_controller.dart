import 'package:get/get.dart';
import 'package:html/parser.dart';
import '../../../apiservices.dart';
import '../Model/view_prod_details_model.dart';


class view_prod_details_controller extends GetxController{
  var loading = false.obs;
  var response = view_prod_details_model().obs;
  var checkboxlst=[].obs;
  var servicemount=[].obs;
  var inlcudetxt;

  Future<void>view_prod_details_cont(id)async{
    try{
      loading(true);
      final respo = await api_service().view_prod_details(id);
      if(respo.status == true){
        response = respo.obs;
        checkboxlst=[].obs;
        servicemount=[].obs;
        final document = parse(response.value.data!.whatincludes.toString().replaceAll("<li>", "• "));
        inlcudetxt = parse(document.body!.text).documentElement!.text;
      }
      else{

      }
    }
    finally{
      loading(false);
    }
  }
}