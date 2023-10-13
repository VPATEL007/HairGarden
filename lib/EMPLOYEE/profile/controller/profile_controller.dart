import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hairgardenemployee/EMPLOYEE/profile/model/update_profile_model.dart';
import 'package:hairgardenemployee/api_services/api_services.dart';
import 'package:hairgardenemployee/auth/model/all_staff_service_model.dart';

class StaffProfileController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isUpdateLoading = false.obs;
  Rx<StaffProfileDataModel> model = StaffProfileDataModel().obs;
  Rx<AllStaffServiceModel> getStaffService = AllStaffServiceModel().obs;
  RxList selectedCheckValueList = [].obs;
  RxList selectedProfession = [].obs;
  RxString selectedProfessionValue = "".obs;

  Future<void> fetchStaffProfile(String staffId) async {
    try {
      isLoading(true);
      StaffProfileDataModel respo = await api_services().getStaffProfileData(staffId);

      if (respo.status == true) {
        model(respo);
        update();
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> allStaffService() async {
    try {
      isLoading(true);
      final respo = await api_services().getAllStaffService();
      if (respo.status == true) {
        getStaffService(respo);
      }
    } finally {
      isLoading(false);
    }
  }
}
