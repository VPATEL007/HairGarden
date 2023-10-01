import 'package:get/get.dart';
import 'package:hairgarden/apiservices.dart';
import 'package:hairgarden/auth/Model/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationController extends GetxController
{

  RxBool loading = false.obs;
  RxString userId = ''.obs;
  Rx<NotificationModel> notificationModel = NotificationModel().obs;

  Future<void>getNotificationData()async{
    try{
      loading(true);
      SharedPreferences sf = await SharedPreferences.getInstance();
      userId(sf.getString("stored_uid"));
      final respo = await api_service().getNotificationData(userId.value);
      if(respo.status == true){
        notificationModel(respo);
      }
    }
    finally{
      loading(false);
    }
  }

  @override
  void onInit() {
    getNotificationData();
    super.onInit();
  }
}