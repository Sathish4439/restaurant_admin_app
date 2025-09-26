import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurent_admin_app/core/services/local_storage.dart';
import 'package:restaurent_admin_app/feature/auth/view/splash_page.dart';

class AdminHomeController extends GetxController {
  var gridData = ["Menu", "Table", "Staff", "Order", "Analytics"];

  var currentUserRole = "".obs;
  var currentUserName = "".obs;

  Future<void> LoadData() async {
    try {
      // Retrieve token from secure storage
      String? name =
          await SecureStorageHelper.readValue(SecureStorageHelper.keyUsername);
      String? role =
          await SecureStorageHelper.readValue(SecureStorageHelper.role);

      // If token exists and is not , user is logged in

      if (name != null && role != null) {
        currentUserName.value = name;
        currentUserRole.value = role;
      }

      print("currentuserName: $currentUserName");
      print("currentuserRole: $currentUserRole");
    } catch (e) {
      print('Error checking login: $e');
    }
  }

  void logout() async {
    try {
      await SecureStorageHelper.deleteAll(); // Clear all stored data
      Get.offAll(() => splash_page()); // Navigate to splash screen
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }
}
