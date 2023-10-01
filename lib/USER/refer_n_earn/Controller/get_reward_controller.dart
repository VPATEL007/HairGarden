import 'package:get/get.dart';

import '../../../apiservices.dart';
import '../Model/get_reward_model.dart';

class get_reward_controller extends GetxController {
  var loading = false.obs;
  Rx<get_rewards_model> response = get_rewards_model().obs;

  Future<void> get_reward_cont(user_id) async {
    try {
      loading(true);
      final respo = await api_service().get_rewards(user_id);
      print('Response Refern===${respo.data}');
      if (respo.status == true) {
        response = respo.obs;
      }
    } finally {
      loading(false);
    }
  }
}
