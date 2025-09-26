import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurent_admin_app/core/services/api_service.dart';
import 'package:restaurent_admin_app/core/services/endpoint.dart';
import 'package:restaurent_admin_app/core/utils/common_wid.dart';
import 'package:restaurent_admin_app/feature/home/model/admin_models/menu_item_model.dart';

class AdminMenuController extends GetxController {
  final api = ApiService();

  var loadMenu = false.obs;
  var menuList = <MenuItem>[].obs;

  var categories = <String>[].obs;
  var selectedCategory = ''.obs;

  var isLoading = false.obs;
  var uploadedUrl = "".obs;

  var idController = TextEditingController();
  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  var priceController = TextEditingController();
  var categoryController = TextEditingController();
  var imageUrlController = TextEditingController();
  var createdAtController = TextEditingController();
  var notesController = TextEditingController();

  List<MenuOption> options = [];
  List<OrderItem> orderItems = [];

  Future<void> fetchMenu() async {
    debugPrint("fetchMenu called");
    try {
      loadMenu(true);
      menuList.clear();

      var res = await api.get(EndPoints.getMenu);

      if (res.data['success']) {
        var li = (res.data['data'] as List)
            .map((e) => MenuItem.fromJson(e))
            .toList();

        if (li.isNotEmpty) {
          menuList.value = li;

          // ✅ Get unique categories (ignores nulls)
          categories.value = menuList
              .map((p0) => p0.category)
              .whereType<String>() // removes nulls
              .toSet()
              .toList();

          ToastHelper.showSuccess(res.data['message']);
        } else {
          ToastHelper.showError(res.data['message']);
        }
      }

      debugPrint(res.toString());
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      loadMenu(false);
    }
  }

  Future<void> createMenu() async {
    try {
      var data = {
        "name": nameController.text,
        "description": descriptionController.text,
        "price": int.tryParse(priceController.text) ?? 0,
        "category":
            menuList.isEmpty ? categoryController.text : selectedCategory.value,
        "imageUrl": imageUrlController.text,
        "createdAt":
            DateTime.tryParse(createdAtController.text)?.toIso8601String() ??
                DateTime.now().toIso8601String(),
        "notes": notesController.text,
        "options": options
            .map((o) => {
                  "name": o.name,
                  "extraPrice": int.tryParse(o.extraPrice) ?? 0,
                })
            .toList(),
        "orderItems": orderItems, // keep as array if backend expects it
      };

      var res = await api.post(EndPoints.addMenu, data: data); // ✅ send as body

      if (res.data['success']) {
        ToastHelper.showSuccess(res.data['message']);
      
      } else {
        ToastHelper.showError(res.data['message']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteMenu(String id) async {
    print("deleteMenu called");
    try {
      var res = await api.delete("${EndPoints.deleteMenu}/$id");

      print(res);
    } catch (e) {
      print(e);
    }
  }


  Future<void> updateMenu(String id) async {
    try {
      var data = {
        "name": nameController.text,
        "description": descriptionController.text,
        "price": int.tryParse(priceController.text) ?? 0,
        "category":
            menuList.isEmpty ? categoryController.text : selectedCategory.value,
        "imageUrl": imageUrlController.text,
        "createdAt":
            DateTime.tryParse(createdAtController.text)?.toIso8601String() ??
                DateTime.now().toIso8601String(),
        "notes": notesController.text,
        "options": options
            .map((o) => {
                  "name": o.name,
                  "extraPrice": int.tryParse(o.extraPrice) ?? 0,
                })
            .toList(),
        "orderItems": orderItems, // keep as array if backend expects it
      };

      var res = await api.put("${EndPoints.updateMenu}/$id", data: data); // ✅ send as body

      if (res.data['success']) {
        ToastHelper.showSuccess(res.data['message']);
      
      } else {
        ToastHelper.showError(res.data['message']);
      }
    } catch (e) {
      print(e);
    }
  }

}
