import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:restaurent_admin_app/core/theme/app_color.dart';
import 'package:restaurent_admin_app/core/utils/common_wid.dart';
import 'package:restaurent_admin_app/feature/home/controller/admin_controllers/admin_table_controller.dart';
import 'package:restaurent_admin_app/feature/home/view/widget/widgets.dart';

class TableManagementPage extends StatefulWidget {
  const TableManagementPage({super.key});

  @override
  State<TableManagementPage> createState() => _TableManagementPageState();
}

class _TableManagementPageState extends State<TableManagementPage> {
  var controller = Get.put(AdminTableController());
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setData();
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomerAppbar(title: "Manage Table"),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondary,
        onPressed: () {
          showAddTableDialog(
            onSubmit: (name, status) {
              controller.createTable();
            },
          );
        },
        child: const Icon(
          Icons.add,
          color: AppColors.textWhite,
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Obx(() => controller.listalltable.isEmpty
              ? Center(
                  child: Text("Add Tables"),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  itemCount: controller.listalltable.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    var table = controller.listalltable[index];
                    return TableWid(
                        onUpdate: () {
                          showUpdateTableDialog(
                            currentName: table.name,
                            currentStatus: table.status,
                            onUpdate: (name, status) {
                              // Call your API to update the table
                              controller.updateTable(table.id, name, status);
                            },
                          );
                        },
                        table: table,
                        onDelete: () {
                          showDeleteTableDialog(
                            onSubmit: () {
                              controller.deleteTable(table.id);
                            },
                            tableName: table.name,
                          );
                        });
                  },
                ))
        ],
      ),
    );
  }

  void showUpdateTableDialog({
    required String currentName,
    required String currentStatus,
    required Function(String name, String status) onUpdate,
  }) {
    var controller = Get.put(AdminTableController());

    // Pre-fill existing values
    controller.nameController.text = currentName;
    controller.selectedStatus.value = currentStatus;

    Get.defaultDialog(
      title: 'Update Table',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller.nameController,
            decoration: const InputDecoration(
              labelText: 'Table Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Obx(() => DropdownButtonFormField<String>(
                value: controller.selectedStatus.value,
                items: ['VACANT', 'CLEANING', 'OCCUPIED']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) controller.selectedStatus.value = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
              )),
        ],
      ),
      actions: [
        CustomButton(
            text: "Cancel",
            onTap: () {
              Get.back();
            }),
        CustomButton(
            text: "Update",
            onTap: () {
              final name = controller.nameController.text.trim();
              final status = controller.selectedStatus.value;
              if (name.isNotEmpty) {
                onUpdate(name, status); // 🔹 send updated data
                Get.back();
              } else {
                Get.snackbar('Error', 'Please enter a table name');
              }
            })
      ],
    );
  }

  void showAddTableDialog({
    required Function(String name, String status) onSubmit,
  }) {
    var controller = Get.put(AdminTableController());

    Get.defaultDialog(
      title: 'Add Table',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller.nameController,
            decoration: const InputDecoration(
              labelText: 'Table Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Obx(() => DropdownButtonFormField<String>(
                value: controller.selectedStatus.value,
                items: ['VACANT', 'CLEANING', 'OCCUPIED']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) controller.selectedStatus.value = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
              )),
        ],
      ),
      actions: [
        CustomButton(
            text: "Cancel",
            onTap: () {
              Get.back();
            }),
        CustomButton(
            text: "Done",
            onTap: () {
              final name = controller.nameController.text.trim();
              final status = controller.selectedStatus.value;
              if (name.isNotEmpty) {
                onSubmit(name, status);
                Get.back();
              } else {
                Get.snackbar('Error', 'Please enter a table name');
              }
            })
      ],
    );
  }

 
  void setData() {
    controller.fetchtable();
  }
}
