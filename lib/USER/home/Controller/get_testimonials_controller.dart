
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../apiservices.dart';
import '../Model/get_testimonials_model.dart';

class get_testimonials_controller extends GetxController{
  var loading = false.obs;
  var response = get_testimonials_model().obs;
  var yturl=[].obs;

  YoutubePlayerController? video_controller_y;

  List vid_d = [].obs;

  void youtube(String you_li){

    String url  = you_li;
    vid_d.add( YoutubePlayer.convertUrlToId(url)!.obs);

  }

  Future<void>get_testimonials_cont(user_id)async{
    try{
      yturl=[].obs;
      loading(true);
      final respo = await api_service().get_testimonials(user_id);
      if(respo.status == true){
        response = respo.obs;
        yturl=[].obs;
        vid_d = [].obs;
        vid_d.clear();
        response.value.data!.forEach((element) {
          yturl.add(element.url.toString());
          youtube(element.url.toString());
        });
      }
    }
    finally{
      loading(false);
    }

  }

}