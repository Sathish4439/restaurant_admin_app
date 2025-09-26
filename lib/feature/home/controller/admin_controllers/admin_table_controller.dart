import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restaurent_admin_app/core/services/api_service.dart';
import 'package:restaurent_admin_app/core/services/endpoint.dart';
import 'package:restaurent_admin_app/core/utils/common_wid.dart';
import 'package:restaurent_admin_app/feature/home/model/admin_models/dinning_table_model.dart';

class AdminTableController extends GetxController {
  var loadTables = false.obs;
  var listalltable = <DiningTable>[].obs;
  var nameController = TextEditingController();
  final RxString selectedStatus = 'VACANT'.obs;
  final api = ApiService();

  Future<void> fetchtable() async {
    debugPrint("fetchMenu called");
    try {
      loadTables(true);
      listalltable.clear();

      var res = await api.get(EndPoints.getTable);

      if (res.data['success']) {
        var li = (res.data['data'] as List)
            .map((e) => DiningTable.fromJson(e))
            .toList();

        if (li.isNotEmpty) {
          listalltable.value = li;

          // ToastHelper.showSuccess(res.data['message']);
        } else {
          //  ToastHelper.showError(res.data['message']);
        }
      }

      debugPrint(res.toString());
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      loadTables(false);
    }
  }

  Future<void> createTable() async {
    try {
      var data = {
        "name": nameController.text,
        "status": selectedStatus.value,
      };
      var res = await api.post(EndPoints.addMenu, data: data); // ✅ send as body

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

  Future<void> downloadQR(String id) async {
    try {
      // Call your backend API
      var res = await api.get("${EndPoints.downloadQR}/$id",
          responseType: dio.ResponseType.bytes);

      // Convert to bytes
      Uint8List bytes = Uint8List.fromList(res.data);

      // Get Downloads folder
      Directory downloadsDir;
      if (Platform.isAndroid) {
        downloadsDir = Directory("/storage/emulated/0/Download");
      } else {
        downloadsDir = await getApplicationDocumentsDirectory();
      }

      // File path
      String filePath = "${downloadsDir.path}/qr_$id.png";
      File file = File(filePath);

      // Save file
      await file.writeAsBytes(bytes);

      ToastHelper.showSuccess("✅ QR downloaded at: $filePath");
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error downloading QR: $e");
      }
    }
  }

  Future<void> updateTable(int id, String name, String status) async {
    try {
      var res = await api.put("${EndPoints.updateTable}/$id",
          data: {"name": name, "status": status});
      print(res);
      if (res.data['success']) {
        ToastHelper.showSuccess(res.data['message']);
      } else {
        ToastHelper.showError(res.data['message']);
      }
    } catch (e) {
      ToastHelper.showError(e.toString());
    } finally {
      fetchtable();
    }
  }

  Future<void> deleteTable(
    int id,
  ) async {
    try {
      var res = await api.delete(
        "${EndPoints.deleteTable}/$id",
      );

      if (res.data['success']) {
        ToastHelper.showSuccess(res.data['message']);
      } else {
        ToastHelper.showError(res.data['message']);
      }
    } catch (e) {
      ToastHelper.showError(e.toString());
    } finally {
      fetchtable();
    }
  }
}
