import 'package:get/get.dart';
import 'package:hairgarden/COMMON/comontoast.dart';
import 'package:hairgarden/USER/support/Screens/support_ticket.dart';
import 'package:hairgarden/apiservices.dart';
import 'package:hairgarden/auth/Model/support_chat_model.dart';
import 'package:hairgarden/auth/Model/ticket_model.dart';

class SupportController extends GetxController
{
  var loading=false.obs;
  Rx<AllTicketModel> ticketModel = AllTicketModel().obs;
  Rx<SupportChatModel> supportChatModel = SupportChatModel().obs;

  Future<void>getAllTicket(user_id) async {
    try{
      loading(true);
      final respo=await api_service().getTicket(user_id);

      if(respo.status==true){
        ticketModel=respo.obs;
      }

    }
    finally{
      loading(false);
    }
  }

  Future<void>addTicketReplay(user_id,message,ticket_id) async {
    await api_service().addReplayTicket(user_id,ticket_id,message);
    commontoas('Message Send Successfully');
  }



  Future<void>addTicket(String userId,String subject,String description,String? attachment) async {
    try{
      loading(true);
      final respo=await api_service().addTicket(userId,subject,description,attachment??"");

      if(respo){
          commontoas('Ticket Inserted Successfully');
          Get.to(SupportTicketView());
      }
      else
       {
         commontoas('Something Went Wrongly');
       }

    }
    finally{
      loading(false);
    }
  }

  Future<void>getSupportChat(ticketId) async {

    try{
      loading(true);
      final respo=await api_service().getSupportChat(ticketId);
      print('Response==${respo.message}');
      if(respo.status==true){
        supportChatModel(respo);
      }
    }
    finally{
      loading(false);
    }
  }
}