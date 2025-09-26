import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurent_admin_app/core/services/api_service.dart';
import 'package:restaurent_admin_app/core/services/endpoint.dart';
import 'package:restaurent_admin_app/core/utils/common_wid.dart';
import 'package:restaurent_admin_app/feature/home/model/admin_models/user_model.dart';

class AdminUserController extends GetxController {
  var loadUser = false.obs;
  var listofUser = [].obs;
  var showPassword = false.obs;

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var image_url = "".obs;

  var loadImage = false.obs;

  var selectedImage = Rxn<File>(); // picked image
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    print("pick image called");
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);

      await uploadImage(selectedImage.value!, loadImage, image_url);
    }
  }

  var selectedRole = "WAITER".obs;
  var roles = ["ADMIN", "WAITER", "CHEIF"].obs;

  final api = ApiService();

  Future<void> fetchUser() async {
    debugPrint("fetchMenu called");
    try {
      loadUser(true);
      listofUser.clear();

      var res = await api.get(EndPoints.getUser);

      print(res);

      if (res.data['success']) {
        var li =
            (res.data['data'] as List).map((e) => User.fromJson(e)).toList();

        if (li.isNotEmpty) {
          listofUser.value = li;

          // ToastHelper.showSuccess(res.data['message']);
        } else {
          //  ToastHelper.showError(res.data['message']);
        }
      }

      debugPrint(res.toString());
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      loadUser(false);
    }
  }

  Future<void> createTable() async {
    try {
      var data = {
        "name": nameController.text,
        "password": passwordController.value,
        "email": emailController.text,
        "role": selectedRole.value
      };
      var res =
          await api.post(EndPoints.createUser, data: data); // ✅ send as body

      if (res.data['success']) {
        ToastHelper.showSuccess(res.data['message']);
      } else {
        ToastHelper.showError(res.data['message']);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> addUser() async {
    try {
      var body = {
        "name": nameController.text,
        "password": passwordController.text,
        "email": emailController.text,
        "role": selectedRole.value,
        "imageUrl": selectedImage.value!.path.split('/').last
      };

      if (kDebugMode) {
        print(body);
      }
      var res = await api.post(EndPoints.createUser, data: body);
      if (kDebugMode) {
        print(res);
      }
      if (res.data['success']) {
        ToastHelper.showSuccess(res.data['message']);
      } else {
        ToastHelper.showError(res.data['message']);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> updateUser(int id) async {
    try {
      var body = {
        "name": nameController.text,
        "password": passwordController.text,
        "email": emailController.text,
        "role": selectedRole.value,
        "imageUrl": selectedImage.value!.path.split('/').last
      };

      print(body);

      var res = await api.put("${EndPoints.updateUser}/$id", data: body);
      print(res);
      if (res.data['success']) {
        ToastHelper.showSuccess(res.data['message']);
      } else {
        ToastHelper.showError(res.data['message']);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      fetchUser();
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      print("${EndPoints.deleteUser}/$id");
      var res = await api.delete(
        "${EndPoints.deleteUser}/$id",
      );
      print(res);
      if (res.data['suceess']) {
        ToastHelper.showSuccess(res.data['message']);
      } else {
        ToastHelper.showError(res.data['message']);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      fetchUser();
    }
  }
}
