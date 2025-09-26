import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:restaurent_admin_app/core/services/api_service.dart';
import 'package:restaurent_admin_app/core/services/endpoint.dart';
import 'package:restaurent_admin_app/core/services/local_storage.dart';
import 'package:restaurent_admin_app/core/utils/common_wid.dart';
import 'package:restaurent_admin_app/feature/auth/view/login_page.dart';
import 'package:restaurent_admin_app/feature/home/view/admin_view/admin_home_page.dart';
import 'package:restaurent_admin_app/feature/home/view/kitchen_view/kitchen_home_page.dart';
import 'package:restaurent_admin_app/feature/home/view/waiter_view/waiter_home_page.dart';

class AuthController extends GetxController {
  final api = ApiService();

  var isLoading = false.obs;

  Future<void> register(String name, String email, String password) async {
    try {
      isLoading(true);

      // Send POST request
      var res = await api.post(
        EndPoints.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      // Access response data
      var data = res.data; // res.data is a Map<String, dynamic>

      if (data['success'] == true) {
        var result = data['data'];

        await SecureStorageHelper.saveValue(
            SecureStorageHelper.keyEmail, result['email'].toString());
        await SecureStorageHelper.saveValue(
            SecureStorageHelper.role, result['role'].toString());
        await SecureStorageHelper.saveValue(
            SecureStorageHelper.keyUsername, result['name'].toString());

        ToastHelper.showSuccess(data['success']);
      } else {
        ToastHelper.showError(data['success']);
      }
    } catch (e) {
      print('Error during registration: $e');
      ToastHelper.showError(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading(true);

      var data = {
        'email': email,
        'password': password,
      };

      var res = await api.post(EndPoints.login, data: data);
      var responseData = res.data;

      if (responseData['success'] == true) {
        var userData = responseData['data']['user'];
        var token = responseData['data']['token'];
        // Store token and user info securely

        print("user Data ${userData}");
        await SecureStorageHelper.saveValue(
            SecureStorageHelper.keyAccessToken, token);
        await SecureStorageHelper.saveValue(
            SecureStorageHelper.keyEmail, userData['email']);
        await SecureStorageHelper.saveValue(
            SecureStorageHelper.keyUsername, userData['name']);
        await SecureStorageHelper.saveValue(
            SecureStorageHelper.keyUserId, userData['id'].toString());
        await SecureStorageHelper.saveValue(
            SecureStorageHelper.role, userData['role']);

        ToastHelper.showSuccess(responseData['message'] ?? 'Login successful');
        String? role =
            await SecureStorageHelper.readValue(SecureStorageHelper.role);
        String? userId =
            await SecureStorageHelper.readValue(SecureStorageHelper.keyUserId);

        if (userId != null) {
          saveDeviceToken(userId);
        }

        // If token exists and is not empty, user is logged inR
        if (token != null && token.isNotEmpty && token != "ACCESS_TOKEN") {
          if (role != null && role == "ADMIN") {
            FirebaseMessaging.instance.subscribeToTopic("ADMIN");
            Get.to(() =>const AdminHomePage());
          }
         else if (role != null && role == "KITCHEN") {
          FirebaseMessaging.instance.subscribeToTopic("KITCHEN"); 
            Get.to(() =>const KitchenHomePage());
          }
         else if (role != null && role == "WAITER") {
          FirebaseMessaging.instance.subscribeToTopic("WAITER"); 
            Get.to(() =>const WaiterHomePage());
          }
        } else {
          Get.to(() => LoginPage());
        }
      } else {
        ToastHelper.showError(responseData['message'] ?? 'Login failed');
      }
    } catch (e) {
      ToastHelper.showError('Unexpected error occurred');
      print('Login error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> saveDeviceToken(String userId) async {
    final fcm = FirebaseMessaging.instance;
    final deviceInfo = DeviceInfoPlugin();
    String? deviceId;

    if (Platform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
    }

    String? token = await fcm.getToken();

    if (token != null) {
      await SecureStorageHelper.saveValue(SecureStorageHelper.fcmToken, token);

      if (kDebugMode) {
        print("device fcm token $token");
      }
      await api.put(
        EndPoints.registerToken,
        data: {
          "id": int.parse(userId),
          "fcmToken": token,
        },
      );
    }
  }

  Future<void> checkLogin() async {
    try {
      // Retrieve token from secure storage
      String? token = await SecureStorageHelper.readValue(
          SecureStorageHelper.keyAccessToken);
      String? role =
          await SecureStorageHelper.readValue(SecureStorageHelper.role);

      // If token exists and is not empty, user is logged in

      print(token);

      print(role);
      if (token != null && token.isNotEmpty && token != "ACCESS_TOKEN") {
        if (role != null && role == "ADMIN") {
          Get.to(() => AdminHomePage());
        }
      } else {
        Get.to(() => LoginPage());
      }
    } catch (e) {
      print('Error checking login: $e');
    }
  }
}
