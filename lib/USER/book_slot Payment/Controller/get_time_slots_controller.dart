
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../COMMON/comontoast.dart';
import '../../../apiservices.dart';
import '../Model/get_time_slots_model.dart';

class get_time_slots_controller extends GetxController{
  var loading =false.obs;
  var response=get_time_slots_model().obs;

  var  timstoreampm=[].obs;
  var timstoreend=[].obs;
  var alltime=[].obs;
  var alltimeid=[].obs;
  var timeindx;

  Future<void>get_time_slots_cont(type, staff_id)async {
    try {
      loading(true);
      final respo = await api_service().get_time_slots(type, staff_id);
      print(respo.data);
      print("Id==${staff_id}");
      print('Type===${type}');
      if (respo.status == true) {
        response = respo.obs;

        timstoreampm=[].obs;
        timstoreend=[].obs;
        alltime=[].obs;
        alltimeid.clear();
        response.value.data!.forEach((element) {
          alltime.add(element.timeSlot);
          alltimeid.add(element.id);
          timstoreampm.add((element.timeSlot!.substring(0,element.timeSlot!.indexOf("-"))));
          timstoreend.add(element.timeSlot!.substring(element.timeSlot!.indexOf("-")).replaceAll("-", "").trim());
        });
        // commontoas(msg: respo.message.toString());
      }
      else {
        response = respo.obs;
        commontoas(respo.message.toString());
      }
    }
    finally {
      loading(false);
    }
  }


}